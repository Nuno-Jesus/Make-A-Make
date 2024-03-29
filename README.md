# Makefile Tutorial

## Description
This README was developed mainly to help 42 students to clear the fog around Makefiles and how they work. But, it will be for sure helpful to anyone out there struggling as well. 

It starts with a beginner's guide, followed up by some medium-advanced concepts.

## <a name="index-0">Index</a>
<ul>
	<li><strong><a href="#beginners-guide" style="color:white">Beginner's Guide</a></strong></li>
	<ul style="list-style-type:disc">
		<li><a href="#index-1">1. What is make?</a></li>
		<li><a href="#index-2">2. An introduction to Makefiles</a></li>
		<li><a href="#index-3">3. Rules</a></li>
		<li><a href="#index-4">4. A simple Makefile</a></li>
		<li><a href="#index-4.1">4.1 Dependencies and rule processing</a></li>
		<li><a href="#index-5">5. Variables</a></li>
		<li><a href="#index-6">6. Automatic Variables</a></li>
		<li><a href="#index-7">7. Towards a more flexible Makefile</a></li>
		<ul style="list-style-type:disc">
			<li><a href="#index-7.1">7.1. Removing more redundancy</a></li>
			<li><a href="#index-7.2">7.2. Implicit Rules</a></li>
			<li><a href="#index-7.3">7.3. Implicit Variables</a></li>
			<li><a href="#index-7.4">7.4. Relinking</a></li>
		</ul>
	</ul>
	<li><strong><a href="#advanced-guide" style="color:white">Advanced Topics</a></strong></li>
	<ul style="list-style-type:disc">
		<li><a href="#conditionals">A1 - Conditional Directives</a></li>
		<li><a href="#mmd-flag">A2 - The MMD flag</a></li>
		<li><a href="#command-line">A3 - Command-line variables</a></li>
		<li><a href="#functions">A4 - Functions</a></li>
		<ul style="list-style-type:disc">
			<li><a href="#functions-1">A4.1 - Functions Call Syntax</a></li>
			<li><a href="#functions-2">A4.2 - Functions for String Manipulation</a></li>
			<li><a href="#functions-3">A4.3 - Functions for File Names</a></li>
			<li><a href="#functions-4">A4.4 - Functions for Generic Purposes</a></li>
		</ul>
		<li><a href="#vpath">A5 - The vpath directive</a></li>
	</ul>
	<!-- <li>Tips and tricks</li>
	<ul>
		<li><a href="#organize-project">Organize your project with vpath</a></li>
		<li><a href="#variable-operators">Other variable related operators</a></li>
		<li><a href="#activate-debug">Activate debug commands/flags with conditionals</a></li>
		<li><a href="#general-tips">General tips</a></li>
	</ul> -->
	<li><strong><a href="#useful-topics" style="color:white">Useful Topics</a></strong></li>
	<ul style="list-style-type:disc">
		<li><a href="#special-targets">Special Targets</a></li>
		<li><a href="#flags">Makefile Flags</a></li>
		<li><a href="#errors">Good-to-know Errors</a></li>
	</ul>
</ul>


------------------------------------------------------------------


# <a name="beginners-guide">Beginner's Guide</a>

## <a name="index-1">1. What is make?</a>
The `make` utility is an automatic tool capable of deciding which commands can / should be executed. The `make` utility is mostly used to automate the compilation process, preventing manual file-by-file compilation. This utility is used through a special file called `Makefile`.

For this guide, we'll only dispose of a C project.


------------------------------------------------------------------


## <a name="index-2">2. An introduction to Makefiles</a>
Typically, a Makefile is called to handle the compilation and linking of a project and its files. The Makefile uses the modification times of participating files to assert if re-compilation is needed or not.

For instance, when compiling a `C` project, the final executable file, would be the zipped version of every `.o` file, which was in turn created from the `.c` files.

Let's create a simple project to work with.

	├── hello.c 
	├── main.c
	└── Makefile

------------------------------------------------------------------


## <a name="index-3">3. Rules</a>
Rules are the core of a Makefile. Rules define how, when and what files and commands are used to achieve the final executable.

A rule has the following syntax:

```Makefile
target: prerequisite-1 prerequisite-2 prerequisite-3 ...
	command-1
	command-2
	command-3
	...
```

- A `target` is the name of a rule. Usually, also the name of a file, but not always.

- A rule can rely on dependencies that must be fulfilled before execution. These are called `prerequisites`. Details of prerequisite parsing will be detailed in 4.1 section. 

- Finally, after the prerequisites are fulfilled, the rule can execute its `recipe`, a collection of `commands`. A rule can also have an empty recipe.

Each command should be indented with a **tab** otherwise, an error like this might show up:

	Makefile:38: *** missing separator.  Stop.

Here's an example of a rule that attempts to generate a `hello.o` file from a `hello.c` file:

```Makefile
hello.o: hello.c
	clang -c hello.c
```

As told before, some rules don't need dependencies.
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
re: fclean
	$(MAKE) all
```

> [!Note]
> `$(MAKE)` is a variable which expands to `make`. We'll see more about variables up ahead.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## <a name="index-4">4. A simple Makefile</a>
The Makefile below is capable of compiling our example project. You can find it in the [code/01-start-example](/code/01-start-example/) folder.

```Makefile
hello.o: hello.c
	cc -c hello.c

all: hello.o
	cc main.c hello.o

clean:
	rm -rf hello.o

fclean: clean
	rm -rf a.out

re: fclean
	$(MAKE) all
```

Here's an image to display the dependencies in a more organized way:
<div align=center>
	<image src=images/graph_1.png>
</div>

In the terminal, run:

	make <target>

...where `<target>` is a list of targets you want to run. In this case, we need both `main.c` and `hello.c` file to be compiled, so you can run:

	make all

> [!Warning]
> If the `<target>` field is ommited, the Makefile will execute the first rule. And yes, this example is not doing that, the primary rule should be 'all'.

You should see something like this on the terminal:

	cc -c hello.c
	cc main.c hello.o

This is great! The compilation worked out and finally, we can execute our program and use our `hello` function! But what if one wanted to compile `N` more files? Would they need to create `N` more rules?


### <a name="index-4.1">4.1. Dependencies and rules processing</a>
Consider a portion of the previous Makefile:

```Makefile
all: hello.o
	cc main.c hello.o

hello.o: hello.c
	cc -c hello.c
