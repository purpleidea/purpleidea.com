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

This happens because of clever bash completion engineering and one coincidence.

1. Clever bash completion engineering:
	To build the bash completion for `make`, the shell (via a completion
	script) actually calls `make -npq __BASH_MAKE_COMPLETION__=1 -C . .DEFAULT`
	which is a magic incantation which actually asks `make` to parse the
	`Makefile`, and return a bunch of information which can then be used to
	automatically build clever bash completion targets. You can run it
	yourself to see the output. (I won't paste it here because it's
	enormous.) As a result, when we invoke our `pmake` script and press
	`<tab>`, the shell actually runs it secretly, and our script passes the
	magic incantation to the real `make`, which returns the necessary
	information. You can observe this by adding:

	```bash
	echo "MAKE: $@" >> /tmp/whatever
	```

	to the top of the script, and then running a `tail -F /tmp/whatever` to
	see our script getting called when you press `<tab>` a few times.

2. The coincidence:
	So why does this work? Our script is `pmake`, and it would be bad if the
	shell always ran `-npq` every time we pressed tab on a binary. As a
	result, the bash completion package only does this for `make`, although
	they also hook up `pmake`, `gmake`, `gnumake`, `colormake`, and `_make`.
	[source](https://github.com/scop/bash-completion/blob/master/completions/make#L169)
	So it was pure coincidence that I chose a script named `pmake`. Had I
	written a script named `pmake` which launched nuclear missiles every
	time you ran it with `-npq` (`-n` for nuclear missiles, `-p` for max
	payload active, and `-q` for a quiet stealth attack) then we'd be in
	serious trouble the moment someone tried to use tab completion!

	Apparently `pmake` is the name of a `make` like command on *BSD, and the
	legacy is present in the GNU package. Turns out BSD _is_ occasionally
	useful ;)

Thanks to the commentors which pointed me to the `pmake` entry in the source!

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
