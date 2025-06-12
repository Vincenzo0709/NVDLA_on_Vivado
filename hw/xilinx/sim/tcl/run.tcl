# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script runs simulation in Vivado.

open_project $::env(SIM_PROJECT)

# Start simulation
launch_simulation
run 100 us

# Open gui
start_gui
