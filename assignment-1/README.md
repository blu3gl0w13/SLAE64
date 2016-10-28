# SLAE64

These scripts have been created for completing the requirements of the SecurityTube Linux Assembly Expert 64-bit certification:

http://www.securitytube-training.com/online-courses/x8664-assembly-and-shellcoding-on-linux/index.html

Student ID: SLAE64 - 1439


## Assignment 1

Create a Shell_Bind_TCP shellcode
  - Binds to a port
  - needs a "Passcode"
  - If Passcode is correct then Execs Shell

Remove 0x00 from the Bind TCP Shellcode discussed

## Assignment 2

Create a Shell_Reverse_TCP Shellcode
  - Reverse connects to configured IP and Port
  - needs a "Passcode"
  - If Passcode is correct then Execs Shell

Remove 0x00 from the Reverse TCP Shellcode discussed

## Assignment 3

Study about the Egg Hunter shellcode

Create a working demo of the Egghunter

Should be configurable for different payloads

## Assignment 4

Create a Custom encoding scheme like the "Insertion Encoder" we showed you

PoC with using execve-stack as the shellcode to encode with your schema and execute

## Assignment 5

Take up at least 3 shellcode samples created using MSFPayload for linux/x86_64

Use GDB to dissect the functionality of shellcode

Document your analysis

## Assignment 6

Take up 3 shellcodes form shell-storm and create polymorphic versions of them to beat pattern matching

The polymorphic versions cannot be larger 150% of the existing shellcode

Bonus points for making it shorter in length than original

## Assignment 7

Create a custom crypter like the one shown in the "crypters" video

Free to use any existing encryption schema

Can use any programming language
