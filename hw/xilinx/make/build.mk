# Environment check
ifndef XILINX_ROOT
$(error Setup script settings.sh has not been sourced, aborting)
endif

IP_BUILD_DIR=${XILINX_IPS_ROOT}/build
#XILINX_IP_LIST   = $(shell basename --multiple ${XILINX_IPS_ROOT}/xlnx_*)
IP_LIST   = $(shell basename ${XILINX_IPS_ROOT}/nvdla)

#IP_LIST = ${XILINX_IP_LIST} ${CUSTOM_IP_LIST}

all: ips

# Generate ips
IP_NAMES ?= $(addprefix ips/, $(addsuffix .xci, ${IP_LIST}))
ips: ${IP_NAMES}

# Build single IP
ips/%.xci: IP_NAME=$*
$(info ${IP_NAME})
ips/%.xci: IP_DIR=$(firstword $(shell find ${XILINX_IPS_ROOT} -name '$*'))
$(info ${IP_DIR})
ips/%.xci: IP_BUILD_DIR=${IP_DIR}/build
$(info ${IP_BUILD_DIR})

# For custom IPs, also depend on RTL wrapper
ips/%.xci: ${UNITS_ROOT}/%/top_wrapper/

ips/%.xci: ${XILINX_IPS_ROOT}/%/config.tcl
	mkdir -p ${IP_BUILD_DIR};								\
	cd	   ${IP_BUILD_DIR};									\
	export IP_DIR=${IP_DIR};								\
	export IP_PRJ_NAME=${IP_NAME}_prj;						\
	export IP_NAME=${IP_NAME};								\
	${XILINX_VIVADO_BATCH}                                   \
		-source ${XILINX_IPS_ROOT}/tcl/pre_config.tcl \
		-source ${IP_DIR}/config.tcl                         \
		-source ${XILINX_IPS_ROOT}/tcl/post_config.tcl
	touch $@