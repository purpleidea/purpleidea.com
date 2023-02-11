+++
date = "2012-04-25 00:59:01"
title = "how to use ssh escape characters"
draft = "false"
categories = ["technical"]
tags = ["devops", "sctp", "ssh"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/04/25/how-to-use-ssh-escape-characters/"
+++

So you've learned screen, ssh and vim. Time to take your skills to level two.

Day one: You've logged in to your server remotely via ssh. You run "screen -xRR", and two minutes later you're busy chatting away in irssi and vim is running in the other window, because, you know, real sysadmins don't use emacs.

Lunch time: You grab your laptop and head off for lunch. When you open the lid and look at your terminals, they're all frozen, because the tcp connections have died. You force quit the terminals, and you're back in 30 seconds with new tcp connections.

Day two: Since lunch is a daily occurence, it would be nice to avoid this altogether. Enter ssh escape characters. Do a: "man ssh" and search for: "ESCAPE CHARACTERS".

Lunch time: Hit: ~ . (tilde-period) in an ssh session. This will probably require you hold &lt;shift&gt; to get a "tilde", (then release) and enter a period (you should know how to type!) Instead of period, you can enter a ? in case you want see about the other cool commands. If ever this doesn't work, press &lt;enter&gt; at least once to "unconfuse" the escape sequence listener and you can now try again.

Day three: You learn about <a href="http://en.wikipedia.org/wiki/Stream_Control_Transmission_Protocol">SCTP</a> and decide this is the future for your multihomed life. Bonus points for someone who comments about how they use it.

Happy Hacking!

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
