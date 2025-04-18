# Environment check
ifndef XILINX_ROOT
$(error Setup script settings.sh has not been sourced, aborting)
endif

# Vivado environment
include make/environment.mk

all: ips

# Build makefile for ips and bitstream
include make/build.mk

# Clean artifacts
clean:
	rm -rf ${XILINX_IPS_ROOT}/*/*/build
	rm -rf ${XILINX_IPS_ROOT}/*.xci

.PHONY: ips clean
