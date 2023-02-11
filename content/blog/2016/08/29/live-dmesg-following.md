+++
date = "2016-08-29 09:00:39"
title = "Live dmesg following"
draft = "false"
categories = ["technical"]
tags = ["devops", "dmesg", "fedora", "journalctl", "planetdevops", "planetfedora", "planetfreeipa", "planetpuppet", "systemd", "tail -f"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/08/29/live-dmesg-following/"
+++

<a href="/blog/2012/11/18/continuous-display-of-log-files-better-tail-f/">All good sysadmins eventually learn about using tail -F to tail files. Yes upper-case F is superior.</a>

Around the time I wrote that article, I remember wanting to stream <code>dmesg</code> output too! The functionality wasn't available without some sort of polling hack, but it turns out that kernel support for this actually landed around the same time in version 3.5.0!

Most GNU/Linux distros are probably running a new enough version by now, and you can now <code>dmesg --follow</code> (or <code>dmesg -w</code>):

```
$ dmesg -w
[1042958.877980] restoring control 00000000-0000-0000-0000-000000000101/10/5
[1042959.254826] usb 1-1.2: reset low-speed USB device number 3 using ehci-pci
[1042959.356847] psmouse serio1: synaptics: queried max coordinates: x [..5472], y [..4448]
[1042959.530884] PM: resume of devices complete after 976.885 msecs
[1042959.531457] PM: Finishing wakeup.
[1042959.531460] Restarting tasks ... done.
[1042959.622234] video LNXVIDEO:00: Restoring backlight state
[1042959.767952] e1000e: enp0s25 NIC Link is Down
[1042959.771333] IPv6: ADDRCONF(NETDEV_UP): enp0s25: link is not ready
[1048528.391506] All your base are belong to us.
```
As an added bonus, you can access this via <code>journalctl --dmesg --follow</code> too:

```
$ journalctl -kf
<em>[snip]</em>
Aug 28 19:58:13 hostname unknown: All your base are belong to us.
```
<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="all-your-base.png"><img class="size-full wp-image-1870" src="all-your-base.png" alt="Now we have a dmesg version too! https://www.youtube.com/watch?v=8fvTxv46ano&html5=1" width="100%" height="100%" /></a></td></tr><tr><td> Now we have a <a href="https://www.youtube.com/watch?v=8fvTxv46ano&html5=1">dmesg version</a> too!</td></tr></table></br />

Since my dmesg output wasn't very noisy when writing this article, and since I didn't write an "<a href="https://en.wikipedia.org/wiki/All_your_base_are_belong_to_us">all your base</a>" kernel module, you can actually test this functionality by writing to the kernel ring buffer:

```
$ sudo bash -c 'echo The Technical Blog of James is awesome! > /dev/kmsg'
```
Happy hacking!

James

PS: Since this is a facility that provides events, we could eventually write an <a href="/tags/mgmtconfig/">mgmt config</a> "fact" or resource around it!

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
