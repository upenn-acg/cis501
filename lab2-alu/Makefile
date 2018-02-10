# source verilog files
SOURCES=lc4_alu.v lc4_divider.v system/debouncer.v system/delay_ms.v system/OLEDCtrl.v system/SpiCtrl.v system/lc4_system_alu.v
TOP_SYNTH_MODULE=lc4_alu

ZIP_SOURCES=lc4_alu.v lc4_divider.v
ZIP_FILE=alu.zip

# the .xcix files have a reference to the .coe files, which is stale
#IP_BLOCKS=system/ip-cc/charLib.xcix system/ip-cc/init_sequence_rom.xcix system/ip-cc/pixel_buffer.xcix

IP_BLOCKS=system/ip/charLib/charLib.xci system/ip/init_sequence_rom/init_sequence_rom.xci system/ip/pixel_buffer/pixel_buffer.xci
TOP_IMPL_MODULE=lc4_system_alu

# testbench files
TESTBENCH=testbench_lc4_alu.v
TOP_TESTBENCH_MODULE=test_alu

CONSTRAINTS=lab2-alu.xdc 

BITSTREAM_FILENAME=alu.bit

include ../common/make/vivado.mk
