;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
;
; Lab: lab 8, ex 1 & 2
; Lab section: 023
; TA: David Feng
;
;=================================================
; test harness
                    .orig x3000
    LD R6, sub_print_opcode_table_3200
    JSRR R6
    
    LD R6, sub_find_opcode_3600
    JSRR R6
                
                    halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
sub_print_opcode_table_3200    .FILL    x3200
sub_find_opcode_3600    		.FILL    x3600

;===============================================================================================

; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE_3200
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;                 and corresponding opcode in the following format:
;                    ADD = 0001
;                    AND = 0101
;                    BR = 0000
;                    …
; Return Value: None
;-----------------------------------------------------------------------------------------------
                    .orig x3200
    ST R7, BACKUP_R7_3200
    ST R4, BACKUP_R4_3200
    ST R6, BACKUP_R6_3200
    ST R1, BACKUP_R1_3200
    ST R2, BACKUP_R2_3200
    ST R3, BACKUP_R3_3200
    
    LD R3, instructions_po_ptr		;load instructions pointer
    LD R2, opcodes_po_ptr			;load opcodes pointer
  
    PRINT
        LDR R1, R3, #0		;load instruction to R1
        BRn DONEPRINT		;if neg, end of array is reached
        
        STARTPUTS    
            LDR R1, R3, #0
            AND R0, R0, #0		
            ADD R0, R0, R1		;if 0, end of string
            BRz ENDPUTS
            
            OUT					;print instruction string
            ADD R3, R3, #1		;increment instructions pointer
            BR STARTPUTS			
        ENDPUTS
        
        LEA R0, equals			
        PUTS
        
        LD R6, sub_print_opcode_3400
        JSRR R6
        
        LD R0, newline
        OUT
        
        ADD R3, R3, #1			;increment instructions pointer
        ADD R2, R2, #1			;increment op codes pointer
        BR PRINT
    DONEPRINT
                
    LD R7, BACKUP_R7_3200
    LD R1, BACKUP_R1_3200
    LD R4, BACKUP_R4_3200
    LD R6, BACKUP_R6_3200
    LD R2, BACKUP_R2_3200
    LD R3, BACKUP_R3_3200
                
                    ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
opcodes_po_ptr        .FILL x4000                ; local pointer to remote table of opcodes
instructions_po_ptr    .FILL x4100                ; local pointer to remote table of instructions
sub_print_opcode_3400    .FILL    x3400

BACKUP_R7_3200    .BLKW    #1
BACKUP_R1_3200    .BLKW    #1
BACKUP_R3_3200    .BLKW    #1
BACKUP_R4_3200    .BLKW    #1
BACKUP_R2_3200    .BLKW    #1
BACKUP_R6_3200    .BLKW    #1

equals    .STRINGZ    " = "
newline   .FILL    '\n'
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_3400
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;                 The output is not newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
                    .orig x3400
    ST R7, BACKUP_R7_3400
    ST R6, BACKUP_R6_3400
    ST R3, BACKUP_R3_3400
    
    LD R6, twelve			
    LDR R3, R2, #0			;load instructions pointer to R3
    SKIP12
        ADD R6, R6, #0		;if counter = 0, end skip
        BRnz DONESKIP
        
        ADD R3, R3, R3		;left shift	
        ADD R6, R6, #-1		;decrement counter
        BR SKIP12
    DONESKIP
                
    LD R6, four		
    PRINT4
        ADD R6, R6, #0				;check if four bits were written
        BRnz GOT4
        
        ADD R3, R3, #0				;check msb 
        COUT                        
            BRzp POS
        NEG
            LD R0, one				;if neg, load 1
            BR ENDCOUT
        POS
            LD R0, zero				;if pos/zero, load 0
        ENDCOUT
        
        OUT                          ;print
        ADD R3, R3, R3               ;left shift
        ADD R6, R6, #-1				;decrement counter
        BR PRINT4
    GOT4       
                
    LD R7, BACKUP_R7_3400
    LD R6, BACKUP_R6_3400
    LD R3, BACKUP_R3_3400
                
                    ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
    BACKUP_R7_3400    .BLKW    #1
    BACKUP_R6_3400    .BLKW    #1
    BACKUP_R3_3400    .BLKW    #1
    
    twelve   .FILL    #12
    four   	 .FILL    #4
    one       .FILL    x31
    zero      .FILL    x30
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE_3600
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
;                 as local data; it has searched the AL instruction list for that string, and reported
;                either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
                    .orig x3600
    ST R7, BACKUP_R7_3600
    ST R1, BACKUP_R1_3600
    ST R5, BACKUP_R5_3600
    ST R2, BACKUP_R2_3600
    ST R3, BACKUP_R3_3600
    ST R6, BACKUP_R6_3600            
    ST R4, BACKUP_R4_3600
    
    LD R4, instructions_fo_ptr
    
    LD R6, sub_get_string_3800
    JSRR R6
    
    LD R2, userinput		;load user input pointer
    LDR R6, R2, #0				
    ADD R6, R6, #0				
	BRz INVALID					;if no input, invalid
	
	AND R6, R6, #0
    
    ST R5, length			;store as length
    
    AND R5, R5, #0			;reset for opcode
    ADD R5, R5, #-1			
    
    FIND
        LD R2, userinput		;load user input pointer
        LDR R6, R4, #0				;load instructions
        ADD R6, R6, #0				
        ADD R5, R5, #1				;counts which number opcode
        BRn INVALID					;counter maxed out = input is invalid				
        
        COMPARE
            LDR R1, R2, #0			;load user input
            ADD R1, R1, R6			;check if matches
            BRz SAME
        
        DIFF
            ADD R4, R4, #1			;increment instructions pointer
            ADD R6, R6, #0			;check for next instruction
            BRz FIND
        
            LDR R6, R4, #0			;if not, loop until next instruction
									; is reached
            BR DIFF

        SAME
            ADD R2, R2, #1			;increment input pointer
            ADD R4, R4, #1			;increment instructions pointer
            LDR R6, R4, #0			;load instructions
            LDR R1, R2, #0			;load input
            
            AND R3, R3, #0			
            ADD R3, R3, R6			;2's complement of instruction
            NOT R3, R3
            ADD R3, R3, #1			
            ADD R3, R3, R1			
            BRz DONESEARCH
            
            ADD R1, R1, #0			;end of input
            BRz DIFF
            
            ADD R6, R6, #0			;end of input
            BRz DIFF
            
            BR COMPARE				
            
        INVALID
            LEA R0, invalid
            PUTS
        BR FIN
        
    DONESEARCH
    
    ST R5, op
    LD R5, length
    NOT R5, R5				;2's complement 
    ADD R5, R5, #1
    ADD R4, R4, R5			;add length with instruction to get to beginning 
							; of string
    PRINTINSTRUCT			;print instruction
        LDR R0, R4, #0
        BRz OK
        
        OUT
        ADD R4, R4, #1
        BR PRINTINSTRUCT
    OK

    LEA R0, equal		;equal sign
    PUTS
    
    LD R3, opcodes_fo_ptr 	;opcode pointer
    LD R5, op
    ADD R2, R3, R5				;increment opcode pointer
    LD R1, sub_print_opcode_3400_		;use print subroutine
    JSRR R1
    
    FIN
        
    LD R7, BACKUP_R7_3600
    LD R3, BACKUP_R3_3600
    LD R4, BACKUP_R4_3600
    LD R6, BACKUP_R6_3600
    LD R2, BACKUP_R2_3600
    LD R1, BACKUP_R1_3600
    LD R5, BACKUP_R5_3600

                
                 ret
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr            .FILL x4000
instructions_fo_ptr        .FILL x4100
BACKUP_R1_3600		.BLKW 	#1
BACKUP_R5_3600		.BLKW 	#1
BACKUP_R7_3600    	.BLKW   #1
BACKUP_R4_3600    	.BLKW   #1
BACKUP_R6_3600    	.BLKW   #1
BACKUP_R2_3600    	.BLKW   #1
BACKUP_R3_3600    	.BLKW   #1

