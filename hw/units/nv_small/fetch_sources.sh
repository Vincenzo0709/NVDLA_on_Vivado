#!/bin/bash
# Author: Vincenzo Merola <vincenzo.merola2@unina.it>

# Description:
# This script downloads NVDLA nv_small sources and flattens them into an rtl/ directory.

# To execute you need:
#   git

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

GIT_URL=https://github.com/Vincenzo0709/nvdla_hw.git
GIT_TAG=nv_small
CLONE_DIR=nvdla_hw
CONFIG=nv_small

# Create rtl dir
mkdir -p rtl

# Clone repo to specific branch
printf "${YELLOW}[FETCH_SOURCES] Cloning source repository${NC}\n"
git clone ${GIT_URL} -b ${GIT_TAG} ${CLONE_DIR}

# Clone Bender (future development)
# printf "${YELLOW}[FETCH_SOURCES] Download Bender${NC}\n"
# curl --proto '=https' --tlsv1.2 https://pulp-platform.github.io/bender/init -sSf | sh

# Copy all RTL files into rtl dir
printf "${YELLOW}[FETCH_SOURCES] Copying all sources into rtl${NC}\n"
for rtl_file in $(cat ${CONFIG_ROOT}/${CONFIG}/${CONFIG}.flist) ; do
    cp $rtl_file ./rtl
done;

## Some necessary modifies
cd rtl/
# Vivado seems to not recognise .vlib sources
find . -type f -name "*.vlib" -exec bash -c 'mv "$0" "${0%.vlib}.v"' {} \;
# find . -type f -name "nv_ram_*" -exec sed -i 's/task arrangement (output integer arrangment_string\[\([0-9]*:[0-9]*\)\]);/task arrangement (output reg [\1] arrangment_string);/g' {} \;
# find . -type f -name "nv_ram_*" -exec sed -i 's/input string init_file;/input reg init_file;/g' {} \;
# sed -i 's/modName = int.*($sformatf *("\%m"));/$sformat(modName, "%m");/' RANDFUNC.v
cd ..

# Delete the cloned repo
printf "${YELLOW}[FETCH_SOURCES] Cleaning all artifacts${NC}\n"
sudo rm -r ${CLONE_DIR}
printf "${GREEN}[FETCH_SOURCES] Completed${NC}\n"