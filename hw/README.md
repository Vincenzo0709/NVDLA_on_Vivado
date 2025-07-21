# Hw directory
Tested on Ubuntu 22.04.4.

This directory contains all needed to synthesize, package or simulate NVDLA accelerator in Vivado:
- In [configs/](configs/) there are the sources flilelists, for each configuration;
- In [units/](units/) are fetched rtl sources sets;
- In [xilinx/](xilinx/) there is the full Vivado project.

## Overview
```
hw
├── configs
│   ├── nv_small
│   │   └── nv_small.flist                              # nv_small configuration filelist
│   └── README.md
├── units
│   ├── nv_small
│   │   ├── rtl                                         # Sources after fetch for nv_small
│   │   ├── spec                                        # Some needed register specification files after fetch for nv_small
│   │   ├── wrapper                                     # AXI Wrapper for nv_small
│   │   └── fetch_sources.sh                            # Fetch script for nv_small
│   ├── Makefile
│   └── README.md
└── xilinx
    ├── ips
    │   ├── nv_small
    │   │   ├── build                                   # Vivado project after build
    │   │   └── config.tcl                              # Soft link to tcl/config.tcl
    │   ├── tcl                                         # Tcl scripts to package and synthesize
    │   │   ├── pre_config.tcl
    │   │   ├── config.tcl
    │   │   └── post_config.tcl
    │   └── nv_small.xci
    ├── make                                            # Makefiles to start all builds
    │   ├── build.mk
    │   ├── environment.mk
    │   └── simulation.mk
    ├── sim
    │   ├── nv_small
    │   │   ├── build                                   # Vivado nv_small simulation project after build
    │   │   ├── tb
    │   │   │   ├── reg_specification.svh               # Register specification for nv_small simulation
    │   │   │   └── nvdla_tb.sv                         # Testbench for nv_small simulation
    │   │   └── wcfg                                    # Wafeform configuration for nv_small simulation
    │   │       └── nvdla_tb_behav.wcfg 
    │   ├── scripts
    │   │   ├── logs                                    # Register specification script log files directory after build
    │   │   └── reg_specification_parser.py             # Python register specification parser script for simulations
    │   ├── tcl                                         # Tcl scripts to build and run simulations
    │   │   ├── block_design.tcl
    │   │   ├── run.tcl
    │   │   └── simulation.tcl
    │   └── README.md
    ├── synth
    │   └── tcl
    │       └── package_ip.tcl                         # Tcl script to package as Vivado IP
    ├── Makefile
    └── README.md
```
