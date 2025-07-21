# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#		This Makefile builds NVDLA drivers and runtime application. 
#		1. Compile kernel and toolchain with buildroot;
#		2. Compile NVDLA compiler;
#		3. Compile KMD;
#		4. Compile UMD.

# Environment check
ifndef NOV_ROOT_DIR
$(error Setup script settings.sh has not been sourced, aborting)
endif

# Buildroot path
BUILDROOT_DIR := $(NOV_SW_TOOLS)/buildroot

# Arm64 toolchain needed for runtime build
TOOLCHAIN_DIR := $(BUILDROOT_DIR)/../../../../buildroot/output/host/
TOOLCHAIN_PREFIX := $(TOOLCHAIN_DIR)/bin/aarch64-linux-gnu-
TOOLCHAIN_CHECK := $(TOOLCHAIN_DIR)/bin/aarch64-linux-gnu-gcc

# Linux kernel image needed for kmd build
KERNEL_DIR := $(BUILDROOT_DIR)/output/build/linux-4.13.3

# Main targets
all: kmd umd

# KMD compilation
kmd: $(KERNEL_DIR) $(TOOLCHAIN_CHECK)
	export KDIR=$<;								\
	export ARCH=arm64;							\
	export CROSS_COMPILE=$(TOOLCHAIN_PREFIX);	\
	$(MAKE) -C kmd/

# UMD compilation
umd: compiler runtime

runtime: $(TOOLCHAIN_CHECK)
	export TOP=$(NOV_SW_ROOT)/umd;						\
	export TOOLCHAIN_PREFIX=$(TOOLCHAIN_PREFIX);		\
	$(MAKE) -C $(NOV_SW_UMD) runtime

compiler:
	export TOP=$(NOV_SW_ROOT)/umd;	\
	$(MAKE) -C $(NOV_SW_UMD) compiler

# Buildroot compilation
$(TOOLCHAIN_CHECK) $(KERNEL_DIR): $(BUILDROOT_DIR)/.done

buildroot: $(BUILDROOT_DIR)/.done

$(BUILDROOT_DIR)/.done:
	$(MAKE) -C $(BUILDROOT_DIR) qemu_aarch64_virt_defconfig
	cp $(NOV_SW_TOOLS)/utils/.config $(NOV_SW_TOOLS)/buildroot
	$(MAKE) -C $(BUILDROOT_DIR) -j6
	touch $@

# Clean targets
clean: clean_umd clean_kmd clean_buildroot

clean_umd:
	$(MAKE) -C $(NOV_SW_UMD) clean

clean_kmd:
	$(MAKE) -C $(NOV_SW_KMD) clean

clean_buildroot:
	$(MAKE) -C $(BUILDROOT_DIR) clean
	rm -f $(BUILDROOT_DIR)/.done

.PHONY: runtime compiler buildroot kmd umd clean clean_umd clean_kmd clean_buildroot
