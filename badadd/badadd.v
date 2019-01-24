`timescale 1ns / 1ps
`default_nettype none

module fulladder(input wire  cin,
                 input wire  a,
                 input wire  b,
                 output wire s,
                 output wire cout);

   wire tmp1, tmp2, tmp3; 
   assign s = cin ^ a ^ b;
   assign tmp1 = a & b;
   assign tmp2 = b & c;
   assign cout = tmp1 | tmp2 | tmp3;
endmodule

module test_adders; 

   // status variables
   integer     errors, tests, i;
   
   reg         a, b;
   wire        actual_ha_sum, actual_ha_cout;
   
   // instantiate the Units Under Test (UUTs)
   
   reg         cin; 
   reg         exp_fa_cout, exp_fa_sum; 
   wire        actual_fa_sum, actual_fa_cout;
   fulladder fa(.cin(cin), .a(a), .b(b), .s(actual_fa_sum), .cout(actual_fa_cout));
   
   initial begin // start testbench block

      // initialize inputs
      a = 0;
      b = 0;
      errors = 0;
      tests = 0; 

      // wait for global reset to finish
      #100;
      
      // FULL ADDER TESTS

      for (i = 0; i <= 7; i = i + 1) begin
         a = i[0];
         b = i[1];
         cin = i[2]; 

         #6; // wait for full adder to produce result
         tests = tests + 2; // test sum and cout

         assign {exp_fa_cout,exp_fa_sum} =  a + b + cin;

         if (exp_fa_cout !== actual_fa_cout) begin
            $display("[fulladder] ERROR: %b + %b should produce cout=%b but was %b instead", a, b, exp_fa_cout, actual_fa_cout);
            errors = errors + 1; 
         end
         if (exp_fa_sum !== actual_fa_sum) begin
            $display("[fulladder] ERROR: %b + %b should produce sum=%b but was %b instead", a, b, exp_fa_sum, actual_fa_sum);
            errors = errors + 1; 
         end 
      end
      
      $display("Simulation finished: %d test cases %d errors", tests, errors);
      $finish;
   end

endmodule
