IP_NAME := $(NVDLA_CONFIG)
SIM_PROJECT := $(IP_NAME)_sim_prj
BD := nvdla_sim

export IP_NAME SIM_PROJECT BD

sim: simrun

# Starting simulation
simrun: simbd $(XILINX_SIM_TCL_ROOT)/simulation.tcl
	cd $(XILINX_SIM_ROOT)/$(IP_NAME)/build; 										\
	$(XILINX_VIVADO_BATCH) 															\
		-source $(XILINX_SIM_TCL_ROOT)/simulation.tcl

# Preparing block design
simbd: $(XILINX_SIM_TCL_ROOT)/block_design.tcl
	mkdir -p $(XILINX_SIM_ROOT)/$(IP_NAME)/build;									\
	cd $(XILINX_SIM_ROOT)/$(IP_NAME)/build; 										\
	$(XILINX_VIVADO_BATCH)															\
		-source $(XILINX_SIM_TCL_ROOT)/block_design.tcl

.PHONY: sim simbd simrun