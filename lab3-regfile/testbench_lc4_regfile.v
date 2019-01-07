/* test_lc4_regfile
 *
 * Testbench for the register file
 */

`timescale 1ns / 1ps
`default_nettype none

`define EOF 32'hFFFF_FFFF
`define NEWLINE 10
`define NULL 0

`define REGISTER_INPUT "test_lc4_regfile.input"
`define REGISTER_OUTPUT "regfile_test.output.txt"

module test_regfile;

`include "print_points.v"
   
   integer     input_file, output_file, errors, tests;


   // Inputs
   reg         wen;
   reg         rst;
   reg         clk;
   reg         gwe;
   
   reg [2:0]   rs;
   reg [2:0]   rt;
   reg [2:0]   rd;
   
   reg [15:0]  wdata;
   
   // Outputs
   wire [15:0] rs_data;
   wire [15:0] rt_data;
   
   // Instantiate the Unit Under Test (UUT)
   
   lc4_regfile regfile (.i_rs(rs),
                        .i_rt(rt),
                        .i_rd(rd),
                        .o_rs_data(rs_data),
                        .o_rt_data(rt_data), 
                        .i_wdata(wdata),
                        .i_rd_we(wen),
                        .gwe(gwe),
                        .rst(rst),
                        .clk(clk)
                        );
   
   reg [15:0]  expectedValue1;
   reg [15:0]  expectedValue2;
   
   always #5 clk <= ~clk;
   
   initial begin
      
      // Initialize Inputs
      rs = 0;
      rt = 0;
      rd = 0;
      wen = 0;
      rst = 1;
      wdata = 0;
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

      while (7 == $fscanf(input_file, "%d %d %d %b %h %h %h", rs, rt, rd, wen, wdata, expectedValue1, expectedValue2)) begin
         
         #8;
         
         tests = tests + 2;
         
         // $display("tests: ", tests);
         
         if (output_file) begin
            $fdisplay(output_file, "%d %d %d %b %h %h %h", rs, rt, rd, wen, wdata, rs_data, rt_data);
         end

         if (rs_data !== expectedValue1) begin
            $display("Error at test %d: Value of register %d on output 1 should have been %h, but was %h instead", tests, rs, expectedValue1, rs_data);
            errors = errors + 1;
         end
         
         if (rt_data !== expectedValue2) begin
            $display("Error at test %d: Value of register %d on output 2 should have been %h, but was %h instead", tests, rt, expectedValue2, rt_data);
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
