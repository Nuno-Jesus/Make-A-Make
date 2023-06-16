# Makefile Tutorial
An introduction to the basics of the make utility.


## <a name="index-0">Index</a>

<ul>
	<li><a href="#index-1">What is make?</a></li>
	<li><a href="#index-2">An introduction to Makefiles</a></li>
	<li><a href="#index-3">Rules</a></li>
	<li><a href="#index-4">A simple Makefile</a></li>
	<li><a href="#index-5">Variables</a></li>
	<li><a href="#index-7">Automatic Variables</a></li>
	<li><a href="#index-7">Towards a more flexible Makefile</a></li>
	<ul>
		<li><a href="#index-7.1">Removing more redundancy</a></li>
		<li><a href="#index-7.2">Is this Magic?</a></li>
		<li><a href="#index-7.3">Relinking</a></li>
	</ul>
</ul>


<!-- ------------------------------------------------------------------ -->


## <a name="index-1">What is make?</a>
The make utility is an automatic tool capable of deciding which commands can / should be executed. Mostly, the make is used to automate the compilation process, preventing manual file-by-file compilation. This utility is used through a special file called `Makefile`.

This tutorial will only display a Makefile with C files, but it can be used with any language.


<!-- ------------------------------------------------------------------ -->


## <a name="index-2">An introduction to Makefiles</a>
Typically, a Makefile is called to handle compilation and linkage of a project and its files. The Makefile uses the modification times of the files it uses to assert if any need to be remade or not.

For instance, when compiling a `C` project, the final executable file, would be the zipped version of every `.o` file, which was in turn created from the `.c` files.

Let's create a simple project to work with. You can find this files in the [code](/code) folder.

	├── hello.c 
	├── main.c
	└── Makefile


<!-- ------------------------------------------------------------------ -->


## <a name="index-3">Rules</a>
Rules are the core of a Makefile. Rules define how, when and what files and commands are used to achieve the final executable.

A rule has the following syntax:

```Makefile
target: pre-requisit-1 pre-requisit-2 pre-requisit-3 ...
	command-1
	command-2
	command-3
	...
```

- A `target` is the name of a rule. Its, usually, also the name of a file, but not always.

- A rule can have dependencies, some stuff to be fulfilled before execution, named `pre-requisits`. A pre-requisit **can be either a file or another rule**. In the last case, the dependency rule is executed first. If the pre-requisit doesn't match neither a file or a rule's name, the Makefile halts and prints an error.

- Finally, after all pre-requisits are fulfilled, the rule can execute its `recipe`, a collection of `commands`. A rule can also have an empty recipe.

Each command should be indented with a **tab**, otherwise an error like this might show up:

	Makefile:38: *** missing separator.  Stop.

Here's an example of a perfectly valid rule that attempts to generate a `hello.o` file from a `hello.c` file:

```Makefile
hello.o: hello.c
	clang -c hello.c
```

The `clean` rule is used to clean temporary files. Those would be the object files in a C project:

```Makefile
clean:
	rm -rf hello.o
```

You can also have a similar rule to clean both object files and the executable:

```Makefile
fclean: clean
	rm -rf a.out
```

Finally, if you're lazy like me and need to re-compile everything, you might want to create a rule to clean and re-compile:

```Makefile
re: fclean all
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


<!-- ------------------------------------------------------------------ -->


## <a name="index-4">A simple Makefile</a>
The Makefile bellow is capable of compiling our example project. 

```Makefile
hello.o: hello.c
	cc -c hello.c

all: hello.o
	cc main.c hello.o

clean:
	rm -rf hello.o

fclean: clean
	rm -rf a.out

re: fclean all
```

Here's an image to display the dependencies in a more organized way:
<div align=center>
	<image src=images/graph_1.png>
</div>

In the terminal, run:

	make <target>

...where `<target>` is the name of the rule you want to run. In this case, we need both `main.c` and `hello.c` file to be compiled, so you can run:

	make all

> **Warning**
> If the `<target>` field is ommited, the Makefile will execute the first rule. And yes, this example is not doing that, the primary rule should be 'all'.

You should see something like this on the terminal:

	cc -c hello.c
	cc main.c hello.o

This is great! The compilation worked out and finally we can execute our program and print "Hello World!"! But what if one wanted to compile `N` more files? Would they need to create `N` more rules?


<!-- ------------------------------------------------------------------ -->


## <a name="index-5">Variables</a>
Similar to programming languages, the Makefile syntax allows you to define variables. Variables can only be strings (a single one or a list of strings). Here are some examples:

```Makefile
FIRST_NAMES := Nuno Miguel 				
LAST_NAMES := Carvalho de Jesus
FULL_NAME := $(FIRST_NAMES) $(LAST_NAMES) # Nuno Miguel Carvalho de Jesus
```

> **Note**: typically you should use the ':=' operator but '=' also works. 

> **Note**: the naming convention for variables is uppercase, to distinguish from Makefile rules. 

> **Note**: When more than one string is specified in a variable, it isn't considered as a string with spaces, but a list of strings.

You can use variables in rules and other variables as well. To access their values, you must use:

	$(FIRST_NAME)

or 

	${FIRST_NAME}

Let's expand our project and add some more files:

	├── hello.c 
	├── bye.c 
	├── highfive.c 
	├── main.c
	└── Makefile

A naive solution would be to create more rules:

```Makefile
hello.o: hello.c
	cc -c hello.c