```

The `make` command will read the current Makefile and process the first rule. Before executing `all` it must process `hello.o` since it is a dependency.

The recompilation of the `hello.o` must be done if either `hello.o` does not exist or `hello.c` was changed since the last `hello.o` file was created. At first, there is no `hello.o` file, so it must be generated.

Now suppose `hello.c` had recent changes. That means `hello.o` would have to be recompiled. Therefore, the `all` target would have to be remade because `hello.o` is newer than the final executable.

Here's a summary:

	Is hello.o an existent file?
		Yes: Was hello.c modified since the last build?
			Yes: Remake hello.o
			No: Do nothing for hello.o
		No: Is there a rule to remake hello.o?
			Yes: Remake hello.o
			No: Error: no rule to make hello.o
	Execute cc main.c hello.o

<div align=center>
	<image src=images/graph_3.png>
</div>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## <a name="index-5">5. Variables</a>
Similar to programming languages, the Makefile syntax allows you to define variables.

Variables are useful because:
- allows you to focus your changes on one place;
- prevents the repetition of values across the Makefile (which are much more error-prone)

Variables can only be strings (a single one or a list of strings). Here are some examples:

```Makefile
FIRST_NAMES = Nuno Miguel 				
LAST_NAMES  = Carvalho de Jesus
FULL_NAME   = $(FIRST_NAMES) $(LAST_NAMES) # Nuno Miguel Carvalho de Jesus
```

> [!Note]
> The naming convention for variables is uppercase, to distinguish from Makefile rules.

You can use variables in rules and other variables as well. To access their values, you must use:

	$(FIRST_NAME)

or 

	${FIRST_NAME}

Let's add a few files to our project:

	├── bye.c 
	├── hello.c 
	├── highfive.c 
	├── main.c
	└── Makefile

A naive solution would be to create more rules. You can find the code in the [code/02-naive-example](/code/02-naive-example/) folder:

```Makefile
all: hello.o bye.o highfive.o
	cc main.c hello.o bye.o highfive.o

hello.o: hello.c
	cc -c hello.c

bye.o: bye.c
	cc -c bye.c

highfive.o: highfive.c
	cc -c highfive.c
```

This would be the new dependency graph:
<div align=center>
	<image src=images/graph_2.png>
</div>

But this is ugly and unnecessary since the pattern is always the same. Let us use the newly learn variables to clean this up! You can find the code in the [code/03-variables-example](code/03-variables-example/) folder:

```Makefile
OBJS = hello.o bye.o highfive.o # Dependency list of the 'all' rule

all: $(OBJS)
	cc main.c $(OBJS)

%.o: %.c
	cc -c $<

clean:
	rm -rf $(OBJS)

...
```

> [!Note]
> Have you have ever run `make -p > logs` ? Neither did I, but it's pretty useful! Detailed explanation on this in an upcoming section.

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

**3.** In the first compilation, the `hello.o` file doesn't exist. The dependency must then be remade, which forces the Makefile to look for a rule:

```Makefile
%.o: %.c
	cc -c $<
```

The `%` can be used in several cases. For this one, it's used to represent a **Regular Expression (REGEX)**. You can read it as "any dependency that ends on `.o` can be generated here and needs a corresponding `.c` dependency with the same prefix". For `hello.o` we have:

```Makefile
hello.o: hello.c
	cc -c $< # The $< expands to the first dependency of this rule (hello.c)
```

The same goes for other dependencies having a `.o` suffix. The `$<` is an **Automatic Variable**. We'll talk more about Automatic Variables up ahead. Specifically, this one is used to handle strings with variable values, since the value of the dependency is not always the same. Final expansion:

```Makefile
hello.o: hello.c
	cc -c hello.c
```

**4.** Finally, after all dependencies are generated following the same pattern as before, the `all` rule can execute the recipe. The `OBJS` variable is expanded again to its values:

```Makefile
all: hello.o bye.o highfive.o
	cc main.c hello.o bye.o highfive.o
```

Here's what we have so far:

```Makefile
OBJS = hello.o bye.o highfive.o # Dependency list of the 'all' rule

all: $(OBJS)
	cc main.c $(OBJS)

%.o: %.c
	cc -c $<

clean:
	rm -rf $(OBJS)

fclean: clean
	rm -rf a.out

re: fclean
	$(MAKE) all
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## <a name="index-6">6. Automatic variables</a>
Automatic variables are special variables used by the Makefile to dynamically compute values. In other words, you can use those, when a rule does not always have the same dependency or target name, like in the example above.

Below, is a table of some of the most useful ones:

<div>
	<table align=center width=100%>
		<thead>
			<tr>
				<td align=center><strong>Variables</strong></td>
				<td align=center><strong>Description</strong></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td align=center><code>$@</code></td>
				<td>The name of a target rule</td>
			</tr>
			<tr>
				<td align=center><code>$<</code></td>
				<td>The name of the first prerequisite</td>
			</tr>
			<tr>
				<td align=center><code>$^</code></td>
				<td>The name of all prerequisites, separated by spaces</td>
			</tr>
			<tr>
				<td align=center><code>$*</code></td>
				<td>The current target name with its suffix deleted</td>
			</tr>
		</tbody>
	</table>
</div>

You can find the code in the [code/04-automatic-variables-example](/code/04-automatic-variables-example/) folder:
```Makefile
all: lib.a this.example

lib.a: hello.o bye.o highfive.o
	echo $@ # Prints "lib.a"
	echo $< # Prints "hello.o"
	echo $^ # Prints "hello.o bye.o highfive.o"
	$(AR) lib.a $^

%.example:
	echo $* # Prints "this"
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## <a name="index-7">7. Towards a more flexible Makefile</a>

We are reaching the end of the tutorial! This section is all about polishing what we've developed so far. There will be (much) more content after this section, but it's up to you to go further. 

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>

### <a name="index-7.1">7.1. Removing more redundancy</a>
Now that the basics are settled (at least they should be), let's have a look at some details. Noticed how the `rm -rf` and the `cc` commands are repeating? We can place them in variables:

```Makefile
CC      = cc
RM      = rm -rf
OBJS	= hello.o bye.o highfive.o

all: $(OBJS)
	$(CC) main.c $(OBJS)

%.o: %.c
	$(CC) -c $<

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) a.out

re: fclean
	$(MAKE) all
```

After a few hours, you realized your code is not that clean and you need a more secure compilation (compilation flags). You also want to name your executable `project`. For both situations, we can define variables to avoid unnecessary repetition. You can find the code in the [code/05-redundancy-example](/code/05-redundancy-example/) folder.
Here are the new changes:

```Makefile
CC      = cc
CFLAGS	= -Wall -Werror -Wextra
RM      = rm -rf
NAME	= project
OBJS	= hello.o bye.o highfive.o

all: $(OBJS)
	$(CC) $(CFLAGS) main.c $(OBJS) -o $(NAME)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

...

fclean: clean
	$(RM) $(NAME)

