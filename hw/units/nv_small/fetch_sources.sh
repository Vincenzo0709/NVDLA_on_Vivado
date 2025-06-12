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
#
#       Tools needed:
#       - git

# Some needed variables
GIT_URL=https://github.com/Vincenzo0709/nvdla_hw.git
GIT_TAG=nv_small
CLONE_DIR=nvdla_hw
CONFIG=nv_small

# Create rtl and spec dirs
mkdir -p rtl
mkdir -p spec

# Clone repo to specific branch
printf "${YELLOW}[FETCH_SOURCES] Cloning source repository${NC}\n"
git clone ${GIT_URL} -b ${GIT_TAG} ${CLONE_DIR}

# Copy all RTL files into rtl dir
printf "${YELLOW}[FETCH_SOURCES] Copying all sources into rtl${NC}\n"
for rtl_file in $(cat ${NOV_CONFIG_ROOT}/${CONFIG}/${CONFIG}.flist) ; do
    cp $rtl_file ./rtl
done;

# Copy python specification file (needed for simulation)
cp ${CLONE_DIR}/outdir/${CONFIG}/spec/manual/opendla.py ./spec

## Some necessary modifies
cd rtl/
# Vivado seems to not recognise .vlib sources
find . -type f -name "*.vlib" -exec bash -c 'mv "$0" "${0%.vlib}.v"' {} \;
# Other syntax corrections (optional)
find . -type f -name "nv_ram_*" -exec sed -i 's/task arrangement (output integer arrangment_string\[\([0-9]*:[0-9]*\)\]);/task arrangement (output reg [\1] arrangment_string);/g' {} \;
find . -type f -name "nv_ram_*" -exec sed -i 's/input string init_file;/input reg init_file;/g' {} \;
# sed -i 's/modName = int.*($sformatf *("\%m"));/$sformat(modName, "%m");/' RANDFUNC.v
cd ..

# Delete the cloned repo
printf "${YELLOW}[FETCH_SOURCES] Cleaning all artifacts${NC}\n"
sudo rm -r ${CLONE_DIR}
printf "${GREEN}[FETCH_SOURCES] Completed${NC}\n"