
app = bits3

.PHONY: all
all: $(app)

$(app): $(app).out
	- ./$<

$(app).out: $(app).o printb.o
	gcc -g -o $@ $^ -no-pie

$(app).o: $(app).asm
	nasm -f elf64 -g -F dwarf $^ -l $(app).lst

printb.o: printb.c
	gcc -c $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
