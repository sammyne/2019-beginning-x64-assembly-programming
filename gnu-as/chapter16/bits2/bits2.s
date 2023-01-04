# bits2.s

.intel_syntax noprefix

.extern printf

.data
  msgn1:   .asciz "Number 1 is = %d"
  msgn2:   .asciz "Number 2 is = %d"
  msg1:    .asciz "SHL 2 = OK multiply by 4"
  msg2:    .asciz "SHR 2 = WRONG divide by 4"
  msg3:    .asciz "SAL 2 = correctly multiply by 4"
  msg4:    .asciz "SAR 2 = correctly divide by 4"
  msg5:    .asciz "SHR 2 = OK divide by 4"
  number1: .quad 8
  number2: .quad -8
  result:  .quad 0

  .fmtstr0: .asciz "\n%s\n"                         # format for a string
  .fmtstr1: .asciz "The original number is %lld\n"
  .fmtstr2: .asciz "The resulting number is %lld\n"

.bss


.text


.global main

main:
  push rbp
  mov rbp, rsp
                        # SHL-------------------------------------------------
                        # positive number
  mov rsi, offset msg1
  call printmsg         # print heading
  mov rsi, [number1]
  call printnbr         # print number1
  mov rax, [number1]
  shl rax, 2            # multiply by 4 (logic)
  mov rsi, rax
  call printres
                        # negative number
  mov rsi, offset msg1
  call printmsg         # print heading
  mov rsi, [number2]
  call printnbr         # print number2
  mov rax, [number2]
  shl rax, 2            # multiply by 4 (logic)
  mov rsi, rax
  call printres
                        # SAL-------------------------------------------------
                        # positive number
  mov rsi, offset msg3
  call printmsg         # print heading
  mov rsi, [number1]
  call printnbr         # print number1
  mov rax, [number1]
  sal rax, 2            # multiply by 4 (arithmetic)
  mov rsi, rax
  call printres
  # negative number
  mov rsi, offset msg3
  call printmsg         # print heading
  mov rsi, [number2]
  call printnbr         # print number2
  mov rax, [number2]
  sal rax, 2            # multiply by 4 (arithmetic)
  mov rsi, rax
  call printres
                        # SHR-------------------------------------------------
                        # positive number
  mov rsi, offset msg5
  call printmsg         # print heading
  mov rsi, [number1]
  call printnbr         # print number1
  mov rax, [number1]
  shr rax, 2            # divide by 4 (logic)
  mov rsi, rax
  call printres
                        # negative number
  mov rsi, offset msg2
  call printmsg         # print heading
  mov rsi, [number2]
  call printnbr         # print number2
  mov rax, [number2]
  shr rax, 2            # divide by 4 (logic)
  mov [result], rax
  mov rsi, rax
  call printres
                        # SAR-------------------------------------------------
                        # positive number
  mov rsi, offset msg4
  call printmsg         # print heading
  mov rsi, [number1]
  call printnbr         # print number1
  mov rax, [number1]
  sar rax, 2            # divide by 4 (arithmetic)
  mov rsi, rax
  call printres
                        # negative number
  mov rsi, offset msg4
  call printmsg         # print heading
  mov rsi, [number2]
  call printnbr         # print number2
  mov rax, [number2]
  sar rax, 2            # divide by 4 (arithmetic)
  mov rsi, rax
  call printres
  leave
  ret

# -----------------------------------
printmsg: # print the title
  mov rdi, offset .fmtstr0
  mov rax, 0
  call printf
  ret

# -----------------------------------
printnbr: # print the number
  mov rdi, offset .fmtstr1
  mov rax, 0
  call printf
  ret

# -----------------------------------
printres: # print the result
  mov rdi, offset .fmtstr2
  mov rax, 0
  call printf
  ret
