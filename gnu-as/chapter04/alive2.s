# alive2.asm

.intel_syntax noprefix

.data
msg1:   .asciz "Hello, World!"
msg2:   .asciz "Alive and Kicking!"
radius: .int 357
pi:     .double 3.14
fmtstr: .asciz "%s\n"   # format for printing a string
fmtflt: .asciz  "%lf\n" # format for a float
fmtint: .asciz "%d\n"   # format for an integer


.bss


.text

.global main

main:
  push rbp
  mov rbp, rsp
                          # print msg1
  mov rax, 0              # no floating point
  mov rdi, offset fmtstr
  mov rsi, offset msg1
  call printf
                          # print msg2
  mov rax, 0              # no floating point
  mov rdi, offset fmtstr
  mov rsi, offset msg2
  call printf
                          # print radius
  mov rax, 0              # no floating point
  mov rdi, offset fmtint
  mov rsi, [radius]
  call printf
                          # print pi
  mov rax, 1              # 1 xmm register used
  movq xmm0, [pi]
  mov rdi, offset fmtflt
  call printf
  mov rsp, rbp
  pop rbp
                          # zero exit codes to fix failed 'make'
  # mov rax, 60           # 60 = exit
  # mov rdi, 0            # 0 = success exit code
  # syscall               # quit
                          # end zero exit codes to fix failed 'make' in case of rax!=0
  xor rax, rax            # zero rax to make ret equal to exit syscall with code 0.
                          # \if missing, the return code 9 (=#(char) printed) of printf will be used as exit code,
                          # rendering the program failed
  ret
