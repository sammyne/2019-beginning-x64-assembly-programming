# avx_unaligned.s

  .intel_syntax noprefix

  .extern printf

  .data
spvector1:
  .float 1.1
  .float 2.1
  .float 3.1
  .float 4.1
  .float 5.1
  .float 6.1
  .float 7.1
  .float 8.1
spvector2:
  .float 1.2
  .float 1.2
  .float 3.2
  .float 4.2
  .float 5.2
  .float 6.2
  .float 7.2
  .float 8.2
dpvector1:
  .double 1.1
  .double 2.2
  .double 3.3
  .double 4.4
dpvector2:
  .double 5.5
  .double 6.6
  .double 7.7
  .double 8.8
fmt1:
  .asciz "Single Precision Vector 1:\n"
fmt2:
  .asciz "\nSingle Precision Vector 2:\n"
fmt3:
  .asciz "\nSum of Single Precision Vector 1 and Vector 2:\n"
fmt4:
  .asciz "\nDouble Precision Vector 1:\n"
fmt5:
  .asciz "\nDouble Precision Vector 2:\n"
fmt6:
  .asciz "\nSum of Double Precision Vector 1 and Vector 2:\n"

newline:
  .asciz "\n"
fmt_f32:
  .asciz "%.1f, "
fmt_4f32:
  .asciz "%.1f, %.1f, %.1f, %.1f"

  .bss
  .lcomm spvector_res, 4*8
  .lcomm dpvector_res, 8*4

  .text

  .global main
main:
  push rbp
  mov rbp, rsp
  # SINGLE PRECISION FLOATING POINT VECTORS
  # load vector1 in the register ymm0
  vmovups ymm0, [spvector1]
  # extract ymm0
  vextractf128 xmm2, ymm0, 0 # first part of ymm0
  vextractf128 xmm2, ymm0, 1 # second part of ymm0
  # load vector2 in the register ymm1
  vmovups ymm1, [spvector2]
  # extract ymm1
  vextractf128 xmm2, ymm1, 0
  vextractf128 xmm2, ymm1, 1
  # add 2 single precision floating point vectors
  vaddps ymm2, ymm0, ymm1
  vmovups [spvector_res], ymm2
  # print the vectors
  mov rdi, offset fmt1
  call printf
  mov rsi, offset spvector1
  call printspfpv
  mov rdi, offset fmt2
  call printf
  mov rsi, offset spvector2
  call printspfpv
  mov rdi, offset fmt3
  call printf
  mov rsi, offset spvector_res
  call printspfpv
  # DOUBLE PRECISION FLOATING POINT VECTORS
  # load vector1 in the register ymm0
  vmovups ymm0, [dpvector1]
  # extract ymm0
  vextractf128 xmm2, ymm0, 0 # first part of ymm0
  vextractf128 xmm2, ymm0, 1 # second part of ymm0
  # load vector2 in the register ymm1
  vmovups ymm1, [dpvector2]
  # extract ymm1
  vextractf128 xmm2, ymm1, 0
  vextractf128 xmm2, ymm1, 1
  # add 2 double precision floating point vectors
  vaddpd ymm2, ymm0, ymm1
  vmovupd [dpvector_res], ymm2
  # print the vectors
  mov rdi, offset fmt4
  call printf
  mov rsi, offset dpvector1
  call printdpfpv
  mov rdi, offset fmt5
  call printf
  mov rsi, offset dpvector2
  call printdpfpv
  mov rdi, offset fmt6
  call printf
  mov rsi, offset dpvector_res
  call printdpfpv
  leave
  ret

printspfpv:
  push rbp
  mov rbp, rsp
  push rcx
  push rbx
  mov rcx, 8
  mov rbx, 0
  mov rax, 1

.loop:
  movss xmm0, [rsi+rbx]
  cvtss2sd xmm0, xmm0
  mov rdi, offset fmt_f32
  push rsi
  push rcx
  call printf
  pop rcx
  pop rsi
  add rbx, 4
  loop .loop
  xor rax, rax
  mov rdi, offset newline
  call printf
  pop rbx
  pop rcx
  leave
  ret

printdpfpv:
  push rbp
  mov rbp, rsp
  mov rdi, offset fmt_4f32
  # fix bugs in book
  movsd xmm0, [rsi]
  movsd xmm1, [rsi+8]
  movsd xmm2, [rsi+16]
  movsd xmm3, [rsi+24]
  # end fix bugs in book
  mov rax, 4 # four floats
  call printf
  mov rdi, offset newline
  call printf
  leave
  ret
