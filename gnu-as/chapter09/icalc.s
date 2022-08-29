# icalc.s

.intel_syntax noprefix

.extern printf

.data

number1: .quad 128                                  # the numbers to be used to
number2: .quad 19                                   # show the arithmetic
neg_num: .quad -12                                  # to show sign extension
fmt:     .asciz "The numbers are %ld and %ld\n"
fmtint:  .asciz "%s %ld\n"
sumi:    .asciz "The sum is"
difi:    .asciz "The difference is"
inci:    .asciz "Number 1 Incremented:"
deci:    .asciz "Number 1 Decremented:"
sali:    .asciz "Number 1 Shift left 2 (x4):"
sari:    .asciz "Number 1 Shift right 2 (/4):"
sariex:  .ascii "Number 1 Shift right 2 (/4) with "
         .asciz "sign extension:"
multi:   .asciz "The product is"
divi:    .asciz "The integer quotient is"
remi:    .asciz "The modulo is"


.bss

.lcomm resulti, 8 # a quad word
.lcomm modulo, 8  # a quad word 


.text

.global main

main:
  push rbp
  mov rbp, rsp
  # displaying the numbers
  mov rdi, offset fmt
  mov rsi, [number1]
  mov rdx, [number2]
  mov rax, 0
  call printf
  # adding------------------------------------------------------------
  mov rax, [number1]
  add rax, [number2] # add number2 to rax
  mov [resulti], rax # move sum to result
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset sumi
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # substracting------------------------------------------------------
  mov rax, [number1]
  sub rax, [number2] # subtract number2 from rax
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset difi
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # incrementing------------------------------------------------------
  mov rax, [number1]
  inc rax             # increment rax with 1
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset inci
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # decrementing------------------------------------------------------
  mov rax, [number1]
  dec rax # decrement rax with 1
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset deci
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # shift arithmetic left---------------------------------------------
  mov rax, [number1]
  sal rax, 2 # multiply rax by 4
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset sali
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # shift arithmetic right--------------------------------------------
  mov rax, [number1]
  sar rax, 2 # divide rax by 4
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset sari
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # shift arithmetic right with sign extension -----------------------
  mov rax, [neg_num]
  sar rax, 2 # divide rax by 4
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset sariex
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # multiply----------------------------------------------------------
  mov rax, [number1]
  imul rax, [number2] # multiply rax with number2
  mov [resulti], rax
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset multi
  mov rdx, [resulti]
  mov rax, 0
  call printf
  # divide------------------------------------------------------------
  mov rax, [number1]
  mov rdx, 0 # rdx needs to be 0 before idiv
  idiv rax, [number2] # divide rax by number2, modulo in rdx
  mov [resulti], rax
  mov [modulo], rdx # rdx to modulo
  # displaying the result
  mov rdi, offset fmtint
  mov rsi, offset divi
  mov rdx, [resulti]
  mov rax, 0
  call printf
  mov rdi, offset fmtint
  mov rsi, offset remi
  mov rdx, [modulo]
  mov rax, 0
  call printf
  mov rsp, rbp
  pop rbp
  ret
