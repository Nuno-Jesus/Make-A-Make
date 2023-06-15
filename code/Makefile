# hello.o: hello.c
# 	cc -c hello.c

# all: hello.o
# 	cc main.c hello.o

# clean:
# 	rm -rf hello.o

# fclean: clean
# 	rm -rf a.out

# re: fclean all

OBJS := hello.o highfive.o bye.o

all: $(OBJS)
	cc main.c $(OBJS)

%.o: %.c
	cc -c $<

clean:
	rm -f $(OBJS)

fclean: clean
	rm -f a.out
