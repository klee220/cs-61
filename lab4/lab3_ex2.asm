;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 4, ex 2
; Lab section: 023 
; TA: David Feng
; 
;=================================================

.orig x3000
;-------------
;INSTRUCTIONS
;-------------
LD R3, DEC_10		;stores #10

LD R1, ptr		;loads pointer 	

AND R2, R2, x0		;R2 <- (R2) AND x0000

STR R2, R1, #0		;stores 0 in R1

ADD R3, R3, #-1		;decrements #10
ADD R1, R1, #1		;increment pointer

DO_WHILE
	ADD R2, R2, #1		;gets next number
	STR R2, R1, #0		;stores number
	ADD R1, R1, #1		;increments pointer
	ADD R3, R3, #-1		;decrements #10
BRp DO_WHILE 

LD R1, ptr
ADD R1, R1, #6  ;go to seventh value
LDR R2, R1, #0	;store seventh value in R2

LD R3, DEC_10		;stores #10

LD R1, ptr
DO
	LDR R0, R1, #0
	ADD R0, R0, #12		;convert to '0'
	ADD R0, R0, #12
	ADD R0, R0, #12
	ADD R0, R0, #12
	OUT
	ADD R1, R1, #1		;increments pointer
	ADD R3, R3, #-1		;decrements #10
BRp DO 




HALT

;------
;DATA
;------
DEC_10	.FILL	#10
ptr		.FILL	x4000

.orig x4000
array	.BLKW	#10

.end
