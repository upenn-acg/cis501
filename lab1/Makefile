ifndef XILINX_VIVADO
$(error ERROR cannot find Vivado, run "source /home1/c/cis371/software/Vivado/2017.4/settings64.sh")
endif

# source verilog files
SOURCES=rca.v

# testbench file
TESTBENCH=rca_testbench.v

# shorthand variables for constraint files and Tcl scripts
COMMON_DIR=../common
XDC_DIR=$(COMMON_DIR)/xdc
TCL_DIR=$(COMMON_DIR)/tcl

time=time -f "Vivado took %E m:s and %M KB"

# if invoked with no explicit target, print out a help message
.DEFAULT: help
help:
	@echo -e "Valid targets are:\n  synth\n  sim\n  impl\n  clean"

# run synthesis to identify code errors/warnings
synth: setup-files $(SOURCES)
	$(time) vivado -mode batch -source $(TCL_DIR)/synthesize.tcl

snapshot.sim: $(SOURCES) $(TESTBENCH)
	rm -rf xsim.dir/
	echo -n verilog mylib $^ > .prj
	xelab -cc gcc --debug typical --prj .prj --snapshot $@ --lib mylib mylib.test_adders

# run all tests
test: snapshot.sim
	xsim $^ --runall --stats -wdb sim.wdb

# investigate waveforms via xsim GUI
wave: snapshot.sim
	xsim $^ --gui -wdb sim.wdb # investigate waveforms via GUI

# run synthesis & implementation to generate a bitstream
impl: setup-files $(SOURCES)
	$(time) vivado -mode batch -source $(TCL_DIR)/implement.tcl

# program the device with user-specified bitstream
program:
	@echo -n "Specify .bit file to use to program FPGA, then press [ENTER]: "
	@read bitfile && export BITSTREAM_FILE=$$bitfile && $(time) vivado -mode batch -notrace -source $(TCL_DIR)/program.tcl

# place arguments to Tcl synthesis/implementation scripts into hidden files
setup-files:
	echo -n $(SOURCES) > .synthesis-source-files
	echo -n rca4 > .top-level-module
	echo -n $(XDC_DIR)/physical-leds-switches.xdc > .constraint-files
	echo -n rca4.bit > .bitstream-filename

# remove Vivado logs and our hidden files
clean:
	rm -f webtalk*.log webtalk*.jou vivado*.log vivado*.jou xsim*.log xsim*.jou xelab*.log xelab*.jou vivado_pid*.str usage_statistics_webtalk.*ml
	rm -f .synthesis-source-files .top-level-module .constraint-files .bitstream-filename .prj
	rm -rf xsim.dir/ .Xil/ xelab.pb 

# clean, then remove output/ directory: use with caution!
extraclean: clean
	rm -rf output/
