# cmdline.asm

.intel_syntax noprefix

      .extern printf

      .data
msg:  .asciz "The command and arguments: \n"
fmt:  .asciz "%s\n"

      .bss

      .text

      .global main
main:
  push rbp
  mov rbp, rsp
  mov r12, rdi                # number of arguments
  mov r13, rsi                # address of arguments array
                              # print the title
  mov rdi, offset msg
  call printf
  mov r14, 0
                              # print the command and arguments
  .ploop:                     # loop through the array and print
  mov rdi, offset fmt
  mov rsi, qword ptr [r13+r14*8]
  call printf
  inc r14
  cmp r14, r12                # number of arguments reached?
  jl .ploop
  leave
  ret
