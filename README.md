This is the repository for the labs in [CIS 501: Computer Architecture](http://cis.upenn.edu/~cis501/current/).

# Running the testbench on your local machine

It is possible to run the various test cases on your local machine using an alternative Verilog simulator called [Icarus Verilog](http://iverilog.icarus.com) or `iverilog`. `iverilog` can generate a trace of your design in a `.vcd` file that you can then view in another program called [GTKWave](http://gtkwave.sourceforge.net), which is equivalent to the Vivado debugger. By running on your _local_ machine, you get potentially faster performance and avoid lag and connectivity issues to the biglab machines. 

There are errors and warnings from `make synth` or `make impl` that **will only be shown by Vivado**. Moreover, **the autograder will continue to run the Vivado tools on biglab**. So there are still reasons to run things on biglab occasionally. But the bulk of your debugging can likely be done without biglab.

It is also possible to install the Vivado compiler locally on a Linux or Windows machine. However it is quite heavyweight, requiring about ~30GB of hard drive space. `iverilog` and `gtkwave` combined, however, take about 10MB (admittedly, excluding other packages they depend on).

### Linux

Instructions for Ubuntu:

```
sudo apt-get install iverilog gtkwave
cd path-to-your-501-git-repo/whichever-lab-you're-working-on
TEST_CASE=test_alu make iv-test
```

You can then launch `gtkwave`, and open the `test_alu.vcd` file with `File`=>`New Window`.

### Mac OSX

Instructions for the [homebrew package manager](https://brew.sh):

```
brew install icarus-verilog
brew cask install gtkwave
cd path-to-your-501-git-repo/whichever-lab-you're-working-on
TEST_CASE=test_alu make iv-test
```

You can then launch `gtkwave`, and open the `test_alu.vcd` file with `File`=>`New Window`.

### Windows 10

You should be able to install Icarus Verilog using the Windows Subsystem for Linux (WSL). See [the instructions from Microsoft](https://docs.microsoft.com/en-us/windows/wsl/install-win10) for installing WSL. Supposing you choose a version of Ubuntu, you should then be able to run, from inside your Ubuntu installation:

```
sudo apt-get install iverilog
```

We recommend then installing `gtkwave` in Windows (not in WSL), since it is a GUI app and getting Linux GUI apps running in WSL requires some extra steps. You can find `gtkwave` installers for Windows at [the GTKWave website](http://gtkwave.sourceforge.net).

Back in Ubuntu, you can then run:
```
cd path-to-your-501-git-repo/whichever-lab-you're-working-on
TEST_CASE=test_alu make iv-test
```
This produces a file `test_alu.vcd` that you can transfer to Windows, and open with GTKWave there.


### Generating .vcd file on biglab, running GTKWave locally

An alternative workflow is to install only GTKWave on your local computer, and use Vivado (on biglab) to generate the `.vcd` files that GTKWave can visualize for you. To do this, you need to make a small edit to your lab's `testbench_lc4_processor.v` file, adding this code at the top:
```
`define GENERATE_VCD 1
```

Then, whenever you run `make test` a `.vcd` file, named after the test case you ran, will be generated. Note that these files can be large -- `wireframe.vcd` is about 1GB in size. We recommend compressing these `.vcd` files with `gzip`, or transferring them via `scp -C` which transparently compresses files before sending (and decompresses them on the receiving end as well), which reduces their size by about 6x.


# Description of files in common/ directory

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
