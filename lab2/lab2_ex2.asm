;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 2, ex 2
; Lab section: 023
; TA: David Feng
; 
;=================================================
.orig x3000
	;---------------
	; INSTRUCTIONS
	;---------------
	LDI R3, DEC_65_PTR		;R3 <- Mem[DEC_65_PTR]
	LDI R4, HEX_41_PTR		;R4 <- Mem[HEX_41_PTR]
	ADD R3, R3, #1			;R3 <- R3 + #1
	ADD R4, R4, #1			;R4 <- R4 + #1
	STI R3, DEC_65_PTR		;store R3 
	STI R4, HEX_41_PTR		;store R4
	
	HALT					;halt program
	
	;---------------
	; LOCAL DATA
	;---------------
	DEC_65_PTR	.FILL	x4000 ;put x4000 into memory 
	HEX_41_PTR	.FILL	x4001 ;put x4001 into memory 
	
;;REMOTE DATA
.orig x4000
	NEW_DEC_65	.FILL	#65
	NEW_HEX_41	.FILL	x41
	
.end
	
