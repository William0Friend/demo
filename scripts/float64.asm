;; Mike Jochen
;; CPSC 232
;; 30 November 2021
;; file: float64.asm
;; Fun with floats!
;;
;; In x86-64, floats are passed via xmm registers
;; Lets explore floats in 64-bit NASM
;; Note: we don't use the stack for parameters
;; and floats use XMM now, not ST
	
segment .data
prompt:      db "Please enter a floating point value: ",0
intF:        db "Int: %d",10,0
answer:      db "Your floating point number is: %lf",10,0
inFormat:    db "%lf",0

segment .bss
floating:    resq 1
floating2:   resq 1
	
segment .text
global asm_main
extern printf, scanf
	
asm_main:
        enter   0,0

;; Prompt user to enter floating point value
	mov	rdi, prompt
	call	printf
	
;; Read in a floating-point value
	mov	rdi, inFormat
	mov	rsi, floating
	call	scanf

;; Print the float
	mov	rdi, answer
	call	printf

;; Store the float in XMM0, add it to itself
;; and print it out
	movsd	xmm0, [floating]
	addsd	xmm0, xmm0
	mov	rdi, answer
	mov	rax, 1
	call	printf
	
;; Print the original float out
	movsd	xmm0, [floating]
	mov	rax, 1
	mov	rdi, answer
	call	printf

        mov     rax, 0
        leave                     
        ret
