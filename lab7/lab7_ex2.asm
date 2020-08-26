;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 023 
; TA: David Feng
; 
;=================================================
.ORIG x3000

AND R2, R2, #0

LEA R0, INTRO		;print the prompt
PUTS

GETC			;get input
OUT

LD R1, COUNT_ONES_3200 ;load and run subroutine
JSRR R1

ADD R2, R0, #0 	;store character in R2

LD R0, NEWLINE ;print newline
OUT

LEA R0, OUTPUT 
PUTS

LD R0, APOS
OUT

AND R0, R0, #0
ADD R0, R2, #0 ;print out character
OUT

LD R0, APOS
OUT

LEA R0, IS
PUTS

AND R0, R0, #0
LD R0, ASCII	 ;convert number in register into printable value
ADD R0, R0, R3	;print out the number of 1's in the character
OUT

LD R0, NEWLINE	;end with newline
OUT

HALT

COUNT_ONES_3200	.FILL		x3200
INTRO		.STRINGZ	"Please input a single character:\n"
OUTPUT		.STRINGZ	"The number of 1s in "
IS			.STRINGZ	" is "
NEWLINE		.FILL		#10
ASCII		.FILL		x30
APOS		.STRINGZ	"'"

;=========================================================================
; Subroutine: COUNT_ONES_3200
; Parameter: R0, the user's input 
; Postcondition: R3 holds the number of 1's in the input
; Return Value: R3, which holds the number of 1's in the input 
;=========================================================================
.ORIG x3200

ST R7, BACKUP_R7_3200

LD R3, COUNTER 		;hold number of 1's
LD R4, BIN_COUNT	;bit number 16

AND R1, R1, #0
ADD R1, R0, #0 	;copy character to R1

CHECK
    ADD R1, R1, #0 	;add value with 0 to see if the leading bit is a 0 or 1
    BRzp IS_ZERO	;if the number is zero or postive, then the msb is 0
    BRn IS_ONE		;else, the msb is 1

IS_ZERO
    ADD R1, R1, R1 	;bit shift left by adding character with itself 
    ADD R4, R4, #-1 ;decrement bit counter
    BRz END 		;end if 16 bits were checked
    BRp CHECK		

IS_ONE
    ADD R1, R1, R1 	;bit shift left by adding character with itself 
    ADD R3, R3, #1 	;increment 1 counter
    ADD R4, R4, #-1 ;decrement bit counter
    BRz END		
    BRp CHECK

END
  
LD R7, BACKUP_R7_3200

RET

BACKUP_R7_3200 .BLKW #1
BIN_COUNT .FILL #16
COUNTER .FILL #0

.END
