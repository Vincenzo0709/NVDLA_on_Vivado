# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description: This script prepares the simulation block design in Vivado

# New simulation project
create_project $::env(SIM_PROJECT) . -force -part $::env(XILINX_PART_NUMBER)
# update_compile_order -fileset sources_1

# Addding IP path
set_property ip_repo_paths $::env(XILINX_IPS_ROOT)/$::env(IP_NAME)/build [current_project]
update_ip_catalog

# Creating the block design
create_bd_design $::env(BD)
open_bd_design ./$::env(SIM_PROJECT).srcs/sources_1/bd/$::env(BD)/$::env(BD).bd

# # Instantiating and rearrranging IPs in block design
# nvdla IP
startgroup
create_bd_cell -type ip -vlnv user.org:user:$::env(IP_NAME)_prj:1.0 $::env(IP_NAME)_prj_0
endgroup
# AXI verifier IP
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0
endgroup
# AXI verifier IP
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1
endgroup
set_property location {0.5 -143 -163} [get_bd_cells axi_vip_0]
set_property location {2 69 -155} [get_bd_cells $::env(IP_NAME)_prj_0]
set_property location {2.5 362 -144} [get_bd_cells axi_vip_1]

# External pins
startgroup
make_bd_pins_external  [get_bd_pins axi_vip_0/aclk]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins axi_vip_0/aresetn]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins $::env(IP_NAME)_prj_0/dla_intr_o]
endgroup

# Changing some properties for the master AXI VIP (AXI VIP -> AXI-LITE slave)
set_property -dict [list CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.PROTOCOL.VALUE_SRC USER] [get_bd_cells axi_vip_0]
set_property -dict [list \
  CONFIG.ADDR_WIDTH {16} \
  CONFIG.INTERFACE_MODE {MASTER} \
  CONFIG.PROTOCOL {AXI4LITE} \
] [get_bd_cells axi_vip_0]

# Changing some properties for the slave AXI VIP (AXI master -> AXI VIP)
set_property -dict [list CONFIG.PROTOCOL.VALUE_SRC USER CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.DATA_WIDTH.VALUE_SRC USER CONFIG.ID_WIDTH.VALUE_SRC USER] [get_bd_cells axi_vip_1]
set_property -dict [list \
  CONFIG.PROTOCOL {AXI3} \
  CONFIG.ADDR_WIDTH {32} \
  CONFIG.DATA_WIDTH {64} \
  CONFIG.ID_WIDTH {8} \
  CONFIG.INTERFACE_MODE {SLAVE} \
] [get_bd_cells axi_vip_1]

# Connectong pins
connect_bd_net [get_bd_ports aclk_0] [get_bd_pins $::env(IP_NAME)_prj_0/dla_clk]
connect_bd_net [get_bd_ports aresetn_0] [get_bd_pins $::env(IP_NAME)_prj_0/dla_resetn]
connect_bd_net [get_bd_ports aclk_0] [get_bd_pins axi_vip_1/aclk]
connect_bd_net [get_bd_ports aresetn_0] [get_bd_pins axi_vip_1/aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_vip_0/M_AXI] [get_bd_intf_pins $::env(IP_NAME)_prj_0/s_axilite]
connect_bd_intf_net [get_bd_intf_pins $::env(IP_NAME)_prj_0/m_axi] [get_bd_intf_pins axi_vip_1/S_AXI]

# Automatic assignment of memory mapped addresses
assign_bd_address

# Validation of BD
validate_bd_design

# Saving
save_bd_design