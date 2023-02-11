+++
date = "2013-04-11 05:53:28"
title = "Fixing jerky scrolling in Firefox"
draft = "false"
categories = ["technical"]
tags = ["driver", "fedora", "firefox", "hardware acceleration", "pgo", "scrolling", "smooth scrolling", "x"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/04/11/fixing-jerky-scrolling-in-firefox/"
+++

Fedora did a lovely job of updating me to the latest version (v. 20) of <a href="http://getfirefox.com">Firefox</a>. One problem I found, was that scrolling on certain pages was quite jerky. Performance was worse (or more likely) on pages with a frameset, and pages which were long. Pages with many images made this problem worse.

It turns out that the workaround is to disable hardware acceleration:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="firefox-disable-hardware-scrolling.png"><img class="alignnone size-full wp-image-394" alt="firefox-disable-hardware-scrolling" src="firefox-disable-hardware-scrolling.png" width="100%" height="100%" /></a></td></tr></table></br />

After you've unchecked this box, restart Firefox, and scrolling is now considerably smoother.

Hopefully this helped you out. Most likely there is some driver issue or deficiency with the X drivers. I'm using an excellent Thinkpad X201. I've also had at least two cases of X freezing while I was manipulating a Firefox window, so perhaps this is related, and hopefully this won't happen to me anymore.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
