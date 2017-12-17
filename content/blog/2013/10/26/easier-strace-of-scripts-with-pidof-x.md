+++
date = "2013-10-26 16:02:12"
title = "Easier strace of scripts with pidof -x"
draft = "false"
categories = ["technical"]
tags = ["devops", "strace", "bash", "pidof", "planetfedora", "hacking"]
author = "jamesjustjames"
+++

Here's a <span style="text-decoration:underline;">one minute read</span>, about a trick which I discovered today:

When running an <em>strace</em>, it's common to do something like:
```
strace -p<<em>pid</em>>
```
Smarter hackers know that they can use some bash magic and do:
```
strace -p`pidof <<em>process name</em>>`
```
However, if you're tracing a script named <em>foo.py</em>, this won't work because the real process is the script's interpreter, and <em>pidof python</em>, might return other unrelated python scripts.
```
strace -p`pidof foo.py` # won't work
<em>[failure]</em>
<em>[user sifting through ps output for real pid]</em>
<em>[computer explodes]</em>
```
The trick is to use the <em><strong>-x</strong></em> flag of <em>pidof</em>. This will let you pass in your script's name, and <em>pidof</em> will take care of the rest:
```
strace -p`pidof -x foo.py` # works!
<em>[user cheering]</em>
<em>[normal strace noise]</em>
```
Awesome!

Happy hacking,

James

&nbsp;

