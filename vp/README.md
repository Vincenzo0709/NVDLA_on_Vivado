### NVDLA VP directory
Tested on Ubuntu 16.04, with 4.15.0 kernel.

# Introduction
This directory contains what needed to build and launch NVDLA VP and execute an inference.
All was taken from nvdla/sw Github repository (link [here](https://github.com/nvdla/sw)).

You need the following tools:
- gcc-v4.8/g++-v4.8 
- python 2.7 for VP build
- python 3.5.2 for image formatting
- SystemC 2.3.0 library
- docker 18.09.7

All install steps are [here](doc/).

# Build VP
To build container environment from Dockerfile:
```
cd Container/
sudo docker build -t nvdla_custom .
```