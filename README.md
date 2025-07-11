
# NVDLA_on_Vivado
Vivado build for NVDLA.<br>
With this project you can syntesize, implement or simulate NVDLA accelerator (documentation [here](https://nvdla.org/index.html)), just by launching a few commands.

## Environment and tools version
This project was tested on the following OS versions:

| Environment      | OS Distro      |
|------------------|----------------|
| Hardware         | Ubuntu 22.04.4 |
| Software         | Ubuntu 16.04.7 |
| Virtual Platform | Ubuntu 16.04.7 |

and the following tools version:

| Tool      | Verified version   |
|-----------|--------------------|
| Vivado    | 2022.2             |
| Docker    | 18.09              |

## NVDLA hardware configurations
It comes in one configuration (so far):

| Configuration   | References         | Description                                            |
|-----------------|--------------------|--------------------------------------------------------|
| nv_small        | [nv_small](https://nvdla.org/hw/v2/integration_guide.html)| The least complex, with 64 INT8 MAC, no SRAM and no Microcontroller |


## Build instructions
Firstly, setup the environment with:
```
source settings.sh <CONFIG> <BOARD>
```

| CONFIG   | BOARD  |
|----------|--------|
| nv_small | zcu102 |

Then build with:
```
make all
```

To cleanup:
```
make clean
```

See the following if you want to build only specific targets.

### Hardware
From the top directory
```
make hw
```

To cleanup:
```
make clean_hw
```

See [units](hw/units/README.md) or [xilinx](hw/xilinx/README.md) for details, or if you want to build step by step.

### Simulation
From the top directory:
```
make sim
```
It builds a new block design with NVDLA accelerator and executes a predefined testbench; then opens waveforms in Vivado.

To cleanup:
```
make clean_sim
```

See [Simulation](hw/xilinx/sim/README.md) for details.

### Software
From the top directory:
```
make sw
```

To cleanup:
```
make clean_sw
```

See [Software](sw/README.md) for details.

### Virtual Platform
From the top directory:
```
make vp
```

To cleanup:
```
make clean_vp
```

See [Virtual Platform](vp/README.md) for details.
