# Hw directory
This is the hw directory.
In units/ there are rtl sources, in xilinx/ there is the full Vivado project.

hw
├── units
│   ├── nv_small
│   │   ├── [rtl](units/nv_small/rtl/) (sources after fetch)
│   │   ├── wrapper
│   │   │   ├── [axilite2csb](units/nv_small/wrapper/axilite2csb.sv)  
│   │   │   └── [NVDLA_wrapper](units/nv_small/wrapper/NVDLA_wrapper.sv)
│   │   └── [fetch_sources.sh](units/nv_small/fetch_sources.sh)
│   ├── [Makefile](units/Makefile)
│   └── [README.md](units/README.md)
└── xilinx
    ├── ips
    │   ├── nv_small
    │   │   ├── [build](xilinx/ips/nv_small/build/) (Vivado project after build)
    │   │   └── [config.tcl](xilinx/ips/nv_small/config.tcl) (soft link)
    │   ├── tcl
    │   │   ├── [pre_config.tcl](xilinx/ips/tcl/pre_config.tcl)
    │   │   ├── [config.tcl](xilinx/ips/tcl/config.tcl)
    │   │   └── [post_config.tcl](xilinx/ips/tcl/post_config.tcl)
    │   └── [nv_small.xci](xilinx/ips/nv_small.xci) (after build)
    ├── make
    │   ├── [build.mk](xilinx/make/build.mk)
    │   ├── [environment.mk](xilinx/make/environment.mk)
    │   └── [simulation.mk](xilinx/make/simulation.mk)
    ├── rtl
    ├── sim
    │   ├── nv_small
    │   │   ├── tb
    │   │   │   └── [nvdla_tb.sv](xilinx/sim/nv_small/tb/nvdla_tb.sv)
    │   │   └── wcfg
    │   │       └── [nvdla_tb_behav.wcfg](xilinx/sim/nv_small/wcfg/nvdla_tb_behav.wcfg)
    │   └── tcl
    │       ├── [block_design.tcl](xilinx/sim/tcl/block_design.tcl)
    │       └── [simulation.tcl](xilinx/sim/tcl/simulation.tcl)
    ├── synth
    │   ├── constraints
    │   └── tcl
    │       └── [package_ip.tcl](xilinx/synth/tcl/package_ip.tcl)
    ├── [Makefile](xilinx/Makefile)
    └── [README.md](xilinx/README.md)