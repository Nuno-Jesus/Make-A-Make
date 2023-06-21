# Makefile Tutorial

## Description
This README was developed mainly to help 42 students to clear the fog around Makefiles and how they work. But, it will be for sure helpful to anyone out there struggling as well. 

It starts with a beginner's guide, followed up by some medium-advanced concepts.

## <a name="index-0">Index</a>
<ul>
	<li>Beginner's guide</li>
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
	<li>Advanced topics</li>
	<ul>
		<li><a href="#builtin-targets">Builtin Targets</a></li>
		<li><a href="#if-directives">The ifdef, ifndef, ifeq, ifneq directives</a></li>
		<li><a href="#functions">Functions</a></li>
		<li><a href="#command-line">Command line variables</a></li>
		<li><a href="#vpath">The vpath directive</a></li>
	</ul>
	<li>Tips and tricks</li>
	<ul>
		<li><a href="#organize-project">Organize your project with vpath</a></li>
		<li><a href="#variable-operators">Other variable related operators</a></li>
		<li><a href="#activate-debug">Activate debug commands/flags with conditionals</a></li>
		<li><a href="#general-tips">General tips</a></li>
	</ul>
	<li><a href="#flags">Useful flags</a></li>
	<li><a href="#errors">Typical errors</a></li>
</ul>


<!-- ------------------------------------------------------------------ -->


## <a name="index-1">1. What is make?</a>
The `make` utility is an automatic tool capable of deciding which commands can / should be executed. The `make` utility is mostly used to automate the compilation process, preventing manual file-by-file compilation. This utility is used through a special file called `Makefile`.

For this guide, we'll only dispose of a C project.


<!-- ------------------------------------------------------------------ -->


## <a name="index-2">2. An introduction to Makefiles</a>
Typically, a Makefile is called to handle the compilation and linking of a project and its files. The Makefile uses the modification times of participating files to assert if re-compilation is needed or not.

For instance, when compiling a `C` project, the final executable file, would be the zipped version of every `.o` file, which was in turn created from the `.c` files.

Let's create a simple project to work with.

	├── hello.c 
	├── main.c
	└── Makefile

You can find these files in the [code/example-1](/code/example-1/) folder.

<!-- ------------------------------------------------------------------ -->


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

> **Note**: $(MAKE) is a variable which expands to `make`. We'll see more about variables up ahead.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


<!-- ------------------------------------------------------------------ -->


## <a name="index-4">4. A simple Makefile</a>
The Makefile below is capable of compiling our example project. You can find it in the [code/example-1](/code/example-1/) folder.

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

> **Warning**
> If the `<target>` field is ommited, the Makefile will execute the first rule. And yes, this example is not doing that, the primary rule should be 'all'.

You should see something like this on the terminal:

	cc -c hello.c
	cc main.c hello.o

This is great! The compilation worked out and finally, we can execute our program and use our `hello` function! But what if one wanted to compile `N` more files? Would they need to create `N` more rules?


<!-- ------------------------------------------------------------------ -->


## <a name="index-4.1">4.1. Dependencies and rules processing</a>
Consider a portion of the previous Makefile:

```Makefile
all: hello.o
	cc main.c hello.o

hello.o: hello.c
	cc -c hello.c
```

The `make` command will read the current Makefile and process the first rule. Before executing `all` it must process `hello.o` since it is a dependency.

The recompilation of the `hello.o` must be done if either `hello.o` does not exist or `hello.c` was changed since the last `hello.o` file was created. In the first time, there is no `hello.o` file, so it must be generated.

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


<!-- ------------------------------------------------------------------ -->


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

> **Note**: the naming convention for variables is uppercase, to distinguish from Makefile rules.

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

A naive solution would be to create more rules. You can find the code in the [code/example-2](/code/example-2/) folder:

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

But this is ugly and unnecessary since the pattern is always the same. Let us use the newly learn variables to clean this up! You can find the code in the [code/example-3](/code/example-3/) folder:

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

