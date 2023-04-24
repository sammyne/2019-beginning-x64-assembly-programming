# transpose4x4.s

  .intel_syntax noprefix

  .extern printf

  .data
fmt0:
  .asciz "4x4 DOUBLE PRECISION FLOATING POINT MATRIX TRANSPOSE\n"
fmt1:
  .asciz "\nThis is the matrix:\n"
fmt2:
  .asciz "\nThis is the transpose (unpack):\n"
fmt3:
  .asciz "\nThis is the transpose (shuffle):\n"
  
  .align 32
matrix:
  .double 1., 2., 3., 4.
  .double 5., 6., 7., 8.
  .double 9., 10., 11., 12.
  .double 13., 14., 15., 16.

  .bss
  .align 32
  .lcomm transpose, 16 * 8

  .text
  .global main
main:
  push rbp
  mov rbp, rsp
  # print title
  mov rdi, offset fmt1
  call printf
  # print matrix
  mov rsi, offset matrix
  call printm4x4
  # compute transpose unpack
  mov rdi, offset matrix
  mov rsi, offset transpose
  call transpose_unpack_4x4
  # print the result
  mov rdi, offset fmt2
  xor rax, rax
  call printf
  mov rsi, offset transpose
  call printm4x4
  # compute transpose shuffle
  mov rdi, offset matrix
  mov rsi, offset transpose
  call transpose_shuffle_4x4
  # print the result
  mov rdi, offset fmt3
  xor rax, rax
  call printf
  mov rsi, offset transpose
  call printm4x4
  leave
  ret

# --------------------------------------------------------
transpose_unpack_4x4:
  push rbp
  mov rbp, rsp
  # load matrix into the registers
  vmovapd ymm0, [rdi]                       # 1 2 3 4
  vmovapd ymm1, [rdi+32]                    # 5 6 7 8
  vmovapd ymm2, [rdi+64]                    # 9 10 11 12
  vmovapd ymm3, [rdi+96]                    # 13 14 15 16
  # unpack
  vunpcklpd ymm12, ymm0, ymm1               # 1 5 3 7
  vunpckhpd ymm13, ymm0, ymm1               # 2 6 4 8
  vunpcklpd ymm14, ymm2, ymm3               # 9 13 11 15
  vunpckhpd ymm15, ymm2, ymm3               # 10 14 12 16
  # permutate
  vperm2f128 ymm0, ymm12, ymm14, 0b00100000  # 1 5 9 13
  vperm2f128 ymm1, ymm13, ymm15, 0b00100000  # 2 6 10 14
  vperm2f128 ymm2, ymm12, ymm14, 0b00110001  # 3 7 11 15
  vperm2f128 ymm3, ymm13, ymm15, 0b00110001  # 4 8 12 16
  # write to memory
  vmovapd [rsi], ymm0
  vmovapd [rsi+32], ymm1
  vmovapd [rsi+64], ymm2
  vmovapd [rsi+96], ymm3
  leave
  ret

#--------------------------------------------------------
transpose_shuffle_4x4:
  push rbp
  mov rbp, rsp
  # load matrix into the registers
  vmovapd ymm0, [rdi]                       # 1 2 3 4
  vmovapd ymm1, [rdi+32]                    # 5 6 7 8
  vmovapd ymm2, [rdi+64]                    # 9 10 11 12
  vmovapd ymm3, [rdi+96]                    # 13 14 15 16
  # shuffle
  vshufpd ymm12, ymm0, ymm1, 0b0000          # 1 5 3 7
  vshufpd ymm13, ymm0, ymm1, 0b1111          # 2 6 4 8
  vshufpd ymm14, ymm2, ymm3, 0b0000          # 9 13 11 15
  vshufpd ymm15, ymm2, ymm3, 0b1111          # 10 14 12 16
  # permutate
  vperm2f128 ymm0, ymm12, ymm14, 0b00100000  # 1 5 9 13
  vperm2f128 ymm1, ymm13, ymm15, 0b00100000  # 2 6 10 14
  vperm2f128 ymm2, ymm12, ymm14, 0b00110001  # 3 7 11 15
  vperm2f128 ymm3, ymm13, ymm15, 0b00110001  # 4 8 12 16
  # write to memory
  vmovapd [rsi], ymm0
  vmovapd [rsi+32], ymm1
  vmovapd [rsi+64], ymm2
  vmovapd [rsi+96], ymm3
  leave
  ret

# --------------------------------------------------------
  .data
.fmt:
  .asciz "%.f\9%.f\9%.f\9%.f\n"

  .text
printm4x4:
  push rbp
  mov rbp, rsp
  push rbx      # callee saved
  push r15      # callee saved
  mov rdi, offset .fmt
  mov rcx, 4
  xor rbx, rbx  # row counter

.loop:
  movsd xmm0, [rsi+rbx]
  movsd xmm1, [rsi+rbx+8]
  movsd xmm2, [rsi+rbx+16]
  movsd xmm3, [rsi+rbx+24]
  mov rax,4                 # four floats
  push rcx                  # caller saved
  push rsi                  # caller saved
  push rdi                  # caller saved
                            # align stack if needed
  xor r15, r15
  test rsp, 0x0f            # last byte is 8 (not aligned)?
  setnz r15b                # set if not aligned
  shl r15, 3                # multiply by 8
  sub rsp, r15              # substract 0 or 8
  call printf
  add rsp, r15              # add 0 or 8
  pop rdi
  pop rsi
  pop rcx
  add rbx, 32               # next row
  loop .loop
  pop r15
  pop rbx
  leave
  ret
