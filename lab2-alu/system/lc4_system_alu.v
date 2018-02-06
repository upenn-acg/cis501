`timescale 1ns / 1ps
`default_nettype none
  
//////////////////////////////////////////////////////////////////////////////////
// Created by Joe Devietti, Feb 2018
// Heavily based on code from https://github.com/Digilent/Zedboard-OLED
// Simplified to remove unneeded OLED functionality (such as clearing the
// screen, or enabling every pixel). Further modified to visualize ALU
// inputs/outputs.
//////////////////////////////////////////////////////////////////////////////////

module lc4_system_alu(
    input wire        oled_ctrl_clk,
    input wire        btnL, // Left DPad button turns the display on and off
    input wire [7:0]  SWITCH, // switches [4:0] control ALU input
    output wire [7:0] LED, // LED[0] tells whether the OLED display is on or off
    output wire       oled_sdin,
    output wire       oled_sclk,
    output wire       oled_dc,
    output wire       oled_res,
    output wire       oled_vbat,
    output wire       oled_vdd
);
    //state machine codes
   localparam Idle       = 0;
   localparam Init       = 1;
   localparam Active     = 2;
   localparam Done       = 3;
   localparam FullDisp   = 4; // jld: used in Digilent demo but not for us
   localparam Write      = 5;
   localparam WriteWait  = 6;
   localparam UpdateWait = 7;
    
    localparam AUTO_START = 1; // determines whether the OLED will be automatically initialized when the board is programmed
    	
    //state machine registers.
    reg [2:0] state = (AUTO_START == 1) ? Init : Idle;
    reg [5:0] count = 0;//loop index variable
    reg       once = 0;//bool to see if we have set up local pixel memory in this session
        
    //oled control signals
    //command start signals, assert high to start command
    reg        update_start = 0;        //update oled display over spi
    reg        disp_on_start = AUTO_START;       //turn the oled display on
    reg        disp_off_start = 0;      //turn the oled display off
    reg        toggle_disp_start = 0;   //turns on every pixel on the oled, or returns the display to before each pixel was turned on
    reg        write_start = 0;         //writes a character bitmap into local memory
    //data signals for oled controls
    reg        update_clear = 0;        //when asserted high, an update command clears the display, instead of filling from memory
    reg  [8:0] write_base_addr = 0;     //location to write character to, two most significant bits are row position, 0 is topmost. bottom seven bits are X position, addressed by pixel x position.
    reg  [7:0] write_ascii_data = 0;    //ascii value of character to write to memory
    //active high command ready signals, appropriate start commands are ignored when these are not asserted high
    wire       disp_on_ready;
    wire       disp_off_ready;
    wire       toggle_disp_ready;
    wire       update_ready;
    wire       write_ready;
    
    //debounced button signals used for state transitions
    wire       rst;     // Left DPad Button: turns the display on and off
   
    //instantiate OLED controller
    OLEDCtrl m_OLEDCtrl (
        .clk                (oled_ctrl_clk),              
        .write_start        (write_start),      
        .write_ascii_data   (write_ascii_data), 
        .write_base_addr    (write_base_addr),  
        .write_ready        (write_ready),      
        .update_start       (update_start),     
        .update_ready       (update_ready),     
        .update_clear       (update_clear),    
        .disp_on_start      (disp_on_start),    
        .disp_on_ready      (disp_on_ready),    
        .disp_off_start     (disp_off_start),   
        .disp_off_ready     (disp_off_ready),   
        .toggle_disp_start  (toggle_disp_start),
        .toggle_disp_ready  (toggle_disp_ready),
        .SDIN               (oled_sdin),        
        .SCLK               (oled_sclk),        
        .DC                 (oled_dc  ),        
        .RES                (oled_res ),        
        .VBAT               (oled_vbat),        
        .VDD                (oled_vdd )
    );

   // code to generate ALU inputs

   // Template string for OLED display. The display can show 4 rows of 16 ASCII
   // characters each (64 chars total). Question marks get filled in with
   // dynamic ALU inputs/outputs.
   localparam strPC= "pc=0x????       "; 
   localparam strReg="1=x????  2=x????"; 
   localparam strOut="result=0x????   ";
   
   // Helper string to translate from a hex value to its ASCII representation.
   // Right-shift string by the hex digit and use least-significant byte.
   localparam strHex="fedcba9876543210";
   localparam strLen=16;

   // string representation of the ALU input insns
   localparam strInsn0="ADD r0, r0, r0  ";
   localparam strInsn1="ADD r0, r0, #4  ";
   localparam strInsn2="MUL r0, r0, r0  ";
   localparam strInsn3="DIV r0, r0, r0  ";
   localparam strInsn4="SUB r0, r0, r0  ";
   localparam strInsn5="MOD r0, r0, r0  ";
   localparam strInsn6="AND r0, r0, r0  ";
   localparam strInsn7="AND r0, r0, #4  ";
   localparam strInsn8="NOT r0, r0      ";
   localparam strInsn9="OR r0, r0, r0   ";
   localparam strInsn10="XOR r0, r0, r0  ";
   localparam strInsn11="SLL r0, r0, #4  ";
   localparam strInsn12="SRA r0, r0, #4  ";
   localparam strInsn13="SRL r0, r0, #4  ";
   localparam strInsn14="LDR r0, r0, #5  ";
   localparam strInsn15="STR r0, r0, #3  ";
   localparam strInsn16="CONST r0, #429  ";
   localparam strInsn17="HICONST r0, #222";
   localparam strInsn18="CMP r0, r0      ";
   localparam strInsn19="CMPU r0, r0     ";
   localparam strInsn20="CMPI r0, #-1    ";
   localparam strInsn21="CMPIU r0, #127  ";
   localparam strInsn22="BRn #10         ";
   localparam strInsn23="BRz #9          ";
   localparam strInsn24="BRp #8          ";
   localparam strInsn25="BRnzp #7        ";
   localparam strInsn26="NOP             ";
   localparam strInsn27="JMP #5          ";
   localparam strInsn28="JMPR r0         ";
   localparam strInsn29="JSR 0x0020      ";
   localparam strInsn30="JSRR r0         ";
   localparam strInsn31="TRAP #186       ";

   // machine code representation of ALU input insns
   localparam INSN0=16'h1000;
   localparam INSN1=16'h1024;
   localparam INSN2=16'h1008;
   localparam INSN3=16'h1018;
   localparam INSN4=16'h1010;
   localparam INSN5=16'hA038;
   localparam INSN6=16'h5000;
   localparam INSN7=16'h5024;
   localparam INSN8=16'h5008;
   localparam INSN9=16'h5010;
   localparam INSN10=16'h5018;
   localparam INSN11=16'hA004;
   localparam INSN12=16'hA014;
   localparam INSN13=16'hA024;
   localparam INSN14=16'h6005;
   localparam INSN15=16'h7003;
   localparam INSN16=16'h91AD;
   localparam INSN17=16'hD1DE;
   localparam INSN18=16'h2000;
   localparam INSN19=16'h2080;
   localparam INSN20=16'h217F;
   localparam INSN21=16'h21FF;
   localparam INSN22=16'h080A;
   localparam INSN23=16'h0409;
   localparam INSN24=16'h0208;
   localparam INSN25=16'h0E07;
   localparam INSN26=16'h0000;
   localparam INSN27=16'hC805;
   localparam INSN28=16'hC000;
   localparam INSN29=16'h4802;
   localparam INSN30=16'h4000;
   localparam INSN31=16'hF0BA;
   
   reg [15:0]  aluInsn, aluData1, aluData2;
   wire [15:0] aluResult;
   wire [15:0] aluPC = 16'h1000;
   
   lc4_alu alu(.i_insn(aluInsn),
               .i_pc(aluPC),
               .i_r1data(aluData1),
               .i_r2data(aluData2),
               .o_result(aluResult));

   always@(SWITCH[4:0])
     case (SWITCH[4:0])
       0: begin 
          aluInsn <= INSN0;
          aluData1 <= 16'h0001;
          aluData2 <= 16'h0001;
       end
       1: begin 
          aluInsn <= INSN1;
          aluData1 <= 16'hADD1;
          aluData2 <= 16'h0001;
       end
       2: begin 
          aluInsn <= INSN2;
          aluData1 <= 16'h0002;
          aluData2 <= 16'h0003;
       end 
       3: begin 
          aluInsn <= INSN3;
          aluData1 <= 16'h0008;
          aluData2 <= 16'h0002;
       end
       4: begin 
          aluInsn <= INSN4;
          aluData1 <= 16'h0003;
          aluData2 <= 16'h0001;
       end
       5: begin 
          aluInsn <= INSN5;
          aluData1 <= 16'h0010;
          aluData2 <= 16'h0005;
       end
       6: begin 
          aluInsn <= INSN6;
          aluData1 <= 16'hF0F0;
          aluData2 <= 16'h0F0F;
       end
       7: begin 
          aluInsn <= INSN7;
          aluData1 <= 16'hFFFF;
          aluData2 <= 16'hFFFF;
       end
       8: begin 
          aluInsn <= INSN8;
          aluData1 <= 16'hFFFF;
          aluData2 <= 16'h0000;
       end
       9: begin 
          aluInsn <= INSN9;
          aluData1 <= 16'hC0F0;
          aluData2 <= 16'h0A0E;
       end
       10: begin 
          aluInsn <= INSN10;
          aluData1 <= 16'h000F;
          aluData2 <= 16'h0001;
       end
       11: begin 
          aluInsn <= INSN11;
          aluData1 <= 16'hAB1E;
          aluData2 <= 16'h0000;
       end
       12: begin 
          aluInsn <= INSN12;
          aluData1 <= 16'hEED0;
          aluData2 <= 16'h0000;
       end
       13: begin 
          aluInsn <= INSN13;
          aluData1 <= 16'h1AB2;
          aluData2 <= 16'h0000;
       end
       14: begin 
          aluInsn <= INSN14;
          aluData1 <= 16'h10A8;
          aluData2 <= 16'h0000;
       end
       15: begin 
          aluInsn <= INSN15;
          aluData1 <= 16'h0B0B;
          aluData2 <= 16'h0000;
       end
       16: begin 
          aluInsn <= INSN16;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       17: begin 
          aluInsn <= INSN17;
          aluData1 <= 16'h00A1;
          aluData2 <= 16'h0000;
       end
       18: begin 
          aluInsn <= INSN18; // CMP
          aluData1 <= 16'hFFFF;
          aluData2 <= 16'h0001;
       end
       19: begin 
          aluInsn <= INSN19;
          aluData1 <= 16'hFFFF;
          aluData2 <= 16'h0001;
       end
       20: begin 
          aluInsn <= INSN20;
          aluData1 <= 16'hFFFF;
          aluData2 <= 16'h0000;
       end
       21: begin 
          aluInsn <= INSN21; // CMPIU
          aluData1 <= 16'hFFFF;
          aluData2 <= 16'h0000;
       end
       22: begin 
          aluInsn <= INSN22; 
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       23: begin 
          aluInsn <= INSN23;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       24: begin 
          aluInsn <= INSN24;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       25: begin 
          aluInsn <= INSN25;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       26: begin 
          aluInsn <= INSN26;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       27: begin 
          aluInsn <= INSN27;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       28: begin 
          aluInsn <= INSN28;
          aluData1 <= 16'hBA5E;
          aluData2 <= 16'h0000;
       end
       29: begin 
          aluInsn <= INSN29;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
       30: begin 
          aluInsn <= INSN30;
          aluData1 <= 16'hBEAD;
          aluData2 <= 16'h0000;
       end
       31: begin 
          aluInsn <= INSN31;
          aluData1 <= 16'h0000;
          aluData2 <= 16'h0000;
       end
     endcase
   
   always@(write_base_addr or SWITCH[4:0])
     case (write_base_addr[8:7]) // determine which row of the display is being sent
       0: begin
          case (SWITCH[4:0])
            0: write_ascii_data <= 8'hff & (strInsn0 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            1: write_ascii_data <= 8'hff & (strInsn1 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            2: write_ascii_data <= 8'hff & (strInsn2 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            3: write_ascii_data <= 8'hff & (strInsn3 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            4: write_ascii_data <= 8'hff & (strInsn4 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            5: write_ascii_data <= 8'hff & (strInsn5 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            6: write_ascii_data <= 8'hff & (strInsn6 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            7: write_ascii_data <= 8'hff & (strInsn7 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            8: write_ascii_data <= 8'hff & (strInsn8 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            9: write_ascii_data <= 8'hff & (strInsn9 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            10: write_ascii_data <= 8'hff & (strInsn10 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            11: write_ascii_data <= 8'hff & (strInsn11 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            12: write_ascii_data <= 8'hff & (strInsn12 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            13: write_ascii_data <= 8'hff & (strInsn13 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            14: write_ascii_data <= 8'hff & (strInsn14 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            15: write_ascii_data <= 8'hff & (strInsn15 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            16: write_ascii_data <= 8'hff & (strInsn16 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            17: write_ascii_data <= 8'hff & (strInsn17 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            18: write_ascii_data <= 8'hff & (strInsn18 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            19: write_ascii_data <= 8'hff & (strInsn19 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            20: write_ascii_data <= 8'hff & (strInsn20 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            21: write_ascii_data <= 8'hff & (strInsn21 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            22: write_ascii_data <= 8'hff & (strInsn22 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            23: write_ascii_data <= 8'hff & (strInsn23 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            24: write_ascii_data <= 8'hff & (strInsn24 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            25: write_ascii_data <= 8'hff & (strInsn25 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            26: write_ascii_data <= 8'hff & (strInsn26 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            27: write_ascii_data <= 8'hff & (strInsn27 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            28: write_ascii_data <= 8'hff & (strInsn28 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            29: write_ascii_data <= 8'hff & (strInsn29 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            30: write_ascii_data <= 8'hff & (strInsn30 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
            31: write_ascii_data <= 8'hff & (strInsn31 >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3));
          endcase
       end
       1: begin
          case (write_base_addr[6:3])
            5: write_ascii_data <= 8'hff & (strHex >> {aluPC[15:12],3'b000}); 
            6: write_ascii_data <= 8'hff & (strHex >> {aluPC[11:8],3'b000}); 
            7: write_ascii_data <= 8'hff & (strHex >> {aluPC[7:4],3'b000});
            8: write_ascii_data <= 8'hff & (strHex >> {aluPC[3:0],3'b000});
            default: write_ascii_data <= 8'hff & (strPC >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3)); //index string parameters as str[x]
          endcase
       end
       2: begin
          case (write_base_addr[6:3])
            3: write_ascii_data <= 8'hff & (strHex >> {aluData1[15:12],3'b000}); 
            4: write_ascii_data <= 8'hff & (strHex >> {aluData1[11:8],3'b000}); 
            5: write_ascii_data <= 8'hff & (strHex >> {aluData1[7:4],3'b000});
            6: write_ascii_data <= 8'hff & (strHex >> {aluData1[3:0],3'b000});
            12: write_ascii_data <= 8'hff & (strHex >> {aluData2[15:12],3'b000}); 
            13: write_ascii_data <= 8'hff & (strHex >> {aluData2[11:8],3'b000}); 
            14: write_ascii_data <= 8'hff & (strHex >> {aluData2[7:4],3'b000});
            15: write_ascii_data <= 8'hff & (strHex >> {aluData2[3:0],3'b000});
            default: write_ascii_data <= 8'hff & (strReg >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3)); //index string parameters as str[x]
          endcase
       end
       3: begin
          case (write_base_addr[6:3])
            9: write_ascii_data <= 8'hff & (strHex >> {aluResult[15:12],3'b000}); 
            10: write_ascii_data <= 8'hff & (strHex >> {aluResult[11:8],3'b000}); 
            11: write_ascii_data <= 8'hff & (strHex >> {aluResult[7:4],3'b000});
            12: write_ascii_data <= 8'hff & (strHex >> {aluResult[3:0],3'b000});
            default: write_ascii_data <= 8'hff & (strOut >> ({3'b0, (strLen - 1 - write_base_addr[6:3])} << 3)); //index string parameters as str[x]
          endcase
       end
     endcase
        
   // Debouncers ensure single state machine loop per button press. 
   // Noisy signals cause possibility of multiple "positive edges" per press.   
   debouncer #(.COUNT_MAX(65535), .COUNT_WIDTH(16)) 
      get_rst (.clk(oled_ctrl_clk), .A(btnL), .B(rst));

   reg oled_on;
   assign LED[0] = oled_on; // display whether the display is on or not
   wire init_done = disp_off_ready | toggle_disp_ready | write_ready | update_ready;//parse ready signals for clarity
   wire init_ready = disp_on_ready;
   always@(posedge oled_ctrl_clk)
     case (state)
       Idle: begin
          if (rst == 1'b1 && init_ready == 1'b1) begin
             disp_on_start <= 1'b1;
             state <= Init;
          end
          once <= 0;
          oled_on <= 1'b0; 
       end
       Init: begin
          disp_on_start <= 1'b0;
          if (rst == 1'b0 && init_done == 1'b1)
            state <= Active;
       end
       Active: begin // hold until ready, then accept input
          if (rst && disp_off_ready) begin
             disp_off_start <= 1'b1;
             state <= Done;
          end else if (once == 0 && write_ready) begin
             write_start <= 1'b1;
             write_base_addr <= 'b0;
             state <= WriteWait;
          end else if (once == 1) begin
             update_start <= 1'b1;
             update_clear <= 1'b0;
             state <= UpdateWait;
          end
       end // case: Active
       Write: begin
          write_start <= 1'b1;
          write_base_addr <= write_base_addr + 9'h8;
          //write_ascii_data updated with write_base_addr
          state <= WriteWait;
       end
       WriteWait: begin
          write_start <= 1'b0;
          if (write_ready == 1'b1)
            if (write_base_addr == 9'h1f8) begin
               oled_on <= 1'b1; 
               once <= 1;
               state <= Active;
            end else begin
               state <= Write;
            end
       end // case: WriteWait
       UpdateWait: begin
          update_start <= 0;
          if (init_done == 1'b1) begin
             state <= Active;
             once <= 0; 
          end
       end
       Done: begin
          disp_off_start <= 1'b0;
          if (rst == 1'b0 && init_ready == 1'b1)
            state <= Idle;
       end
       default: state <= Idle;
     endcase
endmodule
