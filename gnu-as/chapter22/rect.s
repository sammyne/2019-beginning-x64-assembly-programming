# rect.s

  .intel_syntax noprefix

  .data

  .bss

  .text

  .global rarea
rarea:
  push rbp
  mov rbp, rsp
  mov rax, rdi
  imul rsi
  leave
  ret

  .global rcircum
rcircum:
  push rbp
  mov rbp, rsp
  mov rax, rdi
  add rax, rsi
  imul rax, 2
  leave
  ret
