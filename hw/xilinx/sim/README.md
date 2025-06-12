# Xilinx simulation directory
This directory let you simulate a Block Design with chosen NVDLA configuration IP in it.
It contains:
- Some automatizing scripts for simulation Block Design instantiation and simulation launch ([here](tcl/));
- The testbench ([here](nv_small/tb/nvdla_tb.sv));
- The waveform configuration ([here](nv_small/wcfg/nvdla_tb_behav.wcfg)).

To build, both from here or the top directory:
```
make sim
```
To clean, from the top directory:
```
make clean_sim
```
The three scripts in tcl/ directory:
1) Prepare the simulation Block Design:
   1) Instantiating NVDLA nv_small and two AXI Verification IP:
      1) The first acts as master in AXI protocol to CSB NVDLA interface;
      2) The latter acts as slave emulating a slave external DDR interface.
   2) Connecting them;
   3) Assigning AXI Memory Mapped addresses.
2) Prepare simulation:
   1) Preparing all necessary source files and metadata (such as defines, top module etc...);
   2) Adding the waveform configuration.
3) Execute simulation:
   1) Launching simulation;
   2) Opening GUI to display waveforms.
