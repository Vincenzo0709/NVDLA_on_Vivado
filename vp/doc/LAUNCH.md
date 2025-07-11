# NVDLA VP Launch
These are the final steps to start NVDLA VP.

## Custom image generation
DockerHub NVDLA VP container already has built needed tools.
In order to modify container image as needed to run NVDLA VP, you need to recompile the image using the [Dockerfile](/container/Dockerfile), by indicating the new image name (e.g. "nvdla_custom").

```
cd container/
sudo docker build -t <img_name> .
```

## Container execution
To start the container, from the vp/ directory:
```
make IMG_NAME=<img_name> NET=<net_name>
```

| IMG_NAME   | NET_NAME   |
|------------|------------|
| nvdla/vp   | AlexNet    |
| <custom>   | ResNet     |

To verify the container is running:
```
sudo docker ps
```

## Virtual Platform launch
To start the VP, from the current directory:
```
aarch64_toplevel -c /usr/local/nvdla/aarch64_nvdla.lua
```