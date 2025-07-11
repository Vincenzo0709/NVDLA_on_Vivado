# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#		This Makefile builds NVDLA driver and runtime application. 
#		1. Compile NVDLA compiler;
#		2. Compile KMD;
#		3. Compile UMD.
#
# Necessary tools:
# - gcc-4.8
# - g++-4.8

# Arm64 toolchain variables needed for runtime build
TOOLCHAIN_DIR := $(NOV_SW_ROOT)/tools/ext-toolchain/bin
TOOLCHAIN_PREFIX := $(TOOLCHAIN_DIR)/aarch64-linux-gnu-
TOOLCHAIN_CHECK := $(TOOLCHAIN_DIR)/aarch64-linux-gnu-gcc

# Linux kernel image variable needed for kmd build
KERNEL_DIR := $(NOV_SW_ROOT)/tools/buildroot/output/build/linux-4.13.3/

# Main targets
all: kmd umd

# KMD target
kmd: $(KERNEL_DIR) $(TOOLCHAIN_CHECK)
	cd kmd/ 							\
	export KDIR=$<;						\
	export ARCH=arm64;					\
	export CROSS_COMPILE=$(word 2, $^);	\
	$(MAKE)

# UMD targets
umd: compiler runtime

runtime: $(TOOLCHAIN_CHECK)
	export TOP=$(NOV_SW_ROOT)/umd;						\
	export TOOLCHAIN_PREFIX=$(TOOLCHAIN_PREFIX);		\
	$(MAKE) -C umd/ runtime

compiler:
	export TOP=$(NOV_SW_ROOT)/umd;	\
	$(MAKE) -C umd/ compiler

# Clean targets
clean: clean_umd clean_kmd

clean_umd:
	$(MAKE) -C umd/ clean

clean_kmd:
	$(MAKE) -C kmd/ clean

.PHONY: compiler kmd umd clean clean_umd clean_kmd
