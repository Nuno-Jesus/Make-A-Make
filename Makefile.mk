PROJECT	:= webserv
VERSION	:= 2.0.0

# **************************************************************************** #
# Project Variables
# **************************************************************************** #

NAME1	:= webserv

NAMES	:= ${NAME1}

# **************************************************************************** #
# Configs
# **************************************************************************** #

# Operative System
OS	:= $(shell uname)

# Verbose levels
# 0: Make will be totaly silenced
# 1: Make will print echos and printf
# 2: Make will not be silenced but target commands will not be printed
# 3: Make will print each command
# 4: Make will print all debug info
#
# If no value is specified or an incorrect value is given make will print each
# command like if VERBOSE was set to 3.
VERBOSE	:= 2

# Pedantic allows for extra warning flags to be used while compiling. If set to
# true these flags are applied. If set to anything else the flags will not be
# used. By default it's turned on.
PEDANTIC	:= false

# **************************************************************************** #
# Language
# **************************************************************************** #

# Specify the language use by your program. This will allow to detect file
# extentions automatically (not implemented). It also allows fo warnings to be
# activated/deactivated based on the language used.
LANG	:= C++

# Add more extensions here.
ifeq (${LANG},C++)
EXT		:= cpp
HEXT	:= hpp
endif

# **************************************************************************** #
# Colors and Messages
# **************************************************************************** #

