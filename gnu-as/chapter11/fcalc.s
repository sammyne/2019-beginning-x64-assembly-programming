# icalc.s

.intel_syntax noprefix

.extern printf

.data

number1:  .double 9.0
number2:  .double 73.0
fmt:      .asciz "The numbers are %f and %f\n"
fmtfloat: .asciz "%s %f\n"
f_sum:    .asciz "The float sum of %f and %f is %f\n"
f_dif:    .asciz "The float difference of %f and %f is %f\n"
f_mul:    .asciz "The float product of %f and %f is %f\n"
f_div:    .asciz "The float division of %f by %f is %f\n"
f_sqrt:   .asciz "The float squareroot of %f is %f\n"


.bss


.text


.global main

main:
  push rbp
  mov rbp, rsp
                          # print the numbers
  movsd xmm0, [number1]
  movsd xmm1, [number2]
  mov rdi, offset fmt
  mov rax, 2              # two floats
  call printf
                          # sum
  movsd xmm2, [number1]   # double precision float into xmm
  addsd xmm2, [number2]   # add doube precision to xmm
                          # print the result
  movsd xmm0, [number1]
  movsd xmm1, [number2]
  mov rdi, offset f_sum
  mov rax, 3              # three floats
  call printf
                          # difference
  movsd xmm2, [number1]   # double precision float into xmm
  subsd xmm2, [number2]   # subtract from xmm
                          # print the result
  movsd xmm0, [number1]
  movsd xmm1, [number2]
  mov rdi, offset f_dif
  mov rax, 3              # three floats
  call printf
                          # multiplication
  movsd xmm2, [number1]   # double precision float into xmm
  mulsd xmm2, [number2]   # multiply with xmm
                          # print the result
  mov rdi, offset f_mul
  movsd xmm0, [number1]
  movsd xmm1, [number2]
  mov rax, 3              # three floats
  call printf
                          # division
  movsd xmm2, [number1]   # double precision float into xmm
  divsd xmm2, [number2]   # divide xmm0
                          # print the result
  mov rdi, offset f_div
  movsd xmm0, [number1]
  movsd xmm1, [number2]
  mov rax, 1              # one float
  call printf
                          # squareroot
  sqrtsd xmm1, [number1]  # squareroot double precision in xmm
                          # print the result
  mov rdi, offset f_sqrt
  movsd xmm0, [number1]
  mov rax, 2              # two floats
  call printf
                          # exit
  mov rsp, rbp
  pop rbp                 # undo the push at the beginning
  ret
