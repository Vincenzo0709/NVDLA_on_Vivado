### Main starting
puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Starting script"
puts -nonewline "\033\[0m";
set origin_dir "."
set _xil_proj_name_ "nvdla_ip"

variable script_file
set script_file "nvdla_ip.tcl"


puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Creating project ${_xil_proj_name_}"
puts -nonewline "\033\[0m";
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xczu9eg-ffvb1156-2-e -force
set proj_dir [get_property directory [current_project]]
set_property board_part xilinx.com:zcu102:part0:3.4 [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set IP repository paths
puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Initializing ip repository"
puts -nonewline "\033\[0m";
exec mkdir ip_repo
set obj [get_filesets sources_1]
if { $obj != {} } {
   set_property "ip_repo_paths" "[file normalize "$origin_dir/ip_repo"]" $obj

   # Rebuild user ip_repo's index before adding any source files
   update_ip_catalog -rebuild
}

# Set 'sources_1' fileset object
puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Adding needed rtl files"
puts -nonewline "\033\[0m";
set obj [get_filesets sources_1]
set files ../rtl
add_files -fileset $obj $files
import_files -force
set_property top NV_nvdla_AXI [current_fileset]

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

update_compile_order -fileset sources_1
puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Starting Design Elaboration"
puts -nonewline "\033\[0m";
synth_design -rtl -name rtl_1

puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Starting IP packaging"
puts -nonewline "\033\[0m";
ipx::package_project -root_dir ./ip_repo -vendor user.org -library user -taxonomy /UserIP -import_files -set_current true
#ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory ./ip_repo ./ip_repo/component.xml
current_project nvdla_ip
set_property name NV_nvdla [ipx::current_core]
# set_property previous_version_for_upgrade user.org:user:NV_nvdla:1.0 [ipx::current_core]
# set_property core_revision 1 [ipx::current_core]
# ipx::create_xgui_files [ipx::current_core]

puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Adding AXI master bus interface"
puts -nonewline "\033\[0m";
ipx::add_bus_interface m_axi [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:aximm_rtl:1.0 [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:aximm:1.0 [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property display_name m_axi [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
ipx::add_bus_parameter NUM_READ_OUTSTANDING [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
ipx::add_bus_parameter NUM_WRITE_OUTSTANDING [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
ipx::add_port_map WLAST [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_wlast [ipx::get_port_maps WLAST -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map BREADY [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_bready [ipx::get_port_maps BREADY -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWLEN [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awlen [ipx::get_port_maps AWLEN -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWQOS [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awqos [ipx::get_port_maps AWQOS -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWREADY [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awready [ipx::get_port_maps AWREADY -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARBURST [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arburst [ipx::get_port_maps ARBURST -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWPROT [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awprot [ipx::get_port_maps AWPROT -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map RRESP [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_rresp [ipx::get_port_maps RRESP -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARPROT [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arprot [ipx::get_port_maps ARPROT -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map RVALID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_rvalid [ipx::get_port_maps RVALID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARLOCK [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arlock [ipx::get_port_maps ARLOCK -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awid [ipx::get_port_maps AWID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map RLAST [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_rlast [ipx::get_port_maps RLAST -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arid [ipx::get_port_maps ARID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWCACHE [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awcache [ipx::get_port_maps AWCACHE -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map WREADY [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_wready [ipx::get_port_maps WREADY -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map WSTRB [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_wstrb [ipx::get_port_maps WSTRB -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map BRESP [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_bresp [ipx::get_port_maps BRESP -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map BID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_bid [ipx::get_port_maps BID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWUSER [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awuser [ipx::get_port_maps AWUSER -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARLEN [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arlen [ipx::get_port_maps ARLEN -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARQOS [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arqos [ipx::get_port_maps ARQOS -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map RDATA [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_rdata [ipx::get_port_maps RDATA -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map BVALID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_bvalid [ipx::get_port_maps BVALID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARCACHE [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arcache [ipx::get_port_maps ARCACHE -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map RREADY [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_rready [ipx::get_port_maps RREADY -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWVALID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awvalid [ipx::get_port_maps AWVALID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARSIZE [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arsize [ipx::get_port_maps ARSIZE -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map WDATA [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_wdata [ipx::get_port_maps WDATA -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWSIZE [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awsize [ipx::get_port_maps AWSIZE -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map RID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_rid [ipx::get_port_maps RID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARADDR [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_araddr [ipx::get_port_maps ARADDR -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWADDR [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awaddr [ipx::get_port_maps AWADDR -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARREADY [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arread [ipx::get_port_maps ARREADY -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map WVALID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_wvalid [ipx::get_port_maps WVALID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARVALID [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_arvalid [ipx::get_port_maps ARVALID -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWLOCK [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awlock [ipx::get_port_maps AWLOCK -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map AWBURST [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_awburst [ipx::get_port_maps AWBURST -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::add_port_map ARUSER [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]
set_property physical_name m_axi_aruser [ipx::get_port_maps ARUSER -of_objects [ipx::get_bus_interfaces m_axi -of_objects [ipx::current_core]]]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]