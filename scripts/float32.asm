;; Mike Jochen
;; CPSC 232
;; 30 November 2021
;; File: float32.asm
;; Fun with floating point!
;;
;; Lets explore floats in 32-bit NASM	


segment .data
	prompt db "Please enter a float: ",0
	answer db "Your float number is: %lf",10,0
	inFormat db "%lf"

segment .bss
	floating resq 1

segment .text
	extern printf, scanf
        global  asm_main
asm_main:
        enter   0,0
        pusha

;; Prompt user to enter floating point value
	push	dword prompt
	call	printf
	add	esp, 4

;; Read in double-precision float via scanf
	push	dword floating
	push	dword inFormat
	call	scanf
	add	esp, 8

;; Let's print that number
	push	dword [floating+4]
	push	dword [floating]
	push	dword answer
	call	printf
	add	esp, 12

;; Let's store that number in ST0 and then 
;; add the float to itself (in ST0)
	fld	qword [floating]
	fadd	qword [floating]

;; Let's print the result
	fstp	qword [floating]
	push	dword [floating+4]
	push	dword [floating]
	push	dword answer
	call	printf
	add	esp, 12

        popa
        mov     eax, 0
        leave                     
        ret


