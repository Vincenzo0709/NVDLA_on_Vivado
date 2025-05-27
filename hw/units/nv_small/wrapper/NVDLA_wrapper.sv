// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:
//    This module links up NVDLA_wrapper and csb2nvdla interface converter
//
//      ┌──────────────────────────────────────────────────────────────────────────────────────────┐      
//      │                                     NVDLA_wrapper                                        │     
//      │                                                                                          │
//      │                                                                                          │
//      │  AXI-LITE   ┌───────────────────┐         CSB          ┌───────────────────┐    AXI      │
//  ====│===========> │    axilite2csb    │ <==================> │     NV_nvdla      │ ============│====>                              │
//      │             │                   │                      │                   │             │
//      │     AW      │                   │   -----valid----->   │                   │     AW      │
//      │   =====>    │                   │   <----ready------   │                   │   =====>    │
//      │     AR      │    (AXI-LITE      │   -----wdat------>   │                   │     AR      │
//      │   =====>    │        to         │   -----addr------>   │     (NVIDIA       │   =====>    │
//      │     W       │     NVDLA CSB     │   -----write----->   │    accelerator)   │     W       │
//      │   =====>    │     interface     │   ----nposted---->   │                   │   =====>    │
//      │     R       │     converter)    │   <-----valid-----   │                   │     R       │
//      │   =====>    │                   │   <-----data------   │                   │   =====>    │
//      │     B       │                   │   <--wr_complete--   │                   │     B       │
//      │   =====>    │                   │                      │                   │   =====>    │
//      │             │                   │                      │                   │             │
//      │             └───────────────────┘                      │                   │             │
//      │                                                        │                   │             │
// <----│------------------------------------------------------- │                   │             │
//      │                   dla_intr                             └───────────────────┘             │
//      │                                                                                          │
//      └──────────────────────────────────────────────────────────────────────────────────────────┘

module NVDLA_wrapper #(

   // Parameters for signal width
   parameter AXI_ID_WIDTH = 8,
   parameter AXI_ADDR_WIDTH = 32,
   parameter AXI_LEN_WIDTH = 4,
   parameter AXI_DATA_WIDTH = 64,
   parameter AXI_STRB_WIDTH = (AXI_DATA_WIDTH / 8),
   parameter AXILITE_ADDR_WIDTH = 16,
   parameter AXILITE_DATA_WIDTH = 32,
   parameter AXILITE_PROT_WIDTH = 3,
   parameter AXILITE_STRB_WIDTH = (AXILITE_DATA_WIDTH / 8),
   parameter AXILITE_RESP_WIDTH = 2

   ) (

   // Global signals
   input logic dla_clk,
   input logic dla_resetn,

   // Interrupt signal
   output logic dla_intr_o,

   // AXI master interface signals to DDR (NVDLA -> NVDLA_wrapper -> DDR)
   // AW channel
   output logic m_axi_awvalid,
   input logic m_axi_awready,
   output logic [AXI_ID_WIDTH-1:0] m_axi_awid,
   output logic [AXI_LEN_WIDTH-1:0] m_axi_awlen,
   output logic [AXI_ADDR_WIDTH-1:0] m_axi_awaddr,
   // W channel
   output logic m_axi_wvalid,
   input logic m_axi_wready,
   output logic [AXI_DATA_WIDTH-1:0] m_axi_wdata,
   output logic [AXI_STRB_WIDTH-1:0] m_axi_wstrb,
   output logic m_axi_wlast,
   // B channel
   input logic m_axi_bvalid,
   output logic m_axi_bready,
   input logic [AXI_ID_WIDTH-1:0] m_axi_bid,
   // AR channel
   output logic m_axi_arvalid,
   input logic m_axi_arready,
   output logic [AXI_ID_WIDTH-1:0] m_axi_arid,
   output logic [AXI_LEN_WIDTH-1:0] m_axi_arlen,
   output logic [AXI_ADDR_WIDTH-1:0] m_axi_araddr,
   // R channel
   input logic m_axi_rvalid,
   output logic m_axi_rready,
   input logic [AXI_ID_WIDTH-1:0] m_axi_rid,
   input logic m_axi_rlast,
   input logic [AXI_DATA_WIDTH-1:0] m_axi_rdata,

   // AXILITE slave interface signals to NVDLA (NVDLA_wrapper -> NVDLA)
   // AW channel
   input logic s_axilite_awvalid,
   output logic s_axilite_awready,
   input logic [AXILITE_ADDR_WIDTH-1:0] s_axilite_awaddr,
   input logic [AXILITE_PROT_WIDTH-1:0] s_axilite_awprot,
   // W channel
   input logic s_axilite_wvalid,
   output logic s_axilite_wready,
   input logic [AXILITE_DATA_WIDTH-1:0] s_axilite_wdata,
   input logic [AXILITE_STRB_WIDTH-1:0] s_axilite_wstrb,
   // B channel
   output logic s_axilite_bvalid,
   input logic s_axilite_bready,
   output logic [AXILITE_RESP_WIDTH-1:0] s_axilite_bresp,
   // AR channel
   input logic s_axilite_arvalid,
   output logic s_axilite_arready,
   input logic [AXILITE_ADDR_WIDTH-1:0] s_axilite_araddr,
   input logic [AXILITE_PROT_WIDTH-1:0] s_axilite_arprot,
   // R channel
   output logic s_axilite_rvalid,
   input logic s_axilite_rready,
   output logic [AXILITE_DATA_WIDTH-1:0] s_axilite_rdata,
   output logic [AXILITE_RESP_WIDTH-1:0] s_axilite_rresp

);

