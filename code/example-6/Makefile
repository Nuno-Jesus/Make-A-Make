CC      = cc
CFLAGS	= -Wall -Werror -Wextra
RM      = rm -rf
NAME	= project
OBJS	= hello.o bye.o highfive.o

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) main.c $(OBJS) -o $(NAME)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all