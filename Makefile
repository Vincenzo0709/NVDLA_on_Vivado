# Environment check
ifndef ROOT_DIR
$(error Setup script settings.sh has not been sourced, aborting)
endif

all: hw sw

hw: xilinx

xilinx: units
	$(MAKE) -C $(XILINX_ROOT)

units:
	$(MAKE) -C $(UNITS_ROOT)

sw:

sim: 
	$(MAKE) -C $(XILINX_ROOT) sim

clean:
	$(MAKE) -C $(UNITS_ROOT) clean
	$(MAKE) -C $(XILINX_ROOT) clean
	$(MAKE) -C $(SW_ROOT) clean

clean_xilinx:
	${MAKE} -C $(XILINX_ROOT) clean

clean_sim:
	${MAKE} -C $(XILINX_ROOT) clean_sim

.PHONY: hw sw xilinx units sim clean clean_xilinx clean_sim