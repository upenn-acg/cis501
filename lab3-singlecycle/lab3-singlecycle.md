# Lab 3: Single-cycle Datapath

Do not start on your processor module until your register file is
fully implemented and tested.

`lc4_single.v` already includes the module declaration with a
commented list of all the inputs and outputs. It also includes the
program counter. You are also free to use the instruction decoder in
`lc4_decoder.v`. The memory unit is handled outside the processor
module and you don't need to worry about it. Any data your current
instruction reads from memory will be provided on the
`i_cur_dmem_data` input to your processor module. You will pass any
data that should be written to the `o_dmem_towrite` output.

For testing purposes, you need to pass several key processor-internal
signals as outputs from your processor module. These outputs are all
declared in the `lc4_processor` module and must be connected properly
for the test scripts to work.

All told, your implementation should need at most 150-200 lines of
Verilog.

## Disallowed Verilog Operators

You will re-use your ALU module from Lab 2. The operators disallowed within these modules are from the previous labs.

You will need an incrementer for the `PC`; for this you can instantiate your `cla16` module. You cannot use the `+` or `-` operators in your `lc4_processor` module.

## Testing and Debugging

At the end of the `lc4_processor` module, we've included an `always`
block to help you debug. This is a block of code that will be executed
sequentially (like software) at the end of each clock cycle, so you
can use it to examine the state of your processor after all signals
have stabilized. Detailed comments are included in the block to
explain how to use it effectively.

We provide a series of test cases for your processor:
+ `test_alu`: random ALU instructions, but no branches, loads, or stores.
+ `test_br`: random branch and ALU instructions, but no loads or stores.
+ `test_mem`: random ALU instructions, loads, and stores, but no branches.
+ `test_ld_br`: random ALU instructions, loads, stores and branches.
+ `test_all`: random ALU instructions of all types except RTI.
+ `house`: a small, non-interactive program that draws the houses from the game Missile Command.
+ `wireframe`: Renders 3 wireframe cubes. This trace is 20 times longer than the others.

You can run a particular test case via a command like this:
```
TEST_CASE=test_mem make test
```


## Demo

### Verify timing closure

You should first verify that your design has reached *timing closure*, which means that the logic you've designed can be run correctly at the clock speed you specify. The clock speed for Lab 3 is currently set at 15.625MHz, which is sufficient for our solution but YMMV.

To verify timing closure, run `make impl`. Then, examine the `output/post_route_timing_summary_report.txt` file that is generated as part of the implementation proces. Look for the section of the report that discusses the timing for the processor's clock, which is unhelpfully named `clk_processor_design_1_clk_wiz_0_0`. This part of the report looks like this:
```
---------------------------------------------------------------------------------------------------
From Clock:  clk_processor_design_1_clk_wiz_0_0
  To Clock:  clk_processor_design_1_clk_wiz_0_0

Setup :            0  Failing Endpoints,  Worst Slack        1.059ns,  Total Violation        0.000ns
Hold  :            0  Failing Endpoints,  Worst Slack        0.175ns,  Total Violation        0.000ns
PW    :            0  Failing Endpoints,  Worst Slack       31.500ns,  Total Violation        0.000ns
---------------------------------------------------------------------------------------------------


Max Delay Paths
--------------------------------------------------------------------------------------
Slack (MET) :             1.059ns  (required time - arrival time)
  Source:                 memory/memory/IDRAM_reg_0_9/CLKBWRCLK
                            (rising edge-triggered cell RAMB36E1 clocked by clk_processor_design_1_clk_wiz_0_0  {rise@0.000ns fall@32.000ns period=64.000ns})
  Destination:            proc_inst/nzp_reg/state_reg[0]/D
                            (rising edge-triggered cell FDRE clocked by clk_processor_design_1_clk_wiz_0_0  {rise@0.000ns fall@32.000ns period=64.000ns})
  Path Group:             clk_processor_design_1_clk_wiz_0_0
  Path Type:              Setup (Max at Slow Process Corner)
  Requirement:            64.000ns  (clk_processor_design_1_clk_wiz_0_0 rise@64.000ns - clk_processor_design_1_clk_wiz_0_0 rise@0.000ns)
  Data Path Delay:        62.631ns  (logic 18.274ns (29.177%)  route 44.357ns (70.823%))
  Logic Levels:           73  (CARRY4=26 LUT2=4 LUT3=4 LUT4=17 LUT5=3 LUT6=18 RAMB36E1=1)
  Clock Path Skew:        -0.241ns (DCD - SCD + CPR)
    Destination Clock Delay (DCD):    -1.537ns = ( 62.463 - 64.000 ) 
    Source Clock Delay      (SCD):    -0.820ns
    Clock Pessimism Removal (CPR):    0.476ns
  Clock Uncertainty:      0.098ns  ((TSJ^2 + DJ^2)^1/2) / 2 + PE
    Total System Jitter     (TSJ):    0.071ns
    Discrete Jitter          (DJ):    0.184ns
    Phase Error              (PE):    0.000ns

    Location             Delay type                Incr(ns)  Path(ns)    Netlist Resource(s)
  -------------------------------------------------------------------    -------------------
  <lots of information here listing the logic elements along the critical path>
```
The part that says `Slack (MET)` and lists a positive value for slack means that timing closure has been achieved: there is a non-negative amount of time (slack) between when signals are ready and when the next rising clock edge arrives.

