# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#		This Makefile builds NVDLA VP:
#		1. Compile loadable from nets:
#			- AlexNet
#			- ResNet
#		2. Check for built sw;
#		3. Start Docker container.

all: container

# sw: $(NOV_SW_ROOT)/kmd/port/linux/opendla.ko $(NOV_SW_ROOT)/umd/out/apps/compiler $(NOV_SW_ROOT)/umd/out/apps/runtime
# 	$(MAKE) -C $(NOV_SW_ROOT)

comp: $(NOV_SW_ROOT)/umd/out/apps/compiler
	$(MAKE) -C $(NOV_SW_ROOT) compiler

net: nets/$(NET)/*.nvdla
# TODO: compilare una rete

# Start container with:
# - Interactive mode (-i), that mantains STDIN open;
# - TTY device runnning (-t), connecting the user to a shell session;
# - Volume list (-v /home:/home), mounting container /home filesystem to user's /home.
container: comp net
	sudo docker run -it -v /home:/home $(IMG_NAME)

.PHONY: comp sw net container
