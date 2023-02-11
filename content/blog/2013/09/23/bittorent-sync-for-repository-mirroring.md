+++
date = "2013-09-23 02:06:28"
title = "Bittorent sync for repository mirroring"
draft = "false"
categories = ["technical"]
tags = ["bittorent sync", "bittorrent", "deb", "devops", "geo-replication", "gluster", "mirrors", "planetdevops", "puppet", "puppet-gluster", "repository", "rsync", "use case", "yum"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/23/bittorent-sync-for-repository-mirroring/"
+++

<a href="https://twitter.com/theronconrey">Theron Conrey</a> writes about using:
<blockquote><a href="http://conrey.org/2013/05/21/bittorrent-sync-as-geo-replication-for-storage/">BitTorrent Sync as Geo-Replication for Storage</a></blockquote>
We got a chance to talk about this idea at Linuxcon. I'm not entirely convinced there aren't some problem edge cases with this solution, but I think it will be hard to tell as long as the BitTorrent sync library is proprietary. I did come up with a special case of Theron's idea that I believe could work well.

The special case uses the optimization that the synchronization (or file transferring) is unidirectional. This avoids any coherency complications involved if both sides were to write to the same file. Combined with the BitTorrent protocol, this does what normal torrent usage does, except with BitTorrent sync, we're looking at a folder full of files.

What kind of synchronization would benefit from this model? Repository mirroring! This is exactly a folder full of files, but going in only one direction. Instead of yum or deb mirrors each running rsync, they could use BitTorrent sync, and because of the large amount of available upload bandwidth usually available on these mirrors, "seeding", wouldn't be a problem, and the worldwide pool would synchronize faster.

Can we apply this to user mirroring, net installers, and machine updating? Absolutely. I believe someone has already looked into the updates scenario, but it didn't progress for some reason. The more convincing case is still the server geo-replication of course.

Obviously, using glusterfs with <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> to host the mirrors could be a good fit. You might not even need to use any gluster replication when you have built-in geo-replication via other mirrors.

If someone works up the open source BitTorrent parts, I'm happy to hack together the puppet parts to turn this into a turn-key solution for mirror hosts.

Hope you liked this idea.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
