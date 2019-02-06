# LC4 Register File

The LC4 ISA uses eight registers and follows a two-input, one-output
operation format. As such, the register file should have eight
registers accessed via two read ports and one write port. The lecture
notes contain a four-element register file, so this design is just a
small variant on that, so this part hopefully should not take you
long.

## Your Task

The skeleton `lc4_regfile.v` includes the module declaration and a
commented list of all parameters. You may add any modules you wish,
but you must add them to `lc4_regfile.v` to keep our grading scripts
happy.

We provide an n-bit register module for you in `register.v`.

Note: The `gwe` signal is a global write-enable (a single write-enable
signal that controls every register in the design). For now, just pass
this along into the N-bit register. There is more information about it
in the next step.

## Testing

The testbench for the register file is `testbench_lc4_regfile.v` and
the input trace is `test_lc4_regfile.input`. You can run these tests
via the `make test` command as usual.

## Submitting

You don't submit your register file code separately. You'll use your register file in your single-cycle processor and submit that instead. The register file is broken out into its own directory for simplicity.
