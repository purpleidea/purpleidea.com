+++
date = "2013-09-20 16:23:12"
title = "Gluster Community Day, Thursday"
draft = "false"
categories = ["technical"]
tags = ["devops", "gluster", "gluster day", "juju", "new orleans", "planetdevops", "planetpuppet", "puppet", "puppet-gluster", "talks", "ubuntu"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/20/gluster-community-day-thursday-2/"
+++

I'm here in New Orleans <a href="https://github.com/purpleidea/puppet-gluster">hacking up a storm</a> and getting to meet fellow <a href="http://blog.gluster.org/blog/">gluster</a> users IRL. John Mark Walker started off with a great "State of the GlusterFS union" style talk.

Today Louis (semiosis) gave a great talk about running glusterfs on amazon. It was highly pragmatic and he explained how he chose the number of bricks per host. The talk will be posted online shortly.

<a href="https://twitter.com/marcoceppi">Marco Ceppi</a> from Canonical gave a talk about juju and gluster. I haven't had much time to look at juju, so it was good exposure. Marco's gluster charm suffers from a lack of high availability peering, but I'm sure that is easily solved, and it isn't a big issue. I had the same issue when working on puppet-gluster. <a title="How to avoid cluster race conditions or: How to implement a distributed lock manager in puppet" href="/blog/2012/08/23/how-to-avoid-cluster-race-conditions-or-how-to-implement-a-distributed-lock-manager-in-puppet/">I've written an article about how I solved this problem.</a> I think it's the most elegant solution, but if anyone has a better idea, please let me know. The solutions I used for puppet, can be applied to juju too. Marco and I talked about porting puppet-gluster to ubuntu. We also talked about using puppet inside of juju, <em>with</em> a puppetmaster, but we're not sure how useful that would be beyond pure hack value.

Joe Julian gave a talk on running a MySQL (MariaDB) on glusterfs and getting mostly decent performance. That man knows his gluster internals.

I presented my talk about <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a>. I had a successful live demo, which ran over ssh+screen across the conference centre internet to my home cluster Montreal. With interspersed talking, the full deploy took about eight minutes. Hope you enjoyed it. Let me know if you have any trouble with your setup and what features you're missing. The video will be posted shortly.

Thanks again to John Mark Walker, RedHat and gluster.org for sponsoring my trip.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
