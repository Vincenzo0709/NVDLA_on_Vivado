// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:

module NV_nvdla_AXI (
   // GLOBAL
   input logic dla_clk,
   input logic dla_resetn,

   // AXILITE to CSB
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

   //AXI master to DDR
   // AW
   output logic m_axi_awuser,
   output logic [5:0] m_axi_awid,
   output logic [48:0] m_axi_awaddr,
   output logic [7:0] m_axi_awlen,
   output logic [2:0] m_axi_awsize,
   output logic [1:0] m_axi_awburst,
   output logic m_axi_awlock,
   output logic [3:0] m_axi_awcache,
   output logic [2:0] m_axi_awprot,
   output logic m_axi_awvalid,
   input logic m_axi_awready,
   output logic [3:0] m_axi_awqos,
   // W
   output logic [63:0] m_axi_wdata,
   output logic [3:0] m_axi_wstrb,
   output logic m_axi_wlast,
   output logic m_axi_wvalid,
   input logic m_axi_wready,
   // B
   input logic [5:0] m_axi_bid,
   input logic [1:0] m_axi_bresp,
   input logic m_axi_bvalid,
   output logic m_axi_bready,
   // AR
   output logic m_axi_aruser,
   output logic [5:0] m_axi_arid,
   output logic [48:0] m_axi_araddr,
   output logic [7:0] m_axi_arlen,
   output logic [2:0] m_axi_arsize,
   output logic [1:0] m_axi_arburst,
   output logic m_axi_arlock,
   output logic [3:0] m_axi_arcache,
   output logic [2:0] m_axi_arprot,
   output logic m_axi_arvalid,
   input logic m_axi_arready,
   output logic m_axi_arqos,
   // R
   input logic [5:0] m_axi_rid,
   input logic [63:0] m_axi_rdata,
   input logic [1:0] m_axi_rresp,
   input logic m_axi_rlast,
   input logic m_axi_rvalid,
   output logic m_axi_rready,

   // interrupt
   output logic dla_intr
);

// AXI master interface to DDR /////////////////////////////////////////////////////////////////////

