# hello3.s
.intel_syntax noprefix

.data

msg: .asciz "hello, world\n"


.bss


.global main


.text

main:
	mov rax, 1 					# 1 = write
	mov rdi, 1 					# 1 = to stdout
	mov rsi, offset msg	# string to display
	mov rdx, 13 				# length of string, without 0
	syscall 						# display the string
	mov rax, 60					# 60 = exit
	mov rdi, 0 					# 0 = success exit code
	syscall 						# quit
