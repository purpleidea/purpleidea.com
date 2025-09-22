+++
date = "2015-02-23 22:48:39"
title = "Building RHEL Vagrant Boxes with Vagrant-Builder"
draft = "false"
categories = ["technical"]
tags = ["acl", "btrfs", "centos", "devops", "fedora", "gluster", "oh-my-vagrant", "planetdevops", "planetfedora", "planetpuppet", "puppet", "qemu", "red hat enterprise linux", "rhel", "setfacl", "subscription-manager", "vagrant", "vagrant boxes", "vagrant-builder", "virt-builder"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/02/23/building-rhel-vagrant-boxes-with-vagrant-builder/"
+++

<a href="https://en.wikipedia.org/wiki/Vagrant_%28software%29">Vagrant</a> is a great tool for development, but <a href="https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux">Red Hat Enterprise Linux</a> (RHEL) customers have typically been left out, because it has been impossible to get RHEL boxes! It would be extremely elegant if hackers could quickly test and prototype their code on the same OS as they're running in production.

Secondly, when hacking on projects that have a long initial setup phase (eg: a long rpm install) it would be excellent if hackers could roll their own modified base boxes, so that certain common operations could be re-factored out into the base image.

This all changes today.

<em>Please continue reading if you'd like to know how :)</em>

<span style="text-decoration:underline;">Subscriptions</span>:

In order to use RHEL, you first need a <a href="http://red.ht/1Aowjfh">subscription</a>. If you don't already have one, go sign up... I'll wait. You do have to pay money, but in return, you're funding my salary (and many others) so that we can build you lots of <a href="https://github.com/purpleidea/">great hacks</a>.

<span style="text-decoration:underline;">Prerequisites</span>:

I'll be working through this whole process on a <a href="https://getfedora.org/">Fedora 21</a> laptop. It should probably work on different OS versions and flavours, but I haven't tested it. Please test, and let me know your results! You'll also need <code>virt-install</code> and <code>virt-builder</code> installed:
```
$ sudo yum install -y /usr/bin/virt-{install,builder}
```
<span style="text-decoration:underline;">Step one</span>:

Login to <a href="https://access.redhat.com/">https://access.redhat.com/</a> and check that you have a <a href="https://access.redhat.com/management/subscriptions">valid subscription available</a>. This should look like this:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="subscriptions.png"><img class="size-medium wp-image-1028" src="subscriptions.png" alt="A view of my available subscriptions." width="100%" height="100%" /></a></td></tr><tr><td> A view of my available subscriptions.</td></tr></table></br />

If everything looks good, you'll need to download an ISO image of RHEL. First head to the <a href="https://access.redhat.com/downloads/">downloads</a> section and find the RHEL product:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="downloads.png"><img class="size-medium wp-image-1029" src="downloads.png" alt="A view of my available product downloads." width="100%" height="100%" /></a></td></tr><tr><td> A view of my available product downloads.</td></tr></table></br />

In the RHEL download section, you'll find a number of variants. You want the RHEL 7.0 Binary DVD:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="downloads2.png"><img class="size-medium wp-image-1030" src="downloads2.png" alt="A view of the available RHEL downloads." width="100%" height="100%" /></a></td></tr><tr><td> A view of the available RHEL downloads.</td></tr></table></br />

After it has finished downloading, verify the SHA-256 hash is correct, and continue to step two!
```
$ sha256sum rhel-server-7.0-x86_64-dvd.iso
85a9fedc2bf0fc825cc7817056aa00b3ea87d7e111e0cf8de77d3ba643f8646c  rhel-server-7.0-x86_64-dvd.iso
```
<span style="text-decoration:underline;">Step two</span>:

Grab a copy of <a href="https://github.com/purpleidea/vagrant-builder">vagrant-builder</a>:
```
$ git clone https://github.com/purpleidea/vagrant-builder
Cloning into 'vagrant-builder'...
[...]
Checking connectivity... done.
```
I'm pleased to announce that it now has some <a href="https://github.com/purpleidea/vagrant-builder/blob/master/DOCUMENTATION.md">documentation</a>! (Patches are welcome to improve it!)

Since we're going to use it to build RHEL images, you'll need to put your subscription manager credentials in <code>~/.vagrant-builder/auth.sh</code>:
```
$ cat ~/.vagrant-builder/auth.sh
# these values are used by vagrant-builder
USERNAME='purpleidea@redhat.com' # replace with your access.redhat.com username
PASSWORD='<a href="http://bash.org/?244321">hunter2</a>'               # replace with your access.redhat.com password
```
This is a simple shell script that gets sourced, so you could instead replace the static values with a script that calls out to the GNOME Keyring. This is left as an exercise to the reader.

To build the image, we'll be working in the <code>v7/</code> directory. This directory supports common OS families and versions that have high commonality, and this includes Fedora 20, Fedora 21, CentOS 7.0, and RHEL 7.0.

Put the downloaded RHEL ISO in the <code>iso/</code> directory. To allow qemu to see this file, you'll need to add some acl's:
```
$ sudo -s # do this as root
$ cd /home/
$ getfacl james # james is my home directory
# file: james
# owner: james
# group: james
user::rwx
group::---
other::---
$ setfacl -m u:qemu:r-x james # this is the important line
$ getfacl james
# file: james
# owner: james
# group: james
user::rwx
user:qemu:r-x
group::---
mask::r-x
other::---
```
If you have an unusually small <code>/tmp</code> directory, it might also be an issue. You'll need at least 6GiB free, but a bit extra is a good idea. Check your free space first:
```
$ df -h /tmp
Filesystem Size Used Avail Use% Mounted on
tmpfs 1.9G 1.3M 1.9G 1% /tmp
```
Let's increase this a bit:
```
$ sudo mount -o remount,size=8G /tmp
$ df -h /tmp
Filesystem Size Used Avail Use% Mounted on
tmpfs 8.0G 1.3M 8.0G 1% /tmp
```
You're now ready to build an image...

<span style="text-decoration:underline;">Step three</span>:

In the <code>versions/</code> directory, you'll see that I have provided a <a href="https://github.com/purpleidea/vagrant-builder/blob/master/v7/versions/rhel-7.0-iso.sh"><code>rhel-7.0-iso.sh</code></a> script. You'll need to run it from its parent directory. This will take a while, and will cause two sudo prompts, which are required for <code>virt-install</code>. One downside to this process is that your https://access.redhat.com/ password will be briefly shown in the <code>virt-builder</code> output. Patches to fix this are welcome!
```
$ pwd
/home/james/code/vagrant-builder/v7
$ time ./versions/rhel-7.0-iso.sh
[...]
real    38m49.777s
user    13m20.910s
sys     1m13.832s
$ echo $?
0
```
With any luck, this should eventually complete successfully. This uses your cpu's virtualization instructions, so if they're not enabled, this will be a lot slower. It also uses the network, which in <a href="https://en.wikipedia.org/wiki/Net_neutrality">North America</a>, means you're in for a wait. Lastly, the <code>xz</code> compression utility will use a bunch of cpu building the <code>virt-builder</code> base image. On my laptop, this whole process took about 30 minutes. The above run was done without an SSD and took a bit longer.

The good news is that most of hard work is now done and won't need to be repeated! If you want to see the fruits of your CPU labour, have a look in: <code>~/tmp/builder/rhel-7.0-iso/</code>.
```
$ ls -lAhGs
total 4.1G
1.7G -rw-r--r--. 1 james 1.7G Feb 23 18:48 box.img
1.7G -rw-r--r--. 1 james  41G Feb 23 18:48 builder.img
 12K -rw-rw-r--. 1 james  10K Feb 23 18:11 docker.tar
4.0K -rw-rw-r--. 1 james  388 Feb 23 18:39 index
4.0K -rw-rw-r--. 1 james   64 Feb 23 18:11 metadata.json
652M -rw-rw-r--. 1 james 652M Feb 23 18:50 rhel-7.0-iso.box
200M -rw-r--r--. 1 james 200M Feb 23 18:28 rhel-7.0.xz
```
As you can see, we've produced a bunch of files. The <code>rhel-7.0-iso.box</code> is your RHEL 7.0 vagrant base box! <em>Congratulations!</em>

<span style="text-decoration:underline;">Step four</span>:

If you haven't ever installed vagrant, you'll pleased to know that as of last week, vagrant and vagrant-libvirt RPM's have hit Fedora 21! I started trying to <a href="/blog/2014/04/02/working-at-redhat/">convince the RPM wizards about a year ago</a>, and we finally have something that is quite usable! Hopefully we'll iterate on any packaging bugs, and keep this great work going! There are now only three things you need to do to get a working vagrant-libvirt setup on Fedora 21:
<ol>
	<li><code>$ yum install -y vagrant-libvirt</code></li>
	<li>Source this <code>.bashrc</code> add-on from: <a href="https://gist.github.com/purpleidea/8071962">https://gist.github.com/purpleidea/8071962</a></li>
	<li>Add a <a href="/blog/2014/05/13/vagrant-on-fedora-with-libvirt-reprise/">vagrant.pkla file as mentioned here</a></li>
</ol>
Now that we're now in well-known vagrant territory. Adding the box into vagrant is a simple:
```
$ vagrant box add rhel-7.0-iso.box --name rhel-7.0
```
<span style="text-decoration:underline;">Using the box effectively</span>:

Having a base box is great, but having to manage subscription-manager manually isn't fun in a DevOps environment. Enter <a href="/blog/2014/09/03/introducing-oh-my-vagrant/">Oh-My-Vagrant (omv)</a>. You can use omv to automatically register and unregister boxes! Edit the <code>omv.yaml</code> file so that the <em>image</em> variable refers to the base box you just built, enter your https://access.redhat.com/ username and password, and <code>vagrant up</code> away!
```
$ cat omv.yaml 
---
:domain: example.com
:network: 192.168.123.0/24
:image: rhel-7.0
:boxurlprefix: ''
:sync: rsync
:folder: ''
:extern: []
:puppet: false
:classes: []
:docker: false
:cachier: false
:vms: []
:namespace: omv
:count: 2
:username: 'purpleidea@redhat.com'
:password: 'hunter2'
:poolid: true
:repos: []
$ vs
Current machine states:

omv1                      not created (libvirt)
omv2                      not created (libvirt)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
You might want to set <code>repos</code> to be:
```
['rhel-7-server-rpms', 'rhel-7-server-extras-rpms']
```
but it depends on what subscriptions you want or have available. If you'd like to store your credentials in an external file, you can do so like this:
```
$ cat ~/.config/oh-my-vagrant/auth.yaml
---
:username: purpleidea@redhat.com
:password: hunter2
```
Here's an actual run to see the subscription-manager action:
```
$ vup omv1
[...]
==> omv1: The system has been registered with ID: 00112233-4455-6677-8899-aabbccddeeff
==> omv1: Installed Product Current Status:
==> omv1: Product Name: Red Hat Enterprise Linux Server
==> omv1: Status:       Subscribed
$ # the above lines shows that your machine has been registered
$ vscreen root@omv1
[root@omv1 ~]# echo thanks purpleidea!
thanks purpleidea!
[root@omv1 ~]# exit
```
Make sure to unregister when you are permanently done with a machine, otherwise your subscriptions will be left idle. This happens automatically on vagrant destroy when using Oh-My-Vagrant:
```
$ vdestroy omv1 # make sure to unregister when you are done
Unlocking shell provisioning for: omv1...
Running 'subscription-manager unregister' on: omv1...
Connection to 192.168.121.26 closed.
System has been unregistered.
==> omv1: Removing domain...
```
<span style="text-decoration:underline;">Idempotence</span>:

One interesting aspect of this build process, is that it's mostly <a href="https://en.wikipedia.org/wiki/Idempotence">idempotent</a>. It's able to do this, because it uses GNU Make to ensure that only out of date steps or missing targets are run. As a result, if the build process fails part way through, you'll only have to repeat the failed steps! This speeds up debugging and iterative development enormously!

To prove this to you, here is what a second run looks like (after the first successful run):
```
$ time ./versions/rhel-7.0-iso.sh 

real    0m0.029s
user    0m0.013s
sys    0m0.017s
```
As you can see it completes almost instantly.

<span style="text-decoration:underline;">Variants</span>:

To build a variant of the base image that we just built, create a <code>versions/*.sh</code> file, and modify the variables to add your changes in. If you start with a copy of the <code>~/tmp/builder/${VERSION}-${POSTFIX}</code> folder, then you shouldn't need to repeat the initial steps. Hint: <a href="https://en.wikipedia.org/wiki/Btrfs">btrfs</a> is excellent at <a href="https://lwn.net/Articles/331808/">reflinking</a> data, so you don't unnecessarily store multiple copies!

<span style="text-decoration:underline;">Plumbing Pipeline</span>:

What actually happens behind the scenes? Most of the magic happens in the <a href="https://github.com/purpleidea/vagrant-builder/blob/master/v7/Makefile#L21">Makefile</a>. The relevant series of transforms is as follows:
<ol>
	<li>virt-install: install from iso</li>
	<li>virt-sysprep: remove unneeded junk</li>
	<li>virt-sparsify: make sparse</li>
	<li>xz --best: compress into builder format</li>
	<li>virt-builder: use builder to bake vagrant box</li>
	<li>qemu-img convert: convert to correct format</li>
	<li>tar -cvz: tar up into vagrant box format</li>
</ol>
There are some intermediate dependency steps that I didn't mention, so feel free to explore the <a href="https://github.com/purpleidea/vagrant-builder/">source</a>.

<span style="text-decoration:underline;">Future work</span>:
<ul>
	<li>Some of the above steps in the pipeline are actually bundled under the same target. It's not a huge issue, but it could be changed if someone feels strongly about it.</li>
	<li>Virt-builder can't run docker commands during build. This would be very useful for pre-populating images with docker containers.</li>
	<li>Oh-My-Vagrant, needs to have its DNS management switched to use vagrant-hostmanager instead of puppet resource commands.</li>
</ul>
<span style="text-decoration:underline;">Disclaimers</span>:

While I expect you'll love using these RHEL base boxes with Vagrant, the above builder methodology is currently <em>not</em> officially supported, and I can't guarantee that the RHEL vagrant dev environments will be either. I'm putting this out there for the early (DevOps) adopters who want to hack on this and who didn't want to invent their own build tool chain. If you do have issues, please leave a <a href="#comments">comment</a> here, or submit a <a href="https://github.com/purpleidea/vagrant-builder/issues">vagrant-builder issue</a>.

<span style="text-decoration:underline;">Thanks</span>:

Special thanks to <a href="https://rwmj.wordpress.com/">Richard WM Jones</a> and <a href="https://github.com/ptoscano">Pino Toscano</a> for their great work on virt-builder that <a href="https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants">this is based on</a>. Additional thanks to <a href="https://github.com/rbarlow">Randy Barlow</a> for encouraging me to work on this. Thanks to Red Hat for continuing to pay my salary :)

<span style="text-decoration:underline;">Subscriptions</span>?

If I've convinced you that you want some RHEL subscriptions, <a href="http://red.ht/1Aowjfh">please go have a look</a>, and please let Red Hat know that you appreciated this post and my work.

Happy Hacking!

James

<strong>UPDATE:</strong> I've tested that this process also works with the new <em>RHEL 7.1</em> release!
<strong>UPDATE:</strong> I've <a href="https://github.com/purpleidea/vagrant-builder/commit/e99f888a5cde5ad152c8e27b37c8202763bc9357">tested</a> that this process also works with the new <em>RHEL 7.2</em> release!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
