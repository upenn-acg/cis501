`timescale 1ns / 1ps
`default_nettype none

/* PMG: This module is a divide-by-8 clock divider implemented
 using a counter.  We use this because we only have one clock
 available on the Zedboard (100 MHz) to feed to a DCM, and dividing
 down to 2MHz is beyond the possible range.  The output clock
 net is fed through a BUFG internally.
 */
 module clkdiv(input  wire clk_16MHz,
               input  wire reset,
               output wire clk_2MHz
               );

   wire [2:0] counter, counter_in;

   Nbit_reg #(3,0) count_reg(.in(counter_in), .out(counter),
							 .clk(clk_16MHz), .we(1'b1),
							 .gwe(1'b1), .rst(reset));

   assign counter_in = counter + 3'b001;

   // Buffer the output clock
   BUFG clk_bufg(.O(clk_2MHz), .I(counter[2]));
endmodule
