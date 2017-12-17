+++
date = "2012-07-19 18:26:54"
title = "my gluster setup, described"
draft = "false"
categories = ["technical"]
tags = ["devops", "gluster"]
author = "jamesjustjames"
+++

For the last ~two or so years I've played and tested <a href="http://download.gluster.com/pub/gluster/glusterfs/LATEST/CentOS/">gluster</a> on and off and hanging out in the awesome #gluster channel on <a href="http://freenode.net/">Freenode</a>. In case you haven't heard, gluster was <a href="http://www.redhat.com/promo/storage/press-release.html">acquired</a> by RedHat back in October 2011. This post describes my current setup. I urge you to send your comments and suggestions for improvement. I'll update this as needed.

<span style="text-decoration:underline;">Hardware</span>:
Ideology: I wanted to build individual self-contained storage hosts. I didn't want to have servers with separate (serial) attached storage (SAS) like Dell is often pushing. Supermicro fit the design goal, and sold me when I realized I could have the OS drives swappable out the back.
<ul>
	<li>4 x <a href="http://www.supermicro.com/products/system/4u/6047/ssg-6047r-e1r24n.cfm">Supermicro 6047R-E1R24N</a></li>
	<li>4 x 24 x 2TiB, 3.5" HDD (front, hot swappable main storage)</li>
	<li>4 x 2 x 600GiB, 2'5" HDD (<em>rear, hot swappable</em> os drives, awesome feature!)</li>
	<li>2 x quality stacked switches (with one leg of each bond device out to each switch)</li>
	<li>IPMI: absolutely required (It seems it's a bit buggy! I've had problems where the SOL console stops responding when dealing with a big stream of data, and I can only rescue it with a cold reset of the BMC.) Overall it's been sufficient to get me up and running.</li>
</ul>
<span style="text-decoration:underline;">OS</span>:
<ul>
	<li>CentOS 6.3+. I would consider using RHEL if their sales department could get organized and when RHEL integrates into my cobbler+puppet build system.</li>
	<li>Bonded (eth0,eth1 -&gt; bond0) ethernet for each machine. Possible upgrade to bonded 10GbE if ever needed. Interface eth0 on each machine plugs into switch0 and eth1 on each machine plugs into switch1.</li>
	<li>The 24 storage HDD's are split into two separate RAID 6's per machine.</li>
	<li>OS HDD's in software raid 1. Unfortunately anaconda/kickstart doesn't support RAID 1 for the EFI boot partitions. Maybe someone could fix this! (HINT, HINT)</li>
	<li>The machines pxeboot, kickstart and configure themselves automatically with cobbler+puppet.</li>
	<li>The LSI MSM tool (for monitoring the RAID) seems to give me a lot of trouble with false positive warnings about temperature thresholds. Apart from being stuck with proprietary crap ware, it does actually email me when drives fail. Alternatives welcome! I deploy this with a puppet module that I wrote. If it weren't for that, this step would drive me insane.</li>
</ul>
<span style="text-decoration:underline;">Gluster</span>:
<ul>
	<li>Each host has its drives split into two bricks. A gluster engineer recommended this for the type of setup I'm running.</li>
	<li>Each RAID6 set is formatted with xfs.</li>
	<li>Keepalived maintains a VIP (will replace with cman/corosync one day) which serves as the client hostname to connect to. This makes my setup a bit more highly available if one or more nodes go down.</li>
	<li>I have a puppet module which I use to describe/build my gluster setup. It's not perfect, but it <em>works for me</em> (tm). I'm cleaning it up, and will post it shortly.</li>
	<li>I'm using a distributed-replicate setup, with eight bricks (2 per node).</li>
	<li>I originally used the <a href="http://download.gluster.com/pub/gluster/glusterfs/LATEST/CentOS/">official packages</a> to get my gluster rpm's, but recently I switched to using: <a href="http://repos.fedorapeople.org/repos/kkeithle/glusterfs/epel-6/x86_64/">kkeithle</a>'s. Thanks for your hard work!</li>
</ul>
<span style="text-decoration:underline;">Conclusion</span>:

Let me know what other nitpick details you want to know about and I'll post them. A lot of things can also be inferred by reading my puppet module.

Happy Hacking,
James

