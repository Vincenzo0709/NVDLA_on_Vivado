# Docker installation
Here are the steps to download NVDLA VP Docker container image and how to use it.<br>
Tested on Ubuntu 16.04, with 4.15.0 kernel.

## Docker runtime installation
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

## Container image download
Download the official NVDLA VP container image from DockerHub (link [here](https://hub.docker.com/r/nvdla/vp)):
```
sudo docker pull nvdla/vp
```

To verify image has correctly been downloaded:
```
sudo docker images
```
