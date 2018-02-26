`timescale 1ns / 1ps
`default_nettype none

  // VERSION 1.1

  module timer_device (input  wire        write_interval,
                       input  wire [15:0] interval_in, // value to write to interval register
                       input  wire        read_status,
                       output wire        status_out,  // output of interval or status register (depending on `select*')
                       input  wire        GWE,         // global we
                       input  wire        RST,         // global reset
                       input  wire        CLK
                       ); // system clock

   wire [15:0]                           interval;
   wire [31:0]                           counter, counter_in;

   // INTERVAL REGISTER
   Nbit_reg #(16, 0) interval_reg (.in(interval_in), .out(interval), .we(write_interval), .clk(CLK), .gwe(GWE), .rst(RST));

   // COUNTER REGISTER
   Nbit_reg #(32, 0) counter_reg (.in(counter_in), .out(counter), .we( 1'b1 ), .clk(CLK), .gwe( GWE ), .rst(RST));

   // TIMER LOGIC
   assign     counter_in =
                           (counter[31] == 1'b0) ? counter - 1 :
                           (counter[31] == 1'b1 & read_status) ? {{3{1'b0}}, interval, {13{1'b0}}} :
                           counter;

   assign     status_out = counter[31];




   /* UPDATE SYSTEM_CLOCK FREQUENCY HERE: we "multiply" the interval to
    translate the interval into processor ticks */
   // 8 MHz clock -> 8Mega ticks per ms -> 2^13 ticks per ms
   // log_2(2^13) -> 13
   // Since interval_out is 16 bits, pad the shifted value out to 32 bits: 32 - 16 - 13 -> 3
endmodule
