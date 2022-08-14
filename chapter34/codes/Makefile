
srcs = $(shell find $(SRCDIR) -name "*.asm")

apps = $(srcs:./%.asm=%)

objects = $(apps:%=%.o)

binaries = $(apps:%=%.out)

.PHONY: all
all: $(apps)

$(apps): %: %.out
	- ./$<

$(binaries): %.out: %.o print16b.o
	gcc -g -o $@ $^ -no-pie

$(objects): %.o: %.asm
	nasm -f elf64 -g -F dwarf $^ -l $@.lst

print16b.o: print16b.c
	gcc -c $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
