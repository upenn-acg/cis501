/* 
 * Mux testbench
 */

`timescale 1ns / 1ps

module test_mux; 
   // status variables
   integer     errors, tests, i;

   reg [5:0]   val; 
   reg [3:0] a, b, c, d;
   reg [1:0] sel;
   wire [3:0] actual_out;
   
   // instantiate the Units Under Test (UUTs)

   // 4-bit 4-to-1 mux
   mux_Nbit_4to1 #(4) m0(.sel(sel), .a(a), .b(b), .c(c), .d(d), .o(actual_out)); 
   
   initial begin // start testbench block

      // initialize inputs
      sel = 0;
      errors = 0;
      tests = 0; 

      // wait for global reset to finish
      #100;

      for (i = 0; i < 4; i = i+1) begin

         sel = i;
         a = 0;
         b = 0;
         c = 0;
         d = 0;
         
         for (val = 0; val < 16; val = val+1) begin
            case (sel)
              2'd0: a = val[3:0];
              2'd1: b = val[3:0];
              2'd2: c = val[3:0];
              2'd3: d = val[3:0];
            endcase
            
            #2; // wait for mux to produce value
            
            tests = tests + 1;
            
            if (val[3:0] !== actual_out) begin
               errors = errors + 1;
               $display("ERROR: mux output with sel %b should be %b but was %b instead", sel, val[3:0], actual_out); 
            end
         end
      end
      
      $display("Simulation finished: %d test cases %d errors", tests, errors);
      $display("<scorePossible>%d</scorePossible>", tests);
      $display("<scoreActual>%d</scoreActual>", tests - errors);
      
      $finish;
   end

endmodule
