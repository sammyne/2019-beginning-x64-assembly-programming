# sse_string_search.s

          .intel_syntax noprefix

          .extern printf

          .data
# template 123456789012345678901234567890123456789012345 6
# template 0123456789abcdef0123456789abcdef0123456789abc d
string1:  .asciz "the quick brown fox jumps over the lazy river"
string2:  .asciz "e"
fmt1:     .asciz "This is our string: %s \n"
fmt2:     .asciz "The first '%s' is at position %d.\n"
fmt3:     .asciz "The last '%s' is at position %d.\n"
fmt4:     .asciz "The character '%s' didn't show up!.\n"

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
  # find the first occurrence
  mov rdi, offset string1
  mov rsi, offset string2
  call pstrscan_f
  cmp rax, 0
  je no_show
  mov rdi, offset fmt2
  mov rsi, offset string2
  mov rdx, rax
  xor rax,rax
  call printf
  # find the last occurrence
  mov rdi, offset string1
  mov rsi, offset string2
  call pstrscan_l
  mov rdi, offset fmt3
  mov rsi, offset string2
  mov rdx, rax
  xor rax, rax
  call printf
  jmp exit

no_show:
  mov rdi, offset fmt4
  mov rsi, offset string2
  xor rax, rax
  call printf

exit:
  leave
  ret

#------ find the first occurrence ----------------------
pstrscan_f:
  push rbp
  mov rbp, rsp
  xor rax, rax
  pxor xmm0, xmm0
  pinsrb xmm0, [rsi], 0

.block_loop:
  pcmpistri xmm0, [rdi + rax], 0b00000000
  jc .found
  jz .none
  add rax, 16
  jmp .block_loop

.found:
  add rax, rcx  # rcx contains the position of the char
  inc rax       # start counting from 1 instead of 0
  leave
  ret

.none:
  xor rax,rax # nothing found, return 0
  leave
  ret

#------ find the last occurrence ----------------------
pstrscan_l:
  push rbp
  mov rbp, rsp
  push rbx # callee saved
  push r12 # callee saved
  xor rax, rax
  pxor xmm0, xmm0
  pinsrb xmm0, [rsi], 0
  xor r12, r12

.block_loop2:
  pcmpistri xmm0, [rdi + rax], 0b01000000
  setz bl
  jc .found2
  jz .done
  add rax, 16
  jmp .block_loop2

.found2:
  mov r12, rax
  add r12, rcx # rcx contains the position of the char
  inc r12
  cmp bl, 1
  je .done
  add rax,16
  jmp .block_loop2
  pop r12 # callee saved
  pop rbx # callee saved
  leave
  ret

.done:
  mov rax,r12
  pop r12 # callee saved
  pop rbx # callee saved
  leave
  ret
