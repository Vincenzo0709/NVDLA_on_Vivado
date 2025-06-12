# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This Makefile packages the chosen NVDLA configuration.

# Environment check
ifndef NOV_XILINX_ROOT
$(error Setup script settings.sh has not been sourced, aborting)
endif

# Main target
all: ips

# IP dependencies
IP_XCI = $(addprefix ips/, $(addsuffix .xci, $(NOV_CONFIG)))

ips: $(IP_XCI)
ips/$(NOV_CONFIG).xci: IP_DIR=$(NOV_XILINX_IPS)/$(NOV_CONFIG)
ips/$(NOV_CONFIG).xci: IP_BUILD_DIR=$(IP_DIR)/build

# Wrapper dependency
ips/$(NOV_CONFIG).xci: $(NOV_UNITS_ROOT)/$(NOV_CONFIG)/wrapper/

# Synthesze IP
ips/%.xci: $(NOV_XILINX_IPS)/%/config.tcl
	mkdir -p $(IP_BUILD_DIR)
	cd	   $(IP_BUILD_DIR);									\
	export IP_DIR=$(IP_DIR);								\
	export IP_PRJ_NAME=$(NOV_CONFIG)_prj;					\
	export IP_NAME=$(NOV_CONFIG);							\
	$(XILINX_VIVADO_BATCH)                                  \
		-source $(NOV_XILINX_IPS)/tcl/pre_config.tcl 		\
		-source $(IP_DIR)/config.tcl                        \
		-source $(NOV_XILINX_IPS)/tcl/post_config.tcl
	touch $@
