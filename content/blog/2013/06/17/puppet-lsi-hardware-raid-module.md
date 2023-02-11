+++
date = "2013-06-17 18:11:02"
title = "puppet lsi hardware raid module"
draft = "false"
categories = ["technical"]
tags = ["devops", "git", "gluster", "hardware raid", "linux", "lsi", "mdadm", "monitoring", "planetpuppet", "puppet", "puppet module", "raid", "sgpio"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/06/17/puppet-lsi-hardware-raid-module/"
+++

In response to some discussion in the gluster community, I am releasing my <a href="https://github.com/purpleidea/puppet-lsi/">puppet-lsi</a> module. It's quite simple, but it is very useful for rebuilding machines. It could do a lot more, but I wanted to depend on the proprietary LSI tools as little as possible. Running <em>megacli</em> with puppet would be a very doable hack, but I'm not sure enough devops out there who would use that feature.

Usage is straightforward if you like the sensible defaults:
```
include lsi::msm
```
The general idea is that you've probably already setup all your "virtual drive" RAID configurations initially, and now you're deploying your setup using cobbler and <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a>. This puppet-lsi module should install all the client side LSI tools, and make sure monitoring for the hardware RAID is working. <em>Megacli</em> and all the (evil?) <em>vivaldi framework</em> stuff will be up and running after puppet has run.

I haven't tested this on a wide array of hardware, and there might even be newer LSI gear on the market. Please don't test it on production servers. If you want help with this, you might have to sponsor some hardware, or send me somewhere where I can hack on some, because I don't have a gluster test rig at the moment.

I am curious to hear what kind of RAID you're using with gluster. Hardware? Software? Details rock. <a href="https://en.wikipedia.org/wiki/SGPIO">SGPIO</a> with <a href="https://en.wikipedia.org/wiki/Mdadm">mdadm</a>, and you're my hero. I want to hear about that!

<a href="https://github.com/purpleidea/puppet-lsi/">https://github.com/purpleidea/puppet-lsi/</a>

I hope this was useful to you, and in the meantime,

Happy hacking,

James

PS: The most useful feature of this module, is that it sets up monitoring of your RAID, and lets you access the management daemon through the now installed LSI services.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
