# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script initializes Vivado project.

# Create Vivado project
create_project $::env(IP_PRJ_NAME) . -force -part $::env(NOV_XILINX_PART_NUMBER)
set_property board_part $::env(NOV_XILINX_BOARD_PART) [current_project]
