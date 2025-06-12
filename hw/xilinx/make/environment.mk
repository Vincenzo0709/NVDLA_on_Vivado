# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This Makefile holds all the environment variables for Xilinx tools.

# Basic variables for Vivado
XILINX_VIVADO_CMD ?= vivado
XILINX_VIVADO_MODE ?= batch

# Hardware server
XILINX_HW_SERVER ?= hw_server

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

# Full environment variables list for Vivado
XILINX_VIVADO_ENV ?=                                            \
    SYNTH_STRATEGY=$(SYNTH_STRATEGY)                            \
    IMPL_STRATEGY=$(IMPL_STRATEGY)                              \
    NOV_XILINX_PART_NUMBER=$(NOV_XILINX_PART_NUMBER)            \
    NOV_XILINX_BOARD_PART=$(NOV_XILINX_BOARD_PART)              \
    NOV_XILINX_HW_SERVER_HOST=$(NOV_XILINX_HW_SERVER_HOST)      \
    NOV_XILINX_HW_SERVER_PORT=$(NOV_XILINX_HW_SERVER_PORT)      \
    NOV_XILINX_ROOT=$(NOV_XILINX_ROOT)                          \

# Package Vivado command in a single variable
XILINX_VIVADO := $(XILINX_VIVADO_ENV) $(XILINX_VIVADO_CMD) -mode $(XILINX_VIVADO_MODE)
XILINX_VIVADO_BATCH := $(XILINX_VIVADO_ENV) $(XILINX_VIVADO_CMD) -mode batch