```

> [!Note]
> The `-o` flag signals the compiler, to specify the name the executable will have.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


### <a name="index-7.2">7.2. Implicit Rules</a>
Have you tried to remove the `%.o: %.c` rule and run `make`? You'll soon find the Makefile is still working. But how? Makefile has its own default rules defined for specific cases, like the ones you'll see below.
You can define your own implicit rules by using pattern rules (just like we did before).

**Implicit Rules**, also use **Implicit Variables**, which you can check in the next section. Here are some of the implicit rules:

<table align=center width=100%>
	<thead>
		<tr>
			<td align=center><strong>Purpose</strong></td>
			<td align=center><strong>Rule</strong></td>
		</tr>
	</thead>
	<tbody>
		<tr align=center>
			<td>Compiling C</td>
			<td><code>$(CC) $(CPPFLAGS) $(CFLAGS) -c</code></td>
		</tr>
		<tr align=center>
			<td>Compiling C++</td>
			<td><code>$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c</code></td>
		</tr>
		<tr align=center>
			<td>Generating .a</td>
			<td><code>$(AR) $(ARFLAGS) $@ $<</code></td>
		</tr>
	</tbody>
</table>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


### <a name="index-7.3">7.3. Implicit Variables</a>
As told before, implicit rules rely on variables already known by the Makefile, set with a default value: **Implicit Variables**. You can redefine the value for these variables. Even if you don't use them explicitly, these new values can be used by implicit rules. Here's a table of some of them:


<table align=center width=100%>
	<thead>
		<tr>
			<td align=center><strong>Name</strong></td>
			<td align=center><strong>Default value</strong></td>
			<td align=center><strong>Purpose</strong></td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><code>AR</code></td>
			<td><code>ar</code></td>
			<td>The command used to create archives, <code>.a</code> files</td>
		</tr>
		<tr>
			<td><code>ARFLAGS</code></td>
			<td><code>-rv</code></td>
			<td>Used flags when <code>AR</code> command is issued</td>
		</tr>
		<tr>
			<td><code>CC</code></td>
			<td><code>cc</code></td>
			<td>The default compiler to use when C compilation is required. The cc is not a compiler, but rather an alias to the default C compiler of your machine (either <code>gcc</code> or <code>clang</code>)</td>
		</tr>
		<tr>
			<td><code>CFLAGS</code></td>
			<td><code></code></td>
			<td>Used flags when <code>CC</code> command is issued</td>
		</tr>
		<tr>
			<td><code>CXX</code></td>
			<td><code>g++</code></td>
			<td>The default compiler to use when C compilation is required.</td>
		</tr>
		<tr>
			<td><code>CXXFLAGS</code></td>
			<td><code></code></td>
			<td>Used flags when <code>CC</code> command is issued</td>
		</tr>
		<tr>
			<td><code>CPPFLAGS</code></td>
			<td><code></code></td>
			<td>Extra flags used when <code>CC or CXX</code> commands are issued. <code>CPPFLAGS</code> and <code>CFLAGS</code> might appear the same, but this one was designed to contain include flags to help the compiler to locate missing header files. But you are free to override this as you want.</td>
		</tr>
		<tr>
			<td><code>RM</code></td>
			<td><code>rm -f</code></td>
			<td>The command to be used to permanently delete a file</td>
		</tr>
		<tr>
			<td><code>MAKE</code></td>
			<td><code>make</code></td>
			<td>Useful when multi-jobs of Makefile come into play. This will be explained later in detail in an upcoming section, but keep in mind this is the best way of calling make targets inside the Makefile</td>
		</tr>
		<tr>
			<td><code>MAKEFLAGS</code></td>
			<td><code></code></td>
			<td>The flags given to make.</td>
		</tr>
	</tbody>
</table>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


### <a name="index-7.4">7.4. Relinking</a>
To wrap up this simple tutorial, I would like you to run `make` several times. Have you noticed how the `main.c` and `.o` files are getting linked together, even though they haven't changed? This is a phenomenon called **relinking**.

Although it might not seem that important, considering a large-scale project, relinking can cause unnecessary and larger compilation times. To avoid it, we can add as a dependency the executable file you are trying to create, like this:

```Makefile
...

NAME = project
all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) main.c $(OBJS) -o $(NAME)

...
```
You can find the code in the [code/06-relinking-example](/code/06-relinking-example/) folder.
This version does the same job as before. The main difference lies in the new dependency of `all`. The first compilation will assert the project executable is not a file, so it must be remade through the `$(NAME)` rule. In the second run, however, since the `project` file was created before, the dependency is fulfilled and the Makefile directly attempts to execute the `all` recipe. Since it's empty and no other recipes were run, you'll get this message

	make: Nothing to be done for 'all'.

And there you have it! I hope this beginner's guide cleared a bit of your doubts. If you're not a beginner (or don't want to be one anymore), I advise you to check the contents up ahead. Many of those might be useful to change and upgrade your Makefiles!


<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


# <a name="advanced-guide">Advanced Topics</a>

## <a name="conditionals">A1 - Conditional Directives</a>

Conditionals are directives that `make` should obey or ignore, depending on string values. Conditionals always use strings, either from variables or constant strings.

This is the general syntax for a conditional:

```Makefile
conditional-directive-one
	text-if-one-is-true
else conditional-directive-two
	text-if-two-is-true
...
else
	text-if-all-above-are-false
endif
```

Just like in `C`, conditionals either evaluate to true or false. In the block above, if `conditional-directive-one` is true, `text-if-one-is-true` is "obeyed", and the rest is ignored. Otherwise, the second conditional is tested and so on, until reaching the `else` directive (may be present or not). 

Also, conditionals must always end in an `endif` directive.

Consider the following example, saved on [code/11-conditionals-example](code/11-conditionals-example).

```Makefile
VAR1 = Nuno Jesus#The variable ends here
VAR2 = Nuno Jesus #The variable ends here

all:
ifeq ($(VAR1), Nuno Jesus)
	@echo "VAR1 contains my name"
else
	@echo "VAR1 does not contain my name"
endif

ifeq ($(VAR2), Nuno Jesus)
	@echo "VAR2 contains my name"
else
	@echo "VAR2 does not contain my name"
