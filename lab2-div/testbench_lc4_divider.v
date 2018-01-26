/* lc4_divider testbench
 * Milo Martin, CJ Taylor, Benedict Brown, David Mally
 * Updated January 2015
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

module test_divider;
   // status variables (number of errors and total number of tests)
   integer     errors, tests;

   // input variables (registers so we can generate them here)
   reg [15:0] i_dividend;
   reg [15:0] i_divisor;

   // output variables (wires because the result comes from the divider outputs)
   wire [15:0] o_remainder;
   wire [15:0] o_quotient;

   // expected remainder and quotient
   reg [15:0] exp_remainder;
   reg [15:0] exp_quotient;

   // instantiate the Unit Under Test (UUT)
   lc4_divider div(i_dividend,
                   i_divisor,
                   o_remainder,
                   o_quotient);


   initial begin // start testbench block

      // initialize inputs
      i_dividend = 0;
      i_divisor = 0;
      errors = 0;


      // wait for global reset to finish
      #100;

      #2;

      // loop 2000 times, with a one-indexed number for each test
      for (tests = 1; tests <= 2000; tests = tests + 1) begin

         // set random dividend and divisor
         i_dividend = $random;
         i_divisor = $random;

         if(tests > 1000) begin
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
         if (exp_quotient !== o_quotient) begin
            $display("Error at test %d: i_dividend = %b %b %b %b (0x%H), i_divisor = %b %b %b %b (0x%H), o_quotient should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                     tests,
                     i_dividend[15:12], i_dividend[11:8], i_dividend[7:4], i_dividend[3:0], i_dividend,
                     i_divisor[15:12], i_divisor[11:8], i_divisor[7:4], i_divisor[3:0], i_divisor,
                     exp_quotient[15:12], exp_quotient[11:8], exp_quotient[7:4], exp_quotient[3:0], exp_quotient,
                     o_quotient[15:12], o_quotient[11:8], o_quotient[7:4], o_quotient[3:0], o_quotient);
            errors = errors + 1;
         end

         // check if the expected and computed remainders match; print error otherwise
         if (exp_remainder !== o_remainder) begin
            $display("Error at test %d: i_dividend = %b %b %b %b (0x%H), i_divisor = %b %b %b %b (0x%H), o_remainder should have been %b %b %b %b (0x%H), but was %b %b %b %b (0x%H) instead",
                     tests,
                     i_dividend[15:12], i_dividend[11:8], i_dividend[7:4], i_dividend[3:0], i_dividend,
                     i_divisor[15:12], i_divisor[11:8], i_divisor[7:4], i_divisor[3:0], i_divisor,
                     exp_remainder[15:12], exp_remainder[11:8], exp_remainder[7:4], exp_remainder[3:0], exp_remainder,
                     o_remainder[15:12], o_remainder[11:8], o_remainder[7:4], o_remainder[3:0], o_remainder);
            errors = errors + 1;
         end

         #2; // wait some more

      end // end for

      $display("Simulation finished: %d test cases %d errors", tests, errors);
      $display("<scorePossible>%d</scorePossible>", tests);
      $display("<scoreActual>%d</scoreActual>", tests - errors);

      $finish;
   end

endmodule
