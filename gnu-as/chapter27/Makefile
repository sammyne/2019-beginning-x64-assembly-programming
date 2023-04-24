
app = mxcsr

.PHONY: all
all: $(app)

$(app): mxcsr.asm.o print_hex.o print_mxcsr.o
	gcc -o $@.out $^ -no-pie
	- ./$@.out

mxcsr.asm.o: mxcsr.s
	as -a=$@.lst -g --gdwarf-5 -o $@ $^

%.o: %.c
	gcc -c -o $@ $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
