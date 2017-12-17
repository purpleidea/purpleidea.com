+++
date = "2013-03-22 23:34:59"
title = "running your file manager from a terminal"
draft = "false"
categories = ["technical"]
tags = ["gedit", "terminal", "bash", "devops", "nautilus-open-terminal", "nemo", "nemo-open-terminal", "nohup", "open-terminal", "pgo", "file manager", "nautilus"]
author = "jamesjustjames"
+++

I do a lot of my work in a terminal. For the unfamiliar, this might seem strange, however once you're comfortable with your shell, this is the best place to be. I don't restrict myself to it though. I often want to spawn a file manager, or a graphical text editor. When I run nautilus, I usually see something like this:
```
james@computer:~/some/awesome/directory$ nautilus .
Initializing nautilus-open-terminal extension
Shutting down nautilus-open-terminal extension
james@computer:~/some/awesome/directory$
```
This is useful, because I can open a file browser right where I want it, it's annoying, because nautilus runs in that terminal until I close it. (This doesn't happen if the nautilus process is always running, but since GNOME 3, it isn't.)

My solution is a short bash script that runs nautilus, and leaves your terminal alone. I named my script <em>nautilus</em>, and placed it inside my <strong>~/bin/</strong>. Here is the script:
```
#!/bin/bash
# run nautilus from a terminal, without being attached to it; similar to nohup
# use the full path of nautilus to avoid it calling itself (recursion!)
{ `/usr/bin/nautilus "$@" &> /dev/null`; } &
```
I hope this is useful for you too. Feel free to do the same for gedit, nemo, and any other app which you often find convenient to run from the terminal. You can generalize this by leaving out the nautilus program:
```
#!/bin/bash
if [ "$1" == "" ]; then
        echo "usage: ./"`basename $0`"  (to run a command nohup style)"
        exit 1
fi
# do a nohup bash style according to:
{ `"$@" &> /dev/null`; } &
```
I name the above script <em>run.sh</em>, and it helps me out from time to time, when I don't want to touch my mouse.

In case you haven't heard about it, there's also an <em>open-terminal</em> extension for nautilus and nemo which lets you get to a terminal, from your file manager. A quick internet search should help you install it.

If you found this information useful, please let me know, and as always,

Happy hacking,

James

PS: If you plan to do this for gedit, you probably want to preserve stdin, so that you can still pipe things in. To do this, you'll probably want:
```
{ `/usr/bin/gedit "$@" &> /dev/null`; } < /dev/stdin &    # accept stdin too!
```

