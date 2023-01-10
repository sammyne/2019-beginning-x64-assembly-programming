# makefile for $(app) and printb

app=bits3

.PHONY: all
all: $(app)

$(app): $(app).o printb.o
	gcc -g -o $@.out $^ -no-pie
	- ./$@.out

$(app).o: $(app).s
	as -a=$@.lst -g --gdwarf-5 -o $@ $^

printb.o: printb.c
	gcc -c $^

.PHONY: clean
clean:
	rm -f *.lst *.o *.out
