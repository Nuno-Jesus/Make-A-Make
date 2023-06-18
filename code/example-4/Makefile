all: lib.a this.example

lib.a: hello.o bye.o highfive.o
	echo $@ # Prints "lib.a"
	echo $< # Prints "hello.o"
	echo $^ # Prints "hello.o bye.o highfive.o"
	ar -rcs lib.a $^

%.example:
	echo $* # Prints "this"

%.o: %.c
	cc -c $<

clean:
	rm -rf hello.o bye.o highfive.o

fclean: clean
	rm -rf lib.a

re: fclean
	$(MAKE) all

.SILENT: