# makefile for bits1 and printb

#.PHONY: all
#all: bits1
#
#bits1: bits1.o printb.o
#	gcc -g -o $@.out $^ -no-pie
#	- ./$@.out
#
#bits1.o: bits1.s
#	as -a=$@.lst -g --gdwarf-5 -o $@ $^
#
#printb.o: printb.c
#	gcc -c $^
#
#.PHONY: clean
#clean:
#	rm -f *.lst *.o *.out

srcs = $(shell find $(SRCDIR) -name "*.s")

apps = $(srcs:./%.s=%)

.PHONY: all
all: $(apps)

$(apps): %: %.s print16b.o
	@echo ""
	@as -a=$@.lst -g --gdwarf-5 -o $@.o $<
	@gcc -gdwarf -o $@.out -no-pie $@.o print16b.o
	- ./$@.out

print16b.o: print16b.c
	@gcc -c $^

.PHONY: clean
clean:
	@rm -f *.lst *.o *.out