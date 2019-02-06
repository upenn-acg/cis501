`timescale 1ns / 1ps

`define NULL 0

module test_alu;

   // messy code to pretty-print error messages
   // so they are easier to understand
   `include "lc4_prettyprint_errors.v"
   `include "print_points.v"

   // debugging state variables
   integer  aluInFile, gpInFile, outputFile, errors, tests, lineno, claTests;

   // inputs
   reg [3:0]   gin, pin;
   reg         cin;
   reg [15:0]  ain, bin, insn, pc, r1data, r2data;
   
   // module outputs
   wire        actualGout, actualPout;
   wire [2:0]  actualCout;
   wire [15:0] actualSum, actualALUResult;

   // file outputs
   reg         expectedGout, expectedPout;
   reg [2:0]   expectedCout;
   reg [15:0]  expectedSum, expectedALUResult;
   
   // instantiate the Units Under Test (UUTs)
   gp4 gp(.gin(gin), .pin(pin), .cin(cin), .gout(actualGout), .pout(actualPout), .cout(actualCout));
   cla16 cla (.a(ain), .b(bin), .cin(cin), .sum(actualSum));
   lc4_alu alu (.i_insn(insn), .i_pc(pc), .i_r1data(r1data), .i_r2data(r2data), .o_result(actualALUResult));
   
   initial begin
      // initialize Inputs
      $srandom(42); // set random seed for deterministic testing
      lineno = 0;
      errors = 0;
      tests = 0;
      
      // open the test input traces
      aluInFile = $fopen("alu_test_vectors.txt", "r");
      if (aluInFile == `NULL) begin
         $display("Error opening file");
         $finish;
      end
      gpInFile = $fopen("gp4_test_vectors.txt", "r");
      if (gpInFile == `NULL) begin
         $display("Error opening file");
         $finish;
      end
      
      // create a new .input file
//`define OUTPUT "test_lc4_alu.output"
`ifdef OUTPUT
      outputFile = $fopen(`OUTPUT, "w");
      if (outputFile == `NULL) begin
         $display("Error opening file: ", `OUTPUT);
         $finish;
      end
`endif

      // wait for global reset to finish
      #100;
      #2;

      // ******************
      // *** GP TESTING ***
      // ******************

      while (6 == $fscanf(gpInFile, "gin:%b pin:%b cin:%b => gout:%b pout:%b cout:%b\n", gin, pin, cin, expectedGout, expectedPout, expectedCout)) begin
         #2; // wait for inputs to propagate through GP unit
         tests = tests+1;
         lineno = lineno+1;
         
         if (actualGout !== expectedGout || actualPout != expectedPout || actualCout !== expectedCout) begin
            errors = errors+1;
            $write("[gp] error at line %04d: ",    lineno);
            $write("gin:%b pin:%b cin:%b ", gin, pin, cin);
            $write("produced gout:%b pout:%b cout:%b ", actualGout, actualPout, actualCout);
            $write("instead of gout:%b pout:%b cout:%b", expectedGout, expectedPout, expectedCout);
            $display("");
            //$finish; // NB: uncomment this to terminate after the first error
         end
      end

      
      // *******************
      // *** CLA TESTING ***
      // *******************

      for (claTests=0; claTests < 10000; claTests=claTests+1) begin
         ain = $urandom;
         bin = $urandom;
         cin = $urandom % 2;
         expectedSum = ain + bin + cin;
         tests = tests+1;
         #2;
         if (expectedSum !== actualSum) begin
            $display("[cla] error a:%d + b:%d + cin:%d = sum:%d instead of %d", ain, bin, cin, actualSum, expectedSum);
            errors = errors+1;
            //$finish; // NB: uncomment this to terminate after the first error
         end
      end

      
      // *******************
      // *** ALU TESTING ***
      // *******************
      
      lineno = 0;
      // read in the ALU input trace one line at a time
      while (5 == $fscanf(aluInFile, "%b %b %b %b %b", insn, pc, r1data, r2data, expectedALUResult)) begin
         #2; // wait for inputs to propagate through ALU
         
         tests = tests + 1;
         lineno = lineno+1;
                
         // write the output to the output trace file
         //if (outputFile) begin
         //   $fdisplay(outputFile, "%b %b %b %b %b", insn, pc, r1data, r2data, actualALUResult);
         //end
         
         // print an error if one occurred
         if (actualALUResult !== expectedALUResult) begin
            errors = errors + 1;

            // break up all binary values into groups of four bits for readability
            $write("[alu] error at line %04d: ",    lineno);
            $write("insn = %b %b %b %b, ",    insn[15:12],       insn[11:8],       insn[7:4],       insn[3:0]);
            $write("pc = %b %b %b %b, ",      pc[15:12],         pc[11:8],         pc[7:4],         pc[3:0]);
            $write("r1data = %b %b %b %b, ",  r1data[15:12],     r1data[11:8],     r1data[7:4],     r1data[3:0]);
            $write("r2data = %b %b %b %b, ",  r2data[15:12],     r2data[11:8],     r2data[7:4],     r2data[3:0]);
            $write("result = %b %b %b %b ",   actualALUResult[15:12],     actualALUResult[11:8],     actualALUResult[7:4],     actualALUResult[3:0]);
            $write("instead of %b %b %b %b ", expectedALUResult[15:12], expectedALUResult[11:8], expectedALUResult[7:4], expectedALUResult[3:0]);
            
            pinstr(insn); // pretty-print the instruction
            $display("");
            //$finish; // NB: uncomment this to terminate after the first error
         end
         
         #2;
      end // end while
      
      // cleanup
      if (gpInFile)  $fclose(gpInFile);
      if (aluInFile)  $fclose(aluInFile);
      if (outputFile) $fclose(outputFile);
      $display("Simulation finished: %d test cases %d errors", tests, errors);
      printPoints(tests, tests - errors);
      $finish;
   end
   
endmodule
