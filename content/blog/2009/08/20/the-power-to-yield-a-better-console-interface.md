+++
date = "2009-08-20 13:15:51"
title = "the power to yield a better console interface"
draft = "false"
categories = ["technical"]
tags = ["dbus", "gobject", "python", "readline", "yield"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/08/20/the-power-to-yield-a-better-console-interface/"
+++

as part of a different project, i needed to duplicate some existing terminal magic in python. what i needed to write was something similar to the getch() function in curses. it can be found in: ncurses*/base/lib_getch.c after doing an: apt-get source libncurses5

what's the magic? i need to stay in a continuous loop reading from the file descriptor, however i want to return periodically so that gobject doesn't block and the interface can remain responsive. enter: yield, who comes in and saves the day. see the accompanying code for specifics.

as part of the bigger scheme, i wanted to write a console like interface for talking to a dbus server that both allows you to run methods, and receive signals. i wanted to use gobject, and i didn't want to use threads! and because i wanted to make it pro, i decided it should look and feel like my standard bash shell (except prettier). it's intended to be easy to use, and running the module will give you an example session. check back for a more complete and expressive code base.

1) if anyone knows who to do a ualarm (not alarm) in python, help is appreciated. either through ctypes or as a c extension for python.

2) please leave me your comments on my greadline module! more features are on the way, such as history and cursor support.

code: http://www.cs.mcgill.ca/~james/code/greadline.tar

