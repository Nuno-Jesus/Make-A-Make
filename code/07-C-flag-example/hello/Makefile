CC      = cc
CFLAGS	= -Wall -Werror -Wextra
RM      = rm -rf
NAME	= hello.o

all: $(NAME)

$(NAME):
	$(CC) $(CFLAGS) -c hello.c -o $(NAME)

clean:
	$(RM) $(NAME)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all