#!/bin/bash
# 
# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script executes at each nvdla_custom container startup:
#       1. Correct VP configuration file with Image and rootfs absolute paths;
#       2. Copy VP application and libraries, KMD, UMD application and library, to update them if recompiled;
#       3. Keep bash CLI and container environment running.

echo "Running startup script..."

# Correct configuration script "aarch64_nvdla.lua" with correct paths for linux kernel image and rootfs
sed -i 's|Image|/usr/local/nvdla/Image|g' /usr/local/nvdla/aarch64_nvdla.lua
sed -i 's|rootfs.ext4|/usr/local/nvdla/rootfs.ext4|g' /usr/local/nvdla/aarch64_nvdla.lua

# Copy VP application and linked libraries into container environment
# cp $(NOV_VP_ROOT)/build/bin/aarch64_toplevel /usr/bin
# cp $(NOV_VP_ROOT)/build/lib/libcosim_sc_wrapper.so /usr/lib
# cp $(NOV_VP_ROOT)/build/lib/libnvdla.so /usr/lib
# cp $(NOV_VP_ROOT)/build/lib/libqbox-nvdla.so /usr/lib
# cp $(NOV_VP_ROOT)/build/lib/liblog.so /usr/lib
# cp $(NOV_VP_ROOT)/build/lib/libnvdla_cmod.so /usr/lib
# cp $(NOV_VP_ROOT)/build/lib/libsimplecpu.so /usr/lib
# cp $(NOV_VP_ROOT)/conf/aarch64_nvdla.lua /usr/local/nvdla
# cp $(NOV_VP_ROOT)/libs/qbox.build/share/qemu/efi-virtio.rom /usr/local/nvdla

# Copy recompiled KDM kernel module into container environment
cp $(NOV_SW_ROOT)/kmd/port/linux/opendla.ko /usr/local/nvdla/

# Copy recompiled UDM application and linked library into container environment
cp $(NOV_SW_ROOT)/umd/out/apps/runtime/nvdla_runtime/nvdla_runtime /usr/local/nvdla/
cp $(NOV_SW_ROOT)/umd/out/core/src/runtime/libnvdla_runtime/libnvdla_runtime.so /usr/local/nvdla/

# Prevent container from shutting down
exec /bin/bash