# function6.s

.intel_syntax noprefix

.extern printf

.data

first:   .ascii "A"
second:  .ascii "B"
third:   .ascii "C"
fourth:  .ascii "D"
fifth:   .ascii "E"
sixth:   .ascii "F"
seventh: .ascii "G"
eighth:  .ascii "H"
ninth:   .ascii "I"
tenth:   .ascii "J"
fmt:     .asciz "The string is: %s\n"


.bss

.lcomm flist 11   # length of string + terminating 0


.text


.global main

main:
  push rbp
  mov rbp, rsp
  mov rdi, offset flist  # length
  mov rsi, offset first  # fill the registers
  mov rdx, offset second
  mov rcx, offset third
  mov r8,  offset fourth
  mov r9,  offset fifth
  push offset tenth      # now start pushing in
  push offset ninth      # reverse order
  push offset eighth
  push offset seventh
  push offset sixth
  call lfunc      # call the function
                  # print the result
  mov rdi, offset fmt
  mov rsi, offset flist
  mov rax, 0
  call printf
  leave
  ret

#-----------------------------------------------
lfunc:
  push rbp
  mov rbp, rsp
  xor rax, rax             # clear rax (especially higher bits)
  mov al, byte ptr [rsi]      # move content 1st argument to al
  mov [rdi], al           # store al to memory
  mov al, byte ptr [rdx]      # move content 2nd argument to al
  mov [rdi+1], al         # store al to memory
  mov al, byte ptr [rcx]      # etc for the other arguments
  mov [rdi+2], al
  mov al, byte ptr [r8]
  mov [rdi+3], al
  mov al, byte ptr [r9]
  mov [rdi+4], al
                              # now fetch the arguments from the stack
  push rbx                    # callee saved
  xor rbx, rbx
  mov rax, qword ptr [rbp+16] # first value: initial stack: + rip + rbp
                              # 'qword ptr' seems to be optional
                              # 'qword' will trigger undefined behavior
  mov bl, byte ptr [rax]      # extract the character
  mov [rdi+5], bl             # store the character to memory
  mov rax, qword ptr [rbp+24] # continue with next value
  mov bl, byte ptr [rax]
  mov [rdi+6], bl
  mov rax, qword ptr [rbp+32]
  mov bl, byte ptr [rax]
  mov [rdi+7], bl
  mov rax, qword ptr [rbp+40]
  mov bl, byte ptr [rax]
  mov [rdi+8], bl
  mov rax, qword ptr [rbp+48]
  mov bl, byte ptr [rax]
  mov [rdi+9], bl
  mov bl, 0
  mov [rdi+10], bl
  pop rbx                 # callee saved
  mov rsp, rbp
  pop rbp
  ret
