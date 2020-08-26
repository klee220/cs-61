;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 9, ex 3
; Lab section: 023
; TA: David Feng
; 
;=================================================

; test harness
                    .orig x3000
LD R4, BASE		;setup/initialize the 5-slot stack
LD R5, MAX
LD R6, TOS
LD R1, SUB_STACK_PUSH

LEA R0, PROMPT
PUTS

GETC ;ask for user input
OUT

LD R2, OFFSET 
ADD R0, R0, R2 ;add with ASCII offset and push onto stack
JSRR R1			;jump to subroutine after R0 is changed to decimal

LEA R0, COMMA
PUTS

GETC
OUT

ADD R0, R0, R2 
JSRR R1 ;repeat process for 2nd value

LEA R0, COMMA
PUTS

GETC
OUT

LD R0, NEWLINE 
OUT

LD R1, SUB_MULTIPLY ;get product of the 2 values
JSRR R1

LD R1, SUB_STACK_POP ;pop product off
JSRR R1

LD R1, SUB_PRINT_DECIMAL ;convert to decimal and print
JSRR R1

LEA R0, MESSAGE
PUTS

HALT


;Local Data
SUB_STACK_PUSH .FILL x3200
SUB_STACK_POP .FILL x3400
SUB_MULTIPLY .FILL x3600
SUB_PRINT_DECIMAL .FILL x4000
OFFSET .FILL #-48
MAX_DIG .FILL #-9
NEWLINE .FILL x0A
BASE .FILL xA000
MAX .FILL xA005
TOS .FILL xA000
COMMA    .STRINGZ ", "
PROMPT .STRINGZ "Enter two single digit numbers and the operation (no spaces)\n"
MESSAGE .STRINGZ " is the result.\n"


;------------------------------------------------------------------------------------------
;Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
; address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1).
;  If the stack was already full (TOS = MAX), the subroutine has printed an
;  overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3200
;Subroutine Instructions

ST R2, BACKUP_R2
ST R7, BACKUP_R7

NOT R2, R5		;max
ADD R2, R2, #1 ;2's complement

ADD R2, R6, R2 ;check if stack already full
BRzp ERROR		;if MAX is less than TOS, error

ADD R6, R6, #1 ;increment TOS
STR R0, R6, #0 ;store value into R0
BRnzp CONTINUE_1

ERROR
  ST R0, R0_ERROR
  LEA R0, OVERFLOW_MESSAGE ;print out overflow message and save
  PUTS
  
CONTINUE_1
  LD R0, R0_ERROR
  LD R2, BACKUP_R2
  LD R7, BACKUP_R7

  RET

;Subroutine Data
OVERFLOW_MESSAGE .STRINGZ "Error Overflow!!\n"

R0_ERROR	.BLKW #1
BACKUP_R2	.BLKW #1
BACKUP_R7	.BLKW #1


;------------------------------------------------------------------------------------------
;Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
; address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;  If the stack was already empty (TOS = BASE), the subroutine has printed
;  an underflow error message and terminated.
; Return Value: R0  ← value popped off of the stack
;  R6  ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3400
;Subroutine Instructions

ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R5, BACKUP_R5_3400
ST R7, BACKUP_R7_3400

NOT R3, R4		;base
ADD R3, R3, #1 ;2's complement

ADD R3, R6, R3 ;check if stack is already empty
BRnz ERROR_x3400		;if base is equal to or greater than tos, error

LDR R0, R6, #0 ;load value into r0
ADD R6, R6, #-1 ;decrement TOS
BRnzp CONTINUE

ERROR_x3400
    LEA R0, UNDERFLOW_MESSAGE ;print out overflow message and exit
    PUTS
  
CONTINUE

    LD R3, BACKUP_R3_3400
    LD R4, BACKUP_R4_3400
    LD R5, BACKUP_R5_3400
    LD R7, BACKUP_R7_3400
  
  RET

;Subroutine Data
UNDERFLOW_MESSAGE .STRINGZ "Error Underflow!!\n"

BACKUP_R3_3400        .BLKW #1
BACKUP_R4_3400        .BLKW #1
BACKUP_R5_3400        .BLKW #1
BACKUP_R7_3400        .BLKW #1


;------------------------------------------------------------------------------------------
;Subroutine: SUB_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
; address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;  multiplied them together, and pushed the resulting value back
;  onto the stack.
; Return Value: R6  ← updated TOS value
;------------------------------------------------------------------------------------------
.orig x3600
;Subroutine Instructions

ST R0, BACKUP_R0_3
ST R1, BACKUP_R1_3
ST R2, BACKUP_R2_3
ST R3, BACKUP_R3_3
ST R7, BACKUP_R7_3

LD R1, SUB_STACK_POP_ ;pop off last (2nd) value
JSRR R1

ST R0, ONE ;store popped value
JSRR R1 ;pop off first value

ADD R3, R0, #0 ;store 1st entered value into R3
LD R2, ONE ;load 2nd entered value into R2

LD R1, SUB_MULTIPLY_
JSRR R1

LD R1, SUB_STACK_PUSH_ ;push multiplied value onto stack
JSRR R1

LD R0, BACKUP_R1_3
LD R1, BACKUP_R1_3
LD R2, BACKUP_R2_3
LD R3, BACKUP_R3_3
LD R7, BACKUP_R7_3

RET

;Subroutine Data
SUB_STACK_POP_  .FILL x3400
SUB_MULTIPLY_    .FILL x3800
SUB_STACK_PUSH_    .FILL x3200
ONE                .BLKW #1
BACKUP_R0_3        .BLKW #1
BACKUP_R1_3        .BLKW #1
BACKUP_R2_3        .BLKW #1
BACKUP_R3_3        .BLKW #1
BACKUP_R7_3        .BLKW #1


;------------------------------------------------------------------------------------------
;Subroutine: SUB_MULTIPLY_
; Parameter (R2): The first number to be multiplied
; Parameter (R3): The second number to be multiplied
; Postcondition: The subroutine multiplies the two numbers in R2 and R3 and returns their result
; Return Value: R0, multiplication result
;------------------------------------------------------------------------------------------
.orig x3800
;Subroutine Instructions

ST R7, BACKUP_R7_38

AND R0, R0, #0

ADD R2, R2, #0		;if first number is zero, go to zero loop
BRz ZERO

ADD R3, R3, #0		;if second value, go to zero loop
BRz ZERO

LOOP
  ADD R0, R0, R2 ;add R2 into R0
  ADD R3, R3, #-1 ;do it R3 # of times
  BRp LOOP
BRnzp FINISH
  
ZERO
    AND R0, R0, #0
FINISH 

LD R7, BACKUP_R7_38

;return R0
RET

;Subroutine Data
BACKUP_R7_38 .BLKW #1


;------------------------------------------------------------------------------------------
;Subroutine: SUB_PRINT_DECIMAL
; Parameter (R0): The number to be printed
; Postcondition: The subroutine outputs a multi digit number stored in R0
; Return Value: None
;------------------------------------------------------------------------------------------
.orig x4000
;Subroutine Instructions

ST R1, BACKUP_R1_4
ST R2, BACKUP_R2_4
ST R3, BACKUP_R3_4
ST R7, BACKUP_R7_4

LD R3, OFFSET_2

AND R1, R1, #0

TENS_LOOP
  ADD R0, R0, #-10 ;check if value is greater than 9
  BRn PRINT_NUM		;if not, go to print_num

  ADD R1, R1, #1 ;prepare to print out a 1 for the tens place
  BRnzp TENS_LOOP	

PRINT_NUM
  ADD R2, R0, #0	;load R0 value to R2
  ADD R0, R1, #0 ;load R1 into R0

  ADD R0, R0, R3 ;Add with ASCII offset and print
  OUT				;print tens place

  ADD R0, R2, #10 ;reset after checking for tens place
  ADD R0, R0, R3 		
  OUT				;print ones place
  
LD R1, BACKUP_R1_4
LD R2, BACKUP_R2_4
LD R3, BACKUP_R3_4
LD R7, BACKUP_R7_4

RET

;Subroutine Data
OFFSET_2 .FILL #48
BACKUP_R1_4.BLKW 1
BACKUP_R2_4 .BLKW 1
BACKUP_R3_4 .BLKW 1
BACKUP_R7_4 .BLKW 1

.END

