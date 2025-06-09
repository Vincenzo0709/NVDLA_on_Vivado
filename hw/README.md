# Hw directory
This is the hw directory.
In units/ there are rtl sources, in xilinx/ there is the full Vivado project.

```
hw
├── units
│   ├── nv_small
│   │   ├── rtl                                        # Sources after fetch
│   │   ├── wrapper                                    # Wrapper for nv_small
│   │   │   ├── axilite2csb.sv
│   │   │   └── NVDLA_wrapper.sv
│   │   └── fetch_sources.sh                           # Fetch script for nv_small
│   ├── Makefile
│   └── README.md
└── xilinx
    ├── ips
    │   ├── nv_small
    │   │   ├── build                                  # Vivado project after build
    │   │   └── config.tcl                             # Soft link to tcl/config.tcl
    │   ├── tcl                                        # Tcl scripts to package and synthesize
    │   │   ├──pre_config.tcl
    │   │   ├── config.tcl
    │   │   └── post_config.tcl
    │   └── nv_small.xci
    ├── make                                           # Makefiles to synthesize and simulate
    │   ├── build.mk
    │   ├── environment.mk
    │   └── simulation.mk
    ├── rtl
    ├── sim
    │   ├── nv_small
    │   │   ├── tb                                     # Testbench for nv_small simulation
    │   │   │   └── nvdla_tb.sv
    │   │   └── wcfg                                   # Wafeform configuration for nv_small simulation
    │   │       └── nvdla_tb_behav.wcfg
    │   └── tcl                                        # Tcl scripts to build simulations
    │       ├── block_design.tcl
    │       └── simulation.tcl
    ├── synth
    │   ├── constraints
    │   └── tcl
    │       └── package_ip.tcl                         # Tcl script to package IP
    ├── Makefile
    └── README.md
```
