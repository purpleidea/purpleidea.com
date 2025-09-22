+++
date = "2015-08-18 03:12:26"
title = "Thanking Oh-My-Vagrant contributors for version 1.0.0"
draft = "false"
categories = ["technical"]
tags = ["1.0.0", "devops", "fedora", "gluster", "libvirt", "mainstream mode", "networking", "oh-my-vagrant", "planetdevops", "planetfedora", "planetpuppet", "puppet", "thanks", "vagrant", "vagrant-libvirt"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/08/18/thanking-oh-my-vagrant-contributors-for-version-1-0-0/"
+++

The <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant project</a> became public about one year ago and at the time it was more of a fancy template than a robust project, but 188 commits (and counting) later, it has gotten surprisingly useful and mature.
```
james@computer:~/code/oh-my-vagrant$ git rev-list HEAD --count
188
james@computer:~/code/oh-my-vagrant$ git log $(git log --pretty=format:%H|tail -1)
commit 4faa6c89cce01c62130ef5a6d5fa0fff833da371
Author: James Shubin <james@shubin.ca>
Date:   Thu Aug 28 01:08:03 2014 -0400

    Initial commit of vagrant-puppet-docker-template...
    
    This is an attempt to prototype a default environment for
    vagrant+puppet+docker hacking. More improvements are needed for it to be
    useful, but it's probably already useful as a reference for now.
```
It would be easy to take most of the credit for taking the project this far, as I've been responsible for about 87% of the commits, but as is common, the numbers don't tell the whole story. It is also a bug (but hopefully just an artifact) that I've had such a large percentage of commits. It's quite common for a new project to start this way, but for <a href="https://www.gnu.org/philosophy/free-sw.html">Free Software</a> to succeed long-term, it's essential that the users become the contributors. Let's try to change that going forward.
```
james@computer:~/code/oh-my-vagrant$ git shortlog -s | sort -rn
   165    James Shubin
     5    Vasyl Kaigorodov
     4    Randy Barlow
     2    Scott Collier
     2    Milan Zink
     2    Christoph Görn
     2    aweiteka
     1    scollier
     1    Russell Tweed
     1    ncoghlan
     1    John Browning
     1    Flavio Fernandes
     1    Carsten Clasohm
james@computer:~/code/oh-my-vagrant$ echo '165/188*100' | bc -l
87.76595744680851063800
```
The true story behind these 188 commits is the living history of the past year. Countless hours testing the code, using the project, suggesting features, getting hit by bugs, debugging issues, patching those bugs, and so on... If you could see an accurate graph of the number of hours put into the project, you'd see a much longer list of individuals, and I would have nowhere close to 87% of that breakdown.

<span style="text-decoration:underline;">Contributions are important!</span>

Contributions are important, and patches especially help. Patches from your users are what make something a community project as opposed to two separate camps of consumers and producers. It's about time we singled out some of those contributors!

<a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=vkaigoro@redhat.com"><span style="text-decoration:underline;">Vasyl Kaigorodov</span></a>

Vasyl is a great hacker who first <a href="https://github.com/purpleidea/oh-my-vagrant/commit/d021ebcad4c9ad65412ed3773bf805a29b3fda12">fixed the broken networking</a> in OMV. Before his work merged, it was not possible to run two different OMV environments at the same time. Now networking makes a lot more sense. Unfortunately the <a href="https://github.com/purpleidea/oh-my-vagrant/graphs/contributors">GitHub contributors graph</a> doesn't acknowledge his work because he doesn't have a GitHub account. Shame on them!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=rbarlow">Randy Barlow</a></span> (<a href="https://twitter.com/bowlofeggs">bowlofeggs</a>)

Randy came up with the idea for "<a href="/blog/2015/07/08/oh-my-vagrant-mainstream-mode-and-copr-rpms/">mainstream mode</a>", and while his initial proof of concept didn't quite work, the idea was good. His time budget didn't afford the project this new feature, but he has sent in some other patches including <a href="https://github.com/purpleidea/oh-my-vagrant/commit/94534dfa6f3728fab00cbd47606e1dffe209c31e">some</a>, <a href="https://github.com/purpleidea/oh-my-vagrant/commit/c85c7962fe44e933792c7f338d702e7fb338f07c">tweaks</a> used by the <a href="http://www.pulpproject.org/">Pulp</a> Vagrantfile. He's got a patch or two pending on his TODO list which we're looking forward to, as he finishes the work to port Pulp to OMV.

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=scollier">Scott Collier</a></span>

Scott is a great model user. He gets very enthusiastic, he's great at testing things out and complaining if they don't behave as he'd like, and if you're lucky, you can brow beat him to write a quick patch or two. He actually has three commits in the project so far, which would show up correctly above if he had set his git user variables correctly ;) Thanks for spending the time to deal with OMV when there was a lot more cruft, and fewer features. I look forward to your next patch!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=mzink@redhat.com">Milan Zink</a></span>

Milan is a ruby expert who fixed the ruby xdg bugs we had in an earlier version of the project. Because of his work new users don't even realize that there was ever an issue!