> **Note**: have you have ever run `make -p > logs` ? Neither did I, but it's pretty useful! Detailed explanation on this in an upcoming section.

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


<!-- ------------------------------------------------------------------ -->


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

You can find the code in the [code/example-4](/code/example-4/) folder:
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


<!-- ------------------------------------------------------------------ -->


## <a name="index-7">7. Towards a more flexible Makefile</a>

We are reaching the end of the tutorial! This section is all about polishing what we've developed so far. There will be (much) more content after this section, but it's up to you to go further. 

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>

<!-- ------------------------------------------------------------------ -->


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

After a few hours, you realized your code is not that clean and you need a more secure compilation (compilation flags). You also want to name your executable `project`. For both situations, we can define variables to avoid unnecessary repetition. You can find the code in the [code/example-5](/code/example-5/) folder.
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

> **Note**: The `-o` flag signals the compiler, to specify the name the executable will have.

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


<!-- ------------------------------------------------------------------ -->


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


<!-- ------------------------------------------------------------------ -->


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
			<td>Useful when multi-jobs of makefile come into play. This will be explained later in detail in an upcoming section, but keep in mind this is the best way of calling make targets inside the Makefile</td>
		</tr>
	</tbody>
</table>

<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>


<!-- ------------------------------------------------------------------ -->


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
You can find the code in the [code/example-6](/code/example-6/) folder.
This version does the same job as before. The main difference lies in the new dependency of `all`. The first compilation will assert the project executable is not a file, so it must be remade through the `$(NAME)` rule. In the second run, however, since the `project` file was created before, the dependency is fulfilled and the Makefile directly attempts to execute the `all` recipe. Since it's empty and no other recipes were run, you'll get this message:

	make: Nothing to be done for 'all'.

