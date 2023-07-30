##################### Compilation Variables #####################
CC      	= cc
CFLAGS		= -Wall -Werror -Wextra
CPPFLAGS	= -MMD

######################## Commands Variables #######################
RM      	= rm -rf

######################## Files Variables #######################
NAME		= a.out
OBJS		= main.o

all: $(NAME)

$(NAME): $(OBJS) header.h
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJS) -o $(NAME)

clean:
	$(RM) $(OBJS) $(OBJS:.o=.d)

fclean: clean
	$(RM) $(NAME) $(NAME).d

re: fclean
	$(MAKE) all