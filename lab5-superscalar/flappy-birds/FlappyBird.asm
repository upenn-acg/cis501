		.DATA
bird_x 		.FILL #35
		.DATA
bird_y 		.FILL #62
		.DATA
bird_vx 		.FILL #1
		.DATA
bird_vy 		.FILL #0
		.DATA
ay 		.FILL #0
		.DATA
counter 		.FILL #0
		.DATA
score 		.FILL #-1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;printnum;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
printnum
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-13	;; allocate stack space for local variables
	;; function body
	LDR R7, R5, #4
	CONST R3, #0
	CMP R7, R3
	BRnp L3_FlappyBird
	LEA R7, L5_FlappyBird
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L2_FlappyBird
L3_FlappyBird
	LDR R7, R5, #4
	CONST R3, #0
	CMP R7, R3
	BRzp L7_FlappyBird
	LDR R7, R5, #4
	NOT R7,R7
	ADD R7,R7,#1
	STR R7, R5, #-13
	JMP L8_FlappyBird
L7_FlappyBird
	LDR R7, R5, #4
	STR R7, R5, #-13
L8_FlappyBird
	LDR R7, R5, #-13
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRzp L9_FlappyBird
	LEA R7, L11_FlappyBird
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L2_FlappyBird
L9_FlappyBird
	ADD R7, R5, #-12
	ADD R7, R7, #10
	STR R7, R5, #-2
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
	CONST R3, #0
	STR R3, R7, #0
	JMP L13_FlappyBird
L12_FlappyBird
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
	LDR R3, R5, #-1
	CONST R2, #10
	MOD R3, R3, R2
	CONST R2, #48
	ADD R3, R3, R2
	STR R3, R7, #0
	LDR R7, R5, #-1
	CONST R3, #10
	DIV R7, R7, R3
	STR R7, R5, #-1
L13_FlappyBird
	LDR R7, R5, #-1
	CONST R3, #0
	CMP R7, R3
	BRnp L12_FlappyBird
	LDR R7, R5, #4
	CONST R3, #0
	CMP R7, R3
	BRzp L15_FlappyBird
	LDR R7, R5, #-2
	ADD R7, R7, #-1
	STR R7, R5, #-2
	CONST R3, #45
	STR R3, R7, #0
L15_FlappyBird
	LDR R7, R5, #-2
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L2_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;endl;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
endl
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LEA R7, L18_FlappyBird
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L17_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;rand16;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
rand16
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR lc4_lfsr
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #127
	AND R7, R7, R3
L19_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

		.DATA
bird_sprite 		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #65535
		.FILL #65535
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #65535
		.FILL #65535
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #32752
		.FILL #31744
		.FILL #31744
		.FILL #32752
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #32752
		.FILL #32752
		.FILL #0
		.FILL #32752
		.FILL #32752
		.FILL #0
		.DATA
bird_sprite2 		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #65535
		.FILL #65535
		.FILL #31744
		.FILL #0
		.FILL #31744
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #65535
		.FILL #65535
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #32752
		.FILL #31744
		.FILL #31744
		.FILL #32752
		.FILL #31744
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #32752
		.FILL #32752
		.FILL #0
		.FILL #32752
		.FILL #32752
		.FILL #0
		.DATA
s_zero 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_one 		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_two 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_three 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_four 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_five 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_six 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_seven 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_eight 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.DATA
s_nine 		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #0
		.FILL #65535
		.FILL #0
		.FILL #0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;draw_pipes;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
draw_pipes
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
L21_FlappyBird
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	CONST R3, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	CONST R3, #0
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #2
	CONST R2, #124
	SUB R2, R2, R3
	ADD R6, R6, #-1
	STR R2, R6, #0
	CONST R2, #1
	ADD R6, R6, #-1
	STR R2, R6, #0
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	CONST R3, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	CONST R3, #0
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R7, R7, #10
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #2
	CONST R2, #124
	SUB R2, R2, R3
	ADD R6, R6, #-1
	STR R2, R6, #0
	CONST R2, #1
	ADD R6, R6, #-1
	STR R2, R6, #0
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R7, R7, #10
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #1
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #11
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #1
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
	CONST R7, #0
	HICONST R7, #51
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #1
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #10
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #2
	ADD R6, R6, #-1
	STR R3, R6, #0
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_rect
	ADD R6, R6, #5	;; free space for arguments
L22_FlappyBird
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #4
	CMP R7, R3
	BRn L21_FlappyBird
