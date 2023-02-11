+++
date = "2013-09-18 23:05:05"
title = "Linuxcon day two, Tuesday"
draft = "false"
categories = ["technical"]
tags = ["devops", "gluster", "gluster+openshift", "linuxcon", "openshift", "planetpuppet", "puppet", "puppet-gluster", "ubuntu"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/18/linuxcon-day-two-tuesday/"
+++

<a title="Linuxcon day one, Monday" href="/blog/2013/09/18/linuxcon-day-one-monday/">Continuing on from yesterday</a>, I've met even more interesting people. I chatted with <a href="https://twitter.com/pythondj">Dianne Mueller</a> about some interesting ideas for gluster+<a href="https://www.openshift.com/">openshift</a>. More to come on that front soon. Hung out with <a href="https://twitter.com/jonobacon">Jono Bacon</a> and talked a bit about <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> on <a href="http://www.ubuntu.com/">Ubuntu</a>. If there is interest in the community for this, please let me know. Thanks to John Mark Walker and RedHat for sponsoring me and introducing me to many of these folks. Hello to all the others that I didn't mention.

On the hacking side of things, I added <a href="https://github.com/purpleidea/puppet-gluster/commit/269be1cc13c43df0e8e3a3c0babbe494ed727e60">proper xml parsing</a>, and a lot of work on <a href="https://github.com/purpleidea/puppet-gluster/commit/4dbba38fc44e8d7226fdecec12b1237fc24d026d">fancier firewalling</a> to <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a>. At the moment, here's how the firewall support works:
<ol>
	<li>Initially, each host doesn't know about the other nodes.</li>
	<li>Puppet runs and each host <a href="http://docs.puppetlabs.com/puppet/3/reference/lang_exported.html">exports host information</a> to each other node. This opens up the firewall for glusterd so that the hosts can peer.</li>
	<li>Now that we know which hosts are in a common pool, we can open up the firewall for each volume's bricks. Since the volume has not yet been started (or even created) we can't know which ports are needed, so all incoming ports are permitted from other gluster nodes.</li>
	<li>Once the volume is created, and started, the TCP port information will be available, and can be consumed as facts. These facts then refine the previously defined firewall rules, to only allow the needed ports.</li>
	<li>Your white-listed firewall setup is now complete.</li>
	<li>For users who wish to avoid using this module to configure your firewall, you can set <em>shorewall =&gt; false</em> in your <em>gluster::server</em> class. If you want to specify the allowed ip access control manually, that is possible too.</li>
</ol>
I hope you find this useful. I know I do. Let me know, and

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
