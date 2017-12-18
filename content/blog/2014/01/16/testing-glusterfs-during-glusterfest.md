+++
date = "2014-01-16 20:28:17"
title = "Testing GlusterFS during “Glusterfest”"
draft = "false"
categories = ["technical"]
tags = ["devops", "fedora", "gluster", "keepalived", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "qa", "testing", "vagrant", "vrrp"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/01/16/testing-glusterfs-during-glusterfest/"
+++

The GlusterFS community is having a "test day". <a title="Automatically deploying GlusterFS with Puppet-Gluster + Vagrant!" href="/blog/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/">Puppet-Gluster+Vagrant</a> is a great tool to help with this, and it has now been patched to support <em>alpha</em>, <em>beta</em>, <em>qa</em>, and <em>rc</em> releases! Because it was built so well (<strong>\*</strong><em>cough</em><strong>\*</strong>, shameless plug), it only took <a href="https://github.com/purpleidea/puppet-gluster/commit/30392fd0cb4e2bd0e39faea83915bfe8a6574bbc">one patch</a>.

Okay, first make sure that your Puppet-Gluster+Vagrant setup is working properly. I have only tested this on Fedora 20. Please read:
<blockquote><a href="/blog/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/">Automatically deploying GlusterFS with Puppet-Gluster+Vagrant!</a></blockquote>
to make sure you're comfortable with the tools and infrastructure.

This weekend we're testing <code>3.5.0 beta1</code>. It turns out that the full rpm version for this is:
```
3.5.0-0.1.beta1.el6
```
You can figure out these strings yourself by browsing the folders in:

<a href="https://download.gluster.org/pub/gluster/glusterfs/qa-releases/">https://download.gluster.org/pub/gluster/glusterfs/qa-releases/</a>

To test a specific version, use the <code>--gluster-version</code> argument that I added to the vagrant command. For this deployment, here is the list of commands that I used:

{{< highlight bash >}}
$ mkdir /tmp/vagrant/
$ cd /tmp/vagrant/
$ git clone --recursive https://github.com/purpleidea/puppet-gluster.git
$ cd vagrant/gluster/
$ vagrant up puppet
$ sudo -v && vagrant up --gluster-version='3.5.0-0.1.beta1.el6' --gluster-count=2 --no-parallel
{{< /highlight >}}
As you can see, this is a standard vagrant deploy. I've decided to build two gluster hosts (<code>--gluster-count=<em>2</em></code>) and I'm specifying the version string shown above. I've also decided to build in series (<code>--no-parallel<em></em></code>) because I think there might be some hidden race conditions, possibly in the vagrant-libvirt stack.

After about five minutes, the two hosts were built, and about six minutes after that, <a title="Vagrant vsftp and other tricks" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> had finished doing its magic. I had logged in to watch the progress, but if you were out getting a coffee, when you came back you could run:
```
$ gluster volume info
```
to see your newly created volume!

If you want to try a different version or host count, you don't need to destroy the entire infrastructure. You can destroy the gluster annex hosts:
```
$ vagrant destroy annex{1..2}
```
and then run a new <code>vagrant up</code> command.

In addition, I've added a <code>--gluster-firewall</code> option. Currently it defaults to false because there's a strange firewall bug blocking my <a href="https://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol">VRRP</a> (keepalived) setup. If you'd like to enable it and help me fix this bug, you can use:
```
--gluster-firewall=true
```
To make sure the firewall is off, you can use:
```
--gluster-firewall=false
```
In the future, I will change the default value to <em>true</em>, so specify it explicitly if you need a certain behaviour.

Happy hacking,

James

