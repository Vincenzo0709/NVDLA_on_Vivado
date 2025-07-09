# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This Makefile holds all targets for NVDLA_on_Vivado directory.

# Environment check
ifndef NOV_ROOT_DIR
$(error Setup script settings.sh has not been sourced, aborting)
endif

# Main targets
all: hw sw

# Hardware build
hw: xilinx

xilinx: units
	$(MAKE) -C $(NOV_XILINX_ROOT)

units:
	$(MAKE) -C $(NOV_UNITS_ROOT)

sim: 
	$(MAKE) -C $(NOV_XILINX_ROOT) sim

# Software build
sw:
	$(MAKE) -C $(NOV_SW_ROOT)

# Virtual Platform build
vp:
	$(MAKE) -C $(NOV_VP_ROOT)

# Clean targets
clean:
	$(MAKE) -C $(NOV_UNITS_ROOT) clean
	$(MAKE) -C $(NOV_XILINX_ROOT) clean
	$(MAKE) -C $(NOV_SW_ROOT) clean

clean_xilinx:
	$(MAKE) -C $(NOV_XILINX_ROOT) clean

clean_sim:
	$(MAKE) -C $(NOV_XILINX_ROOT) clean_sim

clean_sw:
	$(MAKE) -C $(NOV_SW_ROOT) clean

clean_vp:
	$(MAKE) -C $(NOV_VP_ROOT) clean

.PHONY: hw sw xilinx units sim clean clean_xilinx clean_sim clean_sw clean_vp
