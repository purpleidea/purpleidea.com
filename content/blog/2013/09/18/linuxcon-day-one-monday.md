+++
date = "2013-09-18 22:32:16"
title = "Linuxcon day one, Monday"
draft = "false"
categories = ["technical"]
tags = ["fedora", "gluster", "linuxcon", "new orleans", "planetdevops", "planetpuppet", "puppet", "puppet-gluster", "raspberry pi", "shorewall"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/18/linuxcon-day-one-monday/"
+++

I'm here in New Orleans at Linux Con, hacking on <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> and talking to lots of interesting folks. I've met gluster hacker <a href="https://twitter.com/theronconrey">Theron Conrey</a>, and my host <a href="https://twitter.com/johnmark">John Mark Walker</a>, Fedora and Raspberry Pi experts <a href="https://twitter.com/spotrh">Spot</a> and <a href="https://twitter.com/suehle">Ruth Suehle</a>, and many others too.

The hotel is very nice. The bathroom sink has two taps of course, but both of them are hot. The New Orleans heat is probably the cause of this.

I'm hacking at full speed to get some new features and testing in before my talk on Thursday. I've been <a href="https://github.com/purpleidea/puppet-gluster/commit/1d423ade0362a01acf2cbc35399808b4befe0864">reworking the simple firewall support</a> in my puppet module. For those that want automated and correct firewall configuration, expect some improvements soon.

I also pushed some work on property management for gluster volumes. <a href="https://github.com/purpleidea/puppet-gluster/commit/7e00d90ecc38812e0f24fc711523b778955d39c8">This commit adds a list of all available gluster properties.</a> The patch is still missing type information for many of them, because I haven't yet tested each one, but if there are some you'd like to use, please let me know. This is easy to patch.

More code is landing soon. Don't be afraid to contact me if you're not sure how to get started with puppet gluster, or if there's a use case that I am not currently solving.

Happy Hacking,

James

PS: Sorry I published this late!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
