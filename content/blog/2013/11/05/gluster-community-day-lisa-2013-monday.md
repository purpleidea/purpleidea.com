+++
date = "2013-11-05 01:30:05"
title = "Gluster Community Day, LISA 2013, Monday"
draft = "false"
categories = ["technical"]
tags = ["geo-replication", "gluster", "microserver cluster", "gluster community day", "lisa2013", "planetfedora", "puppet"]
author = "jamesjustjames"
+++

I'm here at LISA 2013 at the <a href="http://glusterday-lisa.eventbrite.com/">Gluster Community Day</a>. I've been asked by <a href="https://twitter.com/jzb">Joe Brockmeier</a> to give a little recap about what's been going on. So here it is!

<a href="https://twitter.com/wphotos">Wesley Duffee-Braun</a> started off with a nice overview talk about <a href="http://www.gluster.org/">GlusterFS</a>. The great thing about his talk was that he gave a live demo, running on virtual machines, on his laptop. If you're a new GlusterFS user, this is good exposure to help you get started. He also has the nicest slides I've ever seen. Someone needs to send me the .<em>odp</em> template!

<a href="https://twitter.com/ecoreply">Eco Willson</a> gave the next talk about geo-replication, and discussed a few other GlusterFS topics too. I particularly enjoyed when he talked to us about the upcoming changes. I understood that this would include the ability to have multiple geo-replication daemons across each distributed part of each volume, and, <a href="https://en.wikipedia.org/wiki/High_availability">HA</a> between the <em>N</em> brick replicas. This way, your workload is split across the volume, and if a replica is down, one of the other copies can take over and continue the sync.

During lunch, I got to meet <a href="https://twitter.com/Obdurodon">Jeff Darcy</a> and talk a bit about storage and feature ideas on my wish-list. He knew my <a href="https://twitter.com/#!/purpleidea">twitter</a>/<a href="http://webchat.freenode.net/">IRC</a> handle, so he instantly gets 200 bonus points. <a href="http://pl.atyp.us/">You should probably checkout his blog if you haven't already.</a>

After lunch I gave my talk about <a title="puppet-gluster" href="http://ttboj.wordpress.com/code/puppet-gluster/">puppet-gluster</a>, and successfully gave two live demos. I'm really due for a blog post about some of the new features that I've added. I'll try to put together a screen cast in the future. If you're really keen on trying out some of the new features, I'm happy to share a screen session on your hosts and walk you through it. When run fully automatically, it takes between five and ten minutes to deploy a featureful GlusterFS!

I won't be able to hack on this project for free, forever. If you're able to donate test hardware, VM time, or sponsor a feature, it would be appreciated. I'm particularly interested in building a GlusterFS microserver cluster. If you're interested in this too, let me know.

Wesley came back for round two to demo the <a href="https://forge.gluster.org/puppet-gluster">GlusterForge</a> (hi <a href="https://twitter.com/johnmark">John Mark</a>!) and <a href="https://forge.gluster.org/glusterinfo">Glusterinfo</a>, which I hadn't ever used. Nobody knew why certain projects are still "incubating", when they're mostly likely cooked through by now.

At this point, we had some left over time for questions and discussion. Jeff, Eco, and I formed a loosely organized "panel" to answer questions. Joe took a photo, and now owes me a copy, since I've never really been on a "panel" before. Jeff knows his GlusterFS internals very well. I should have come prepared with some hard questions!

<a href="http://rhsummit.files.wordpress.com/2013/07/england_th_0450_rhs_perf_practices-4_neependra.pdf">To whoever was looking for Ben England's RHS performance talk, it's available here</a>.

Overall, it was a very nice little event, and I hope the attendees enjoyed it. If I forgot anything, please feel free to add it into the comments. I'd also love to hear about what you enjoyed or didn't enjoy about my talk. <a title="contact" href="http://ttboj.wordpress.com/contact/">Let me know</a>!

Happy Hacking,

James

