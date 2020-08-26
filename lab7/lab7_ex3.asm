;=================================================
; Name: Karina Lee
; Email: klee220@ucr.edu
; 
; Lab: lab 7, ex 3
; Lab section: 023 
; TA: David Feng
; 
;=================================================


;in order to right shift
;you can divide by 2
;you do this by subtracting 2 from the number until it turns negative
;keep a counter of how many times that can be done 
;the value in the counter is the original / 2

;or we can do this:
;left shift the original value by adding it onto itself
;if the MSB was negative(1), add 1 to the binary number 
;otherwise, do nothing
;this is repeated for n-1 bits
;ex: 4 bits requires this to loop 3 times

1100 	1
1001 	1
0011	0	
0110	0
