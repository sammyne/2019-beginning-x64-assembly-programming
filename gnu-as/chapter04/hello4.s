# hello4.s
.intel_syntax noprefix

# extern declaration isn't unrequired
# extern printf # declare the function as external

.data

msg:    .asciz "Hello, World!"
fmtstr: .asciz "This is our string: %s\n" # printformat


.bss


.text

.global main

main:
  push rbp
  mov rbp, rsp
  mov rdi, offset fmtstr  # first argument for printf
  mov rsi, offset msg     # second argument for printf
  mov rax, 0              # no xmm registers involved
  call printf             # call the function
  mov rsp, rbp
  pop rbp
  mov rax, 60             # 60 = exit
  mov rdi, 0              # 0 = success exit code
  syscall                 # quit
