#!/bin/bash

export ROOT_DIR=$( dirname $( realpath $BASH_SOURCE[0]} ) )

# Check if Vivado is in path
if ! command -v vivado &> /dev/null; then
    echo "[Error] Can't find Vivado in PATH! Pleas add Vivado to your PATH" >&2
    return 1
fi

# Configuration root directory
export CONFIG_ROOT=${ROOT_DIR}/config

# Hw directories
export HW_ROOT=${ROOT_DIR}/hw
export UNITS_ROOT=${HW_ROOT}/units
export XILINX_ROOT=${HW_ROOT}/xilinx

# Synthesis
export XILINX_SYNTH_ROOT=${XILINX_ROOT}/synth
export XILINX_SYNTH_TCL_ROOT=${XILINX_SYNTH_ROOT}/tcl
export XILINX_SYNTH_XDC_ROOT=${XILINX_SYNTH_ROOT}/constraints

# Ips directories
export XILINX_RTL_ROOT=${XILINX_ROOT}/rtl
export XILINX_SCRIPTS_ROOT=${XILINX_ROOT}/scripts
export XILINX_IPS_ROOT=${XILINX_ROOT}/ips

# Sw directory
export SW_ROOT=${ROOT_DIR}/sw

# Project for Vivado
export XILINX_PROJECT_NAME=nvdla
export IP_NAME=nvdla
export XILINX_PROJECT_NAME=nvdla

# Configuration selection
CONFIG=$1
BOARD=$2

case ${CONFIG} in
    nv_small | "")
        export NVDLA_CONFIG=nv_small
        ;;
    *)
        echo "Configuration not recognized"
        return 1
        ;;
esac

case ${BOARD} in
    zcu102 | "")
        export XILINX_PART_NUMBER=xczu9eg-ffvb1156-2-e
        export XILINX_BOARD_PART=xilinx.com:zcu102:part0:3.4
        export XILINX_HW_DEVICE=xczu9_0
        export XILINX_BOARD=zcu102
        ;;
    *)
        echo "Board not supported"
        return 1
        ;;
esac

# Hardware Server Host
export XILINX_HW_SERVER_HOST=127.0.0.1
export XILINX_HW_SERVER_PORT=3121
