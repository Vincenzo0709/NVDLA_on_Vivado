# Xilinx directory
This directory is used to package, synthesize and implement NVDLA in Vivado.

To package, from the top directory:
```
make xilinx
```
It does Vivado IP packaging and OOC Synthesis.

To clean, from the top directory:
```
make clean_ips
```

To simulate with AXI VIP IP in Vivado and see waveforms, see [here](sim/README.md).
