+++
date = "2014-01-20 11:46:31"
title = "Building base images for Vagrant with a Makefile"
draft = "false"
categories = ["technical"]
tags = ["dangerous", "devops", "gluster", "makefile", "planetfedora", "selinux", "vagrant", "bash", "fedora", "planetpuppet", "puppet-gluster", "vagrant-libvirt", "centos", "planetdevops", "virt-builder", "boxes", "make", "puppet", "box"]
author = "jamesjustjames"
+++

I needed a base image "<a href="https://docs.vagrantup.com/v2/boxes.html">box</a>" for my <a title="Automatically deploying GlusterFS with Puppet-Gluster + Vagrant!" href="http://ttboj.wordpress.com/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/">Puppet-Gluster+Vagrant</a> work. It would have been great if good boxes already existed, and even better if it were easy to build my own. As it turns out, I wasn't able to satisfy either of these conditions, so I've had to build one myself! <a href="https://github.com/purpleidea/puppet-gluster/blob/master/builder/README">I've published all of my code</a>, so that you can use these techniques and <a href="https://github.com/purpleidea/puppet-gluster/blob/master/builder/Makefile">tools</a> too!

<strong><span style="text-decoration:underline;">Status quo</span>:</strong>

Having an <a href="https://en.wikipedia.org/wiki/Not_Invented_Here">NIH problem</a> is bad for <a href="https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants">your vision</a>, and it's best to benefit from existing tools before creating your own. I first tried using <em><a href="https://github.com/fgrehm/vagrant-cachier">vagrant-cachier</a></em>, and then <em><a href="https://github.com/jedi4ever/veewee">veewee</a></em>, and <em><a href="https://github.com/mitchellh/packer">packer</a></em>. <em>Vagrant-cachier</em> is a great tool, but it turned out not being very useful because there weren't any base images available for download that met my needs. <em>Veewee</em> and <em>packer</em> can build those images, but they both failed in doing so for different reasons. Hopefully this situation will improve in the future.

<strong><span style="text-decoration:underline;">Writing a script</span>:</strong>

I started by hacking together a short <a href="https://www.gnu.org/software/bash/manual/bash.html">shell script</a> of commands for building base images. There wasn't much programming involved as the process was fairly linear, but it was useful to figure out what needed getting done.

I decided to use the excellent <a href="http://libguestfs.org/virt-builder.1.html"><code>virt-builder</code></a> command to put together the base image. This is exactly what it's good at doing! To install it on Fedora 20, you can run:
```
$ sudo yum install libguestfs-tools
```
It wasn't available in Fedora 19, but after a lot of pain, I managed to build (mostly correct?) packages. I have <a href="https://download.gluster.org/pub/gluster/purpleidea/virt-builder/f19/rpm/">posted them online</a> if you are <a href="https://download.gluster.org/pub/gluster/purpleidea/virt-builder/f19/rpm/README">brave (or crazy?)</a> enough to want them.

<strong><span style="text-decoration:underline;">Using the right tool</span>:</strong>

After building a few images, I realized that a shell script was the wrong tool, and that it was time for an upgrade. What was the right tool? <a href="https://www.gnu.org/software/make/manual/make.html"><em>GNU Make</em></a>! After working on this for more hours than I'm ready to admit, I present to you, a lovingly crafted virtual machine base image ("box") builder:
<blockquote><a href="https://github.com/purpleidea/puppet-gluster/blob/master/builder/Makefile">Makefile</a></blockquote>
The <code>Makefile</code> itself is quite compact. It uses a few shell scripts to do some of the customization, and builds a clean image in about <em>ten</em> minutes. To use it, just run <code>make</code>.

<strong><span style="text-decoration:underline;">Customization</span>:</strong>

At the moment, it builds <em>x86_64</em>, <a href="https://en.wikipedia.org/wiki/CentOS">CentOS</a> 6.5+ machines for <a href="https://github.com/pradels/vagrant-libvirt/">vagrant-libvirt</a>, but you can edit the <code>Makefile</code> to build a custom image of your choosing. I've gone out of my way to add an <code>$(OUTPUT)</code> variable to the <code>Makefile</code> so that your generated files get saved in <code>/tmp/</code> or somewhere outside of your source tree.

