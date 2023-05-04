# transpose.asm

  .intel_syntax noprefix

  .extern printf

  .data
fmt0:
  .asciz "4x4 DOUBLE PRECISION FLOATING POINT MATRIX TRANSPOSE\n"
fmt1:
  .asciz "\nThis is the matrix:\n"
fmt2:
  .asciz "\nThis is the transpose (sequential version): \n"
fmt3:
  .asciz "\nThis is the transpose (AVX version): \n"
fmt4:
  .asciz "\nNumber of loops: %d\n"
fmt5:
  .asciz "Sequential version elapsed cycles: %d\n"
fmt6:
  .asciz "AVX Shuffle version elapsed cycles: %d\n"
  .align 32
matrix:
  .double 1., 2., 3., 4.
  .double 5., 6., 7., 8.
  .double 9., 10., 11., 12.
  .double 13., 14., 15., 16.
loops:
  .quad 10000


  .bss
  .align 32
  .lcomm transpose, 16 * 8
  .lcomm bahi_cy, 8 # timers for avx version
  .lcomm balo_cy, 8
  .lcomm eahi_cy, 8
  .lcomm ealo_cy, 8
  .lcomm bshi_cy, 8 # timers for sequential version
  .lcomm bslo_cy, 8
  .lcomm eshi_cy, 8
  .lcomm eslo_cy, 8


  .text

  .global main
main:
  push rbp
  mov rbp, rsp
  # print title
  mov rdi, offset fmt0
  call printf
  # print matrix
  mov rdi, offset fmt1
  call printf
  mov rsi, offset matrix
  call printm4x4
  # SEQUENTIAL VERSION
  # compute transpose
  mov rdi, offset matrix
  mov rsi, offset transpose
  mov rdx, [loops]
  # start measuring the cycles
  cpuid
  rdtsc
  mov [bshi_cy], edx
  mov [bslo_cy], eax
  call seq_transpose
  # stop measuring the cycles
  rdtscp
  mov [eshi_cy], edx
  mov [eslo_cy], eax
  cpuid
  # print the result
  mov rdi, offset fmt2
  call printf
  mov rsi, offset transpose
  call printm4x4
  # AVX VERSION
  # compute transpose
  mov rdi, offset matrix
  mov rsi, offset transpose
  mov rdx, [loops]
  # start measuring the cycles
  cpuid
  rdtsc
  mov [bahi_cy], edx
  mov [balo_cy], eax
  call AVX_transpose
  # stop measuring the cycles
  rdtscp
  mov [eahi_cy], edx
  mov [ealo_cy], eax
  cpuid
  # print the result
  mov rdi, offset fmt3
  call printf
  mov rsi, offset transpose
  call printm4x4
  # print the loops
  mov rdi, offset fmt4
  mov rsi, [loops]
  call printf
  # print the cycles
  # cycles sequential version
  mov rdx, [eslo_cy]
  mov rsi, [eshi_cy]
  shl rsi, 32
  or rsi, rdx # rsi contains end time
  mov r8, [bslo_cy]
  mov r9, [bshi_cy]
  shl r9, 32
  or r9, r8   # r9 contains start time
  sub rsi, r9 # rsi contains elapsed
  # print the timing result
  mov rdi, offset fmt5
  call printf
  # cycles AVX blend version
  mov rdx, [ealo_cy]
  mov rsi, [eahi_cy]
  shl rsi, 32
  or rsi, rdx # rsi contains end time
  mov r8, [balo_cy]
  mov r9, [bahi_cy]
  shl r9, 32
  or r9, r8   # r9 contains start time
  sub rsi, r9 # rsi contains elapsed
  # print the timing result
  mov rdi, offset fmt6
  call printf
  leave
  ret

# -----------------------------------------------------
seq_transpose:
  push rbp
  mov rbp, rsp
.loopx: # the number of loops
  pxor xmm0, xmm0
  xor r10, r10
  xor rax, rax
  mov r12, 4
.loopo:
#  push rcx   # this is useless, and trigger SEGFAULT
  mov r13, 4
.loopi:
  movsd xmm0, [rdi+r10]
  movsd [rsi+rax], xmm0
  add r10, 8
  add rax, 32
  dec r13
  jnz .loopi
  add rax, 8
  xor rax, 0b10000000 # rax - 128
  inc rbx
  dec r12
  jnz .loopo
  dec rdx
  jnz .loopx
  leave
  ret

# ---------------------------------------------------------------
AVX_transpose:
  push rbp
  mov rbp, rsp
.loopx2: # the number of loops
  # load matrix into the registers
  vmovapd ymm0, [rdi]     # 1 2 3 4
  vmovapd ymm1, [rdi+32]  # 5 6 7 8
  vmovapd ymm2, [rdi+64]  # 9 10 11 12
  vmovapd ymm3, [rdi+96]  # 13 14 15 16
  # shuffle
  vshufpd ymm12, ymm0, ymm1, 0b0000 # 1 5 3 7
  vshufpd ymm13, ymm0, ymm1, 0b1111 # 2 6 4 8
  vshufpd ymm14, ymm2, ymm3, 0b0000 # 9 13 11 15
  vshufpd ymm15, ymm2, ymm3, 0b1111 # 10 14 12 16
  # permutate
  vperm2f128 ymm0, ymm12, ymm14, 0b00100000 # 1 5 9 13
  vperm2f128 ymm1, ymm13, ymm15, 0b00100000 # 2 6 10 14
  vperm2f128 ymm2, ymm12, ymm14, 0b00110001 # 3 7 11 15
  vperm2f128 ymm3, ymm13, ymm15, 0b00110001 # 4 8 12 16
  # write to memory
  vmovapd [rsi], ymm0
  vmovapd [rsi+32], ymm1
  vmovapd [rsi+64], ymm2
  vmovapd [rsi+96], ymm3
  dec rdx
  jnz .loopx2
  leave
  ret

# ---------------------------------------------------------------
  .data
.fmt:
  .asciz "%f\9%f\9%f\9%f\n"

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
  mov rax, 4    # four floats
  push rcx      # caller saved
  push rsi      # caller saved
  push rdi      # caller saved
  # align stack if needed
  xor r15, r15
  test rsp, 0x0f  # last byte is 8 (not aligned)?
  setnz r15b      # set if not aligned
  shl r15, 3      # multiply by 8
  sub rsp, r15    # substract 0 or 8
  call printf
  add rsp, r15  # add 0 or 8
  pop rdi
  pop rsi
  pop rcx
  add rbx, 32   # next row
  loop .loop
  pop r15
  pop rbx
  leave
  ret
