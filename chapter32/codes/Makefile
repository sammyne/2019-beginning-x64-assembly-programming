
srcs = $(shell find $(SRCDIR) -name "*.asm")

apps = $(srcs:./%.asm=%)

.PHONY: all
all: $(apps)

$(apps): %: %.asm
	@echo ""
	@nasm -f elf64 -g -F dwarf $^ -l $@.lst
	@gcc -g -o $@.out $@.o -no-pie
	- ./$@.out

.PHONY: clean
clean:
	@rm -f *.lst *.o *.out
