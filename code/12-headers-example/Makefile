###################### Compilation ######################
CC      	= cc
CFLAGS		= -Wall -Werror -Wextra
CPPFLAGS	= -MMD

######################## Commands #######################
RM = rm -rf

######################### Files #########################
NAME = a.out
OBJS = main.o
DEPS = $(OBJS:.o=.d)

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJS) -o $(NAME)

-include $(DEPS)

clean:
	$(RM) $(OBJS) $(OBJS:.o=.d)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all