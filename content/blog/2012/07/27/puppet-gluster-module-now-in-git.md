+++
date = "2012-07-27 00:48:50"
title = "puppet gluster module now in git"
draft = "false"
categories = ["technical"]
tags = ["gluster", "puppet", "devops", "git", "github"]
author = "jamesjustjames"
+++

The thoughtful <a href="https://twitter.com/bodepd/">bodepd</a> has been kind enough to help me get my <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> module off the ground and publicized a bit too. My first few commits have been all clean up to get my initial hacking up to snuff with the puppet style guidelines. Sadly, I love indenting my code with tabs, and this is against the puppet rules :(

[caption id="attachment_154" align="alignnone" width="584"]<a href="http://ttboj.files.wordpress.com/2012/07/tabsspacesboth1.png"><img class="size-full wp-image-154" title="TabsSpacesBoth" src="http://ttboj.files.wordpress.com/2012/07/tabsspacesboth1.png" alt="i'm actually a vim user though, sorry rms." width="584" height="264" /></a> http://www.emacswiki.org/emacs/TabsSpacesBoth[/caption]

I'll be accepting patches by email, but I'd prefer discussion first, especially since I've got a few obvious things brewing in my mental queue that should hit master shortly.

Are you a gluster expert who's weak at puppet? I'm keen to implement many of the common raid, file system and gluster performance optimization's directly into the module, so that the out of box experience for new users is a fast, streamlined, experience.

Are you a puppet expert who knows a bit of gluster? I'm not sure what the best way to handle large config changes, such as expanding volumes, or replacing bricks is. I can imagine a large state diagram that would be very hard to wholly implement in puppet. So for now, I'm missing a few edge cases, but hopefully this module will be able to solve more of them over time.

I've included an examples/ directory in the repository, to give you an idea of how this works for now. Stay tuned for more commits!
```
git clone https://github.com/purpleidea/puppet-gluster.git
```
Happy hacking,
James