sub_print_opcode_3400_    .FILL    x3400
sub_get_string_3800    .FILL    x3800
userinput    .FILL 			x4300
invalid    .STRINGZ    "Invalid input"
equal    	.STRINGZ    " = "
length  	 .FILL    #0
op   		 .FILL    #0
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING_3800
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated
;                 by [ENTER]. That string has been stored as a null-terminated character array
;                 at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
                    .orig x3800
    
    ST R7, BACKUP_R7_3800
    ST R0, BACKUP_R0_3800
	ST R1, BACKUP_R1_3800    
    
    LD R2, ARR			;load array
  
    LEA R0, prompt		;print prompt
    PUTS
    
    AND R5, R5, #0    	;input length
    AND R1, R1, #0
    
    INPUT
        GETC		
        OUT
        ADD R1, R0, #-10 		;check if newline is entered
        BRz DONEINPUT			
        
        NOT R0, R0				;2's complement
        ADD R0, R0, #1
        STR R0, R2, #0			;store in R2
        ADD R5, R5, #1			;increment length counter
        ADD R2, R2, #1			;increment user input array pointer
        BR INPUT
    DONEINPUT
    
    LD R7, BACKUP_R7_3800
    LD R0, BACKUP_R0_3800
	LD R1, BACKUP_R1_3800    
                    ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
BACKUP_R7_3800    .BLKW    #1
BACKUP_R1_3800    .BLKW    #1
BACKUP_R0_3800    .BLKW    #1
ARR 			.FILL 	x4300
prompt    .STRINGZ    "Please input an instruction: "

;===============================================================================================

;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
;opcodes
opcodes_ADD          .FILL #1
opcodes_AND          .FILL #5
opcodes_BR    	     .FILL #0
opcodes_JMP          .FILL #12
opcodes_JSR          .FILL #4
opcodes_JSRR       	 .FILL #4
opcodes_LD           .FILL #2
opcodes_LDI          .FILL #10
opcodes_LDR          .FILL #6
opcodes_LEA          .FILL #14
opcodes_NOT          .FILL #9
opcodes_RET          .FILL #12
opcodes_RTI          .FILL #8
opcodes_ST           .FILL #3
opcodes_STI          .FILL #11
opcodes_STR          .FILL #7
opcodes_TRAP         .FILL #15


                    .ORIG x4100            ; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
;instructions
instructions_ADD        .STRINGZ      "ADD"                             ; - be sure to follow same order in opcode & instruction arrays!
instructions_AND        .STRINGZ      "AND"
instructions_BR         .STRINGZ      "BR"
instructions_JMP        .STRINGZ      "JMP"
instructions_JSR        .STRINGZ      "JSR"
instructions_JSRR       .STRINGZ      "JSRR"
instructions_LD         .STRINGZ      "LD"
instructions_LDI        .STRINGZ      "LDI"
instructions_LDR        .STRINGZ      "LDR"
instructions_LEA        .STRINGZ      "LEA"
instructions_NOT        .STRINGZ      "NOT"
instructions_RET        .STRINGZ      "RET"
instructions_RTI        .STRINGZ      "RTI"
instructions_ST         .STRINGZ      "ST"
instructions_STI        .STRINGZ      "STI"
instructions_STR        .STRINGZ      "STR"
instructions_TRAP       .STRINGZ      "TRAP"
FINISH                  .FILL         #-1
;===============================================================================================


.END
