# alive.s
.intel_syntax noprefix

.data

msg1:   .asciz "Hello, World!\n"      # string with NL and 0
msg1Len = . - msg1 - 1                # measure the length, minus the 0
msg2:   .asciz "Alive and Kicking!\n" # string with NL and 0
msg2Len = . - msg2 - 1                # measure the length, minus the 0
radius: .quad 357                     # no string, not displayable?
pi:     .double 3.14                  # no string, not displayable?


.bss


.text

.global main

main:
  push rbp              # function prologue
  mov rbp, rsp          # function prologue
  mov rax, 1            # 1 = write
  mov rdi, 1            # 1 = to stdout
  mov rsi, offset msg1  # string to display
  mov rdx, msg1Len      # length of the string
  syscall               # display the string
  mov rax, 1            # 1 = write
  mov rdi, 1            # 1 = to stdout
  mov rsi, offset msg2  # string to display
  mov rdx, msg2Len      # length of the string
  syscall               # display the string
  mov rsp, rbp          # function epilogue
  pop rbp               # function epilogue
  mov rax, 60           # 60 = exit
  mov rdi, 0            # 0 = success exit code
  syscall               # quit
