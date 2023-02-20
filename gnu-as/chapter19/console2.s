# console2.s

.intel_syntax noprefix

.data
  msg1:     .asciz "Hello, World!\n"
  msg2:     .asciz "Your turn (only a-z): "
  msg3:     .asciz "You answered: "
  inputlen  = 10 # length of inputbuffer
  NL:       .byte '\n'

  .inputchar: .byte 1


.bss
  .lcomm input, inputlen+1 # provide space for ending 0


.text

.global main

main:
  push rbp
  mov rbp, rsp
  mov rdi, offset msg1  # print first string
  call prints
  mov rdi, offset msg2  # print second string, no NL
  call prints
  mov rdi, offset input # address of inputbuffer
  mov rsi, inputlen     # length of inputbuffer
  call reads            # wait for input
  mov rdi, offset msg3  # print third string and add the input string
  call prints
  mov rdi, offset input # print the inputbuffer
  call prints
  mov rdi, offset NL    # print NL
  call prints
  leave
  ret

# ----------------------------------------------------------
prints:
  push rbp
  mov rbp, rsp
  push r12      # callee saved
                # Count characters
  xor rdx, rdx  # length in rdx
  mov r12, rdi

.lengthloop:
  cmp byte ptr [r12], 0
  je .lengthfound
  inc rdx
  inc r12
  jmp .lengthloop

.lengthfound:   # print the string, length in rdx
  cmp rdx, 0    # no string (0 length)
  je .done
  mov rsi, rdi  # rdi contains address of string
  mov rax, 1    # 1 = write
  mov rdi, 1    # 1 = stdout
  syscall

.done:
  pop r12
  leave
  ret

# ----------------------------------------------------------
reads:
  push rbp
  mov rbp, rsp
  push r12      # callee saved
  push r13      # callee saved
  push r14      # callee saved
  mov r12, rdi  # address of inputbuffer
  mov r13, rsi  # max length in r13
  xor r14, r14  # character counter

.readc:
  mov rax, 0              # read
  mov rdi, 1              # stdin
  lea rsi, [.inputchar]   # address of input
  mov rdx, 1              # # of characters to read
  syscall
  mov al, [.inputchar]    # char is NL?
  cmp al, byte ptr [NL]
  je .readc_done          # NL end
  cmp al, 97              # lower than a?
  jl .readc               # ignore it
  cmp al, 122             # higher than z?
  jg .readc               # ignore it
  inc r14                 # inc counter
  cmp r14, r13
  ja .readc               # buffer max reached, ignore
  mov byte ptr [r12], al  # save the char in the buffer
  inc r12                 # point to next char in buffer
  jmp .readc

.readc_done:
  inc r12
  mov byte ptr [r12], 0   # add end 0 to inputbuffer
  pop r14                 # callee saved
  pop r13                 # callee saved
  pop r12                 # callee saved
  leave
  ret