bye.o: bye.c
	cc -c bye.c

highfive.o: highfive.c
	cc -c highfive.c

all: hello.o bye.o highfive.o
	cc main.c hello.o bye.o highfive.o
```

This would be the new dependency graph:
<div align=center>
	<image src=images/graph_2.png>
</div>

But this is ugly and unnecessary since the pattern is always the same. Let us use the newly learn variables to clean this up!

```Makefile
OBJS := hello.o bye.o highfive.o # Dependency list of the 'all' rule

all: $(OBJS)
	cc main.c $(OBJS)

%.o: %.c
	cc -c $<
```

Variables allow you to focus your changes on one place, preventing error-prone implementations and repeated values across your Makefile.

Ok, pause. I know this is a lot to take in. Let's look into the details.When running `make`:

**1.** The `all` rule is chosen by default:

```Makefile
all: $(OBJS)
	cc main.c $(OBJS)
```

**2.** The `OBJS` variable is expanded its values, creating multiple dependencies:

```Makefile
all: hello.o bye.o highfive.o
	cc main.c $(OBJS)
```

**3.** In the first compilation, the `hello.o` file doesn't exist. The dependency must then be remade, which forces the Makefile to look for a rule.

```Makefile
%.o: %.c
	cc -c $<
```

The `%` can be used in several cases. For this one, its used to represent a **Regular Expression (REGEX)**. You can read it as "any dependency that ends on `.o` can be generated here and needs a corresponding `.c` dependency with the same prefix". For `hello.o` we have:

```Makefile
hello.o: hello.c
	cc -c $< # The $< expands to the first dependency of this rule (hello.c)
```

The same goes for other dependencies having a `.o` suffix. The `$<` is an **Automatic Variable**. We'll talk more about Automatic Variables up ahead.Specifically this one is used to handle variable dependency strings, since the value of the dependency is not always the same. Final expansion:

```Makefile
hello.o: hello.c
	cc -c hello.c
```

**4.** Finally, after all dependencies are generated following the same pattern as before, the `all` rule can execute its recipe. The `OBJS` variable is expanded again to its values

```Makefile
all: hello.o bye.o highfive.o
	cc main.c hello.o bye.o highfive.o
```

Here's what we have so far:

```Makefile
OBJS := hello.o bye.o highfive.o # Dependency list of the 'all' rule

all: $(OBJS)
	cc main.c $(OBJS)

%.o: %.c
	cc -c $<

clean:
	rm -rf $(OBJS)

fclean: clean
	rm -rf a.out

re: fclean all
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


<!-- ------------------------------------------------------------------ -->


## <a name="index-6">Automatic variables</a>
Automatic variables are special variables used by the Makefile to dynamically compute values. In other words, you should use those, when a rule does not always have the same dependency or target name, like in the example above.

Below, is a table of some of the most useful ones:

| Variable | Description |
|----------|-------------|
|`$@`|The name of a target rule|
|`$<`|The name of the first pre-requisit|
|`$^`|The name of all pre-requisits, separated by spaces|
|`$*`|The stem that matched the pattern of a rule|

```Makefile
lib.a: hello.o bye.o highfive.o
	echo $@ # Prints "lib.a"
	echo $< # Prints "hello.o"
	echo $^ # Prints "hello.o bye.o highfive.o"

%.example:
	echo $* # Prints "this", since it matched the prefix pattern

all: lib.a this.example
```


<!-- ------------------------------------------------------------------ -->


## <a name="index-7">Towards a more flexible Makefile</a>

We are reaching the end of the tutorial! This section is all about polishing what we've developed so far. There will (much) more contents after this, but its up to move on. 

### <a name="index-7.1">Removing more redundancy</a>
Now that the basics are settled (at least they should be), let's have a look at some details. Noticed how the `rm -rf` and the `cc` commands are repeating? We can place them in variables:

```Makefile
CC      := cc
RM      := rm -rf
OBJS	:= hello.o bye.o highfive.o

all: $(OBJS)
	$(CC) main.c $(OBJS)

%.o: %.c
	$(CC) -c $<

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) a.out

re: fclean all
```

After a few hours, you realised your code is not that clean and you need a more secure compilation (compilation flags). You also want to name your executable `project`. For both cases we can define variables to avoid unecessary repetition.
Here are the new changes:

```Makefile
CC      := cc
CFLAGS	:= -Wall -Werror -Wextra
RM      := rm -rf
NAME	:= project
OBJS	:= hello.o bye.o highfive.o

all: $(OBJS)
	$(CC) $(CFLAGS) main.c $(OBJS) -o $(NAME)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

...

fclean: clean
	$(RM) $(NAME)

```

