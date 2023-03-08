
srcs = $(shell find $(SRCDIR) -name "*.asm")

apps = $(srcs:./%.asm=%)

.PHONY: all
all: $(apps)

$(apps): %: %.asm
	nasm -f elf64 -g -F dwarf $^ -l $@.lst
	gcc -g -o $@.out $@.o -no-pie
	- ./$@.out hello world

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
