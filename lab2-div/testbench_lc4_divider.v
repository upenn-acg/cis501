/* lc4_divider testbench
 * Milo Martin, CJ Taylor, Benedict Brown, David Mally, Matthew Cohen, Natasha Narang
 * Updated January 2018
 *
 * Validate 2000 test inputs for the lc4_divider_one_iter module.
 * 
 * Divide 1000 pairs of random numbers and verify
 * that the quotient and remainder are correct.
 * Then, check division by zero for 1000 random
 * numbers, and check that the quotient and remainder
 * are both set to zero, as per the LC4 specification.
 *
 * Outputs are printed in both binary and hex.
 */

`timescale 1ns / 1ps

`define EOF 32'hFFFF_FFFF
`define NEWLINE 10
`define NULL 0

`ifndef INPUT
`define INPUT "test_lc4_divider_one_iter.input"
`endif

module test_divider;

`include "print_points.v"

   // status variables (number of errors and total number of tests)
   integer     input_file, errors, allTests, divTests;

   // input variables (registers so we can generate them here)
   reg [15:0] i_dividend;
   reg [15:0] i_divisor;
   reg [15:0] i_remainder;
   reg [15:0] i_quotient;
   
   // output variables (wires because the result comes from the divider outputs)
   wire [15:0] o_1iter_dividend;
   wire [15:0] o_1iter_remainder;
   wire [15:0] o_1iter_quotient;

   wire [15:0] o_div_remainder;
   wire [15:0] o_div_quotient;
   
   // expected values
   reg [15:0] exp_dividend;
   reg [15:0] exp_remainder;
   reg [15:0] exp_quotient;

   // instantiate the Units Under Test (UUT)
   lc4_divider div(.i_dividend(i_dividend), .i_divisor(i_divisor),
                   .o_remainder(o_div_remainder), .o_quotient(o_div_quotient));

   lc4_divider_one_iter divider_iter(.i_dividend(i_dividend), .i_divisor(i_divisor), 
                                     .i_remainder(i_remainder), .i_quotient(i_quotient), 
                                     .o_dividend(o_1iter_dividend), .o_remainder(o_1iter_remainder),
                                     .o_quotient(o_1iter_quotient));


   initial begin // start testbench block

      // initialize inputs
      i_dividend = 0;
      i_divisor = 0;
      i_remainder = 0;
      i_quotient = 0;

      errors = 0;
      allTests = 0; 

      // open the lc4_divider_one_iter test input trace
      input_file = $fopen(`INPUT, "r");
      if (input_file == `NULL) begin
         $display("Error opening file: ", `INPUT);
         $finish;
      end

      // wait for global reset to finish
      #100;

      #2;

      // read in the input trace one line at a time
      while (7 == $fscanf(input_file, "%b %b %b %b %b %b %b", i_dividend, i_divisor, i_remainder, i_quotient, exp_dividend, exp_remainder, exp_quotient)) begin
         #8; // wait for the divider to do its thing
         
         allTests = allTests + 1;
         
         // print an error if one occurred
         if (o_1iter_dividend !== exp_dividend || o_1iter_remainder != exp_remainder || o_1iter_quotient != exp_quotient) begin
            errors = errors + 1;

            // break up all binary values into groups of four bits for readability
            $display("[lc4_divider_one_iter] Error at test %04d: i_dividend = %b %b %b %b (0x%H), i_divisor = %b %b %b %b (0x%H), i_remainder = %b %b %b %b (0x%H), i_quotient = %b %b %b %b (0x%H)", allTests,
                     i_dividend[15:12], i_dividend[11:8], i_dividend[7:4], i_dividend[3:0], i_dividend,
                     i_divisor[15:12], i_divisor[11:8], i_divisor[7:4], i_divisor[3:0], i_divisor,
                     i_remainder[15:12], i_remainder[11:8], i_remainder[7:4], i_remainder[3:0], i_remainder,
                     i_quotient[15:12], i_quotient[11:8], i_quotient[7:4], i_quotient[3:0], i_quotient); 

            if (o_1iter_dividend !== exp_dividend) begin
               $display("   o_dividend should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                        exp_dividend[15:12], exp_dividend[11:8], exp_dividend[7:4], exp_dividend[3:0], exp_dividend,
                        o_1iter_dividend[15:12], o_1iter_dividend[11:8], o_1iter_dividend[7:4], o_1iter_dividend[3:0], o_1iter_dividend); 
            end
            if (o_1iter_remainder !== exp_remainder) begin
               $display("   o_remainder should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                        exp_remainder[15:12], exp_remainder[11:8], exp_remainder[7:4], exp_remainder[3:0], exp_remainder,
                        o_1iter_remainder[15:12], o_1iter_remainder[11:8], o_1iter_remainder[7:4], o_1iter_remainder[3:0], o_1iter_remainder); 
            end
            if (o_1iter_quotient !== exp_quotient) begin
               $display("   o_quotient should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                        exp_quotient[15:12], exp_quotient[11:8], exp_quotient[7:4], exp_quotient[3:0], exp_quotient,
                        o_1iter_quotient[15:12], o_1iter_quotient[11:8], o_1iter_quotient[7:4], o_1iter_quotient[3:0], o_1iter_quotient); 
            end
            
         end
         
         #2;
      end // end while
      
      // cleanup
      if (input_file) begin
         $fclose(input_file);
      end
      
      // loop 2000 times, with a one-indexed number for each test
      for (divTests = 0; divTests < 4000;) begin

         // set random dividend and divisor
         i_dividend = $random;
         i_divisor = $random;

         if (divTests >= 2000) begin
            i_divisor = 16'h0000;
         end

         #8; // wait for the divider to do its work

         // computed expected result
         /* It's unclear how the Xilinx sim handles division/modulo by zero,
            so we set the expected values to zero first, and only compute
            the actual division/modulo if i_divisor is non-zero.
         */
         exp_quotient  = 16'h0000;
         exp_remainder = 16'h0000;

         if(i_divisor !== 16'h0000) begin
            exp_quotient  = (i_dividend / i_divisor);
            exp_remainder = (i_dividend % i_divisor);
         end

         // check if the expected and computed quotients match; print error otherwise
         if (exp_quotient !== o_div_quotient) begin
            $display("[lc4_divider] Error at test %d: i_dividend = %b %b %b %b (0x%H), i_divisor = %b %b %b %b (0x%H), o_quotient should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                     divTests,
                     i_dividend[15:12], i_dividend[11:8], i_dividend[7:4], i_dividend[3:0], i_dividend,
                     i_divisor[15:12], i_divisor[11:8], i_divisor[7:4], i_divisor[3:0], i_divisor,
                     exp_quotient[15:12], exp_quotient[11:8], exp_quotient[7:4], exp_quotient[3:0], exp_quotient,
                     o_div_quotient[15:12], o_div_quotient[11:8], o_div_quotient[7:4], o_div_quotient[3:0], o_div_quotient);
            errors = errors + 1;
         end
         divTests = divTests + 1;
         allTests = allTests + 1; 

         // check if the expected and computed remainders match; print error otherwise
         if (exp_remainder !== o_div_remainder) begin
            $display("[lc4_divider] Error at test %d: i_dividend = %b %b %b %b (0x%H), i_divisor = %b %b %b %b (0x%H), o_remainder should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                     divTests,
                     i_dividend[15:12], i_dividend[11:8], i_dividend[7:4], i_dividend[3:0], i_dividend,
                     i_divisor[15:12], i_divisor[11:8], i_divisor[7:4], i_divisor[3:0], i_divisor,
                     exp_remainder[15:12], exp_remainder[11:8], exp_remainder[7:4], exp_remainder[3:0], exp_remainder,
                     o_div_remainder[15:12], o_div_remainder[11:8], o_div_remainder[7:4], o_div_remainder[3:0], o_div_remainder);
            errors = errors + 1;
         end
         divTests = divTests + 1;
         allTests = allTests + 1; 

         #2; // wait some more

      end // end for

      $display("Simulation finished: %d test cases %d errors", allTests, errors);
      printPoints(allTests, allTests - errors);
      $finish;
   end

endmodule
