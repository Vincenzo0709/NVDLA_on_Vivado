# Author: Vincenzo Merola <vincenzo.merola2@unina.it>
# Description:
#       This script extracts addresses to be used by testbench for simulation from NVDLA register python specification:
#       1. Reads from 'units/$(NOV_CONFIG)/spec/opendla.py' specification file;
#       2. Extracts readable and writable addresses;
#       3. Writes formatted output in '$(NOV_XILINX_SIM)/$(NOV_CONFIG)/tb/reg_specification.svh'.

import importlib.util
import sys
import os
from pathlib import Path
from math import ceil

# Constants
SIZE_WIDTH = 8
ADDR_WIDTH = 18
DATA_WIDTH = 32
MASK_WIDTH = 32
RESET_WIDTH = 32

# Data structure to extract needed infos for readable/writable registers
class RegisterInfo:

    def __init__(self, reg):
        self.size = reg.get('size')
        self.read_mask = reg.get('read_mask')
        self.write_mask = reg.get('write_mask')
        self.reset_value = reg.get('reset_val')

    def __str__(self):

        hex_digits = ceil(self.size / 4)

        return (
            f"\tSize       : 0x{self.size:02X} ({self.size:d} bits)\n"
            f"\tRead mask  : 0x{self.read_mask:0{hex_digits}X}\n"
            f"\tWrite mask : 0x{self.write_mask:0{hex_digits}X}\n"
            f"\tReset value: 0x{self.reset_value:0{hex_digits}X}\n"
        )

    def __repr__(self):
        return f"{self.__str__()}\n"
    
# Read register specification
def load_registers_module(path):

    # Create a module specification from the file
    spec = importlib.util.spec_from_file_location("reg_module", path)

    # Create a module object from the specification
    module = importlib.util.module_from_spec(spec)

    # Load and execute the module
    spec.loader.exec_module(module)

    return module.registers

# Extract writable/readable addresses
def extract_writable_readable_offsets(registers):

    # Offsets dictionaries (each element is addr: RegisterInfo)
    writable_offsets = {}
    readable_offsets = {}

    # Cycle over macro-registers
    for _, space_regs in registers.items():

        for reg_name in space_regs.get('register_list', []):

            reg = space_regs[reg_name]
            addr = reg.get('addr')

            # TODO 1: some addresses are in reg specification but not actually in nvdla rtl
            # TODO 2: for now selecting only 0xFFFFFFFF masks, as other masks are not reliable enough from register specification
            if 0x2000 <= addr < 0xE000:

                # Check fields for read/write permissions
                if reg.get('read_mask') == 0xFFFFFFFF:
                    
                    register = RegisterInfo(reg)
                    readable_offsets[addr] = register

                    if reg.get('write_mask') == 0xFFFFFFFF:
                        
                        writable_offsets[addr] = register

    return writable_offsets, readable_offsets

# Generate two log files
def generate_log(writable_offsets, readable_offsets):
    
    dir = Path(sys.argv[0]).parent
    os.makedirs(f'{dir}/logs', exist_ok=True)

    with open(f"{dir}/logs/writable_offsets.log", 'w') as f:
        for a, r in writable_offsets.items():
            f.write(f'Address 0x{a:05X}:\n{r}\n')

    with open(f'{dir}/logs/readable_offsets.log', 'w') as f:
        for a, r in readable_offsets.items():
            f.write(f"Address 0x{a:05X}:\n{r}\n")

