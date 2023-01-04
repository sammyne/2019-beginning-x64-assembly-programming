# makefile for bits1 and printb

.PHONY: all
all: bits1

bits1: bits1.o printb.o
	gcc -g -o $@.out $^ -no-pie
	- ./$@.out

bits1.o: bits1.s
	as -a=$@.lst -g --gdwarf-5 -o $@ $^

printb.o: printb.c
	gcc -c $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
