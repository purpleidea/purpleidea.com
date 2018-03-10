---
date: 2018-03-10 02:00:00-05:00
title: "Running `make` from anywhere"
description: "Run commands from your `Makefile`, even if you're nested deeply!"
categories:
  - "technical"
tags:
  - "bash"
  - "ten minute hacks"
  - "make"
  - "makefile"
  - "devops"
  - "fedora"
  - "planetfedora"
draft: false
---

Sometimes while I'm deep inside [mgmt](https://github.com/purpleidea/mgmt/)'s
project directory, I want to run an operation from the `Makefile` which lives in
the root! Unfortunately, if you do so while nested, you'll just get:

```bash
james@computer:~/code/mgmt/resources$ make build
make: *** No rule to make target 'build'.  Stop.
```

{{< blog-paragraph-header "The Ten Minute Solution" >}}

I figured I'd hack out a quick solution. What I came up with looks like this:

```bash
#!/bin/bash
# James Shubin, 2018
# run `make` in the first directory (or its parent recursively) that it works in

MF='Makefile'	# looks for this file, could look for others, but that's silly
CWD=$(pwd)	# starting here

while true; do
	if [ -e "$MF" ]; then
		make $@		# run make!
		e=$?
		cd "$CWD"	# go home first
		exit $e		# pass on the exit status
	fi

	# stop if we get home
	if [ "$(pwd)" = "$HOME" ]; then
		cd "$CWD"
		exit 2		# the exit status of `make` when it errors
	fi

	#echo "searching..."
	cd ..			# go up one dir
done
```

You can probably figure it out quite easily from the code, but what this does is
it searches upwards until it finds a `Makefile`, and then runs your command from
there!

I saved that into a file named `pmake`, made it executable (`chmod u+x pmake`)
and put it into my `~/bin/`. You can download it from [here](https://gist.github.com/purpleidea/ebf5ee7bf47f41132e5d0c1cd8329c75)
instead.

{{< blog-paragraph-header "Problems" >}}

One problem with this solution is that if you have an intermediate `Makefile`
which is in a parent folder of where you're working, then it will stop the
search there, instead of continuing upwards. One potential solution to this is
to name those files `GNUmakefile` instead, since they will continue to work as
normal, but won't get found by this script. In my use cases, I only ever split
up `Makefile`'s into intermediate layers for compartmentalization and
readability, and I can almost always invoke anything important from the root.

{{< blog-paragraph-header "Magic?" >}}

You'd expect that this doesn't support the magical bash completion that comes
with a normal `Makefile`. Strangely, and due to nothing that I did, it seems to
just work! I type `pmake <tab>` and I see the correct completions!

If anyone knows why this works, please let me know. It seems that `bash` **is**
magic!

Happy Hacking,

James

{{< twitter-follow-purpleidea >}}
