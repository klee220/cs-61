;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 2, ex 3
; Lab section: 023
; TA: David Feng
; 
;=================================================

.orig x3000
	;---------------
	; INSTRUCTIONS
	;---------------
	LD R5, DEC_65_PTR			;R5 <- Mem[DEC_65_PTR]
	LD R6, HEX_41_PTR			;R6 <- Mem[HEX_41_PTR]
	LDR R3, R5, #0				;R5 <- Mem[R5 + offset 0]
	LDR R4, R6, #0				;R6 <- Mem[R6 + offset 0]
	ADD R3, R3, #1				;R3 <- R3 + #1, increments R3 by 1
	ADD R4, R4, #1				;R4 <- R4 + #1, increments R3 by 1
	STR R3, R5, #0				;store R3 
	STR R4, R6, #0				;store R4
	
	HALT						;halt program
	
	;---------------
	; LOCAL DATA
	;---------------
	;our "remote" memory addresses 
	DEC_65_PTR	.FILL	x4000 ;put x4000 into memory 
	HEX_41_PTR	.FILL	x4001 ;put x4001 into memory 
	
;;REMOTE DATA
.orig x4000
	NEW_DEC_65	.FILL	#65
	NEW_HEX_41	.FILL	x41
	
.end