GREEN		:= \e[38;5;2m
BLUE		:= \e[38;5;20m
YELLOW		:= \e[38;5;3m
RED			:= \e[38;5;1m
DRED		:= \e[38;5;88m
GRAY		:= \e[38;5;8m
RESET		:= \e[0m

_OBJS	:= ${DRED}[obj]: ${RESET}
_BINS	:= ${BLUE}[bin]: ${RESET}
_LIBS	:= ${YELLOW}[lib]: ${RESET}
_DEPS	:= ${GRAY}[dep]: ${RESET}

_SUCCESS	:= ${GREEN}[ok]:${RESET}
_FAILURE	:= ${RED}[ko]:${RESET}
_INFO		:= ${YELLOW}[info]:${RESET}

# **************************************************************************** #
# Compiler & Flags
# **************************************************************************** #

# Compiler
ifeq (${LANG},C++)
	CC := c++
endif

# Compiler flags
CFLAGS := -Wall -Wextra -Werror -g
CFLAGS += -std=c++98

# Pedantic flags
ifeq (${PEDANTIC},true)
	CFLAGS += -Wpedantic -Werror=pedantic -pedantic-errors -Wcast-align
	CFLAGS += -Wcast-qual -Wdisabled-optimization -Wformat=2 -Wuninitialized
	CFLAGS += -Winit-self -Wmissing-include-dirs -Wredundant-decls -Wshadow
	CFLAGS += -Wstrict-overflow=5 -Wundef -fdiagnostics-show-option
	CFLAGS += -fstack-protector-all -fstack-clash-protection
	ifeq (${CC},gcc)
		CFLAGS += -Wformat-signedness -Wformat-truncation=2 -Wformat-overflow=2
		CFLAGS += -Wlogical-op -Wstringop-overflow=4
	endif
	ifeq (${LANG},C++)
		CFLAGS += -Wctor-dtor-privacy -Wold-style-cast -Woverloaded-virtual
		CFLAGS += -Wsign-promo
		ifeq (${CC},gcc)
			CFLAGS += -Wstrict-null-sentinel -Wnoexcept
		else ifeq (${CC},c++)
			CFLAGS += -std=c++98
		endif
	endif
endif

# Generic debug flags
DFLAGS := -g

# Address sanitizing flags
ASAN := -fsanitize=address -fsanitize-recover=address
ASAN += -fno-omit-frame-pointer -fno-common
ASAN += -fsanitize=pointer-subtract -fsanitize=pointer-compare
# Technicaly UBSan but works with ASan
ASAN += -fsanitize=undefined
# Technicaly LSan but works with ASan
ASAN += -fsanitize=leak
# Thread sanitizing flags
TSAN := -fsanitize=thread
# Memory sanitizing flags
MSAN := -fsanitize=memory -fsanitize-memory-track-origins

# **************************************************************************** #
# File Manipulation
# **************************************************************************** #

RM		:= rm -rf
GIT		:= git
MV		:= mv
PRINT	:= printf
CP		:= cp -r
MKDIR	:= mkdir -p
NORM	:= norminette
FIND	:= find
ifeq (${OS},Linux)
 SED	:= sed -i.tmp --expression
else ifeq (${OS},Darwin)
 SED	:= sed -i.tmp
endif

# Definitions
T		:= 1
comma	:= ,
empty	:=
space	:= $(empty) $(empty)
tab		:= $(empty)	$(empty)

# **************************************************************************** #
# Root Folders
# **************************************************************************** #

BIN_ROOT	:= ./
DEP_ROOT	:= dep/
INC_ROOT	:= includes/
LIB_ROOT	:= lib/
OBJ_ROOT	:= obj/
SRC_ROOT	:= srcs/
TEST_ROOT	:= build/tests/

# **************************************************************************** #
# Content Folders
# **************************************************************************** #

# Lists of ':' separated folders inside SRC_ROOT containing source files. Each
# folder needs to end with a '/'. The path to the folders is relative to
# SRC_ROOTIf SRC_ROOT contains files './' needs to be in the list. Each list is
# separated by a space or by going to a new line and adding onto the var.
# Exemple:
# DIRS := folder1/:folder2/
# DIRS += folder1/:folder3/:folder4/
DIRS	:= ./:cgi/:config/:http/:utils/:server/:sockets/

SRC_DIRS_LIST	:= $(addprefix ${SRC_ROOT},${DIRS})
SRC_DIRS_LIST	:= $(foreach dl,${SRC_DIRS_LIST},$(subst :,:${SRC_ROOT},${dl}))

SRC_DIRS	= $(call rmdup,$(subst :,${space},${SRC_DIRS_LIST}))
OBJ_DIRS	= $(subst ${SRC_ROOT},${OBJ_ROOT},${SRC_DIRS})
DEP_DIRS	= $(subst ${SRC_ROOT},${DEP_ROOT},${SRC_DIRS})

# List of folders with header files.Each folder needs to end with a '/'. The
# path to the folders is relative to the root of the makefile. Library includes
# can be specified here.
INC_DIRS	+= ${INC_ROOT}

# **************************************************************************** #
# Files
# **************************************************************************** #

SRCS_LIST	= $(foreach dl,${SRC_DIRS_LIST},$(subst ${space},:,\
	$(strip $(foreach dir,$(subst :,${space},${dl}),\
	$(wildcard ${dir}*.${EXT})))))
OBJS_LIST	= $(subst ${SRC_ROOT},${OBJ_ROOT},$(subst .${EXT},.o,${SRCS_LIST}))

SRCS	= $(foreach dir,${SRC_DIRS},$(wildcard ${dir}*.${EXT}))
OBJS	= $(subst ${SRC_ROOT},${OBJ_ROOT},${SRCS:.${EXT}=.o})
DEPS	= $(subst ${SRC_ROOT},${DEP_ROOT},${SRCS:.${EXT}=.d})

INCS	:= ${addprefix -I,${INC_DIRS}}

BINS	:= ${addprefix ${BIN_ROOT},${NAMES}}

# **************************************************************************** #
# Test Files
# **************************************************************************** #

BUILD	:= build/
TEST_NAME	:= ${TEST_ROOT}webserv_utests

# **************************************************************************** #
# Conditions
# **************************************************************************** #

ifeq (${OS},Linux)
	SED := sed -i.tmp --expression
else ifeq (${OS},Darwin)
	SED := sed -i.tmp
endif

ifeq ($(VERBOSE),0)
	MAKEFLAGS += --silent
	BLOCK := &>/dev/null
else ifeq ($(VERBOSE),1)
	MAKEFLAGS += --silent
else ifeq ($(VERBOSE),2)
	AT := @
else ifeq ($(VERBOSE),4)
	MAKEFLAGS += --debug=v
endif

ifeq (${CREATE_LIB_TARGETS},0)
	undefine DEFAULT_LIBS
endif

# **************************************************************************** #
# VPATHS
# **************************************************************************** #

vpath %.o $(OBJ_ROOT)
vpath %.${HEXT} $(INC_ROOT)
vpath %.${EXT} $(SRC_DIRS)
vpath %.d $(DEP_DIRS)

# **************************************************************************** #
# Project Target
# **************************************************************************** #

all: ${BINS}

run: CFLAGS += -DLIB=FT
run: all
	${AT} $(foreach bin,${BINS},./${bin}) ${BLOCK}

run_re : fclean run

std: CFLAGS += -DLIB=STD
std: all
	${AT} $(foreach bin,${BINS},./${bin}) ${BLOCK}

std_re : fclean std

.SECONDEXPANSION:
${BIN_ROOT}${NAME1}: $$(call get_files,$${@F},$${OBJS_LIST})
	${AT}${PRINT} "${_BINS} $@\n" ${BLOCK}
	${AT}${MKDIR} ${@D} ${BLOCK}
	${AT}${CC} ${CFLAGS} ${INCS} ${ASAN_FILE}\
		$(call get_files,${@F},${OBJS_LIST}) ${LIBS} -o $@ ${BLOCK}

# **************************************************************************** #
# Test Targets
# **************************************************************************** #

${TEST_NAME}: test

test_run: ${FORCE}
test_run: ${TEST_NAME}
	${AT} ./${TEST_NAME} ${BLOCK}

test_re: test_clean test_run

test_clean:
	${AT}${MAKE} clean -C ${BUILD} ${BLOCK}

test:
	${AT}${MAKE} -C ${BUILD} ${BLOCK}

# **************************************************************************** #
# Clean Targets
# **************************************************************************** #

clean:
	${AT}${PRINT} "${_INFO} removed objects\n" ${BLOCK}
	${AT}${MKDIR} ${OBJ_ROOT} ${BLOCK}
	${AT}${FIND} ${OBJ_ROOT} -type f -name "*.o" -delete ${BLOCK}

fclean:
	${AT}${PRINT} "${_INFO} removed objects\n" ${BLOCK}
	${AT}${MKDIR} ${OBJ_ROOT} ${BLOCK}
	${AT}${FIND} ${OBJ_ROOT} -type f -name "*.o" -delete ${BLOCK}
	${AT}${PRINT} "${_INFO} removed bins\n" ${BLOCK}
	${AT}${MKDIR} ${BIN_ROOT} ${BLOCK}
	${AT}${FIND} ${BIN_ROOT} -type f\
		$(addprefix -name ,${NAMES}) -delete ${BLOCK}

clean_dep:
	${AT}${PRINT} "${_INFO} removed dependencies\n" ${BLOCK}
	${AT}${MKDIR} ${DEP_ROOT} ${BLOCK}
	${AT}${FIND} ${DEP_ROOT} -type f -name "*.d" -delete ${BLOCK}

clean_all: fclean clean_dep

re: fclean all

# **************************************************************************** #
# Debug Targets
# **************************************************************************** #

debug: CFLAGS += ${DFLAGS}
debug: all

debug_tsan: CFLAGS += ${DFLAGS} ${TSAN}
debug_tsan: all

debug_msan: CFLAGS += ${DFLAGS} ${MSAN}
debug_msan: all

debug_re: fclean debug

debug_tsan_re: fclean debug_tsan

debug_msan_re: fclean debug_msan

# **************************************************************************** #
# Utility Targets
# **************************************************************************** #

folders:
	${AT}${MKDIR} ${SRC_ROOT} ${BLOCK}
	${AT}${MKDIR} ${INC_ROOT} ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: folder structure created\n" ${BLOCK}

git_init:
	${AT} git init ${BLOCK}
	${AT}echo "*.o\n*.d\n.vscode\na.out\n.DS_Store\nbin/\n.ccls-cache/\nbuild/\n*.ignore" > .gitignore ${BLOCK}
	${AT}${GIT} add README.md ${BLOCK}
	${AT}${GIT} add .gitignore ${BLOCK}
	${AT}${GIT} add Makefile ${BLOCK}
	${AT}${GIT} commit -m "first commit - via Makefile (automatic)" ${BLOCK}
	${AT}${GIT} branch -M main ${BLOCK}
	${AT}${GIT} remote add origin git@github.com:${USER}/${PROJECT}.git ${BLOCK}
	${AT}${GIT} push -u origin main ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: git: initialized\n" ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: git: .gitignore created\n" ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: git: commit \"initial commit\"\n" ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: initialized\n" ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: git: \"push -u origin main\"\n" ${BLOCK}

readme:
	${AT}${GIT} clone git@github.com:mlanca-c/Generic-README.git ${BLOCK}
	${AT}${MV} Generic-README/README.md ./ ${BLOCK}
	${AT}${RM} Generic-README ${BLOCK}
	${AT}${SED} 's/NAME/${PROJECT}/g' README.md ${BLOCK}
	${AT}${RM} README.md.tmp ${BLOCK}
	${AT}${PRINT} "${_INFO} ${PROJECT}: git: README.md created\n" ${BLOCK}

.init: folders readme git_init

# Meta target to force a target to be executed
.FORCE: ;

# Print a specifique variable
print-%: ; @echo $*=$($*)

# List all the targets in alphabetical order
targets:
	${AT}${MAKE} LC_ALL=C -pRrq -f ${CURRENT_FILE} : 2>/dev/null\
		| awk -v RS= -F: '/^# File/,/^# files hash-table stats/\
			{if ($$1 !~ "^[#]") {print $$1}}\
			{if ($$1 ~ "# makefile") {print $$2}}'\
		| sort

# **************************************************************************** #
# .PHONY
# **************************************************************************** #

# Phony project targets
.PHONY: run run_re std std_re
# Phony clean targets
.PHONY: clean fclean clean_dep clean_all

# Phony debug targets
.PHONY: debug debug_re debug_tsan debug_tsan_re

# Phony utility targets
.PHONY: targets .FORCE

# Phony execution targets
.PHONY: re all

# **************************************************************************** #
# Constantes
# **************************************************************************** #

NULL =
SPACE = ${NULL} #
CURRENT_FILE = ${MAKEFILE_LIST}

# **************************************************************************** #
# Functions
# **************************************************************************** #

# Get the index of a given word in a list
_index = $(if $(findstring $1,$2),$(call _index,$1,\
	$(wordlist 2,$(words $2),$2),x $3),$3)
index = $(words $(call _index,$1,$2))

# Get value at the same index
lookup = $(word $(call index,$1,$2),$3)

# Remove duplicates
rmdup = $(if $1,$(firstword $1) $(call rmdup,$(filter-out $(firstword $1),$1)))

# Get files for a specific binary
get_files = $(subst :,${space},$(call lookup,$1,${NAMES},$2))

# **************************************************************************** #
# Target Templates
# **************************************************************************** #

define make_bin_def
${1}: ${2}
endef

define make_obj_def
${1}: ${2} ${3}
	$${AT}$${PRINT} "$${_OBJS} $${@F}\n" $${BLOCK}
	$${AT}${MKDIR} $${@D} $${BLOCK}
	$${AT}$${CC} $${CFLAGS} $${INCS} -c $$< -o $$@ $${BLOCK}
endef

define make_dep_def
${1}: ${2}
	$${AT}$${PRINT} "$${_DEPS} $${@F}\n" $${BLOCK}
	$${AT}${MKDIR} $${@D} $${BLOCK}
	$${AT}$${CC} -MM $$< $${INCS} -MF $$@ $${BLOCK}
	$${AT}$${SED} 's|:| $$@ :|' $$@ $${SED_END} $${BLOCK}
	$${AT}$${SED} '1 s|^|$${@D}/|' $$@ && rm -f $$@.tmp $${BLOCK}
	$${AT}$${SED} '1 s|^$${DEP_ROOT}|$${OBJ_ROOT}|' $$@\
		&& rm -f $$@.tmp $${BLOCK}
endef

define make_lib_def
${1}/${2}: .FORCE
	make -C ${1} ${2}
	$${AT}$${PRINT} "$${_LIBS} $${@F}\n" $${BLOCK}
endef

define make_compile_test_def
compile-test/${1}: .FORCE
	$${AT}$${PRINT} "[testing]: $${@F}\n" $${BLOCK}
	$${AT}$${CC} $${CFLAGS} -fsyntax-only $${INCS} $${ASAN_FILE}\
		$$(call get_files,$${@F},$${SRCS_LIST}) $${BLOCK}
endef

# **************************************************************************** #
# Target Generator
# **************************************************************************** #

ifneq (${BIN_ROOT},./)
$(foreach bin,${BINS},$(eval\
$(call make_bin_def,$(notdir ${bin}),${bin})))
endif

$(foreach src,${SRCS},$(eval\
$(call make_dep_def,$(subst ${SRC_ROOT},${DEP_ROOT},${src:.${EXT}=.d}),${src})))

$(foreach src,${SRCS},$(eval\
$(call make_obj_def,$(subst ${SRC_ROOT},${OBJ_ROOT},${src:.${EXT}=.o}),\
${src},\
$(subst ${SRC_ROOT},${DEP_ROOT},${src:.${EXT}=.d}))))

$(foreach lib,${DEFAULT_LIBS},$(foreach target,${DEFAULT_LIB_RULES},$(eval\
$(call make_lib_def,${lib},${target}))))

$(foreach name,$(NAMES),$(eval\
$(call make_compile_test_def,${name})))

# **************************************************************************** #
# Includes
# **************************************************************************** #

-include ${DEPS}