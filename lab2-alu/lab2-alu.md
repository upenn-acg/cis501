The LC4 ALU module performs all of the arithmetic and logical
operations for the various instructions. In this lab you'll build a
self-contained ALU datapath with the corresponding control signals.

## ALU Specification

Your code should live in the `lc4_alu` module. This module takes a
16-bit instruction and two 16-bit data values, corresponding to the
two register values, as input, and generates a single 16-bit output:

+ Basic ALU operations (ADD, MUL, SUB, DIV, MOD, AND, NOT, OR, XOR,
SLL, SRA, SRL, CONST, HICONST): output the value that should be
written back to the register file. Use your `lc4_divider` module for
DIV and MOD. **Do not use Verilog's `/` and `%` operators. They will
not synthesize.**
+ Memory operations (LDR, STR): output the generated effective memory address.
+ Comparison instructions (CMP, CMPU, CMPI, CMPIU): Output zero (`0000 0000 0000 0000`), one (`0000 0000 0000 0001`), or negative one (`1111 1111 1111 1111`), depending on the result of the comparison. This will be used later to set the NZP bits.
+ Branch instructions (BR, JMP, JMPR, JSR, RTI, TRAP), the PC of the next instruction *if the branch were to be taken*. The ALU should not decide whether or not the branch actually will be taken, that will be done elsewhere in the datapath.
+ No-op (NOP) should be treated as if it is a branch instruction. When you implement your full datapath, the branch will simply not be taken on NOP instructions.
+ All other operations: output zero (`0000 0000 0000 0000`).

## ALU implementation pointers

+ **Do not start implementing until your schematic is complete!**
+ Implement the basic ALU operations, including `+` and `*` using the built-in Verilog operators.
+ Implement DIV and MOD using your `lc4_divider` module.
+ For shift operations, we recommend a barrel shifter as described in lecture.
+ For comparisons, we recommend extending the input values to 17 bits using zero extension for unsigned comparisons, and sign extension for signed comparisons. Perform the subtraction, then set the output accordingly.

## Testing

The testbench of the ALU is in `testbench_lc4_alu.v`, which internally
uses `lc4_prettyprint_errors.v` and the input trace
`test_lc4_alu.input`.

The testbench reads a series of instructions, PC, register values, and
expected results from the input trace, executes them on your ALU,
compares your result to the expected result, and prints a detailed
error message if the two differ. The error message prints instructions
in assembly format for easier cross-referencing with the [LC4 ISA documentation](http://cis.upenn.edu/~cis371/current/lc4.html).

## ZedBoard demo

TBD