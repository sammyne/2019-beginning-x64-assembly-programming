# icalc.s

.intel_syntax noprefix

.extern printf

.data

strng:     .asciz "ABCDE"
strngLen = . - strng - 1                      # string length without 0
fmt1:      .asciz "The original string: %s\n"
fmt2:      .asciz "The reversed string: %s\n"

.bss

.text

.global main

main:
  push rbp
  mov rbp, rsp
  # Print the original string
  mov rdi, offset fmt1
  mov rsi, offset strng
  mov rax, 0
  call printf
  # push the string char per char on the stack
  xor rax, rax
  mov rbx, offset strng       # address of strng in rbx
  mov rcx, strngLen           # length in rcx counter
  mov r12, 0                  # use r12 as pointer

pushLoop:
  mov al, byte ptr [rbx+r12]  # move char into rax
  push rax                    # push rax on the stack
  inc r12                     # increase char pointer with 1
  loop pushLoop               # continue loop
  # pop the string char per char from the stack
  # this will reverse the original string
  mov rbx, offset strng       # address of strng in rbx
  mov rcx, strngLen           # length in rcx counter
  mov r12, 0                  # use r12 as pointer

popLoop:
  pop rax                     # pop a char from the stack
  mov byte ptr [rbx+r12], al  # move the char into strng
  inc r12                     # increase char pointer with 1
  loop popLoop                # continue loop
  mov byte ptr [rbx+r12], 0x0 # terminate string with 0
  # Print the reversed string
  mov rdi, offset fmt2
  mov rsi, offset strng
  mov rax, 0
  call printf
  mov rsp, rbp
  pop rbp
  ret
