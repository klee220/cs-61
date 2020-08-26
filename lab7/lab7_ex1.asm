;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 023
; TA: David Feng 
; 
;=================================================
.ORIG x3000

LD R1, LOAD_3200		;load first subroutine
JSRR R1			

ADD R2, R2, #1			;add 1 to the hard-coded value from subroutine 1

LD R3, PRINT_3400		;load second subroutine
JSRR R3			

LD R0, NEWLINE1		
OUT


HALT

NEWLINE1		.FILL		x0A
LOAD_3200		.FILL		x3200
PRINT_3400		.FILL		x3400

;=========================================================================
; Subroutine: LOAD_3200
; Parameter: none 
; Postcondition: R2 has a hard-coded value in it 
; Return Value (R2): R2 contains a hard-coded value
;=========================================================================
.ORIG x3200

ST R7, BACKUP_R7_3200

LD R2, LABEL			;the hard-coded value 

LD R7, BACKUP_R7_3200

RET

;-----
;DATA
;-----
BACKUP_R7_3200		.BLKW	#1
LABEL				.FILL	#49

;=========================================================================
; Subroutine: PRINT_3400
; Parameter: R2
; Postcondition: R2 prints to the console. 
; Return Value: none
;=========================================================================
.ORIG x3400

ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R1, BACKUP_R1_3400
ST R4, BACKUP_R4_3400
ST R5, BACKUP_R5_3400
ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400

AND R3, R3, #0
AND R7, R7, #0
AND R1, R1, #0
ADD R3, R2, #0 	;copy R2 input to R3
AND R2, R2, #0
LD R4, MINUS_TEN_THOUSAND
LD R5, COUNTER 	;keeps track of the number in a place value 
LD R6, ASCII 	;convert decimal to printable character

ADD R3, R3, #0
BRn NEG
BRzp TEN_THOUSAND

NEG 
	LD R0, negative
	OUT
	NOT R3, R3
	ADD R3, R3, #1
	AND R0, R0, #0

TEN_THOUSAND
	ADD R3, R3, R4		;subtract ten thousand from input 
	BRn OUTPUT		
	ADD R1, R1, #1 		;indicates we have a value
	ADD R5, R5, #1		;increment counter to count 
						;	how many ten thousands there are 
BRnzp TEN_THOUSAND

OUTPUT
	ADD R5, R5, #0		;check if value is 0
	BRz RESET			; if so, dont print
	
	ADD R0, R5, #0		;add counter into R0
	ADD R0, R0, R6		;convert to printable number
	OUT
BRnzp RESET

RESET
	LD R4, TEN_THOUSAND_ADD 
	ADD R3, R3, R4				;reset input
	LD R4, MINUS_THOUSAND
	LD R5, COUNTER				;reset counter
	AND R0, R0, #0			
	
THOUSAND
	ADD R3, R3, R4		;subtract a thousand
	BRn OUTPUT2
	
	ADD R1, R1, #1		;indicates thousands place has a value
	ADD R5, R5, #1		;increment counter 
BRnzp THOUSAND

OUTPUT2
	ADD R1, R1, #0 	;check if ten thousands place had value
	BRp PLACEHOLDER ;if it does print value
	
	ADD R5, R5, #0	;if not, check if thousands place has value
	BRz RESET2
	
	PLACEHOLDER
	ADD R0, R5, #0		;add counter to R0 to print
	ADD R0, R0, R6		;convert to ASCII
	OUT
BRnzp RESET2

RESET2
	LD R4, THOUSAND_ADD		
	ADD R3, R3, R4			;reset input
	LD R4, MINUS_HUNDRED	
	LD R5, COUNTER			;reset counter
	AND R0, R0, #0

HUNDRED
	ADD R3, R3, R4		;subtract input by 100
	BRn OUTPUT3
	ADD R2, R2, #1		;indicates value in hundreds place
	ADD R5, R5, #1		;increment counter
BRnzp HUNDRED

OUTPUT3	
	ADD R1, R1, R1		;check if there is value in previous place values
	BRp PLACEHOLDER1
	
	ADD R5, R5, #0		;check if value is 0
	BRz RESET3
	
	PLACEHOLDER1
	ADD R0, R5, #0		;add counter value to R0 to print
	ADD R0, R0, R6		;convert to ASCII
	OUT
BRnzp RESET3

RESET3
	LD R4, HUNDRED_ADD		
	ADD R3, R3, R4			;reset input
	LD R5, COUNTER			;reset counter
	AND R0, R0, #0
	
TENS
	ADD R3, R3, #-10		;subtract input by 10
	BRn OUTPUT4
	ADD R2, R2, #1			;indicates there is value in tens place
	ADD R5, R5, #1			;increment counter
BRnzp TENS

OUTPUT4
	ADD R1, R1, R2		;check if there was value in previous place values
	BRp PLACEHOLDER2
	
	ADD R5, R5, #0		;check if value is 0
	BRz RESET4
	
	PLACEHOLDER2
	ADD R0, R5, #0		;add counter to R0 to print
	ADD R0, R0, R6		;convert to ASCII
	OUT
BRnzp RESET4

RESET4
	ADD R3, R3, #10		;reset input
	LD R5, COUNTER		;reset counter
	AND R0, R0, #0		

ONES
	ADD R3, R3, #-1		;subtract input by 1
	BRn OUTPUT5		
	ADD R5, R5, #1		;increment counter
BRnzp ONES

OUTPUT5
	ADD R1, R1, #0
	BRp PLACEHOLDER3
	
	ADD R5, R5, #0		;check if value is 0
	BRz END
	
	PLACEHOLDER3
	ADD R0, R5, #0		;add counter to R0 to print
	ADD R0, R0, R6		;convert to ASCII
	OUT


END

LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400
LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400
LD R1, BACKUP_R1_3400

RET

;-----
;DATA
;-----
BACKUP_R1_3400			.BLKW 	#1
BACKUP_R2_3400			.BLKW	#1
BACKUP_R3_3400			.BLKW	#1
BACKUP_R4_3400			.BLKW	#1
BACKUP_R5_3400			.BLKW	#1
BACKUP_R6_3400			.BLKW	#1
BACKUP_R7_3400			.BLKW	#1
ASCII					.FILL	#48
COUNTER					.FILL	#0
TEN_THOUSAND_ADD		.FILL	#10000
THOUSAND_ADD			.FILL	#1000
HUNDRED_ADD				.FILL	#100
MINUS_TEN_THOUSAND		.FILL	#-10000
MINUS_THOUSAND			.FILL	#-1000
MINUS_HUNDRED			.FILL	#-100	
negative				.STRINGZ "- " 

.END
