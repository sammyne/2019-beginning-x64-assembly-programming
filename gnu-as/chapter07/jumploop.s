# jumploop.asm
# calculate 1+2+...+5
.intel_syntax noprefix

.extern printf

.data

number: .quad 5
fmt:    .asciz "The sum from 0 to %ld is %ld\n"


.bss


.text

.global main

main:
  push rbp
  mov rbp, rsp
  mov rbx, 0 # counter
  mov rax, 0 # sum will be in rax

jloop:
  add rax, rbx
  inc rbx
  cmp rbx, [number]   # number already reached?
  jle jloop           # number not reached yet, loop
                      # number reached, continue here
  mov rdi, offset fmt # prepare for displaying
  mov rsi, [number]
  mov rdx, rax
  mov rax, 0
  call printf
  mov rsp, rbp
  pop rbp
  ret