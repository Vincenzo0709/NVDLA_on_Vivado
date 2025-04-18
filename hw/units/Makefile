# Environment check
ifndef ROOT_DIR
$(error Setup script settings.sh has not been sourced, aborting)
endif

SHELL := /bin/bash

IP_RTL_LIST=$(shell basename $(UNITS_ROOT)/*/)

# Targets
all: units

units: $(addsuffix /rtl, ${IP_RTL_LIST})

# Fetch rtl sources
%/rtl:
	cd $(UNITS_ROOT)/$* ; source fetch_sources.sh

# Remove all RTL dirs
clean:
	rm -rf ${UNITS_ROOT}/*/rtl

.PHONY: units clean