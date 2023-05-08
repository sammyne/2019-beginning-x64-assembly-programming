# sse_integer.s

  .intel_syntax noprefix

  .extern printf

  .data
dummy:
  .byte 13
  .align 16
pdivector1:
  .int 1
  .int 2
  .int 3
  .int 4
pdivector2:
  .int 5
  .int 6
  .int 7
  .int 8
fmt1:
  .asciz "Packed Integer Vector 1: %d, %d, %d, %d\n"
fmt2:
  .asciz "Packed Integer Vector 2: %d, %d, %d, %d\n"
fmt3:
  .asciz "Sum Vector: %d, %d, %d, %d\n"
fmt4:
  .asciz "Reverse of Sum Vector: %d, %d, %d, %d\n"

  .bss
  .align 16
  .lcomm pdivector_res, 4 * 4
  .lcomm pdivector_other, 4 * 4

  .text

  .global main

main:
  push rbp
  mov rbp, rsp
  # print vector 1
  mov rsi, offset pdivector1
  mov rdi, offset fmt1
  call printpdi
  # print vector 2
  mov rsi, offset pdivector2
  mov rdi, offset fmt2
  call printpdi
  # add 2 aligned double int vectors
  movdqa xmm0, [pdivector1]
  paddd xmm0, [pdivector2]
  # store the result in memory
  movdqa [pdivector_res], xmm0
  # print the vector in memory
  mov rsi, offset pdivector_res
  mov rdi, offset fmt3
  call printpdi
  # copy the memory vector to xmm3
  movdqa xmm3, [pdivector_res]
  # extract the packed values from xmm3
  pextrd eax, xmm3, 0
  pextrd ebx, xmm3, 1
  pextrd ecx, xmm3, 2
  pextrd edx, xmm3, 3
  # insert in xmm0 in reverse order
  pinsrd xmm0, eax, 3
  pinsrd xmm0, ebx, 2
  pinsrd xmm0, ecx, 1
  pinsrd xmm0, edx, 0
  # print the reversed vector
  movdqa [pdivector_other], xmm0
  mov rsi, offset pdivector_other
  mov rdi, offset fmt4
  call printpdi
  # exit
  mov rsp,rbp
  pop rbp
  ret

# print function-----------------------------------------
printpdi:
  push rbp
  mov rbp,rsp
  movdqa xmm0, [rsi]
  # extract the packed values from xmm0
  pextrd esi, xmm0, 0
  pextrd edx, xmm0, 1
  pextrd ecx, xmm0, 2
  pextrd r8d, xmm0, 3
  mov rax, 0          # no floats
  call printf
  leave
  ret
