# Xilinx directory
This directory is used to package, synthesize and implement NVDLA in Vivado.

To package, from the top directory:

    make xilinx

    make clean_ips

It does Vivado IP packaging and OOC Synthesis.

To simulate with AXI VIP IP in Vivado and see waveforms:

    make sim

    make clean_sim

It will open simulation waveforms based on the tesbench in [here](sim/nv_small/tb/).
