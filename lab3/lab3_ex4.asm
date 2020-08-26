;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 023
; TA: David Feng
; 
;=================================================
.ORIG x3000

;-----------------
;INSTRUCTIONS
;-----------------
LD R1, ARRAY_PTR	;loads memory location into R1

DO_WHILE
	GETC
	STR R0, R1, #0		;stores input in array
	ADD R0, R0, #-10	;check if input is sentinel char: enter
BRz CONTINUE			;if it is sentinel char, do nothing

	ADD R0, R0, #10		;check if input is sentinel char: enter
	OUT
	ADD R1, R1, #1		;increments pointer
BRnzp DO_WHILE 

CONTINUE

LD R0, ENDL				;prints newline
OUT
LD R1, ARRAY_PTR		;resets pointer

DO_WHILE_L
	LDR R0, R1, #0		;stores array element
	OUT 
	ADD R1, R1, #1		;increments pointer
	ADD R0, R0, #-10	;check if input is sentinel char: enter
BRnp DO_WHILE_L

LD R0, ENDL				;prints newline
OUT

HALT

;-------------
;LOCAL DATA
;-------------
DEC_10			.FILL 		#10
ARRAY_PTR		.FILL 		x4000 	;ptr starts at memory location x4000
ENDL			.FILL		x0A		;newline
ZERO			.FILL		#0

.end


