// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:
//      This is the testbench for NVDLA behavioral simulation. It executes a write/read test:
//      1. Write on writable locations;
//      2. Check for AXI well-done trasaction;
//      2. Read the same location;
//      4. Compare expected value with read value.

`timescale 1ns / 1ps

// Include register specification from generated header file
`include "reg_specification.svh"

// Necessary imports for AXI VIPs
import axi_vip_pkg::*;
import nvdla_sim_axi_vip_0_0_pkg::*;
import nvdla_sim_axi_vip_1_0_pkg::*;

// Module beginning
module nvdla_tb();

// Constant variables
localparam ADDR_WIDTH = 18;
localparam DATA_WIDTH = 32;

// Interface signals declaration
bit aclk = 0;
bit aresetn = 0;
bit dla_intr;

// NVDLA Block Design istantiation
nvdla_sim_wrapper UUT(
    .aclk_0 (aclk),
    .aresetn_0 (aresetn),
    .dla_intr_o_0 (dla_intr)
);

// Generate a 50 MHz clock    
always #10ns aclk = ~aclk;

// Reset process
initial begin
    // Assertion
    aresetn = 0;
    #340ns
    // Release
    aresetn = 1;
end

// Master VIP agent
nvdla_sim_axi_vip_0_0_mst_t master_agent;

// Base CSB addres
bit [ADDR_WIDTH-1:0] base_addr = 'h00000;

// AXI VIP response packet
xil_axi_resp_t resp;

// Write data array
bit [DATA_WIDTH-1:0] wdata [0:NUM_WRITABLE_REGS-1];

// Offset address
bit [ADDR_WIDTH-1:0] addr = 0;

// Read data buffer
bit [DATA_WIDTH-1:0] rdata = 0;

// Espected result
bit [DATA_WIDTH-1:0] expctd = 0;

// Enumeration for AXI VIP response codes
enum {
    OKAY = 2'b00,       // no error
    SLVERRR = 2'b01,    // slave error
    EXOKAY = 2'b10,     // exclusive access okay (not used)
    DECERR = 2'b11      // decode error (invalid address)
} RESP_CODES;

// Main process
initial begin    

    // Master VIP Agent instantiation
    master_agent = new("master vip agent",UUT.nvdla_sim_i.axi_vip_0.inst.IF);

    // Addresses random initialization
    foreach(wdata[i]) begin
        wdata[i] = $urandom(i);
    end

    // Agent start
    master_agent.start_master();
    
    // Wait for the reset to be released, and to take effect
    wait (aresetn == 1'b1);
    #340ns

    // Write/read test
    foreach (writable_offsets[i]) begin

        addr = base_addr + writable_offsets[i];
        $display("\n[WRITE TEST] Address: 0x%h\n", addr);

        expctd = wdata[i];
        master_agent.AXI4LITE_WRITE_BURST((addr >> 2), 0, wdata[i], resp);

        // Write response code assert
        assert(resp[1:0] == RESP_CODES.first())
            else begin
                $fatal("[WRITE TEST] Write error at 0x%h.\n\t\tResponse code was: %2b, expected: %2b (OKAY)\n", addr, resp, RESP_CODES.first());
            end

        master_agent.AXI4LITE_READ_BURST((addr >> 2), 0, rdata, resp);

        // Read response code assert
        assert(resp[1:0] == RESP_CODES.first())
            else begin
                $fatal("[WRITE TEST] Read error at 0x%h.\n\t\tResponse code was: %2b, expected: %2b (OKAY)\n", addr, resp, RESP_CODES.first());
            end

        // Register expected content assert
        assert(expctd == rdata)
            else begin
                $fatal("[WRITE TEST] Mismatch at 0x%h.\n\t\tValue: 0x%h, expected: 0x%h\n", addr, rdata, expctd);
            end

        // Read value print
        $display("\t\tWritten: 0x%h, expected: 0x%h\n", rdata, expctd);

    end

end

endmodule // nvdla_tb
