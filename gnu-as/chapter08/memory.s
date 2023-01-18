# memory.s

.intel_syntax noprefix


.data

bNum:   .byte 123
wNum:   .word 12345
warray: .rept 5   # array of 5 words containing 0
        .word 0
        .endr
dNum:   .int 12345
qNum1:  .quad 12345
text1:  .asciz "abc"
qNum2:  .double 3.141592654


.bss

.lcomm bvar, 1
.lcomm dvar, 4    # 1 double-words
.lcomm wvar, 20   # 10 words
.lcomm qvar, 24   # 3 quad-words

.text

.global main

main:
  push rbp
  mov rbp, rsp
  lea rax, [bNum]         # load address of bNum in rax
  mov rax, offset bNum    # load address of bNum in rax
  mov rax, [bNum]         # load value at bNum in rax
  mov [bvar], rax         # load from rax at address bvar
  lea rax, [bvar]         # load address of bvar in rax
  lea rax, [wNum]         # load address of wNum in rax
  mov rax, [wNum]         # load content of wNum in rax
  lea rax, [text1]        # load address of text1 in rax
  mov rax, offset text1   # load address of text1 in rax
  mov rax, offset text1+1 # load second character in rax
  lea rax, [text1+1]      # load second character in rax
  mov rax, [text1]        # load starting at text1 in rax
  mov rax, [text1+1]      # load starting at text1+1 in rax
  mov rsp, rbp
  pop rbp
  ret
