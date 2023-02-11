+++
date = "2013-10-21 00:07:06"
title = "first release of puppet-shorewall"
draft = "false"
categories = ["technical"]
tags = ["NFS", "devops", "gluster", "ipa", "puppet", "puppet modules", "puppet-shorewall", "shorewall"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/10/21/first-release-of-puppet-shorewall/"
+++

Oh, hi there.

In case you're interested, I've just made a <a href="https://github.com/purpleidea/puppet-shorewall">first release of my puppet-shorewall module</a>. This isn't meant as an exhaustive shorewall module, but it does provide most of the usual functionality that most users need.

In particular, it's the module dependency that I use for many of <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">my</a> <a href="https://github.com/purpleidea/puppet-ipa">other</a> <a href="https://github.com/purpleidea/puppet-nfs">puppet</a> <a href="https://github.com/purpleidea/puppet-cobbler">modules</a> that provide firewalling. This is probably where you're most likely to consume it.

In general most modules just implement <em>shorewall::rule</em>, so if you really don't want to use this code, you can implement that signature yourself, or not use automatic firewalling. The <em>shorewall::rule</em> type has two main signatures, so have a <a href="https://github.com/purpleidea/puppet-shorewall">look at the source</a>, or a <a href="https://github.com/purpleidea/puppet-shorewall/blob/master/examples/misc-example.pp">simple example</a> if you want to get more familiar with the specifics. Using this module is highly recommended, specifically with <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">puppet-gluster</a>.

Please keep in mind that since I mostly use this module to open ports and to keep my other modules happy, I probably don't have <a href="http://www.lartc.org/">advanced traffic control</a> features on my roadmap. If you're looking for something that I haven't added, <a title="contact" href="/contact/">contact me</a> with the details and consider <a title="donate" href="/donate/">sponsoring</a> some features.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
