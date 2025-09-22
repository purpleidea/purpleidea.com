---
# get with: `date --rfc-3339=seconds`
date: 2024-12-03 02:56:37-05:00
title: "Modules and imports in mgmt"
description: "Understanding mgmt modules, imports, and entry points"
categories:
  - "technical"
tags:
  - "entrypoints"
  - "git"
  - "imports"
  - "mcl"
  - "mgmt"
  - "mgmtconfig"
  - "modules"
  - "planetfedora"

draft: false
---

[Mgmt](https://github.com/purpleidea/mgmt/) modules are used for structuring
your code across multiple files. This keeps things readable and allows for code
reusability. For example, it should be easy to write a single module which can
be effectively used by many different parties. To me, it never felt like code
reuse was a core design objective with other tools. In mgmt it has been since
the very beginning. I'm very proud of our module system, so let me introduce you
to it properly.

{{< blog-paragraph-header "Historical problems" >}}

Anyone who used [Puppet](https://en.wikipedia.org/wiki/Puppet_(software)) knows
there were typically multiple different modules for each task or service. I even
contributed to this problem by writing my own [puppet modules](https://purpleidea.com/tags/puppet/)
as well!

It was necessary to reinvent the wheel continually for two main reasons:

1. The strangeness of the "programming language" design limited how you could
build things. As a result, there was a lot of pre-planning needed for the
specific use case that you were aiming for, and so code reuse was challenging.

A simple example: in `puppet` you only had "facts" which ran on the server, and
you had to have a list of everything you'd want to run in advance. The idea that
you might not want to run every single fact, or that you might want to pass in
arguments to a particular fact, somehow was not considered.

Requiring back-and-forth communication between the client and the server was an
architectural mess. You should only communicate what you really need to if you
care about distributed-systems hygiene and scaling.

As a result, `mgmt` has a different operating model, which is compatible with a
modern distributed-systems mentality, and of course, it supports real
[functions](/blog/2024/11/22/functions-in-mgmt/)!

2. The incompleteness of the "programming language" didn't consider modelling of
time and what a future unified world of automation should look like.

A simple example: If you wanted to autoscale, you'd really be using that tool to
configure another tool to do that job for you, and so on. You'd have these
unsafe boundary layers (passing data from one format and type to another)
between tools, which made it very difficult to model complete systems properly.

The tools were not powerful enough to accomplish the entire goal, so you'd have
to be clever with how you built things. Expressing a more complex interface that
could be happily used by more than one consumer was challenging.

A more powerful language was the solution, however I didn't want to sacrifice
safety, which is why `mcl` is an [FRP](https://en.wikipedia.org/wiki/Functional_reactive_programming).

We can now model time safely, and express things that would have previously
required multiple different classes of tools, and many different classes of
bugs.

{{< blog-image src="alice-rabbit-time.png" caption="We knew about time, but choose to ignore it." scale="100%" >}}

{{< blog-paragraph-header "Imports" >}}

Let's start with the `import` statement. There are many useful system modules
which you may wish to import and use. A *system* module is one which begins and
ends with a normal alphanumeric character, such as `fmt` or `golang/strings`. It
may not contain a (`.`) period.

A complete list of available modules and their contained functions
[is available here](https://mgmtconfig.com/docs/functions/).

Imported modules can also contain classes and variables, but those are not
generally seen in system modules.

You do not need to "import" [resources](https://mgmtconfig.com/docs/resources/).
All resources are available to the user automatically.

Once you import a module, the last token in its name is used as the handle for
referencing the contents. For example:

```mcl
import "fmt"
import "golang/strings"

$words = [
	"hello",
	"crazy",
	"world",
]
$sentence = strings.join($words, " ")

print "sentence" {
	msg => fmt.printf("sentence: %s", $sentence),
}
```

As you can see `fmt` and `strings` are the handles used for the two functions
that we use in this example.

{{< blog-paragraph-header "Import as" >}}

You can choose a different handle name if you want. For example:

```mcl
import "fmt" as blah

print "sentence" {
	msg => blah.printf("hello world"), # blah is the handle here
}
```

You can also `import <module> as *`, which splats the contents of the module all
over the current namespace, although I generally don't recommend it when
importing system modules. It's much better to be explicit.

Import can also be used to import local subdirectories as well as modules from
`git`, but let's first look at the structure of a module.

{{< blog-paragraph-header "Structure" >}}

Let's dive into the basic structure of a module. As an example, I'll use the
[shorewall](https://github.com/purpleidea/mgmt/tree/master/modules/shorewall/)
module which I've added to the core collection of useful `mcl` modules in
`mgmt`.

```
$ tree shorewall/
shorewall/
├── files
│   ├── interfaces
│   ├── interfaces.frag.tmpl
│   ├── policy
│   ├── policy.frag.tmpl
│   ├── rules
│   ├── rules.frag.tmpl
│   ├── shorewall.conf.tmpl
│   ├── snat
│   ├── snat.frag.tmpl
│   ├── stoppedrule.frag.tmpl
│   ├── stoppedrules
│   ├── zones
│   └── zones.frag.tmpl
├── main.mcl
└── metadata.yaml
```

In the root directory you only need there to be one file for it to be considered
a module. That file is named `metadata.yaml`, which can even be empty! This file
tells `mgmt` where it should search for the initial code entry point and it also
gives it a static list of files to include in part of the "deploy".

{{< alert type="blue" >}}
A "deploy" is the bundle of code that makes up everything that is used when
running `mgmt`. We'll learn more about deploys in a future article.
{{< /alert >}}

{{< blog-paragraph-header "Metadata" >}}

By default (if the `metadata.yaml` file is empty) the code entry point is
`main.mcl` and any files can be found in the `files/` directory. Both of those
locations can be overridden in the `yaml` file, but they are sensible defaults
which you should probably not change.

If you did want to override one of these locations, or if you wanted to add some
additional metadata to your module, you can add it in the `metadata.yaml` file.
For example, it might instead look like this:

```
main: "james/hello.mcl"	# This is not the default, the default is "main.mcl".
files: "myfiles/"	# This is a different location for the files/ folder.
path: "path/"		# You can change the module path, but try not to here.
```

As with all things in `mgmt`, remember that directories end with a slash!

{{< blog-paragraph-header "Explicit path following" >}}

In some tools, you need to place their "classes" and "roles" and "templates" in
various *magic directories* for things to work. I always found this confusing
and user-hostile. Maybe I want the structure to follow my more logical pattern?

Keep in mind, that in some ways we want our concepts to be more similar to those 
found in general-purpose programming languages. Can you imagine if `golang`
forced a certain folder structure on its users? Just because you're a [DSL](https://en.wikipedia.org/wiki/Domain-specific_language),
doesn't mean you should throw away that practice! And just because you have the
freedom to choose your own directory structure, doesn't mean there are no good
conventions to follow!

One advantage of explicit path following, is that the compiler can
deterministically build a list of every single item which is being used, and that
can be used to create a packaged "deploy".

{{< blog-paragraph-header "Files" >}}

Previously, we mentioned a `files/` directory corresponding to the `files` key
in the `metadata.yaml` file. The `files/` path (or whatever you choose to name
it) is special because it is the location which is used to find files in if
asked by the [`deploy.readfile`](https://mgmtconfig.com/docs/functions/#deploy.readfile)
function.

For example, given the above directory structure, you may wish to use the
`shorewall.conf.tmpl` as a template, and store the output of running that
template in `/etc/shorewall/shorewall.conf` which would look like:

```mcl
import "deploy" # access stuff relating to the bundle of modules
import "golang" # contains a golang-style template(...) function

# pull out the contents of this file, note the leading slash
$tmpl = deploy.readfile("/files/shorewall.conf.tmpl")
$values = struct{
	# some values to pass into the template could go in here...
}

file "/etc/shorewall/shorewall.conf" {
	state => $const.res.file.state.exists, # a magic var of value "exists"
	content => golang.template($tmpl, $values), # run the template
	owner => "root",
	group => "root",
	mode => "u=rw,go=",
}
```

You can see that the `deploy.readfile` function returns the file contents, which
are passed to the `golang.template` function, which passes them to the file
resource. Of course if we don't want to run the templating engine, we could pass
the file content into the resource from `deploy.readfile` directly.

You might also notice that `deploy.readfile` takes an absolute path which is
rooted in the directory root of the module that it's in. In other words,
relative to the directory the `main.mcl` is in, the file is at
`/files/shorewall.conf.tmpl`. The `/files/` prefix is not a "magic word", it's
the actual directory! We need that prefix because how else would we access the
other files? For example:

```mcl
import "deploy"

print "print" {
	msg => deploy.readfile("/main.mcl"), # this refers to itself!
}
```

This program reads its own contents and prints them, which makes this roughly a
[quine](https://en.wikipedia.org/wiki/Quine_(computing))!

If you've used tools like `puppet`, you'll remember that the `template()`
function only read files from the `templates/` directory, which was different
from their `files/` directory. All of this sillyness is gone, and things can now
work sensibly. Why not let a template and static file co-exist in the same
folder, so that the developer doesn't need to `cd` around as much!

So what makes the `files/` directory special if we're explicitly specifying its
path in `deploy.readfile` anyways? What's special is that this directory is
included in the deployed "bundle" of code when `mgmt` runs. If you don't include
the file in that directory, then it won't be found when `mgmt` runs.

{{< blog-paragraph-header "Importing files and directories" >}}

Your module might like to split code into multiple files and directories. To
import a file, just include the relative path to that file. For example, assume
that your directory now looks like this:

```
$ tree project1/
project1/
├── internal
│   ├── data
│   │   ├── main.mcl
│   │   └── metadata.yaml
│   ├── james
│   │   └── main.mcl
│   └── timemachine
│       ├── files
│       │   ├── flux_capacitor.FCStd
│       │   └── math.tmpl.sh
│       ├── main.mcl
│       └── metadata.yaml
├── main.mcl
├── metadata.yaml
├── profiles.mcl
├── README.md
├── roles.mcl
└── test.sh
```

In the root, we have an empty `metadata.yaml` entry point. This then starts
things off at `main.mcl`:

```mcl
import "regexp"				# a system import

import "roles.mcl" as role		# a relative file import

import "internal/data/"			# a relative dir/module import

# This is a regular "if" statement, no custom "node" keyword even exists!
if $hostname == "delorian" {		# some mgmt code
	include role.timemachine
}

# Match on any hostname of the pattern app1, app2, appN...
if regexp.match("^app\\d+$", $hostname) {
	include role.application
}

print "hello" {
	msg => $data.owner,	# use some data
}
```

Our `roles.mcl` file, might then contain:

```mcl
import "profiles.mcl" as profile

class timemachine() {
	include profile.base
	include profile.ssh_server
	include profile.delorean
	# more included classes...
}

class application() {
	include profile.base
	include profile.ssh_server
	# more included classes...
}
```

And lastly in our `profiles.mcl` file, it might contain:

```mcl
import "internal/data/"		# organizational data
import "internal/james/"	# my personal module
import "internal/timemachine/"	# for managing the delorean

import "https://github.com/purpleidea/mgmt/modules/misc/" as misc	# a git import!

class base() {
	# Things that should be on *every* machine go here.
	include james.base

	# Every machine should have it's own ssh keypair.
	include misc.ssh_keygen("root")
}

class delorean() {
	include timemachine.speed("bttf-2015", struct{
		kmh => 142,
		mr_fusion => true,
		colour => $data.favourite_colour, # probably blue
	})
}
```

Take some time to read through these carefully. It's easy to follow the single
file imports like `import "roles.mcl" as role` and the `import "internal/data/"`
style. If you don't use the `as` syntax, then in the aforementioned two cases,
an automatic handle of `roles` and `data` will be used.

You may also wish to make note that there is no `metadata.yaml` file in the
`james/` folder. We'll talk about that below.

{{< blog-paragraph-header "Importing parent modules" >}}

Yes you can include `../` in your imports when you specify a relative path.

```mcl
import "../internal/data/"		# valid relative import
```

This is valid, but it is hopefully unnecessary for most modules. As long as your
import graph is a DAG (no cycles) then it's legal. If you're using a lot of
these, then it might be a good idea to rethink how you're structuring your code.

{{< blog-paragraph-header "Importing git modules" >}}

You'll notice there is one long-form module import there beginning with
`https://`. This does what you probably expect, and it's similar to what the
`golang` community has come to expect. Simply put some code in a git repo, and
it can be downloaded from that remote path! The actual schema specified is used,
so you probably want `git://` for normal git repositories, and `https://` for
many of the current hosting services which serve git over https.

At the moment, identifiers are all lowercase and don't allow dashes, so if you
import a package with: `git://example.com/purpleidea/Module-Name"`, this will
get transformed into `module_name`.

If you happen to name the final directory something of the form: `mgmt-foo/`,
then the module will automatically get given a handle of `foo` if you don't use
the `as` syntax.

For example:

```
import "https://example.com/whatever/modules/mgmt-magic/"

print "hello" {
	msg => $magic.abracadabra(), # runs the function from that module
}
```

{{< blog-paragraph-header "Downloading the code..." >}}

To cause a download to occur, you'll need to include the `--download` or
`--only-download` flags as part of your `mgmt run lang` or `mgmt deploy lang`
commands. You can also use `--update` to ensure you get the latest versions.

For example, you may run:

```bash
mgmt run --tmp-prefix lang --download --update foo.mcl
```

to make sure you have the latest versions of everything, but where does that
code get downloaded to?

{{< blog-paragraph-header "MGMT_MODULE_PATH" >}}

Anytime you run `mgmt`, you'll need a "module path" specified, which tells it
where to look for and store any modules. You can specify this in three ways:

1. With the `--module-path [PATH]` command line argument.

2. In the `MGMT_MODULE_PATH` environment variable.

3. In the `path` key of the `metadata.yaml` file.

The above precedence order applies. Make sure that the directory itself exists,
since `mgmt` will not create it for you. This prevents unexpected module
directories from appearing on your system when you didn't expect them to.

{{< blog-paragraph-header "Running mgmt" >}}

Combining everything we've learned so far, you could now run `mgmt` with:

```bash
mgmt run --tmp-prefix lang --module-path=mypath/ --download --update foo.mcl
```

or:

```bash
mgmt run --tmp-prefix lang --download --update ./metadata.yaml
```

and so on...

{{< blog-paragraph-header "Entry points" >}}

Whenever you run `mgmt`, create a "deploy", or import a module, `mgmt` has a
concept of "entry points" which it uses to determine how to "find that code". It
is a simple search sequence which it follows to turn your requested input into a
runnable scenario. Let's list the precedence rules first:

1. empty
2. stdin
3. metadata.yaml
4. file.mcl
5. dir/
6. code
7. error

Let's go over each one:

1. We have no input, nothing happens. (We may consider adding a default action
to look in `/etc/mgmt/` for code by default if there's enough of a demand for
that.)

2. We have a `-` (dash) so we look at `stdin`. Type or pipe in some code and it
will run.

3. We have the path to a `metadata.yaml` file. That's our entry point, we follow
it to the first `main.mcl` file (or whatever it specifies) and we also take any
other information defined there into account.

4. We're given a path to a single `whatever.mcl` file. We start running from
there.

5. We're given a directory. We look inside that directory first for
`metadata.yaml`, and if so we follow that. Otherwise we look for `main.mcl`
which is the built-in default.

6. We assume our input is a string of some actual `mcl` code. We try to run it.

7. We error. You've failed to specify a valid entry point for `mgmt`.

Note that for #5, this is why the above `james/` folder with only a single
`main.mcl` file in it, is a valid import. When the system sees that folder, it
automatically looks for `metadata.yaml`, which it doesn't find, and then falls
back to `main.mcl` which it does. Remember that if a `files/` dir was present,
[it will not be included in a deploy](https://github.com/purpleidea/mgmt/blob/master/docs/language-guide.md#why-am-i-getting-a-deployreadfile-error-when-the-file-actually-exists).

{{< blog-paragraph-header "Running in production" >}}

If you want to run `mgmt` in production, there are a few ways to go about it.
We'll talk more about this in a future article about "deploys", but as a sneak
peak, you may find it valuable to store your main code repo in `/etc/mgmt/`.
Inside that directory there are two possible scenarios:

1. Nested modules

In this first scenario, you may wish to put your code into `/etc/mgmt/` or even
`/etc/mgmt/main/` and your `metadata.yaml` file inside that directory. Alongside
it, there should be a directory named `modules/` which contains the module tree.
That path can be specified either in the `metadata.yaml` file, or with the
`--module-path` argument. This latter variant is preferred.

This "nested modules directory" variant is preferred for users who are
comfortable with git submodules, and wish to store everything in a giant mono
repo. This is a very excellent way to develop and manage your code.

2. Modules abreast

In this scenario, you'll want to have your code in `/etc/mgmt/main/` and a
`modules/` directory in `/etc/mgmt/modules/`. Your "module path" will get
specified by command line arg when you run `mgmt`.

This more classical scenario is easier for users who want to simplify their git
experience, or who are developing `mgmt`. This is because it makes it easy to
`rsync` up a module path from your development environment and run it directly.

Whatever way you choose to run `mgmt` is up to you. If you think there's a
better way, please let me know!

{{< blog-paragraph-header "Side effects from import" >}}

Suppose you had the following two files:

```mcl
# nested/main.mcl
$answer = 42
print "hello" {
	msg => "this is in the nested module",
}
```

and:

```mcl
# main.mcl
import "fmt"

import "nested/"

print "answer" {
	msg => fmt.printf("the answer is: %d", $nested.answer)
}
```

What do you expect to happen if you ran this? The answer is that this code will
error at compile time. This is because "the action of an import should not cause
a side effect". In the top-level scope of the `nested/` module, there is a bare
resource! Importing it would effectively make it part of the main scope, which
is not allowed implicitly.

Instead, write your modules so they instead look like:

```mcl
# nested/main.mcl
$answer = 42
class run() {
	print "hello" {
		msg => "this is in the nested module",
	}
}
```

and:

```mcl
# main.mcl
import "fmt"

import "nested/"

include nested.run()

print "answer" {
	msg => fmt.printf("the answer is: %d", $nested.answer)
}
```

This way effectors need to be explicitly pulled in. Nothing happens
accidentally. You'll encounter similar safeguards if you try and import a module
which has an `include` statement in its top-level scope.

{{< blog-paragraph-header "Git at the core" >}}

You'll have noticed by now, that the use of `git` is fully baked into the `mgmt`
system. This keeps things simple and standardized. The lesson was learned from
`golang`: By supporting more than one dvcs in the core, they were forced to make
many design compromises, whilst also adding code complexity. We think one dvcs
is the best way forward. This will become more apparent when you use the
"deploy" system. If there is a good reason to re-evaluate this decision, we
will.

{{< blog-paragraph-header "Pinning versions" >}}

Users invariably want to "pin" dependency versions. I generally think this is
not a good practice, as it's much more beneficial to have a `git master` (or
`git main`) which is always both the best and the most stable. This makes
development easier for many reasons, but it is not the common place situation.

As a result, if you _do_ want to pin a specific version, I recommend you use
"git submodules". They actually do work great, but if you have tunnel-vision
about them, then I'm more than willing to accept a patch that does "go.mod"
style versioning, but under the hood is just running the `git` commands for you.

If you're not convinced about submodules, then first book a
[training session](https://mgmtconfig.com/services/) and we'll make sure you
feel like a pro!

{{< blog-paragraph-header "Modules vs. packages" >}}

A note on naming. In discussing modules, I often use the word "package"
interchangeably. I might have even done it in the source code or in other blog
posts. This is generally a mistake, but I think the word (at least at this time)
is roughly synonymous. If you notice the error in writing, feel free to point it
out, and if I say "package" assume I'm really talking about "modules".

{{< blog-paragraph-header "Organizing code" >}}

Lastly, a note on organizing the structure of your projects. I'm not sure that
there is an authoritative answer here. The historical, pre-`mgmt` solution was
called ["roles and profiles"](https://web.archive.org/web/20230904100629/https://www.craigdunn.org/2012-puppet-roles-and-profiles/)
and it served us fairly well. I'd love to see an updated version of that for
`mgmt`.

There are some important differences that may make the situation unique. In
`mgmt`, we do not have a `node` statement, and the equivalent of "node
classification" (as it was called in `puppet` land) can happen anywhere in the
code base, and it doesn't need to be at the top-level!

As a result, we should revisit the old decisions and analysis, but the old work
is a good starting point, and I've been using that pattern for now.

{{< blog-paragraph-header "Conclusion" >}}

I know this is a long article, and I'm sorry I didn't write it sooner, but I
hope it serves as a good reference for you to put `mgmt` in production!

[Enterprise support, training, and consulting are all available.](https://mgmtconfig.com/)

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