L20_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;draw_bird;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
draw_bird
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LEA R7, counter
	LDR R7, R7, #0
	CONST R3, #2
	CMP R7, R3
	BRzp L26_FlappyBird
	LEA R7, bird_sprite
	ADD R6, R6, #-1
	STR R7, R6, #0
	LEA R7, bird_y
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	LEA R7, bird_x
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L27_FlappyBird
L26_FlappyBird
	LEA R7, bird_sprite2
	ADD R6, R6, #-1
	STR R7, R6, #0
	LEA R7, bird_y
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	LEA R7, bird_x
	LDR R7, R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
L27_FlappyBird
L25_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;redraw;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
redraw
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	JSR lc4_reset_vmem
	ADD R6, R6, #0	;; free space for arguments
	JSR draw_pipes
	ADD R6, R6, #0	;; free space for arguments
	JSR draw_bird
	ADD R6, R6, #0	;; free space for arguments
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	CMP R7, R3
	BRzp L29_FlappyBird
	LEA R7, s_zero
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L30_FlappyBird
L29_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #20
	CMP R7, R3
	BRzp L31_FlappyBird
	LEA R7, s_one
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L32_FlappyBird
L31_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #30
	CMP R7, R3
	BRzp L33_FlappyBird
	LEA R7, s_two
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L34_FlappyBird
L33_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #40
	CMP R7, R3
	BRzp L35_FlappyBird
	LEA R7, s_three
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L36_FlappyBird
L35_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #50
	CMP R7, R3
	BRzp L37_FlappyBird
	LEA R7, s_four
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L38_FlappyBird
L37_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #70
	CMP R7, R3
	BRzp L39_FlappyBird
	LEA R7, s_five
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L40_FlappyBird
L39_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #70
	CMP R7, R3
	BRzp L41_FlappyBird
	LEA R7, s_six
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L42_FlappyBird
L41_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #80
	CMP R7, R3
	BRzp L43_FlappyBird
	LEA R7, s_seven
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L44_FlappyBird
L43_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #90
	CMP R7, R3
	BRzp L45_FlappyBird
	LEA R7, s_eight
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L46_FlappyBird
L45_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #100
	CMP R7, R3
	BRzp L47_FlappyBird
	LEA R7, s_nine
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
L47_FlappyBird
L46_FlappyBird
L44_FlappyBird
L42_FlappyBird
L40_FlappyBird
L38_FlappyBird
L36_FlappyBird
L34_FlappyBird
L32_FlappyBird
L30_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #-1
	CMP R7, R3
	BRnp L49_FlappyBird
	LEA R7, s_zero
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L50_FlappyBird
L49_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #1
	CMP R7, R3
	BRnp L51_FlappyBird
	LEA R7, s_one
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L52_FlappyBird
L51_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #2
	CMP R7, R3
	BRnp L53_FlappyBird
	LEA R7, s_two
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L54_FlappyBird
L53_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #3
	CMP R7, R3
	BRnp L55_FlappyBird
	LEA R7, s_three
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L56_FlappyBird
L55_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #4
	CMP R7, R3
	BRnp L57_FlappyBird
	LEA R7, s_four
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L58_FlappyBird
L57_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #5
	CMP R7, R3
	BRnp L59_FlappyBird
	LEA R7, s_five
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L60_FlappyBird
L59_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #6
	CMP R7, R3
	BRnp L61_FlappyBird
	LEA R7, s_six
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L62_FlappyBird
L61_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #7
	CMP R7, R3
	BRnp L63_FlappyBird
	LEA R7, s_seven
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L64_FlappyBird
L63_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #8
	CMP R7, R3
	BRnp L65_FlappyBird
	LEA R7, s_eight
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L66_FlappyBird
L65_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #9
	CMP R7, R3
	BRnp L67_FlappyBird
	LEA R7, s_nine
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
	JMP L68_FlappyBird
L67_FlappyBird
	LEA R7, score
	LDR R7, R7, #0
	CONST R3, #10
	MOD R7, R7, R3
	CONST R3, #0
	CMP R7, R3
	BRnp L69_FlappyBird
	LEA R7, s_zero
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #0
	ADD R6, R6, #-1
	STR R7, R6, #0
	CONST R7, #6
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_draw_sprite
	ADD R6, R6, #3	;; free space for arguments
L69_FlappyBird
L68_FlappyBird
L66_FlappyBird
L64_FlappyBird
L62_FlappyBird
L60_FlappyBird
L58_FlappyBird
L56_FlappyBird
L54_FlappyBird
L52_FlappyBird
L50_FlappyBird
	JSR lc4_blt_vmem
	ADD R6, R6, #0	;; free space for arguments
