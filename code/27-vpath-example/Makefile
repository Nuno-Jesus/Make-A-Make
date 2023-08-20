###################### Compilation ######################

CC      	= cc
CFLAGS		= -Wall -Werror -Wextra

######################## Commands #######################

RM = rm -rf

######################### Files #########################

SOURCES = nc_strlen nc_strncmp nc_substr
SOURCES += nc_clamp nc_count nc_free nc_numlen
SOURCES += main

OBJS = $(addsuffix .o, $(SOURCES))
NAME = a.out

vpath nc_%.c nc_str nc_utils

######################## Rules #########################

all: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $(NAME)

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all
