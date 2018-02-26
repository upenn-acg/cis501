`timescale 1ns / 1ps
`default_nettype none

  module delay_eight_cycles #(parameter n=1) (
                    input wire          clk,
                    input wire          gwe,
                    input wire          rst,
                    input wire [n-1:0]  in_value,
                    output wire [n-1:0] out_value
                    );

   wire [n-1:0] value_1_2;
   wire [n-1:0] value_2_3;
   wire [n-1:0] value_3_4;
   wire [n-1:0] value_4_5;
   wire [n-1:0] value_5_6;
   wire [n-1:0] value_6_7;
   wire [n-1:0] value_7_8;
   wire [n-1:0] value_8_9;

   Nbit_reg #(n) stage_1 (.in(in_value), .out(value_1_2), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_2 (.in(value_1_2),.out(value_2_3), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_3 (.in(value_2_3), .out(value_3_4), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_4 (.in(value_3_4), .out(value_4_5), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_5 (.in(value_4_5), .out(value_5_6), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_6 (.in(value_5_6), .out(value_6_7), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_7 (.in(value_6_7), .out(value_7_8), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));
   Nbit_reg #(n) stage_8 (.in(value_7_8), .out(value_8_9), .clk(clk), .we(1'd1), .gwe(gwe), .rst(rst));

   assign out_value = value_8_9;
endmodule
