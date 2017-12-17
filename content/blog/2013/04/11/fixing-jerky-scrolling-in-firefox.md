+++
date = "2013-04-11 05:53:28"
title = "Fixing jerky scrolling in Firefox"
draft = "false"
categories = ["technical"]
tags = ["fedora", "firefox", "pgo", "scrolling", "smooth scrolling", "driver", "hardware acceleration", "x"]
author = "jamesjustjames"
+++

Fedora did a lovely job of updating me to the latest version (v. 20) of <a href="http://getfirefox.com">Firefox</a>. One problem I found, was that scrolling on certain pages was quite jerky. Performance was worse (or more likely) on pages with a frameset, and pages which were long. Pages with many images made this problem worse.

It turns out that the workaround is to disable hardware acceleration:

<a href="http://ttboj.files.wordpress.com/2013/04/firefox-disable-hardware-scrolling.png"><img class="alignnone size-full wp-image-394" alt="firefox-disable-hardware-scrolling" src="http://ttboj.files.wordpress.com/2013/04/firefox-disable-hardware-scrolling.png" width="584" height="580" /></a>

After you've unchecked this box, restart Firefox, and scrolling is now considerably smoother.

Hopefully this helped you out. Most likely there is some driver issue or deficiency with the X drivers. I'm using an excellent Thinkpad X201. I've also had at least two cases of X freezing while I was manipulating a Firefox window, so perhaps this is related, and hopefully this won't happen to me anymore.

Happy hacking,

James

&nbsp;

