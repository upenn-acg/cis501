;;; Adapted from code by Amir Roth; CJT Oct 17, 2010

;;; OS Code
	.OS
	.CODE
	.ADDR x8000

; the TRAP vector table
	JMP TRAP_GETC	; x00
	JMP TRAP_PUTC	; x01
	JMP TRAP_DRAW_H_LINE	; x02
	JMP TRAP_DRAW_V_LINE	; x03
	JMP BAD_TRAP	; x04
	JMP BAD_TRAP	; x05
	JMP BAD_TRAP	; x06
	JMP TRAP_GET_EVENT	; x07
	JMP TRAP_PUTS	; x08
	JMP TRAP_CHECK_KBD	; x09
	JMP TRAP_DRAW_RECT	; x0A
	JMP TRAP_DRAW_SPRITE	; x0B
	JMP BAD_TRAP	; x0C
	JMP BAD_TRAP	; x0D
	JMP BAD_TRAP	; x0E
	JMP BAD_TRAP	; x0F
	JMP BAD_TRAP	; x10
	JMP BAD_TRAP	; x11
	JMP BAD_TRAP	; x12
	JMP BAD_TRAP	; x13
	JMP BAD_TRAP	; x14
	JMP BAD_TRAP	; x15
	JMP BAD_TRAP	; x16
	JMP BAD_TRAP	; x17
	JMP BAD_TRAP	; x18
	JMP BAD_TRAP	; x19
	JMP BAD_TRAP	; x1A
	JMP BAD_TRAP	; x1B
	JMP BAD_TRAP	; x1C
	JMP BAD_TRAP	; x1D
	JMP BAD_TRAP	; x1E
	JMP BAD_TRAP	; x1F
	JMP BAD_TRAP	; x20
	JMP BAD_TRAP	; x21
	JMP BAD_TRAP	; x22
	JMP BAD_TRAP	; x23
	JMP BAD_TRAP	; x24
	JMP TRAP_HALT		; x25
	JMP TRAP_RESET_VMEM	; x26
	JMP TRAP_BLT_VMEM	; x27
	JMP BAD_TRAP	; x28
	JMP BAD_TRAP	; x29
	JMP BAD_TRAP	; x2A
	JMP BAD_TRAP	; x2B
	JMP BAD_TRAP	; x2C
	JMP BAD_TRAP	; x2D
	JMP BAD_TRAP	; x2E
	JMP BAD_TRAP	; x2F
	JMP BAD_TRAP	; x30
	JMP BAD_TRAP	; x31
	JMP BAD_TRAP	; x32
	JMP BAD_TRAP	; x33
	JMP BAD_TRAP	; x34
	JMP BAD_TRAP	; x35
	JMP BAD_TRAP	; x36
	JMP BAD_TRAP	; x37
	JMP BAD_TRAP	; x38
	JMP BAD_TRAP	; x39
	JMP BAD_TRAP	; x3A
	JMP BAD_TRAP	; x3B
	JMP BAD_TRAP	; x3C
	JMP BAD_TRAP	; x3D
	JMP BAD_TRAP	; x3E
	JMP BAD_TRAP	; x3F
	JMP BAD_TRAP	; x40
	JMP BAD_TRAP	; x41
	JMP BAD_TRAP    ; x42
	JMP BAD_TRAP	; x43
	JMP BAD_TRAP	; x44
	JMP BAD_TRAP	; x45
	JMP BAD_TRAP	; x46
	JMP BAD_TRAP	; x47
	JMP BAD_TRAP	; x48
	JMP BAD_TRAP	; x49
	JMP BAD_TRAP	; x4A
	JMP BAD_TRAP	; x4B
	JMP BAD_TRAP	; x4C
	JMP BAD_TRAP	; x4D
	JMP BAD_TRAP    ; x4E
	JMP BAD_TRAP    ; x4F
	JMP BAD_TRAP    ; x50
	JMP BAD_TRAP	; x51
	JMP BAD_TRAP	; x52
	JMP BAD_TRAP	; x53
	JMP BAD_TRAP	; x54
	JMP BAD_TRAP	; x55
	JMP BAD_TRAP	; x56
	JMP BAD_TRAP	; x57
	JMP BAD_TRAP	; x58
	JMP BAD_TRAP	; x59
	JMP BAD_TRAP	; x5A
	JMP BAD_TRAP	; x5B
	JMP BAD_TRAP	; x5C
	JMP BAD_TRAP	; x5D
	JMP BAD_TRAP	; x5E
	JMP BAD_TRAP	; x5F
	JMP BAD_TRAP	; x60
	JMP BAD_TRAP	; x61
	JMP BAD_TRAP	; x62
	JMP BAD_TRAP	; x63
	JMP BAD_TRAP	; x64
	JMP BAD_TRAP	; x65
	JMP BAD_TRAP	; x66
	JMP BAD_TRAP	; x67
	JMP BAD_TRAP	; x68
	JMP BAD_TRAP	; x69
	JMP BAD_TRAP	; x6A
	JMP BAD_TRAP	; x6B
	JMP BAD_TRAP	; x6C
	JMP BAD_TRAP	; x6D
	JMP BAD_TRAP	; x6E
	JMP BAD_TRAP	; x6F
	JMP BAD_TRAP	; x70
	JMP BAD_TRAP	; x71
	JMP BAD_TRAP	; x72
	JMP BAD_TRAP	; x73
	JMP BAD_TRAP	; x74
	JMP BAD_TRAP	; x75
	JMP BAD_TRAP	; x76
	JMP BAD_TRAP	; x77
	JMP BAD_TRAP	; x78
	JMP BAD_TRAP	; x79
	JMP BAD_TRAP	; x7A
	JMP BAD_TRAP	; x7B
	JMP BAD_TRAP	; x7C
	JMP BAD_TRAP	; x7D
	JMP BAD_TRAP	; x7E
	JMP BAD_TRAP	; x7F
	JMP BAD_TRAP	; x80
	JMP BAD_TRAP	; x81
	JMP BAD_TRAP	; x82
	JMP BAD_TRAP	; x83
	JMP BAD_TRAP	; x84
	JMP BAD_TRAP	; x85
	JMP BAD_TRAP	; x86
	JMP BAD_TRAP	; x87
	JMP BAD_TRAP	; x88
	JMP BAD_TRAP	; x89
	JMP BAD_TRAP	; x8A
	JMP BAD_TRAP	; x8B
	JMP BAD_TRAP	; x8C
	JMP BAD_TRAP	; x8D
	JMP BAD_TRAP	; x8E
	JMP BAD_TRAP	; x8F
	JMP BAD_TRAP	; x90
	JMP BAD_TRAP	; x91
	JMP BAD_TRAP	; x92
	JMP BAD_TRAP	; x93
	JMP BAD_TRAP	; x94
	JMP BAD_TRAP	; x95
	JMP BAD_TRAP	; x96
	JMP BAD_TRAP	; x97
	JMP BAD_TRAP	; x98
	JMP BAD_TRAP	; x99
	JMP BAD_TRAP	; x9A
	JMP BAD_TRAP	; x9B
	JMP BAD_TRAP	; x9C
	JMP BAD_TRAP	; x9D
	JMP BAD_TRAP	; x9E
	JMP BAD_TRAP	; x9F
	JMP BAD_TRAP	; xA0
	JMP BAD_TRAP	; xA1
	JMP BAD_TRAP	; xA2
	JMP BAD_TRAP	; xA3
	JMP BAD_TRAP	; xA4
	JMP BAD_TRAP	; xA5
	JMP BAD_TRAP	; xA6
	JMP BAD_TRAP	; xA7
	JMP BAD_TRAP	; xA8
	JMP BAD_TRAP	; xA9
	JMP BAD_TRAP	; xAA
	JMP BAD_TRAP	; xAB
	JMP BAD_TRAP	; xAC
	JMP BAD_TRAP	; xAD
	JMP BAD_TRAP	; xAE
	JMP BAD_TRAP	; xAF
	JMP BAD_TRAP	; xB0
	JMP BAD_TRAP	; xB1
	JMP BAD_TRAP	; xB2
	JMP BAD_TRAP	; xB3
	JMP BAD_TRAP	; xB4
	JMP BAD_TRAP	; xB5
	JMP BAD_TRAP	; xB6
	JMP BAD_TRAP	; xB7
	JMP BAD_TRAP	; xB8
	JMP BAD_TRAP	; xB9
	JMP BAD_TRAP	; xBA
	JMP BAD_TRAP	; xBB
	JMP BAD_TRAP	; xBC
	JMP BAD_TRAP	; xBD
	JMP BAD_TRAP	; xBE
	JMP BAD_TRAP	; xBF
	JMP BAD_TRAP	; xC0
	JMP BAD_TRAP	; xC1
	JMP BAD_TRAP	; xC2
	JMP BAD_TRAP	; xC3
	JMP BAD_TRAP	; xC4
	JMP BAD_TRAP	; xC5
	JMP BAD_TRAP	; xC6
	JMP BAD_TRAP	; xC7
	JMP BAD_TRAP	; xC8
	JMP BAD_TRAP	; xC9
	JMP BAD_TRAP	; xCA
	JMP BAD_TRAP	; xCB
	JMP BAD_TRAP	; xCC
	JMP BAD_TRAP	; xCD
	JMP BAD_TRAP	; xCE
	JMP BAD_TRAP	; xCF
	JMP BAD_TRAP	; xD0
	JMP BAD_TRAP	; xD1
	JMP BAD_TRAP	; xD2
	JMP BAD_TRAP	; xD3
	JMP BAD_TRAP	; xD4
	JMP BAD_TRAP	; xD5
	JMP BAD_TRAP	; xD6
	JMP BAD_TRAP	; xD7
	JMP BAD_TRAP	; xD8
	JMP BAD_TRAP	; xD9
	JMP BAD_TRAP	; xDA
	JMP BAD_TRAP	; xDB
	JMP BAD_TRAP	; xDC
	JMP BAD_TRAP	; xDD
	JMP BAD_TRAP	; xDE
	JMP BAD_TRAP	; xDF
	JMP BAD_TRAP	; xE0
	JMP BAD_TRAP	; xE1
	JMP BAD_TRAP	; xE2
	JMP BAD_TRAP	; xE3
	JMP BAD_TRAP	; xE4
	JMP BAD_TRAP	; xE5
	JMP BAD_TRAP	; xE6
	JMP BAD_TRAP	; xE7
	JMP BAD_TRAP	; xE8
	JMP BAD_TRAP	; xE9
	JMP BAD_TRAP	; xEA
	JMP BAD_TRAP	; xEB
	JMP BAD_TRAP	; xEC
	JMP BAD_TRAP	; xED
	JMP BAD_TRAP	; xEE
	JMP BAD_TRAP	; xEF
	JMP BAD_TRAP	; xF0
	JMP BAD_TRAP	; xF1
	JMP BAD_TRAP	; xF2
	JMP BAD_TRAP	; xF3
	JMP BAD_TRAP	; xF4
	JMP BAD_TRAP	; xF5
	JMP BAD_TRAP	; xF6
	JMP BAD_TRAP	; xF7
	JMP BAD_TRAP	; xF8
	JMP BAD_TRAP	; xF9
	JMP BAD_TRAP	; xFA
	JMP BAD_TRAP	; xFB
	JMP BAD_TRAP	; xFC
	JMP BAD_TRAP	; xFD
	JMP BAD_TRAP	; xFE
	JMP BAD_TRAP	; xFF