And there you have it! I hope this beginner's guide cleared a bit of your doubts. If you're not a beginner (or don't want to be one anymore), I advise you to check the contents up ahead. Many of those might be useful to change and upgrade your Makefiles!


<div align=center>
	<strong><a href="#index-0">🚀 Go back to top 🚀</a></strong>
</div>

## <a name="index-8">Advanced Topics</a>
> Still in development...

<!--

## <a name="index-4">Builtin target names</a> 
.SILENT: silences all the commands printed on the output
.PHONY: used to tell the Makefile to not confuse the names of the targets with filenames. For instance, having a file called `hello`, should not enter in conflict with the `hello` rule
.DEFAULT_GOAL: used to define what is the primary target of the makefile. For instance, even if the clean rule is not the first, if defined in this macro, it will be executed when running solely 'make'.
	

## <a name="index-4">The ifdef, ifndef, ifeq, ifneq directives</a>

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
## <a name="index-4">General tips</a>
- Group up common stuff: variables with variables, rules with rules. Mixing it up might turn your makefile confusing.
- Comment your makefile and delimit different sections. If your Makefile is out of this world, you should comment it. Its good for you and the others.
- Want to silent commands, but not all of them? Write a '@' before each command to silent it.
- You can append strings to variables by using the '+=' operator
- As I said before, Makefiles have a wide use case range. You can create rules to avoid writing repeating and large commands, like valgrind.
- Compiling a Makefile with another Makefile? Don't use make directly. Instead use $(MAKE), which expands to the same value. Might seem pointless, but some flags might depend on in. The $(MAKE) variables tells the Makefile we are calling another Makefile.
- Using the '\' operator at the end of the line forces the Makefile to consider the next line as a continuation of the first. Essentially a one line only.
- Avoid repetition. Use functions when you can

- In this Makefile, what does the $(SRCS:.c=.o) do?


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
-->

## <a name="tips"> General tips</a>
> Still in development...

## <a name="flags"> Useful flags</a>
- `-C <dir>`: used to recursively call another makefile `<dir>`. The syntax is as follows: `make <target> -C <dir>`. You can find an example of this in the [code/ example-7](/code/example-7).

<!-- A table with two columns displaying an example and the output -->
<table>
	<tr>
		<th>Example</th>
		<th>Output</th>
	</tr>
	<tr>
		<td>
<pre>
all:
	$(MAKE) -C hello/
	$(CC) main.c hello/hello.c
</pre>
		</td>
		<td>
<pre>
make -C hello/
make[1]: Entering directory '/nfs/homes/ncarvalh/Programming/make-a-make/code/example-7/hello'
cc -Wall -Werror -Wextra -c hello.c -o hello.o
make[1]: Leaving directory '/nfs/homes/ncarvalh/Programming/make-a-make/code/example-7/hello'
cc -Wall -Werror -Wextra main.c hello/hello.c -o project
</pre>
		</td>
	</tr>
	<tr>
		<td colspan=2>When the <code>make -C</code> command is issued, it forces a directory change towards the sub-Makefile directory. After the sub-Makefile is done executing, the directory is changed back to continue execution.</td>
	</tr>
</table>


- `-k` Continue as much as possible after an error occurred. Even though the error occurred, the makefile will continue to execute the other targets. This is useful when you want to know all the errors that occurred in the makefile. You can find an example of this in the [code/example-8](/code/example-8).

<table>
	<tr>
		<th>Example</th>
		<th>Output</th>
	</tr>
	<tr>
		<td>
<pre>
make
</pre>
		</td>
		<td>
<pre>
cc -Wall -Werror -Wextra -c hello.c
make: *** No rule to make target 'bye.o', needed by 'project'.  Stop.
</pre>
		</td>
	</tr>
	<tr>
		<td>
<pre>
make -k
</pre>
		</td>
		<td>
<pre>
cc -Wall -Werror -Wextra -c hello.c
make: *** No rule to make target 'bye.o', needed by 'project'.
make: *** No rule to make target 'highfive.o', needed by 'project'.
make: Target 'all' not remade because of errors.
</pre>
		</td>
	</tr>
	<tr>
		<td colspan=2>Even though the <code>bye.o</code> can not be remade, the Makefile attempts to fulfill the next pre-requisite, which also fails.</td>
	</tr>
</table>

- `-p` Displays all known rules (both explicit and implicit) and variables to the current Makefile.

<table>
	<tr>
		<th>Example</th>
		<th>Output</th>
	</tr>
	<tr>
		<td>
<pre>
make -p
</pre>
		</td>
		<td>
<pre>
...
# environment
VSCODE_INJECTION = 1
# environment
XDG_DATA_DIRS = /usr/share/gnome:/usr/share/ubuntu:/nfs/homes/ncarvalh/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share:/var/lib/snapd/desktop
# environment
DBUS_SESSION_BUS_ADDRESS = unix:path=/run/user/101153/bus
# makefile (from 'Makefile', line 1)
CC = cc
# makefile (from 'Makefile', line 5)
OBJS = hello.o bye.o highfive.o
# default
CHECKOUT,v = +$(if $(wildcard $@),,$(CO) $(COFLAGS) $< $@)
# environment
TERMINATOR_UUID = urn:uuid:e4859a76-e335-4e1b-857f-c9d5ad3db53e
# default
CPP = $(CC) -E
...
</pre>
		</td>
	</tr>
</table>

- `-s` Turns off printing of the makefile actions in the terminal
- `-r` Tells the makefile to ignore any builtin rules
- `-j [number of threads]` Allows parallel computation of makefile actions. Needs $(MAKE) to work properly.
- `-n` Displays the commands the makefile would run without actually running them
- `--debug` Displays the thinking process of the makefile before executing any targets
- `--no-print-directory` Disables message printing whenever the makefile enters or exits a directory

## <a name="errors"> Typical errors</a>
> Still in development...

## 📞 **Contact me**
Feel free to ask me any questions through Slack (**ncarvalh**).
