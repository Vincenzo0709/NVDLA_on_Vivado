# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description: create a custom IP using rtl sources

# Define the top_module name (NB: IP Name must be different from the top_module name)
set top_module NV_nvdla

# Define directories
set dir_name $::env(UNITS_ROOT)/$::env(IP_NAME)
set rtl_dir_name ${dir_name}/rtl
set nvdla_dir $::env(XILINX_ROOT)/rtl

# Define path for wrapper file
set top_module_path ${dir_name}/rtl/${top_module}.v
#${dir_name}/${top_module}.sv

# Append svh files and top module
set src_file_list {}
lappend src_file_list ${top_module_path}

# Read file names from RTL dir into src file list
set ls_list [exec ls ${rtl_dir_name}]

foreach item $ls_list {
    lappend src_file_list ${rtl_dir_name}/$item
}

# Package the IP with the specified file list and top module
source $::env(XILINX_SYNTH_TCL_ROOT)/package_ip.tcl

