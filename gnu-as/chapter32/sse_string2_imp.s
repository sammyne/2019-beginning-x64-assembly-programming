# sse_string2_imp.s
# compare strings implicit length

  .intel_syntax noprefix

  .extern printf

  .data
string1:
  .asciz "the quick brown fox jumps over the lazy river\n"
string2:
  .asciz "the quick brown fox jumps over the lazy river\n"
string3:
  .asciz "the quick brown fox jumps over the lazy dog\n"
fmt1:
  .asciz "Strings 1 and 2 are equal.\n"
fmt11:
  .asciz "Strings 1 and 2 differ at position %i.\n"
fmt2:
  .asciz "Strings 2 and 3 are equal.\n"
fmt22:
  .asciz "Strings 2 and 3 differ at position %i.\n"

  .bss

  .text

  .global main
main:
  push rbp
  mov rbp, rsp
  # first print the strings
  mov rdi, offset string1
  xor rax, rax
  call printf
  mov rdi, offset string2
  xor rax, rax
  call printf
  mov rdi, offset string3
  xor rax, rax
  call printf
  # compare string 1 and 2
  mov rdi, offset string1
  mov rsi, offset string2
  call pstrcmp
  mov rdi, offset fmt1
  cmp rax, 0
  je eql1         # the strings are equal
  mov rdi, offset fmt11  # the strings are unequal

eql1:
  mov rsi, rax
  xor rax, rax
  call printf
  # compare string 2 and 3
  mov rdi, offset string2
  mov rsi, offset string3
  call pstrcmp
  mov rdi, offset fmt2
  cmp rax, 0
  je eql2               # the strings are equal
  mov rdi, offset fmt22 # the strings are unequal

eql2:
  mov rsi, rax
  xor rax, rax
  call printf
  # exit
  leave
  ret

# string compare----------------------------------------------
pstrcmp:
  push rbp
  mov rbp, rsp
  xor rax, rax
  xor rbx, rbx

.loop: movdqu xmm1, [rdi + rbx]
  pcmpistri xmm1, [rsi + rbx], 0x18 # equal each | neg polarity
  jc .differ
  jz .equal
  add rbx, 16
  jmp .loop

.differ:
  mov rax, rbx
  add rax, rcx # the position of the differing character
  inc rax      # because the index starts at 0

.equal:
  leave
  ret
