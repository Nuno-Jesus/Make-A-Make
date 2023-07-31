FILES = main hello function
SRCS  = $(foreach file, $(FILES), $(file).c)
OBJS  = $(foreach file, $(FILES), $(file).o)

all:
	echo Prefixes = $(FILES)
	echo Files = $(SRCS)
	echo Object files = $(OBJS)

.SILENT: