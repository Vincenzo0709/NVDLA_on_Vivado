// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:
//    This module wraps an FSM that converts standard slave AXI-LITE interface to NVDLA CSB interface

module axilite2csb #(

   // Parameters
   parameter DATA_WIDTH = 32,
   parameter ADDR_WIDTH = 16,
   parameter PROT_WIDTH = 3,
   parameter STRB_WIDTH = 4,
   parameter RESP_WIDTH = 2

   ) (

   // Global signals
   input logic dla_clk,
   input logic dla_resetn,

   // Interrupt signal doesn't pass-through this adapter

   // AXI-LITE slave interface (NVDLA_wrapper -> axilite2csb)
   // AW
   input logic s_axilite_awvalid,
   output logic s_axilite_awready,
   input logic [ADDR_WIDTH-1:0] s_axilite_awaddr,
   input logic [PROT_WIDTH-1:0] s_axilite_awprot,
   // W
   input logic s_axilite_wvalid,
   output logic s_axilite_wready,
   input logic [DATA_WIDTH-1:0] s_axilite_wdata,
   input logic [STRB_WIDTH-1:0] s_axilite_wstrb,
   // B
   output logic s_axilite_bvalid,
   input logic s_axilite_bready,
   output logic [RESP_WIDTH-1:0] s_axilite_bresp,
   // AR
   input logic s_axilite_arvalid,
   output logic s_axilite_arready,
   input logic [ADDR_WIDTH-1:0] s_axilite_araddr,
   input logic [PROT_WIDTH-1:0] s_axilite_arprot,
   // R
   output logic s_axilite_rvalid,
   input logic s_axilite_rready,
   output logic [DATA_WIDTH-1:0] s_axilite_rdata,
   output logic [RESP_WIDTH-1:0] s_axilite_rresp,

   // CSB master interface to NVDLA (csb2nvdla -> CSB -> NVDLA)
   output logic m_csb_valid_o,
   input logic m_csb_ready_i,
   output logic [ADDR_WIDTH-1:0] m_csb_addr_o,
   output logic [DATA_WIDTH-1:0] m_csb_wdat_o,
   output logic m_csb_write_o,
   output logic m_csb_nposted_o,
   input logic m_csb_valid_i,
   input logic [DATA_WIDTH-1:0] m_csb_data_i,
   input logic m_csb_wr_complete_i

);

// FSM for CSB protocol
typedef enum {
   IDLE,          // reset state
   READ_REQ,      // read request is managed
   WRITE_REQ,     // write request is managed
   READ_COMP,     // read is completed
   WRITE_COMP,    // write is completed
   READ_RESP,     // read response is sent
   WRITE_RESP     // write response is sent
} state_t;

state_t curr_state = IDLE;
state_t next_state;

/* Pending input signals
- s_axilite_awprot
- s_axilite_arprot
- s_axilite_wstrb
*/

// According to AXI write protocol, address is valid only during address write handshake
// so FSM needs to store that value, at the beginning of WRITE_REQ state, in order to
// send it after, when wvalid and wready are asserted and write packet is formed.
//                            __________
// dla_clk ----------------> |          |
// we ---------------------> |          |
//                           | addr_reg | -------> m_csb_addr_o
// s_axilite_awaddr -------> |          |
//                           |__________|
//

logic we_r;
logic we_w;
logic [ADDR_WIDTH-1:0] addr_reg;
assign m_csb_addr_o = addr_reg;

// Address register (addr_reg) synchronous assignment block
always_ff @(posedge dla_clk or negedge dla_resetn) begin

   if (!dla_resetn) begin

      addr_reg <= 'h0;

   end else begin

      if (we_w)

         addr_reg <= s_axilite_awaddr;
      
      else if (we_r)

         addr_reg <= s_axilite_araddr;

   end

end

// Sequential block
always_ff @(posedge dla_clk or negedge dla_resetn) begin

   if (!dla_resetn) begin

      curr_state <= IDLE;

   end else begin

      curr_state <= next_state;

   end

end

