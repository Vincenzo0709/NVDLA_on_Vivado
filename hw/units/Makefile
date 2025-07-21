# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This Makefile populates units/ directory by executing "fetch_sources.sh" script for the chosen NVDLA configuration.

# Environment check
ifndef NOV_ROOT_DIR
$(error Setup script settings.sh has not been sourced, aborting)
endif

SHELL := /bin/bash

# Main target
all: units

# Units dependency
units: $(addsuffix /rtl, $(NOV_CONFIG))

# Fetch rtl sources
%/rtl:
	cd $(NOV_UNITS_ROOT)/$* ; source fetch_sources.sh
	@if [ -z "$$(ls -A $(NOV_UNITS_ROOT)/$@)" ]; then 		\
		echo "[UNITS] Failed to fetch sources for $*" >&2; 	\
		rm -rf rtl/; 										\
		false; 												\
	fi

# Clean target
clean:
	rm -rf $(NOV_UNITS_ROOT)/*/rtl
	rm -rf $(NOV_UNITS_ROOT)/*/spec
	rm -rf $(NOV_UNITS_ROOT)/*/nvdla_hw

.PHONY: units clean