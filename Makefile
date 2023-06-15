#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_
#_                                                                                           _
#_                                           COLORS                                          _
#_                                                                                           _
#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_

RESET	= \033[0m
BLACK 	= \033[1;30m
RED 	= \033[1;31m
GREEN 	= \033[1;32m
YELLOW 	= \033[1;33m
BLUE	= \033[1;34m
PURPLE 	= \033[1;35m
CYAN 	= \033[1;36m
WHITE 	= \033[1;37m

#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_
#_                                                                                           _
#_                                          COMMANDS                                         _
#_                                                                                           _
#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_

CC = cc
RM = rm -rf
AR = ar -rcs

#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_
#_                                                                                           _
#_                                           FLAGS                                           _
#_                                                                                           _
#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_

CFLAGS		= -Wall -Wextra -Werror
MAKEFLAGS	= --no-print-directory

#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_
#_                                                                                           _
#_                                          FOLDERS                                          _
#_                                                                                           _
#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_

DEPS			= includes 
SRCS			= .
_SUBFOLDERS		= binary_search_tree conversions dictionary is linked_list \
					matrix memory pair print str vector
VPATH			= srcs $(addprefix $(SRCS)/nc_, $(_SUBFOLDERS))
OBJ_DIR			= bin

#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_
#_                                                                                           _
#_                                           FILES                                           _
#_                                                                                           _
#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_


NAME			= libnc.a

_IS 			= isalnum isalpha isascii isdigit isprint

_STR			= replace replace_all split strchr strdup striteri strjoin strlcat \
					strlcpy strlen strmapi strncmp strnstr strrchr strtrim substr

_PRINT			= putchar_fd putendl_fd putnbr_fd putstr_fd

_MEMORY			= bzero calloc memchr memcmp memcpy memmove memset

_CONVERSIONS 	= atoi itoa tochar tolower tonum toupper

_PAIR 			= pair_new pair_print pair_copy pair_swap pair_delete pair_tostring \
					pair_clear

_MATRIX			= matrix_new matrix_delete matrix_size matrix_copy matrix_append \
					matrix_print matrix_merge 

_VECTOR			= vector_new vector_push vector_pop vector_clear vector_delete \
					vector_copy vector_at vector_find vector_merge vector_print \
					vector_first vector_last 

_DICTIONARY 	= dict_new dict_insert dict_copy dict_get dict_exists dict_remove \
					dict_values_setup dict_clear dict_delete dict_to_list dict_keys \
					dict_values dict_print

_LINKED_LISTS	= list_add_back list_add_front list_at list_clear list_delone list_find \
					list_iter list_last list_map list_new list_reverse list_size

_BINARY_TREE	= bstree_new bstree_insert bstree_traverse bstree_delete bstree_clear \
					bstree_print bstree_copy bstree_deepcopy bstree_find bstree_count \
					bstree_height bstree_to_list

_FILES			= $(_BINARY_TREE) $(_CONVERSIONS) $(_DICTIONARY) $(_IS) $(_LINKED_LISTS) \
					$(_MATRIX) $(_MEMORY) $(_PAIR) $(_PRINT) $(_STR) $(_VECTOR)

OBJS			= $(_FILES:%=nc_%.o)
TARGET			= $(addprefix $(OBJ_DIR)/, $(OBJS))

#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_
#_                                                                                           _
#_                                           RULES                                           _
#_                                                                                           _
#_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_/=\_


all: $(NAME)

$(NAME): $(OBJ_DIR) $(TARGET)
	echo "[$(CYAN) Linking $(RESET)] $(GREEN)$(NAME)$(RESET)"
	$(AR) $(NAME) $(TARGET)
	
	echo "$(GREEN)Done.$(RESET)"
	
$(OBJ_DIR)/%.o : $(SRCS)/%.c 
	echo "[$(CYAN)Compiling$(RESET)] $(CFLAGS) $(GREEN)$<$(RESET)"
	$(CC) $(CFLAGS) -c $< -o $@ -I $(DEPS)

$(OBJ_DIR) :
	mkdir -p $(OBJ_DIR)

clean:	
	echo "[$(RED) Deleted $(RESET)] $(GREEN)$(OBJ_DIR)$(RESET)"
	$(RM) $(OBJ_DIR)

fclean: clean
	echo "[$(RED) Deleted $(RESET)] $(GREEN)$(NAME)$(RESET)"
	$(RM) $(NAME)

re: fclean all

.SILENT:
.ONESHELL:
