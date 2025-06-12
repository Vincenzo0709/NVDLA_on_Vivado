# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script extracts addresses to be used by testbench for simulation from NVDLA register python specification:
#       1. Reads from 'units/$(NOV_CONFIG)/spec/opendla.py' specification
#       2. Extracts readable and writable addresses (all 32 bit fields with read and write mask = 0xffffffff)
#       3. Writes formatted output in '$(NOV_XILINX_SIM)/$(NOV_CONFIG)/tb/reg_specification.svh'

import importlib.util
import sys
from pathlib import Path

# Read register specification
def load_registers_module(path):

    # Create a module specification from the file
    spec = importlib.util.spec_from_file_location("reg_module", path)

    # Create a module object from the specification
    module = importlib.util.module_from_spec(spec)

    # Load and execute the module
    spec.loader.exec_module(module)
    return module.registers

# Extract readable/writable addresses
def extract_writable_readable_offsets(registers):

    # Set of offsets
    writable_offsets = set()
    readable_offsets = set()

    # Cycle over macro-registers
    for _, space_regs in registers.items():

        for reg_name in space_regs.get('register_list', []):

            reg = space_regs[reg_name]
            addr = reg.get('addr')

            # TODO: some addresses are in reg specification but not actually in nvdla rtl
            if addr < 0xe000:

                # Check fields for read/write permissions
                if reg.get('read_mask') == 0xffffffff:
                    
                    readable_offsets.add(addr)

                    if reg.get('write_mask') == 0xffffffff:
                        
                        writable_offsets.add(addr)


    return sorted(writable_offsets), sorted(readable_offsets)

# Generate two .svh files
def generate_sv(writable_offsets, readable_offsets):

    lines_w = []
    lines_r = []

    # Initial comments
    lines_w.append("// This header was generated from opendla.py by reg_specification_parser.py\n")

    # Initial arguments
    lines_w.append("// Writable register offsets")
    lines_w.append(f"localparam int NUM_WRITABLE_REGS = {len(writable_offsets)};")
    lines_r.append("\n\n// Readable register offsets")
    lines_r.append(f"localparam int NUM_READABLE_REGS = {len(readable_offsets)};")

    lines_w.append(f"bit [15:0] writable_offsets [NUM_WRITABLE_REGS] = '{{")
    lines_r.append(f"bit [15:0] readable_offsets [NUM_READABLE_REGS] = '{{")

    # Generate lines like this:
    #   localparam int NUM_WRITABLE_REGS = 117;
    #   bit [15:0] writable_offsets [NUM_WRITABLE_REGS] = '{
    #       16'h2000,
    #       16'h2004,
    #       ...
    #   };
    for i, offset in enumerate(writable_offsets):
        comma = "," if i < len(writable_offsets)-1 else ""
        lines_w.append(f"    18'h{offset:05x}{comma}")
    lines_w.append("};")

    for i, offset in enumerate(readable_offsets):
        comma = "," if i < len(readable_offsets)-1 else ""
        lines_r.append(f"    18'h{offset:05x}{comma}")
    lines_r.append("};")

    return "\n".join(lines_w), "\n".join(lines_r)

if __name__ == "__main__":

    # Check arguments and print help
    if len(sys.argv) != 3:
        print("Usage: python3 reg_specification_parser.py <register_file>.py <output_file>.svh")
        sys.exit(1)
    
    # Open file
    registers_py = Path(sys.argv[1])
    if not registers_py.exists():
        print(f"Error: File {registers_py} does not exist.")
        sys.exit(1)

    # Read spec and load module
    registers = load_registers_module(str(registers_py))

    # Extract writable and readable offsets
    writable_offsets, readable_offsets = extract_writable_readable_offsets(registers)

    # Generate sv code
    sv_code_w, sv_code_r = generate_sv(writable_offsets, readable_offsets)
    
    # Print on .svh file
    f = open(sys.argv[2], "w")
    f.write(sv_code_w)
    f.write(sv_code_r)
    f.close()