> **Note**: The `-o` flag is part of the `cc` compiler, which allows you to specify which name the executable will have.

> **Note**: the `CC` and `CFLAGS` names are not randomly chosen...

### <a name="index-7.2">Is this magic?</a>
Have you tried to remove the `%.o: %.c` rule? Is the Makefile still working? If you are confused about it, check the [Implicit Rules](#index-0) and [Builtin Variables](#index-0) sections.

### <a name="index-7.3">Relinking</a>
To wrap this simple tutorial, I would like you to run `make` several times. Have you noticed how the `main.c` and `.o` files are getting linked together, even though they haven't changed? This is a phenomenon called **relinking**.

Although it might not seem that important, considering a large scale project, relinking can cause unnecessary and larger compilation times. To avoid it, we can add as a dependency the executable file you are trying to create, like this:

```Makefile
...

NAME := project
all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) main.c $(OBJS) -o $(NAME)

...
```

This version does the same job as before. The main difference lies on the new dependency of `all`. The first compilation will assert the project executable is not a file, so it must be remade through the `$(NAME)` rule. In the second compilation, since the `project` file was created before, the dependency is fulfilled and the Makefile directly executes the `all` recipe. Since it's empty, you'll get this message:

	make: Nothing to be done for 'all'.

And there you have it! I hope this beginner's guide cleared a bit of your doubts. If you're not a beginner (or don't want to be one anymore), I advise you to check the contents up ahead. Many of those might be useful to change and upgrade your Makefiles!
<!-- 

## <a name="index-4">Implicit rules</a> 
	Implicit rule for C:
		$(CC) $(CPPFLAGS) $(CFLAGS) -c
	Implicit rule for C++:
		$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c

## <a name="index-4">Builtin target names</a> 
.SILENT: silences all the commands printed on the output
.PHONY: used to tell the Makefile to not confuse the names of the targets with filenames. For instance, having a file called `hello`, should not enter in conflict with the `hello` rule
.DEFAULT_GOAL: used to define what is the primary target of the makefile. For instance, even if the clean rule is not the first, if defined in this macro, it will be executed when running solely 'make'.

## <a name="index-4">Builtin variables</a>
Some variables are already recognized by the Makefile when given a certain name. Those are the variables the Makefile will use to execute the implicit rules. Here are some useful variables:
	AR("ar") - used to create archives, .a files
	CC("cc") - the default compiler to use when compiling C programs
	CXX("g++") - the default compiler to use when compiling C++ programs
	ARFLAGS("-rv") - flags to work with AR
	CFLAGS("") - extra flags to work with CC
	CXXFLAGS("") - extra flags to work with CXX
	


## <a name="index-4">Typical errors</a>

## <a name="index-4">Useful flags</a>
-C <directory> Call another makefile located at <dir>
-k Continue as much as possible after an error occurred.
-s Turns off printing of the makefile actions in the terminal
-r Tells the makefile to ignore any builtin rules
-j<number of threads> Allows parallel computation of makefile actions. Needs $(MAKE) to work properly.
-n Displays the commands the makefile would run without actually running them
--debug Displays the thinking process of the makefile before executing any targets
--no-print-directory Disables message printing of whenever the makefile enters or exits a directory

## <a name="index-4">Makefile functions</a>

## <a name="index-4">Command line variables</a>

## <a name="index-4">The vpath directive and project organization</a>

## <a name="index-4">Questions</a>

- In this Makefile, what does the $(SRCS:.c=.o) do?

-->

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>

## <a name="index-4">Glossary</a>

<details>
	<summary>A</summary>
	<ul>
		<li><strong>Automatic Variable</strong> - </li>
	</ul>
</details>
<details>
	<summary>D</summary>
	<ul>
		<li><strong>Dependency</strong> - </li>
	</ul>
</details>
<details>
	<summary>E</summary>
	<ul>
		<li><strong>Expansion</strong> - </li>
	</ul>
</details>
<details>
	<summary>F</summary>
	<ul>
		<li><strong>Flag</strong> - </li>
	</ul>
</details>
<details>
	<summary>P</summary>
	<ul>
		<li><strong>Pre-requisit</strong> - </li>
	</ul>
</details>
<details>
	<summary>R</summary>
	<ul>
		<li><strong>Recipe</strong> - </li>
	</ul>
	<ul>
		<li><strong>Regular Expression</strong> - </li>
	</ul>
	<ul>
		<li><strong>Re-linking</strong> - </li>
	</ul>
	<ul>
		<li><strong>Rule</strong> - </li>
	</ul>
</details>
<details>
	<summary>T</summary>
	<ul>
		<li><strong>Target</strong> - </li>
	</ul>
</details>
<details>
	<summary>V</summary>
	<ul>
		<li><strong>Variable</strong> - </li>
	</ul>
</details>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>