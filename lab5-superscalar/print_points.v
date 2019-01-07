task printPoints;
   input [31:0] possible, actual;
   begin
      $display("<scorePossible>%d</scorePossible>", possible);
      $display("<scoreActual>%d</scoreActual>", actual);
   end
endtask
