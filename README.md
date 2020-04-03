This is the repository for the labs in [CIS 501: Computer Architecture](http://cis.upenn.edu/~cis501/current/).

# Running the testbench on your local machine

It is possible to run the various test cases on your local machine using an alternative Verilog simulator called [Icarus Verilog](http://iverilog.icarus.com) or `iverilog`. `iverilog` can generate a trace of your design in a `.vcd` file that you can then view in another program called [GTKWave](http://gtkwave.sourceforge.net), which is equivalent to the Vivado debugger. By running on your _local_ machine, you get potentially faster performance and avoid lag and connectivity issues to the biglab machines.

Some caveats:

* There are errors and warnings from `make synth` or `make impl` that **will only be shown by Vivado**. Moreover, **the autograder will continue to run the Vivado tools on biglab**. So there are still reasons to run things on biglab occasionally. 
* Icarus Verilog sometimes stumbles on Verilog code that Vivado is perfectly happy with. So you may need to make small edits to your code to satisfy Icarus. Please post on piazza with problems/workarounds you discover to help others navigate this process.
* It is also possible to install the Vivado compiler locally on a Linux or Windows machine. However it is quite heavyweight, requiring about ~30GB of hard drive space, and the scripts we have for Vivado can only be run on Linux. In contrast, `iverilog` and `gtkwave` combined take about 90MB.

### Linux

Instructions for Ubuntu:

```
sudo apt-get install iverilog gtkwave
cd path-to-your-501-git-repo/whichever-lab-you're-working-on
TEST_CASE=test_alu make iv-test
```

You can then run `gtkwave test_alu.vcd &` to launch the debugger with the execution of `test_alu`.

### Mac OSX

Instructions for the [homebrew package manager](https://brew.sh):

```
brew install icarus-verilog
brew cask install gtkwave
cd path-to-your-501-git-repo/whichever-lab-you're-working-on
TEST_CASE=test_alu make iv-test
```

You can then launch `gtkwave`, and open the `test_alu.vcd` file with `File`=>`New Window`. On Joe's Mac, he can't launch `gtkwave` from the Terminal for some reason but can do so via Spotlight or by navigating to the `/Applications` folder.

### Windows

Install the Windows version of Icarus Verilog from [here](http://bleyer.org/icarus/). Use the `iverilog-v11-20190809-x64_setup` version in particular. During installation, there are two important steps:

1) Choose the **Full installation** option, which installs GTKWave and other code that `iverilog` needs.
![icarus-full-installation](https://raw.githubusercontent.com/upenn-acg/cis501/icarus/images/icarus-full-installation.png)

2) Have your `PATH` updated to include the `iverilog.exe` and `gtkwave.exe` executables.
![icarus-path](https://raw.githubusercontent.com/upenn-acg/cis501/icarus/images/icarus-path.png)

Then, you can open up the Windows command prompt or PowerShell (we recommend the latter) and run:
```
cd path-to-your-501-git-repo\whichever-lab-you're-working-on
iv-test.cmd test_alu
```
This runs the `test_alu` test case and produces a file `test_alu.vcd`. You can substitute other test cases as well. 

You can then open a `.vcd` file in GTKWave to view the signals in your design throughout the entire execution. To launch GTKWave, in our test installation nothing was added to the Start Menu, so there are two options:
* navigate to the Icarus Verilog installation directory that you chose (`C:\iverilog` by default) and then to `gtkwave\bin\gtkwave.exe`. You can open a new `.vcd` file via `File => Open New Window` or `File => Open New Tab`.
* in PowerShell, run `Start-Process -NoNewWindow gtkwave.exe test_alu.vcd`. Just running `gtkwave.exe` runs it in the foreground which blocks the PowerShell session.


### Generating .vcd file on biglab, running GTKWave locally

An alternative workflow is to install only GTKWave on your local computer (see instructions from [the GTKWave website](http://gtkwave.sourceforge.net)), and use Vivado (on biglab) to generate the `.vcd` files that GTKWave can visualize for you. To do this, you need to make a small edit to your lab's `testbench_lc4_processor.v` file, adding this code at the top:
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
