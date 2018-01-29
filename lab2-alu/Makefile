# source verilog files
SOURCES=lc4_alu.v lc4_divider.v
TOP_MODULE=lc4_alu

# testbench files
TESTBENCH=testbench_lc4_alu.v
TOP_TESTBENCH_MODULE=test_alu

# NB: $(XDC_DIR) defined in vivado.mk
CONSTRAINTS=$(XDC_DIR)/physical-leds-switches.xdc

BITSTREAM_FILENAME=alu.bit

include ../common/make/vivado.mk