endif
```

> [!Warning]
> The directives **cannot** be indented inside a recipe, otherwise `make` will consider those as commands and will attempt to execute them.

We are currently making use of 3 directives:

`ifeq` - after expansion of `VAR1`, compares all the inner strings with the right field. If any string dont't match, the comparison is evaluated to false.
- `else` - if the `ifeq` directive evaluates to false, the lines below the `else` directive are obeyed.
- `endif` - marks the end of the conditional.

This outputs the following:
```shell
VAR1 contains my name
VAR2 does not contain my name
```

Although `VAR1` and `VAR2` are very similar, `VAR2` ends in space! It was more than enough to assert an inequality between the 2 values. On the other hand, the first conditional evaluates to true, because all strings from `VAR1` match the strings on the right side. Note that **leading whitespaces are ignored, but trailing spaces are not**.

> [!Note]
> You can use the `strip` built-in makefile function to remove extra whitespaces.

Conditionals determine which parts of the `Makefile` should be excluded or included before the building process begins.

Expansion of variables occurs as usual. However, **automatic variables cannot be used to test conditionals, since their values are only known in the building process**. 

The animation below demonstrates how conditionals behave.

![Conditionals](https://github.com/Nuno-Jesus/Make-A-Make/assets/93390807/0c23ea0e-d3f3-4cc6-85fb-872fd86126b0)

> [!Note]
> Quotes are only used to detail the extra space.

There are 4 different conditional directives. Here's a list:

<details>
	<summary><h4>ifeq</h4></summary>
<pre>
ifeq (ARG1, ARG2)
	...
endif
</pre>
Both <code>ARG1</code> and <code>ARG2</code> are expanded. If all strings are identical, the directive evaluates to true - false otherwise.

For example:

```Makefile
VAR = 0

all: 
ifeq ($(VAR), 0)
	@echo VAR=0.
else ifeq ($(VAR), 1)
	@echo VAR=1.
else
	@echo This not binary!
endif
```

Output: 

<pre>
VAR=0
</pre>
</details>

<details>
	<summary><h4>ifneq</h4></summary>
<pre>
ifneq (ARG1, ARG2)
	...
endif
</pre>
Both <code>ARG1</code> and <code>ARG2</code> are expanded. If any of the strings is different, the directive evaluates to true - false otherwise.

For example:

```Makefile
VAR1 = 1 2 3 4 5
VAR2 = 1 2 3 4 0

all: 
ifneq ($(VAR1), $(VAR2))
	@echo $(VAR1) != $(VAR2)
else
	@echo $(VAR1) = $(VAR2)
endif
```

Output:

<pre>
1 2 3 4 5 != 1 2 3 4 0
</pre>
</details>

<details>
	<summary><h4>ifdef</h4></summary>
<pre>
ifdef VARIABLE-NAME
	...
endif
</pre>

Takes the name of a variable (not its value), although it can receive a variable that expands to the name of another variable. If `VARIABLE-NAME` isn't an empty string, the conditional evaluates to true - false otherwise. **Undefined variables have an empty value by default.**

For example:

```Makefile
VAR = Nuno

all: 
ifdef VAR
	@echo VAR=$(VAR).
else
	@echo VAR is not defined.
endif

ifdef WHAT
	@echo WHAT=$(WHAT).
else
	@echo WHAT is not defined.
endif
```

Output:

<pre>
VAR=Nuno
WHAT is not defined.
</pre>
</details>

<details>
	<summary><h4>ifndef</h4></summary>
<pre>
ifndef VARIABLE-NAME
	...
endif
</pre>

Takes the name of a variable (not its value), although it can receive a variable that expands to the name of another variable. If `VARIABLE-NAME` is an empty string, the conditional evaluates to true. **Undefined variables have an empty value by default.**

For example:

```Makefile
ifndef CFLAGS 
	CFLAGS = -Wall -Werror -Wextra
endif

all:
	@echo You are using CFLAGS=-Wall -Werror -Wextra
```

Output:

<pre>
You are using CFLAGS=-Wall -Werror -Wextra
</pre>
</details>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>


------------------------------------------------------------------


## <a name="mmd-flag">A2 - The MMD flag</a>

Most likely, your Makefile was designed to remake whenever a `.c` file changes. But what if a `.h` changes?

Consider the following files, saved on [code/12-headers-example/](code/12-headers-example/) ...

	12-headers-example
		├── header.h 
		├── main.c
		└── Makefile


... where `header.h` and `main.c` are displayed below.

```C
// header.h
#ifndef HEADER_H
# define HEADER_H
# include <stdio.h>

# define NUMBER 42

#endif
```

```C
// main.c
#include "header.h"

int main()
{
	printf("This is the number: %d\n", NUMBER);
	return 0;
}
```

The Makefile is initially designed like this:

```Makefile
###################### Compilation ######################
CC      	= cc
CFLAGS		= -Wall -Werror -Wextra

######################## Commands #######################
RM = rm -rf

######################### Files #########################
NAME = a.out
OBJS = main.o

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

clean:
	$(RM) $(OBJS)

fclean: clean
	$(RM) $(NAME)

re: fclean
	$(MAKE) all
```

Running `make` builds `a.out`, which outputs the following when executed:

```sh
This is the number: 42
```

What if you were to change the `NUMBER` macro to `24`? Have you tried to `make` and run `a.out` after? To your surprise, the output is exacly the same. Why?

Well, as I explained in section [4.1](#index-4.1), `make` will remake a target if it notices its dependencies have a newer version. So, our Makefile cannot rely on the dependencies it doesn't know about, like `header.h`.

A naive solution would be to add `header.h` as a dependency to `$(NAME)`:

```Makefile
...
######################### Files #########################
NAME 		= a.out
OBJS 		= main.o
HEADERS		= header.h

all: $(NAME)

$(NAME): $(OBJS) $(HEADERS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)
...
```

It does fix the issue, but it's only a band-aid. We have yet another issue:

Changing `header.h` only forces the final linking of all object files...

```sh
cc  -Wall -Werror -Wextra main.o -o a.out
```

..., but it won't force the recompilation of `.c` files.


We could manually add a rule that specifies what files `main.o` depends on, which also solves the issue, but this is not very scalable.

To automate this process, we can use the `-MMD` compilation flag which generates a micro-makefile with a `.d` extension for each `.c`.

By adding `-MMD` and running `make`, ...

```Makefile
###################### Compilation ######################
CC      	= cc
CFLAGS		= -Wall -Werror -Wextra
CPPFLAGS	= -MMD

...

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJS) -o $(NAME)
...
```

...`main.d` is generated, with the following contents:

```Makefile
main.o: main.c header.h
```

Great! Now, we just need to **include** the `.d` files in our Makefile. You can use the `include` directive:

```Makefile
...

######################### Files #########################
NAME 		= a.out
OBJS 		= main.o
DEPS		= $(OBJS:.o=.d)

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJS) -o $(NAME)

-include $(DEPS)	

...
```

> [!Note]
> The `-` prefix in the `include` directive prevents make from quitting if an included file doesn't exist.

Before the building process begins, the Makefile will look for the included files and try to append them, just like the animation below demonstrates:

![MMD](https://github.com/Nuno-Jesus/Make-A-Make/assets/93390807/fb790d73-98ee-4617-9343-d17facf33edd)

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>


------------------------------------------------------------------


## <a name="command-line">A3 - Command-line variables</a>

Just like `argv` in C, `make` allows you to declare variables when running the `make` command. Let's assume we want a variable called `DEBUG` to be declared this way. We can write:

```sh
make DEBUG=1
```

General syntax for variable declaration:

```sh
make variable-name=variable-value
```

The `=` is mandatory, as `make` would consider `DEBUG` as another target to make otherwise. Remember that, if the `variable-value` is empty, the variable is considered undefined. **Assigning a new value to an existent variable overrides its old value.**

Here's an example that prints the value of the `DEBUG` variable. You can find the code in [code/14-command-line-example](code/14-command-line-example):

```Makefile
DEBUG =

