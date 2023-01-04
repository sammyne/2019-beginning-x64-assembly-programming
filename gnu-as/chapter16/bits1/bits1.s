# bits1.s

.intel_syntax noprefix

.extern printb
.extern printf

.data
  msgn1:   .asciz "Number 1\n"
  msgn2:   .asciz "Number 2\n"
  msg1:    .asciz "XOR\n"
  msg2:    .asciz "OR\n"
  msg3:    .asciz "AND\n"
  msg4:    .asciz "NOT number 1\n"
  msg5:    .asciz "SHL 2 lower byte of number 1\n"
  msg6:    .asciz "SHR 2 lower byte of number 1\n"
  msg7:    .asciz "SAL 2 lower byte of number 1\n"
  msg8:    .asciz "SAR 2 lower byte of number 1\n"
  msg9:    .asciz "ROL 2 lower byte of number 1\n"
  msg10:   .asciz "ROL 2 lower byte of number 2\n"
  msg11:   .asciz "ROR 2 lower byte of number 1\n"
  msg12:   .asciz "ROR 2 lower byte of number 2\n"
  number1: .quad -72
  number2: .quad 1064

  .fmtstr: .asciz "%s"

.bss


.text


.global main

main:
  push rbp
  mov rbp, rsp
  # print number1
  mov rsi, offset msgn1
  call printmsg
  mov rdi, [number1]
  call printb
  # print number2
  mov rsi, offset msgn2
  call printmsg
  mov rdi, [number2]
  call printb
  # print XOR (exclusive OR)------------------------
  mov rsi, offset msg1
  call printmsg
  # xor and print
  mov rax, [number1]
  xor rax, [number2]
  mov rdi, rax
  call printb
  # print OR ---------------------------------------
  mov rsi, offset msg2
  call printmsg
  # or and print
  mov rax, [number1]
  or rax, [number2]
  mov rdi, rax
  call printb
  # print AND ---------------------------------------
  mov rsi, offset msg3
  call printmsg
  # and and print
  mov rax, [number1]
  and rax, [number2]
  mov rdi, rax
  call printb
  # print NOT ---------------------------------------
  mov rsi, offset msg4
  call printmsg
  # not and print
  mov rax, [number1]
  not rax
  mov rdi, rax
  call printb
  # print SHL (shift left----------------------------
  mov rsi, offset msg5
  call printmsg
  # shl and print
  mov rax, [number1]
  shl al, 2
  mov rdi, rax
  call printb
  # print SHR (shift right)--------------------------
  mov rsi, offset msg6
  call printmsg
  # shr and print
  mov rax, [number1]
  shr al, 2
  mov rdi, rax
  call printb
  # print SAL (shift arithmetic left)----------------
  mov rsi, offset msg7
  call printmsg
  # sal and print
  mov rax, [number1]
  sal al, 2
  mov rdi, rax
  call printb
  # print SAR (shift arithmetic right)----------------
  mov rsi, offset msg8
  call printmsg
  # sar and print
  mov rax, [number1]
  sar al, 2
  mov rdi, rax
  call printb
  # print ROL (rotate left)---------------------------
  mov rsi, offset msg9
  call printmsg
  # rol and print
  mov rax, [number1]
  rol al, 2
  mov rdi, rax
  call printb
  mov rsi, offset msg10
  call printmsg
  mov rax, [number2]
  rol al, 2
  mov rdi, rax
  call printb
  # print ROR (rotate right)---------------------------
  mov rsi, offset msg11
  call printmsg
  # ror and print
  mov rax, [number1]
  ror al, 2
  mov rdi, rax
  call printb
  mov rsi, offset msg12
  call printmsg
  mov rax, [number2]
  ror al, 2
  mov rdi, rax
  call printb
  leave
  ret

# -----------------------------------------------------
printmsg: # print the heading for every bit operation
  mov rdi, offset .fmtstr
  mov rax, 0
  call printf
  ret
