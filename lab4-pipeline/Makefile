# synthesis

SYNTH_SOURCES=.set_testcase.v lc4_alu.v lc4_decoder.v lc4_divider.v lc4_regfile.v lc4_pipeline.v include/register.v include/lc4_memory.v include/clock_util.v include/delay_eight_cycles.v include/bram.v
TOP_SYNTH_MODULE=lc4_processor

ZIP_SOURCES=lc4_alu.v lc4_divider.v lc4_regfile.v lc4_pipeline.v
ZIP_FILE=pipeline.zip

# testbench

TESTBENCH=testbench_lc4_processor.v
#TESTBENCH=testbench_gen.v
TOP_TESTBENCH_MODULE=test_processor
NEEDS_TEST_CASE=true

# LC4 assembly code

PENNSIM_SCRIPT=lab4-demo.pennsim

# implementation

IMPL_SOURCES=$(SYNTH_SOURCES) system/mmcm.v system/fake_pb_kbd.v system/lc4_system.v system/one_pulse.v system/svga_timing_generation.v system/timer.v system/vga_controller.v system/video_out.v
TOP_IMPL_MODULE=lc4_system
CONSTRAINTS=system/lab4-pipeline.xdc 
BITSTREAM_FILENAME=pipeline.bit

include ../common/make/vivado.mk
