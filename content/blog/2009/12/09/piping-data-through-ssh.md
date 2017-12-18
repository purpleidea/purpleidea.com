+++
date = "2009-12-09 22:36:05"
title = "piping data through ssh"
draft = "false"
categories = ["technical"]
tags = ["bash", "linux", "ssh"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/12/09/piping-data-through-ssh/"
+++

not that what i'm about to tell you is brilliant, new or revolutionary, however i thought i'd mention it in case you're not doing it. also feel free to let me know if there is a better way.

<strong>problem:</strong> i have some stdout which comes from a command and i want it in a file on another machine.

i <em>could</em> first send it to a temp file, scp that over, and then remove the temp file; but instead, i'll just:

<code>echo here is some stdout | ssh example.com tee filename</code>

which gives me the added bonus of seeing the contents fly by my screen as they get sent through tee.

