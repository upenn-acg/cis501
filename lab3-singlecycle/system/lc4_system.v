/* lc4_system.v
 * DO NOT MODIFY
 */

`timescale 1ns / 1ps
`default_nettype none

module lc4_system(/* Clock */
                  input wire        CLOCK_100MHz,

                  /* VGA ports */
                  output wire       VGA_HSYNCH,
                  output wire       VGA_VSYNCH,
                  output wire [3:0] VGA_OUT_RED,
                  output wire [3:0] VGA_OUT_GREEN,
                  output wire [3:0] VGA_OUT_BLUE,

		  // LEDs, buttons, switches
                  output wire [7:0] LED,
		  input wire        BTN_U,
                  input wire        BTN_D,
                  input wire        BTN_L,
                  input wire        BTN_R,
                  input wire        BTN_C,
                  input wire [7:0]  SWITCH
		  );
   
   wire          RST_BTN_IN;     // Right push button
   wire          GWE_BTN_IN;     // Down push button
   assign RST_BTN_IN = SWITCH[0];
   assign GWE_BTN_IN = 1'b0;

   // CLOCK MANAGEMENT
   wire          GLOBAL_WE;    // global we, toggled to build a single-step clock
   wire          GLOBAL_RST;   // global reset signal
   wire          clocks_ok; 
   wire          clock_processor; // processor clock
   wire          clock_vga; // VGA clock: 25 MHz
   wire          clock_vga_inv; // inverted version of clock_vga

   // Mixed-Mode Clock Manager, see mmcm.v for details
   mmcm_clock_wizard mmcm0 (.clk_in_100MHz(CLOCK_100MHz),
                            .reset(GLOBAL_RST),
                            
                            // outputs:
                            .locked(clocks_ok),
                            .clk_processor(clock_processor),
                            .clk_vga(clock_vga),
                            .clk_vga_inv(clock_vga_inv));
   
   /* Generate "single-step clock" by one-pulsing the global
    write-enable. The one-pulse circuitry cleans up the signal edges
    for us. */
   wire          global_we_pulse;
   one_pulse clk_pulse(.clk( clock_processor ), 
                       .rst( 1'b0 ),
                       .btn( GWE_BTN_IN ), // FPGA buttons are active-low
                       .pulse_out( global_we_pulse ));
   
   /* Clean up trailing edges of the GLOBAL_WE switch input */
   wire          global_we_switch;
   
   Nbit_reg #(1, 0) gwe_cleaner(.in(SWITCH[7]), // FPGA switches are active-low
                                .out( global_we_switch ), 
                                .clk( clock_processor ), 
                                .we( 1'b1 ), 
                                .gwe( 1'b1 ), 
                                .rst( GLOBAL_RST ));
   
   
   wire          i1re, i2re, dre, gwe_out;
   lc4_we_gen we_gen(.clk( clock_processor ),
                     .i1re( i1re ),
                     .i2re( i2re ),
                     .dre( dre ),
                     .gwe( gwe_out ));
   
   
   assign GLOBAL_WE = clocks_ok & (global_we_pulse | (gwe_out & global_we_switch));
   
   
   
   /* Clean up the edges of the manual reset signal. Only the trailing
    edge should really matter, though.*/
   wire          rst_btn;
   Nbit_reg #(1, 0) reset_cleaner(.in( RST_BTN_IN ),
				  .out( rst_btn ), 
                                  .clk( clock_processor ), 
                                  .we( 1'b1 ), 
                                  .gwe( 1'b1 ), 
                                  .rst( 1'b0 ));
   assign GLOBAL_RST = rst_btn;
   
   // MEMORY INTERFACE
   // INSTRUCTIONS
   wire [15:0]   imem1_addr, imem2_addr;
   wire [15:0]   imem1_out, imem2_out;
   // DATA MEMORY
   wire [15:0]   dmem_addr;
   wire [15:0]   dmem_in;
   wire          dmem_we;
   wire [15:0]   dmem_mout;
   
   // DEVICE INTERFACES
   // P/S2 KEYBOARD
   wire          read_kbsr = ~dmem_we & (dmem_addr == 16'hFE00);
   wire          kbsr;
   wire          read_kbdr = ~dmem_we & (dmem_addr == 16'hFE02);
   wire [7:0]    kbdr;
   // TIMER
   wire          read_tsr = ~dmem_we & (dmem_addr == 16'hFE08);
   wire          write_tir = dmem_we & (dmem_addr == 16'hFE0A);
   wire          tsr;
   // VGA
   wire [13:0]   vga_addr;
   wire [15:0]   vga_data;
   
   // MEMORY/DEVICE MUX
   wire [15:0]   dmem_out = dmem_we ? 16'h0000 :
                 (dmem_addr == 16'hFE00) ? {kbsr, {15{1'b0}}} :
                 (dmem_addr == 16'hFE02) ? {8'h00, kbdr} :
                 (dmem_addr == 16'hFE08) ? {tsr, {15{1'b0}}} :
                 (dmem_addr < 16'hFE00) ? dmem_mout : 16'h0000;
   
   
   // PROCESSOR
   // NB: we leave the testing outputs disconnected

   lc4_processor proc_inst(.clk( clock_processor ),
                           .rst(GLOBAL_RST),
                           .gwe(GLOBAL_WE),
                           .o_cur_pc(imem1_addr),
                           .i_cur_insn(imem1_out),
                           .o_dmem_addr(dmem_addr),
                           .i_cur_dmem_data(dmem_out),
                           .o_dmem_we(dmem_we),
                           .o_dmem_towrite(dmem_in),
                           .switch_data(SWITCH),
                           .led_data(LED)
                           );
   
   assign imem2_addr = 16'd0;
   
   // MEMORY
   
   // The memory for bit-mapped video and other I/O. Port a is a read-only
   // port for the VGA video. Port b is a read-write port for memory-mapped
   // I/O data. The addresses used in the memory are only 14 bits because the
   // most-significant bits are always 11. Port b is accessed in the memory
   // stage of a pipeline; memory-mapped I/O is implemented by executing loads
   // and stores to I/O memory.          

   lc4_memory memory (.idclk(clock_processor),
                      .i1re(i1re),
                      .i2re(i2re),
                      .dre(dre),
                      .gwe(GLOBAL_WE),
                      .rst(GLOBAL_RST),
                      .i1addr(imem1_addr),
                      .i2addr(imem2_addr),
                      .i1out(imem1_out),
                      .i2out(imem2_out),
                      .daddr(dmem_addr),
                      .din(dmem_in),
                      .dout(dmem_mout),
                      .dwe(dmem_we),
                      .vaddr({2'b11, vga_addr}),
                      .vout(vga_data),     //VGA data out
                      .vclk(clock_vga)
                      ); 
   
   
   // PS/2 KEYBOARD CONTROLLER
   fake_pb_kbd fake_kbd_inst( .read_kbsr( read_kbsr ),
                              .kbsr( kbsr ), 
                              .read_kbdr( read_kbdr ),
                              .kbdr( kbdr ),
			      .proc_clk( clock_processor ),
			      .reset( GLOBAL_RST ),
                              // TODO: jld unsure these are in the correct order
			      .ZED_PB( {BTN_U, BTN_D, BTN_L, BTN_R, BTN_C} ));
   
   
   // Timer device
   timer_device timer(.write_interval( write_tir ),
                      .interval_in( dmem_in ),
                      .read_status( read_tsr ),
                      .status_out ( tsr ),
                      .GWE(GLOBAL_WE),
                      .RST(GLOBAL_RST),
                      .CLK(clock_processor));
   
   // vga_controller handles the VGA signals.
   vga_controller vga_cntrl_inst(.PIXEL_CLK(clock_vga_inv),
                                 .RESET(GLOBAL_RST),
                                 .VGA_HSYNCH(VGA_HSYNCH),
                                 .VGA_VSYNCH(VGA_VSYNCH),
                                 .VGA_OUT_RED(VGA_OUT_RED),
                                 .VGA_OUT_GREEN(VGA_OUT_GREEN),
                                 .VGA_OUT_BLUE(VGA_OUT_BLUE),
                                 .VGA_ADDR(vga_addr),
                                 .VGA_DATA(vga_data[14:0]));
   
endmodule
