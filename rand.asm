;------------------------------------------------------------------------
; conio.asm
; Console I/O functions that are smaller to implement in assembly than C
; Copyright (c)2022 Kevin Boone, GPL v3.0
;------------------------------------------------------------------------

	PUBLIC getr_ 
	PUBLIC srand_ 
	PUBLIC rand_ 

;------------------------------------------------------------------------
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;  getchne_ 
;  C wrapper for getchne 
;------------------------------------------------------------------------
getr_:
        DB 	237,95 	; LD A,R 
	MOV	L, A 
	MVI 	H, 0 
	RET


;------------------------------------------------------------------------
;  srand_ 
;------------------------------------------------------------------------
srand_:
        PUSH    H
        PUSH    D
        LXI     H, 6
        DAD     SP
        MOV     E, M
        INX     H
        MOV     D, M
        XCHG
	; Arg is now in HL
	SHLD	rnd
        POP     D
        POP     H
        RET


;------------------------------------------------------------------------
;  rand_
;  This is an implementation of George Marsaglia's three-stage 
;    XOR-shift algorithrm
;------------------------------------------------------------------------
rand_:
	LHLD	rnd

	MOV	A, H
	RAR
	MOV	A, L
	RAR
	XRA	H
	MOV	H, A
	MOV	A, L
	RAR
	MOV	A, H
	RAR
	XRA	L
	MOV	L, A
	XRA	H
	MOV	H, A
	SHLD	rnd

	RET

;------------------------------------------------------------------------
;  data 
;------------------------------------------------------------------------
rnd:	dw 9


