# Units directory
This directory contains NVDLA accelerator sources sets and specification files, populated by *fetch_sources.sh* scripts for each hardware configuration.

## Fetch
To fetch sources, from the top directory:
```
make units
```
Otherwise, from the current directory:
```
make
```
All needed source files are downloaded from [Github](https://github.com/Vincenzo0709/nvdla_hw).

To clean up, from the top directory:
```
make clean_units
```
Otherwise, from the current directory:
```
make clean
```
