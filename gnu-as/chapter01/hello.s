.intel_syntax noprefix

.data

msg: .asciz "hello, world"


.bss

.global main

.text

main: 
  mov rax, 1    # 1 = write
  mov rdi, 1    # 1 = to stdout
  mov rsi, offset msg   # string to display in rsi,
                        # ref: https://stackoverflow.com/questions/51543818/att-syntax-hello-world-works-but-intel-syntax-does-not
  mov rdx, 12           # length of the string, without 0
  syscall       # display the string
  mov rax, 60   # 60 = exit
  mov rdi, 0    # 0 = success exit code
  syscall       # quit
