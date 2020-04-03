# The Superscalar Pipelined Datapath

Your superscalar pipeline must be fully bypassed, and must predict all branches as *not taken* (including JMP, TRAP, and RTI), according to the same rules as your scalar pipeline. It should stall only in the load-to-use case and for superscalar hazards. Instead of bypassing from W->D, your register file should bypass its inputs to its outputs. This will be much simpler to implement. The only significant difference in the module definition from previous labs is that there are now *two* instruction input ports. There is still a single port for accessing data memory, however, so you should never dispatch two load/store instructions in parallel.

The initial value of your `pc_reg` in Fetch should be `16'h8200`. **You only need one PC register.**

The only time you should stall unnecessarily is on a `BRnzp` instruction that depends on a prior load. See also the Stalling section for important information about stalling. 

Your datapath must contain the following elements:

+ **Two In-Order Pipelines:** These are referred to as "pipe A" and "pipe B." Pipe B contains the instruction immediately following the parallel instruction in pipe A (unless pipe B contains a pipeline bubble).
+ **Multi-Ported, Bypassed Register File:** You will need to create a register file with two write ports and four read ports. We have provided the module interface in `lc4_regfile_ss.v` (Note: Port names for the register file *are different from* previous labs!).
   + If both write ports specify the same destination, only pipe B's write should succeed (since the instruction in pipe B follows the instruction in pipe A in program order).
   + Any values being written to the register file should be bypassed to the outputs (read ports) so that values being written are immediately available. This *eliminates* the need to bypass from Writeback to Decode in the pipeline.
