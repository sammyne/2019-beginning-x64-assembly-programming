
.PHONY: all
all: run

run: hello.out
	@./$^

hello.out: hello.o
	@gcc -o $@ $^ -no-pie

hello.o: hello.asm
	@nasm -f elf64 -g -F dwarf $^ -l hello.lst

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