If your report says `Slack (VIOLATED)` and has a negative value for slack, then **timing closure has not been achieved**, and you need to run with a slower clock (see below).

### Buying yourself some time

If your design does not achieve timing closure with the default 15.625MHz clock, you need to try again with a slower clock. There's no grade penalty for needing a slower clock. We're just interested in seeing what kinds of designs people come up with.

To actually change the clock frequency, edit the file `lab3-singlecycle/system/mmcm.v` at line 139. You can use the slack reported by Vivado to guide your decision about a new frequency to choose. E.g., if your design has a slack of -2ns, then your clock period needs to be ≥66ns instead of the default 64ns. [This online calculator](https://www.sensorsone.com/period-to-frequency-calculator/) is handy for seeing that a clock period of ≥66ns means a frequency ≤15.15MHz. So you could set the parameter `CLKOUT0_DIVIDE_F` to be 66.25, which would yield a resulting clock frequency of 15.09MHz which is sufficiently slow. 

Re-run `make impl` and see if you achieve timing closure with the slower clock. You can also try running `make impl` multiple times, especially if you have a small negative slack, since timing closure may be achievable some of the time due to the nondeterministic choices made by Vivado. Overall, it pays to go with a slower clock than absolutely necessary. There are many ways to ask Vivado to try harder to achieve timing closure (without having to re-run it yourself), but then Vivado takes (even) longer to compile your code.

### Reporting timing results

Once you have timing closure, you can submit results to the **Lab 3: Implementation timing results** assignment on Canvas. Each group member should do this separately, due to Canvas limitations and also to give us more datapoints since Vivado uses randomness extensively.

### Run demo

For the demo, you will write a simple LC4 assembly program that displays a string to the ZedBoard's VGA display. Most of the code has been written for you, but you need to come up with a string you want to display and call appropriate library functions to send the string to the display. In the file `lab3-demo.asm`, you should write assembly code at `PROGRAM_START` to write your desired string. You will find the code in `DRAW_CHAR` function especially helpful, as it takes an ASCII character, translates it into a pixel bitmap, and sends it to the VGA display at the desired x,y coordinates.

It is **highly recommended** that you debug your program with the PennSim simulator from CIS 240. `PennSim.jar` is included in the `common/pennsim/` directory to this end. Conveniently, the video display in PennSim works the same way as the VGA display on the ZedBoard: stores to the memory-mapped display region should have the same effect in both cases.

Once you have a working program, you should load it up as your processor's initial memory state. You can do this by running the following commands:
```
make pennsim
TEST_CASE=lab3-demo make impl
```
The first command uses PennSim to create a `lab3-demo.hex` file containing the code/data memory contents specified by `lab3-demo.asm`. The second command runs implementation, using `lab3-demo.hex` as the initial state for your processor's memory. 

Once you program the ZedBoard, raise the rightmost switch on the ZedBoard (`SW0`) to set the global write-enable (`gwe`) signal. The right-most LED (`LD0`) shows the value of the `gwe` signal. Your processor should start executing, and your string should display on an attached VGA monitor. VGA cables are in the ZedBoard lockers, and there are monitors with VGA inputs in the K Lab and Moore 100A.
