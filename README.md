# Makefile Tutorial
An introduction to the basics of the make utility.


## Index

- [What is make?](#index-1)
- [Introduction to Makefiles](#index-2)
- ...

## <a name="index-1">What is make?</a>

The make utility is an automatic tool capable of deciding which commands can / should be executed. Mostly, the make is used to automate the compilation process, preventing manual file-by-file compilation. This utility is used through a special file called `Makefile`.

This tutorial will only display a Makefile with C files, but it can be used with any language.

## <a name="index-2">Introduction to Makefiles</a>
Creating a valid Makefile is your first priority. Typically, a Makefile is called to handle compilation and linkage of a project and its files.

For instance, when compiling a `C` project, the final executable file, would be the zipped version of every `.o` file, which was in turn created from the `.c` files.

## <a name="index-3">Let's start</a>
First off, let's define a project we will be working with. This is the directory structure.

		├── hello.c 
		├── main.c
		└── Makefile

## <a name="index-4">Makefile rules</a>
A Makefile is essentially composed of rules. Rules define how files and commands are linked together in order for the compilation to take effect.

A rule has the following syntax:

```		
	target: pre-requisit-1 pre-requisit-2 pre-requisit-3 ...
		command-1
		command-2
		command-3
		...
```

Let's break this down:

- A `target` is the name of a rule. Usually, the name of the rule is also the name of the a file that has to be generated, but it is not mandatory. Sometimes we just need an auxiliary rule to do some extra work like cleaning files or debugging.

- `Pre-requisits` are mandatory requisits that should be fulfilled before the rule executes its commands. A rule can have 0 or more pre-requisites. Pre-requisits can be files that should be present or other rules. If one of the pre-requisits is another rule, it will be executed first. Should one of the pre-requisits not be present, the rule might not be executed.

- `Commands` are the commands to be executed within a rule and usually lead to the compilation/linkage of object files. A set of commands within a rule is called a `recipe`.

Each command should be indented with a tab, otherwise an error like this might show up:

		Makefile:38: *** missing separator.  Stop.


A rule explains how, when and what files/rules are involved so the own rule is executed properly.
Here's an example of a perfectly valid rule that attempts to generate a `hello.o` file from a `hello.c` file:

	hello.o: hello.c
		clang -c hello.c

Ok! Given the current knowledge you acquired so far, you are ready to create your first simple Makefile. It will VERY simple, but functional! Let's assemble a Makefile that compiles our initial project all together.

## <a name="index-5">The first Makefile</a>
<!-- 

## <a name="index-4">Implicit rules</a> 
	Implicit rule for C:
		$(CC) $(CPPFLAGS) $(CFLAGS) -c
	Implicit rule for C++:
		$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c

-->