<strong><span style="text-decoration:underline;">Download the image</span>:</strong>

If you'd like to download the image that I generated, it is being generously hosted by the <a href="https://www.gluster.org/">Gluster</a> community <a href="https://download.gluster.org/pub/gluster/purpleidea/vagrant/">here</a>. If you're using the <a href="https://github.com/purpleidea/puppet-gluster/blob/master/vagrant/gluster/Vagrantfile">Vagrantfile</a> from my <a title="Automatically deploying GlusterFS with Puppet-Gluster + Vagrant!" href="http://ttboj.wordpress.com/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/">Puppet-Gluster+Vagrant</a> setup, then you don't have to download it manually, this will happen automatically.

<strong><span style="text-decoration:underline;">Open issues</span>:</strong>

The biggest issue with the images is that <em>SELinux</em> gets disabled! You might be okay with this, but it's actually quite unfortunate. It is disabled to avoid the <a href="https://github.com/purpleidea/puppet-gluster/blob/master/builder/Makefile#L57"><em>SELinux</em> relabelling</a> that happens on first boot, as this overhead defeats the usefulness of a fast vagrant deployment. If you know of a way to fix this problem, please let me know!

<strong><span style="text-decoration:underline;">Example output</span>:</strong>

If you'd like to see this in action, but don't want to run it yourself, here's an example run:

[code gutter="false"]
$ date && time make && date
Mon Jan 20 10:57:35 EST 2014
Running templater...
Running virt-builder...
[   1.0] Downloading: http://libguestfs.org/download/builder/centos-6.xz
[   4.0] Planning how to build this image
[   4.0] Uncompressing
[  19.0] Resizing (using virt-resize) to expand the disk to 40.0G
[ 173.0] Opening the new disk
[ 181.0] Setting a random seed
[ 181.0] Setting root password
[ 181.0] Installing packages: screen vim-enhanced git wget file man tree nmap tcpdump htop lsof telnet mlocate bind-utils koan iftop yum-utils nc rsync nfs-utils sudo openssh-server openssh-clients
[ 212.0] Uploading: files/epel-release-6-8.noarch.rpm to /root/epel-release-6-8.noarch.rpm
[ 212.0] Uploading: files/puppetlabs-release-el-6.noarch.rpm to /root/puppetlabs-release-el-6.noarch.rpm
[ 212.0] Uploading: files/selinux to /etc/selinux/config
[ 212.0] Deleting: /.autorelabel
[ 212.0] Running: yum install -y /root/epel-release-6-8.noarch.rpm && rm -f /root/epel-release-6-8.noarch.rpm
[ 214.0] Running: yum install -y bash-completion moreutils
[ 235.0] Running: yum install -y /root/puppetlabs-release-el-6.noarch.rpm && rm -f /root/puppetlabs-release-el-6.noarch.rpm
[ 239.0] Running: yum install -y puppet
[ 254.0] Running: yum update -y
[ 375.0] Running: files/user.sh
[ 376.0] Running: files/ssh.sh
[ 376.0] Running: files/network.sh
[ 376.0] Running: files/cleanup.sh
[ 377.0] Finishing off
Output: /home/james/tmp/builder/gluster/builder.img
Output size: 40.0G
Output format: qcow2
Total usable space: 38.2G
Free space: 37.3G (97%)
Running convert...
Running tar...
./Vagrantfile
./metadata.json
./box.img

real	9m10.523s
user	2m23.282s
sys	0m37.109s
Mon Jan 20 11:06:46 EST 2014
$
```
If you have any other questions, <a title="contact" href="http://ttboj.wordpress.com/contact/">please let me know</a>!

Happy hacking,

James

PS: Be careful when writing <code>Makefile</code>'s. They can be dangerous if used improperly, and in fact I once took out part of my <code>lib/</code> directory by running one. Woops!

<strong>UPDATE:</strong> This technique now exists in it's own repo here: <a href="https://github.com/purpleidea/vagrant-builder">https://github.com/purpleidea/vagrant-builder</a>

