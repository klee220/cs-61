;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 023
; TA: David Feng
; 
;=================================================
.orig x3000
;-------------
;INSTRUCTIONS
;-------------
LD R2, SUB_GET_STRING_3200
LEA R1, arr

JSRR R2		;call subroutine

LEA R0, arr	;print string
PUTS

HALT
;------
;DATA
;------
SUB_GET_STRING_3200 .FILL x3200
arr 				.BLKW #100

;------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING_3200
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;			terminated by the [ENTER] key (the "sentinel"), and has stored
;			the received characters in an array of characters starting at (R1).
;			the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of ​ non-sentinel​ characters read from the user.
;			R1 contains the starting address of the array unchanged.
;------------------------------------------------------------------------------
.orig x3200

;-------------
;INSTRUCTIONS
;-------------
ST R7, backup_r7_3200
ST R0, backup_r0_3200

LD R5, counter

GET_CHAR
	GETC
	OUT
	ADD R0, R0, #-10	;check if newline
	BRz BYE
	ADD R0, R0, #10	;undo the check
	STR R0, R1, #0	;put input into array
	ADD R1, R1, #1	;increment array pointer
	ADD R5, R5, #1	;increment counter
	BR GET_CHAR

BYE
AND R0, R0, #0	;null terminated
STR R0, R1, #0	;put input into array
	
LD R7, backup_r7_3200
LD R0, backup_r0_3200


RET
;------
;DATA
;------
backup_r7_3200 	.BLKW #1
backup_r0_3200 	.BLKW #1
counter 		.FILL #0


.end