;;; OS memory address constants
USER_CODE_ADDR 	.UCONST x0000
OS_CODE_ADDR 	.UCONST x8000

OS_GLOBALS_ADDR .UCONST xA000
OS_STACK_ADDR 	.UCONST xBFFF
OS_VIDEO_ADDR 	.UCONST xC000
				
OS_KBSR_ADDR	.UCONST xFE00		; keyboard status register
OS_KBDR_ADDR	.UCONST xFE02		; keyboard data register
OS_ADSR_ADDR	.UCONST xFE04		; display status register
OS_ADDR_ADDR	.UCONST xFE06		; display data register
OS_TSR_ADDR	.UCONST xFE08		; timer register
OS_TIR_ADDR	.UCONST xFE0A		; timer interval register
OS_VDCR_ADDR	.UCONST xFE0C	        ; video display control register
OS_MCR_ADDR	.UCONST xFFEE		; machine control register

TIM_INIT 	.UCONST #100

MASK_L15 	.UCONST x7FFF
MASK_H4		.UCONST xF000
MASK_H1		.UCONST x8000
	
;;; OS_START - operating system entry point (always starts at x8200)
	
	.CODE
	.ADDR x8200
OS_START
	;; initialize timer
	LC R0, TIM_INIT
	LC R1, OS_TIR_ADDR
	STR R0, R1, #0

	;; R7 <- User code address (x0000)
	LC R7, USER_CODE_ADDR 
	RTI			; RTI removes the privilege bit

