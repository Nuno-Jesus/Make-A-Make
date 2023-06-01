# Makefile Tutorial
An introduction to the basics of the make utility.


## Index

- [What is make?](#index-1)
- [Introduction to Makefiles](#index-2)

## <a name="index-1">What is make?</a>

The make utility is an automatic tool capable of deciding which commands can / should be executed. Mostly, the make is used to automate the compilation process, preventing manual file-by-file compilation. This utility is used through a special file called `Makefile`.

This tutorial will only display a Makefile with C files, but it can be used with any language.

## <a name="index-2">Introduction to Makefiles</a>
Creating a valid Makefile is your first priority. Typically, a Makefile is called to handle compilation and linkage of a project and its files.

For instance, when compiling a `C` project, the final executable file, would be the zipped version of every `.o` file, which was in turn created from the `.c` files.