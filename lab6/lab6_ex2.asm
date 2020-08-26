;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 6, ex 2
; Lab section: 023
; TA: David Feng
; 
;=================================================
.orig x3000
;--------------
;INSTRUCTIONS
;--------------
LD R2, SUB_GET_STRING_3200
LEA R1, arr
LD R4, flag

JSRR R2		;call subroutine

LEA R1, arr

LD R3, SUB_IS_PALINDROME_3400

JSRR R3		;call subroutine

LEA	R0, thestringmsg
PUTS

LEA R0, arr
PUTS

ADD R4, R4, #0
BRz YES
BRp NO

NO
	LEA	R0, nomsg
	PUTS
	BR OK

YES
	LEA R0, yesmsg
	PUTS
	
OK

HALT
;-----
;DATA
;-----
SUB_GET_STRING_3200 	.FILL x3200
arr 					.BLKW #100
SUB_IS_PALINDROME_3400 	.FILL x3400
thestringmsg			.STRINGZ "The string "
yesmsg					.STRINGZ " IS a palindrome"
nomsg					.STRINGZ " IS NOT a palindrome"
flag					.FILL	#0
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

;-------------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME_3400
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1) is
;			a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
;-------------------------------------------------------------------------------
.orig x3400
;--------------
;INSTRUCTIONS
;--------------
ST R7, backup_r7_3400
ST R1, backup_r1_3400
ST R3, backup_r3_3400
ST R5, backup_r5_3400
ST R6, backup_r6_3400
ST R0, backup_r0_3400

ADD R6, R5, R1 ;get last element array into r6
ADD R6, R6, #-1 ;get index of last element

SUB_LOOP
  LDR R0, R1, #0 ;load array into r0
  LDR R3, R6, #0 ;load array into r3

  NOT R3, R3 ;inverse of last element into r3
  ADD R3, R3, #1 

  ADD R0, R0, R3 ;add last character and first
  BRnp NOT_PALINDROME

  ADD R1, R1, #1 	;next element in array
  ADD R6, R6, #-1
  ADD R5, R5, #-1 ; decrease counter
  BRp SUB_LOOP
  BRz END

NOT_PALINDROME
	ADD R4, R4, #1
	BR DONE
	
END
	ADD R4, R4, #0
	BR DONE

DONE
	
LD R7, backup_r7_3400
LD R1, backup_r1_3400
LD R3, backup_r3_3400
LD R5, backup_r5_3400
LD R6, backup_r6_3400
LD R0, backup_r0_3400

RET
;-----
;DATA
;-----
backup_r7_3400 	.BLKW #1
backup_r1_3400 	.BLKW #1
backup_r3_3400 	.BLKW #1
backup_r5_3400 	.BLKW #1
backup_r6_3400 	.BLKW #1
backup_r0_3400	.BLKW #1

.end

