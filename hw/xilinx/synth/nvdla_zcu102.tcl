# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

#RED "\033\[1;31m"
#GREEN "\033\[1;32m"
#YELLOW "\033\[1;33m"
#NC "\033\[0m"

### Main starting
puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Starting script"
puts -nonewline "\033\[0m";
set origin_dir "."
set _xil_proj_name_ "nvdla_zcu102"

variable script_file
set script_file "nvdla_zcu102.tcl"

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Creating project ${_xil_proj_name_}"
puts -nonewline "\033\[0m";
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xczu9eg-ffvb1156-2-e
set proj_dir [get_property directory [current_project]]
set_property board_part xilinx.com:zcu102:part0:3.4 [current_project]

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

# Creating Block Design
puts -nonewline "\033\[1;33m"; 
puts "\[NVDLA_IP\] Initializing ip repository"
puts -nonewline "\033\[0m";
create_bd_design "nvdla_zcu102"
update_compile_order -fileset sources_1