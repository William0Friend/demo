;; Mike Jochen
;; file: string.asm
;; 10/21/21
;; Read in a string, print it out - exciting...
;; Using only the C standard library

segment .data
	prompt      db "String please? ",0
	inputFormat db "%s",0              ; scanf format string (read a string)
	newline     db 10,0                ; String to print a newline

segment .bss
	buffer resb 255	                   ; Buffer to store user input

segment .text
	extern  scanf, printf              ; We'll use stdio library
        global  asm_main
asm_main:
        enter   0,0                        ; setup the stack for asm_main

	push	dword prompt
	call	printf
	add	esp, 4

	push	dword buffer               ; Call scanf to read a string
	push	dword inputFormat
	call	scanf
	add	esp, 4                     ; Note: leaving "buffer" on the stack
	                                   ; We will use it in the call to printf below

	call    printf                     ; Print buffer & newline
	push	dword newline
	call	printf
	add	esp, 8      

        mov     eax, 0                      ; Return to C
        leave                     
        ret
