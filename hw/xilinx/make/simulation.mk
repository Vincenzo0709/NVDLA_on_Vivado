# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This Makefile executes Vivado simulation for the chosen NVDLA configuration.

IP_NAME := $(NOV_CONFIG)
SIM_PROJECT := $(IP_NAME)_sim_prj
BD := nvdla_sim

export IP_NAME SIM_PROJECT BD

# Main target
sim: simrun

# Start simulation
simrun: simprep $(NOV_XILINX_SIM)/$(IP_NAME)/wcfg/nvdla_tb_behav.wcfg $(NOV_XILINX_SIM_TCL)/run.tcl
	cd $(NOV_XILINX_SIM)/$(IP_NAME)/build; 										\
	$(XILINX_VIVADO_BATCH)														\
		-source $(NOV_XILINX_SIM_TCL)/run.tcl

# Prepare simulation
simprep: simbd $(NOV_XILINX_SIM)/$(IP_NAME)/tb/reg_specification.svh $(NOV_XILINX_SIM_TCL)/simulation.tcl
	cd $(NOV_XILINX_SIM)/$(IP_NAME)/build; 										\
	$(XILINX_VIVADO_BATCH) 														\
		-source $(NOV_XILINX_SIM_TCL)/simulation.tcl

# Prepare block design
simbd: $(NOV_XILINX_SIM_TCL)/block_design.tcl
	mkdir -p $(NOV_XILINX_SIM)/$(IP_NAME)/build;								\
	cd $(NOV_XILINX_SIM)/$(IP_NAME)/build; 										\
	$(XILINX_VIVADO_BATCH)														\
		-source $(NOV_XILINX_SIM_TCL)/block_design.tcl

# Generate register SystemVerilog specification by script
$(NOV_XILINX_SIM)/$(IP_NAME)/tb/reg_specification.svh: $(NOV_XILINX_SIM)/scripts/reg_specification_parser.py \
														$(NOV_UNITS_ROOT)/$(IP_NAME)/spec/opendla.py
	python3 $< $(word 2, $^) $@

.PHONY: sim simbd simprep simrun
