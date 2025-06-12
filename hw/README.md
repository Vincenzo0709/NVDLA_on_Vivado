# Hw directory
This is the hw directory.
In [units/](units/) there are rtl sources, in [xilinx/](xilinx/) there is the full Vivado project.

```
hw
├── units
│   ├── nv_small
│   │   ├── rtl                                         # Sources after fetch for nv_small
│   │   ├── spec                                        # Some needed register specification files after fetch for nv_small
│   │   ├── wrapper                                     # AXI Wrapper for nv_small
│   │   │   ├── axilite2csb.sv
│   │   │   └── NVDLA_wrapper.sv
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
    │   │   ├── build                                   # Vivado nv_small simulation project after 'make sim'
    │   │   ├── tb
    │   │   │   ├── reg_specification.svh               # Register specification for nv_small simulation
    │   │   │   └── nvdla_tb.sv                         # Testbench for nv_small simulation
    │   │   └── wcfg                                    # Wafeform configuration for nv_small simulation
    │   │       └── nvdla_tb_behav.wcfg 
    │   ├── tcl                                         # Tcl scripts to build simulations
    │   │   ├── block_design.tcl
    │   │   └── simulation.tcl
    │   └── README.md
    ├── synth
    │   └── tcl
    │       └── package_ip.tcl                         # Tcl script to package as Vivado IP
    ├── Makefile
    └── README.md
```
