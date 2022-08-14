
app = string4

.PHONY: all
all: $(app)

$(app): $(app).o print16b.o
	gcc -g -o $@.out $^ -no-pie
	- ./$@.out

string4.o: string4.asm
	nasm -f elf64 -g -F dwarf $^ -l $@.lst

print16b.o: print16b.c
	gcc -c $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
