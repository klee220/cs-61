;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 023
; TA: David Feng
; 
;=================================================

.orig x3000
;-------------
;INSTRUCTIONS
;-------------
LD R3, DEC_10	;stores #10

LD R1, ptr		;loads pointer 	

LD R2, one		;load 2^0

LD R4, SUB_PRINT_3200	 ;load subroutine address

STR R2, R1, #0		;stores 0 in R1

ADD R3, R3, #-1		;decrements #10
ADD R1, R1, #1		;increment pointer

DO_WHILE
	ADD R2, R2, R2		;gets next number
	STR R2, R1, #0		;stores number
	ADD R1, R1, #1		;increments pointer
	ADD R3, R3, #-1		;decrements #10
BRp DO_WHILE 

LD R1, ptr
;ADD R1, R1, #6  ;go to seventh value
;LDR R2, R1, #0	;store seventh value in R2

LD R3, DEC_10	;stores #10
LD R1, ptr		;reset pointer		

DO
	LDR R0, R1, #0		;load array element to R0
	JSRR R4
	ADD R1, R1, #1		;increments pointer
	ADD R3, R3, #-1		;decrements #10
BRp DO 


HALT

;------
;DATA
;------
DEC_10	.FILL	#10
one		.FILL	#1
ptr		.FILL	x4000
SUB_PRINT_3200 .FILL x3200
.orig x4000
array	.BLKW	#10

.end

;=================================================
;subroutine: SUB_PRINT_3200	
;input: value that will be converted to 16 bit ascii 1s and 0s
;postcondition: the subroutine has calculated the binary representation
;			of the value in R0 and printed it
;return value; none
;=================================================
.ORIG x3200			; Program begins here

ST R1, backup_r1_3200
ST R4, backup_r4_3200
ST R3, backup_r3_3200
ST R7, backup_r7_3200

;subroutine algorithm
;LD R6, Value_ptr	; R6 <-- pointer to value to be displayed as binary
AND R1, R1, #0
ADD R1, R0, #0
;LDR R0, R1, #0		; R1 <-- value to be displayed as binary 
LD R2, sixteen 	;load counter
LD R3, four		;load #4
LD R4, steen 	;load #16

DO_W 
ADD R2, R2, #-1	;decrement counter
BRn bye			;end while loop
ADD R1, R1, #0 	;the value
BRn DO_L		;negative branch
BRzp DOO		;positive/zero branch

DO_L
LD R0, neg
OUT				;print 1
ADD R3, R3, #-1	;decrement four
BRz SPACE_L

DO_LC			;continue
ADD R1, R1, R1 	;left shift, multiply by 2
BRnzp DO_W

DOO				
LD R0, pos
OUT				;print 0
ADD R3, R3, #-1	;decrement four
BRz SPACE

DOO_C			;continue
ADD R1, R1, R1 	;left shift, multiply by 2
BRnzp DO_W

SPACE
ADD R4, R4, #-4	
BRz bye			;if 16 bits printed, omit space
LD R0, sp		
OUT				;print space
LD R3, four
BRnzp DOO_C		;continue

SPACE_L
ADD R4, R4, #-4	
BRz bye			;if 16 bits printed, omit space
LD R0, sp		
OUT				;print space
LD R3, four
BRnzp DO_LC		;continue

bye
LD R0, newline
OUT

LD R3, backup_r3_3200
LD R7, backup_r7_3200
LD R4, backup_r4_3200	
LD R1, backup_r1_3200
LD R0, backup_r0_3200


RET
;---------------	
;Data
;---------------
;Value_ptr	.FILL xB270	; The address where value to be displayed is stored
sixteen 	.FILL #16	;counter
neg			.FILL '1'
pos			.FILL '0'
four		.FILL #4	
sp			.FILL ' ' 	;space
newline		.FILL '\n'
steen 		.FILL #16	;counter
zero		.FILL #0

backup_r3_3200	.BLKW #1
backup_r7_3200	.BLKW #1
backup_r4_3200	.BLKW #1
backup_r1_3200	.BLKW #1	
backup_r0_3200	.BLKW #1



;.ORIG xB270					; Remote data
;Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!!
							;Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