;;; Video memory
	.DATA
	.ADDR xC000	
OS_VIDEO_MEM .BLKW x3E00

;;; Space for globals
	.ADDR xA000
OS_GLOBALS_MEM	.BLKW x1000

OS_VIDEO_NUM_COLS .UCONST #128
OS_VIDEO_NUM_ROWS .UCONST #124		
	
;;; TRAP_HALT - trap handler for halting machine

;;; BAD_TRAP - code to execute for undefined trap
	.CODE
BAD_TRAP
	JMP TRAP_HALT	; execute HALT

;;; TRAP_HALT - halts the program and jumps to OS_START
	.CODE
TRAP_HALT	
	; clear run bit in MCR
	LC R3, OS_MCR_ADDR
	LDR R0, R3, #0
	LC R1, MASK_L15
	AND R0,R0,R1
	STR R0, R3, #0
	JMP OS_START 	; restart machine

	
;;; TRAP_RESET_VMEM - In double-buffered video mode, resets the video
;;; display, i.e., turns it to black.
;;; Inputs - none
;;; Outputs - none
	.CODE	
TRAP_RESET_VMEM
	LC R4, OS_VDCR_ADDR
	CONST R5, #1
	STR R5, R4, #0
	RTI

;;; TRAP_BLT_VMEM - In double-buffered video mode, copies the contents
;;; of video memory to the video display.
;;; Inputs - none
;;; Outputs - none
	.CODE
