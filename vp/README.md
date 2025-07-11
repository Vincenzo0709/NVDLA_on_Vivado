# NVDLA VP directory
Tested on Ubuntu 16.04, with 4.15.0 kernel.

## Introduction
This directory contains what needed to build and launch NVDLA VP and execute an inference.<br>

You need the following tools:
- gcc-v4.8/g++-v4.8 
- python 2.7 for VP build
- python 3.5.2 for image formatting
- SystemC 2.3.0 library
- docker 18.09.7

All install steps are [here](doc/STEPS.md).

## Container description
All necessary tools to run NVDLA VP will be located in /usr/local/nvdla directory, inside the container environment:
- LICENSE: gathers all Licenses for UMD, KMD, Apache, MIT, Google protobuf, Caffe, rapidjson, msinttypes, GNU buildroot and Linux, JSON;
- aarch64_nvdla.lua and aarch64_nvdla_dump_dts.lua: configuration script needed by Qemu;
- drm.ko: kernel module for Direct Rendering Image, graphics and GPU management;
- opendla_x.ko: kernel mode drivers to access NVDLA hardware, depending on the configuration:
    - opendla_1.ko: for nv_large and nv_full configurations;
    - opendla_2.ko: for nv_small configuration.
- rootfs.ext4: root fileysystem;
- Image: linux 4.13.3 kernel image.
- efi-virtio.rom: optional ROM for Virtio device support on boot with UEFI;
- nvdla_compiler: to compile nets' description into loadable;
- libnvdla_compiler.so: shared library referenced from compiler application;
- nvdla_runtime: user-level application to start inference;
- libnvdla_runtime.so: shared library referenced from runtime application;
- init_dla.sh: example script to start VP and configure SSH (not used).

The VP executable is located in /usr/bin:
- aarch64_toplevel
