# bits3.s

.intel_syntax noprefix

.extern printb
.extern printf

.data
  msg1:      .asciz "No bits are set:\n"
  msg2:      .asciz "\nSet bit #4, that is the 5th bit:\n"
  msg3:      .asciz "\nSet bit #7, that is the 8th bit:\n"
  msg4:      .asciz "\nSet bit #8, that is the 9th bit:\n"
  msg5:      .asciz "\nSet bit #61, that is the 62nd bit:\n"
  msg6:      .asciz "\nClear bit #8, that is the 9th bit:\n"
  msg7:      .asciz "\nTest bit #61, and display rdi\n"
  bitflags:  .quad 0


.bss


.text


.global main

main:
  push rbp
  mov rbp, rsp
  # print title
  mov rdi, offset msg1
  xor rax, rax
  call printf
  # print bitflags
  mov rdi, [bitflags]
  call printb
  # set bit 4 (=5th bit)
  # print title
  mov rdi, offset msg2
  xor rax,rax
  call printf
  bts qword ptr [bitflags], 4 # set bit 4
  # print bitflags
  mov rdi, [bitflags]
  call printb
  # set bit 7 (=8th bit)
  # print title
  mov rdi, offset msg3
  xor rax,rax
  call printf
  bts qword ptr [bitflags], 7 # set bit 7
  # print bitflags
  mov rdi, [bitflags]
  call printb
  # set bit 8 (=9th bit)
  # print title
  mov rdi, offset msg4
  xor rax,rax
  call printf
  bts qword ptr [bitflags], 8 # set bit 8
  # print bitflags
  mov rdi, [bitflags]
  call printb
  # set bit 61 (=62nd bit)
  # print title
  mov rdi, offset msg5
  xor rax, rax
  call printf
  bts qword ptr [bitflags], 61 # set bit 61
  # print bitflags
  mov rdi, [bitflags]
  call printb
  # clear bit 8 (=9th bit)
  # print title
  mov rdi, offset msg6
  xor rax, rax
  call printf
  btr qword ptr [bitflags], 8 # bit reset 8
  # print bitflags
  mov rdi, [bitflags]
  call printb
  # test bit 61 (will set carry flag CF if 1)
  # print title
  mov rdi, offset msg7
  xor rax, rax
  call printf
  xor rdi, rdi
  mov rax, 61        # bit 61 to be tested
  xor rdi, rdi       # make sure all bits are 0
  bt [bitflags], rax # bit test
  setc dil           # set dil (=low rdi) to 1 if CF is set
  call printb        # display rdi
  leave
  ret
