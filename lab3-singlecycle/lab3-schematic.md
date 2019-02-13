# Lab 3: Single-cycle Datapath Schematic

You must create schematics of your **register file** and **control+datapath**, with all wires, ports, and module instantiations labeled. Examine the template code in the other lab3 directories to see what the interface to the `lc4_regfile`, `lc4_processor` and other modules is.

This schematic will be *much* more complex than your ALU, so it is essential that your schematic has the necessary detail and legibility to help you implement the single-cycle datapath.

Your schematics may be hand-drawn or computerized (most people feel hand-drawn is faster). It's fine to make your wiring table on the computer — we recommend using Google Sheets or a similar collaborative spreadsheet. Remember that your schematics must be legible and tolerably neat, but they do not have to be beautiful. There is certainly no need to use a straight-edge unless you want to.

+ You **do not** have to include the `rst` and `gwe` ports and wires on these schematics. You **do** need to mark the clock port (with a little triangle), but you do not need to draw the clock wires.
+ You **do not** need to redraw or resubmit the ALU and divider schematics, since you presumably are not re-implementing that code. It's fine to draw the ALU as a box with its ports.
+ You **do not** need to make schematics of the memory or the instruction decoder since we provide them for you.
+ You **do not** need to include the `switch_data`, `seven_segment_data`, and `led_data` wires in your schematic
+ You **do** need to include the branch logic.
+ You **do** need to include the `test_*` wires on your schematic. Getting these right the first time around can save you hours of debugging. (`test_stall` is hard-wired to 0 on this lab, but include it in the schematic anyway.)
+ We strongly recommend including a wiring table that lists every wire in your datapath, its bus width, its source, and its destination. For wires that connect directly to the port of a functional unit, list the units name as declared in your Verilog code, and the port name. This may seem redundant but it will save you more time during Verilog implementation than it takes you to make it. If you make a wiring table, you can assign a number to each wire and put the numbers on the schematic rather than the names.
+ Label wires that you do not need to declare explicitly in your Verilog code (e.g. because they are implicitly created by a `?` expression) with an asterisk (*).
+ It's fine **and advisable** to break your schematic up into multiple parts. It's also fine to have an overview schematic that is not scrupulously labeled, and closeups of different parts or functional units with the full labeling.
+ It's fine to number the rows in your wiring table, and give these numbers on the wires and ports in your schematic instead of writing the full names. If you do this for your ports, make sure the schematic clearly indicates whether it is an input or output port (e.g. with arrows on the wires). When you label multi-bit buses this way, you should still indicate the bus width on the schematic.
+ It's fine to draw a wire leaving one unit and entering another one, without drawing the line in between when it would be a long, confusing line. Make sure to label the wire and bus width in both cases. This is preferable to drawing the same functional unit (e.g. register file) in multiple places. (However the instruction memory and data memory *are* separate units, so you should draw both.)
+ It's a good idea to color-code your wires. One possibility is to color them based on purpose: data, control, test, ...
+ **Pick a consistent and precise naming scheme for your wires and functional units!** Keep in mind that virtually every wire in this lab will become **10** similarly named wires in your superscalar pipeline. If you pick confusing, ambiguous, or indistinct names for your wires and functional units now, you will regret it in later labs. So don't pick a name like `ctrl1` for the control signal for a mux, but instead something more descriptive like `ctrlALUInput1`.
