# cpu.s

  .intel_syntax noprefix

  .extern printf

  .data
fmt_no_sse:
  .asciz "This cpu does not support SSE\n"
fmt_sse42:
  .asciz "This cpu supports SSE 4.2\n"
fmt_sse41:
  .asciz "This cpu supports SSE 4.1\n"
fmt_ssse3:
  .asciz "This cpu supports SSSE 3\n"
fmt_sse3:
  .asciz "This cpu supports SSE 3\n"
fmt_sse2:
  .asciz "This cpu supports SSE 2\n"
fmt_sse:
  .asciz "This cpu supports SSE\n"

  .bss

  .text

  .global main
main:
  push rbp
  mov rbp, rsp
  call cpu_sse # returns 1 in rax if sse support, otherwise 0
  leave
  ret

cpu_sse:
  push rbp
  mov rbp, rsp
  xor r12, r12        # flag SSE available
  mov eax, 1          # request CPU feature flags
  cpuid
                      # test for SSE
  test edx, 0x2000000 # test bit 25 (SSE)
  jz sse2             # SSE available
  mov r12, 1
  xor rax, rax
  mov rdi, offset fmt_sse
  push rcx            # modified by printf
  push rdx            # preserve result of cpuid
  call printf
  pop rdx
  pop rcx

sse2:
  test edx, 0x4000000 # test bit 26 (SSE 2)
  jz sse3             # SSE 2 available
  mov r12, 1
  xor rax, rax
  mov rdi, offset fmt_sse2
  push rcx            # modified by printf
  push rdx            # preserve result of cpuid
  call printf
  pop rdx
  pop rcx

sse3:
  test ecx, 1         # test bit 0 (SSE 3)
  jz ssse3            # SSE 3 available
  mov r12, 1
  xor rax, rax
  mov rdi, offset fmt_sse3
  push rcx            # modified by printf
  call printf
  pop rcx

ssse3:
  test ecx, 0x9       # test bit 0 (SSE 3)
  jz sse41            # SSE 3 available
  mov r12, 1
  xor rax, rax
  mov rdi, offset fmt_ssse3
  push rcx            # modified by printf
  call printf
  pop rcx

sse41:
  test ecx, 0x80000   # test bit 19 (SSE 4.1)
  jz sse42            # SSE 4.1 available
  mov r12, 1
  xor rax, rax
  mov rdi, offset fmt_sse41
  push rcx            # modified by printf
  call printf
  pop rcx

sse42:
  test ecx, 0x100000  # test bit 20 (SSE 4.2)
  jz wrapup           # SSE 4.2 available
  mov r12, 1
  xor rax, rax
  mov rdi, offset fmt_sse42
  push rcx            # modified by printf
  call printf
  pop rcx

wrapup:
  cmp r12, 1
  je sse_ok
  mov rdi, offset fmt_no_sse
  xor rax, rax
  call printf         # displays message if SSE not available
  jmp the_exit

sse_ok:
  mov rax, r12        # returns 1, sse supported

the_exit:
  leave
  ret
