
asm_srcs = $(shell find $(SRCDIR) -name "*.s")

asm_objs = $(asm_srcs:./%.s=%.o)

app = fromc

.PHONY: all
all: $(app)

$(app): fromc.c $(asm_objs)
	gcc -gdwarf -o $@.out $^ -no-pie
	- ./$@.out

$(asm_objs): %.o: %.s
	as -a=$<.lst -g --gdwarf-5 -o $@ $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