// Signals connecting csb2nvdla -> NVDLA interfaces
logic m_csb_valid_o;
logic m_csb_ready;
logic [AXILITE_ADDR_WIDTH-1:0] m_csb_addr;
logic [AXILITE_DATA_WIDTH-1:0] m_csb_wdat;
logic m_csb_write;
logic m_csb_nposted;
logic m_csb_valid_i;
logic [AXILITE_DATA_WIDTH-1:0] m_csb_data;
logic m_csb_wr_complete;

// NVDLA accelerator instance
NV_nvdla nvdla_u (

   // Global signals
   .dla_core_clk                             (dla_clk),
   .dla_csb_clk                              (dla_clk),
   .global_clk_ovr_on                        (1'h0),
   .tmc2slcg_disable_clock_gating            (1'h0),
   .dla_reset_rstn                           (dla_resetn),
   .direct_reset_                            (1'h0),
   .test_mode                                (1'h0),

   // Interrupt signal
   .dla_intr                                 (dla_intr),

   // CSB NVDLA slave interface (csb2nvdla -> NVDLA)
   .csb2nvdla_valid                          (m_csb_valid_o),
   .csb2nvdla_ready                          (m_csb_ready),
   .csb2nvdla_addr                           (m_csb_addr),
   .csb2nvdla_wdat                           (m_csb_wdat),
   .csb2nvdla_write                          (m_csb_write),
   .csb2nvdla_nposted                        (m_csb_nposted),
   .nvdla2csb_valid                          (m_csb_valid_i),
   .nvdla2csb_data                           (m_csb_data),
   .nvdla2csb_wr_complete                    (m_csb_wr_complete),

   // AXI master NVDLA interface to DDR (NVDLA -> NVDLA_wrapper -> DDR)
   .nvdla_core2dbb_aw_awvalid                (m_axi_awvalid),
   .nvdla_core2dbb_aw_awready                (m_axi_awready),
   .nvdla_core2dbb_aw_awid                   (m_axi_awid),
   .nvdla_core2dbb_aw_awlen                  (m_axi_awlen),
   .nvdla_core2dbb_aw_awaddr                 (m_axi_awaddr),
   .nvdla_core2dbb_w_wvalid                  (m_axi_wvalid),
   .nvdla_core2dbb_w_wready                  (m_axi_wready),
   .nvdla_core2dbb_w_wdata                   (m_axi_wdata),
   .nvdla_core2dbb_w_wstrb                   (m_axi_wstrb),
   .nvdla_core2dbb_w_wlast                   (m_axi_wlast),
   .nvdla_core2dbb_b_bvalid                  (m_axi_bvalid),
   .nvdla_core2dbb_b_bready                  (m_axi_bready),
   .nvdla_core2dbb_b_bid                     (m_axi_bid),
   .nvdla_core2dbb_ar_arvalid                (m_axi_arvalid),
   .nvdla_core2dbb_ar_arready                (m_axi_arready),
   .nvdla_core2dbb_ar_arid                   (m_axi_arid),
   .nvdla_core2dbb_ar_arlen                  (m_axi_arlen),
   .nvdla_core2dbb_ar_araddr                 (m_axi_araddr),
   .nvdla_core2dbb_r_rvalid                  (m_axi_rvalid),
   .nvdla_core2dbb_r_rready                  (m_axi_rready),
   .nvdla_core2dbb_r_rid                     (m_axi_rid),
   .nvdla_core2dbb_r_rlast                   (m_axi_rlast),
   .nvdla_core2dbb_r_rdata                   (m_axi_rdata),
   
   // Power management
   .nvdla_pwrbus_ram_c_pd                    (32'h0),
   .nvdla_pwrbus_ram_ma_pd                   (32'h0),
   .nvdla_pwrbus_ram_mb_pd                   (32'h0),
   .nvdla_pwrbus_ram_p_pd                    (32'h0),
   .nvdla_pwrbus_ram_o_pd                    (32'h0),
   .nvdla_pwrbus_ram_a_pd                    (32'h0)
);

// Interface adapter from AXI-LITE TO CSB
axilite2csb #(

   // Parameters for signal width
   .DATA_WIDTH                               (AXILITE_DATA_WIDTH),
   .ADDR_WIDTH                               (AXILITE_ADDR_WIDTH),
   .PROT_WIDTH                               (AXILITE_PROT_WIDTH),
   .STRB_WIDTH                               (AXILITE_STRB_WIDTH),
   .RESP_WIDTH                               (AXILITE_RESP_WIDTH)

) axilite2csb_u (

   // Global signals
   .dla_clk                                (dla_clk),
   .dla_resetn                             (dla_resetn),

   // Interrupt signal doesn't pass-through this adapter

   // AXILITE slave interface to NVDLA (NVDLA_wrapper -> csb2nvdla)
   // AW
   .s_axilite_awvalid                        (s_axilite_awvalid),
   .s_axilite_awready                        (s_axilite_awready),
   .s_axilite_awaddr                         (s_axilite_awaddr),
   .s_axilite_awprot                         (s_axilite_awprot),
   // W
   .s_axilite_wvalid                         (s_axilite_wvalid),
   .s_axilite_wready                         (s_axilite_wready),
   .s_axilite_wdata                          (s_axilite_wdata),
   .s_axilite_wstrb                          (s_axilite_wstrb),
   // B
   .s_axilite_bvalid                         (s_axilite_bvalid),
   .s_axilite_bready                         (s_axilite_bready),
   .s_axilite_bresp                          (s_axilite_bresp),
   // AR
   .s_axilite_arvalid                        (s_axilite_arvalid),
   .s_axilite_arready                        (s_axilite_arready),
   .s_axilite_araddr                         (s_axilite_araddr),
   .s_axilite_arprot                         (s_axilite_arprot),
   // R
   .s_axilite_rvalid                         (s_axilite_rvalid),
   .s_axilite_rready                         (s_axilite_rready),
   .s_axilite_rdata                          (s_axilite_rdata),
   .s_axilite_rresp                          (s_axilite_rresp),

   // NVDLA CSB slave interface to NVDLA (csb2nvdla -> NVDLA)
   .m_csb_valid_o                            (m_csb_valid_o),
   .m_csb_ready_i                            (m_csb_ready),
   .m_csb_addr_o                             (m_csb_addr),
   .m_csb_wdat_o                             (m_csb_wdat),
   .m_csb_write_o                            (m_csb_write),
   .m_csb_nposted_o                          (m_csb_nposted),
   .m_csb_valid_i                            (m_csb_valid_i),
   .m_csb_data_i                             (m_csb_data),
   .m_csb_wr_complete_i                      (m_csb_wr_complete)

);

endmodule
