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
   Title      : Video Timing Generation
   Project    : XUP Virtex-II Pro Development System
   -------------------------------------------------------------------------------

   File       : SVGA_TIMING_GENERATION.v
   Company    : Xilinx, Inc.
   Created    : 2004/08/12
   Last Update: 2004/08/12
   Copyright  : (c) Xilinx Inc, 2004
   VERSION 1.1
   -------------------------------------------------------------------------------
   Uses       : SVGA_DEFINES.v
   -------------------------------------------------------------------------------
   Used by    : HW_BIST.v
   -------------------------------------------------------------------------------
   Description: This module creates the timing and control signals for the
   VGA output. The module provides character-mapped addressing
   in addition to the control signals for the DAC and the VGA output connector.
   The design supports screen resolutions up to 1024 x 768. The user will have
   to add the charcater memory RAM and the character generator ROM and create
   the required pixel clock.

   The video mode used is defined in the svga_defines.v file.

   Conventions:
   All external port signals are UPPER CASE.
   All internal signals are LOWER CASE and are active HIGH.


   -----------------------------------------------------------------------------
   */

  /*PJH 1/29/06
   **This module comes from the board's built-in self test. I removed all the
   **parts related to character-mapped video and just left the parts needed
   **for bit-mapped video. I did not make any other changes.
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

module svga_timing_generation (input  wire       PIXEL_CLOCK,   // 25 MHz pixel clock (for 640x480, 60 Hz)
                               input  wire       RESET,         // reset signal (from DCM)
                               output reg        H_SYNCH_DELAY, // horizontal sync for VGA connector delayed 2 clocks to line up with DAC pipeline
                               output reg        V_SYNCH_DELAY, // vertical sync   for VGA connector delayed 2 clocks to line up with DAC pipeline
                               output reg        BLANK,         // composite blanking
                               output reg [10:0] PIXEL_COUNT,   // position of pixel in line
                               output reg [ 9:0] LINE_COUNT     // position of line on screen
                               );

   reg        h_synch;        // horizontal synch
   reg        v_synch;        // vertical synch
   reg        h_synch_delay0; // h_synch delayed 1 clock
   reg        v_synch_delay0; // v_synch delayed 1 clock

   reg        h_blank;        // horizontal blanking
   reg        v_blank;        // vertical blanking

   // jld 16 Feb 2018: removed asynchronous resets for PIXEL_COUNT and
   // LINE_COUNT registers because Vivado was complaining about them. The VGA
   // output still seems to work fine.
   
   // CREATE THE HORIZONTAL LINE PIXEL COUNTER
   always @ (posedge PIXEL_CLOCK /*or posedge RESET*/) begin
      if (RESET)
        begin                      // on reset set pixel counter to 0
           PIXEL_COUNT <= 11'h000;
        end

      else if (PIXEL_COUNT == (`H_TOTAL - 1))
        begin                      // last pixel in the line
           PIXEL_COUNT <= 11'h000; // reset pixel counter
        end

      else    begin
         PIXEL_COUNT <= PIXEL_COUNT +1;
      end
   end

   // CREATE THE HORIZONTAL SYNCH PULSE
   always @ (posedge PIXEL_CLOCK or posedge RESET) begin
      if (RESET)
        begin                   // on reset
           h_synch <= 1'b0;        // remove h_synch
        end

      else if (PIXEL_COUNT == (`H_ACTIVE + `H_FRONT_PORCH -1))
        begin                   // start of h_synch
           h_synch <= 1'b1;
        end

      else if (PIXEL_COUNT == (`H_TOTAL - `H_BACK_PORCH -1))
        begin                   // end of h_synch
           h_synch <= 1'b0;
        end
   end

   // CREATE THE VERTICAL FRAME LINE COUNTER
   always @ (posedge PIXEL_CLOCK /*or posedge RESET*/) begin
      if (RESET)
        begin                   // on reset set line counter to 0
           LINE_COUNT <= 10'h000;
        end

      else if ((LINE_COUNT == (`V_TOTAL - 1))&& (PIXEL_COUNT == (`H_TOTAL - 1)))
        begin                   // last pixel in last line of frame
           LINE_COUNT <= 10'h000;      // reset line counter
        end

      else if ((PIXEL_COUNT == (`H_TOTAL - 1)))
        begin                   // last pixel but not last line
           LINE_COUNT <= LINE_COUNT + 1;   // increment line counter
        end
   end

   // CREATE THE VERTICAL SYNCH PULSE
   always @ (posedge PIXEL_CLOCK or posedge RESET) begin
      if (RESET)
        begin                   // on reset
           v_synch = 1'b0;         // remove v_synch
        end

      else if ((LINE_COUNT == (`V_ACTIVE + `V_FRONT_PORCH -1) &&
                (PIXEL_COUNT == `H_TOTAL - 1)))
        begin                   // start of v_synch
           v_synch = 1'b1;
        end

      else if ((LINE_COUNT == (`V_TOTAL - `V_BACK_PORCH - 1)) &&
               (PIXEL_COUNT == (`H_TOTAL - 1)))
        begin                   // end of v_synch
           v_synch = 1'b0;
        end
   end

   // ADD TWO PIPELINE DELAYS TO THE SYNCHs COMPENSATE FOR THE DAC PIPELINE DELAY
   always @ (posedge PIXEL_CLOCK or posedge RESET) begin
      if (RESET)
        begin
           h_synch_delay0 <= 1'b0;
           v_synch_delay0 <= 1'b0;
           H_SYNCH_DELAY  <= 1'b0;
           V_SYNCH_DELAY  <= 1'b0;

        end
      else
        begin
           h_synch_delay0 <= h_synch;
           v_synch_delay0 <= v_synch;
           H_SYNCH_DELAY  <= h_synch_delay0;
           V_SYNCH_DELAY  <= v_synch_delay0;
        end
   end

   // CREATE THE HORIZONTAL BLANKING SIGNAL
   // the "-2" is used instead of "-1" because of the extra register delay
   // for the composite blanking signal
   always @ (posedge PIXEL_CLOCK or posedge RESET) begin
      if (RESET)
        begin                   // on reset
           h_blank <= 1'b0;        // remove the h_blank
        end

      else if (PIXEL_COUNT == (`H_ACTIVE -2))
        begin                   // start of HBI
           h_blank <= 1'b1;
        end

      else if (PIXEL_COUNT == (`H_TOTAL -2))
        begin                   // end of HBI
           h_blank <= 1'b0;
        end
   end

   // CREATE THE VERTICAL BLANKING SIGNAL
   // the "-2" is used instead of "-1"  in the horizontal factor because of the extra
   // register delay for the composite blanking signal
   always @ (posedge PIXEL_CLOCK or posedge RESET) begin
      if (RESET)
        begin                       // on reset
           v_blank <= 1'b0;            // remove v_blank
        end

      else if ((LINE_COUNT == (`V_ACTIVE - 1) &&
                (PIXEL_COUNT == `H_TOTAL - 2)))
        begin                       // start of VBI
           v_blank <= 1'b1;
        end

      else if ((LINE_COUNT == (`V_TOTAL - 1)) &&
               (PIXEL_COUNT == (`H_TOTAL - 2)))
        begin                       // end of VBI
           v_blank <= 1'b0;
        end
   end

   // CREATE THE COMPOSITE BANKING SIGNAL
   always @ (posedge PIXEL_CLOCK or posedge RESET) begin
      if (RESET)
        begin                           // on reset
           BLANK <= 1'b0;              // remove blank
        end

      else if (h_blank || v_blank)        // blank during HBI or VBI
        begin
           BLANK <= 1'b1;
        end
      else begin
         BLANK <= 1'b0;              // active video do not blank
      end
   end

endmodule //SVGA_TIMING_GENERATION
