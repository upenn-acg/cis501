# synthesis

SYNTH_SOURCES=.set_testcase.v lc4_alu.v lc4_decoder.v lc4_divider.v lc4_regfile_ss.v lc4_superscalar.v include/register.v include/lc4_memory.v include/clock_util.v include/delay_eight_cycles.v include/bram.v
TOP_SYNTH_MODULE=lc4_processor

ZIP_SOURCES=lc4_alu.v lc4_divider.v lc4_regfile_ss.v lc4_superscalar.v
ZIP_FILE=superscalar.zip

# testbench

NEEDS_TEST_CASE=true

TESTBENCH=testbench_lc4_processor.v
#TESTBENCH=testbench_gen.v
TOP_TESTBENCH_MODULE=test_processor

# legacy testbench from Spring 2017
#TESTBENCH=grade_lc4_superscalar.v
#TOP_TESTBENCH_MODULE=grade_lc4_superscalar_v


# LC4 assembly code

PENNSIM_SCRIPT=lab5-demo.pennsim

# implementation

IMPL_SOURCES=$(SYNTH_SOURCES) system/mmcm.v system/fake_pb_kbd.v system/lc4_system.v system/one_pulse.v system/svga_timing_generation.v system/timer.v system/vga_controller.v system/video_out.v
TOP_IMPL_MODULE=lc4_system
CONSTRAINTS=system/lab5-superscalar.xdc 
BITSTREAM_FILENAME=superscalar.bit

include ../common/make/vivado.mk
