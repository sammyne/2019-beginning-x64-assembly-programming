# function5.s

.intel_syntax noprefix

.extern printf

.data

first:   .asciz "A"
second:  .asciz "B"
third:   .asciz "C"
fourth:  .asciz "D"
fifth:   .asciz "E"
sixth:   .asciz "F"
seventh: .asciz "G"
eighth:  .asciz "H"
ninth:   .asciz "I"
tenth:   .asciz "J"
fmt1:    .asciz "The string is: %s%s%s%s%s%s%s%s%s%s\n"
fmt2:    .asciz "PI = %f\n"
pi:      .double 3.14


.bss


.text


.global main

main:
  push rbp
  mov rbp, rsp
  mov rdi, offset fmt1                # first use the registers
  mov rsi, offset first
  mov rdx, offset second
  mov rcx, offset third
  mov r8, offset fourth
  mov r9, offset fifth
  push offset tenth                  # now start pushing in
  push offset ninth                  # reverse order
  push offset eighth
  push offset seventh
  push offset sixth
  mov rax, 0
  call printf
  and rsp, 0xfffffffffffffff0 # 16-byte align the stack
  movsd xmm0, [pi]            # now print a floating-point
  mov rax, 1                  # 1 float to print
  mov rdi, offset fmt2
  call printf
  leave
  ret
