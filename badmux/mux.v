
`timescale 1ns / 1ps

// prevents undeclared wires from being inferred
`default_nettype none
  
  module mux_Nbit_4to1
    #(parameter N = 1)
    (input wire  [1:0]   sel,
     input wire [N-1:0]  a,
     input wire [N-1:0]  b,
     input wire [N-1:0]  c,
     input wire [N-1:0]  d,
     output wire [N-1:0] o);

   assign o = (sel == 2'd0) ? a :
              (sel == 2'd1) ? d :
              (sel == 2'd2) ? c : d;
   
endmodule
                       
