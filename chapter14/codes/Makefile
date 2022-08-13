
apps = function4

.PHONY: all
all: $(apps)

$(apps): %: %.out
	- ./$^

function4.out: function4.o circle.o rect.o
	@gcc -g -o $@ $^ -no-pie

%.o: %.asm
	@nasm -f elf64 -g -F dwarf $^ -l $^.lst

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
