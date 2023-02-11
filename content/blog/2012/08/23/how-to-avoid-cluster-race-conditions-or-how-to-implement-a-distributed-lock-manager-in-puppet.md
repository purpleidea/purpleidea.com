+++
date = "2012-08-23 16:14:44"
title = "How to avoid cluster race conditions or: How to implement a distributed lock manager in puppet"
draft = "false"
categories = ["technical"]
tags = ["devops", "dlm", "gluster", "keepalived", "puppet", "vip", "vrrp"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/08/23/how-to-avoid-cluster-race-conditions-or-how-to-implement-a-distributed-lock-manager-in-puppet/"
+++

I've been working on a puppet module for gluster. Both this, my puppet-gfs2 module, and other puppet clustering modules all share a common problem: How does one make sure that only certain operations happen on one node at a time?

The inelegant solutions are simple:
<ol>
	<li>Specify manually (in puppet) which node the "master" is, and have it carry out all the special operations. <span style="text-decoration:underline;">Downside:</span> Single point of failure for your distributed cluster, and you've also written ugly asymmetrical code. Build a beautiful, decentralized setup instead.</li>
	<li>Run all your operations on all nodes. Ensure they're idempotent, and that they check the cluster state for success first. <span style="text-decoration:underline;">Downside:</span> Hope that they don't run simultaneously and <a href="http://en.wikipedia.org/wiki/Race_condition">race</a> somehow. This is actually how I engineered my first version of puppet-gluster! It was low risk, and I just wanted to get the cluster up; my module was just a tool, not a product.</li>
	<li>Use the built-in puppet <a href="http://en.wikipedia.org/wiki/Distributed_lock_manager">DLM</a> to coordinate running of these tasks. <span style="text-decoration:underline;">Downside:</span> Oh wait, puppet can't do this, you misunderstand the puppet architecture. I too thought this was possible for a short duration. Woops! There is no DLM.</li>
</ol>
<span style="text-decoration:underline;">Note:</span> I know this is ironic, since by default puppet requires a master node for coordination, however you <a href="http://docs.puppetlabs.com/guides/scaling_multiple_masters.html"><em>can</em></a> have multiple masters, and if they're down, puppetd still runs on the clients, it just doesn't receive new information. (You could also reconfigure your manifests to work around these downsides as they arise, but this takes the point out of puppet: keeping it automatic.)

Mostly elegant: Thoughts of my other cluster crept into my head. Out of nowhere, I realized the solution was: <a href="http://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol">VRRP</a>! You may use a different mechanism if you like, but at the moment I'm using <a href="http://www.keepalived.org/">keepalived</a>. Keepalived runs on my gluster pool to provide a <a href="http://en.wikipedia.org/wiki/Virtual_IP_address">VIP</a> for the cluster. This allows my clients to use a highly available IP address to download volume files (mount operation) otherwise, if that particular server were down, they wouldn't be about to mount. The trick: I tell each node what the expected VIP for the cluster is, and if that IP is present in a facter $ipaddress_, then I let that node execute!

The code is now <a href="https://github.com/purpleidea/puppet-gluster">available</a>, please have a look, and <a href="#comments">let me know</a> what you think.

Happy hacking,
James

PS: Inelegant modes 1 and 2 are still available. For mode 1, set "vip" in your config to the master node IP address you'd like to use. For mode 2, leave the "vip" value at the empty string default.

PPS: I haven't had a change to thoroughly test this, so be warned of any dust bunnies you might find.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
