// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:

module NV_axilite2CSB (
    // GLOBAL
    input logic dla_clk,
    input logic dla_reset,

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
    input logic s_axilite_bvalid,
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
typedef enum {IDLE, READ, WRITE, READ_OP, WRITE_OP} stato;
stato curr_state = IDLE;
stato next_state;

always_ff @(posedge dla_clk) begin
   if (!dla_reset) begin
      curr_state <= IDLE;
   end else begin
      next_state <= curr_state;
   end
end

always_comb begin
   case (curr_state)
      
      IDLE: begin

         if (s_axilite_arvalid) begin

            axilite2csb_addr = s_axilite_araddr;
            axilite2csb_ready = s_axilite_arready;
            axilite2cscb_write = 1'h0;

            next_state = READ;
         
         end

         else if (m_axi_awvalid) begin

            addr = s_axilite_awaddr;
            ready = s_axilite_awready;
            write = 1'h0;
            
            next_state = WRITE;
         
         end

      end

      READ: begin

         if (valid_in == 1'h0)
            valid_in = 1'h1;
         else if (ready)
            next_state = READ_OP;
         
      end

      WRITE: begin
      
         if (valid_in == 1'h0)
            valid_in = 1'h1;
         else if (ready)
            next_state = WRITE_OP;
      
      end

      READ_OP: begin

         if (valid_out && s_axilite_rready) begin

            rresp = 2'h0;
            valid_in = 1'h0;
            write = 1'h0;
            next_state = IDLE;

         end

      end

      WRITE_OP: begin

         if (s_axilite_wvalid) begin
            
            if (!s_axilite_wready)
            
               wready = 1'h1;
            
            else if (wr_complete && s_axilite_bready) begin
            
               bresp = 2'h0;
               valid_in = 1'h0;
               write = 1'h0;
            
               next_state = IDLE;
               
            end
         
         end

      end

   endcase

end

endmodule