all:
	@echo Compiling with DEBUG=$(DEBUG)
```

```shell
➜  14-command-line-example git:(advanced-topics) ✗ make DEBUG=-g
Compiling with DEBUG=-g
➜  14-command-line-example git:(advanced-topics) ✗ 
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## <a name="functions">A4 - Functions</a>

This starts to look a lot like C right? Now we have functions and they are very similar! Functions take parameters that are processed depending on the behavior of the function. The result of that function is later returned and replaced wherever the function call happened.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

### <a name="functions-1">A4.1 - Functions Call Syntax</a>

Function calls can appear anywhere a variable can. Function calls resemble a variable reference:

```Makefile
$(function arguments)
```

or 

```Makefile
${function arguments}
```

If the `arguments` field is composed of more than 1 parameter, they are separated using commas:

```Makefile
$(function arg1, arg2, arg3,...)
```

Whitespaces and commas are not part of the arguments. Commas and parenthesis are special characters that `make` recognize when it's time to parse a function call. If you need to use these special characters as arguments, you can hide them in variables:

```Makefile
COMMA = ,
EMPTY =
SPACE = $(EMPTY) $(EMPTY)
FOO   = a b c
BAR   = $(subst $(SPACE),$(COMMA),$(FOO))

all:
	echo FOO=$(FOO)
	echo BAR=$(BAR)

.SILENT:
```

Output
```shell
FOO=a b c
BAR=a,b,c
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

### <a name="functions-2">A4.2 - Functions for String Manipulation</a>

Up ahead, we have functions that can be used for generic string manipulation.

<details>
	<summary><h4>patsubst</h4> - replaces string patterns</summary>
	
```
$(patsubst pattern,replacement,text)
```

**Arguments**
- `pattern` - A pattern to look for
- `replacement` - What to replace `pattern` with  
- `text` - The string(s) to operate on

Looks for whitespace-separated words that match `pattern` in `text` to replace them with `replacement`. The function returns the result after the replacements.

In `pattern` the `%` symbol may appear, meaning any number of characters that match the pattern. If `%` also appears on `replacement`, the `%` is replaced with the characters matched on `pattern`.

Only the first `%` in `pattern` and `replacement` are treated this way, while the remaining ones, if any, remain unchanged.

The following example, saved on [code/16-patsubst-example](code/16-patsubst-example/)...

```Makefile
FILES = main.c foo.c bar.c
OBJS = $(patsubst %.c, %.o, $(FILES))

all:
	echo FILES = $(FILES)
	echo OBJS = $(OBJS)

.SILENT:
```

... outputs:

```
FILES = main.c foo.c bar.c
OBJS = main.o foo.o bar.o
```

> [!Note]
> The notation `$(variable-name:pattern=replacement)` is an equivalent notation. For instance, the assignment of `OBJS` could become `OBJS = $(FILES:.c=.o)`

</details>

<details>
	<summary><h4>strip</h4> - strips away whitespaces</summary>
	
```
$(strip string)
```

**Arguments**
- `string` - The string(s) to work on

Removes both leading and trailing whitespaces. Multiple whitespaces between strings are condensed into a single space.

Here's an example ([code/17-strip-example](code/17-strip-example)):

```Makefile
FILES = a           b c         # Ends here

all:
ifeq ($(FILES), a b c)
	echo "FILES == a b c"
else
	echo "FILES != a b c"
endif

ifeq ($(strip $(FILES)), a b c)
	echo "RESULT == a b c"
else
	echo "RESULT != a b c"
endif


.SILENT:
```

Output:

```Makefile
FILES != a b c
RESULT == a b c
```
</details>

<details>
	<summary><h4>findstring</h4> - looks for occurrences of a string</summary>

```
$(findstring find,in)
```

**Arguments**
- `find` - The string to look for on
- `in` - The string(s) to search on

If the text `in` contains a word identical to `find`, the function returns `find`. Otherwise, it returns the empty string.

Here's an example ([code/18-findstring-example](code/18-findstring-example)):

```Makefile
NAME = Nuno Jesus

all:
	echo Result=$(findstring Jesus, $(NAME))
	echo Result=$(findstring Miguel, $(NAME))
.SILENT:
```

Output:

```
Result=Jesus
Result=
```

</details>
<details>
	<summary><h4>words</h4> - counts the number of words</summary>

```
$(words text)
```

**Arguments**
- `text` - The string(s) to operate on

Counts the number of words in `text`.

Here's an example ([code/19-words-example](code/19-words-example)):

```Makefile
VAR = This is a very large string

all:
	echo VAR has $(words $(VAR)) words
.SILENT:
```

Output:

```
VAR has 6 words
```

</details>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

### <a name="functions-3">A4.3 - Functions for File Names</a>

The following functions were designed to handle file names or paths to files. The transformations take place in the same way for every string.

<details>
	<summary><h4>dir</h4> - extracts the directory part of a file</summary>

```
$(dir names…)
```

**Arguments**
- `names` - The string(s) to operate on

Extracts the directory part of every file contained in `names`. The directory part is considered to be all the characters until the last `/` is found (including it).

Here's an example ([code/20-dir-example](code/20-dir-example)):

```Makefile
FILES = source/foo.c source/bar.c baz.c

all:
	echo These are the directories: $(dir $(FILES))
.SILENT:
```

Output:

```
These are the directories: source/ source/ ./
```

</details>

<details>
	<summary><h4>notdir</h4> - extracts the non-directory part of a file</summary>

```
$(notdir names…)
```

**Arguments**
- `names` - The string(s) to operate on

Extracts the non-directory part of every file contained in `names`. The non-directory part is considered to be all the characters from the last `/` (not including it) to the end.

Here's an example ([code/21-dir-example](code/21-dir-example)):

```Makefile
FILES = source/foo.c source/bar.c baz.c

all:
	echo These are the files: $(notdir $(FILES))
.SILENT:
```

Output:

```
These are the files: foo.c bar.c baz.c
```

</details>

<details>
	<summary><h4>addprefix</h4> - appends a prefix to strings</summary>

```
$(addprefix prefix,names…)
```

**Arguments**
- `prefix` - The prefix to append
- `names` - The string(s) to operate on

For each reference in `names`, it appends `prefix` to it. The final result is the prefix concatenated with each reference, separated by a space between each final reference.

Here's an example ([code/22-addprefix-example](code/22-addprefix-example)):

```Makefile
FILES = foo.c bar.c baz.c
SOURCES = sources/

