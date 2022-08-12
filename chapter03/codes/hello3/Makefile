
app = hello3

.PHONY: all
all: run

run: $(app).out
	@./$^

$(app).out: $(app).o
	@gcc -o $@ $^ -no-pie

$(app).o: $(app).asm
	@nasm -f elf64 -g -F dwarf $^ -l $(app).lst

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
