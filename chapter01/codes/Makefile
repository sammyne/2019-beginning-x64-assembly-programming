
.PHONY: all
all: hello

hello: hello.out
	@./$^

hello.out: hello.o
	# '-no-pie' disables such behavior: the recent GCC linker and compiler generate position-independent executables
	#   (PIEs) by default to prevent hacking.
	# gcc is used to ease accessing C standard library functions from within assembler code.
	@gcc -o $@ $^ -no-pie

hello.o: hello.asm
	# '-f' specify the output format elf64 (a.k.a. Executable and Linkable Format for 64-bit)
	# '-g' means include debug information in a debug format specified after the -F option
	# '-F' specify debug format as dwarf (a.k.a. Debug With Arbitrary Record Format), other format is
	#      STABS (a.k.a. Symbol Table Strings)
	# '-l' NASM to generate a .lst file helping debugging
	@nasm -f elf64 -g -F dwarf $^ -l hello.lst

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
