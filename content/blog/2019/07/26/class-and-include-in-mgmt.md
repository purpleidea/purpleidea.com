---
date: 2019-07-26 06:35:00-04:00
title: "Mgmt Configuration Language: Class and Include"
description: "Class and Include statements in the Mgmt Configuration Language"
categories:
  - "technical"
tags:
  - "class"
  - "devops"
  - "dsl"
  - "frp"
  - "include"
  - "mcl"
  - "mgmt"
  - "mgmtconfig"
  - "planetfedora"

draft: false
---

It's been a little over a year since I introduced the
[Mgmt Configuration Language](/blog/2018/02/05/mgmt-configuration-language/). A
lot has happened since then, and I'd like to introduce some of the missing
features that weren't available when the language was first introduced. If you
haven't already read that [post](/blog/2018/02/05/mgmt-configuration-language/),
please start there and come back when you're finished. In this article we'll
learn about classes.

{{< blog-paragraph-header "Classes" >}}

You might remember that the [_mgmt_](https://github.com/purpleidea/mgmt/)
language called `mcl` has both `statements`, and `expressions`. Statements
ultimately produce the `resources` and `edges` that make up our output graph,
and expressions produce the values (strings, integers, lists, etc) that make up
the inputs to those statements.

As it turns out, it's useful to have a grouping construct for statements to make
them composable. That grouping construct is called the class statement. It looks
like this:

```mcl
# define a class named foo
class foo {
	pkg "cowsay" {
		state => "installed",
	}
	# you can add any number of statements in here...
}
```

To use a class statement, you reference a defined class by using the `include`
statement. This causes the scoped contents of the class definition to
"empty out" into the scope of the `include`. It looks like this:

```mcl
# it's now as if the resources and edges in the class were typed here
include foo
```

I think this is pretty straightforward.

{{< blog-paragraph-header "Class Scope Capture" >}}

One interesting thing about classes is that they can capture scope. Examine the
following:

```mcl
$x1 = "t1" # this variable gets captured by bar
class bar {
	print $x1 {} # captures variable in the parent scope
}
include bar
```

In this scenario, when the class is defined, you'll see that it "captures" the
`$x1` variable from the parent scope. Later on when the class is `include`-ed,
it builds the `print` resource with the original `$x1` variable.

You might assume that we're lazy and we actually just use the `$x1` variable
that exists in the same scope, but if you experiment, you'll find that we
actually "do the right thing". As an example, assume the following two files:

```mcl
# whatever.mcl

$x1 = "t1"
class baz {
	print $x1 {}
}
```

and

```mcl
# main.mcl

import "whatever.mcl"

$x1 = "bad1" # this isn't consumed anywhere
include whatever.baz
```

If we run `main.mcl`, you'll see that it uses an imported class that was defined
in a different scope, and in fact, it retains the `$x1` from that original scope
where it was created. Don't worry that you haven't seen `import` yet, we'll get
to that shortly.

{{< blog-paragraph-header "Parameterized Classes" >}}

It would be unfortunate if class definitions were only "single-use", and it
would also be unfortunate if you couldn't mix the local scope into a class when
you `include` it. As a result, classes can be "parameterized". They look like
this:

```mcl
class fruit($colour, $shape) {
	print $x1 {}
	if $colour == "red" && $shape == "round" {
		print "i am a tomato" {}
	} else {
		$n1 = "i am a " + $shape + " shaped fruit that's " + $colour
		print $n1 {}
	}
}

include fruit("red", "round")
include fruit("red", "round") # de-duplication happens at the resource level
include fruit("blue", "round")
```

As you can see, we can `include` the class multiple times, and produce multiple
resources. If for some reason we end up producing identical (or more
specifically, compatible) resources, then they are de-duplicated by the resource
engine, and are not compile errors. This solves a well-known issue (I say bug)
with the _Puppet_ tool. (This works correctly in _mgmt_ and avoids the headaches
with two different modules requiring the same package dependency.)

{{< blog-paragraph-header "Typed Parameterized Classes" >}}

When you define a class, you may also specify some type restrictions on the
parameters. By default when you do not specify the type of a value, it is
determined automatically by the type unification engine. This is the recommended
way to use _mgmt_. You may add an additional type rule to the class parameters
if you'd like. It looks like this:

```mcl
import "fmt"

# specifying a fixed type for $b is a compile error, because it's sometimes str!
class c1($a, $b []str) { # note that we specified the type of $b
	print $a {
		msg => fmt.printf("len is: %d", len($b)),
	}
}

# note that the class can have two separate types for $b
include c1("t1", [13, 42, 0, -37,]) # len of second arg is 4
include c1("t2", "hello") # len of second arg is 5
```

In this case you can see that while the code *could* allow more than one
different type for the `$b` parameter, it was restricted to only allow `[]str`
(a list of strings) and as a result, the above code won't compile. It's good to
know that these kinds of issues are always found at _compile_ time, and not at
_runtime_. Once the program has compiled successfully, it always runs safely.

To get this to compile, you can either remove the type specification, or you can
remove the last line. If you remove the type specification, compile it, and look
at the internals, you might notice that the `c1` class is actually polymorphic
before compile time, but afterwards at runtime every single variable and value
has a single static type.

{{< blog-paragraph-header "Shadowed Variables" >}}

The _mgmt_ language is designed to be very safe. This is important because when
using a powerful, higher-level tool, you don't want a simple programming error
to cause you to destroy an entire data-center, or triple your `aws:ec2` bill.
As a result many common bugs are prevented at compile-time. Consider the
following:

```mcl
$x1 = "hello"
$x1 = "world" # compile-time error
print $x1 {}
```

As you can see in the above example, variable re-assignment is not permitted,
and as a result, that code will not compile. Variable shadowing however, *is*
permitted, because it has many useful implications. It looks like this:

```mcl
$msg = "nobody" # won't get used

class shadowme($x1, $msg) {
	print "message" {
		msg => $x1 + $msg,
	}
}

include shadowme("hello", "world")
```

It's important that the class author be able to define their own variables, and
as a result, they're in charge of their own scope. The class parameter `$msg`
shadows the global var, and is what is actually used. As a quick quiz, consider
this example. What message will be printed?

```mcl
$msg = "a"
class shadowme($msg) {
	$msg = "d"
	if true {
		$msg = "c"
		print "shadowed" {
			msg => $msg,
		}
	}
}

include shadowme("b")
```

If you think you've got it all figured out, what do you think this will print?
Getting the answer is easy, telling me why is more important.

```
$msg = "a"
class shadowme($msg) {
	$msg = "c"
	if true {
		$msg = "d"
	}
	print "shadowed" {
		msg => $msg,
	}
}

include shadowme("b")
```

While it is possible to write the above code, it's probably not considered good
practice. Avoid using shadowing wherever possible, to avoid confusing the user.
The answer for the above two problems was "c".

{{< blog-paragraph-header "Nested Classes" >}}

In case it's not implied, you should know that classes can be nested. The
following is perfectly valid code:

```mcl
class outside {
	class inside {
		print "hello" {}
	}
	include inside
}
include outside
```

It's also worth mentioning that the following code will _not_ compile:

```mcl
class outside {
	class inside {
		print "hello" {}
	}
}
include outside
include inside # the inside class is not in scope here, so this fails
```

We can't generate new classes to appear in scope from the `include` of a parent
class. As an example, the following is also invalid, and won't compile:

```mcl
class outside($b) {
	if $b {
		class inside {
			print "hello" {}
		}
	}
}
include outside(true)
include inside # the inside class is not in scope here, so this fails
```

While this might seem unfortunate, it's actually an important consequence of
understanding the statement scope in general. The statement scope includes the
classes and variables that exist at that time, and at compile time, they're
bindings (data flow mappings) are static. Consider the following code:

```mcl
$foo = "a"

class weird($cond) {
	$foo = "b"
	if $cond {
		$foo = "c"
	}
	print "hello" {}
}
include weird(true) # instead of a constant, this value could change over time

print "world" {
	msg => $foo,
}
```

What does this print? While this code is valid and compiles, it must print "a".
If it didn't, it would mean the variable binding could change over time, which
would be very complex, and error prone. For a declarative DSL, this isn't a net
positive in my opinion. To do so would require a "higher-order" FRP.

{{< blog-paragraph-header "Recursive Classes" >}}

For similar reasons to what was just mentioned, classes can't be recursive. You
can `include` other classes inside your class, but the chain must terminate
statically. The following code is valid:

```mcl
class c1($m) {
	print $m {}
}

class c2 {
	include c1("hello")
	print "world" {}
}

include c1("this is a test...")
include c2
```

The following code is *not* valid:

```mcl
class c1($cond) {
	print "nope" {}
	if $cond {
		include c1(false)
	} else {
		print "done" {}
	}
}
include c1(true)
```

While it appears that it would terminate and be a "safe" program, for the
reasons I mentioned above, the compiler will catch this and forbid it at compile
time. Also not allowed:

```mcl
class c1 {
	include c2
}
class c2 {
	include c1
}
```

This all helps prevent a common cause of bugs in programs: non-terminating
programs that infinitely recurse. Iteration is not always your friend. But our
compiler will be.

{{< blog-paragraph-header "Light Copies" >}}

When you `include` a class, it effectively copies the contents and dumps them
out in the requested location. You might think that this gets expensive quickly,
but in fact it is quite efficient. Consider the following code:

```mcl
$big_data = "Now this is a story, all about how, my code got..."
class lyrics($in) {
	print "${in}" {
		msg => "lyrics: " + $big_data,
	}
}

include lyrics("fresh code")
include lyrics("fresh rhymes")
```

Here's a graph of the data flows that the function engine will run:

{{< blog-image src="graph1.png" caption="The function engine data flows of the above code. Notice how the raw value of the $big_data string only appears once." scale="100%" >}}

Even though the `$big_data` variable gets pulled into the `lyrics` class for
each invocation, the initial copy is the only one that's used in the function
graph. This is because we perform an intelligent "light copy" when running
`include`, and anything that is a bound constant, remains that way. Enjoy the
memory gains!

{{< blog-paragraph-header "Statement Ordering" >}}

As I mentioned in the [earlier language post](/blog/2018/02/05/mgmt-configuration-language/),
code is actually a [graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph)
and as a result can be written out-of-order. If you experiment with re-arranging
the ordering of the statements, you'll find that everything still works
correctly. This can be useful for situations when you might prefer to define the
`class` before it is used, or for when you want to see your business logic that
combines different `include`s at the top, and have the internals down at the
bottom.

In general, it is recommended that you avoid out-of-order code, but at the
moment it is allowed. There is a compile-time constant that specifies whether it
is allowed or not, and there is another one that specifies whether it should
allow it, but generate a warning. Neither is fully implemented because we are
missing one function in our graph library. If you can write a [function](https://github.com/purpleidea/mgmt/blob/f53376cea1056649a147dfc7654381e46d4388a5/lang/structs.go#L3562)
that returns whether a given ordering is a valid subset of one of the possible
topological sorts for that graph, then [please let us know](/contact/)!

{{< blog-paragraph-header "Conclusion" >}}

I hope you try out the language! More documentation is available in the
[language guide](https://github.com/purpleidea/mgmt/blob/master/docs/language-guide.md#class).

Happy Hacking,

James

{{< twitter-follow-purpleidea >}}
{{< patreon-support-purpleidea >}}