L28_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;reset_game_state;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
reset_game_state
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	LEA R7, score
	CONST R3, #-1
	STR R3, R7, #0
	LEA R7, bird_x
	CONST R3, #35
	STR R3, R7, #0
	LEA R7, bird_y
	CONST R3, #62
	STR R3, R7, #0
	LEA R7, bird_vx
	CONST R3, #1
	STR R3, R7, #0
	CONST R7, #0
	LEA R3, bird_vy
	STR R7, R3, #0
	STR R7, R5, #-1
L72_FlappyBird
	LDR R7, R5, #-1
	CONST R3, #3
	MUL R3, R3, R7
	LEA R2, the_pipes
	ADD R3, R3, R2
	SLL R7, R7, #5
	CONST R2, #70
	ADD R7, R7, R2
	STR R7, R3, #0
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #3
	LDR R2, R5, #-1
	MUL R3, R3, R2
	LEA R2, the_pipes
	ADD R3, R3, R2
	CONST R2, #53
	MOD R7, R7, R2
	ADD R7, R7, #5
	STR R7, R3, #1
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #1
	CONST R2, #60
	ADD R3, R3, R2
	STR R3, R7, #2
L73_FlappyBird
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #4
	CMP R7, R3
	BRn L72_FlappyBird
L71_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;update_pipes;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
update_pipes
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
L77_FlappyBird
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R7, R7, #0
	CONST R3, #0
	CMP R7, R3
	BRnz L81_FlappyBird
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #0
	LEA R2, bird_vx
	LDR R2, R2, #0
	SUB R3, R3, R2
	STR R3, R7, #0
	JMP L82_FlappyBird
L81_FlappyBird
	LEA R7, score
	LDR R3, R7, #0
	ADD R3, R3, #1
	STR R3, R7, #0
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	CONST R3, #128
	STR R3, R7, #0
	JSR rand16
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #3
	LDR R2, R5, #-1
	MUL R3, R3, R2
	LEA R2, the_pipes
	ADD R3, R3, R2
	CONST R2, #53
	MOD R7, R7, R2
	ADD R7, R7, #5
	STR R7, R3, #1
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R3, R7, #1
	CONST R2, #60
	ADD R3, R3, R2
	STR R3, R7, #2
L82_FlappyBird
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R7, R7, #0
	CONST R3, #129
	CMP R7, R3
	BRnp L83_FlappyBird
	LEA R7, score
	LDR R3, R7, #0
	ADD R3, R3, #1
	STR R3, R7, #0
L83_FlappyBird
L78_FlappyBird
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #4
	CMP R7, R3
	BRn L77_FlappyBird
L76_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;update_bird;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
update_bird
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	;; function body
	LDR R7, R5, #4
	CONST R3, #0
	CMP R7, R3
	BRnp L86_FlappyBird
	LEA R7, ay
	CONST R3, #1
	STR R3, R7, #0
	JMP L87_FlappyBird
L86_FlappyBird
	LEA R7, ay
	CONST R3, #-1
	STR R3, R7, #0
L87_FlappyBird
	LEA R7, bird_y
	LEA R3, bird_vy
	LDR R2, R3, #0
	LDR R1, R7, #0
	ADD R1, R1, R2
	STR R1, R7, #0
	LEA R7, ay
	LDR R7, R7, #0
	ADD R7, R2, R7
	STR R7, R3, #0
	LDR R7, R3, #0
	CONST R3, #5
	CMP R7, R3
	BRnz L88_FlappyBird
	LEA R7, bird_vy
	CONST R3, #5
	STR R3, R7, #0
	JMP L89_FlappyBird
L88_FlappyBird
	LEA R7, bird_vy
	LDR R7, R7, #0
	CONST R3, #-5
	CMP R7, R3
	BRzp L90_FlappyBird
	LEA R7, bird_vy
	CONST R3, #-5
	STR R3, R7, #0
L90_FlappyBird
L89_FlappyBird
L85_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;dead_bird;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
dead_bird
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-3	;; allocate stack space for local variables
	;; function body
	CONST R7, #0
	STR R7, R5, #-1
