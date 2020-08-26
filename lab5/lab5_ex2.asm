;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 5, ex 2
; Lab section: 023
; TA: David Feng
; 
;==================================================
.ORIG x3000

;---------------
;INSTRUCTIONS
;---------------

LD  R5, SUB_CONVERT_3200			;R5 <-- x3200
JSRR R5					;Jump to SUB_CONVERT subroutine

ADD R2, R1, #0				;Put contents of R1 (total) into R2

LD  R5, SUB_PRINT_3400			;R5 <-- x3400
JSRR R5					;Jump to SUB_PRINT


HALT

;-----------------
;Local data
;-----------------

SUB_CONVERT_3200		.FILL		x3200
SUB_PRINT_3400			.FILL		x3400

;==================================================
;Subroutine: SUB_CONVERT_3200
;Input (None):
;Post-condition: The user entered 16-bit binary number
;		 is converted to a single value 16-bit
;		 binary number
;Return value: R1 <-- 16-bit value
;==================================================
.ORIG x3200

ST R7, BACKUP_R7_3200
ST R4, BACKUP_R4_3200
ST R5, BACKUP_R5_3200
ST R0, BACKUP_R0_3200


LD R1, TOTAL				;R1 <-- TOTAL == #0
LD R3, COUNTER				;Load 16 counter into R3
LD R5, ASCII_SHIFT			;Load #-49 into R5

LEA R0, PROMPT				;Load PROMPT into R0
PUTS					;Output PROMPT to console

GETC					;Get user input 'b' stored in R0
OUT

DO_WHILE_LOOP

	GETC				;Get '1' or '0' from user input
	OUT
	ADD R4, R0, #0			;Store user-entered char '1' or '0' into R4

	ADD R3, R3, #0			;Make counter LMF
	BRp  CALCULATE			;Go to CALCULATE branch if there is more input

	ADD R4, R4, R5			;Check if '1' or '0'
	BRz  ONE
	BRn  ZERO

	CALCULATE

		ADD R1, R1, R1		;Double R1
		ADD R4, R4, #0		;Make R4 LMF

		ADD R4, R4, R5		;Check if '1' or '0'
		BRz ONE			;Go to ONE branch if '1'
		BRn ZERO		;Go to ZERO branch if '0'

	ONE

		ADD R1, R1, #1		;R1 <-- R1 + #1
		ADD R3, R3, #-1		;Decrement counter
		BRz END_DO_WHILE_LOOP	;Go to end of loop
		BRp DO_WHILE_LOOP

	ZERO

		ADD R3, R3, #-1		;Decrement counter
		BRz END_DO_WHILE_LOOP	;Go to end of loop
		BRp DO_WHILE_LOOP	;Loop again if counter is still positive

END_DO_WHILE_LOOP

LD R0, NEWLINE2
OUT

LD R7, BACKUP_R7_3200
LD R4, BACKUP_R4_3200
LD R5, BACKUP_R5_3200
LD R0, BACKUP_R0_3200



RET

;-----------------
;SUB_CONVERT Data
;-----------------

PROMPT			.STRINGZ	"Enter 'b' and 16 binary digits\n"
NEWLINE2		.FILL		'\n'
TOTAL			.FILL		#0
COUNTER			.FILL		#16
ASCII_SHIFT		.FILL		#-49
BACKUP_R4_3200		.BLKW		#1
BACKUP_R7_3200		.BLKW		#1
BACKUP_R5_3200		.BLKW		#1
BACKUP_R1_3200		.BLKW		#1
BACKUP_R0_3200		.BLKW		#1

;=================================================
;subroutine: SUB_PRINT_3400
;input: value that will be converted to 16 bit ascii 1s and 0s
;postcondition: the subroutine has calculated the binary representation
;			of the value in R1 and printed it.
;return value: none
;=================================================
.ORIG x3400			; Program begins here

ST R1, backup_r1_3400
ST R4, backup_r4_3400
ST R3, backup_r3_3400
ST R7, backup_r7_3400

LD R0, b
OUT
;subroutine algorithm
;LD R0, Value_ptr	; R6 <-- pointer to value to be displayed as binary
;AND R1, R1, #0
ADD R1, R1, #0
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

LD R3, backup_r3_3400
LD R7, backup_r7_3400
LD R4, backup_r4_3400	
LD R1, backup_r1_3400
LD R0, backup_r0_3400


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
b			.FILL 'b'

backup_r3_3400	.BLKW #1
backup_r7_3400	.BLKW #1
backup_r4_3400	.BLKW #1
backup_r1_3400	.BLKW #1	
backup_r0_3400	.BLKW #1



;.ORIG xB270					; Remote data
;Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!!
							;Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
