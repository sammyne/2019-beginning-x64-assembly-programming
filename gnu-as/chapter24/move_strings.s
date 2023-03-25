# move_strings.asm

  .intel_syntax noprefix

.macro prnt string length
  mov rax, 1  # 1 = write
  mov rdi, 1  # 1 = to stdout
  mov rsi, offset \string
  mov rdx, \length
  syscall
  mov rax, 1
  mov rdi, 1
  mov rsi, offset NL
  mov rdx, 1
  syscall
.endm

  .data
  .equ length, 95
NL:
  .byte 0xa
string1:
  .asciz "my_string of ASCII:"
string2:
  .asciz "\nmy_string of zeros:"
string3:
  .asciz "\nmy_string of ones:"
string4:
  .asciz "\nagain my_string of ASCII:"
string5:
  .asciz "\ncopy my_string to other_string:"
string6:
  .asciz "\nreverse copy my_string to other_string:"

  .bss
  .lcomm my_string, length
  .lcomm other_string, length

  .text

  .global main
main:
  push rbp
  mov rbp, rsp
                                  #--------------------------------------------------
                                  # fill the string with printable ascii characters
  prnt string1, 18
  mov rax, 32
  mov rdi, offset my_string
  mov rcx, length

str_loop1:
  mov byte ptr [rdi], al              # the simple method
  inc rdi
  inc al
  loop str_loop1
  prnt my_string, length
                                  #--------------------------------------------------
                                  # fill the string with ascii 0's
  prnt string2, 20
  mov rax, 48                     # ASCII code for '0'
  mov rdi, offset my_string
  mov rcx, length

str_loop2:
  stosb                           # no inc rdi needed anymore
  loop str_loop2
  prnt my_string, length
                                  #--------------------------------------------------
                                  # fill the string with ascii 1's
  prnt string3, 19
  mov rax, 49                     # ASCII code for '1'
  mov rdi, offset my_string
  mov rcx, length
  rep stosb                       # no inc rdi and no loop needed anymore
  prnt my_string, length
                                  #--------------------------------------------------
                                  # fill the string again with printable ascii characters
  prnt string4, 26
  mov rax, 32                     # ASCII code for whitespace
  mov rdi, offset my_string
  mov rcx, length

str_loop3:
  mov byte ptr [rdi], al          # the simple method
  inc rdi
  inc al
  loop str_loop3
  prnt my_string, length
                                  #--------------------------------------------------
                                  # copy my_string to other_string
  prnt string5, 32
  mov rsi, offset my_string              # rsi source
  mov rdi, offset other_string           # rdi destination
  mov rcx, length
  rep movsb
  prnt other_string, length
                                  #--------------------------------------------------
                                  # reverse copy my_string to other_string
  prnt string6, 40
  mov rax, 48                     # clear other_string
  mov rdi, offset other_string
  mov rcx, length
  rep stosb
  lea rsi, [my_string+length-4]
  lea rdi, [other_string+length]
  mov rcx, 27                     # copy only 27-1 characters
  std                             # std sets DF, cld clears DF
  rep movsb
  prnt other_string, length

  leave
  ret
