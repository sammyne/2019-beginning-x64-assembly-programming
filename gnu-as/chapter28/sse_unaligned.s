# sse_unaligned.s

  .intel_syntax noprefix

  .extern printf

  .data
  # single precision
spvector1:
  .float 1.1
  .float 2.2
  .float 3.3
  .float 4.4
spvector2:
  .float 1.1
  .float 2.2
  .float 3.3
  .float 4.4
# double precision
dpvector1:
  .double 1.1
  .double 2.2
dpvector2:
  .double 3.3
  .double 4.4
fmt1:
  .asciz "Single Precision Vector 1: %f, %f, %f, %f\n"
fmt2:
  .asciz "Single Precision Vector 2: %f, %f, %f, %f\n"
fmt3:
  .asciz "Sum of Single Precision Vector 1 and Vector 2: %f, %f, %f, %f\n"
fmt4:
  .asciz "Double Precision Vector 1: %f, %f\n"
fmt5:
  .asciz "Double Precision Vector 2: %f, %f\n"
fmt6:
  .asciz "Sum of Double Precision Vector 1 and Vector 2: %f, %f\n"


  .bss
  .lcomm spvector_res, 4 * 4
  .lcomm dpvector_res, 4 * 8


  .text

  .global main

main:
  push rbp
  mov rbp, rsp
  # add 2 single precision floating point vectors
  mov rsi, offset spvector1
  mov rdi, offset fmt1
  call printspfp
  mov rsi, offset spvector2
  mov rdi, offset fmt2
  call printspfp
  movups xmm0, [spvector1]
  movups xmm1, [spvector2]
  addps xmm0, xmm1
  movups [spvector_res], xmm0
  mov rsi, offset spvector_res
  mov rdi, offset fmt3
  call printspfp
  # add 2 double precision floating point vectors
  mov rsi, offset dpvector1
  mov rdi, offset fmt4
  call printdpfp
  mov rsi, offset dpvector2
  mov rdi, offset fmt5
  call printdpfp
  movupd xmm0, [dpvector1]
  movupd xmm1, [dpvector2]
  addpd xmm0, xmm1
  movupd [dpvector_res], xmm0
  mov rsi, offset dpvector_res
  mov rdi, offset fmt6
  call printdpfp
  leave
  ret

printspfp:
  push rbp
  mov rbp, rsp
  movss xmm0, [rsi]
  cvtss2sd xmm0, xmm0
  movss xmm1, [rsi+4]
  cvtss2sd xmm1, xmm1
  movss xmm2, [rsi+8]
  cvtss2sd xmm2, xmm2
  movss xmm3, [rsi+12]
  cvtss2sd xmm3, xmm3
  mov rax, 4          # four floats
  call printf
  leave
  ret

printdpfp:
  push rbp
  mov rbp, rsp
  movsd xmm0, [rsi]
  movsd xmm1, [rsi+8]
  mov rax, 2          # four floats
  call printf
  leave
  ret
