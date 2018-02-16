`timescale 1ns / 1ps
`default_nettype none

  //     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
  //     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
  //     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
  //     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
  //     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
  //     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
  //     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
  //     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
  //     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
  //     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
  //     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
  //     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
  //     FOR A PARTICULAR PURPOSE.
  //
  //     (c) Copyright 2004 Xilinx, Inc.
  //     All rights reserved.
  //
  /*
   -------------------------------------------------------------------------------
   Title      : Video Output Mux
   Project    : XUP Virtex-II Pro Development System
   -------------------------------------------------------------------------------
   File       : VIDEO_OUT.v
   Company    : Xilinx, Inc.
   Created    : 2004/08/12
   Last Update: 2005/06/15
   Copyright  : (c) Xilinx Inc, 2005
   VERSION 1.1
   -------------------------------------------------------------------------------
   Uses       :
   -------------------------------------------------------------------------------
   Used by    : HW_BIST.v
   -------------------------------------------------------------------------------
   Description: This module selects the correct video output data based on the
   line count output of the video timing generator.
   The upper third of the display is character based data and will
   be displayed as white characters. The lower two thirds of the
   display is based on bit mapped data.

   Conventions:
   All external port signals are UPPER CASE.
   All internal signals are LOWER CASE and are active HIGH.


   -------------------------------------------------------------------------------
   */


  /*PJH 1/29/06
   **This module is adapted from the built-in self test, although many of its
   **functions in the self-test have been moved outside of the module. The module
   **generates VGA signals that are passed up through the hierarchy and go directly
   **to the VGA pins. The module is set up for 640x480 @ 60 Hz timing and generates
   **a 128x120 screen of 4x4 pixel blocks (leaving black bars of 64 pixels on the
   **left and right sides of the screen). video_out takes in the pixel and line
   **counts of the 640x480 screen and uses them to calculate a video memory
   **address. The color data (5 bits each for red, green and blue) is retrieved
   **from the video memory and passed back into this module, where the output
   **signals are assigned.
   */

  // PMG: removed outputs not used on the Zedboard
  module video_out(// The following eight signals are output directly to the VGA pins:
                   // PMG: removed outputs not used on Zedboard
                   input  wire        PIXEL_CLOCK,   // 25 MHz pixel clock (for 640x480 @ 60 Hz resolution)
                   input  wire        RESET,         // reset signal (from DCM)
                   output wire        VGA_HSYNCH,    // VGA pin signals
                   output wire        VGA_VSYNCH,
                   output wire [3:0]  VGA_OUT_RED,
                   output wire [3:0]  VGA_OUT_GREEN,
                   output wire [3:0]  VGA_OUT_BLUE,
                   input  wire        H_SYNCH_DELAY,
                   input  wire        V_SYNCH_DELAY,
                   input  wire        BLANK,
                   input  wire [10:0] PIXEL_COUNT,   // position of pixel in line
                   input  wire [ 9:0] LINE_COUNT,    // position of line on screen
                   output wire [13:0] VGA_ADDR,      // address into video memory
                   input  wire [14:0] VGA_DATA       // output of video memory
                   );

   // input to the regs
   wire             VGA_HSYNCH_in;
   wire             VGA_VSYNCH_in;
   wire             VGA_COMP_SYNCH_in;
   wire             VGA_OUT_BLANK_Z_in;
   wire [3:0]       VGA_OUT_RED_in;
   wire [3:0]       VGA_OUT_GREEN_in;
   wire [3:0]       VGA_OUT_BLUE_in;

   // regs themselves, explicitly defined
   Nbit_reg #(1, 1) VGA_HSYNCH_reg (VGA_HSYNCH_in, VGA_HSYNCH, PIXEL_CLOCK, 1'b1, 1'b1, RESET);
   Nbit_reg #(1, 1) VGA_VSYNCH_reg (VGA_VSYNCH_in, VGA_VSYNCH, PIXEL_CLOCK, 1'b1, 1'b1, RESET);
   Nbit_reg #(4, 0) VGA_OUT_RED_reg (VGA_OUT_RED_in, VGA_OUT_RED, PIXEL_CLOCK, 1'b1, 1'b1, RESET);
   Nbit_reg #(4, 0) VGA_OUT_GREEN_reg (VGA_OUT_GREEN_in, VGA_OUT_GREEN, PIXEL_CLOCK, 1'b1, 1'b1, RESET);
   Nbit_reg #(4, 0) VGA_OUT_BLUE_reg (VGA_OUT_BLUE_in, VGA_OUT_BLUE, PIXEL_CLOCK, 1'b1, 1'b1, RESET);

   //make the external video connections, depending on the current
   //pixel location
   assign {	VGA_HSYNCH_in,
			VGA_VSYNCH_in,
			VGA_OUT_RED_in,
			VGA_OUT_GREEN_in,
			VGA_OUT_BLUE_in	}
	 // PMG: Because the Zedboard does not have true DACs, we need to
	 // pull the RGB lines down manually during a blank.
	 = (BLANK == 1'b1) ?
	   {	H_SYNCH_DELAY,
			V_SYNCH_DELAY,
			4'h0,
			4'h0,
			4'h0 }
	   :
	   // <=63 or >=576
	   (PIXEL_COUNT[9:6] == 0 || PIXEL_COUNT[9] == 1'b1 && PIXEL_COUNT[6] == 1'b1)?
	   {	H_SYNCH_DELAY,
			V_SYNCH_DELAY,
			4'h0,
			4'h0,
			4'h0	}
	   :
	   // normal video on the 128x120 block screen
	   {	H_SYNCH_DELAY,
			V_SYNCH_DELAY,
			VGA_DATA[14:11],
			VGA_DATA[9:6],
			VGA_DATA[4:1]	};

   // PMG: we no longer need a pixel clock, as Zedboard has no DACs.


   //VGA_ADDR, the address in video/IO memory that contains the color data
   //for one 4x4 pixel block, is calculated using pixel_count (the "column"
   //of the current pixel) and line_count (the "row"). VGA_ADDR is a 14-bit
   //address.
   wire [9:0]       vga_pixel_count;
   //Logic:
   //PIXEL_COUNT[10:0] counts from 0 to 639
   //LINE_COUNT[9:0] counts from 0 to 479
   //Perform logic using PIXEL_COUNT:
   //if (PIXEL_COUNT <= 63 || PIXEL_COUNT >= 576)
   //  then output black to VGA (leftmost or rightmost 64 pixels/16 blocks)
   //else
   //  vga_pixel_count = PIXEL_COUNT - 64
   //      To align pixel address 64 to memory address 0, we must subtract 64
   //      Then, vga_pixel_count only matters for 0 to 512, so it is only 9
   //      bits wide (not 10 bits, like PIXEL_COUNT)
   //  vga_address[13:7] = LINE_COUNT[8:2];         //MSBs determine row/line
   //  vga_address[6:0]  = vga_pixel_count[8:2];    //LSBs determine col/pixel
   //      We ignore the least-significant 2 bits of the pixel and line counts
   //      because we are using 4-pixel blocks. We use only the lowest 9/7 bits
   //      of vga_pixel_count because it only matters up to 512 pixels/128
   //      blocks, the width of the usable screen.

   assign vga_pixel_count[9:0] = {5'b0, PIXEL_COUNT} - 64;

   assign VGA_ADDR[13:7] = LINE_COUNT[8:2];
   assign VGA_ADDR[6:0]  = vga_pixel_count[8:2];
endmodule // VIDEO_OUT
