# strings.asm

  .intel_syntax noprefix

  .extern printf

  .data
string1:
  .asciz "This is the 1st string.\n"
string2:
  .asciz "This is the 2nd string.\n"
  .equ strlen2, . - string2 - 2
string21:
  .asciz "Comparing strings: The strings do not differ.\n"
string22:
  .asciz "Comparing strings: The strings differ, starting at position: %d.\n"
string3:
  .asciz "The quick brown fox jumps over the lazy dog."
  .equ strlen3, . - string3 - 2
string33:
  .asciz "Now look at this string: %s\n"
string4:
  .asciz "z"
string44:
  .asciz "The character '%s' was found at position: %d.\n"
string45:
  .asciz "The character '%s' was not found.\n"
string46:
  .asciz "Scanning for the character '%s'.\n"

  .bss

  .text

  .global main
main:
  push rbp
  mov rbp, rsp

  # print the 2 strings
  xor rax, rax
  mov rdi, offset string1
  call printf
  mov rdi, offset string2
  call printf
  # compare 2 strings -----------------------------------------------
  lea rdi, [string1]
  lea rsi, [string2]
  mov rdx, strlen2
  call compare1
  cmp rax, 0
  jnz not_equal1
  # strings are equal, print
  mov rdi, offset string21
  call printf
  jmp otherversion

# strings are not equal, print
not_equal1:
  mov rdi, offset string22
  mov rsi, rax
  xor rax, rax
  call printf

# compare 2 strings, other verstion ------------------------------
otherversion:
  lea rdi, [string1]
  lea rsi, [string2]
  mov rdx, strlen2
  call compare2
  cmp rax, 0
  jnz not_equal2
  # strings are equal, print
  mov rdi, offset string21
  call printf

  jmp scanning

# strings are not equal, print
not_equal2:
  mov rdi, offset string22
  mov rsi, rax
  xor rax, rax
  call printf
  # scan for a character in a string -------------------------------
  # first print the string
  mov rdi, offset string33
  mov rsi, offset string3
  xor rax, rax
  call printf
  # then print the search argument, can only be 1 character
  mov rdi, offset string46
  mov rsi, offset string4
  xor rax, rax
  call printf

scanning:
  lea rdi, [string3] # string
  lea rsi, [string4] # search argument
  mov rdx, strlen3
  call cscan
  cmp rax, 0
  jz char_not_found
  # character found, print
  mov rdi, offset string44
  mov rsi, offset string4
  mov rdx, rax
  xor rax, rax
  call printf
  jmp exit

# character not found, print
char_not_found:
  mov rdi, offset string45
  mov rsi, offset string4
  xor rax, rax
  call printf

exit:
  leave
  ret

# FUNCTIONS ===============================================================
# function compare 2 strings ------------------------------------
compare1:
  mov rcx, rdx
  cld

cmpr:
  cmpsb
  jne notequal
  loop cmpr
  xor rax, rax
  ret

notequal:
  mov rax, strlen2
  dec rcx             # compute position
  sub rax, rcx        # compute position
  ret

  xor rax, rax
  ret

#----------------------------------------------------------------
# function compare 2 strings ------------------------------------
compare2:
  mov rcx, rdx
  cld
  repe cmpsb        # repe stands for repeat while equal. 
                    # cmpsb compares two bytes and
                    # sets the status flag ZF to 1 if the two compared bytes are equal, or
                    # to 0 if the 2 bytes are not equal.
  je equal2
  mov rax, strlen2
  sub rax, rcx      # compute position
  ret

equal2:
  xor rax, rax
  ret

#----------------------------------------------------------------
# function scan a string for a character
cscan:
  mov rcx, rdx
  lodsb               # load the byte at address rsi into rax
  cld
  repne scasb         # repne stands for "repeat while not equal"
  jne char_notfound
  mov rax, strlen3
  sub rax, rcx        # compute position
  ret

char_notfound:
  xor rax, rax
  ret
