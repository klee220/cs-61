;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 023
; TA: David Feng
; 
;=================================================
.orig x3000
	;---------------
	; INSTRUCTIONS
	;---------------
	LD R5, DATA_PTR				;R5 <- Mem[DATA_PTR]
	LDR R3, R5, #0				;R3 <- Mem[R5 + offset 0], stores #65 
	ADD R3, R3, #1				;R3 <- R3 + #1, increments R3 by 1	
	STR R3, R5, #0				;store R3 
	
	ADD R5, R5, #1				;increment pointer by 1

	LDR R4, R5, #0				;R4 <- Mem[R6 + offset 0], stores x41
	ADD R4, R4, #1				;R4 <- R4 + #1, increments R3 by 1	
	STR R4, R5, #0				;store R4
	 
	
	HALT						;halt program
	
	;---------------
	; LOCAL DATA
	;---------------
	DATA_PTR	.FILL 	x4000	;address of the start of remote data block
	
;;REMOTE DATA
.orig x4000
	NEW_DEC_65	.FILL	#65
	NEW_HEX_41	.FILL	x41
	
.end