+ **Fetch:** Instead of fetching a single instruction, you will (normally) fetch two *consecutive* instructions (i.e. `o_cur_pc` and `o_cur_pc + 1`. The provided skeleton code automatically handles this and gives both instructions to your module.
+ the **test_stall** signal can take on the following values:
   + 0: no stall
   + 1: **superscalar stall** (see Stalling section below)
   + 2: flushed due to misprediction or because the first real instruction hasn't made it through to the writeback stage yet
   + 3: stalled due to load-to-use penalty
+ **Decode:** Decode both instructions in parallel. Determine if there are any dependencies between them (one depends on a value computed by the other, or if both are load/store instructions). Note that this is much more complicated than in the previous lab; see the Stalling section below for details. After determining the dependencies, dispatch the instructions, and report the appropriate stall values, according to the rules given in the Stalling section.  
+ **Dispatch (Fetch/Decode):** When both instructions advance out of the decode stage in parallel, `o_cur_pc` should increase by two (since you just dispatched two instructions). When only one instruction advances out of decode, only one instruction can advance out of fetch (and `o_cur_pc` should increase by 1). To maintain the illusion of in-order execution, this means instructions need to *switch pipes*, as outlined in the Pipe Switching section below.
+ **Execute/Memory/Writeback:** These stages will be essentially identical to your previous lab. If you handled dependencies properly in decode, there will never be two load/stores in the memory stage at the same time. Note that the single memory insn can be in either the A or B pipe, however.
+ **Bypassing Logic:** You'll need to bypass between pipes A and B as well as within them. All of the bypasses from Lab 4 will be used here, except for the WD bypass, since that is handled by the new register file. When choosing between `y.A` and `y.B` for the source of the bypass, where `y` is a stage (e.g. Memory), you should prioritize `y.B` since that is the more recent instruction. For example, you should prioritize `M.B` over `M.A` when bypassing to `X`. There is also a new **MM bypass**, which forwards data from the M stage of pipe A to the M stage of pipe B. This is used when you have for example an `ADD` to register `x` followed directly by a `STR` of register `x` (for the data only, not the address!).
+ **Squash Logic:** Pipeline flushes affect both pipes. Note that a branch can be in either `X.A` or `X.B` when it is found to be taken. In either case, when a branch is found to be taken, the stages `F.A`, `F.B`, `D.A` and `D.B` need to be flushed. In addition, if the branch is in `X.A` when it is taken, then the `X.B` stage also must be flushed, since its instruction comes after the branch instruction and is thus incorrect.


## Stalling:  

The stall logic for this lab will be more complex than that of the previous lab. The reason is that now, there are two instructions in execute and two instructions in decode, so there are a lot more possibilities for dependencies between those instructions. 

### Determining dependencies:

There are several dependencies that can occur in the superscalar pipeline:

1. LTU dependence with **dest = `D.A`** (can be within pipe A (from `X.A` **to `D.A`**) or between pipes (from `X.B` **to `D.A`**))
1. LTU dependence with **dest = `D.B`** (can be within pipe B (from `X.B` **to `D.B`**) or between pipes (from `X.A` **to `D.B`** (note: a LTU dependence from `D.A` to `D.B` should be considered part of (3) below)
1. Dependence from `D.A` to `D.B` (including the case where `D.A` is a load)
1. Structural hazard (both `D.A` and `D.B` access memory)

For ease of reference in the next section, in case (1) we say that "`D.A` has a LTU dependence". In case (2) we say that "`D.B` has a LTU dependence". Cases (3) and (4) are called "superscalar dependencies".

Note: It's possible to have more than one dependence present in a given cycle.


### Rules for stalling:

Once you've determined the dependencies, you must determine which pipe(s) to stall, and what to compute as the stall signal in the two decode stages. Here are the rules:

  1. If instruction `D.A` (the insn in the Decode stage in the A pipe) has a LTU dependence, insert a NOP into *both* pipes, and stall the fetch and decode stages. Record a load-to-use stall (stall = 3) in pipe A and a superscalar stall (stall = 1) in pipeline B.
   1. If instruction `D.B` has a LTU dependence, but does not have any dependencies on instruction `D.A`, and instruction `D.A` does not stall, then stall pipeline B only (see Pipe Switching section below) and record a **load-to-use stall** in pipeline B.
   1. If instruction `D.B` requires a value computed by `D.A` (including if `D.A` is a load), and instruction `D.A` does not stall, then stall pipe B only (see Pipe Switching section), and record a **superscalar stall** in pipeline B.
   1. If neither instruction has a load-to-use dependence, and instruction `D.B` does not depend on instruction `D.A`, then both instructions advance normally.
   1. If you have two independent instructions that interact with memory in the same stage (e.g., two loads, or a load and a store), instruction `D.B` incurs a **superscalar stall**, since only one instruction can interact with memory at a time.
   1. If you encounter a case where you could record either a superscalar or load-to-use stall, the superscalar stall takes precedence.
   
Here is a summary of these rules, as a series of questions and answers:

Does `D.A` have a LTU dependence?
+ Yes: record a LTU stall (stall = 3) in pipe A, and a superscalar stall in pipe B (stall = 1) -- even if pipe B has a LTU dependence -- see rule 6 above. Stall the fetch and decode stages of both pipes.
+ No: Does `D.B` require a value computed by `D.A` (even if `D.A` is a load)? Are both `D.A` and `D.B` memory instructions?
   * Yes to either of the above: record a superscalar stall in pipe B and stall only pipe B (see Pipe Switching section below).
   * No to both of the above: Does `D.B` have a LTU dependence?
     - Yes: Record a LTU stall in pipe B, and stall only pipe B (see Pipe Switching section).
     - No: No stalling. Both instructions advance normally.

### Pipe Switching

As mentioned above, whenever **only** Pipe B stalls, you need to perform pipe switching. Here is what this involves: 
  + `D.insn_A` advances to `X.insn_A`
  + `D.insn_B` advances to `D.insn_A` so that it will be the "first" instruction advancing out of decode on the next cycle. 
  + `F.insn_A` advances to `D.insn_B`.
  + `o_cur_pc` increases by one since only one instruction advanced out of decode.
  + Execute, Memory, and Writeback instructions advance normally.
  
What about `F.insn_B`? Note that, since the PC increases by 1, the current `F.insn_B` will be fetched again in the next cycle, but this time into `F.insn_A`. This takes care of moving `F.insn_B` to `F.insn_A`.
  
Below is an illustration of the procedure (the numbers represent instructions).

**Before pipe-switching:**

`PC = 9`

|     | F     | D     | X     | M     | W     |
| --- | ----- | ----- | ----- | ----- | ----- |
| A:  | 9     | 7     | 5     | 3     | 1     |
| B:  | 10    | 8     | 6     | 4     | 2     |

**After pipe-switching:**

`PC = 10`

|     | F     | D     | X     | M     | W     |
| --- | ----- | ----- | ----- | ----- | ----- |
| A:  | 10    | 8     | 7     | 5     | 3     |
| B:  | 11    | 9     | NOP   | 6     | 4     |

  
Note: The above needs to happen *whenever only Pipe B stalls*. This could be for a LTU dependence that makes pipe B stall, or because `D.B` depends on a value computed by pipe `D.A`.

### Important note on LTU stalling:

When determining whether to stall based on a LTU dependence between instructions, there are some subtleties to look out for. For example, suppose we have the following sequence of instructions:

    1. LDR r0 = [r1+8]
    2. ADD r0 = r2 + #1
    3. SUB r3 = r0 - #1

Even though the `LDR` writes to a register that the `SUB` then reads from, the intermediate `ADD` instruction also writes to this same register, effectively overwriting the value written by the `LDR`. Thus, the dependence between instructions 1 and 3 is "nullified", and no stall should be necessitated. What this means is that when you're determining whether to stall, be sure to check that intervening instructions don't nullify those dependencies. For concreteness, let's consider how the above instructions might look inside the pipeline. Consider two possible ways the instructions could be arranged in the pipeline (note that in the tables below, "insn" stands for some arbitrary independent insn that doesn't affect the stalling). Here's one way:

|     | F     | D     | X     | M     | W     |
| --- | ----- | ----- | ----- | ----- | ----- |
| A:  | insn  | **ADD** | insn  | insn  | insn  |
| B:  | insn  | SUB   | LDR   | insn  | insn  |

From this picture, you can see that if you have a LTU dependence from `X.B` to `D.B` involving a register `R`, you should check that there isn't *also* a dependence between **`D.A`** and `D.B` involving the same register `R`, since the latter dependence would nullify the former one.

<!--- In this case, if we don't bother to do the check, it's actually okay. Although there are two different dependencies, there is no ambiguity in what to do as far as stalling: Pipe B (and only pipe B) needs to be stalled in the next cycle. Nor is there ambiguity in what to report as the stall signal: By rule 3 above, we should record a **superscalar** stall for pipe B (**not** a LTU stall). Note that rule 2 doesn't apply, because in this case, even though `Decode.B` incurs a load-to-use stall, it also has a dependence on `Decode.A`. ---> 

Now consider another possible configuration:

|     | F     | D     | X     | M     | W     |
| --- | ----- | ----- | ----- | ----- | ----- |
| A:  | insn  | SUB   | LDR   | insn  | insn  |
| B:  | insn  | insn  | **ADD** | insn  | insn  |

From this picture, you can see that if you have a LTU dependence from `X.A` to `D.A` involving a register `R`, you should check that there isn't *also* a dependence between **`X.B`** and `D.A` involving the same register `R`, since the latter dependence would nullify the former one.

**Note:** This same principle also applies when you have a LTU dependence from `X.A` to `D.B`, but in this case there are *two* intervening instructions you should check!

## Design Tips

We strongly *discourage* using separate modules for your pipeline stages, let alone for each of the two pipelines. The bypasses are asymmetric, making it very tricky to write, say, a single module for Fetch that you can instantiate twice for the two pipelines.

Be on the lookout in `vivado.log` and `post_synth_drc_report.txt` for **combinational loops**. They can cause simulation to hang.

In the objects pane in the Vivado debugger (accessible via `make debug`), you can use `Ctrl-A` to select all, then open the pop-up menu and set the radix to hexadecimal for everything at once. Most wires are much easier to trace when you view them in hexadecimal rather than binary.

Use the scopes pane in the Vivado debugger to select which module's wires are shown in the objects pane. This lets you see the values within a module to help debug.

**Build your bypass and dispatch logic up step-by-step!** Use intermediate wires for computing each possible bypass, then combine these signals into the final bypassed values. Do the same thing for determining which instructions to dispatch. Most of your bugs are likely to be in this logic, and it will be almost impossible to get "jumbo" expressions working properly if written from scratch.

## Demo

There is no demo for this lab.
