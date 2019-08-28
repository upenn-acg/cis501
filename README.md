This is the repository for the labs in [CIS 501: Computer Architecture](http://cis.upenn.edu/~cis501/current/).

## Description of files in common/ directory

#### common/make/vivado.mk
The Makefile that does all the real work. Each lab's Makefile (e.g., `lab1/Makefile`) defines variables that are used by `vivado.mk` to run synthesis, implementation, simulation, etc as needed for that lab. Not all labs support all possible targets. E.g., some labs are synthesis- and simulation-only because they don't connect to any ZedBoard I/O pins. Other labs do use these pins to interact with the outside world and thus support implementation.

#### common/pennsim/PennSim.jar
A copy of the PennSim simulator for CIS 240. Used to assemble LC4 code into a .hex file representation that can be loaded into a Verilog memory.

#### common/sdcard-boot/zynq_fsbl_0.elf
The "first-stage boot loader" for the ZedBoard. This executable will program the FPGA on power-up via a bitstream stored on an SD Card. Useful for programming the FPGA without direct access to Vivado. Note that the ZedBoard's jumpers must be set appropriately:
* MIO 6: set to GND
* MIO 5: set to 3V3
* MIO 4: set to 3V3
* MIO 3: set to GND
* MIO 2: set to GND
* VADJ Select (J18): Set to 1V8
* JP6: shorted
* JP2: shorted
* All other jumpers should be left unshorted.

#### Tcl scripts
`common/tcl/build.tcl` Tcl script for Vivado batch mode to perform synthesis, and optionally implementation, for a lab.

`common/tcl/debug.tcl` Tcl script for Vivado GUI mode to launch the Vivado debugger on the testbench for a lab.

`common/tcl/program.tcl` Tcl script for Vivado batch mode to program an FPGA attached to the local computer.

#### common/xdc/zedboard_master.xdc
The master list of the physical pins on the ZedBoard, along with their functionalities and required voltages. Used as a reference to create constraint files for each lab.
