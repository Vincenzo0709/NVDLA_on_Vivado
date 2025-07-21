# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script prepares simulation properties in Vivado.

open_project $::env(SIM_PROJECT)

# Add all sources in sources_1 fileset in sim_1 fileset
set_property SOURCE_SET sources_1 [get_filesets sim_1]

# Add the testbench
add_files -fileset sim_1 -norecurse -scan_for_includes $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/tb/nvdla_tb.sv
update_compile_order -fileset sim_1

# Update generated files for block design
set_property synth_checkpoint_mode None [get_files $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).srcs/sources_1/bd/$::env(BD)/$::env(BD).bd]
generate_target all [get_files $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).srcs/sources_1/bd/$::env(BD)/$::env(BD).bd]
export_ip_user_files -of_objects [get_files $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).srcs/sources_1/bd/$::env(BD)/$::env(BD).bd] -no_script -sync -force -quiet
export_simulation -of_objects [get_files $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).srcs/sources_1/bd/$::env(BD)/$::env(BD).bd] -directory $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).ip_user_files/sim_scripts -ip_user_files_dir $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).ip_user_files -ipstatic_source_dir $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).ip_user_files/ipstatic -lib_map_path [list {modelsim=$::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).cache/compile_simlib/modelsim} {questa=$::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).cache/compile_simlib/questa} {xcelium=$::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).cache/compile_simlib/xcelium} {vcs=$::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).cache/compile_simlib/vcs} {riviera=$::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet

# Add the bd wrapper to simulation sources
add_files -fileset sim_1 -norecurse -scan_for_includes $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).gen/sources_1/bd/$::env(BD)/hdl/$::env(BD)_wrapper.v
# Add needed packages to simulation sources
add_files -fileset sim_1 -scan_for_includes $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).gen/sources_1/bd/$::env(BD)/ip/$::env(BD)_axi_vip_0_0/
add_files -fileset sim_1 -scan_for_includes $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/build/$::env(SIM_PROJECT).gen/sources_1/bd/$::env(BD)/ip/$::env(BD)_axi_vip_1_0/
update_compile_order -fileset sim_1

# Set the simulation top module
set_property top nvdla_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

# Add SYNTHESIS macro
set_property -name {xsim.compile.xvlog.more_options} -value {-d SYNTHESIS=1} -objects [get_filesets sim_1]

# Add wave configuration
add_files -fileset sim_1 -norecurse $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/wcfg/nvdla_tb_behav.wcfg
set_property xsim.view $::env(NOV_XILINX_SIM)/$::env(IP_NAME)/wcfg/nvdla_tb_behav.wcfg [get_filesets sim_1]
