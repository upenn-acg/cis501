# The Superscalar Pipelined Datapath

Your superscalar pipeline must be fully bypassed, and must predict all branches as *not taken* (including JMP, TRAP, and RTI), according to the same rules as your scalar pieline. It should stall only in the load-to-use case and for superscalar hazards. Instead of bypassing from W->D, your register file should bypass its inputs to its outputs. This will be much simpler to implement. The only significant difference in the module definition from previous labs is that there are now *two* instruction input ports. There is still a single port for accessing data memory, however, so you should never dispatch two load/store instructions in parallel.

The initial value of your `pc_reg` in Fetch should be `16'h8200`.

The only time you should stall unnecessarily is on a `BRnzp` instruction that depends on a prior load.

Your datapath must contain the following elements:

+ **Two In-Order Pipelines:** These are referred to as "pipe A" and "pipe B." Pipe B contains the instruction immediately follow the parallel instruction in pipe A (unless pipe B contains a pipeline bubble).
+ **Multi-Ported, Bypassed Register File:** You will need to create a register file with two write ports and four read ports. We have provided the module interface in `lc4_regfile_ss.v` (Note: Port names for the register file *are different from* previous labs!).
   + If both write ports specify the same destination, only pipe B's write should succeed (since the instruction in pipe B follows the instruction in pipe A in program order).
   + Any values being written to the register file should be bypassed to the ouputs (read ports) so that values being written are immediately available. This *eliminates* the need to bypass from Writeback to Decode in the pipeline.
+ **Fetch:** Instead of fetching a single instruction, you will fetch two *consecutive* instructions (i.e. `o_cur_pc` and `o_cur_pc + 1`. The provded skeleton code automatically handles this and gives both instructions to your module.
+ the **test_stall** signal can take on the following values:
   + 0: no stall
   + 1: **superscalar stall** (see below)
   + 2: flushed due to misprediction or because the first real instruction hasn't made it through to the writeback stage yet
   + 3: stalled due to load-to-use penalty
+ **Decode:** Decode both instructions in parallel. Determine if there are any dependencies between them (one depends on a value computed by the other, or if both are load/store instructions). Dispatch the instructions according to the following rules: 
   1. If instruction A incurs a load-to-use stall, insert a NOP into *both* pipes, and stall the fetch and decode stages. Record a load-to-use stall in pipe A and a superscalar stall in pipe B (see below).
   1. If instruction B incurs a load-to-use stall, but does not have any dependencies on instruction A, and instruction A does not stall, insert a NOP into pipeline B and record it as a load-to-use stall.
   1. If instruction B requires a value computed by A (including if A is a load), and instruction A does not stall, insert a NOP into pipe B, and record it as a **superscalar stall**.
   1. If neither instruction incurs a load-to-use stall, and instruction B does not depend on instruction A, then both instructions advance normally.
   1. If you have two independent instructions that interact with memory in the same stage (e.g., two loads, or a load and a store), B incurs a **superscalar stall**, since only one instruction can interact with memory at a time.
   1. If you encounter a case where you could produce a NOP bubble that is either a superscalar or load-to-use stall, the superscalar stall takes precedence.
+ **Dispatch (Fetch/Decode):** When both instructions advance out of the decode stage in parallel, `o_cur_pc` should increase by two (since you just dispatched two instructions). When only one instruction advances out of decode, only one instruction can advance out of fetch. To maintain the illusion of in-order execution, this means instructions need to *switch pipes*: 
   + `decode.insn_A` advances to `execute.insn_A`
   + `decode.insn_B` advances to `decode.insn_A` so that it will be the "first" instruction advancing out of decode on the next cycle.      
   + `fetch.insn_A` advances to `decode.insn_B`. `o_cur_pc` increases by one since only one instruction advanced out of decode.
+ **Execute/Memory/Writeback:** These stages will be essentially identical to your previous lab. If you handled dependencies properly in decode, the there will never be two load/stores in the memory stage at the same time.
+ **Bypass/Squash Logic:** You'll need to bypass between pipes A and B as well as within them. Squashes affect both pipes. **Have fun!!**

## Design Tips

We strongly *discourage* using separate modules for your pipeline stages, let alone for each of the two pipelines. The bypasses are asymmetric, making it very tricky to write, say, a single module for Fetch that you can instantiate twice for the two pipelines.

Be on the lookout in `vivado.log` and `post_synth_drc_report.txt` for **combinational loops**. They can cause simulation to hang.

In the objects pane in the Vivado debugger (accessible via `make debug`), you can use `Ctrl-A` to select all, then open the pop-up menu and set the radix to hexadecimal for everything at once. Most wires are much easier to trace when you view them in hexadecimal rather than binary.

Use the scopes pane in the Vivado debugger to select which module's wires are shown in the objects pane. This lets you see the values within a module to help debug.

**Build your bypass and dispatch logic up step-by-step!** Use intermediate wires for computing each possible bypass, then combine these signals into the final bypassed values. Do the same thing for determining which instructions to dispatch. Most of your bugs are likely to be in this logic, and it will be almost impossible to get "jumbo" expressions working properly if written from scratch.
