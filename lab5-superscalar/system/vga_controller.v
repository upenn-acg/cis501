`timescale 1ns / 1ps

`default_nettype none

// VERSION 1.1

/*PJH 1/29/06
 **This module connects the video_out and svga_timing_generation modules. It
 **could probably be removed and its parts moved into the higher level of the
 **hierarchy.
 */

// DEFINE THE VARIOUS PIPELINE DELAYS
//(Do not change these when changing resolutions)
`define ZBT_PIPELINE_DELAY  0
`define ZBT_INTERFACE_DELAY     0
`define CHARACTER_DECODE_DELAY  5


//  640 X 480 @ 60Hz with a 25.175MHz pixel clock
`define H_ACTIVE        640 // pixels
`define H_FRONT_PORCH   16  // pixels
`define H_SYNCH         96  // pixels
`define H_BACK_PORCH    48  // pixels
`define H_TOTAL         800 // pixels

`define V_ACTIVE        480 // lines
`define V_FRONT_PORCH   11  // lines
`define V_SYNCH         2   // lines
`define V_BACK_PORCH    31  // lines
`define V_TOTAL         524 // lines

// PMG: removed outputs not used on the Zedboard
module vga_controller(input  wire        PIXEL_CLK,     // 25 MHz pixel clock (640x480 @ 60 Hz resolution)
                      input  wire         RESET,         // global reset signal

                      // PJH: these 8 ports are the only outputs needed for the DAC (VGA port):
                      // PMG: removed outputs not used on the Zedboard
                      output wire        VGA_HSYNCH,    // horizontal sync for the VGA output connector
                      output wire        VGA_VSYNCH,    // vertical sync for the VGA output connector
                      output wire [3:0]  VGA_OUT_RED,   // RED DAC data
                      output wire [3:0]  VGA_OUT_GREEN, // GREEN DAC data
                      output wire [3:0]  VGA_OUT_BLUE,  // BLUE DAC data

                      output wire [13:0] VGA_ADDR,      // address to retrieve color from vid. memory
                      input  wire [14:0]  VGA_DATA       // block color data from video memory
                      );

   // internal video timing signals
   wire        h_synch_delay;
   wire        v_synch_delay;
   wire        blank;
   wire [10:0] pixel_count; // pixel position within a line
   wire [9:0]  line_count;  // line number in a frame

   //video_out generates the VGA signals using the pixel clock, pixel and line
   //counts, etc, using bit-mapped video memory.
   // PMG: removed outputs not used on the Zedboard
   video_out v_out_inst(.PIXEL_CLOCK(PIXEL_CLK),
                        .RESET(RESET),
                        .VGA_HSYNCH(VGA_HSYNCH),
                        .VGA_VSYNCH(VGA_VSYNCH),
                        .VGA_OUT_RED(VGA_OUT_RED),
                        .VGA_OUT_GREEN(VGA_OUT_GREEN),
                        .VGA_OUT_BLUE(VGA_OUT_BLUE),
                        .H_SYNCH_DELAY(h_synch_delay),
                        .V_SYNCH_DELAY(v_synch_delay),
                        .BLANK(blank),
                        .PIXEL_COUNT(pixel_count),
                        .LINE_COUNT(line_count),
                        .VGA_ADDR(VGA_ADDR),
                        .VGA_DATA(VGA_DATA[14:0])
                        );

   //svga_timing_generation generates the VGA timing signals using the pixel
   //clock.
   svga_timing_generation svga_t_g(.PIXEL_CLOCK(PIXEL_CLK),            //input
                                   .RESET(RESET),                      //input
                                   .H_SYNCH_DELAY(h_synch_delay),      //rest are outputs
                                   .V_SYNCH_DELAY(v_synch_delay),
                                   .BLANK(blank),
                                   .PIXEL_COUNT(pixel_count),
                                   .LINE_COUNT(line_count)
                                   );

endmodule
