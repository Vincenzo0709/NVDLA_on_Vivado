# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This Makefile builds Vivado project, to package and simulate chosen NVDLA configuration

# Environment check
ifndef NOV_XILINX_ROOT
$(error Setup script settings.sh has not been sourced, aborting)
endif

# Vivado environment
include make/environment.mk

# Main target
all: ips

# Packaging makefile
include make/build.mk

# Makefile to prepare and run simulation
include make/simulation.mk

# Clean target
clean: clean_ips clean_sim

# Clean xilinx
clean_ips:
	rm -rf $(NOV_XILINX_IPS)/*.xci
	rm -rf $(NOV_XILINX_IPS)/*/build

# Clean simulation
clean_sim:
	rm -rf $(NOV_XILINX_SIM)/*/build
	rm -rf $(NOV_XILINX_SIM)/*/tb/reg_specification.svh
	rm -rf $(NOV_XILINX_SIM)/scripts/logs

.PHONY: ips clean clean_ips clean_sim