all:
	echo Final path: $(addprefix $(SOURCES), $(FILES))
.SILENT:
```

Output:

```
Final paths: sources/foo.c sources/bar.c sources/baz.c
```

</details>


<details>
	<summary><h4>addsuffix</h4> - appends a suffix to strings</summary>

```
$(addsuffix suffix,names…)
```

**Arguments**
- `suffix` - The suffix to append
- `names` - The string(s) to operate on

For each reference in `names`, it appends `suffix` to it. The final result is the suffix concatenated with each reference, separated by a space between each final reference.

Here's an example ([code/23-addsuffix-example](code/23-addsuffix-example)):

```Makefile
FILES = foo bar baz

all:
	echo Final object files: $(addsuffix .o, $(FILES))
.SILENT:
```

Output:

```
Final object files: foo.o bar.o baz.o
```

</details>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

### <a name="functions-4">A4.4 - Functions for Generic Purpose</a>

<details>
	<summary><h4>foreach</h4> - good old loops</summary>

```
$(foreach var,list,text)
```

**Arguments**
- `var` - The name of a variable that will work as a temporary iterator
- `list` - The string(s) to operate on
- `text` - The final transformation for each reference in `list`

For each word in `list`, `var` takes its value and gets transformed according to whatever is expanded on `text`. Both `var` and `list` are expanded before any transformation is applied.

The `var` field contains the name of a temporary variable used to reference each word inside `list`. This variable becomes undefined outside the `foreach` call.

The `text` variable is expanded as many times as there are whitespace-separated words in `list`. The multiple expansions are then concatenated with a single space to produce the final result.

The following example replicates the `addprefix` example, saved on [code/24-foreach-example](code/24-foreach-example):

```Makefile
FILES = foo.c bar.c baz.c
SOURCES = sources

all:
	echo Final paths: $(foreach file, $(FILES), $(SOURCES)/$(file))
.SILENT:
```

Output:

```
Final paths: sources/foo.c sources/bar.c sources/baz.c
```

Visual representation of the example above:

![foreach](https://github.com/Nuno-Jesus/Make-A-Make/assets/93390807/02d0b529-1fb6-4d45-9591-49275ddf0c8b)

</details>

<details>
	<summary><h4>shell</h4> - using shell commands</summary>

```
$(shell command)	
```

**Arguments**
- `command` - The string(s) to operate on

The `shell` function has a particular behavior. It's responsible to communicate with the environment outside `make`, invoke a shell and execute a command, just like what happens in a recipe. The result is then returned and replaced wherever the function was called. Newlines are replaced with a single space.

The `command` parameter is the command that should be run in the shell, alongside its arguments.

The following example detects and prints the current kernel ([code/25-shell-example](code/25-shell-example)):

```Makefile
OS = $(shell uname -s)

all:
	echo $(OS)	
.SILENT:
```

Output:

``` shell
Linux
```

</details>

<details>
	<summary><h4>call</h4> - call your own defined functions</summary>

```
$(call variable,param,param,…)
```


**Arguments**
- `variable` - the name of the function to call. 
- `param` - strings that will serve as arguments of the function defined in `variable`.

If you're constantly writing the same complex expressions, you can define a function of your own and assign it the expression. On expansion time, each `param` is assigned to the temporary variables `$(1)`, `$(2)`, etc. As for `$(0)` it receives the value of `variable`.

Let's assume you need to compile a few sub-Makefiles. You also want to keep track of the progress using some custom messages. Something like this:

```Makefile
all:
	echo "Compiling folder-1"
	$(MAKE) -C folder-1

	echo "Compiling folder-2"
	$(MAKE) -C folder-2

	echo "Compiling folder-3"
	$(MAKE) -C folder-3
```

The example below, saved on [code/26-call-example](code/26-call-example) refactors the Makefile above by defining an expression that holds both the `echo` and the `make` commands:

```Makefile
SUBFOLDERS = folder-1 folder-2 folder-3

define compile
	$(info Compiling $(1))
	$(MAKE) -C $(1)
endef

all:
	$(foreach folder, $(SUBFOLDERS), $(call compile,$(folder)))

```

Although it might be confusing, the example above simply automates the tasks manually written before. It iterates through the list of subfolders where the Makefiles are and calls the commands to both log and compile.

</details>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

------------------------------------------------------------------



## <a name="vpath">A5 - The vpath directive</a>

It's exhausting to manually assemble and write the relative path of files. Assuming you stored some source files in a `nc_utils` folder and your Makefile is right next to that folder...

	├── ... 
	├── nc_utils
		├── nc_clamp.c
		├── nc_count.c
		├── nc_free.c
		├── nc_numlen.c
		├── main.c
	└── Makefile

...you would have to either write those paths down...

```Makefile
SOURCES = nc_utils/nc_clamp.c \
          nc_utils/nc_count.c \
          nc_utils/nc_free.c \
          nc_utils/nc_numlen.c \
          nc_utils/main.c
```

...or make use of some built-in Makefile function...

```Makefile
SOURCES = nc_clamp.c nc_count.c nc_free.c nc_numlen.c main.c
SOURCES := $(addprefix utils/, $(SOURCES))
```

The first approach is, obviously, **not scalable**. Despite the second looking more friendly, how much more do you have to add if the source files are placed among multiple folders? (this is the directory tree from [my C library](https://github.com/Nuno-Jesus/42_libnc))

	├── ...
	├── nc_binary_search_tree/
	├── nc_conversions/
	├── nc_dictionary/
	├── nc_is/
	├── nc_linked_list/
	├── nc_matrix/
	├── nc_memory/
	├── nc_pair/
	├── nc_print/
	├── nc_str/
	├── nc_utils/
	├── nc_vector/
	├── Makefile
	└── ...

Or even sub-folders? The `addprefix` solution doesn't seem so friendly anymore!

The `vpath` directive offers a more flexible approach. This directive states what directories `make` should search on. Thus, if any pre-requisite or target is not found on the same directory level as your Makefile, `make` will search on that list of directories for a file with that name.

The most common syntax for `vpath` is down below:

```Makefile
vpath pattern directories
```

- `pattern` - a string containing most often a `%` to match a sequence of characters. If `%` is not present, the `pattern` must match the exact name of a file (quite useless)

- `directories` - a list of directories to search on by files that match `pattern`

Using `vpath` simplifies the search of source files in `nc_utils`:

```Makefile
SOURCES = nc_clamp.c nc_count.c nc_free.c nc_numlen.c main.c

vpath %.c nc_utils
```

Adding more folders into play is a simple matter of adding the source files' names and a new directory to the `vpath` directive. Example with string functions:

```Makefile
SOURCES =  nc_clamp.c nc_count.c nc_free.c nc_numlen.c
SOURCES += nc_strlen.c nc_strncmp.c nc_substr.c
SOURCES += main.c

