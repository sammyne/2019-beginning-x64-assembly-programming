
apps = function4

.PHONY: all
all: $(apps)

$(apps): %: %.out
	- ./$^

function4.out: function4.o circle.o rect.o
	@gcc -gdwarf -o $@ -no-pie $^

%.o: %.s
	@as -a=$@.lst -g --gdwarf-5 -o $@ $^

.PHONY: clean
clean:
	@rm -f *.out *.o *.lst
