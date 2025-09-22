+++
date = "2014-03-20 18:01:24"
title = "Preserving your working directory in gnome-terminal"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "fedora", "gluster", "gnome", "gnome-terminal", "pgo", "planetdevops", "planetfedora", "planetpuppet", "puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/03/20/preserving-your-working-directory-in-gnome-terminal/"
+++

I use gnome-terminal for most of my hacking. In fact, I use it so much, that I'll often have multiple tabs open for a particular project. Here's my workflow:
<ol>
	<li><em>Control+Alt+t</em> (My shortcut to open a new gnome-terminal window.)</li>
	<li><code>cd ~/code/some_cool_hack/ # directory of some cool hack</code></li>
	<li><em>Control-Shift-t</em> (Shortcut to open a new gnome-terminal tab.)</li>
	<li>Hack, hack, hack...</li>
</ol>
The problem is that the new tab that I've created will have a <em>$PWD</em> of <code>~</code>, instead of keeping the <em>$PWD</em> of <code>~/code/some_cool_hack/</code>, which is the project I'm working on!

The solution is to add:
```
# including this ensures that new gnome-terminal tabs keep the parent `pwd` !
if [ -e /etc/profile.d/vte.sh ]; then
    . /etc/profile.d/vte.sh
fi
```
to your <code>~/.bashrc</code>. Now everything works perfectly!

Many thanks to <a href="https://blogs.gnome.org/mclasen/">Matthias Clasen</a> and <a href="https://blogs.gnome.org/halfline/">Ray Strode</a> for figuring this one out!

One side note: this used to be the default, but for some reason it broke around Fedora 19 or 20. Maybe it had to do with my <a href="/blog/2014/01/29/show-the-exit-status-in-your-ps1/">fancy prompt</a>, but everything is working great now.

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
