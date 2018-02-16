`timescale 1ns / 1ps
`default_nettype none

`ifndef ONE_PULSE_V
 `define ONE_PULSE_V

// VERSION 1.1

/* Counter-based implementation of signal de-bouncer.  pulse_out has a
 value of 1 254 clock ticks after btn transitions from 1 to 0.
 Previous implementation based on consecutive latches was susceptible
 to button release bounces and would sometimes generate multiple pulses.
 The counter based implemenation lets the bounces settle before
 generating a signal.  -AR
 */

module one_pulse(input wire clk,
                 input wire  rst,
                 input wire  btn,
                 output wire pulse_out);

   wire [7:0]                counter, counter_in;

   Nbit_reg #(8, 0) pulse_reg (.clk(clk), .rst(rst), .we(1'b1), .gwe(1'b1),
                               .in(counter_in), .out(counter));

   assign counter_in = (btn) ? 8'd255 :
                       (counter != 8'd0) ? counter - 8'd1 : counter;

   assign pulse_out = ~btn & (counter == 8'd1);
endmodule // one_pulse

`endif
