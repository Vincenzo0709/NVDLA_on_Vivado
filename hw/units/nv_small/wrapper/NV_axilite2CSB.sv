// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:

module NV_axilite2CSB (
    // GLOBAL
    input logic dla_clk,
    input logic dla_resetn,

    // AXILITE slave to CSB
    // AW
    input logic [15:0] s_axilite_awaddr,
    input logic [2:0] s_axilite_awprot,
    input logic s_axilite_awvalid,
    output logic s_axilite_awready,
    // W
    input logic [31:0] s_axilite_wdata,
    input logic [3:0] s_axilite_wstrb,
    input logic s_axilite_wvalid,
    output logic s_axilite_wready,
    // B
    output logic [1:0] s_axilite_bresp,
    output logic s_axilite_bvalid,
    input logic s_axilite_bready,
    // AR
    input logic [15:0] s_axilite_araddr,
    input logic [2:0] s_axilite_arprot,
    input logic s_axilite_arvalid,
    output logic s_axilite_arready,
    // R
    output logic [31:0] s_axilite_rdata,
    output logic [1:0] s_axilite_rresp,
    output logic s_axilite_rvalid,
    input logic s_axilite_rready,

    // CSB interface from/to NVDLA
    output logic axilite2csb_valid,
    input logic axilite2csb_ready,
    output logic [15:0] axilite2csb_addr,
    output logic [31:0] axilite2csb_wdat,
    output logic axilite2csb_write,
    output logic axilite2csb_nposted,
    input logic csb2axilite_valid,
    input logic [31:0] csb2axilite_data,
    input logic csb2axilite_wr_complete
);

// FSM for CSB protocol
typedef enum {IDLE, READ_REQ, WRITE_REQ, READ_RESP, WRITE_RESP} stato;
stato curr_state = IDLE;
stato next_state;

// Read data protocol: when nvdla valid is asserted, it means data is available
assign s_axilite_rvalid = csb2axilite_valid;
assign s_axilite_rdata = csb2axilite_data;

// Write data protocol: when master valid is asserted, it means write data is available
assign axilite2csb_wdat = s_axilite_wdata;

// Write response protocol: when nvdla wr_complete (bvalid) is asserted, it means write is over
assign s_axilite_bvalid = csb2axilite_wr_complete;

// N posted signal must be 1
assign axilite2csb_nposted = 1'h1;

/* Pending futile signals
- s_axilite_awprot
- s_axilite_wstrb
*/

always_ff @(posedge dla_clk) begin

   if (!dla_resetn) begin

      curr_state <= IDLE;

   end else begin

      curr_state <= next_state;

   end

end

always_comb begin

   case (curr_state)
      
      IDLE: begin

         s_axilite_arready = 1'h1;
         s_axilite_awready = 1'h1;
         s_axilite_wready = 1'h1;

         if (s_axilite_arvalid) begin

            axilite2csb_addr = s_axilite_araddr;               // araddr ------> addr
            axilite2csb_valid = s_axilite_arvalid;             // arvalid ------> valid
            s_axilite_arready = axilite2csb_ready;             // arready <------ ready
            axilite2csb_write = 1'h0;                          // request is read

            next_state = READ_REQ;
         
         end

         else if (s_axilite_awvalid) begin

            axilite2csb_addr = s_axilite_awaddr;               // awaddr ------> addr
            axilite2csb_valid = s_axilite_awvalid;             // awvalid ------> valid
            s_axilite_awready = axilite2csb_ready;             // awready <------ ready
            axilite2csb_write = 1'h1;                          // request is write
            
            next_state = WRITE_REQ;
         
         end

      end

      READ_REQ: begin

         if (s_axilite_arvalid && axilite2csb_ready) begin

            next_state = READ_RESP;

         end
         
      end

      WRITE_REQ: begin
      
         if (s_axilite_awvalid && axilite2csb_ready) begin
            
            if (s_axilite_wvalid) begin

               s_axilite_wready = 1'h1;
               next_state = WRITE_RESP;

            end

         end

      end

      READ_RESP: begin

         if (csb2axilite_valid && s_axilite_rready) begin
            
               next_state = IDLE;

               s_axilite_arready = 1'h1;

         end

      end

      WRITE_RESP: begin
            
         if (csb2axilite_wr_complete && s_axilite_bready) begin
            
               s_axilite_bresp = 2'h0;
               next_state = IDLE;

               axilite2csb_write = 1'h0;
               s_axilite_awready = 1'h1;
               s_axilite_wready = 1'h1;
               
         end

      end

   endcase

end

endmodule