+++
date = "2013-10-18 06:00:49"
title = "Desktop Notifications for Irssi in Screen through SSH in Gnome Terminal"
draft = "false"
categories = ["technical"]
tags = ["bash", "desktop notifications", "fnotify", "freenode", "gluster", "gnome-terminal", "irc", "irssi", "notify-send", "pgo", "planetdevops", "planetfedora", "screen", "ssh"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/10/18/desktop-notifications-for-irssi-in-screen-through-ssh-in-gnome-terminal/"
+++

I'm usually on <a href="http://freenode.net/">IRC</a>, but I don't often notice incoming pings until after the fact. I had to both write, and modify various scripts to get what I wanted, but now it's all done, and you can benefit from my hacking by following along...

<span style="text-decoration:underline;">The Setup</span>
```
Laptop -> Gnome-Terminal -> SSH -> Screen -> Irssi
```
This way, I'm connected to IRC, even when my laptop isn't. I run <a href="http://irssi.org/">irssi</a> in a <a href="https://www.gnu.org/software/screen/">screen</a> session on an SSH server that I manage, and I use <a href="https://en.wikipedia.org/wiki/GNOME_Terminal">gnome-terminal</a> on my laptop. If you don't understand this setup, then you'll need to get more comfortable with these tools first.

<span style="text-decoration:underline;">Fnotify</span>

The first trick is getting irssi to store notifications in a uniform way. To do this, I modified an irssi script called fnotify. My <a href="https://gist.githubusercontent.com/purpleidea/9017ba480391fc2936760a94ae1791ac/raw/3e4ac1404e2f3836842fe3ae01d40b8b345f8155/fnotify.pl">changed version is available here</a>. Installation is easy:
```
# on your ssh server:
cd /tmp; wget https://gist.githubusercontent.com/purpleidea/9017ba480391fc2936760a94ae1791ac/raw/3e4ac1404e2f3836842fe3ae01d40b8b345f8155/fnotify.pl -O fnotify.pl
cp /tmp/fnotify.pl ~/.irssi/scripts/
# in irssi:
irssi> /load perl
irssi> /script load fnotify
```
When someone sends you a direct message, or highlights your nick on IRC, this script will append a line to the <em>~/.irssi/fnotify</em> file on the SSH server.

<span style="text-decoration:underline;">Watching fnotify</span>

On your local machine, we need a script to <em><a href="https://www.gnu.org/software/coreutils/manual/html_node/tail-invocation.html">tail</a></em> the fnotify file. This was surprisingly hard to get right. The <a href="https://gist.githubusercontent.com/purpleidea/531441fac2b439b1ab28b424c6eddc8a/raw/84aac2fd1f845aafb62aceb0c870a333d86c51e4/irssi-fnotify.sh">fruit of my labour is available here</a>. You'll want to copy this script to your local <em>~/bin/</em> directory. I've named this script <em>irssi-fnotify.sh</em>. This script watches the remote <em>fnotify</em> file, and runs <em>notify-send</em> and <em>paplay</em> locally to notify you of any incoming messages, each time one comes in.

<span style="text-decoration:underline;">SSH Activation</span>

We want the <em>irssi-fnotify.sh</em> script to run automatically when we connect to our SSH server. To do this, add the following lines to your <em>~/.ssh/config</em> file:
```
# home
Host home
    HostName home.example.com
    PermitLocalCommand yes
    LocalCommand ~/bin/irssi-fnotify.sh --start %r@%h
```
You might also want to have other directives listed here as well, but that is outside the scope of this article. Now each time you run:
```
ssh home
```
The <em>irssi-fnotify.sh</em> command will automatically run.

<span style="text-decoration:underline;">Magic</span>

I've left out some important details:
<ul>
	<li>The <em>LocalCommand</em> that you use, must return before ssh will continue. As a result, it daemonizes itself into the background when you invoke it with <em>--start</em>.</li>
	<li>My <em>irssi-fnotify.sh</em> program watches the parent ssh <em>$PID</em>. When it exits, it will run a cleanup routine to purge old notifications from the <em>fnotify</em> file. This requires a brief SSH connection back to the server. This is a useful feature!</li>
	<li>You may wish to modify <em>irssi-fnotify.sh</em> to <em>paplay</em> a different alert sound, or to avoid making noise entirely. The choice is yours.</li>
	<li>When <em>irssi-fnotify.sh</em> runs, it will <em>tail</em> the <em>fnotify</em> file over ssh. If there are "<em>unread</em>" messages, tail will try to "<em>download</em>" up to ten. You can edit this behaviour in <em>irssi-fnotify.sh</em> if you want a larger initial backlog.</li>
	<li>The <em>irssi-notify.sh</em> script doesn't attempt to prevent flooding, nor does it filter weird characters from incoming messages. You may want to add this yourself, and or /kb users who cause you to need these features.</li>
</ul>
Here's a little screenshot (with shameless plug) of the result in action:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="irssi-fnotify.png"><img alt="irssi-fnotify.sh notification screenshot" src="irssi-fnotify.png" width="100%" height="100%" /></a></td></tr></table></br />

Here's an example of how this helps me to be more responsive in channel:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="irssi-fnotify2.png"><img class="size-full wp-image-555" alt="helping out in #gluster" src="irssi-fnotify2.png" width="100%" height="100%" /></a></td></tr><tr><td> helping out in <a href="https://webchat.freenode.net/?channels=#gluster">#gluster</a></td></tr></table></br />

I hope you found this useful.

Happy Hacking,

James

