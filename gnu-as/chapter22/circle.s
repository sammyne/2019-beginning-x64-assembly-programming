# circle.s

  .intel_syntax noprefix

  .data
pi:
  .double 3.141592654

  .bss

  .text

  .global carea
carea:
  push rbp
  mov rbp, rsp
  movsd xmm1, qword ptr [pi]
  mulsd xmm0, xmm0        # radius in xmm0
  mulsd xmm0, xmm1
  leave
  ret

  .global ccircum
ccircum:
  push rbp
  mov rbp, rsp
  movsd xmm1, qword ptr [pi]
  addsd xmm0, xmm0      # radius in xmm0
  mulsd xmm0, xmm1
  leave
  ret