vpath %.c nc_utils nc_str
```

You can find the example above in [code/27-vpath-example](code/27-vpath-example).

There is also a Makefile implicit `VPATH` variable that serves the same purpose. However, it does not allow you to specify a pattern. One could re-write the `vpath` directive like this:

```Makefile
VPATH = nc_utils nc_str
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------



# <a name="useful-topics">Useful Topics</a>

I don't think those topics fit either in the beginner's guide or in the advanced topics. However, I think they are useful to know and can be used to improve your Makefiles.

## <a name="special-targets">Special Targets</a>
There are a few special targets that can be used in a Makefile. These targets are not files but, rather commands that can be executed by the Makefile. Please note that these are not all the targets, but rather only the ones I use the most/are more useful.

- `.SILENT` - Disables the default logging of Make actions in the terminal. If used with prerequisites, only those targets are executed silently.

```Makefile
.SILENT: all
```

Otherwise, if used without prerequisites, all targets are executed silently.

```Makefile
.SILENT:
```

- `.PHONY` - used to tell the Makefile to not confuse the names of the targets with filenames. For instance, if `clean` is considered phony...

```Makefile
.PHONY: clean
```

...the Make will always execute the `clean` rule, even if a file named `clean` exists.

- `.DEFAULT_GOAL` - used to define what is the primary target of the Makefile. If not specified, the first target is chosen by default.

```Makefile
.DEFAULT_GOAL: clean
```

The example above would set the clean target to execute by default when running `make`.

- `.NOTPARALLEL` - executes the Makefile in a single thread, even if the -j flag is used. If used with prerequisites, only those targets are executed sequentially.

```Makefile
.NOTPARALLEL: fclean
```

Otherwise, if used without prerequisites, all targets are executed sequentially.

```Makefile
.NOTPARALLEL:
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## <a name="flags">Makefile Flags</a>

- `-C <dir>` - used to recursively call another Makefile `<dir>`. The syntax is as follows: `make [target] -C <dir>`. The `target` field can be omitted You can find an example of this in the [code/07-C-flag-example](/code/07-C-flag-example).

```Makefile
all:
	$(MAKE) -C hello/
	$(CC) main.c hello/hello.c
```

```shell
➜  example-7 git:(master) ✗ make  
make -C hello/
make[1]: Entering directory '/nfs/homes/ncarvalh/...'
cc -Wall -Werror -Wextra -c hello.c -o hello.o
make[1]: Leaving directory '/nfs/homes/ncarvalh/...'
cc -Wall -Werror -Wextra main.c hello/hello.c -o project
➜  example-7 git:(master) ✗
```

When <code>make -C</code> is issued, it forces a directory change towards the sub-Make directory. After the sub-Make is done executing, the directory is changed back to the original Make to continue execution.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `-k` - Usually, when an error happens, the Make aborts execution immediately. Using this flag, the Make is forced to attempt executing further targets. If you need an error list, this flag is for you. You can find an example of this in the [code/08-k-flag-example](/code/08-k-flag-example).

```shell
➜  example-8 git:(master) ✗ make  
cc -Wall -Werror -Wextra -c hello.c
make: *** No rule to make target 'bye.o', needed by 'project'.  Stop.
➜  example-8 git:(master) ✗  
```
```shell
➜  example-8 git:(master) ✗ make -k  
cc -Wall -Werror -Wextra -c hello.c
make: *** No rule to make target 'bye.o', needed by 'project'.
make: *** No rule to make target 'highfive.o', needed by 'project'.
make: Target 'all' not remade because of errors.
➜  example-8 git:(master) ✗
```

Even though <code>bye.o</code> can not be remade, the Makefile attempts to fulfill the next pre-requisite, which also fails, not aborting execution though.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `-p` - Dumps the whole database of known variables and rules (both explicit and implicit). The output is quite extensive, so I'll only display a small portion of it. For demonstration purposes, we're re-using the [code/06-relinking-example](/code/06-relinking-example) folder.

```shell
➜  example-6 git:(master) ✗ make -p
...
# environment
DBUS_SESSION_BUS_ADDRESS = unix:path=/run/user/101153/bus
# Makefile (from 'Makefile', line 1)
CC = cc
# Makefile (from 'Makefile', line 5)
OBJS = hello.o bye.o highfive.o
...
➜  example-6 git:(master) ✗
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `-s` - Disables the default logging of Make actions in the terminal. Works just like the `.SILENT` special target/ For demonstration purposes, we're re-using the [code/06-relinking-example](/code/06-relinking-example) folder.

```shell
➜  example-6 git:(master) ✗ make       
cc -Wall -Werror -Wextra -c hello.c
cc -Wall -Werror -Wextra -c bye.c
cc -Wall -Werror -Wextra -c highfive.c
cc -Wall -Werror -Wextra main.c hello.o bye.o highfive.o -o project
➜  example-6 git:(master) ✗
```

```shell
➜  example-6 git:(master) ✗ make -s
➜  example-6 git:(master) ✗
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `-r` - Tells the Makefile to ignore any built-in rules. In the example below, we simply omit the rule for compiling C files. You can find an example of this in the [code/09-r-flag-example](/code/09-r-flag-example). 

```shell
➜  example-9 git:(master) ✗ make       
cc -Wall -Werror -Wextra   -c -o hello.o hello.c
cc -Wall -Werror -Wextra main.c hello.o -o project
➜  example-9 git:(master) ✗       
```

```shell
➜  example-9 git:(master) ✗ make -r       
make: *** No rule to make target 'hello.o', needed by 'project'.  Stop.
➜  example-9 git:(master) ✗       
```

Because we removed the explicit rule for compiling C files, the compilation must be done using an implicit rule. However, using the <code>-r</code>, all implicit rules are not considered, so there's no way of generating <code>hello.o</code>.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `-j [number of threads]` - Takes advantage of threads to speed up the Makefile execution. The number of threads is optional. You can find an example of this in the [code/10-j-flag-example](/code/10-j-flag-example).

When using the `-j` flag, the Makefile will execute the targets in parallel, which doesn't guarantee the order of execution. So a rule designed like this...

```make
fclean: clean all
```

... would perform `clean` and `all` at the same time, which can cause weird outputs. You can either re-write it...

```make
fclean: clean
	$(MAKE) all
