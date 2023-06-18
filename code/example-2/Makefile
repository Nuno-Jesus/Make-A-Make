all: hello.o bye.o highfive.o
	cc main.c hello.o bye.o highfive.o

hello.o: hello.c
	cc -c hello.c

bye.o: bye.c
	cc -c bye.c

highfive.o: highfive.c
	cc -c highfive.c

clean:
	rm -rf hello.o bye.o highfive.o

fclean: clean
	rm -rf a.out

re: fclean
	$(MAKE) all