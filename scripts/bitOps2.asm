; Mike Jochen
; File: bitOps2.asm
; Reverse all the BITS!
; Converting bitOps to use subprograms
; WARNING - this version is broken
; Try to fix it!

%include "asm_io.inc"
segment .data
	msg1  db "Enter an int: ",0
	msg2  db "Original: ",0
	msg3  db "Reversed: ",0

segment .bss

segment .text
        global  asm_main
asm_main:
        enter   0,0
        pusha

	; Read in an integer
	; from standard in then
	; print it out
	mov	eax, msg1
	call	print_string

	call	read_int
	mov	edx, eax

	push	edx
	call	printValue
		
	mov	eax, edx
	xor	ebx, ebx
; Reverse bits NONDESTRUCTIVELY
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1
	ror	eax, 1       	; REVERSE BIT
	rcl	ebx, 1

	; Print it!
	; (as an integer)
	mov	eax, msg3
	call	print_string
	mov	eax, ebx
	call	print_int
	call	print_nl

	; Print it!
	; (one bit at a time)
	mov	ecx, 32
printLoop2:
	xor	eax, eax
	rol	ebx, 1
	setc	al
	call	print_int
	loop	printLoop2
	call	print_nl

	; Reverse it, but 
	; now let's work smart - not hard
	; Let's use a loop!
	mov	eax, edx    ; get the original value back
	xor	ebx, ebx
	mov	ecx, 32
reverseLoop:
	ror	eax, 1
 	rcl	ebx, 1
	loop	reverseLoop

	; Print it!
	; (as an integer)
	mov	eax, msg3
	call	print_string
	mov	eax, ebx
	call	print_int
	call	print_nl

	; Print it!
	; (one bit at a time)
	mov	ecx, 32
printLoop3:
	xor	eax, eax
	rol	ebx, 1
	setc	al
	call	print_int
	loop	printLoop3
	call	print_nl

	; Return back to C
        popa
        mov     eax, 0
        leave                     
        ret


; Subprogram to print the decimal value
; and binary (32 bits).
printValue:
        enter   0,0
        pusha

	mov	ebx, [EBP+8]

	; Print the value as an integer
	; and in binary one bit at a time
	mov	eax, msg2
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

        popa
        leave                     
        ret
