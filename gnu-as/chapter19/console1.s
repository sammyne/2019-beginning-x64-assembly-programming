# console1.s

.intel_syntax noprefix

.data
  msg1:      .asciz "Hello, World!\n"
  msg1len  = . - msg1
  msg2:      .asciz "Your turn: "
  msg2len  = . - msg2
  msg3:      .asciz "You answered: "
  msg3len  = . - msg3
  inputlen = 10      # length of inputbuffer


.bss
  .lcomm input, inputlen+1 # provide space for ending 0


.text

.global main

main:
  push rbp
  mov rbp, rsp
  mov rsi, offset msg1  # print first string
  mov rdx, msg1len
  call prints
  mov rsi, offset msg2  # print second string, no NL
  mov rdx, msg2len
  call prints
  mov rsi, offset input # address of inputbuffer
  mov rdx, inputlen     # length of inputbuffer
  call reads            # wait for input
  mov rsi, offset msg3  # print third string
  mov rdx, msg3len
  call prints
  mov rsi, offset input # print the inputbuffer
  mov rdx, inputlen     # length of inputbuffer
  call prints
  leave
  ret

# ----------------------------------------------------
prints:
  push rbp
  mov rbp, rsp
              # rsi contains address of string
              # rdx contains length of string
  mov rax, 1  # 1 = write
  mov rdi, 1  # 1 = stdout
  syscall
  leave
  ret

# ----------------------------------------------------
reads:
  push rbp
  mov rbp, rsp
              # rsi contains address of the inputbuffer
              # rdi contains length of the inputbuffer
  mov rax, 0  # 0 = read
  mov rdi, 1  # 1 = stdin
  syscall
  leave
  ret
