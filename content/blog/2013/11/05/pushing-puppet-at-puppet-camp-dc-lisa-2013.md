+++
date = "2013-11-05 15:00:19"
title = "Pushing Puppet at Puppet Camp DC, LISA 2013"
draft = "false"
categories = ["technical"]
tags = ["Puppet Camp D.C.", "devops", "fsm", "gluster", "hacks", "lisa2013", "planetfedora", "puppet", "puppet hacks", "puppet-fsm", "puppet-gluster", "puppet-ipa", "pushing puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/11/05/pushing-puppet-at-puppet-camp-dc-lisa-2013/"
+++

Hi there,

I hope you enjoyed my "<strong>Pushing Puppet</strong> (to its limit)" talk and demos from <a href="https://puppetcampdc2013.eventbrite.com/">Puppet Camp D.C., LISA 2013</a>. As requested, I've posted the code and slides.

Here is the code:
<a href="https://github.com/purpleidea/puppet-pushing">https://github.com/purpleidea/puppet-pushing</a>

This module will require three modules as dependencies. The dependencies are:
<ul>
	<li><span style="text-decoration:underline;">My Puppet-Common module</span>
<a href="https://github.com/purpleidea/puppet-common">https://github.com/purpleidea/puppet-common</a></li>
	<li><span style="text-decoration:underline;">My Puppet-Runonce module</span>
<a href="https://github.com/purpleidea/puppet-runonce">https://github.com/purpleidea/puppet-runonce</a></li>
	<li>My Puppet-FSM module
<a href="https://github.com/purpleidea/puppet-fsm">https://github.com/purpleidea/puppet-fsm</a></li>
</ul>
Each example doesn't require all the dependencies, so if you're only interested in the <a href="https://en.wikipedia.org/wiki/Finite-state_machine">FSM</a>, you only need that module.

Here are the slides:
<a href="https://github.com/purpleidea/puppet-pushing/blob/master/talks/pushing-puppet.pdf">https://github.com/purpleidea/puppet-pushing/blob/master/talks/pushing-puppet.pdf</a>

Here is the bug fix to fix my third <em>Exec['again']</em> demo:
<a href="https://github.com/purpleidea/puppet-common/commit/df3d004044f013415bb6001a2defd64b587d3b85">https://github.com/purpleidea/puppet-common/commit/df3d004044f013415bb6001a2defd64b587d3b85</a>

It's my fault that I added the fancy <em>--delta</em> support, but forgot to test the simpler, version again. Woops.

I've previously written about some of this puppet material. Read through these articles for more background and details:
<ul>
	<li><a href="/blog/2012/11/20/recursion-in-puppet-for-no-particular-reason/">Recursion in puppet for no particular reason</a></li>
	<li><a href="/blog/2012/11/14/setting-timed-events-in-puppet/">Setting timed events in puppet</a></li>
	<li><a href="/blog/2013/09/28/finite-state-machines-in-puppet/">Finite state machines in puppet</a></li>
</ul>
I haven't yet written articles about all the techniques used during my talk. I'll try to write future articles about these topics if you're interested.

If anyone has some photos from the talk, I'd love for you to send me a copy.

Special thanks to <a href="https://twitter.com/FeyNudibranch">Kara</a>, <a href="https://twitter.com/geekygirldawn">Dawn</a> and Puppet Labs for asking me to present.

If you'd like to <a title="live!" href="/talks/">invite me to teach, talk or consult</a>, I'd love to come visit your {<em>$SCHOOL</em>, <em>$WORK</em>, <em>$CITY</em>, etc}. <a title="contact" href="/contact/">Contact me!</a> I'll be around in D.C. till Friday if you'd like to meet up and hack on some of the code or examples that I've published.

If you're interested in looking at some of the "<em>real work</em>" modules that I've written, have a look through my <a href="https://github.com/purpleidea?tab=repositories">github repositories</a>. <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> and <a href="https://github.com/purpleidea/puppet-ipa">Puppet-IPA</a>, are two that you might find most interesting.

There are a few that I haven't yet published, so if you're looking for a fancy module to do <em>X</em>, let me know and I might be a few commits away from something helpful that I haven't made public yet.

I hope you enjoyed hacking on puppet with me, and please don't be shy -- leave me a comment about my talk, and ask questions if you have any.

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
