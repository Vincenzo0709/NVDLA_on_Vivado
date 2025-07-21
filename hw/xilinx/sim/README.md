# Xilinx simulation directory
This directory let you simulate a Block Design with chosen NVDLA configuration IP in it.
It contains:
- Some automatizing [scripts](tcl/) for simulation Block Design instantiation and simulation launch (see below);
- For each configuration (e.g. nv_small):
   - The [testbench](nv_small/tb/);
   - The waveform [configuration](nv_small/wcfg/).

## Build
To build, both from *xilinx/* or the top directory:
```
make sim
```

To clean up:
```
make clean_sim
```
or:
```
make clean
```
to clean up the whole Vivado project.

## Scripts overview
About the three scripts in *tcl/* directory:
1. Prepare the simulation [Block Design](tcl/block_design.tcl):
   1. Instantiating NVDLA accelerator and two AXI Verification IP:
      1. The first acts as master in AXI protocol to CSB NVDLA interface;
      2. The latter acts as slave emulating a slave external DDR interface.
   2. Connecting them;
   3. Assigning AXI Memory Mapped addresses.
2. Prepare simulation [properties](tcl/simulation.tcl):
   1. Preparing all necessary source files and metadata (such as defines, top module etc...);
   2. Adding the waveform configuration.
3. Execute [simulation](tcl/run.tcl):
   1. Launching simulation;
   2. Opening GUI to display waveforms.
