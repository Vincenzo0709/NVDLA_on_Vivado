
# NVDLA_on_Vivado

Vivado build for NVDLA.
With this project you can create a Vivado IP from NVDLA accelerator Github hardware repository, just by launching a few commands.

## Environment and tools version
This project was tested on the following OS version:

| OS Distro    |
|--------------|
| Ubuntu 22.04 |

and the following tools version:

| Tool      | Verified version   |
|-----------|--------------------|
| Vivado    | 2022.2             |

## NVDLA Configurations
It comes in one configuration:

| Configuration   | References         | Description                                    |
|-----------------|--------------------|------------------------------------------------|
| nv_small        | [nv_small](https://nvdla.org/primer.html)| The least complex, with |


## Build Instructions
- First, setup the environment with:

    source settings.sh <CONFIG> <BOARD>

- Then build with:

    make all
    make clean

The defaults are "nv_small" and "zcu102".

## Simulation
There is also a simulation target.

    make sim
    make clean_sim

It builds a new block design with NVDLA accelerator and executes a predefined testbench.
See [Simulation] (hw/xilinx/sim/Readme.md) for details.