L93_FlappyBird
	CONST R7, #3
	LDR R3, R5, #-1
	MUL R7, R7, R3
	LEA R3, the_pipes
	ADD R7, R7, R3
	LDR R7, R7, #0
	STR R7, R5, #-2
	CONST R3, #27
	CMP R7, R3
	BRnz L97_FlappyBird
	CONST R7, #43
	LDR R3, R5, #-2
	CMP R3, R7
	BRzp L97_FlappyBird
	LEA R7, bird_y
	LDR R7, R7, #0
	STR R7, R5, #-3
	CONST R3, #3
	LDR R2, R5, #-1
	MUL R3, R3, R2
	LEA R2, the_pipes
	ADD R3, R3, R2
	LDR R2, R3, #1
	CMP R7, R2
	BRn L101_FlappyBird
	LDR R7, R5, #-3
	ADD R7, R7, #8
	LDR R3, R3, #2
	CMP R7, R3
	BRnz L99_FlappyBird
L101_FlappyBird
	CONST R7, #1
	JMP L92_FlappyBird
L99_FlappyBird
L97_FlappyBird
L94_FlappyBird
	LDR R7, R5, #-1
	ADD R7, R7, #1
	STR R7, R5, #-1
	LDR R7, R5, #-1
	CONST R3, #4
	CMP R7, R3
	BRn L93_FlappyBird
	LEA R7, bird_y
	LDR R7, R7, #0
	STR R7, R5, #-2
	CONST R3, #0
	CMP R7, R3
	BRn L104_FlappyBird
	LDR R7, R5, #-2
	ADD R7, R7, #8
	CONST R3, #124
	CMP R7, R3
	BRnz L102_FlappyBird
L104_FlappyBird
	CONST R7, #1
	JMP L92_FlappyBird
L102_FlappyBird
	CONST R7, #0
L92_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;main;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		.CODE
		.FALIGN
main
	;; prologue
	STR R7, R6, #-2	;; save return address
	STR R5, R6, #-3	;; save base pointer
	ADD R6, R6, #-3
	ADD R5, R6, #0
	ADD R6, R6, #-1	;; allocate stack space for local variables
	;; function body
	LEA R7, L106_FlappyBird
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JSR reset_game_state
	ADD R6, R6, #0	;; free space for arguments
	JSR redraw
	ADD R6, R6, #0	;; free space for arguments
	JMP L108_FlappyBird
L107_FlappyBird
	LEA R7, L110_FlappyBird
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
L111_FlappyBird
L112_FlappyBird
	JSR lc4_check_kbd
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #114
	CMP R7, R3
	BRnp L111_FlappyBird
	JSR reset_game_state
	ADD R6, R6, #0	;; free space for arguments
	JSR redraw
	ADD R6, R6, #0	;; free space for arguments
	JMP L115_FlappyBird
L114_FlappyBird
	LEA R7, counter
	LDR R3, R7, #0
	ADD R3, R3, #1
	CONST R2, #4
	MOD R3, R3, R2
	STR R3, R7, #0
	JSR lc4_get_event
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	STR R7, R5, #-1
	JSR update_pipes
	ADD R6, R6, #0	;; free space for arguments
	LDR R7, R5, #-1
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR update_bird
	ADD R6, R6, #1	;; free space for arguments
	JSR redraw
	ADD R6, R6, #0	;; free space for arguments
	JSR dead_bird
	LDR R7, R6, #-1	;; grab return value
	ADD R6, R6, #0	;; free space for arguments
	CONST R3, #0
	CMP R7, R3
	BRz L117_FlappyBird
	LEA R7, L119_FlappyBird
	ADD R6, R6, #-1
	STR R7, R6, #0
	JSR lc4_puts
	ADD R6, R6, #1	;; free space for arguments
	JMP L116_FlappyBird
L117_FlappyBird
L115_FlappyBird
	JMP L114_FlappyBird
L116_FlappyBird
L108_FlappyBird
	JMP L107_FlappyBird
	CONST R7, #0
L105_FlappyBird
	;; epilogue
	ADD R6, R5, #0	;; pop locals off stack
	ADD R6, R6, #3	;; free space for return address, base pointer, and return value
	STR R7, R6, #-1	;; store return value
	LDR R5, R6, #-3	;; restore base pointer
	LDR R7, R6, #-2	;; restore return address
	RET

		.DATA
the_pipes 		.BLKW 12
		.DATA
L119_FlappyBird 		.STRINGZ "**** GAME OVER ****\n"
		.DATA
L110_FlappyBird 		.STRINGZ "Press r to reset\n"
		.DATA
L106_FlappyBird 		.STRINGZ "!!! Welcome to FlappyBird !!!\n"
		.DATA
L18_FlappyBird 		.STRINGZ "\n"
		.DATA
L11_FlappyBird 		.STRINGZ "-32768"
		.DATA
L5_FlappyBird 		.STRINGZ "0"
