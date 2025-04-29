`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 11:08:12 AM
// Design Name: 
// Module Name: nvdla_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import axi_vip_pkg::*;
import nvdla_axi_vip_0_0_pkg::*;
import nvdla_axi_vip_1_0_pkg::*;

module nvdla_tb();

bit aclk = 0;
bit aresetn = 1;
bit dla_intr;
bit [15:0] addr;
bit [15:0] base_addr = 16'h0000;
bit [31:0] data;
xil_axi_resp_t resp;

nvdla_wrapper UUT(
    .aclk_0 (aclk),
    .aresetn_0 (aresetn),
    .dla_intr_0 (dla_intr)
);

// Generate the clock : 50 MHz    
always #10ns aclk = ~aclk;

//////////////////////////////////////////////////////////////////////////////////
// Main Process
//////////////////////////////////////////////////////////////////////////////////
//
initial begin
    //Assert the reset
    aresetn = 0;
    #340ns
    // Release the reset
    aresetn = 1;
end
//
//////////////////////////////////////////////////////////////////////////////////
// The following part controls the AXI VIP. 
//It follows the "Usefull Coding Guidelines and Examples" section from PG267
//////////////////////////////////////////////////////////////////////////////////
//
// Step 3 - Declare the agent for the master VIP
nvdla_axi_vip_0_0_mst_t      master_agent;

//
initial begin    

    // Step 4 - Create a new agent
    master_agent = new("master vip agent",UUT.nvdla_i.axi_vip_0.inst.IF);
    
    // Step 5 - Start the agent
    master_agent.start_master();
    
    //Wait for the reset to be released
    wait (aresetn == 1'b1);
	#200ns
    
    //Send a write burst
    #500ns
    addr = 2*4096;
    data = 1;
    master_agent.AXI4LITE_WRITE_BURST(base_addr + addr, 0, data, resp);
    
    #1000ns
    master_agent.AXI4LITE_READ_BURST(base_addr + addr, 0, data, resp);

end

endmodule
