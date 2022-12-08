# function.s

.intel_syntax noprefix

.extern printf

.data

radius: .double 10.0
pi:     .double 3.14
fmt:    .asciz  "The area of the circle is %.2f\n"


.bss


.text


.global main

# ----------------------------------------------
main:
  push rbp
  mov rbp, rsp
  call area           # call the function
  mov rdi, offset fmt # print format
  mov rax, 1          # area in xmm0
  call printf
  leave
  ret

# ----------------------------------------------
area:
  push rbp
  mov rbp, rsp
  movsd xmm0, [radius]  # move float to xmm0
  mulsd xmm0, [radius]  # multiply xmm0 by float
  mulsd xmm0, [pi]      # multiply xmm0 by float
  leave
  ret
