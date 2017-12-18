+++
date = "2014-10-10 15:34:53"
title = "Continuous integration for Puppet modules"
draft = "false"
categories = ["technical"]
tags = ["blacksmith", "ci", "forge", "freeipa", "git", "gluster", "jenkins", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "puppet-ipa", "travis"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/10/10/continuous-integration-for-puppet-modules/"
+++

I just patched <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> and <a href="https://github.com/purpleidea/puppet-ipa">puppet-ipa</a> to bring their infrastructure up to date with the current state of affairs...

<span style="text-decoration:underline;">What's new</span>?
<ul>
	<li>Better README's</li>
	<li><a href="https://github.com/purpleidea/puppet-ipa/blob/master/Rakefile">Rake syntax checking</a> (fewer oopsies)</li>
	<li><a href="https://en.wikipedia.org/wiki/Continuous_integration">CI</a> (testing) with <a href="https://github.com/purpleidea/puppet-ipa/blob/master/.travis.yml">travis</a> on git push (automatic testing for everyone)</li>
	<li>Use of <a href="https://projects.puppetlabs.com/issues/14651"><code>.pmtignore</code></a> to ignore files from puppet module packages (finally)</li>
	<li>Pushing modules to the forge with <a href="https://github.com/maestrodev/puppet-blacksmith">blacksmith</a> (sweet!)</li>
</ul>
This last point deserves another mention. Puppetlabs created the "forge" to try to provide some sort of added value to their stewardship. Personally, I like to look for code on <a href="https://github.com/purpleidea/">github</a> instead, but nevertheless, some do use the forge. The problem is that to upload new releases, <a href="https://twitter.com/purpleidea/status/520635052850675712">you need to click your mouse like a windows user</a>! Someone has finally solved that problem! If you use blacksmith, a new build is just a <code>rake push</code> away!

Have a look at <a href="https://github.com/purpleidea/puppet-gluster/commit/f24cca2ac8d138aae71c019a9bf6f311395f562d">this example commit</a> if you're interested in seeing the plumbing.

<span style="text-decoration:underline;">Better documentation and FAQ answering</span>:

I've answered a lot of questions by email, but this only helps out individuals. From now on, I'd appreciate if you asked your question in the form of a patch to my FAQ. (<a href="https://github.com/purpleidea/puppet-gluster/blob/master/DOCUMENTATION.md#usage-and-frequently-asked-questions">puppet-gluster</a>, <a href="https://github.com/purpleidea/puppet-ipa/blob/master/DOCUMENTATION.md#usage-and-frequently-asked-questions">puppet-ipa</a>)

I'll review and merge your patch, including a follow-up patch with the answer! This way you'll get more familiar with git and sending small patches, everyone will benefit from the response, and I'll be able to point you to the docs (and even a specific commit) to avoid responding to already answered questions. You'll also have the commit information of something else who already had this problem. Cool, right?

Happy hacking,

James