TRAP_BLT_VMEM
	LC R4, OS_VDCR_ADDR
	CONST R5, #2
	STR R5, R4, #0
	RTI
	
;;; TRAP_GETC - Check for a character from the keyboard
;;; Inputs - none
;;; Outputs - R0 the value of the KBSR - the MSB is 1 if a character was read
;;; 	      R1 the value of the character read from the keyboard

	.CODE
TRAP_GETC
	LC R4, OS_KBSR_ADDR
	LDR R0, R4, #0		; Read the KBSR into R0
	BRzp GETC_END		; Check if the MSB is zero

	LC R4, OS_KBDR_ADDR
	LDR R1, R4, #0		; Read the character into R1
	
GETC_END

	RTI
	
;;; TRAP_PUTC - Put a character on the console
;;; Inputs - R0 - ASCII character value to be output
;;; Outputs - none

	.CODE
TRAP_PUTC
	LC R4, OS_ADSR_ADDR
	LDR R1, R4, #0
	BRzp TRAP_PUTC		; Loop while the MSB is zero

	LC R4, OS_ADDR_ADDR
	STR R0, R4, #0		; Write out the character
	
	RTI


;;; TRAP_DRAW_H_LINE - Draw a horizontal line on the video display
;;; Inputs R0 - row to draw on
;;;        R1 - column address 1
;;;        R2 - column address 2
;;;        R3 - color to draw with
;;;  Outputs - none

	.CODE
TRAP_DRAW_H_LINE
;;;  First we figure out whether R1 or R2 is larger - they should both be 0-127
	CMP R1, R2
	BRnz NO_SWAP_H
;;;  Swap R1 and R2 using R4
	ADD R4, R1, #0
	ADD R1, R2, #0
	ADD R2, R4, #0
;;; Now R1 <= R2
NO_SWAP_H
	LEA R4, OS_VIDEO_MEM
	LC R5, OS_VIDEO_NUM_COLS

	MUL R5, R0, R5		; Compute (row * NUM_COLS)
	ADD R5, R5, R1		; Compute (row * NUM_COLS) + col
	ADD R4, R4, R5		; Add the offset to the start of video memory
R1_LE_R2_H
	STR R3, R4, #0		; Fill in the pixel
	ADD R4, R4, #1		; Update the pixel address
	ADD R1, R1, #1		; Update R1

	CMP R1, R2		; Test whether R1 <= R2
	BRnz R1_LE_R2_H

	RTI

	
;;; TRAP_DRAW_V_LINE - Draw a horizontal line on the video display
;;; Inputs R0 - column to draw on
;;;        R1 - row address 1
;;;        R2 - row address 2
;;;        R3 - color to draw with
;;;  Outputs - none

	.CODE
TRAP_DRAW_V_LINE
;;;  First we figure out whether R1 or R2 is larger - they should both be 0-123
	CMP R1, R2
	BRnz NO_SWAP_V
;;;  Swap R1 and R2 using R4
	ADD R4, R1, #0
	ADD R1, R2, #0
	ADD R2, R4, #0
NO_SWAP_V
;;; Now R1 <= R2
	LEA R4, OS_VIDEO_MEM
	LC R5, OS_VIDEO_NUM_COLS

	MUL R6, R1, R5		; Compute (R1 * NUM_COLS)
	ADD R6, R6, R0		; Compute (row * NUM_COLS) + col
	ADD R4, R4, R6		; Add the offset to the start of video memory
R1_LE_R2_V
	STR R3, R4, #0		; Fill in the pixel
	ADD R4, R4, R5		; Update the pixel address
	ADD R1, R1, #1		; Update R1

	CMP R1, R2		; Test whether R1 <= R2
	BRnz R1_LE_R2_V

	RTI

		
;;; TRAP_CHECK_KBD - for checking the keyboard
;;; Input
;;;   none
;;; Output
;;;   r1 - if a new keypress is available
;;; 		bottom 8 bits contain the ASCII character read while top 8 bits are 0
;;; 	    if no keypress available r1 = -1 = 0xFFFF
;;; 


	.CODE
TRAP_CHECK_KBD
	LC R4, OS_KBSR_ADDR
	CONST R1, #-1		; initialize R1 to 0xFFFF
	LDR R0, R4, #0		; Read the KBSR into R0
	BRzp CHECK_KBD_END	; Check if the MSB is zero

	LC R4, OS_KBDR_ADDR
	LDR R1, R4, #0		; Read the character into R1
	
CHECK_KBD_END
	RTI

	
;;; TRAP_GET_EVENT - for getting a keyboard or timer event
;;; Input
;;;   none
;;; Output
;;;   r5 - an integer indicating what event has happened
;;;        0 (timer) 
;;;        non-0 (keyboard character)


	.CODE
TRAP_GET_EVENT
;;;  This version of the code does not respect the stack
;;;  Check timer event
	LC R0, OS_TSR_ADDR
	LC R1, OS_KBSR_ADDR

CHECK_EVENT
	LDR R2, R1, #0		; Check keyboard
	BRnp HANDLE_KEYBOARD_EVENT
	LDR R2, R0, #0		; Check Timer
	BRnp HANDLE_TIMER_EVENT
	JMP CHECK_EVENT		; Loop checking event

HANDLE_TIMER_EVENT
	CONST R5, 0
	RTI

HANDLE_KEYBOARD_EVENT
	LC R1 OS_KBDR_ADDR
	LDR R5, R1, #0		; Get the character that was typed
	RTI
		
;;; TRAP_PUTS - for writing null-terminated string to ASCII display
;;; Input
;;;   r0 - address of first character in string
;;; Output
;;;   none

	.CODE
TRAP_PUTS
;;;  This version of the code does not respect the stack

;; 	LDR R1, R0, #0		; Load the next character into R1
;; 	BRz END_TRAP_PUTS	; Check for the zero terminating character

;; 	LC R2, OS_ADSR_ADDR
;; CHECK_ADSR
;; 	LDR R3, R2, #0
;; 	BRzp CHECK_ADSR		; Loop while ADSR[15] == 0 ie output not ready
;; 	LC R2, OS_ADDR_ADDR
;; 	STR R1, R2, #0		; Write out the character
;; 	ADD R0, R0, #1		; Increment the pointer R0
;; 	BRnzp TRAP_PUTS		; Go back to the top 
	
END_TRAP_PUTS
	RTI



;;; TRAP_DRAW_RECT - draws a rectangular block on the screen.
;;; Input
;;;   r0 - video column (left)
;;;   r1 - video row (upper)
;;;   r2 - width of block in pixels
;;;   r3 - height of block in pixels
;;;   r4 - color
;;; Output
;;;   video memory will be updated to place block of approriate color
	.CODE
TRAP_DRAW_RECT

;;;  Check if width or height is <= 0 
	CMPI R2, #0
	BRnz TRAP_DRAW_RECT_END
	CMPI R3, #0
	BRnz TRAP_DRAW_RECT_END

	;; Compute end row and store in R3
	;; R3 = MIN(OS_VIDEO_NUM_COLS, R3 + R1)	
	ADD R3, R3, R1
	LC R5 OS_VIDEO_NUM_ROWS
	CMP R3, R5
	BRnz TRAP_DRAW_RECT_L1
	LC R3 OS_VIDEO_NUM_ROWS
TRAP_DRAW_RECT_L1

	;; Compute start row and store in R1
	;; R1 = MAX(0, R1)
	CMPI R1, #0
	BRzp TRAP_DRAW_RECT_L2
	CONST R1, #0
TRAP_DRAW_RECT_L2

	;; Compute end column and store in R2
	;; R2 = MIN(OS_VIDEO_NUM_COLS, R0+R2)
	ADD R2, R2, R0
	LC R5 OS_VIDEO_NUM_COLS
	CMP R2, R5
	BRnz TRAP_DRAW_RECT_L3
	LC R2 OS_VIDEO_NUM_COLS
TRAP_DRAW_RECT_L3
	
	;; Compute start col and store in R0
	;; R0 = MAX(0, R0)
	CMPI R0, #0
	BRzp TRAP_DRAW_RECT_L4
	CONST R0, #0
TRAP_DRAW_RECT_L4

	;; Register allocation
	;; R1 - row
	;; R5 - col
	;; R6 - ptr to video memory

;;; for (row = start_row; row < end_row; ++row) {
;;;   ptr = VIDEO_MEM + row*num_cols + start_col
;;;   for (col = start_col; col < end_col; ++col, ++ptr)
;;;       *ptr = color;
;;; }
	
	JMP TRAP_DRAW_RECT_F12

TRAP_DRAW_RECT_F11

	;; Set up ptr in R6 using R5
	SLL R6, R1, #7		; R6 = R1 << 7 = R1*128
	LEA R5, OS_VIDEO_MEM
	ADD R6, R6, R5
	ADD R6, R6, R0

	ADD R5, R0, #0		; col = start_col
	JMP TRAP_DRAW_RECT_F22
TRAP_DRAW_RECT_F21
	STR R4, R6, #0		; *ptr = color
	ADD R6, R6, #1		; increment ptr
	ADD R5, R5, #1		; increment col
TRAP_DRAW_RECT_F22
	CMP R5, R2
	BRn TRAP_DRAW_RECT_F21

	ADD R1, R1, #1 		; increment row
TRAP_DRAW_RECT_F12
	CMP R1, R3
	BRn TRAP_DRAW_RECT_F11
	
TRAP_DRAW_RECT_END
	RTI

	
;;; TRAP_DRAW_SPRITE - draws an 8x8 sprite on the screen.
;;; Input
;;;   r0 - video column (left)
;;;   r1 - video row (upper) 
;;;   r2 - Address of sprite bitmap - an array of 64 words in row major order
;;; Output
;;;   video memory will be updated to include sprite of approriate color
	.CODE
TRAP_DRAW_SPRITE

;;;  Approach for (i=0; i < 64; ++i)
;;;  compute row address row = start_row + (i >> 3)
;;;  compute column address col = start_col + (i % 8) = start_col + (i & 0x7)
;;;  check if (col >= 0) && (col < OS_VIDEO_NUM_COLS)
;;;  check if (row >= 0) && (row < OS_VIDEO_NUM_ROWS)
;;;  if so transfer the pixel value
;;;  increment pointer r2
;;;  increment i

;;;  register utilization
;;;  	R3 = i
;;;  	R4 = row
;;;  	R5 = col
;;;  	R6 = address of pixel to be updated

	CONST R3, #0		; initialize i to 0

DRAW_SPRITE_L1
	SRA R4, R3, #3
	ADD R4, R4, R1		; compute row address

	CMPIU R4, #0
	BRn DRAW_SPRITE_L2
	CMPIU R4, #123
	BRp DRAW_SPRITE_L2

	AND R5, R3, 0x7
	ADD R5, R5, R0		; compute column address

	CMPIU R5, #0
	BRn DRAW_SPRITE_L2
	CMPIU R5, #127
	BRp DRAW_SPRITE_L2

	;; Compute the pixel address
	LEA R6, OS_VIDEO_MEM	
	SLL R4, R4, #7		; row *= 128
	ADD R6, R6, R4
	ADD R6, R6, R5

	LDR R4, R2, #0		; load the pixel
	STR R4, R6, #0		; store the pixel

DRAW_SPRITE_L2
	ADD R2, R2, #1		; increment pointer
	ADD R3, R3, #1 		; increment i
	CMPIU R3, #64		; check if we are done with the loop
	BRn DRAW_SPRITE_L1

	RTI

