+++
date = "2013-09-08 04:51:14"
title = "New puppet-gluster features before Linuxcon"
draft = "false"
categories = ["technical"]
tags = ["devops", "gluster", "linux", "linuxcon", "new features", "planetpuppet", "puppet", "puppet module", "puppet-gluster", "selinux"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/08/new-puppet-gluster-features-before-linuxcon/"
+++

Hey there,

I've done a bit of <a title="puppet-gluster" href="http://github.com/purpleidea/puppet-gluster/">puppet-gluster</a> hacking lately to try to squeeze some extra features and testing in before <a title="Puppet-Gluster and me at Linuxcon" href="/blog/2013/09/02/puppet-gluster-and-me-at-linuxcon/">Linuxcon</a>. Here's a short list:
<ul>
	<li><a href="https://github.com/purpleidea/puppet-gluster/commit/7c2dc0cadc03bc5dd2da3155e5773ad4471563df">SELinux fixes</a> to keep <a href="http://danwalsh.livejournal.com/">Dan Walsh</a> happy :)</li>
	<li><a href="https://github.com/purpleidea/puppet-gluster/commit/4345cf9e625259585f7f8541e08c0e79a914e78c">Ping and status checks before volume creation.</a> Now puppet-gluster will be less noisy about failures or missing executions that are due to the necessary incremental nature of puppet-gluster runs. You'll need multiple puppet runs to get a complete setup, so don't let puppet complain part way through. This is due to the design of puppet.</li>
	<li><a href="https://github.com/purpleidea/puppet-gluster/commit/231e4b9ff771d33514d78518e14fe13148e7b431">Simple filesystem paths for bricks.</a> This is very useful for prototyping with virtual machines.</li>
	<li><a href="https://github.com/purpleidea/puppet-gluster/commit/24844a892c07001bb50eeb443005d3c2fe5d4025">Automatic UUID assignment for hosts.</a> This requires <a href="http://docs.puppetlabs.com/puppet/2.7/reference/lang_exported.html">exported resources</a>.</li>
	<li><a href="https://github.com/purpleidea/puppet-gluster/tree/master/examples">Updated examples</a></li>
	<li><a href="https://github.com/purpleidea/puppet-gluster">And more...</a></li>
</ul>
If there are features or bugs that you'd like to see added or removed (respectively) please let me know <em>ASAP</em> so that I can try to get something ready for you before my <a href="https://events.linuxfoundation.org/events/linuxcon-north-america/program/co-located-events">Linuxcon talk</a>. I also don't have any hardware RAID or physical hardware to test external storage partitions (bricks) on. If you have any that you can donate or let me hack on for a while, there are some features I'd like to test. <a title="contact" href="/contact/">Contact me</a>!

I've got a few more things queued up too, but you'll have to wait and see. Until then,

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