logic [7:0] m_axi_awid_;
assign m_axi_awid_ = {2'h0, m_axi_awid};
logic [7:0] m_axi_bid_;
assign m_axi_bid_ = {2'h0, m_axi_bid};
logic [7:0] m_axi_arid_;
assign m_axi_arid_ = {2'h0, m_axi_arid};
logic [7:0] m_axi_rid_;
assign m_axi_rid_ = {2'h0, m_axi_rid};

assign m_axi_awuser = 1'h0;
assign m_axi_awsize = 3'h6;
assign m_axi_awburst = 2'h1;
assign m_axi_awlock = 2'h0;
assign m_axi_awcache = 4'h0;
assign m_axi_awprot = 3'h0;
assign m_axi_awqos = 4'h0;
assign m_axi_aruser = 1'h0;
assign m_axi_arsize = 3'h6;
assign m_axi_arburst = 2'h1;
assign m_axi_arlock = 2'h0;
assign m_axi_arcache = 4'h0;
assign m_axi_arprot = 3'h0;
assign m_axi_arqos = 4'h0;

// AXIlite slave interface to CSB /////////////////////////////////////////////////////////////////////////////////

logic valid_in;
logic ready;
logic [15:0] addr;
logic [31:0] wdat;
logic write;
logic valid_out;
logic [31:0] data;
logic wr_complete;
logic nposted;

NV_nvdla nvdla_u (
   .dla_core_clk                             (dla_clk),
   .dla_csb_clk                              (dla_clk),
   .global_clk_ovr_on                        (1'h0),
   .tmc2slcg_disable_clock_gating            (1'h0),
   .dla_reset_rstn                           (dla_resetn),
   .direct_reset_                            (1'h0),
   .test_mode                                (1'h0),
   // AXILITE slave to CSB
   .csb2nvdla_valid                          (valid_in),
   .csb2nvdla_ready                          (ready),
   .csb2nvdla_addr                           (addr),
   .csb2nvdla_wdat                           (wdat),
   .csb2nvdla_write                          (write),
   .csb2nvdla_nposted                        (nposted),
   .nvdla2csb_valid                          (valid_out),
   .nvdla2csb_data                           (data),
   .nvdla2csb_wr_complete                    (wr_complete),
   // AXI master to DDR
   .nvdla_core2dbb_aw_awvalid                (m_axi_awvalid),
   .nvdla_core2dbb_aw_awready                (m_axi_awready),
   .nvdla_core2dbb_aw_awid                   (m_axi_awid_),
   .nvdla_core2dbb_aw_awlen                  (m_axi_awlen[3:0]),
   .nvdla_core2dbb_aw_awaddr                 (m_axi_awaddr[31:0]),
   .nvdla_core2dbb_w_wvalid                  (m_axi_wvalid),
   .nvdla_core2dbb_w_wready                  (m_axi_wready),
   .nvdla_core2dbb_w_wdata                   (m_axi_wdata),
   .nvdla_core2dbb_w_wstrb                   (m_axi_wstrb),
   .nvdla_core2dbb_w_wlast                   (m_axi_wlast),
   .nvdla_core2dbb_b_bvalid                  (m_axi_bvalid),
   .nvdla_core2dbb_b_bready                  (m_axi_bready),
   .nvdla_core2dbb_b_bid                     (m_axi_bid_),
   .nvdla_core2dbb_ar_arvalid                (m_axi_arvalid),
   .nvdla_core2dbb_ar_arready                (m_axi_arready),
   .nvdla_core2dbb_ar_arid                   (m_axi_arid_),
   .nvdla_core2dbb_ar_arlen                  (m_axi_arlen[3:0]),
   .nvdla_core2dbb_ar_araddr                 (m_axi_araddr[31:0]),
   .nvdla_core2dbb_r_rvalid                  (m_axi_rvalid),
   .nvdla_core2dbb_r_rready                  (m_axi_rready),
   .nvdla_core2dbb_r_rid                     (m_axi_rid_),
   .nvdla_core2dbb_r_rlast                   (m_axi_rlast),
   .nvdla_core2dbb_r_rdata                   (m_axi_rdata),
   // Interrupt
   .dla_intr                                 (dla_intr),
   // Power management
   .nvdla_pwrbus_ram_c_pd                    (32'h0),
   .nvdla_pwrbus_ram_ma_pd                   (32'h0),
   .nvdla_pwrbus_ram_mb_pd                   (32'h0),
   .nvdla_pwrbus_ram_p_pd                    (32'h0),
   .nvdla_pwrbus_ram_o_pd                    (32'h0),
   .nvdla_pwrbus_ram_a_pd                    (32'h0)
);

NV_axilite2CSB axilite2CSB_u (
   // GLOBAL
   .dla_clk                                  (dla_clk),
   .dla_resetn                               (dla_resetn),

   // AXILITE slave to CSB
   // AW
   .s_axilite_awaddr                         (s_axilite_awaddr),
   .s_axilite_awprot                         (s_axilite_awprot),
   .s_axilite_awvalid                        (s_axilite_awvalid),
   .s_axilite_awready                        (s_axilite_awready),
   // W
   .s_axilite_wdata                          (s_axilite_wdata),
   .s_axilite_wstrb                          (s_axilite_wstrb),
   .s_axilite_wvalid                         (s_axilite_wvalid),
   .s_axilite_wready                         (s_axilite_wready),
   // B
   .s_axilite_bresp                          (s_axilite_bresp),
   .s_axilite_bvalid                         (s_axilite_bvalid),
   .s_axilite_bready                         (s_axilite_bready),
   // AR
   .s_axilite_araddr                         (s_axilite_araddr),
   .s_axilite_arprot                         (s_axilite_arprot),
   .s_axilite_arvalid                        (s_axilite_arvalid),
   .s_axilite_arready                        (s_axilite_arready),
   // R
   .s_axilite_rdata                          (s_axilite_rdata),
   .s_axilite_rresp                          (s_axilite_rresp),
   .s_axilite_rvalid                         (s_axilite_rvalid),
   .s_axilite_rready                         (s_axilite_rready),

   // CSB interface from/to NVDLA
   .axilite2csb_valid                        (valid_in),
   .axilite2csb_ready                        (ready),
   .axilite2csb_addr                         (addr),
   .axilite2csb_wdat                         (wdat),
   .axilite2csb_write                        (write),
   .axilite2csb_nposted                      (nposted),
   .csb2axilite_valid                        (valid_out),
   .csb2axilite_data                         (data),
   .csb2axilite_wr_complete                  (wr_complete)
);

endmodule
