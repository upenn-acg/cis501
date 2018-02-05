/* register.v
 * A parameterized-width positive-edge-trigged register, with synchronous reset. 
 * The value to take on after a reset is the 2nd parameter.
 * 
 * DO NOT MODIFY
 */

`timescale 1ns / 1ps
`default_nettype none

/* A parameterized-width positive-edge-trigged register, with synchronous reset. 
   The value to take on after a reset is the 2nd parameter. */

module Nbit_reg #(parameter n=1, r=0)
   (input  wire [n-1:0] in,
    output wire [n-1:0] out,
    input  wire         clk,
    input  wire         we,
    input  wire         gwe,
    input  wire         rst
    );

   reg [n-1:0] state;

   assign #(1) out = state;

   always @(posedge clk) 
     begin 
       if (gwe & rst) 
         state = r;
       else if (gwe & we) 
         state = in; 
     end
endmodule
