;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 3, ex 2
; Lab section: 023
; TA: David Feng
; 
;=================================================
.ORIG x3000

;-----------------
;INSTRUCTIONS
;-----------------
LEA R1, ARRAY_PTR	;loads memory location into R1
LD R2, DEC_10		;stores #10

DO_WHILE
	GETC
	OUT
	STR R0, R1, #0		;stores input
	ADD R1, R1, #1		;increments pointer
	ADD R2, R2, #-1		;decrements #10
BRp DO_WHILE 

HALT

;-------------
;LOCAL DATA
;-------------
DEC_10			.FILL 		#10
ARRAY_PTR		.BLKW		#10	;reserves 10 memory locations


.end
