# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#		This Makefile builds NVDLA driver and runtime application. 
#		1. Compile NVDLA compiler
#		2. Compile KMD
#		3. Compile UMD

all: compiler kmd umd

compiler:
	cd umd; 						\
	export TOP=$(NOV_SW_ROOT)/umd;	\
	$(MAKE) compiler

kmd: /buildroot/output/build/linux-4.13.3/ $(NOV_SW_ROOT)/tools/toolchain/aarch64-linux-gnu-
	cd kmd/ 							\
	export KDIR=$<;						\
	export ARCH=arm64;					\
	export CROSS_COMPILE=$(word 2, $^);	\
	$(MAKE)

umd: $(NOV_SW_ROOT)/tools/toolchain/aarch64-linux-gnu-
	cd umd; 								\
	export TOP=$(NOV_SW_ROOT)/umd;			\
	export TOOLCHAIN_PREFIX=$<;				\
	$(MAKE) runtime

clean:
	$(MAKE) clean_umd clean_kmd

.PHONY: compiler kmd umd clean