# Xilinx directory
This directory is used to package, synthesize or simulate NVDLA accelerator in Vivado.
It contains:
- The Vivado [build](ips/) directory, with specific Vivado tcl automating [scripts](ips/tcl/);
- The [makefiles](make/) directory, with packaging, synthesis and simulation targets;
- The simulation directory (for details see the [README](sim/README.md));
- The tcl general [scripts](synth/tcl/) directory, to package the chosen configuration.

## Packaging and synthesis
To package, from the top directory:
```
make xilinx
```
Otherwise, from the current directory:
```
make
```
It does Vivado IP packaging and OOC Synthesis.

To clean up, from the top directory:
```
make clean_xilinx
```
Otherwise, from the current directory:
```
make clean_ips
```
or:
```
make clean
```
to clean up the simulation environment too.

## Simulation
To simulate with AXI VIP IP in Vivado and display waveforms, see the [README](sim/README.md).

## Scripts overview
About scripts in *ips/tcl* directory:
1. Create a new Vivado [project](ips/tcl/pre_config.tcl) for the chosen configuration;
2. Prepare the IP [packaging](ips/tcl/config.tcl) and launch it;
3. Generate all needed artifacts for OOC [synthesis](ips/tcl/post_config.tcl).

About general scripts in synth/ directory:
1. Perform Vivado IP [packaging](synth/tcl/package_ip.tcl).