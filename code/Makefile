# all: hello.o highfive.o bye.o
# 	cc main.c hello.o highfive.o bye.o

# hello.o: hello.c
# 		cc -c hello.c

# bye.o: bye.c
# 		cc -c bye.c

# highfive.o: highfive.c
# 		cc -c highfive.c

# clean:
# 	rm -f a.out hello.o highfive.o bye.o

OBJS := hello.o highfive.o bye.o

all: $(OBJS)
	cc main.c $(OBJS)

%.o: %.c
	cc -c $<

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f a.out
