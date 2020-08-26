;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 23 
; TA: David Feng
; 
;=================================================

; test harness
                    .orig x3000

LD R4, BASE  ;setup/initialize the 5-slot stack
LD R5, MAX 
LD R6, TOS

LEA R0, INPUT
PUTS

GETC
OUT

LD R2, SUB_STACK_PUSH
JSRR R2

ST R6, TOS ;update TOS

LD R0, NEWLINE
OUT

LEA R0, POP_S  
PUTS

LD R1, SUB_STACK_POP
JSRR R1

ST R6, TOS

LEA R0, INPUT
PUTS

GETC ;repeat push to show that pop subroutine worked
OUT

JSRR R2		;jump to push subroutine

ST R6, TOS

LD R0, NEWLINE
OUT

AND R2, R2, #0

ADD R2, R2, #5

LD R0, NEWLINE
OUT

LEA R0, OVERF
PUTS

TEST_OVERFLOW   
    LOOP
		LEA R0, INPUT
		PUTS
		
        GETC
        OUT

        LD R1, SUB_STACK_PUSH
        JSRR R1
        
        LD R0, NEWLINE
		OUT
        
        ST R6, TOS ;update TOS
        
        ADD R2, R2, #-1
    BRp LOOP
RESET_R2
    
    AND R2, R2, #0
    ADD R2, R2, #6

LEA R0, UNDERF
PUTS

TEST_UNDERFLOW
    LOOP_2
		LEA R0, POP_S
		PUTS
		
        LD R1, SUB_STACK_POP
        JSRR R1
        
        ST R6, TOS
        
        ADD R2, R2, #-1
    BRp LOOP_2
 
LEA R0, INPUT
PUTS
      
GETC
OUT
    
LD R1, SUB_STACK_PUSH
JSRR R1

ST R6, TOS
    
                 
                    halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
SUB_STACK_PUSH            	.FILL x3200
SUB_STACK_POP            	.FILL x3400
INPUT                    	.STRINGZ "Enter value to be pushed onto stack: "
NEWLINE                    	.FILL x0A
BASE                    	.FILL xA000
MAX                        	.FILL xA005
TOS                        	.FILL xA000
POP_S                   	.STRINGZ "Popping TOS... \n"
OVERF						.STRINGZ "TESTING OVERFLOW: \n"
UNDERF						.STRINGZ "TESTING UNDERFLOW: \n"

;===============================================================================================

; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;            If the stack was already full (TOS = MAX), the subroutine has printed an
;            overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
                    .orig x3200

ST R3, BACKUP_R3_3200
ST R4, BACKUP_R4_3200
ST R5, BACKUP_R5_3200
ST R7, BACKUP_R7_3200

ADD R6, R6, #1	
ADD R3, R6, #0 ;load TOS pointer into R3
NOT R3, R3
ADD R3, R3, #2 ;2's complement for subtraction

ADD R3, R3, R5 ;check if stack already full
BRn FULL_ERROR	;if TOS is greater than MAX, it is full
BRnp CONTINUE

FULL_ERROR
    LEA R0, OVERFLOW ;print out overflow message and exit
    PUTS
	ADD R6, R6, #-1	
BRnzp TERMINATE

CONTINUE

STR R0, R6, #0 ;store value in R0 into R6
;ADD R6, R6, #1 ;increment top of stack

TERMINATE
            
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
LD R5, BACKUP_R5_3200     
LD R7, BACKUP_R7_3200
                    ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
BACKUP_R3_3200        .BLKW #1
BACKUP_R4_3200        .BLKW #1
BACKUP_R5_3200        .BLKW #1
BACKUP_R7_3200        .BLKW #1
OVERFLOW            .STRINGZ "\nERROR: Stack is full\n"


;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      ;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;            If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;           R6 ← updated TOS
;------------------------------------------------------------------------------------------
                    .orig x3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R5, BACKUP_R5_3400
ST R7, BACKUP_R7_3400

ADD R3, R6, #0 ;load TOS pointer into R3
NOT R3, R3
ADD R3, R3, #1 ;2's complement for subtraction

ADD R3, R3, R4 		;check if stack already empty
BRz EMPTY_ERROR		;if TOS and BASE are same, it is empty
BRnp CONTINUE_1

EMPTY_ERROR
    LEA R0, EMPTY ;print out overflow message and exit
    PUTS
BRnzp TERMINATE_1

CONTINUE_1

LDR R0, R6, #0 	;load value popped off stack into R0
ADD R6, R6, #-1 ;decrement top of stack

TERMINATE_1


LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400
LD R7, BACKUP_R7_3400
                 
                    ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
;ZERO                    .FILL #0
BACKUP_R3_3400        .BLKW #1
BACKUP_R4_3400        .BLKW #1
BACKUP_R5_3400        .BLKW #1
BACKUP_R7_3400        .BLKW    #1
EMPTY                    .STRINGZ "ERROR: Stack is empty\n"
;===============================================================================================

.END

