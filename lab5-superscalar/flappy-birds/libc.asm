USER_STACK_ADDR .UCONST x7FFF
USER_STACK_SIZE .UCONST x1000
USER_HEAP_SIZE .UCONST x3000	
;;; Reserve space for heap and stack so that assembler will not try to
;;; place data in these regions
	
.DATA
.ADDR x4000
USER_HEAP	.BLKW x3000
.ADDR x7000			
USER_STACK	.BLKW x1000

.CODE
.ADDR x0000	
	.FALIGN
__start
	LC R6, USER_STACK_ADDR	; Init the Stack Pointer
	LEA R7, main		; Invoke the main routine
	JSRR R7
	TRAP x25		; HALT

;;; Wrappers for the traps.  Marshall the arguments from stack to 
;;; registers and return value from register to stack

	.FALIGN
lc4_puts
	;; prologue
	ADD R6, R6, #-2
	STR R5, R6, #0
	STR R7, R6, #1
	
	LEA R7, STACK_SAVER
	STR R6, R7, #0

	
	;; marshall arguments
	LDR R0, R6, #2

	TRAP x08

	;; epilogue
	LEA R7, STACK_SAVER
	LDR R6, R7, #0

	LDR R7, R6, #1
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET
	
	.FALIGN
lc4_check_kbd 
	;; R5 is the base pointer as well as the 
	;; TRAP return register.  If the trap returns
	;; a value, we have to save and restore the user's
	;; base-pointer
	ADD R6, R6, #-2	
	STR R5, R6, #0
	STR R7, R6, #1

	LEA R7, STACK_SAVER
	STR R6, R7, #0

	TRAP x09
	
	LEA R7, STACK_SAVER
	LDR R6, R7, #0	

	LDR R7, R6, #1
	;; save TRAP return value on stack
	STR R1, R6, #1
	;; restore user base-pointer
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET

	.FALIGN
lc4_get_event 
	;; R5 is the base pointer as well as the 
	;; TRAP return register.  If the trap returns
	;; a value, we have to save and restore the user's
	;; base-pointer
	ADD R6, R6, #-2	
	STR R5, R6, #0
	STR R7, R6, #1

	LEA R7, STACK_SAVER
	STR R6, R7, #0

	TRAP x07
	
	LEA R7, STACK_SAVER
	LDR R6, R7, #0	

	LDR R7, R6, #1
	;; save TRAP return value on stack
	STR R5, R6, #1
	;; restore user base-pointer
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET

	.FALIGN
lc4_draw_rect
	;; prologue
	ADD R6, R6, #-2
	STR R5, R6, #0
	STR R7, R6, #1
	;; marshall arguments
	LDR R0, R6, #2		; x
	LDR R1, R6, #3		; y
	LDR R2, R6, #4		; width
	LDR R3, R6, #5		; height
	LDR R4, R6, #6		; color

	LEA R7, STACK_SAVER
	STR R6, R7, #0
	
	TRAP x0A
	
	LEA R7, STACK_SAVER
	LDR R6, R7, #0
	
	;; epilogue
	LDR R7, R6, #1
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET

	.FALIGN
lc4_draw_sprite
	;; prologue
	ADD R6, R6, #-2
	STR R5, R6, #0
	STR R7, R6, #1
	;; marshall arguments
	LDR R0, R6, #2		; x
	LDR R1, R6, #3		; y
	LDR R2, R6, #4		; sprite
	
	LEA R7, STACK_SAVER
	STR R6, R7, #0
	
	TRAP x0B
	
	LEA R7, STACK_SAVER
	LDR R6, R7, #0
	
	;; epilogue
	LDR R7, R6, #1
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET
	
	.FALIGN	
lc4_halt
	;; prologue
	ADD R6, R6, #-2
	LDR R5, R6, #0
	STR R7, R6, #1
	;; no arguments
	TRAP x25
	;; epilogue
	LDR R7, R6, #1
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET			

	.FALIGN
lc4_reset_vmem
	;; prologue
	ADD R6, R6, #-7
	STR R5, R6, #0
	STR R7, R6, #1
        STR R0, R6, #2
        STR R1, R6, #3
        STR R2, R6, #4
        STR R3, R6, #5
        STR R4, R6, #6

        ;; LEA R7, RESET_VMEM_COUNTER
        ;; CONST R0, #4           ; iterations to perform
        ;; STR R0, R7, #0

reset_vmem_loop
        ;; set arguments
        CONST R0, #0            ; x
        CONST R1, #0            ; y
        CONST R2, #128          ; width
        CONST R3, #124          ; height
        CONST R4, #0            ; color

	LEA R7, STACK_SAVER
	STR R6, R7, #0
        
	TRAP x0A                ; call lc4_draw_rect

	LEA R7, STACK_SAVER
	LDR R6, R7, #0

        ;; LEA R7, RESET_VMEM_COUNTER
        ;; LDR R0, R7, #0
        ;; ADD R0, R0, #-1
        ;; STR R0, R7, #0
        ;; ADD R0, R0, #0
        ;; BRp reset_vmem_loop
        
	;; epilogue
	LDR R5, R6, #0
	LDR R7, R6, #1
        LDR R0, R6, #2
        LDR R1, R6, #3
        LDR R2, R6, #4
        LDR R3, R6, #5
        LDR R4, R6, #6
	ADD R6, R6, #7
	RET

	.FALIGN
lc4_blt_vmem
	;; prologue
	ADD R6, R6, #-2
	STR R5, R6, #0
	STR R7, R6, #1

        ;; NOP loop to slow the game down to be playable on hardware
        CONST R5, #255
        ;; HICONST R5, x7F         ; run for 2K iterations
LC4_BLT_VMEM_LOOP
        ADD R5, R5, #-1
        BRzp LC4_BLT_VMEM_LOOP

        ;; no arguments
;;; TRAP x27
        
	;; epilogue
	LDR R5, R6, #0
	LDR R7, R6, #1
	ADD R6, R6, #2
	RET

		
	.FALIGN
lc4_lfsr 
	;; R5 is the base pointer as well as the 
	;; TRAP return register.  If the trap returns
	;; a value, we have to save and restore the user's
	;; base-pointer
	ADD R6, R6, #-2	
	STR R5, R6, #0
	STR R7, R6, #1

	LEA R3, LFSR
	LDR R0, R3, 0

	SLL R1, R0,  2		; move bit 13 to MSB
	XOR R2, R0, R1		; xor with bit 15

	SLL R1, R0, 3		; move bit 12 to MSB
	XOR R2, R1, R2

	SLL R1, R0, 5		; move bit 10 to MSB
	XOR R2, R1, R2

	SRL R2, R2, 15		; Shift right logical move MSB to LSB and zeros elsewhere

	SLL R0, R0, 1		; shift left by one bit
	OR  R0, R0, R2		; add in the LSB - note upper bits of R2 are all 0

	STR R0, R3, 0		; update the LFSR in memory
	
	;; save LFSR return value on stack
	STR R0, R6, #1
	;; restore user base-pointer
	LDR R5, R6, #0
	ADD R6, R6, #2
	RET
	
	
;;; Other library data will start at x2000
;;; This needs to be here so that subsequent files will have their user data
;;;  placed appropriately
.DATA
.ADDR x2000

;;;  We use this storage location to cache the Stack Pointer so that
;;;  we can restore the stack appropriately after a TRAP. It is only
;;;  needed for traps that overwrite R6
STACK_SAVER .FILL 0x0000

RESET_VMEM_COUNTER .FILL 0x0000
        
;;;  LFSR value used by lfsr code
LFSR .FILL 0x0001
