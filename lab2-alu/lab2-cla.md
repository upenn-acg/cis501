You'll implement a two-level Carry-Lookahead (CLA) adder, as discussed
extensively in class. This adder will then be used in turn in your ALU
implementation in the final part of this lab.

## Writing your code

We supply some skeleton code in `lc4_cla.v`, for the simple `gp1`
generate-propagate module at the leaf of the CLA hierarchy. You will need to
implement two additional modules to have a complete 16-bit adder. 

You should start with the `gp4` module, which computes aggregate g/p signals for
a 4-bit slice of the addition. The module takes the bit-level g/p signals from
`gp1` as input, and computes whether all 4 bits collectively generate/propagate
a carry. The module also computes the actual carry-out values for the low-order
3b of its input. You should think about why `gp4` doesn't compute 4b worth of
carry-out :-). The `gp4` module will form the middle layer of your CLA
hierarchy, and also the root as it can be used to aggregate the output from the
middle layer. Our `gp4` solution is about 30 lines of code.

Verilog's reduction operators will come in handy in building your `gp4`
module. They perform a bit-wise reduction like so:
```
wire [3:0] w;
wire or_reduction;
assign or_reduction = (| w);
assign or_reduction = (w[3] | w[2] | w[1] | w[0]); // equivalent to code above
```
Reductions can be combined with indexing to reduce just a portion of a bus:
```
wire [3:0] w;
wire or_reduction;
assign or_reduction = (| w[2:0]);
assign or_reduction = (w[2] | w[1] | w[0]); // equivalent to code above
```

Once you have the `gp4` module working, you can move on to the `cla16` module,
which is a full 16-bit adder (with carry-in, but no carry-out). You will need to
assemble the `gp1` and `gp4` modules to build the CLA hierarchy. You will also
need to compute the sum -- the lecture slides focus just on the carry
computation for simplicity. Our `cla16` solution is about 30 lines of code.

## Tests

The testbench for the CLA unit is in `testbench_lc4_alu.v` (this is also the
testbench for the full ALU). You can run all of the tests via the Makefile with
the command `make test`.

We recommend that you comment out irrelevant tests - to start, enable just the
`gp4` tests until your `gp4` module is complete. Then you can turn on the
`cla16` tests. You will also see comments in the testbench about how to exit at
the first failure, which is helpful during debugging.

The `gp4` testbench tests all possible inputs to the module, validating full
functional correctness. This is possible because it has small inputs. For
`cla16` a set of randomly-generated inputs are used because validating all
inputs would take too long. This remains true for future modules - the testing
we can do is increasingly perfunctory.

## Extra Credit

While your `gp4` module only needs to aggregate over a 4-bit window, it is
possible to write more generic code that computes g/p over an arbitrary window
of 2 or more bits. The module interface looks as follows:
```
module gpn
  #(parameter N = 4)
  (input wire [N-1:0] gin, pin,
   input wire  cin,
   output wire gout, pout,
   output wire [N-2:0] cout);
endmodule
```

For a *to-be-determined* amount of extra credit and general goodwill, implement
this parameterized `gpn` module at the bottom of the file `lc4_cla.v`. You can
then use `gpn #(4) g` as your implementation of `gp4` above if you want. This
parameterizable module makes it easier to experiment with different CLA
hierarchies or addition of various widths.

It will require making non-trivial use of `for` loops to generate varying amount
of hardware. Note also that `for` loops can be nested.

We'll test your `gpn` module with various parameterization values of `N>=2`, and
check that your code produces the same output as our reference version. Note
that we are not releasing test cases for `gpn` (though you are welcome to write
your own), and you can see the autograder output as well.

You can submit your `lc4_cla.v` file with your implementation of `gpn` in it via
Canvas, to the separate Lab 2 Extra Credit assignment.

<!---
It seems likely that a 2-level CLA adder that is parameterizable in the width of
the addition (and probably also in the number of first-level `gpn` blocks) can
also be built. This would make it easy to experiment with different CLA
hierarchies to see which are fastest on our ZedBoards.
-->


