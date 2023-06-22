CC      = cc
CFLAGS	= -Wall -Werror -Wextra
RM      = rm -rf
NAME	= project
OBJS	= hello.o

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) main.c $(OBJS) -o $(NAME)

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all