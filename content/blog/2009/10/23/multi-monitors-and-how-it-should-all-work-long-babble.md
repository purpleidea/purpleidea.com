+++
date = "2009-10-23 21:09:13"
title = "multi monitors and how it should all work (long babble)"
draft = "false"
categories = ["technical"]
tags = ["babble", "compiz", "gnome", "multi-head", "multiple monitors", "reference", "window manager", "xmonad"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/10/23/multi-monitors-and-how-it-should-all-work-long-babble/"
+++

at work i use two screens for my day to day workflow. i find it's much more efficient for doing work, like coding. i'll often have at least one terminal open, a full screen text editor, and usually a number of references, such as the <a href="http://dbus.freedesktop.org/doc/dbus-specification.html">dbus specification</a> open in a <a href="http://projects.gnome.org/epiphany/">web browser</a>.

i recently just realized that one of the reasons multiple monitors are so useful to me, isn't because of the increased screen real estate (although that certaintly is an important factor) but because of how the window manager deals with the windows. for example, when i click maximize, the chosen window expands to fill that monitors capacity, and not the entire set of monitors. it would be nice for this type of behaviour to be configurable somewhere for people with ultra large screens, who want to manage their windows better. the closest i've found is: <a href="https://launchpad.net/winwrangler">winwrangler</a> which i've started using at home where i only have one screen. it works sort of along those lines, however i still want more. multiple "workspaces" are essential. no matter how many screens i have, i'll always need a few workspaces to be able to flip between email and coding-- there is no sense in mixing it all together.

the cheeses ("the cheddar", aka the suggestions i want to make in this babble):
<ul>
	<li> as i change workspaces both/(all) screens change along with me. adding multiple monitors, essentially extends the size of the workspace. let us call this "<em>mode 1</em>".</li>
</ul>
<ul>
	<li>an alternate behaviour could be to allow "x" independent workspaces on monitor 1, and "y" independent workspaces on monitor 2, and so on... i read somewhere that someone accomplished this with two different x sessions somehow; the problem was that you couldn't drag windows from one to the other. if someone was able to solve that problem and that type of usability was possible, then we could call this "<em>mode 2</em>"</li>
</ul>
<ul>
	<li>even more exciting would be to have a workspace on each monitor sharing a common set of workspaces. for example workspace "c" could be displayed on monitor 1, and workspace "e" could be displayed on monitor 2. you could switch each independently, and in the special case that both monitors were displaying the same workspace, then you would be getting an almost "clone". the one exception to this being a true clone is that when using multiple monitors, you usually have a static per-monitor panel layout which doesn't change as you switch workspaces. that functionality is good. all this would be called "<em>mode 3</em>"</li>
</ul>
<ul>
	<li>for completeness sake, a *true* clone of one screen to another is a possibility, and should be called "<em>mode 0</em>".</li>
</ul>
the complicated point to this discussion is doing what any good mathematician, computer scientist, or ropes-technician (because of the knot tying) would do, and that is to extend the idea of our our modes to the more general case where we can mix and match them for N screens. (to take it a step further would be to let any physical screen be split into M virtual screens, and then use those to solve the above problem!)

think of combining two screens in mode 1, which together are in mode 2 with a second screen, which all together could be in mode 3 with an auxiliary monitor. you've got a big mess, and maybe it would be nice to dump this whole setup to your clone output in mode 0 to the projector. now i'm pretty sure that nobody would want <strong>that</strong> particular setup, but there should be some sensible way to choose what setup you do want, and to configure it appropriately.

i've heard that <a href="http://xmonad.org/">xmonad</a> can apparently do something like mode 3. it makes me want to switch to using that. mode 1 is currently what i'm using. mode 2 could probably be emulated in a window manager which supports mode 3, by confining monitor 1 to only allow even numbered workspaces, and monitor 2 to only allow odd numbered workspaces (mod N if you have N monitors), and mode 0 already exists and is nice for presentations.

i think there are two important things to get right:

1) have a way to create "virtual screens" - it would be nice to be able to benefit from multiple screen logic, without physically buying 8 screens. also this would be indispensible for testing.
2) have a beautifully designed tool for managing the configuration, which obviously uses a well thought out configuration file format.

i would love to hear your thoughts, and if anyone knows of projects with great goals like these, please let me know.

ps: <a href="http://www.compiz-fusion.org/">compiz</a> has a "multi output mode" but i'm not sure exactly what it does and if it helps with any of this.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
