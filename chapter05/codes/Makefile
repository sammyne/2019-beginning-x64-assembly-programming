
apps = move

.PHONY: all
all: $(apps)

# Static Pattern Rules by GNU make
# @todo: figure out why this causes circular dependency
$(apps): %: %.out
	@echo "--- $@"
	@echo "running $^"
# ./$^

%.out: %.o
	@gcc -o $@ $^ -no-pie

%.o: %.asm
	@nasm -f elf64 -g -F dwarf $^ -l $(app).lst

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
