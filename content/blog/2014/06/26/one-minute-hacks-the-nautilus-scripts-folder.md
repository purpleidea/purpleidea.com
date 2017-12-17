+++
date = "2014-06-26 00:01:10"
title = "One minute hacks: the nautilus scripts folder"
draft = "false"
categories = ["technical"]
tags = ["planetfedora", "totem", "devops", "planetpuppet", "bash", "fedora", "hack", "nautilus", "planetdevops", "1 minute hack", "gluster"]
author = "jamesjustjames"
+++

Master <a href="https://en.wikipedia.org/wiki/Software_Defined_Networking">SDN</a> hacker <a href="https://twitter.com/guteusa">Flavio</a> sent me some tunes. They were sitting on my desktop in a folder:
```
$ ls ~/Desktop/
uncopyrighted_tunes_from_flavio/
```
I wanted to listen them while hacking, but what was the easiest way...? I wanted to use the <em>nautilus</em> file browser to select which folder to play, and the <em>totem</em> music/video player to do the playing.

Drop a file named <code>totem</code> into:
```
~/.local/share/nautilus/scripts/
```
with the contents:
```
#!/bin/bash
# o hai from purpleidea
exec totem -- "$@"
```
and make it executable with:
```
$ chmod u+x ~/.local/share/nautilus/scripts/totem
```
Now right-click on that music folder in <em>nautilus</em>, and you should see a <code>Scripts</code> menu. In it there will be a <code>totem</code> menu item. Clicking on it should load up all the contents in <em>totem</em> and you'll be rocking out in no time. You can also run scripts with a selection of various files.

Here's a screenshot:

[caption id="attachment_846" align="alignnone" width="584"]<a href="https://ttboj.files.wordpress.com/2014/06/nautilus-scripts-folder.png"><img class="size-large wp-image-846" src="http://ttboj.files.wordpress.com/2014/06/nautilus-scripts-folder.png?w=584" alt="nautilus is pretty smart and lets you know that this folder is special" width="584" height="167" /></a> nautilus is pretty smart and even lets you know that this folder is special[/caption]

I wrote this to demonstrate a cute <em>nautilus</em> hack. Hopefully you'll use this idea to extend this feature for something even more useful.

Happy hacking,

James

&nbsp;

