+++
date = "2013-09-18 23:59:28"
title = "Linuxcon day three, Wednesday"
draft = "false"
categories = ["technical"]
tags = ["beaglebone", "devops", "gluster", "linuxcon", "minnowboard", "planetdevops", "planetpuppet", "puppet", "puppet-gluster", "the cloudcast"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/18/linuxcon-day-three-wednesday/"
+++

After hacking away on <a title="Linuxcon day one, Monday" href="/blog/2013/09/18/linuxcon-day-one-monday/">Monday</a> and <a title="Linuxcon day two, Tuesday" href="/blog/2013/09/18/linuxcon-day-two-tuesday/">Tuesday</a> and meeting fellow nerds IRL, I've landed even more changes to <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a>. <a href="https://github.com/purpleidea/puppet-gluster/commits/master">My git master branch now sits at 47 commits.</a>
```
$ git clone https://github.com/purpleidea/puppet-gluster.git
Cloning into 'puppet-gluster'...
remote: Counting objects: 317, done.
remote: Compressing objects: 100% (144/144), done.
remote: Total 317 (delta 187), reused 275 (delta 148)
Receiving objects: 100% (317/317), 82.17 KiB | 12.00 KiB/s, done.
Resolving deltas: 100% (187/187), done.
$ cd puppet-gluster/
$ git log | grep '^commit' | wc -l
47
$ git log | head
commit <a href="https://github.com/purpleidea/puppet-gluster/commit/fa3fd2eb4bab499031274e0918a40e7a99fe0086">fa3fd2eb4bab499031274e0918a40e7a99fe0086</a>
Author: James Shubin <<em>hidden</em>>
Date:   Wed Sep 18 17:53:13 2013 -0400

    Added fancy volume creation.
    
    This moves the command into a separate file. This also adds temporary
    saving of stdout and stderr to /tmp for easy debugging of command
    output.
```
As you can see above, volume creation is now "<em>fancier</em>" and more robust. In case things go wrong, it's easy to get fast access to gluster command line output (saved in <em>/tmp/</em>), and the volume creation commands are individually stored in your puppet-gluster working directory. Usually this is <em>/var/lib/puppet/tmp/gluster/</em>, and each volume creation command is in the <em>volume</em> subdirectory.

I also met gluster expert <a href="https://twitter.com/JoeCyberGuru">Joe Julian</a>. He's been recently hired at Rackspace. Congratulations Joe. We talked about puppet and gluster, and is very knowledgeable about gluster internals and <a href="https://en.wikipedia.org/wiki/Pro_re_nata">PRN</a> source diving.

<a href="http://www.thecloudcast.net/2013/09/the-cloudcast-111-real-world-puppet.html">I was interviewed</a> by <em><a href="https://twitter.com/aarondelp">Aaron Delp</a></em> and <em><a href="https://twitter.com/bgracely">Brian Gracely</a></em>, on <a href="http://www.thecloudcast.net/2013/09/the-cloudcast-111-real-world-puppet.html"><em>The Cloudcast</em></a>. These two gentlemen are a pleasure to sit and chat with. Check out their podcast. We talked about puppet, gluster, puppet-gluster and how to dive in. Feel free to comment or email me if you have any questions about something that we didn't cover in the interview.

All week, I've been hacking along side <a href="http://elinux.org/Jayneil_Dalal">Jayneil Dalal</a> in the speaker room. He was kind enough to give me a <a href="http://beagleboard.org/Products/BeagleBone%20Black">Beagle Bone black</a>! Where will its hack potential take you? Two features which are particularly useful are on-board Ethernet, and 2GB of flash storage. He's at the conference showing off some <a href="http://www.minnowboard.org/">Minnow boards</a>. They've got an Intel atom chip on board if you need something a little beefier.

I'm giving my puppet-gluster talk tomorrow (Thursday) here at <a href="http://events.linuxfoundation.org/events/linuxcon-north-america/program/co-located-events">Linuxcon</a>! I hope you can make it. I'll even have a live demo. Until then,

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