```

... or use the `.NOTPARALLEL` special target, which disables parallel execution of targets and their dependencies.

```make
.NOTPARALLEL: fclean
fclean: clean all
```

```shell
➜  example-10 git:(master) ✗ time make    
cc -Wall -Werror -Wextra -c hello.c
cc -Wall -Werror -Wextra -c bye.c
cc -Wall -Werror -Wextra -c highfive.c
cc -Wall -Werror -Wextra -c hug.c
cc -Wall -Werror -Wextra -c kiss.c
cc -Wall -Werror -Wextra -c handshake.c
cc -Wall -Werror -Wextra -c wave.c
cc -Wall -Werror -Wextra main.c hello.o bye.o highfive.o hug.o ...
make  0.10s user 0.06s system 84% cpu 0.185 total
➜  example-10 git:(master) ✗
```

```shell
➜  example-10 git:(master) ✗ time make -j  
cc -Wall -Werror -Wextra -c hello.c
cc -Wall -Werror -Wextra -c bye.c
cc -Wall -Werror -Wextra -c highfive.c
cc -Wall -Werror -Wextra -c hug.c
cc -Wall -Werror -Wextra -c kiss.c
cc -Wall -Werror -Wextra -c handshake.c
cc -Wall -Werror -Wextra -c wave.c
cc -Wall -Werror -Wextra main.c hello.o bye.o highfive.o hug.o ...
make -j  0.12s user 0.06s system 235% cpu 0.076 total
➜  example-10 git:(master) ✗
```

The <code>time</code> command is only used to read the CPU load and execution time.

> [!Note]
> When recursively calling make, the parallel computation is not imposed in sub-Makes unless you use the `$(MAKE)` variable. You also don't need to use the <code>-j</code> flag in the sub-Make, since you would launch N more threads, which you don't really need to.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `-n` - Displays the commands the Makefile would run without actually executing it.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `--debug` - Executes and displays how dependencies are resolved. For demonstration purposes, we're re-using the [code/09-r-flag-example](/code/09-r-flag-example) folder.

```shell
➜  example-9 git:(master) ✗ make
cc -Wall -Werror -Wextra   -c -o hello.o hello.c
cc -Wall -Werror -Wextra main.c hello.o -o project
➜  example-9 git:(master) ✗
```

```shell
➜  example-9 git:(master) ✗ make --debug
...
Reading makefiles...
Updating makefiles....
Updating goal targets....
 File 'all' does not exist.
   File 'project' does not exist.
     File 'hello.o' does not exist.
    Must remake target 'hello.o'.
cc -Wall -Werror -Wextra   -c -o hello.o hello.c
    Successfully remade target file 'hello.o'.
  Must remake target 'project'.
cc -Wall -Werror -Wextra main.c hello.o -o project
  Successfully remade target file 'project'.
Must remake target 'all'.
Successfully remade target file 'all'.
➜  example-9 git:(master) ✗
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>

- `--no-print-directory` Disables message printing whenever the Makefile enters or exits a directory. For demonstration purposes, we're re-using the [code/07-C-flag-example](/code/07-C-flag-example) folder.

```shell
➜  example-7 git:(master) ✗ make
make -C hello/
make[1]: Entering directory '/nfs/homes/ncarvalh/...'
cc -Wall -Werror -Wextra -c hello.c -o hello.o
make[1]: Leaving directory '/nfs/homes/ncarvalh/...'
cc main.c hello/hello.c
➜  example-7 git:(master) ✗
```

```shell
➜  example-7 git:(master) ✗ make --no-print-directory
make -C hello/
cc -Wall -Werror -Wextra -c hello.c -o hello.o
cc main.c hello/hello.c
➜  example-7 git:(master) ✗
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>

- `-I <dir>` - specifies a directory to search for included Makefiles. Useful to prevent building the path to the dependencies. You can find an example of this in the [code/13-I-flag-example](/code/13-I-flag-example).

```shell
➜  13-I-flag-example git:(advanced-topics) ✗ make          
Makefile:18: main.d: No such file or directory
make: *** No rule to make target 'main.d'.  Stop.
➜  13-I-flag-example git:(advanced-topics) ✗ make -I teste 
cc -Wall -Werror -Wextra   -c -o main.o main.c
cc -Wall -Werror -Wextra main.o -o a.out
➜  13-I-flag-example git:(advanced-topics) ✗ 
```

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
<br>


------------------------------------------------------------------ 


## <a name="errors">Good-to-know Errors</a>

	Makefile: *** missing separator.  Stop.

`make` is very strict when it comes to its syntax. Whether it's reading a rule, a variable assignment or a target, `make` looks for separators like `:`, `=` or tabulations. So probably you're missing one of those.

	Makefile: *** missing separator (did you mean TAB instead of 8 spaces?).  Stop.

This one is derived from the first. You can get this message if you're attempting to replace tabs with spaces.

	make: *** No rule to make target X.  Stop.

This is probably one of the most common errors. It means `make` was trying to build something called `X`, but couldn't find an explicit or implicit rule to do so. It can be caused due to a typo, wrong pattern matching rules (when using `%`), or missing files.

	Makefile: *** recipe commences before first target.  Stop.

This means that when `make` was trying to parse your Makefile, it found something that looks like a recipe but doesn't start with a target. Remember that rules must always have a target.

	warning: overriding recipe for target 'X'

Happens whenever you define 2 or more recipes for the same target. This will force `make` to override the previous recipes with the last one.

	Circular X <- Y dependency dropped.

This means `make` detected a loop when parsing the prerequisites of its rules. Supposing you have something like this...

```Makefile
	X: Y ...
		...
```

... where `X` depends on `Y`. After tracing `Y` and its prerequisites, the `make` reached a point where it found a target depending on `X`.

	Unterminated variable reference. Stop.

If you received this message, you're missing a parenthesis/brace when using a variable. Remember that the correct syntax to use a variable's value is either `$(NAME)` or `${NAME}`.

	Makefile: *** missing 'endif'.  Stop.

Self-explanatory, you forgot to add an `endif` directive to your conditional.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


------------------------------------------------------------------


## 📞 **Contact me**
Feel free to ask me any questions through Slack (**ncarvalh**).

<!--

## <a name="index-4">The vpath directive and project organization</a>

## <a name="index-4">Questions</a>
## <a name="index-4">General tips</a>
- Group up common stuff: variables with variables, rules with rules. Mixing it up might turn your Makefile confusing.
- Comment your Makefile and delimit different sections. If your Makefile is out of this world, you should comment it. Its good for you and the others.
- Want to silent commands, but not all of them? Write a '@' before each command to silent it.
- You can append strings to variables by using the '+=' operator
- As I said before, Makefiles have a wide use case range. You can create rules to avoid writing repeating and large commands, like valgrind.
- Compiling a Makefile with another Makefile? Don't use make directly. Instead use $(MAKE), which expands to the same value. Might seem pointless, but some flags might depend on in. The $(MAKE) variables tells the Makefile we are calling another Makefile.
- Using the '\' operator at the end of the line forces the Makefile to consider the next line as a continuation of the first. Essentially a one line only.
- Avoid repetition. Use functions when you can

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>
-->
