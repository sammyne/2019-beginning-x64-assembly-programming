# mxcsr.s

  .intel_syntax noprefix

  .extern printf
  .extern print_mxcsr
  .extern print_hex

  .data
eleven:
  .double 11.0
two:
  .double 2.0
three:
  .double 3.0
ten:
  .double 10.0
zero:
  .double 0.0
hex:
  .asciz "0x"
fmt1:
  .asciz "\nDivide, default mxcsr:\n"
fmt2:
  .asciz "\nDivide by zero, default mxcsr:\n"
fmt4:
  .asciz "\nDivide, round up:\n"
fmt5:
  .asciz "\nDivide, round down:\n"
fmt6:
  .asciz "\nDivide, truncate:\n"
f_div:
  .asciz "%.1f divided by %.1f is %.16f, in hex: "
f_before:
  .asciz "\nmxcsr before:\9"
f_after:
  .asciz "mxcsr after:\9"

# mxcsr values
default_mxcsr:
  .int 0b0001111110000000
round_nearest:
  .int 0b0001111110000000
round_down:
  .int 0b0011111110000000
round_up:
  .int 0b0101111110000000
truncate:
  .int 0b0111111110000000


  .bss
  .lcomm mxcsr_before, 1 * 4
  .lcomm mxcsr_after, 1 * 4
  .lcomm xmm, 1 * 8

  .text
  .global main
main:
  push rbp
  mov rbp, rsp
  # division
  # default mxcsr
  mov rdi, offset fmt1
  mov rsi, offset ten
  mov rdx, offset two
  mov ecx, [default_mxcsr]
  call apply_mxcsr
  # ----------------------------------------------
  # division with precision error
  # default mxcsr
  mov rdi, offset fmt1
  mov rsi, offset ten
  mov rdx, offset three
  mov ecx, [default_mxcsr]
  call apply_mxcsr
  # divide by zero
  # default mxcsr
  mov rdi, offset fmt2
  mov rsi, offset ten
  mov rdx, offset zero
  mov ecx, [default_mxcsr]
  call apply_mxcsr
  # division with precision error
  # round up
  mov rdi, offset fmt4
  mov rsi, offset ten
  mov rdx, offset three
  mov ecx, [round_up]
  call apply_mxcsr
  # division with precision error
  # round up
  mov rdi, offset fmt5
  mov rsi, offset ten
  mov rdx, offset three
  mov ecx, [round_down]
  call apply_mxcsr
  # division with precision error
  # truncate
  mov rdi, offset fmt6
  mov rsi, offset ten
  mov rdx, offset three
  mov ecx, [truncate]
  call apply_mxcsr
  #----------------------------------------------
  # division with precision error
  # default mxcsr
  mov rdi, offset fmt1
  mov rsi, offset eleven
  mov rdx, offset three
  mov ecx, [default_mxcsr]
  call apply_mxcsr  # division with precision error
  # round up
  mov rdi, offset fmt4
  mov rsi, offset eleven
  mov rdx, offset three
  mov ecx, [round_up]
  call apply_mxcsr
  # division with precision error
  # round up
  mov rdi, offset fmt5
  mov rsi, offset eleven
  mov rdx, offset three
  mov ecx, [round_down]
  call apply_mxcsr
  # division with precision error
  # truncate
  mov rdi, offset fmt6
  mov rsi, offset eleven
  mov rdx, offset three
  mov ecx, [truncate]
  call apply_mxcsr
  leave
  ret

# function --------------------------------------------
apply_mxcsr:
  push rbp
  mov rbp, rsp
  push rsi
  push rdx
  push rcx
  push rbp                # one more for stack alignment
  call printf
  pop rbp
  pop rcx
  pop rdx
  pop rsi
  mov [mxcsr_before], ecx
  ldmxcsr [mxcsr_before]
  movsd xmm2, [rsi]       # double precision float into xmm2
  divsd xmm2, [rdx]       # divide xmm2
  stmxcsr [mxcsr_after]   # save mxcsr to memory
  movsd [xmm], xmm2       # for use in print_xmm
  mov rdi, offset f_div
  movsd xmm0, [rsi]
  movsd xmm1, [rdx]
  call printf
  call print_xmm
  # print mxcsr
  mov rdi, offset f_before
  call printf
  mov rdi, [mxcsr_before]
  call print_mxcsr
  mov rdi, offset f_after
  call printf
  mov rdi, [mxcsr_after]
  call print_mxcsr
  leave
  ret

# function --------------------------------------------
print_xmm:
  push rbp
  mov rbp, rsp
  mov rdi, offset hex # print 0x
  call printf
  mov rcx, 8

.loop:
  xor rdi, rdi
  mov dil, [xmm+rcx-1]
  push rcx
  call print_hex
  pop rcx
  loop .loop
  leave
  ret
