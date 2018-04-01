`timescale 1ns / 1ps
`default_nettype none

// VERSION 1.1

module count #(parameter n = 2) (input wire clk, output wire [n-1:0] out);
   reg [n-1:0]         q;

   initial begin
      q = 0;
   end

   always @(posedge clk)
     begin
        q = (q==2**n) ? 0 : q+1;
     end
   assign #(1) out = q;
endmodule

module lc4_we_gen(input  wire clk,
                  output wire i1re,
                  output wire i2re,
                  output wire dre,
                  output wire gwe
                  );

   //generate gwe, ire, and dre signals by counting the small clock
   wire [1:0]  clk_counter;

   count #(2) global_we_count(.clk( clk ),
                              .out( clk_counter ));

   assign i1re = (clk_counter == 2'd0);
   assign i2re = (clk_counter == 2'd1);
   assign dre = (clk_counter == 2'd2);
   assign gwe = (clk_counter == 2'd3);
endmodule // lc4_we_gen
