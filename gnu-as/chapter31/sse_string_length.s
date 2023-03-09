# sse_string_length.s

          .intel_syntax noprefix

          .extern printf

          .data
# template 0123456789abcdef0123456789abcdef0123456789abcd e
# template 1234567890123456789012345678901234567890123456 7
string1:  .asciz "The quick brown fox jumps over the lazy river."
fmt1:     .asciz "This is our string: %s \n"
fmt2:     .asciz "Our string is %d characters long.\n"

          .bss

          .text

          .global main
main:
  push rbp
  mov rbp, rsp
  mov rdi, offset fmt1
  mov rsi, offset string1
  xor rax, rax
  call printf
  mov rdi, offset string1
  call pstrlen
  mov rdi, offset fmt2
  mov rsi, rax
  xor rax, rax
  call printf
  leave
  ret

# function to compute string length-------------------------
pstrlen:
  push rbp
  mov rbp, rsp
  mov rax, -16 # avoid changing later
  pxor xmm0, xmm0 # 0 (end of string)

.not_found:
  add rax, 16                             # avoid changing ZF later
                                          # after pcmpistri
  pcmpistri xmm0, [rdi + rax], 0b00001000 # 'equal each'
  jnz .not_found                          # 0 found?
  add rax, rcx                            # rcx contains the index of the 0
  inc rax                                 # correct for index 0 at start
  leave
  ret
