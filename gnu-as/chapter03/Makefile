
srcs = $(shell find $(SRCDIR) -name "*.s")

apps = $(srcs:./%.s=%)

.PHONY: all
all: $(apps)

$(apps): %: %.s
	as -a=$@.lst -g --gdwarf-5 -o $@.o $^
	gcc -gdwarf -o $@.out -no-pie $@.o
	./$@.out

.PHONY: clean
clean:
	rm -f *.lst *.o *.out