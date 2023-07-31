####################### Compilation ######################
CC      	= cc
CFLAGS		= -Wall -Werror -Wextra

######################## Commands #######################
RM = rm -rf

######################### Files #########################
NAME = a.out
OBJS = main.o

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

#Try to eliminate main.d from teste folder and run make again
include main.d

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all