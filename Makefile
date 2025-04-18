# Environment check
ifndef ROOT_DIR
$(error Setup script settings.sh has not been sourced, aborting)
endif


all: hw sw


hw: xilinx

xilinx: units
	${MAKE} -C ${XILINX_ROOT}

units:
	${MAKE} -C ${UNITS_ROOT}

sw:

clean:
	${MAKE} -C ${UNITS_ROOT} clean
	${MAKE} -C ${XILINX_ROOT} clean
	${MAKE} -C ${SW_ROOT} clean


.PHONY: hw sw xilinx units clean