# hello2.s
.intel_syntax noprefix

.data

msg:  .asciz "hello, world"
NL:   .byte  0xa # ascii code for new line


.bss

.text

.global main

main:
  mov rax, 1          # 1 = write
  mov rdi, 1          # 1 = to stdout
  mov rsi, offset msg # string to display
  mov rdx, 12         # length of string, without 0
  syscall             # display the string
  mov rax, 1          # 1 = write
  mov rdi, 1          # 1 = to stdout
  mov rsi, offset NL  # display new line
  mov rdx, 1          # length of the string
  syscall             # display the string
  mov rax, 60         # 60 = exit
  mov rdi, 0          # 0 = success exit code
  syscall             # quit
