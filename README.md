### NVDLA_on_Vivado
Vivado build for NVDLA

With this project you can create a Vivado IP from NVDLA accelerator Github hardware repository, just by launching a few commands.

## Environment and tools version
This project was tested on Ubuntu 22.04 and the following tools version:
| Tool      | Verified version   |        
|-----------|--------------------|
| Vivado    | 2022.2             |

## NVDLA Configurations
It comes in one configuration:
| Configuration   | Description    | References     |
|-----------------|----------------|----------------|
| nv_small        |                | [nv](https://nvdla.org/primer.html) |

[ZCU102](https://www.xilinx.com/products/boards-and-kits/ek-u1-zcu102-g.html)

## Build Instructions
You can import only scripts/fetch_sources.sh file or you can clone the whole repository.

To fetch sources:

    ./scripts/fetch_sources.sh

If you want also to prepare Vivado IP and Block Design for zcu102:

    ./scripts/fetch_sources.sh --vivado
