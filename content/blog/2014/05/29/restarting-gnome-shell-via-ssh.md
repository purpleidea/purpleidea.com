+++
date = "2014-05-29 02:18:35"
title = "Restarting GNOME shell via SSH"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "fedora", "gnome shell", "planetdevops", "planetfedora", "restart"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/05/29/restarting-gnome-shell-via-ssh/"
+++

When GNOME shell breaks, you get to keep both pieces. The nice thing about shell failures in GNOME 3, is that if you're able to do a restart, the active windows are <a href="https://bugzilla.gnome.org/show_bug.cgi?id=695487">mostly not disturbed</a>. The common way to do this is to type <em>ALT-F2</em>, <em>r</em>, <<em>ENTER</em>>.

Unfortunately, you can't always type that in if your shell is very borked. If you are lucky enough to have SSH access, and another machine, you can log in remotely and run this script:
```
#!/bin/bash
export DISPLAY=:0.0
{ `gnome-shell --replace &> /dev/null`; } < /dev/stdin &amp;
```
This will restart the shell, but also allow you to disconnect from the terminal without killing the shell. If you're not sure what I mean, try running <code>gnome-shell --replace</code> by itself, and then disconnect.

The script is available as a <a href="https://gist.github.com/purpleidea/aae7b91f8cc714b04803#file-gnome-shell-restart-sh">gist</a>. Download it, put it inside your <code>~/bin/</code> and <code>chmod u+x</code> it. Hopefully you don't need to use it!

Happy hacking,

James

