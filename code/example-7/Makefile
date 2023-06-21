CC      = cc
RM      = rm -rf
NAME	= project

all:
	$(MAKE) -C hello/
	$(CC) main.c hello/hello.c

%.o: %.c
	$(CC) -c $<

clean:
	$(MAKE) clean -C hello/ 
	$(RM) $(OBJS)

fclean: clean
	$(MAKE) fclean -C hello/ 
	$(RM) $(NAME)

re: fclean
	$(MAKE) all