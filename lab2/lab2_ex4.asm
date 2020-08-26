;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 2, ex 4
; Lab section: 023
; TA: David Feng
; 
;=================================================
.orig x3000

;-----------------
; INSTRUCTIONS
;-----------------
	LD R0, HEX_61 
	LD R1, HEX_1A
	
	DO_WHILE_LOOP
		OUT 
		ADD R0, R0, #1		;R0 <-- R0 + #1
		ADD R1, R1, #-1		;R1 <-- R1 - #1

		BRp DO_WHILE_LOOP	;If (R1>0): goto DO_WHILE_LOOP
	END_DO_WHILE_LOOP 

	HALT

;--------------
; LOCAL DATA 
;--------------

	HEX_61	.FILL	x61	;put x61 into memory
	HEX_1A	.FILL	x1A	;put x1A into memory
	
.end
