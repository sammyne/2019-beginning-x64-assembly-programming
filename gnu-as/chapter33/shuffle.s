# shuffle.s

  .intel_syntax noprefix

  .extern printf

  .data
fmt0:
  .asciz "These are the numbers in memory: \n"
fmt00:
  .asciz "This is xmm0: \n"
fmt1:
  .asciz "%d "
fmt2:
  .asciz "Shuffle-broadcast double word %i:\n"
fmt3:
  .asciz "%d %d %d %d\n"
fmt4:
  .asciz "Shuffle-reverse double words:\n"
fmt5:
  .asciz "Shuffle-reverse packed bytes in xmm0:\n"
fmt6:
  .asciz "Shuffle-rotate left:\n"
fmt7:
  .asciz "Shuffle-rotate right:\n"
fmt8:
  .asciz "%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c\n"
fmt9:
  .asciz "Packed bytes in xmm0:\n"
NL:
  .asciz "\n" 
number1:
  .int 1
number2:
  .int 2
number3:
  .int 3
number4:
  .int 4
char:
  .ascii "abcdefghijklmnop"
bytereverse:
  .byte 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0

  .bss

  .text

  .global main
main:
  push rbp
  mov rbp, rsp
  sub rsp, 32   # stackspace for the original xmm0
                # and for the modified xmm0
  # SHUFFLING DOUBLE WORDS
  # first print the numbers in reverse
  mov rdi, offset fmt0
  call printf
  mov rdi, offset fmt1
  mov rsi, [number4]
  xor rax, rax
  call printf
  mov rdi, offset fmt1
  mov rsi, [number3]
  xor rax, rax
  call printf
  mov rdi, offset fmt1
  mov rsi, [number2]
  xor rax, rax
  call printf
  mov rdi, offset fmt1
  mov rsi, [number1]
  xor rax, rax
  call printf
  mov rdi, offset NL
  call printf
  # build xmm0 with the numbers
  pxor xmm0, xmm0
  pinsrd xmm0, dword ptr [number1], 0
  pinsrd xmm0, dword ptr [number2], 1
  pinsrd xmm0, dword ptr [number3], 2
  pinsrd xmm0, dword ptr [number4], 3
  movdqu [rbp-16], xmm0         # save xmm0 for later use
  mov rdi, offset fmt00
  call printf                   # print title
  movdqu xmm0, [rbp-16]         # restore xmm0 after printf
  call print_xmm0d              # print xmm0
  movdqu xmm0, [rbp-16]         # restore xmm0 after printf
  # SHUFFLE-BROADCAST
  # shuffle: broadcast least significant dword (index 0)
  movdqu xmm0, [rbp-16]         # restore xmm0
  pshufd xmm0, xmm0, 0b00000000 # shuffle
  mov rdi, offset fmt2
  mov rsi, 0                    # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # shuffle: broadcast dword index 1
  movdqu xmm0, [rbp-16]         # restore xmm0
  pshufd xmm0, xmm0, 0b01010101 # shuffle
  mov rdi, offset fmt2
  mov rsi, 1                    # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # shuffle: broadcast dword index 2
  movdqu xmm0, [rbp-16]         # restore xmm0
  pshufd xmm0, xmm0, 0b10101010 # shuffle
  mov rdi, offset fmt2
  mov rsi, 2                    # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # shuffle: broadcast dword index 3
  movdqu xmm0, [rbp-16]         # restore xmm0
  pshufd xmm0, xmm0, 0b11111111 # shuffle
  mov rdi, offset fmt2
  mov rsi, 3                    # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # SHUFFLE-REVERSE
  # reverse double words
  movdqu xmm0, [rbp-16]         # restore xmm0
  pshufd xmm0, xmm0, 0b00011011 # shuffle
  mov rdi, offset fmt4          # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # SHUFFLE-ROTATE
  # rotate left
  movdqu xmm0, [rbp-16]         # restore xmm0
  pshufd xmm0, xmm0, 0b10010011 # shuffle
  mov rdi, offset fmt6          # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0,[rbp-32]          # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # rotate right
  movdqu xmm0,[rbp-16]          # restore xmm0
  pshufd xmm0, xmm0, 0b00111001 # shuffle
  mov rdi, offset fmt7          # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0d              # print the content of xmm0
  # SHUFFLING BYTES
  mov rdi, offset fmt9
  call printf                   # print title
  movdqu xmm0, [char]           # load the character in xmm0
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call print_xmm0b              # print the bytes in xmm0
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  movdqu xmm1, [bytereverse]    # load the mask
  pshufb xmm0, xmm1             # shuffle bytes
  mov rdi, offset fmt5          # print title
  movdqu [rbp-32], xmm0         # printf destroys xmm0
  call printf
  movdqu xmm0, [rbp-32]         # restore xmm0 after printf
  call print_xmm0b              # print the content of xmm0
  leave
  ret

# function to print double words--------------------
print_xmm0d:
  push rbp
  mov rbp, rsp
  mov rdi, offset fmt3
  xor rax, rax
  pextrd esi, xmm0, 3   # extract the double words
  pextrd edx, xmm0, 2   # in reverse, little endian
  pextrd ecx, xmm0, 1
  pextrd r8d, xmm0, 0
  call printf
  leave
  ret

#function to print bytes---------------------------
print_xmm0b:
  push rbp
  mov rbp, rsp
  mov rdi, offset fmt8
  xor rax, rax
  pextrb esi, xmm0, 0   # in reverse, little endian
  pextrb edx, xmm0, 1   # use registers first and
  pextrb ecx, xmm0, 2   # then the stack
  pextrb r8d, xmm0, 3
  pextrb r9d, xmm0, 4
  pextrb eax, xmm0, 15
  push rax
  pextrb eax, xmm0, 14
  push rax
  pextrb eax, xmm0, 13
  push rax
  pextrb eax, xmm0, 12
  push rax
  pextrb eax, xmm0, 11
  push rax
  pextrb eax, xmm0, 10
  push rax
  pextrb eax, xmm0, 9
  push rax
  pextrb eax, xmm0, 8
  push rax
  pextrb eax, xmm0, 7
  push rax
  pextrb eax, xmm0, 6
  push rax
  pextrb eax, xmm0, 5
  push rax
  xor rax, rax
  call printf
  leave
  ret
