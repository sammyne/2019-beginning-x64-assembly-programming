# sse_string3_exp.s
# compare strings explicit length

   .intel_syntax noprefix

  .extern printf

.data
string1:
  .ascii "the quick brown fox jumps over the lazy river"
string1Len  = . - string1
string2:
  .ascii "the quick brown fox jumps over the lazy river"
string2Len  = . - string2
dummy:
  .ascii "confuse the world"
string3:
  .ascii "the quick brown fox jumps over the lazy dog"
string3Len  = . - string3
fmt1:
  .asciz "Strings 1 and 2 are equal.\n"
fmt11:
  .asciz "Strings 1 and 2 differ at position %i.\n"
fmt2:
  .asciz "Strings 2 and 3 are equal.\n"
fmt22:
  .asciz "Strings 2 and 3 differ at position %i.\n"

  .bss
  .lcomm buffer, 64

  .text

  .global main
main:
  push rbp
  mov rbp, rsp
  # compare string 1 and 2
  mov rdi, offset string1
  mov rsi, offset string2
  mov rdx, string1Len
  mov rcx, string2Len
  call pstrcmp
  push rax # push result on stack for later use
  # print the string1 and 2 and the result
  #-------------------------------------------------------------
  # first build the string with newline and terminating 0
  # string1
  mov rsi, offset string1
  mov rdi, offset buffer
  mov rcx, string1Len
  rep movsb
  mov byte ptr [rdi], 10  # add NL to buffer
  inc rdi             # add terminating 0 to buffer
  mov byte ptr [rdi], 0
  # print
  mov rdi, offset buffer
  xor rax, rax
  call printf
  # string2
  mov rsi, offset string2
  mov rdi, offset buffer
  mov rcx, string2Len
  rep movsb
  mov byte ptr [rdi], 10  # add NL to buffer
  inc rdi             # add terminating 0 to buffer
  mov byte ptr [rdi], 0
  # print
  mov rdi, offset buffer
  xor rax, rax
  call printf
  #-------------------------------------------------------------
                    # now print the result of the comparison
  pop rax           # recall the return value
  mov rdi, offset fmt1
  cmp rax, 0
  je eql1
  mov rdi, offset fmt11

eql1:
  mov rsi, rax
  xor rax, rax
  call printf
  #-------------------------------------------------------------
  #-------------------------------------------------------------
  # compare string 2 and 3
  mov rdi, offset string2
  mov rsi, offset string3
  mov rdx, string2Len
  mov rcx, string3Len
  call pstrcmp
  push rax
  # print the string3 and the result
  #-------------------------------------------------------------
  # first build the string with newline and terminating 0
  # string3
  mov rsi, offset string3
  mov rdi, offset buffer
  mov rcx, string3Len
  rep movsb
  mov byte ptr [rdi], 10  # add NL to buffer
  inc rdi             # add terminating 0 to buffer
  mov byte ptr [rdi], 0
                    # print
  mov rdi, offset buffer
  xor rax, rax
  call printf
  #-------------------------------------------------------------
                    # now print the result of the comparison
  pop rax           # recall the return value
  mov rdi, offset fmt2
  cmp rax, 0
  je eql2
  mov rdi, offset fmt22

eql2:
  mov rsi, rax
  xor rax, rax
  call printf
  # exit
  leave
  ret

#-------------------------------------------------------------
pstrcmp:
  push rbp
  mov rbp, rsp
  xor rbx, rbx
  mov rax, rdx # rax contains length of 1st string
  mov rdx, rcx # rdx contains length of 2nd string
  xor rcx, rcx # rcx as index

.loop:
  movdqu xmm1, [rdi + rbx]
  pcmpestri xmm1, [rsi + rbx], 0x18 # equal each|neg. polarity
  jc .differ
  jz .equal
  add rbx, 16
  sub rax, 16
  sub rdx, 16
  jmp .loop

.differ:
  mov rax, rbx
  add rax, rcx                      # rcx contains the differing position
  inc rax                           # because the counter starts at 0
  jmp exit

.equal:
  xor rax, rax

exit:
  leave
  ret
