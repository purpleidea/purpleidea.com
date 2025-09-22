+++
date = "2013-10-26 16:02:12"
title = "Easier strace of scripts with pidof -x"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "hacking", "pidof", "planetfedora", "strace"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/10/26/easier-strace-of-scripts-with-pidof-x/"
+++

Here's a <span style="text-decoration:underline;">one minute read</span>, about a trick which I discovered today:

When running an <em>strace</em>, it's common to do something like:
```
strace -p<pid>
```
Smarter hackers know that they can use some bash magic and do:
```
strace -p`pidof <process name>`
```
However, if you're tracing a script named <em>foo.py</em>, this won't work because the real process is the script's interpreter, and <em>pidof python</em>, might return other unrelated python scripts.
```
strace -p`pidof foo.py` # won't work
[failure]
[user sifting through ps output for real pid]
[computer explodes]
```
The trick is to use the <em>-x</em> flag of <em>pidof</em>. This will let you pass in your script's name, and <em>pidof</em> will take care of the rest:
```
strace -p`pidof -x foo.py` # works!
[user cheering]
[normal strace noise]
```
Awesome!

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
