# LC4 Superscalar Register File

**Multi-Ported, Bypassed Register File:** You will need to create a register file with eight registers, two write ports, and four read ports. We have provided the module interface in `lc4_regfile_ss.v`. (Note: Port names for the register file *are different from* previous labs!)
+ If both write ports specify the same destination, only pipe B's write should succeed (since the instruction in pipe B follows the instruction in pipe A in program order).
+ Any values being written to the register file should be bypassed to the outputs (read ports) so that values being written are immediately available. This *eliminates* the need to bypass from Writeback to Decode in the pipeline, outside of the register file.
+ The skeleton `lc4_regfile_ss.v` includes the module declaration and a commented list of all parameters. You may add any modules you wish, but you must add them to `lc4_regfile_ss.v` to keep our grading scripts happy. We provide an n-bit register module for you in `register.v`.
+ The testbench for the register file is `testbench_lc4_regfile_ss.v` and the input trace is `test_lc4_regfile_ss.input`. You can run these tests via the `make test` command as usual.
+ You don't submit your register file code separately. You'll use your register file in your superscalar processor and submit that instead. The register file is broken out into its own directory for simplicity.
