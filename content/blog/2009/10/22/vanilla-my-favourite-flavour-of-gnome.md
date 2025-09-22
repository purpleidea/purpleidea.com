+++
date = "2009-10-22 17:14:47"
title = "vanilla: my favourite flavour of gnome"
draft = "false"
categories = ["technical"]
tags = ["gnome", "pgo", "vanilla"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/10/22/vanilla-my-favourite-flavour-of-gnome/"
+++

after a recent upgrade to ubuntu 9.04, it seems that i've been pushed into using some "unfeatures" that i didn't ask for. well apparently they won't be unfeatures forever, but for me, <a href="https://wiki.ubuntu.com/NotifyOSD">notify-osd</a> and <a href="https://launchpad.net/indicator-applet">indicator-applet</a> aren't quite ready for my consumption. i realize that ubuntu is trying to improve the desktop experience, but i'm going to need to wait for some more polish first.

so how do i get rid of these horrible things ? i really liked the look of the notification-daemon, and i wanted it back. turns out i can do:

<code>sudo aptitude install gnome-stracciatella-session</code>

and when i log into x there is a "gnome (without ubuntu specific components)" option that i can choose. it seems to work and i'm running it now. hope this tip is helpful to you. thanks to martin pitt for making it easier for us to <a href="http://www.piware.de/2009/02/the-stracciatella-gnome-session/">choose</a>.

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
