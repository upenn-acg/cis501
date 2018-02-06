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
signals as outputs from you processor module. These outputs are all
declared in the `lc4_processor` module and must be connected properly
for the test scripts to work.

All told, your implementation should need at most 150-200 lines of
Verilog.

## Testing and Debugging

At the end of the `lc4_processor` module, we've included an `always`
block to help you debug. This is a block of code that will be executed
sequentially (like software) at the end of each clock cycle, so you
can use it to examine the state of your processor after all signals
have stabilized. Detailed comments are included in the block to
explain how to use it effectively.

We provide a series of test benches for your processor, which you can
select by uncommenting the appropriate line in `set_testcase.v`.

TODO: You will need to restart the simulation after you change test
cases, but you shouldn't need to re-synthesize or re-simulate. The
test cases are:

+ `test_alu`: random ALU instructions, but no branches, loads, or stores.
+ `test_br`: random branch and ALU instructions, but no loads or stores.
+ `test_mem`: random ALU instructions, loads, and stores, but no branches.
+ `test_all`: random ALU instructions of all types except RTI.
+ `house`: a small, non-interactive program that draws the missile command houses on an attached VGA display. (You can simulate this in Vivado, but you'll need to program the Zedboard and hook up a display to see the drawing.)
+ `wireframe`: Renders 3 wireframe cubes. This trace is 20 times longer than the others. (Program the Zedboard and hook up a display to see the drawing. Use the +-shaped button pad on the Zedboard to rotate the cubes.)

## Demo

TBD