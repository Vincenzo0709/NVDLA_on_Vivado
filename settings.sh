#!/bin/bash
#
# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script downloads NVDLA nv_small sources and flattens them into an rtl/ directory:
#       1. Clone the Github repository;
#       2. Copy source files from the repo, flattening them in rtl/ directory;
#       3. Copy register specification file in spec/ directory;
#       4. Correct some syntax in source files;
#       5. Delete the repo.

# Top directory
export NOV_ROOT_DIR="$( dirname "$( realpath "${BASH_SOURCE[0]}" )" )"

# Check if Vivado is in path
if ! command -v vivado &> /dev/null; then
    echo "[Error] Can't find Vivado in PATH! Please add Vivado to your PATH" >&2
    return 1
fi

# Configuration directory
export NOV_CONFIG_ROOT=${NOV_ROOT_DIR}/config

# Hardware directories
export NOV_HW_ROOT=${NOV_ROOT_DIR}/hw
export NOV_UNITS_ROOT=${NOV_HW_ROOT}/units
export NOV_XILINX_ROOT=${NOV_HW_ROOT}/xilinx

# Ips directory
export NOV_XILINX_IPS=${NOV_XILINX_ROOT}/ips

# Synthesis directories
export NOV_XILINX_SYNTH=${NOV_XILINX_ROOT}/synth
export NOV_XILINX_SYNTH_TCL=${NOV_XILINX_SYNTH}/tcl

# Simulation directories
export NOV_XILINX_SIM=${NOV_XILINX_ROOT}/sim
export NOV_XILINX_SIM_TCL=${NOV_XILINX_SIM}/tcl

# Software directory
export NOV_SW_ROOT=${NOV_ROOT_DIR}/sw

# Virtual Platform directory
export NOV_VP_ROOT=${NOV_ROOT_DIR}/vp

# Hardware Server Host
export NOV_XILINX_HW_SERVER_HOST=127.0.0.1
export NOV_XILINX_HW_SERVER_PORT=3121

# Configuration and board selection
CONFIG=$1
BOARD=$2

case ${CONFIG} in
    nv_small | "")
        export NOV_CONFIG=nv_small
        ;;
    *)
        echo "Configuration not recognized"
        return 1
        ;;
esac

case ${BOARD} in
    zcu102 | "")
        export NOV_XILINX_PART_NUMBER=xczu9eg-ffvb1156-2-e
        export NOV_XILINX_BOARD_PART=xilinx.com:zcu102:part0:3.4
        export NOV_XILINX_BOARD=zcu102
        ;;
    *)
        echo "Board not supported"
        return 1
        ;;
esac
