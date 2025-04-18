# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#    Hold all the environment variables for Xilinx tools.

# Basic variables for Vivado
XILINX_VIVADO_CMD ?= vivado
XILINX_VIVADO_MODE ?= batch
# Build directory
XILINX_PROJECT_BUILD_DIR ?= ${HW_XILINX_ROOT}/build
# Vivado's compilation reports directory
XILINX_PROJECT_REPORTS_DIR ?= ${XILINX_PROJECT_BUILD_DIR}/reports
# Hardware server
XILINX_HW_SERVER ?= hw_server

# List of the Xilinx IPs to build and import in the design
XILINX_IP_LIST   = $(shell basename --multiple ${XILINX_IPS_DIR}/xlnx_*)

# List of the Custom IPs to build and import in the design
CUSTOM_IP_LIST   = $(shell basename ${XILINX_IPS_DIR}/nvdla)

# List of IPs' xci files
XILINX_IP_LIST_XCI   := $(foreach ip,${XILINX_IP_LIST},${XILINX_IPS_DIR}/common/${ip}/build/${ip}_prj.srcs/sources_1/ip/${ip}/${ip}.xci)
CUSTOM_IP_LIST_XCI   := $(foreach ip,${CUSTOM_IP_LIST},${XILINX_IPS_DIR}/common/${ip}/build/${ip}_prj.srcs/sources_1/ip/${ip}/${ip}.xci)

# Concatenate/create the final IP lists
IP_LIST     = ${XILINX_IP_LIST} ${CUSTOM_IP_LIST}
IP_LIST_XCI = ${XILINX_IP_LIST_XCI} ${CUSTOM_IP_LIST_XCI}

#########################
# Vivado run strategies #
#########################
# Vivado defaults
# SYNTH_STRATEGY    ?= "Vivado Synthesis Defaults"
# IMPL_STRATEGY     ?= "Vivado Implementation Defaults"
# Runtime optimized  (shorter runtime)
# SYNTH_STRATEGY    ?= Flow_RuntimeOptimized
# IMPL_STRATEGY     ?= Flow_RuntimeOptimized
# High-performace (longer runtime)
SYNTH_STRATEGY     ?= "Flow_PerfOptimized_high"
IMPL_STRATEGY      ?= "Performance_ExtraTimingOpt"

# Implementation artifacts
XILINX_BITSTREAM ?= ${XILINX_PROJECT_BUILD_DIR}/${XILINX_PROJECT_NAME}.runs/impl_1/${XILINX_PROJECT_NAME}.bit
XILINX_PROBE_LTX ?= ${XILINX_PROJECT_BUILD_DIR}/${XILINX_PROJECT_NAME}.runs/impl_1/${XILINX_PROJECT_NAME}.ltx

# Whether to use ILA probes (0|1)
XILINX_ILA ?= 0

# Full environment variables list for Vivado
XILINX_VIVADO_ENV ?=                                \
    XILINX_ILA=${XILINX_ILA}                        \
    SYNTH_STRATEGY=${SYNTH_STRATEGY}                \
    IMPL_STRATEGY=${IMPL_STRATEGY}                  \
    XILINX_PART_NUMBER=${XILINX_PART_NUMBER}        \
    XILINX_PROJECT_NAME=${XILINX_PROJECT_NAME}      \
    SOC_CONFIG=${SOC_CONFIG}                        \
    XILINX_BOARD_PART=${XILINX_BOARD_PART}          \
    XILINX_HW_SERVER_HOST=${XILINX_HW_SERVER_HOST}  \
    XILINX_HW_SERVER_PORT=${XILINX_HW_SERVER_PORT}  \
    XILINX_FPGA_DEVICE=${XILINX_FPGA_DEVICE}        \
    XILINX_BITSTREAM=${XILINX_BITSTREAM}            \
    XILINX_PROBE_LTX=${XILINX_PROBE_LTX}            \
    IP_LIST_XCI="${IP_LIST_XCI}"                    \
    XILINX_ROOT=${XILINX_ROOT}                      \
    QUESTA_PATH=${QUESTA_PATH}                      \
    GCC_PATH=${GCC_PATH}                            \
    XILINX_SIMLIB_PATH=${XILINX_SIMLIB_PATH}

# Package Vivado command in a single variable
XILINX_VIVADO := ${XILINX_VIVADO_ENV} ${XILINX_VIVADO_CMD} -mode ${XILINX_VIVADO_MODE}
XILINX_VIVADO_BATCH := ${XILINX_VIVADO_ENV} ${XILINX_VIVADO_CMD} -mode batch
