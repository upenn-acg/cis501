# source verilog files
SOURCES=.set_testcase.v lc4_alu.v lc4_decoder.v lc4_divider.v lc4_regfile.v lc4_single.v include/register.v include/lc4_memory.v include/clock_util.v include/delay_eight_cycles.v include/bram.v
TOP_SYNTH_MODULE=lc4_processor

ZIP_SOURCES=lc4_alu.v lc4_divider.v lc4_regfile.v lc4_single.v
ZIP_FILE=single.zip

# testbench files
TESTBENCH=testbench_lc4_processor.v
TOP_TESTBENCH_MODULE=test_processor
NEEDS_TEST_CASE=true

include ../common/make/vivado.mk
