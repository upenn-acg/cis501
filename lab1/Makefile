ifndef XILINX_VIVADO
$(error ERROR cannot find Vivado, run "source /home1/c/cis371/software/Vivado/2017.4/settings64.sh")
endif

# source verilog file(s)
SOURCES=rca.v

# testbench file(s)
TESTBENCH=rca_testbench.v
TOP_TESTBENCH_MODULE=test_adders

# shorthand variables for constraint files and Tcl scripts
COMMON_DIR=../common
XDC_DIR=$(COMMON_DIR)/xdc
TCL_DIR=$(COMMON_DIR)/tcl

time=time -f "Vivado took %E m:s and %M KB"

# if invoked with no explicit target, print out a help message
.DEFAULT: help
help:
	@echo -e "Valid targets are: synth test debug impl program clean"

# run synthesis to identify code errors/warnings
synth: setup-files $(SOURCES)
	$(time) vivado -mode batch -source $(TCL_DIR)/synthesize.tcl

# run all tests
test: $(SOURCES) $(TESTBENCH)
	rm -rf xsim.dir/
	echo -n verilog mylib $^ > .prj
	xelab -cc gcc --debug typical --prj .prj --snapshot snapshot.sim --lib mylib mylib.$(TOP_TESTBENCH_MODULE)
	xsim snapshot.sim --runall --stats -wdb sim.wdb

# investigate design via GUI debugger
debug: setup-files
	rm -rf .debug-project
	vivado -mode batch -source $(TCL_DIR)/debug.tcl

# run synthesis & implementation to generate a bitstream
impl: setup-files $(SOURCES)
	$(time) vivado -mode batch -source $(TCL_DIR)/implement.tcl

# program the device with user-specified bitstream
program:
	@echo -n "Specify .bit file to use to program FPGA, then press [ENTER]: "
	@read bitfile && export BITSTREAM_FILE=$$bitfile && $(time) vivado -mode batch -notrace -source $(TCL_DIR)/program.tcl

# place arguments to Tcl debug/synthesis/implementation scripts into hidden files
setup-files:
	echo -n $(SOURCES) > .synthesis-source-files
	echo -n rca4 > .top-level-module
	echo -n $(TESTBENCH) > .simulation-source-files
	echo -n $(TOP_TESTBENCH_MODULE) > .top-level-testbench
	echo -n $(XDC_DIR)/physical-leds-switches.xdc > .constraint-files
	echo -n rca4.bit > .bitstream-filename

# remove Vivado logs and our hidden files
clean:
	rm -f webtalk*.log webtalk*.jou vivado*.log vivado*.jou xsim*.log xsim*.jou xelab*.log xelab*.jou vivado_pid*.str usage_statistics_webtalk.*ml
	rm -f .synthesis-source-files .simulation-source-files .top-level-module .top-level-testbench .constraint-files .bitstream-filename .prj
	rm -rf xsim.dir/ .Xil/ xelab.pb 

# clean, then remove output/ directory: use with caution!
extraclean: clean
	rm -rf output/
