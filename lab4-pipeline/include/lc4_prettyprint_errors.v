task pinstr;
   input [15:0]  insn;
   
   reg [4:0] op;

   begin   
      op = insn[15:12];

      // branch instructions
      if (op == 0) begin
         if      (insn[11:9] == 0) $write("NOP");
         else if (insn[11:9] == 4) $write("BRn %b", insn[8:0]);
         else if (insn[11:9] == 6) $write("BRnz %b", insn[8:0]);
         else if (insn[11:9] == 5) $write("BRnp %b", insn[8:0]);
         else if (insn[11:9] == 2) $write("BRz %b", insn[8:0]);
         else if (insn[11:9] == 3) $write("BRzp %b", insn[8:0]);
         else if (insn[11:9] == 1) $write("BRp %b", insn[8:0]);
         else if (insn[11:9] == 7) $write("BRnzp %b", insn[8:0]);
         else                      $write("???");
      end

      // arithmetic
      else if (op == 1) begin
         if      (insn[5:3] == 0) $write("ADD R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else if (insn[5:3] == 1) $write("MUL R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else if (insn[5:3] == 2) $write("SUB R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else if (insn[5:3] == 3) $write("DIV R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else                     $write("ADDI R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[4:0]);
      end

      // compare
      else if (op == 2) begin
         if      (insn[8:7] == 0) $write("CMP R%d R%d", insn[11:9], insn[2:0]);
         else if (insn[8:7] == 1) $write("CMPU R%d R%d", insn[11:9], insn[2:0]);
         else if (insn[8:7] == 2) $write("CMPI R%d SEXT(%b)", insn[11:9], insn[6:0]);
         else if (insn[8:7] == 3) $write("CMPIU R%d %b", insn[11:9], insn[6:0]);
      end
      
      // jump save register
      else if (op == 4) begin
         if (insn[11] == 1)       $write("JSR %b", insn[10:0]);
         else                     $write("JSRR R%d", insn[8:6]);
      end
      
      // logical
      else if (op == 5) begin
         if      (insn[5:3] == 0) $write("AND R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else if (insn[5:3] == 1) $write("NOT R%d R%d", insn[11:9], insn[8:6]);
         else if (insn[5:3] == 2) $write("OR R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else if (insn[5:3] == 3) $write("XOR R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
         else                     $write("ANDI R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[4:0]);
      end
      
      // load/store register
      else if (op == 6)           $write("LDR R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[5:0]);
      else if (op == 7)           $write("STR R%d R%d SEXT(%b)", insn[11:9], insn[8:6], insn[5:0]);
      
      // RTI
      else if (op == 8)           $write("RTI");
      
      // load immediate
      else if (op == 9)           $write("CONST R%d SEXT(%b)", insn[11:9], insn[8:0]);
      
      // shift/mod
      else if (op == 10) begin
         if      (insn[5:4] == 0) $write("SLL R%d R%d %b", insn[11:9], insn[8:6], insn[3:0]);
         else if (insn[5:4] == 1) $write("SRA R%d R%d %b", insn[11:9], insn[8:6], insn[3:0]);
         else if (insn[5:4] == 2) $write("SRL R%d R%d %b", insn[11:9], insn[8:6], insn[3:0]);
         else if (insn[5:4] == 3) $write("MOD R%d R%d R%d", insn[11:9], insn[8:6], insn[2:0]);
      end

      // jump
      else if (op == 12) begin
         if (insn[11] == 0)       $write("JMPR R%d", insn[8:6]);
         else                     $write("JMP SEXT(%b)", insn[10:0]);
      end
      
      // hiconst (lc4_decoder.v ignores insn[8] even though ISA says it should be 1)
      else if (op == 13)          $write("HICONST R%d %b", insn[11:9], insn[7:0]);
      
      // trap
      else if (op == 15)          $write("TRAP %b", insn[7:0]);

      // unknown
      else $write("???");
   end
endtask
