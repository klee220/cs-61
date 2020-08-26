;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 2. ex 1
; Lab section: 023
; TA: David Feng
; 
;=================================================
.orig x3000
	;---------------
	; INSTRUCTIONS
	;---------------
	
	LD R3, DEC_65		;R3 <- Mem[DEC_65]
	LD R4, HEX_41		;R4 <- Mem[HEX_41]
	
	HALT				;halt program
	
	;---------------
	; LOCAL DATA
	;---------------
	
	DEC_65	.FILL	#65 ;put #65 into memory 
	HEX_41	.FILL	x41 ;put x41 into memory 
	
.end
