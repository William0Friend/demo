; Mike Jochen
; File: bitOps3.asm
; Reverse all the BITS!

%include "asm_io.inc"
extern printf
segment .data
	msg1  db "Enter an int: ",0
	msg2  db "Original: ",0
	msg3  db "Reversed: ",0
	debug db "HERE",10,0

segment .bss

segment .text
        global  asm_main
asm_main:
        enter   0,0
        pusha

	; Prompt user for an int
	mov	eax, msg1
	call	print_string

	; Read in an integer
	; from standard in
	call	read_int
	mov	edx, eax

	; print it out
	push	edx
	push	dword msg2
	call	printValue
	add	esp, 4        	; pop the string, leave value to reverse on stack

	; Call reverseIt to reverse the bits
	; Parameters: size, value
	push	dword 32
	call	reverseIt
	add	esp, 8

	; Call printValue to print the reversed value
	push	eax
	push	dword msg3
	call	printValue
	pop	eax             ; get rid of input params, but need value to reverse
	pop	eax             ; stored inside EAX

	; Reverse the value on more time
	push	ebx
	call	reverseItLongWay
	
	; Print the reverse of the reversed value
	; We should arrive at the original value
	push	dword msg3
	call	printValue
	add	esp, 8


	popa
        mov     eax, 0
        leave                     
        ret
;; END SUBPROGRAM ASM_MAIN
	
;; subprogram printValue
;; Print a string and an integer value (base ten and binary)
;; Parameters: 2
;; Parameter: string to print
;; Parameter: value to print
;; No return value
printValue:
        enter   0,0
        push	ebx

	mov	ebx, [ebp+12]
	mov	eax, [ebp+8]
	
	; Print the value as an integer
	; and in binary one bit at a time
	call	print_string
	mov	eax, ebx
	call	print_int
	call	print_nl

	mov	ecx, 32
printLoop:
	xor	eax, eax
	rol	ebx, 1
	setc	al
	call	print_int
	loop	printLoop
	call	print_nl

	pop	ebx
        leave                     
        ret
;; END SUBPROGRAM PRINTVALUE

;; subprogram ReverseIt
;; Reverse a sequence of bits
;; Parameters: 2
;; Parameter: Size (number of bits)
;; Parameter: Value to be reversed
;; Return Value: Value with bits reversed is returned via EAX
reverseIt:
	enter	0,0
	push	ebx            	; Callee must preserve EBX

	mov	ecx, [ebp+8]
	mov	ebx, [ebp+12]
	xor	eax, eax
reverseLoop:
	ror	ebx, 1
 	rcl	eax, 1
	loop	reverseLoop

	pop	ebx
	leave
	ret
;; End subprogram REVERSEIT

;; subprogram ReverseItLongWay
;; Reverse a sequence of bits with 32 rotates!
;; Parameters: 1
;; Parameter: Value to be reversed
;; Return Value: Value with bits reversed is returned via EAX
reverseItLongWay:
	enter	0,0
	push	ebx

	mov	eax,[ebp+8]
	xor	ebx, ebx
; Reverse bits NONDESTRUCTIVELY
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1
	ror	eax, 1     	; REVERSE IT!
	rcl	ebx, 1

	pop	ebx
	leave
	ret
;; End subprogram REVERSEITLONGWAY
