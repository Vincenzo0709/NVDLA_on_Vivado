# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script creates a custom IP using rtl sources.

# Define the top_module name (NB: IP Name must be different from the top_module name)
set top_module NVDLA_wrapper

# Define directories
set dir_name $::env(NOV_UNITS_ROOT)/$::env(IP_NAME)
set rtl_dir_name ${dir_name}/rtl

# Define path for wrapper file
set top_module_dir ${dir_name}/wrapper
set top_module_path ${top_module_dir}/${top_module}.sv
# set top_module_path ${dir_name}/rtl/${top_module}.v

# Append in src file list
set src_file_list {}

# Read file names from RTL dir and wrapper dir into src file list
set ls_list [exec ls ${rtl_dir_name}]
set top_list [exec ls ${top_module_dir}]

foreach item $ls_list {
    lappend src_file_list ${rtl_dir_name}/$item
}

foreach item $top_list {
    lappend src_file_list ${top_module_dir}/$item
}

# Package the IP with the specified file list and top module
source $::env(NOV_XILINX_SYNTH_TCL)/package_ip.tcl