def generate_sv(writable_offsets, readable_offsets):

    with open(sys.argv[2], 'w') as f:

        # Initial infos
        f.write(
            "// This header was generated from opendla.py by reg_specification_parser.py\n" \
            "// Author: Vincenzo Merola <vincenzo.merola2@unina.it>\n" \
            "// The idea is to declare a dictionary-like structure with {{addr: reg_info}} elements\n" \
            "// where each reg_info object wraps:\n"  \
            "// - Register size;\n" \
            "// - Read mask;\n" \
            "// - Write mask;\n" \
            "// - Reset value.\n\n" \
        )
        
        # Constants
        f.write(
            f"// Constant parameters\n"
            f"localparam ADDR_WIDTH = {ADDR_WIDTH};\n"
            f"localparam DATA_WIDTH = {DATA_WIDTH};\n"
            f"localparam SIZE_WIDTH = {SIZE_WIDTH};\n"
            f"localparam MASK_WIDTH = {MASK_WIDTH};\n"
            f"localparam RESET_WIDTH = {RESET_WIDTH};\n\n"
        )

        # Struct declaration
        f.write(
            f"// Register info structure\n"
            f"typedef struct {{\n"
            f"    bit [{SIZE_WIDTH-1}:0] size;\n"
            f"    bit [{MASK_WIDTH-1}:0] read_mask;\n"
            f"    bit [{MASK_WIDTH-1}:0] write_mask;\n"
            f"    bit [{RESET_WIDTH-1}:0] reset_value;\n"
            f"}} reg_info_t;\n\n"
        )

        ## Writable register offsets

        # Generate lines like this:
        # localparam int NUM_WRITABLE_REGS = 282;
        # bit [17:0] writable_offsets [NUM_WRITABLE_REGS] = '{
        #    18'h01004,    18'h0100C,    18'h02000,    18'h02004,    18'h02008,    18'h0200C,    18'h02010,    18'h02014,
        #    18'h03004,    18'h03008,    18'h03010,    18'h03014,    18'h03018,    18'h0301C,    18'h03020,    18'h03024,
        #    ...
        # };
        f.write(("// Writable register offsets\n"))
        f.write(f"localparam int NUM_WRITABLE_REGS = {len(writable_offsets)};\n")
        f.write("bit [ADDR_WIDTH-1:0] writable_offsets [NUM_WRITABLE_REGS] = {\n")

        addresses = list(writable_offsets.keys())
        for i, a in enumerate(addresses):
            comma = "," if i < len(addresses)-1 else ""
            ret = "\n" if i % 8 == 8-1 else ""
            f.write(f"    {ADDR_WIDTH}'h{a:0{ceil(ADDR_WIDTH/4)}X}{comma}{ret}")
        f.write("\n};\n\n")

        # Generate lines like this:
        # reg_info_t reg_write_map [bit [ADDR_WIDTH-1:0]] = {
        #     1 : '{18'h16, 32'h003f03ff, 32'h003f03ff, 32'h00000000},
        #     4 : '{18'h16, 32'h003f03ff, 32'h003f03ff, 32'h00000000}};
        #     ...
        # };
        f.write("// Writable addresses associative array\n")
        f.write(f"reg_info_t reg_write_map [bit [ADDR_WIDTH-1:0]] = {{\n")
        
        i = 0
        for a, r in writable_offsets.items():
            comma = "," if i < len(writable_offsets)-1 else ""
            f.write(f"\t\t{ADDR_WIDTH}'h{a:0{ceil(ADDR_WIDTH/4)}X} : '{{ ")
            f.write(f"{SIZE_WIDTH}'h{r.size:0{ceil(SIZE_WIDTH/4)}X}, ")
            f.write(f"{MASK_WIDTH}'h{r.read_mask:0{ceil(MASK_WIDTH/4)}X}, ")
            f.write(f"{MASK_WIDTH}'h{r.write_mask:0{ceil(MASK_WIDTH/4)}X}, ")
            f.write(f"{RESET_WIDTH}'h{r.reset_value:0{ceil(RESET_WIDTH/4)}X} }}{comma}\n")
            i = i+1
        f.write(f"}};\n\n")

        ## Readable register offsets
        f.write(("// Readable register offsets\n"))
        f.write(f"localparam int NUM_READABLE_REGS = {len(readable_offsets)};\n")
        f.write("bit [ADDR_WIDTH:0] readable_offsets [NUM_READABLE_REGS] = {\n")
        
        addresses = list(readable_offsets.keys())
        for i, a in enumerate(addresses):
            comma = "," if i < len(addresses)-1 else ""
            ret = "\n" if i % 8 == 8-1 else ""
            f.write(f"    {ADDR_WIDTH}'h{a:0{ceil(ADDR_WIDTH/4)}X}{comma}{ret}")
        f.write("\n};\n\n")

        f.write("// Readable addresses associative array\n")
        f.write(f"reg_info_t reg_read_map [bit [ADDR_WIDTH-1:0]] = {{\n")
        
        i = 0
        for a, r in readable_offsets.items():
            comma = "," if i < len(readable_offsets)-1 else ""
            f.write(f"\t\t{ADDR_WIDTH}'h{a:0{ceil(ADDR_WIDTH/4)}X} : '{{ ")
            f.write(f"{SIZE_WIDTH}'h{r.size:0{ceil(SIZE_WIDTH/4)}X}, ")
            f.write(f"{MASK_WIDTH}'h{r.read_mask:0{ceil(MASK_WIDTH/4)}X}, ")
            f.write(f"{MASK_WIDTH}'h{r.write_mask:0{ceil(MASK_WIDTH/4)}X}, ")
            f.write(f"{RESET_WIDTH}'h{r.reset_value:0{ceil(RESET_WIDTH/4)}X} }}{comma}\n")
            i = i+1
        f.write(f"}};\n\n")

# Main
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

    # Write offsets in two log files
    generate_log(writable_offsets, readable_offsets)

    # Generate sv code
    generate_sv(writable_offsets, readable_offsets)
