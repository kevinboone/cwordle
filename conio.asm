;------------------------------------------------------------------------
; conio.asm
; Console I/O functions that are smaller to implement in assembly than C
; Copyright (c)2022 Kevin Boone, GPL v3.0
;------------------------------------------------------------------------

	PUBLIC puts2_
	PUBLIC puts2ln_
	PUBLIC putch_
	PUBLIC puteol_
	PUBLIC getchne_ 
	PUBLIC _keyseed_

bdos 		equ 5	; define BDOS entry point
bdos_cout 	equ 2	; console out
bdos_rawio 	equ 6	; raw input 

;------------------------------------------------------------------------
;  putch
;  Output the character in A; other registers preserved.
;------------------------------------------------------------------------
putch:
	PUSH	H	; We must preserve HL, as the BDOS call sets it
	PUSH	B
	PUSH	D 
	PUSH	PSW
	MVI	C, bdos_cout 
	MOV 	E, A 
	CALL	bdos 
	POP	PSW
	POP	D
	POP	B
	POP	H
	RET

;------------------------------------------------------------------------
;  puts2 
;  Output a zero-terminated string whose address is in HL; other
;  registers preserved.
;------------------------------------------------------------------------
puts2:
	PUSH	B 
	PUSH	D 
	PUSH	H 
	PUSH	PSW
puts_next:
	MOV	A, M 
	ORA	A
	JZ	puts_done
	CALL	putch
	INX	H
	JP	puts_next
puts_done:
	POP	PSW
	POP	H
	POP	D 
	POP	B
	RET

;------------------------------------------------------------------------
;  puts2_ 
;  C interface function for puts2(). Displays the string whose address is
;  at the top of the stack
;------------------------------------------------------------------------
puts2_:
	PUSH	H
	PUSH	D
	LXI	H, 6
	DAD	SP
	MOV	E, M
	INX 	H
	MOV	D, M
	XCHG
	CALL	puts2
	POP	D
	POP	H
	RET

;------------------------------------------------------------------------
;  puts2ln_ 
;  C interface function for puts(). Displays the string whose address is
;  at the top of the stack
;------------------------------------------------------------------------
puts2ln_:
	PUSH	H
	PUSH	D
	LXI	H, 6
	DAD	SP
	MOV	E, M
	INX 	H
	MOV	D, M
	XCHG
	CALL	puts2
        CALL    puteol_
	POP	D
	POP	H
	RET

;------------------------------------------------------------------------
;  putch_
;  C interface function for putch(). Displays the character whose 
;  value is at the top of the stack 
;------------------------------------------------------------------------
putch_:
	PUSH	H
	PUSH	D
	LXI	H, 6
	DAD	SP
	MOV	E, M
	MOV	A, E
	CALL	putch
	POP	D
	POP	H
	RET

;------------------------------------------------------------------------
;  putdigit
;  Output a single hex digit in A; other registers preserved 
;------------------------------------------------------------------------
putdigit:
	PUSH	PSW 
	CPI	10	; Digit >= 10
	JC	pd_lt
	ADI	55 
	CALL	putch
	POP	PSW 
	RET
pd_lt:	    		; Digit < 10
	ADI	48 
	CALL	putch
	POP	PSW 
	RET


;------------------------------------------------------------------------
;  puthxb
;  Output a hex byte in A; other registers preserved 
;------------------------------------------------------------------------
puthxb:
	PUSH	PSW 
	PUSH	PSW 
	RRC 
	RRC 
	RRC 
	RRC
	ANI	0Fh
	CALL	putdigit
	POP	PSW
	ANI	0Fh
	CALL	putdigit
	POP	PSW 
	RET

;------------------------------------------------------------------------
;  puteol_ 
;  C function to write an end-of-line 
;------------------------------------------------------------------------
puteol_:
	PUSH	PSW
	MVI	A, 13
	CALL	putch
	MVI	A, 10
	CALL	putch
	POP	PSW
	RET

;------------------------------------------------------------------------
;  getchne
;  Read a character, unbuffered, from the console, without echoing it 
;------------------------------------------------------------------------
getchne:
	PUSH    B
	PUSH    D
	PUSH    H
ne_next:
	; TODO ADD R to SEED
	LHLD	_keyseed_
	INX	H
	SHLD	_keyseed_
	MVI	E, 0ffh
	MVI     C, bdos_rawio
	CALL    bdos
	CPI     0
	JZ 	ne_next
	POP     H
	POP     D
	POP     B
	RET

;------------------------------------------------------------------------
;  getchne_ 
;  C wrapper for getchne 
;------------------------------------------------------------------------
getchne_:
	CALL	getchne
	MVI	H, 0 
	MOV 	L, A 
	RET

_keyseed_:	DW	0


