# adouble.s

  .intel_syntax noprefix

  .data

  .bss

  .text

  .global adouble
adouble:        # double the elements
  mov rcx, rsi  # array length
  mov rbx, rdi  # address of array
  mov r12, 0

aloop:
  movsd xmm0, qword ptr [rbx+r12*8] # take an
  addsd xmm0, xmm0                  # double it
  movsd qword ptr [rbx+r12*8], xmm0 # move it to array
  inc r12
  loop aloop
  ret
