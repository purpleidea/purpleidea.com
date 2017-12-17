+++
date = "2013-04-08 21:27:29"
title = "Knowing when to release and deploy your code (...and a mini script)"
draft = "false"
categories = ["technical"]
tags = ["gluster", "hack", "pgo", "TODO", "XXX", "devops", "FIXME", "bash", "puppet"]
author = "jamesjustjames"
+++

Knowing when to release and deploy your code can turn into a complicated discussion. In general, In general, I tend to support <a href="https://en.wikipedia.org/wiki/Release_early,_release_often">releasing early and often</a>, for some value of <em>$early</em> and <em>$often</em>. I've decided to keep this simple and introduce you to one metric that I use...

I think that I am fairly diligent in adding plenty of comments to my source code. I might even sometimes add too many. I create plenty of XXX, FIXME, or TODO tagged comments as reminders of things to work on.

To me, XXX represents an important problem that should get looked at or fixed; FIXME, reminds me that I should definitely look into something, and finally, TODO gives me homework or things to pursue when I'm in need of a new project.

I try to resolve most if not all XXX tagged comments before making a 0.1 release, FIXME's to consider something very stable, and a lack of TODO's mean something is completely done for now.

To count all these, I wrote a little tool that greps through the top-level directories in my <em>~/code/</em> folder, and displays the results in a table. Feel free to give it a try, and use it for your own projects.

While I don't see this as a particularly game changing utility, it scratches my itch, and helps me keep up my bash skills. <a href="https://dl.dropbox.com/u/48553683/release%3F.sh">The code is available here.</a> Let me know if you have any improvements, or if the source isn't enough documentation for you.

Happy hacking,

James

