+++
date = "2014-01-08 23:00:22"
title = "Automatically deploying GlusterFS with Puppet-Gluster + Vagrant!"
draft = "false"
categories = ["technical"]
tags = ["NFS", "devops", 'exec["again"]', "fedora", "fedora 20", "gluster", "gluster::simple", "keepalived", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "shorewall", "testing", "vagrant", "vagrant-cachier", "vagrant-libvirt", "vcssh", "vrrp"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/"
+++

<a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> was always about automating the deployment of <a href="https://www.gluster.org/">GlusterFS</a>. Getting your own Puppet server and the associated infrastructure running was never included "<em>out of the box</em>". <strong>Today, it is!</strong> (This is big news!)

I've used <a href="https://www.vagrantup.com/">Vagrant</a> to automatically build these GlusterFS clusters. I've tested this with <a href="https://fedoraproject.org/">Fedora 20</a>, and <a href="https://github.com/pradels/vagrant-libvirt/">vagrant-libvirt</a>. This won't work with Fedora 19 because of <a href="https://bugzilla.redhat.com/show_bug.cgi?id=876541">bz#876541</a>. I recommend first reading my earlier articles for Vagrant and Fedora:
<ul>
	<li>
<blockquote><a href="/blog/2013/12/09/vagrant-on-fedora-with-libvirt/">Vagrant on Fedora with libvirt</a></blockquote>
</li>
	<li>
<blockquote><a href="/blog/2013/12/21/vagrant-vsftp-and-other-tricks/">Vagrant vsftp and other tricks</a></blockquote>
</li>
	<li>
<blockquote><a href="/blog/2014/01/02/vagrant-clustered-ssh-and-screen/">Vagrant clustered SSH and 'screen'</a></blockquote>
</li>
</ul>
Once you're comfortable with the material in the above articles, we can continue...

<strong><span style="text-decoration:underline;">The short answer</span>:</strong>

{{< highlight bash >}}
$ sudo service nfs start
$ git clone --recursive https://github.com/purpleidea/puppet-gluster.git
$ cd puppet-gluster/vagrant/gluster/
$ vagrant up puppet && sudo -v && vagrant up
{{< /highlight >}}
Once those commands finish, you should have four running gluster hosts, and a puppet server. The gluster hosts will still be building. You can log in and <code>tail -F</code> log files, or <code>watch -n 1</code> gluster status commands.

The whole process including the one-time downloads took about 30 minutes. If you've got faster internet that I do, I'm sure you can cut that down to under 20. Building the gluster hosts themselves probably takes about 15 minutes.

Enjoy your new Gluster cluster!

<strong><span style="text-decoration:underline;">Screenshots</span>!</strong>

I took a few screenshots to make this more visual for you. I like to have <a href="http://virt-manager.org/">virt-manager</a> open so that I can visually see what's going on:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="virt-manager.png"><img class="size-full wp-image-702" alt="The annex{1..4} machines are building in parallel." src="virt-manager.png" width="100%" height="100%" /></a></td></tr><tr><td> The annex{1..4} machines are building in parallel. The valleys happened when the machines were waiting for the vagrant DHCP server (dnsmasq).</td></tr></table></br />

Here we can see two puppet runs happening on <em>annex1</em> and <em>annex4</em>.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="virt-manager-puppet.png"><img class="size-full wp-image-703" alt="Notice the two peaks on the puppet server which correspond to the valleys on annex{1,4}." src="virt-manager-puppet.png" width="100%" height="100%" /></a></td></tr><tr><td> Notice the two peaks on the puppet server which correspond to the valleys on annex{1,4}.</td></tr></table></br />

Here's another example, with four hosts working in parallel:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="virt-manager-puppet2.png"><img class="size-full wp-image-704" alt="foo" src="virt-manager-puppet2.png" width="100%" height="100%" /></a></td></tr><tr><td> Can you answer why the annex machines have two peaks? Why are the second peaks bigger?</td></tr></table></br />

<strong><span style="text-decoration:underline;">Tell me more</span>!</strong>

Okay, let's start with the command sequence shown above.
```
$ sudo service nfs start
```
This needs to be run <em>once</em> if the NFS server on your host is not already running. It is used to provide folder synchronization for the Vagrant guest machines. I offer more information about the NFS synchronization in an <a href="/blog/2013/12/21/vagrant-vsftp-and-other-tricks/">earlier article</a>.
```
$ git clone --recursive https://github.com/purpleidea/puppet-gluster.git
```
This will pull down the Puppet-Gluster source, and all the necessary submodules.
```
$ cd puppet-gluster/vagrant/gluster/
```
The Puppet-Gluster source contains a <em>vagrant</em> subdirectory. I've included a <em>gluster</em> subdirectory inside it, so that your machines get a sensible prefix. <a href="https://github.com/pradels/vagrant-libvirt/issues/121">In the future, this might not be necessary.</a>
```
$ vagrant up puppet && sudo -v && vagrant up
```
This is where the fun stuff happens. You'll need a <a href="https://docs.vagrantup.com/v2/boxes.html">base box</a> image to run machines with Vagrant. Luckily, I've already built one for you, and it is generously hosted by the <a href="https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/">Gluster community</a>.

The very first time you run this Vagrant command, it will download this image automatically, install it and then continue the build process. This initial box download and installation only happens once. Subsequent Puppet-Gluster+Vagrant deploys and re-deploys won't need to re-download the base image!

This command starts by building the puppet server. Vagrant might use sudo to prompt you for root access. This is used to manage your <code>/etc/exports</code> file. After the puppet server is finished building, we refresh the sudo cache to avoid <a href="https://github.com/mitchellh/vagrant/issues/2680">bug #2680</a>.

The last <code>vagrant up</code> command starts up the remaining gluster hosts in parallel, and kicks off the initial puppet runs. As I mentioned above, the gluster hosts will still be building. Puppet automatically waits for the cluster to "settle" and enter a steady state (no host/brick changes) before it creates the first volume. You can log in and <code>tail -F</code> log files, or <code>watch -n 1</code> gluster status commands.

At this point, your cluster is running and you can do whatever you want with it! Puppet-Gluster+Vagrant is meant to be easy. If this wasn't easy, or you can think of a way to make this better, let me know!

<strong><span style="text-decoration:underline;">I want <em>N</em> hosts, not 4</span>:</strong>

By default, this will build four (4) gluster hosts. I've spent a lot of time writing a fancy <em>Vagrantfile</em>, to give you speed and configurability. If you'd like to set a different number of hosts, you'll first need to destroy the hosts that you've built already:
```
$ vagrant destroy annex{1..4}
```
You don't have to rebuild the puppet server because this command is clever and automatically cleans the old host entries from it! This makes re-deploying even faster!

Then, run the <code>vagrant up</code> command with the <code>--gluster-count=<em><N></em></code> argument. Example:
```
$ vagrant up --gluster-count=8
```
This is also configurable in the <code>puppet-gluster.yaml</code> file which will appear in your vagrant working directory. Remember that before you change any configuration option, you should destroy the affected hosts first, otherwise vagrant can get confused about the current machine state.

<strong><span style="text-decoration:underline;">I want to test a different GlusterFS version</span>:</strong>

By default, this will use the packages from:

<a href="https://download.gluster.org/pub/gluster/glusterfs/LATEST/">https://download.gluster.org/pub/gluster/glusterfs/LATEST/</a>

but if you'd like to pick a specific GlusterFS version you can do so with the <code>--gluster-version=<em>&lt;<strong>version</strong>&gt;</em></code> argument. Example:
```
$ vagrant up --gluster-version='3.4.2-1.el6'
```
This is also stored, and configurable in the <code>puppet-gluster.yaml</code> file.

<strong><span style="text-decoration:underline;">Does (repeating) this consume a lot of bandwidth</span>?</strong>

Not really, no. There is an initial download of about <em>450MB</em> for the base image. You'll only ever need to download this again if I publish an updated version.

Each deployment will hit a public mirror to download the necessary <em>puppet</em>, <em>GlusterFS</em> and <em>keepalived</em> packages. The puppet server caused about <em>115MB</em> of package downloads, and each gluster host needed about <em>58MB</em>.

The great thing about this setup, is that it is integrated with <a href="https://github.com/fgrehm/vagrant-cachier">vagrant-cachier</a>, so that you don't have to re-download packages. When building the gluster hosts in parallel (the default), each host will have to download the necessary packages into a separate directory. If you'd like each host to share the same cache folder, and save yourself <em>58MB</em> or so per machine, you'll need to build in series. You can do this with:
```
$ vagrant up --no-parallel
```
I chose speed over preserving bandwidth, so I do <em>not</em> recommend this option. If your <a href="https://en.wikipedia.org/wiki/Internet_service_provider">ISP</a> has a <a href="https://en.wikipedia.org/wiki/Bandwidth_cap">bandwidth cap</a>, you should find one <a href="http://publicknowledge.org/issues/data-caps">that isn't crippled</a>.

Subsequent re-builds won't download any packages that haven't already been downloaded.

<strong><span style="text-decoration:underline;">What should I look for</span>?</strong>

Once the vagrant commands are done running, you'll want to look at something to see how your machines are doing. I like to log in and run different commands. I usually log in like this:
```
$ vcssh --screen root@annex{1..4}
```
I explain how to do this kind of magic in <a href="/blog/2014/01/02/vagrant-clustered-ssh-and-screen/">an earlier post</a>. I then run some of the following commands:
```
# tail -F /var/log/messages
```
This lets me see what the machine is doing. I can see puppet runs and other useful information fly by.
```
# ip a s eth2
```
This lets me check that the <em>VIP</em> is working correctly, and which machine it's on. This should usually be the first machine.
```
# ps auxww | grep again.[py]
```
This lets me see if puppet has scheduled another puppet run. My scripts automatically do this when they decide that there is still building (deployment) left to do. If you see a <em>python</em> <code>again.py</code> process, this means it is sleeping and will wake up to continue shortly.
```
# gluster peer status
```
This lets me see which hosts have connected, and what state they're in.
```
# gluster volume info
```
This lets me see if Puppet-Gluster has built me a volume yet. By default it builds one distributed volume named <em>puppet</em>.

<strong><span style="text-decoration:underline;">I want to configure this differently</span>!</strong>

Okay, you're more than welcome to! All of the scripts can be customized. If you want to configure the volume(s) differently, you'll want to look in the:
```
puppet-gluster/vagrant/gluster/puppet/manifests/site.pp
```
file. The <code>gluster::simple</code> class is <a href="https://github.com/purpleidea/puppet-gluster/blob/master/DOCUMENTATION.md#glustersimple">well-documented</a>, and can be configured however you like. If you want to do more serious hacking, have a look at the <a href="https://github.com/purpleidea/puppet-gluster/blob/master/vagrant/gluster/Vagrantfile">Vagrantfile</a>, the <a href="https://github.com/purpleidea/puppet-gluster/">source</a>, and the <a href="https://github.com/purpleidea/puppet-gluster/tree/master/vagrant/gluster/puppet/modules/">submodules</a>. Of course the <a href="http://git.gluster.org/?p=glusterfs.git;a=summary">GlusterFS source</a> is a great place to hack too!

The network block, domain, and other parameters are all configurable inside of the <em>Vagrantfile</em>. I've tried to use sensible defaults where possible. I'm using <code>example.com</code> as the default domain. <em>Yes</em>, this will work fine on your private network. DNS is currently configured with the <code>/etc/hosts</code> file. I wrote some magic into the <em>Vagrantfile</em> so that the slow <code>/etc/hosts</code> shell provisioning only has to happen once per machine! If you have a better, functioning, alternative, please let me know!

<strong><span style="text-decoration:underline;">What's the greatest number of machines this will scale to</span>?</strong>

Good question! I'd like to know too! I know that GlusterFS probably can't scale to <a href="http://www.gluster.org/community/documentation/index.php/Features/thousand-node-glusterd">1000 hosts</a> yet. Keepalived can't support more than 256 priorities, therefore Puppet-Gluster can't scale beyond that count until a suitable fix can be found. There are likely some earlier limits inside of Puppet-Gluster due to maximum command line length constraints that you'll hit. If you find any, let me know and I'll patch them. Patches now cost around seven karma points. Other than those limits, there's the limit of my hardware. Since this is all being virtualized on a lowly <a href="https://en.wikipedia.org/wiki/ThinkPad_X_Series#X201">X201</a>, my tests are limited. <a title="donate" href="/donate/">An upgrade would be awesome!</a>

<strong><span style="text-decoration:underline;">Can I use this to test QA releases, point releases and new GlusterFS versions</span>?</strong>

Absolutely! That's the idea. There are two caveats:
<ol>
	<li>Automatically testing QA releases isn't supported until the QA packages have a sensible home on <em>download.gluster.org</em> or similar. This will need a change to:

<a href="https://github.com/purpleidea/puppet-gluster/blob/master/manifests/repo.pp#L18">https://github.com/purpleidea/puppet-gluster/blob/master/manifests/repo.pp#L18</a>

The gluster community is working on this, and as soon as a solution is found, I'll patch Puppet-Gluster to support it. If you want to disable automatic repository management (in <code>gluster::simple</code>) and manage this yourself with the <a href="https://docs.vagrantup.com/v2/provisioning/shell.html">vagrant shell provisioner</a>, you're able to do so now.</li>
	<li>It's possible that new releases introduce bugs, or change things in a backwards incompatible way that breaks Puppet-Gluster. If this happens, please let me know so that something can get patched. That's what testing is for!</li>
</ol>
You could probably use this infrastructure to test GlusterFS builds automatically, but that's a project that would need real funding.

<strong><span style="text-decoration:underline;">Updating the puppet source</span>:</strong>

If you make a change to the puppet source, but you don't want to rebuild the puppet virtual machine, you don't have to. All you have to do is run:
```
$ vagrant provision puppet
```
This will update the puppet server with any changes made to the source tree at:
```
puppet-gluster/vagrant/gluster/puppet/
```
Keep in mind that the <em>modules</em> subdirectory contains all the necessary puppet submodules, and a clone of puppet-gluster itself. You'll first need to run <code>make</code> inside of:
```
puppet-gluster/vagrant/gluster/puppet/modules/
```
to refresh the local clone. To see what's going on, or to customize the process, you can look at the <code>Makefile</code>.

<strong><span style="text-decoration:underline;">Client machines</span>:</strong>

At the moment, this doesn't build separate machines for gluster client use. You can either mount your gluster pool from the puppet server, another gluster server, or if you add the right DNS entries to your <code>/etc/hosts</code>, you can mount the volume on your host machine. If you really want Vagrant to build client machines, you'll have to <a title="donate" href="/donate/">persuade me</a>.

<strong><span style="text-decoration:underline;">What about firewalls</span>?</strong>

Normally I use <a href="http://www.shorewall.net/">shorewall</a> to manage the firewall. It integrates well with Puppet-Gluster, and does a great job. For an unexplained reason, it seems to be blocking my VRRP (keepalived) traffic, and I had to disable it. I think this is due to a <a href="http://wiki.libvirt.org/page/VirtualNetworking">libvirt networking</a> bug, but I can't prove it yet. If you can help debug this issue, <a href="/contact/">please let me know</a>! To reproduce it, enable the <em>firewall</em> and <em>shorewall</em> directives in:
```
puppet-gluster/vagrant/gluster/puppet/manifests/site.pp
```
and then get keepalived to work.

<strong><span style="text-decoration:underline;">Re-provisioning a machine after a long wait throws an error</span>:</strong>

You might be hitting: <a href="https://github.com/fgrehm/vagrant-cachier/issues/74">vagrant-cachier #74</a>. If you do, there is an <a href="https://gist.github.com/purpleidea/8211614">available workaround</a>.

<strong><span style="text-decoration:underline;">Keepalived shows "invalid passwd!" messages in the logs</span>:</strong>

This is expected. This happens because we build a distributed password for use with keepalived. Before the cluster state has settled, the password will be different from host to host. Only when the cluster is coherent will the password be identical everywhere, which incidentally is the only time when the VIP matters.

<strong><span style="text-decoration:underline;">How did you build that awesome base image</span>?</strong>

I used <a href="http://libguestfs.org/virt-builder.1.html">virt-builder</a>, some scripts, and a clever <em>Makefile</em>. I'll be publishing this code shortly. Hasn't this been enough to keep you busy for a while?

<strong><span style="text-decoration:underline;">Are you still here</span>?</strong>

If you've read this far, then good for you! I'm sorry that it has been a long read, but I figured I would try to answer everyone's questions in advance. I'd like to hear your <a href="#comments">comments</a>! I get very little feedback, and I've never gotten a <a title="donate" href="/donate/">single tip</a>! If you find this useful, <a title="contact" href="/contact/">please let me know</a>.

Until then,

Happy hacking,

James

