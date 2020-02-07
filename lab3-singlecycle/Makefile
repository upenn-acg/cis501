# synthesis

SYNTH_SOURCES=.set_testcase.v lc4_alu.v lc4_cla.v lc4_decoder.v lc4_divider.v lc4_regfile.v lc4_single.v include/register.v include/lc4_memory.v include/clock_util.v include/delay_eight_cycles.v include/bram.v
TOP_SYNTH_MODULE=lc4_processor

ZIP_SOURCES=lc4_cla.v lc4_alu.v lc4_divider.v lc4_regfile.v lc4_single.v output/singlecycle.bit output/post_route_power_report.txt output/post_route_timing_summary_report.txt output/post_route_utilization_report.txt
ZIP_FILE=single.zip

# testbench

TESTBENCH=testbench_lc4_processor.v
TOP_TESTBENCH_MODULE=test_processor
NEEDS_TEST_CASE=true

# LC4 assembly code

PENNSIM_SCRIPT=lab3-demo.pennsim

# implementation

IMPL_SOURCES=$(SYNTH_SOURCES) system/mmcm.v system/fake_pb_kbd.v system/lc4_system.v system/one_pulse.v system/svga_timing_generation.v system/timer.v system/vga_controller.v system/video_out.v
TOP_IMPL_MODULE=lc4_system
CONSTRAINTS=system/lab3-singlecycle.xdc 
BITSTREAM_FILENAME=singlecycle.bit

include ../common/make/vivado.mk
