# jump.s
.intel_syntax noprefix

.extern printf

.data

number1:  .quad   42
number2:  .quad   41
fmt1:     .asciz  "NUMBER1 > = NUMBER2\n"
fmt2:     .asciz  "NUMBER1 < NUMBER2"


.bss


.text

.global main

main:
  push rbp
  mov rbp, rsp
  mov rax, [number1]  # move the numbers into registers
  mov rbx, [number2]
  cmp rax, rbx        # compare rax and rbx
  jge greater         # rax greater or equal go to greater:
  mov rdi, offset fmt2       # rax is smaller, continue here
  mov rax, 0          # no xmm involved
  call printf         # display fmt2
  jmp exit            # jump to label exit:

greater:
  mov rdi, offset fmt1       # rax is greater
  mov rax, 0          # no xmm involved
  call printf         # display fmt1

exit:
  mov rsp, rbp
  pop rbp
  ret
