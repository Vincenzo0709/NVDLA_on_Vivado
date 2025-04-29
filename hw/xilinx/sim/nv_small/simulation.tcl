open_project nv_small_prj.xpr
update_compile_order -fileset sources_1
create_bd_design nvdla
open_bd_design {/home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.srcs/sources_1/bd/nvdla/nvdla.bd}

startgroup
create_bd_cell -type ip -vlnv user.org:user:nv_small_prj:1.0 nv_small_prj_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1
endgroup
set_property location {0.5 -143 -163} [get_bd_cells axi_vip_0]
set_property location {2 69 -155} [get_bd_cells nv_small_prj_0]
set_property location {2.5 362 -144} [get_bd_cells axi_vip_1]
startgroup
make_bd_pins_external  [get_bd_pins nv_small_prj_0/dla_intr]
endgroup

set_property -dict [list CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.PROTOCOL.VALUE_SRC USER] [get_bd_cells axi_vip_0]
set_property -dict [list \
  CONFIG.ADDR_WIDTH {16} \
  CONFIG.INTERFACE_MODE {MASTER} \
  CONFIG.PROTOCOL {AXI4LITE} \
] [get_bd_cells axi_vip_0]
startgroup
make_bd_pins_external  [get_bd_pins axi_vip_0/aclk]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins axi_vip_0/aresetn]
endgroup
set_property -dict [list CONFIG.ADDR_WIDTH.VALUE_SRC USER CONFIG.DATA_WIDTH.VALUE_SRC USER CONFIG.ID_WIDTH.VALUE_SRC USER] [get_bd_cells axi_vip_1]

set_property -dict [list \
  CONFIG.ADDR_WIDTH {49} \
  CONFIG.DATA_WIDTH {64} \
  CONFIG.ID_WIDTH {6} \
  CONFIG.INTERFACE_MODE {SLAVE} \
] [get_bd_cells axi_vip_1]
connect_bd_net [get_bd_ports aclk_0] [get_bd_pins nv_small_prj_0/dla_clk]
connect_bd_net [get_bd_ports aresetn_0] [get_bd_pins nv_small_prj_0/dla_resetn]
connect_bd_net [get_bd_ports aclk_0] [get_bd_pins axi_vip_1/aclk]
connect_bd_net [get_bd_ports aresetn_0] [get_bd_pins axi_vip_1/aresetn]
connect_bd_intf_net [get_bd_intf_pins axi_vip_0/M_AXI] [get_bd_intf_pins nv_small_prj_0/s_axilite]
connect_bd_intf_net [get_bd_intf_pins nv_small_prj_0/m_axi] [get_bd_intf_pins axi_vip_1/S_AXI]
assign_bd_address

validate_bd_design
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse -scan_for_includes /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/sim/nv_small/nvdla_tb.sv
import_files -fileset sim_1 -norecurse /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/sim/nv_small/nvdla_tb.sv
update_compile_order -fileset sim_1
set_property synth_checkpoint_mode None [get_files  /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.srcs/sources_1/bd/nvdla/nvdla.bd]
generate_target all [get_files  /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.srcs/sources_1/bd/nvdla/nvdla.bd]

export_ip_user_files -of_objects [get_files /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.srcs/sources_1/bd/nvdla/nvdla.bd] -no_script -sync -force -quiet
export_simulation -of_objects [get_files /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.srcs/sources_1/bd/nvdla/nvdla.bd] -directory /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.ip_user_files/sim_scripts -ip_user_files_dir /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.ip_user_files -ipstatic_source_dir /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.cache/compile_simlib/modelsim} {questa=/home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.cache/compile_simlib/questa} {xcelium=/home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.cache/compile_simlib/xcelium} {vcs=/home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.cache/compile_simlib/vcs} {riviera=/home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
add_files -norecurse -scan_for_includes /home/vincenzo/Desktop/Progetti/NVDLA_on_Vivado/hw/xilinx/ips/nv_small/build/nv_small_prj.gen/sources_1/bd/nvdla/hdl/nvdla_wrapper.v
update_compile_order -fileset sources_1
set_property top nvdla_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1
set_property -name {xsim.compile.xvlog.more_options} -value {-d SYNTHESIS=1} -objects [get_filesets sim_1]
launch_simulation