<span style="text-decoration:underline;"><a href="https://github.com/goern/">Christoph Görn</a></span>

Christoph has been an invaluable promoter and dedicated user of the project. His work pushing OMV to the limit has generated real world requirements and feature requests, which have made the project useful for real users! It's been hard to say no when he opens an issue ticket, but I've been able to force him to write a <a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=goern">patch or two</a> as well.

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=rtweed">Russell Tweed</a></span>

Russell is a new OMV user who jumped right into the code and sent in a patch for <a href="https://github.com/purpleidea/oh-my-vagrant/commit/ae484b2e5fad6f8188d861a97c64b874fe3965ab">adding an arbitrary number of disks to OMV machines</a>. As a first time contributor, I thank him for his patch and for withstanding the number of reviews it had to go through. It's finally merged, even though we might have let one <a href="https://github.com/purpleidea/oh-my-vagrant/commit/b03fe1e3fc3090d6846fcd068040f4ec037de436">bug (now fixed) slip in too</a>. I particularly like his patch, because <a href="https://github.com/pradels/vagrant-libvirt/commit/be2042537e4f8f3e59a7880bf3e09358252be252">I actually wrote the initial patch to add extra disks support to vagrant-libvirt</a>, and I'm pleased to see it get used one level up!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=johbro">John Browning</a></span>

John actually found an edge case in the subscription manager code and after an interesting discussion, <a href="https://github.com/purpleidea/oh-my-vagrant/commit/3f03325bc4b7866e108d8aec1f4ef4ad6af5e359">patched the issue</a>. More users means more edge cases will fall out! Thanks John!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=flavio-fernandes">Flavio Fernandes</a></span>

Even though Flavio is an OSX user, we're thankful that <a href="https://github.com/purpleidea/oh-my-vagrant/commit/2595f1206c6d5214c80c6ee255185a91371370de">he wrote and tested the virtualbox patch</a> for OMV. OMV still needs an installer for OSX + mainstream mode, but once that's done, we know the rest will work great!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=clasohm">Carsten Clasohm</a></span>

Carsten actually wrote a lovely patch for a subtle OMV issue that is very hard to reproduce. I was able to merge <a href="https://github.com/purpleidea/oh-my-vagrant/commit/b29247070855d7f18bb81bf3409decae2677e11c">his patch</a> on the first review, and in fact it looked nicer than how I would have written it!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=ncoghlan">Nick Coghlan</a></span>

Nick is actually a python hacker, so getting a ruby contribution proved a bit tricky! Fortunately, he is also a master of words, and helped clean up the <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/DOCUMENTATION.md">documentation</a> a bit. We'd love to get a few more doc patches if you have the time and <a href="https://github.com/purpleidea/oh-my-vagrant/issues/79">some love</a>!

<span style="text-decoration:underline;"><a href="https://github.com/purpleidea/oh-my-vagrant/commits?author=aweiteka">Aaron Weitekamp</a></span>

Even though aweiteka (as we call him) has only added five lines of source (2 of which were comments), he was an early user and tester, and we thank him for his contributions! Hopefully we'll see him in our commit logs in the future!

<a href="https://twitter.com/mairin"><span style="text-decoration:underline;">Máirín Duffy</span></a>

Máirín is a talented artist who does great work using <a href="https://mako.cc/writing/hill-free_tools.html">free tools</a>. I asked her if she'd be kind enough to make us a logo, and I'll hopefully be able to show it to you soon!

<span style="text-decoration:underline;">Everyone else</span>

To everyone else who isn't in the commit log yet, thank you for using and testing OMV, finding bugs, opening issues and even for your social media love in getting the word out! I hope to get a patch from you soon!

<span style="text-decoration:underline;">The power of the unknown user</span>

They're sometimes hard to measure, but a recently introduced bug was reported to me independently by two different (and previously unknown) users very soon after the bug was introduced! I'm sorry for letting the bug in, but I am glad that people picked up on it so quickly! I'd love to have your help in improving our <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/test.sh">automated test infrastructure</a>!

<span style="text-decoration:underline;">The <code>AUTHORS</code> file</span>

Every good project needs a "hall of fame" for its contributors. That's why, starting today there is an <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/AUTHORS"><code>AUTHORS</code></a> file, and if you're a contributor, we urge you to send a one-line patch with your name, so it can be immortalized in the project forever. We could try to generate this file with <code>git log</code>, but that would remove the prestige behind getting your first and second patches in. If you're not in the <code>AUTHORS</code> file, and you should be, send me your patch already!

<span style="text-decoration:underline;">Version 1.0.0</span>

I think it's time. The project deserves a 1.0.0 release, <a href="https://github.com/purpleidea/oh-my-vagrant/releases/tag/1.0.0">and I've now made it so</a>. Please <a href="https://en.wikipedia.org/wiki/The_Hitchhiker%27s_Guide_to_the_Galaxy">share and enjoy</a>!

I hope you enjoy this project, and I look forward to receiving your patch.

Happy Hacking!

James

PS: Thanks to <a href="https://github.com/bmbouter">Brian Bouterse</a> for encouraging me to focus on community, and for inspiring me to write this post!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
