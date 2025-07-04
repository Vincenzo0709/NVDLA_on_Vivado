
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
It comes in one configuration (so far):

| Configuration   | References         | Description                                            |
|-----------------|--------------------|--------------------------------------------------------|
| nv_small        | [nv_small](https://nvdla.org/primer.html)| The least complex, with 64 INT8 MAC, no SRAM and no Microcontroller |


## Build Instructions
- First, setup the environment with:
  ```
  source settings.sh <CONFIG> <BOARD>
  ```
- Then build with:
  ```
  make all
  ```
The defaults are "nv_small" and "zcu102".
See [units](hw/units/README.md) or [xilinx](hw/xilinx/README.md) for details, or if you want to build step by step.

## Simulation
There is also a simulation target.
```
make sim
```
It builds a new block design with NVDLA accelerator and executes a predefined testbench; then opens waveforms in Vivado.
See [Simulation](hw/xilinx/sim/README.md) for details.
