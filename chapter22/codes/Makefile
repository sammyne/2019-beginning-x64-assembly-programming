
asm_srcs = $(shell find $(SRCDIR) -name "*.asm")

asm_objs = $(asm_srcs:./%.asm=%.o)

app = fromc

.PHONY: all
all: $(app)

$(app): fromc.c $(asm_objs)
	gcc -g -o $@.out $^ -no-pie
	- ./$@.out

$(asm_objs): %.o: %.asm
	nasm -f elf64 -g -F dwarf $^ -l $@.lst

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
