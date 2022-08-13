
srcs = $(shell find $(SRCDIR) -name "*.c")

apps = $(srcs:./%.c=%)

.PHONY: all
all: $(apps)

$(apps): %: %.c
	gcc -o $@.out $^ -masm=intel -no-pie
	./$@.out

.PHONY: clean
clean:
	rm -f *.out
