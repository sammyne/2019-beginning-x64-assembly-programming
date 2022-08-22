# move.s
.intel_syntax noprefix

.data

bNum:  .byte 123
wNum:  .word 12345
dNum:  .int 1234567890
qNum1: .quad 1234567890123456789
qNum2: .quad 123456
qNum3: .double 3.14


.bss


.text

.global main

main:
  push rbp
  mov rbp, rsp
  mov rax, -1         # fill rax with 1s
  mov al, [bNum]      # does NOT clear upper bits of rax
  xor rax, rax        # clear rax
  mov al, [bNum]      # now rax has the correct value
  mov rax, -1         # fill rax with 1s
  mov ax, [wNum]      # does NOT clear upper bits of rax
  xor rax, rax        # clear rax
  mov ax, [wNum]      # now rax has the correct value
  mov rax, -1         # fill rax with 1s
  mov eax, [dNum]     # does clear upper bits of rax
  mov rax, -1         # fill rax with 1s
  mov rax, [qNum1]    # does clear upper bits of rax
  mov [qNum2], rax    # one operand always a register
  mov rax, 123456     # source operand an immediate value
  movq xmm0, [qNum3]  # instruction for floating point
  mov rsp, rbp
  pop rbp
                      # it seems al is used as exit code
  ret
