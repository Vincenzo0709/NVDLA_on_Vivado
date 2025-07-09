# Container installation
Here are the steps to download NVDLA VP Docker container and how to use it.
Tested on Ubuntu 16.04, with 4.15.0 kernel.

## Docker installation
Install necessary tools for GPG keys management:
```
sudo apt-get update
sudo apt-get install ca-certificates curl
```

Create the trusted GPG keys directory:
```
sudo install -m 0755 -d /etc/apt/keyrings
```

Install and store the key:
```
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
```

Change access premissions:
```
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add Docker repo to APT sources:
```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

Install Docker packages:
```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

To verify that installation ended successfully:
```
sudo docker run hello-world
```

## Download
Download the official NVDLA VP container image from DockerHub (link [here](https://hub.docker.com/r/nvdla/vp)):
```
sudo docker pull nvdla/vp
```

To verify image has correctly been downloaded:
```
sudo docker images
```

## Execution
To start the nvdla/vp container, with:
- Interactive mode (-i): mantains STDIN open;
- TTY device runnning (-t), connecting the user to a shell session;
- Volume list (-v /home:/home), linking container /home filesystem to user's /home.
```
sudo docker run -it -v /home:/home nvdla/vp
```

To verify the container is running:
```
sudo docker ps
```

All necessary tools to run NVDLA VP are located in /usr/local/nvdla directory:
- nvdla_compiler: to compile nets' description into loadable;
- libnvdla_compiler.so: shared library referenced from compiler application;
- drm.ko: kernel module for Direct Rendering Image, graphics and GPU management;
- opendla_x.ko: kernel mode drivers to access NVDLA hardware, depending on the configuration:
    - opendla_1.ko: for nv_large and nv_full?
    - opendla_2.ko: for nv_small?
- nvdla_runtime: user-level application to start inference;
- libnvdla_runtime.so: shared library referenced from runtime application;
- image/ directory:
    - rootfs.ext4: root fileysystem;
    - Image: linux 4.13.3 kernel image.
- aarch64_nvdla.lua: configuration script needed by Qemu;

The VP executable is located in /usr/bin:
- aarch64_toplevel