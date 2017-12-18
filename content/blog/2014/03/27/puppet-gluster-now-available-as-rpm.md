+++
date = "2014-03-27 20:32:41"
title = "Puppet-Gluster now available as RPM"
draft = "false"
categories = ["technical"]
tags = ["centos", "devops", "fedora", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-common", "puppet-gluster", "puppet-keepalived", "puppet-puppet", "puppet-shorewall", "puppet-yum", "puppetlabs-stdlib", "rpm", "wizard", "yum"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/03/27/puppet-gluster-now-available-as-rpm/"
+++

I've been afraid of <a href="https://en.wikipedia.org/wiki/RPM_Package_Manager">RPM</a> and package maintaining [1] for years, but thanks to <a href="http://www.keithley.org/kaleb/kaleb.html">Kaleb Keithley</a>, I have finally made some RPM's that weren't generated from a <a href="http://docs.python.org/3/distutils/builtdist.html">high level tool</a>. Now that I have the <a href="https://github.com/purpleidea/puppet-gluster/commit/241956937f9778c332335267fac1256792c71155">boilerplate</a> done, it's a relatively painless process!

In case you don't know <a href="https://twitter.com/kalebkuechle">kkeithley</a>, he is a wizard [2] who happens to also be especially cool and hardworking. If you meet him, be sure to buy him a <a href="https://en.wikipedia.org/wiki/Beer"><em>$BEVERAGE</em></a>. &lt;/plug&gt;

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="wizard_penguin.png"><img class="size-large wp-image-799" src="wizard_penguin.png" alt="A photo of kkeithley after he (temporarily) transformed himself into a wizard penguin." width="100%" height="100%" /></a></td></tr><tr><td> A photo of kkeithley after he (temporarily) transformed himself into a wizard penguin.</td></tr></table></br />

<a href="https://github.com/purpleidea/puppet-gluster/commit/241956937f9778c332335267fac1256792c71155">The full source of my changes is available in git.</a>

If you want to make the RPM's yourself, simply clone the <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">puppet-gluster</a> source, and run: <code>make rpm</code>. If you'd rather download pre-built RPM's, SRPM'S, or source tarballs, they are all being graciously hosted on <a href="https://dl.fedoraproject.org/pub/alt/purpleidea/puppet-gluster/">download.gluster.org</a>, thanks to <a href="https://twitter.com/johnmark">John Mark Walker</a> and the <a href="http://www.gluster.org/">gluster.org</a> community.

These RPM's will install their contents into <code>/usr/share/puppet/modules/</code>. They should work on <a href="https://fedoraproject.org/">Fedora</a> or <a href="https://www.centos.org/">CentOS</a>, but they do require a <code>puppet</code> package to be installed. I hope to offer them in the future as part of a repository for easier consumption.

There are also <a href="https://dl.fedoraproject.org/pub/alt/purpleidea/">RPM's available</a> for <a title="Screencasts of Puppet-Gluster + Vagrant" href="https://github.com/purpleidea/puppet-common">puppet-common</a>, <a href="https://github.com/purpleidea/puppet-keepalived">puppet-keepalived</a>, <a href="https://github.com/purpleidea/puppet-puppet">puppet-puppet</a>, <a href="https://github.com/purpleidea/puppet-shorewall">puppet-shorewall</a>, <a href="https://github.com/purpleidea/puppet-yum">puppet-yum</a>, and even <a href="https://github.com/purpleidea/puppetlabs-stdlib">puppetlabs-stdlib</a>. These are the dependencies required to install the <a title="Screencasts of Puppet-Gluster + Vagrant" href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> module.

Please let me know if you find any issues with any of the packages, or if you have any recommendations for improvement! I'm new to packaging, so I probably made some mistakes.

Happy Hacking,

James

<strong>[1]</strong> package maintainer, aka: "paintainer" - according to <a href="https://github.com/semiosis">semiosis</a>, who is right!

<strong>[2]</strong> wizard as in an <a href="http://www.catb.org/jargon/html/W/wizard.html">awesome, talented, hacker</a>.

