/* testbench_lc4_regfile_ss
 *
 * Testbench for the superscalar register file
 */

`timescale 1ns / 1ps
`default_nettype none

`define EOF 32'hFFFF_FFFF
`define NEWLINE 10
`define NULL 0

`define REGISTER_INPUT "test_lc4_regfile_ss.input"
// `define REGISTER_OUTPUT "regfile_ss_test.output.txt"

module test_regfile;

`include "print_points.v"
   
   integer     input_file, output_file, errors, tests;


   // Global Inputs
   reg         rst;
   reg         clk;
   reg         gwe;
   
   // Pipeline A Inputs
   reg [2:0]   rs_A;
   reg [2:0]   rt_A;
   reg [2:0]   rd_A;

   reg         wen_A;
   reg [15:0]  wdata_A;
   
   // Pipeline A Outputs
   wire [15:0] rs_data_A;
   wire [15:0] rt_data_A;

   // Pipeline B Inputs
   reg [2:0]   rs_B;
   reg [2:0]   rt_B;
   reg [2:0]   rd_B;

   reg         wen_B;
   reg [15:0]  wdata_B;
   
   // Pipeline B Outputs
   wire [15:0] rs_data_B;
   wire [15:0] rt_data_B;
   
   // Instantiate the Unit Under Test (UUT)
   
   lc4_regfile_ss regfile_ss (.i_rs_A(rs_A),
                              .i_rt_A(rt_A),
                              .i_rd_A(rd_A),
                              .o_rs_data_A(rs_data_A),
                              .o_rt_data_A(rt_data_A), 
                              .i_wdata_A(wdata_A),
                              .i_rd_we_A(wen_A),
                              .i_rs_B(rs_B),
                              .i_rt_B(rt_B),
                              .i_rd_B(rd_B),
                              .o_rs_data_B(rs_data_B),
                              .o_rt_data_B(rt_data_B), 
                              .i_wdata_B(wdata_B),
                              .i_rd_we_B(wen_B),
                              .gwe(gwe),
                              .rst(rst),
                              .clk(clk)
                              );
   
   reg [15:0]  expected_rs_A;
   reg [15:0]  expected_rt_A;
   reg [15:0]  expected_rs_B;
   reg [15:0]  expected_rt_B;
   
   always #5 clk <= ~clk;
   
   initial begin
      
      // Initialize Inputs
      rs_A = 0;
      rt_A = 0;
      rd_A = 0;
      wen_A = 0;
      wdata_A = 0;

      rs_B = 0;
      rt_B = 0;
      rd_B = 0;
      wen_B = 0;
      wdata_B = 0;

      rst = 1;
      clk = 0;
      gwe = 1;

      errors = 0;
      tests = 0;
      output_file = 0;

      // open the test inputs
      input_file = $fopen(`REGISTER_INPUT, "r");
      if (input_file == `NULL) begin
         $display("Error opening file: ", `REGISTER_INPUT);
         $finish;
      end

      // open the output file
`ifdef REGISTER_OUTPUT
      output_file = $fopen(`REGISTER_OUTPUT, "w");
      if (output_file == `NULL) begin
         $display("Error opening file: ", `REGISTER_OUTPUT);
         $finish;
      end
`endif
      
      // Wait for global reset to finish
      #100;
      
      #5 rst = 0;
      
      #2;         

      while (14 == $fscanf(input_file, "%d %d %d %b %h %h %h %d %d %d %b %h %h %h", rs_A, rt_A, rd_A, wen_A, wdata_A, expected_rs_A, expected_rt_A, rs_B, rt_B, rd_B, wen_B, wdata_B, expected_rs_B, expected_rt_B)) begin
         
         #8;
         
         tests = tests + 4;
         
         // $display("tests: ", tests);
         
         if (output_file) begin
            $fdisplay(output_file, "%d %d %d %b %h %h %h %d %d %d %b %h %h %h", rs_A, rt_A, rd_A, wen_A, wdata_A, rs_data_A, rt_data_A, rs_B, rt_B, rd_B, wen_B, wdata_B, rs_data_B, rt_data_B);
         end

         if (rs_data_A !== expected_rs_A) begin
            $display("Error at test %d: Value of register %d on output rs_A should have been %h, but was %h instead", tests, rs_A, expected_rs_A, rs_data_A);
            errors = errors + 1;
         end
         
         if (rt_data_A !== expected_rt_A) begin
            $display("Error at test %d: Value of register %d on output rt_A should have been %h, but was %h instead", tests, rt_A, expected_rt_A, rt_data_A);
            errors = errors + 1;
         end

         if (rs_data_B !== expected_rs_B) begin
            $display("Error at test %d: Value of register %d on output rs_B should have been %h, but was %h instead", tests, rs_B, expected_rs_B, rs_data_B);
            errors = errors + 1;
         end
         
         if (rt_data_B !== expected_rt_B) begin
            $display("Error at test %d: Value of register %d on output rt_B should have been %h, but was %h instead", tests, rt_B, expected_rt_B, rt_data_B);
            errors = errors + 1;
         end
         
         #2;         
         
      end // end while
      
      if (input_file) $fclose(input_file); 
      if (output_file) $fclose(output_file);
      $display("Simulation finished: %d test cases %d errors [%s]", tests, errors, `REGISTER_INPUT);
      printPoints(tests, tests - errors);
      $finish;
   end
   
endmodule
