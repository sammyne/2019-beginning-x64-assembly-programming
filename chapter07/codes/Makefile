
apps = jump

.PHONY: all
all: $(apps)

$(apps): %: %.asm
	@echo "build then run $@"
	nasm -f elf64 -g -F dwarf $^ -l $@.lst
	gcc -o $@.out $@.o -no-pie
	- ./$@.out

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
