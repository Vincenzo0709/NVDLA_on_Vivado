# Environment check
ifndef XILINX_ROOT
$(error Setup script settings.sh has not been sourced, aborting)
endif

IP_LIST=$(NVDLA_CONFIG)

all: ips

# Generate ips
IP_XCI = $(addprefix ips/, $(addsuffix .xci, $(IP_LIST)))
ips: $(IP_XCI)

# Build the IP
ips/$(NVDLA_CONFIG).xci: IP_NAME=$(NVDLA_CONFIG)
ips/$(NVDLA_CONFIG).xci: IP_DIR=$(XILINX_IPS_ROOT)/$(NVDLA_CONFIG)
ips/$(NVDLA_CONFIG).xci: IP_BUILD_DIR=$(IP_DIR)/build

# Dependency on top module
ips/$(NVDLA_CONFIG).xci: $(UNITS_ROOT)/$(NVDLA_CONFIG)/wrapper/

# Synthesis for the IP
ips/%.xci: $(XILINX_IPS_ROOT)/%/config.tcl
	mkdir -p $(IP_BUILD_DIR);								\
	cd	   $(IP_BUILD_DIR);									\
	export IP_DIR=$(IP_DIR);								\
	export IP_PRJ_NAME=$(IP_NAME)_prj;						\
	export IP_NAME=$(IP_NAME);								\
	$(XILINX_VIVADO_BATCH)                                  \
		-source $(XILINX_IPS_ROOT)/tcl/pre_config.tcl 		\
		-source $(IP_DIR)/config.tcl                        \
		-source $(XILINX_IPS_ROOT)/tcl/post_config.tcl
		
	touch $@