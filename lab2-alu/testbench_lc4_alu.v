`timescale 1ns / 1ps

`define EOF 32'hFFFF_FFFF
`define NEWLINE 10
`define NULL 0

`ifndef INPUT
`define INPUT "test_lc4_alu.input"
`endif

`define OUTPUT "test_lc4_alu.output"

module test_alu;

   // messy code to pretty-print error messages
   // so they are easier to understand
   `include "lc4_prettyprint_errors.v"
   `include "print_points.v"
   
   // debugging state variables
   integer  input_file, output_file, errors, tests;
   reg [15:0] expected_result;

   // inputs
   reg [15:0] insn;
   reg [15:0] pc;
   reg [15:0] r1data;
   reg [15:0] r2data;
   
   // outputs
   wire [15:0] result;
   
   // instantiate the Unit Under Test (UUT)
   lc4_alu alu (insn, pc, r1data, r2data, result);
   
   initial begin
      // initialize Inputs
      insn = 0;
      r1data = 0;
      r2data = 0;

      errors = 0;
      tests = 0;
      output_file = 0;
      
      // open the test input trace
      input_file = $fopen(`INPUT, "r");
      if (input_file == `NULL) begin
         $display("Error opening file: ", `INPUT);
         $finish;
      end

      // open the output file for writing the output trace
`ifdef OUTPUT
      output_file = $fopen(`OUTPUT, "w");
      if (output_file == `NULL) begin
         $display("Error opening file: ", `OUTPUT);
         $finish;
      end
`endif

      // wait for global reset to finish
      #100;
      #2;

      // read in the input trace one line at a time
      while (5 == $fscanf(input_file, "%b %b %b %b %b", insn, pc, r1data, r2data, expected_result)) begin
         #8; // wait for the ALU to do its thing
         
         tests = tests + 1;
                
         // write the output to the output trace file
         if (output_file) begin
            $fdisplay(output_file, "%b %b %b %b %b", insn, pc, r1data, r2data, result);
         end
         
         // print an error if one occured
         if (result !== expected_result) begin
            errors = errors + 1;

            // break up all binary values into groups of four bits for readability
            $write("Error at line %04d: ",    tests);
            $write("insn = %b %b %b %b, ",    insn[15:12],       insn[11:8],       insn[7:4],       insn[3:0]);
            $write("pc = %b %b %b %b, ",      pc[15:12],         pc[11:8],         pc[7:4],         pc[3:0]);
            $write("r1data = %b %b %b %b, ",  r1data[15:12],     r1data[11:8],     r1data[7:4],     r1data[3:0]);
            $write("r2data = %b %b %b %b, ",  r2data[15:12],     r2data[11:8],     r2data[7:4],     r2data[3:0]);
            $write("result = %b %b %b %b ",   result[15:12],     result[11:8],     result[7:4],     result[3:0]);
            $write("instead of %b %b %b %b ", expected_result[15:12], expected_result[11:8], expected_result[7:4], expected_result[3:0]);
            
            pinstr(insn); // pretty-print the instruction
            $display(""); // add a newline
            //$finish;
         end
         
         #2;
      end // end while
      
      // cleanup
      if (input_file)  $fclose(input_file); 
      if (output_file) $fclose(output_file);
      $display("Simulation finished: %d test cases %d errors [%s]", tests, errors, `INPUT);
      printPoints(tests, tests - errors);
      $finish;
   end
   
endmodule
