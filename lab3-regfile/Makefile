# source verilog files
SYNTH_SOURCES=lc4_regfile.v register.v
TOP_SYNTH_MODULE=lc4_regfile

# testbench files
TESTBENCH=testbench_lc4_regfile.v
TOP_TESTBENCH_MODULE=test_regfile

# NB: $(XDC_DIR) defined in vivado.mk
CONSTRAINTS=$(XDC_DIR)/empty.xdc

include ../common/make/vivado.mk
