FILES = a           b c         # Ends here

all:
ifeq ($(FILES), a b c)
	echo "FILES = a b c"
else
	echo "FILES != a b c"
endif

ifeq ($(strip $(FILES)), a b c)
	echo "RESULT = a b c"
else
	echo "RESULT != a b c"
endif

.SILENT: