# Environment check
ifndef XILINX_ROOT
$(error Setup script settings.sh has not been sourced, aborting)
endif

# Vivado environment
include make/environment.mk

all: ips

# Build makefile for ips and bitstream
include make/build.mk

# Makefile to prepare block design for simulation and run simulation
include make/simulation.mk

# Clean artifacts
clean: clean_ips clean_sim

clean_ips:
	rm -rf $(XILINX_IPS_ROOT)/*.xci
	rm -rf $(XILINX_IPS_ROOT)/*/build

clean_sim:
	rm -rf $(XILINX_SIM_ROOT)/*/build

.PHONY: ips clean clean_ips clean_sim
