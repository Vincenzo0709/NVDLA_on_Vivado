// Author: Vincenzo Merola <vincenzo.merola2@unina.it>
// Description:
//      This is the testbench for NVDLA behavioral simulation. It executes a write/read test:
//      1. Include needed 'reg_specification.svh'
//      2. Write on writable locations;
//      3. Check for AXI well-done trasaction;
//      4. Read the same location;
//      5. Compare expected value with read value.

`timescale 1ns / 1ps

// Include register specification from generated header file
`include "reg_specification.svh"

// Necessary imports for AXI VIPs
import axi_vip_pkg::*;
import nvdla_sim_axi_vip_0_0_pkg::*;
import nvdla_sim_axi_vip_1_0_pkg::*;

// Module beginning
module nvdla_tb();

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

// AXI VIP response packet
xil_axi_resp_t resp;

// Base CSB addres
bit [ADDR_WIDTH-1:0] base_addr = 'h0;

// Offset address
bit [ADDR_WIDTH-1:0] addr = 0;

// Write data array
bit [DATA_WIDTH-1:0] wdata [0:NUM_WRITABLE_REGS-1];

// Read data buffer
bit [DATA_WIDTH-1:0] rdata_buf = 0;

// Espected read/write results
bit [DATA_WIDTH-1:0] write_expctd = 0;
bit [DATA_WIDTH-1:0] read_expctd = 0;

// Read/write masks
bit [MASK_WIDTH-1:0] write_mask = 0;
bit [MASK_WIDTH-1:0] read_mask = 0;

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

    // Write test
    foreach (wdata[i]) begin

        // Address and masks (not necessarily read and write masks match)
        addr = base_addr + writable_offsets[i];
        write_mask = reg_write_map[addr].write_mask;
        read_mask = reg_write_map[addr].read_mask;
        $display("\n[WRITE TEST] Address: 0x%H, data: 0x%H, write mask: 0x%H, read mask: 0x%H",
                                            addr, wdata[i], write_mask, read_mask);

        // Expected write result
        write_expctd = wdata[i] & write_mask;

        // AXI write (we need to shift addresses as they are word-addressed internally)
        master_agent.AXI4LITE_WRITE_BURST((addr >> 2), 0, wdata[i], resp);
        $display("[WRITE TEST] Written: 0x%H, expected: 0x%H", wdata[i], write_expctd);

        // Write response code assert
        assert(resp[1:0] == RESP_CODES.first())
        else begin
            $fatal("[WRITE TEST] Write error at 0x%H.\n\tResponse code was: %2b, expected: %2b (OKAY)\n", addr, resp, RESP_CODES.first());
        end

        // Expected read result
        read_expctd = write_expctd & read_mask;

        // AXI read check
        master_agent.AXI4LITE_READ_BURST((addr >> 2), 0, rdata_buf, resp);
        $display("[WRITE TEST] Read: 0x%H, expected: 0x%H", rdata_buf, read_expctd);

        // Read response code assert
        assert(resp[1:0] == RESP_CODES.first())
        else begin
            $fatal("[WRITE TEST] Read error at 0x%H.\n\tResponse code was: %2b, expected: %2b (OKAY)\n", addr, resp, RESP_CODES.first());
        end

        // Register expected content assert
        assert(read_expctd == rdata_buf)
        else begin
            $fatal("[WRITE TEST] Mismatch at 0x%H.\n\tRead: 0x%H, expected: 0x%H\n", addr, rdata_buf, read_expctd);
        end

    end

end

endmodule // nvdla_tb
