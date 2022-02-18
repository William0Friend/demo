;; Mike Jochen
;; CPSC 232
;; 2 November 2021
;; file: array.asm
;; Play with dynamically allocated arrays

segment .data
	sizePrompt db "What size array? ",0
	inputPrompt db "Enter int values (-1 to stop): ",0
	printMsg db "Element %d is %d",10,0
	inputFormat db "%d",0

segment .bss
	array resd 1
	arraySize resd 1

segment .text
global  asm_main
	extern scanf, printf, malloc, free
asm_main:
        enter   4,0               ; one local variable (double)
        pusha

	push	dword sizePrompt  ; prompt user for size of the array
	call	printf
	add	esp, 4

	push	dword arraySize	  ; read array size from std in
	push	dword inputFormat
	call	scanf
	add	esp, 8

	mov	eax, [arraySize]  ; calulate # bytes needed for array
	mov	ebx, 4
	mul	ebx

;; Call malloc to get some memory, takes one parameter (# bytes to allocate)
;; returns address of allocated memory in EAX
;; we store this in "array" so array now acts like a pointer
;; (the contents of variable array are the address of the array)
	
	push	eax
	call	malloc
	mov	[array], eax
	add	esp, 4

;; check return value of malloc,if zero
;; (not a valid address), malloc failed,
;; end the progam
	
	and	eax, eax	  ; check if zero
	jz	end

	push	inputPrompt	  ; prompt user for array data
	call	printf
	add	esp, 4

;; Initialize the array using EDI and stosd
;; looping arraySize times
;; dereferencing "array" since it contains the address of the array
	
	mov	edi, [array]
	mov	ecx, [arraySize]
initLoop:
	push	ecx
	lea	eax, [ebp-4]
	push	eax
	push	dword inputFormat
	call	scanf
	add	esp, 8
	pop	ecx
	mov	eax, [ebp-4]
	cmp	eax, -1
	je	initComplete
	stosd
	loop	initLoop

;; We've built the array, now print it out!
;; Use ESI and LODSD to print each element
	
initComplete:
	mov	esi, [array]	
	mov	ecx, [arraySize]
printLoop:
	lodsd
	push	ecx
	push	eax
	mov	eax, ecx
	mov	ebx, [arraySize]
	sub	ebx, eax
	push	ebx
	push	printMsg
	call	printf
	add	esp, 12
	pop	ecx
	loop	printLoop

;; Give back our allocated memory

	push	dword [array]
	call	free
	add	esp, 4

end:
        popa
        mov     eax, 0		
        leave                     
        ret
