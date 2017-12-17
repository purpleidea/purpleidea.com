+++
date = "2012-10-24 04:08:38"
title = "Multifile mode for text editors"
draft = "false"
categories = ["technical"]
tags = ["feature request", "vim", "text editor", "gedit", "inventions", "multifile mode", "puppet"]
author = "jamesjustjames"
+++

Dear internets,

I'm a sysadmin/architect, which means I spend a good amount of time <a href="http://developers.slashdot.org/story/12/10/22/2257222/system-admins-should-know-how-to-code">coding</a> in <a href="http://en.wikipedia.org/wiki/Puppet_%28software%29">puppet</a> and other languages. Puppet is a great tool, however the puppet community is a bit <del>anal</del> strict about their style policies. I can respect this because I understand how important uniformity is when many developers are sharing code.

(<a href="http://www.kernel.org/doc/Documentation/CodingStyle">On a side note, I absolutely can't stand using spaces for indentation, but that's another story. Please, just tell people to use tabs - preferably with a width of eight spaces.</a>)

The puppet community has a habit of splitting up each class, subclass and function ("define") into a separate file. When I'm hacking on a new module, I usually have everything together inside one big <em>init.pp</em> file until it becomes big enough that I need to split it up.

What I'd like to do, is have separate files loaded into my text editor linearly, so that as I scroll up or down with my mousewheel or keyboard, gedit or vim smoothly transitions me from one file to another. It would have per file line numbering (as usual), and a soft visual break when you transitioned from one file to the next. It would <em>feel</em> like a single file!

Interface wise, gedit could allow you to group tabs into this single "multifile" mode, which lets the native tab semantics (drag to reorder, open, close, see name) reorder, add, remove and view file name, respectively. Clicking on that tab would smooth scroll you right to where that file starts. I'm not sure what the grouping/ungrouping mechanism should look like, because this will depend on what is possible/sane with GTK+.

Gedit devs, can you make this happen? I will be a happy programmer/sysadmin.

Happy hacking,

James

