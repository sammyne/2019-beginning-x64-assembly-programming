# function4.s

.intel_syntax noprefix

.extern printf
.extern c_area
.extern c_circum
.extern r_area
.extern r_circum


.global pi


.data

pi:     .double 3.141592654
radius: .double 10.0
side1:  .quad   4
side2:  .quad   5
fmtf:   .asciz  "%s %f\n"
fmti:   .asciz  "%s %d\n"
ca:     .asciz  "The circle area is "
cc:     .asciz  "The circle circumference is "
ra:     .asciz  "The rectangle area is "
rc:     .asciz  "The rectangle circumference is "


.bss


.text


.global main

main:
  push rbp
  mov rbp, rsp
                              # circle area
  movsd xmm0, qword ptr [radius]  # radius xmm0 argument
  call c_area                 # area returned in xmm0
                              # print the circle area
  mov rdi, offset fmtf
  mov rsi, offset ca
  mov rax, 1
  call printf
                              # circle circumference
  movsd xmm0, qword ptr [radius]  # radius xmm0 argument
  call c_circum               # circumference in xmm0
                              # print the circle circumference
  mov rdi, offset fmtf
  mov rsi, offset cc
  mov rax, 1
  call printf
                              # rectangle area
  mov rdi, [side1]
  mov rsi, [side2]
  call r_area                 # area returned in rax
                              # print the rectangle area
  mov rdi, offset fmti
  mov rsi, offset ra
  mov rdx, rax
  mov rax, 0
  call printf
                              # rectangle circumference
  mov rdi, [side1]
  mov rsi, [side2]
  call r_circum               # circumference in rax
                              # print the rectangle circumference
  mov rdi, offset fmti
  mov rsi, offset rc
  mov rdx, rax
  mov rax, 0
  call printf
  mov rsp, rbp
  pop rbp
  ret