// Combinatorial block
always_comb begin

   // Default AXI output signals (all zeroed as in reset state)
   s_axilite_awready = 1'h0;
   s_axilite_wready = 1'h0;
   s_axilite_bresp = 'h0;
   s_axilite_bvalid = 1'h0;
   s_axilite_arready = 1'h0;
   s_axilite_rdata = 'h0;
   s_axilite_rresp = 'h0;
   s_axilite_rvalid = 1'h0;

   // Default CSB output signals (all zeroed as in reset state) except m_csb_addr_o
   // which is permanently associated to addr_reg and must not be set to avoid conflicts
   m_csb_valid_o = 1'h0;
   m_csb_wdat_o = 'h0;
   m_csb_write_o = 1'h0;
   m_csb_nposted_o = 1'h0;


   // Address enable signals to multiplex awaddr and araddr towards addr_reg
   we_w = 1'h0;
   we_r = 1'h0;

   // FSM definition
   case (curr_state)
      
      // Reset state, it switches when a request arrives
      IDLE: begin

         // Read request can start only if:
         //    - master has a request (arvalid)
         //    - NVDLA is prepared to accept it (ready_i)
         if (s_axilite_arvalid && m_csb_ready_i) begin

            // AXI-LITE read address protocol:
            //    slave asserts arready when arvalid = 1
            //    to signal it can accept the request address,
            //    then he deasserts it during the following clock cycle
            s_axilite_arready = 1'h1;

            // Master araddr is stored in reg_addr
            we_r = 1'h1;

            next_state = READ_REQ;
         
         end

         // Write request can start only if:
         //    - master has a request (awvalid)
         //    - NVDLA is prepared to accept it (ready_i)
         else if (s_axilite_awvalid && m_csb_ready_i) begin
            
            // AXI-LITE write address protocol: 
            //    slave asserts awready when awvalid = 1
            //    to signal it can accept the request address,
            //    then he deasserts it during the following clock cycle
            s_axilite_awready = 1'h1;

            // Master awaddr is stored in reg_addr
            we_w = 1'h1;

            next_state = WRITE_REQ;
         
         end

      end // IDLE

      // The following 4 signals must have the correct value when valid_o is asserted,
      // otherwise NVDLA would not store the right write request packet in its write requests fifo
      //    - nposted (= 1 for writes, = 0 for reads)
      //    - write (= 1 for writes, = 0 for reads)
      //    - wdat (data to be written, not importanto for reads)
      //    - addr (managed through addr_reg)

      // Read request is accepted and can be managed
      READ_REQ: begin

         // CSB read protocol:
         //    master asserts valid to start request to NVDLA,
         //    then he deasserts it during the following clock cycle
         m_csb_valid_o = 1'h1;

         next_state = READ_COMP;
         
      end

      // Write request is accepted and can be managed
      WRITE_REQ: begin

            // CSB write protocol:
            //    nposted = 1 means NVDLA must send write completion,
            //    then is deasserted during the following clock cycle
            m_csb_nposted_o = 1'h1;

            // CSB write protocol
            //    write = 1 means a write request
            m_csb_write_o = 1'h1;

            // Master wdata signal is passed-through to NVDLA
            m_csb_wdat_o = s_axilite_wdata;                                   // wdata --------> wdat
      
         // When master asserts wvalid, write operation can start
         if (s_axilite_wvalid) begin

            // AXI-LITE write data protocol:
            //    slave asserts wready if wvalid is high to start write operation,
            //    then he deasserts it during the following clock cycle.
            s_axilite_wready = 1'h1;

            // CSB write protocol: 
            //    master asserts valid to start write request to NVDLA
            m_csb_valid_o = 1'h1;

            next_state = WRITE_COMP;

         end

      end // WRITE_REQ

      // Read operation is completed
      READ_COMP: begin

         // Read operation can start if:
         //    - master is waiting for data (rready)
         //    - NVDLA provides the data (valid_i)
         if (s_axilite_rready && m_csb_valid_i) begin

            // NVDLA read data is passed-through to master
            s_axilite_rdata = m_csb_data_i;                                   // rdata <------- data

            // Read data protocol: 
            //    slave asserts valid to signal read data is available,
            //    then he deasserts it during the following clock cycle
            s_axilite_rvalid = 1'h1;
      
            next_state = READ_RESP;

         end

      end // READ_COMP

      // Write operation is completed
      WRITE_COMP: begin

         // When NVDLA asserts wr_complete, it means write operation has completed
         if (m_csb_wr_complete_i) begin

            // AXI-LITE write response protocol: 
            //    slave asserts bvalid to start write response handshake
            s_axilite_bvalid = 1'h1;

            next_state = WRITE_RESP;
            
         end

      end // WRITE_COMP

      // After read occurred, the AXI-LITE slave sends the response
      WRITE_RESP: begin

         // AXI-LITE write response protocol:
         //    if bready is high response handshake is done, response is sent
         //    bresp = 00 (OKAY) by default
         if (s_axilite_bready) begin
            
            next_state = IDLE;

         end

      end // WRITE_RESP

      // After read occurred, the AXI-LITE slave sends the response
      READ_RESP: begin

         // AXI-LITE read data protocol:
         //    during read_data hanshake slave sends rresp
         //    rresp = 00 (OKAY) by default
            
         next_state = IDLE;

      end

      default: next_state = IDLE;

   endcase // FSM definition

end // Combinatorial block

endmodule // axilite2csb module