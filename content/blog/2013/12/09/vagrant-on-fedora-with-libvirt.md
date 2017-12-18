+++
date = "2013-12-09 20:14:51"
title = "Vagrant on Fedora with libvirt"
draft = "false"
categories = ["technical"]
tags = ["devops", "fedora", "gluster", "libvirt", "pkla", "planetfedora", "planetpuppet", "policykit", "polkit", "puppet", "puppet-gluster", "vagrant", "virsh", "virt-manager"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/12/09/vagrant-on-fedora-with-libvirt/"
+++

Apparently lots of people are using <a href="https://www.vagrantup.com/">Vagrant</a> these days, so I figured I'd try it out. I wanted to get it working on Fedora, and without Virtualbox. This is an intro article on Vagrant, and what I've done. I did this on Fedora 19. Feel free to suggest improvements.

<span style="text-decoration:underline;">Intro</span>:

Vagrant is a tool that easily provisions virtual machines, and then kicks off a configuration management deployment like <a href="https://en.wikipedia.org/wiki/Puppet_%28software%29">Puppet</a>. It's often used for development. I'm planning on using it to test some <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> managed GlusterFS clusters.

<span style="text-decoration:underline;">Installation</span>:

You should already have the base libvirt/QEMU packages already installed (if they're not already present) and be comfortable with basic virtual machine concepts. If not, come back when you're ready.

Fedora 20 was <a href="https://fedoraproject.org/wiki/Changes/Vagrant">supposed to include Vagrant</a>, but I don't think this happened. In the meantime, I installed the latest x86_64 RPM from the Vagrant download page.
```
$ mkdir ~/vagrant
$ wget http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_x86_64.rpm
$ sudo yum install vagrant_1.3.5_x86_64.rpm
```
<em>EDIT</em>: Please use version 1.3.5 only! The 1.4 series breaks compatibility with a lot of the necessary plugins. You might have success with different versions, but I have not tested them yet.

You'll probably need some dependencies for the next few steps. Ensure they're present:
```
$ sudo yum install libvirt-devel libxslt-devel libxml2-devel
```
The <a href="http://libvirt.org/virshcmdref.html"><em>virsh</em></a> and <a href="http://virt-manager.org/"><em>virt-manager</em></a> tools are especially helpful additions. Install those too.

<span style="text-decoration:underline;">Boxes</span>:

Vagrant has a concept of default "boxes". These are pre-built images that you download, and use as base images for the virtual machines that you'll be building. Unfortunately, they are hypervisor specific, and the most commonly available images have been built for Virtualbox. Yuck! To get around this limitation, there is an easy solution.

First we'll need to install a special <a href="https://github.com/sciurus/vagrant-mutate">Vagrant plugin</a>:
```
$ sudo yum install qemu-img # depends on this
$ vagrant plugin install vagrant-mutate
```
<em>EDIT</em>: Note that there is a <a href="https://github.com/sciurus/vagrant-mutate/issues/37">bug</a> on Fedora 20 that breaks mutate! Feel free to skip over the mutate steps below on Fedora, and use <a href="https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/centos-6/centos-6.box">this</a> image instead. You can install it with:
```
$ vagrant box add centos-6 https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/centos-6/centos-6.box --provider=libvirt
```
You'll have to replace the <em>precise32</em> name in the below <em>Vagrantfile</em> with <em>centos-6</em>.

<em>END EDIT</em>

Now download an incompatible box. We'll use the well-known example:
```
$ vagrant box add precise32 http://files.vagrantup.com/precise32.box
```
Finally, convert the box so that it's libvirt compatible:
```
$ vagrant mutate precise32 libvirt
```
This plugin can also convert to KVM friendly boxes.

You'll need to make a working directory for Vagrant and initialize it:
```
$ mkdir test1
$ cd test1
$ vagrant init precise32
```
<span style="text-decoration:underline;">Hypervisor</span>:

I initially tried getting this working with the <a href="https://github.com/adrahon/vagrant-kvm">vagrant-kvm</a> plugin that Fedora 20 will eventually include, but I did not succeed. Instead, I used the <a href="https://github.com/pradels/vagrant-libvirt">vagrant-libvirt</a> plugin:
```
$ vagrant plugin install vagrant-libvirt
```
<em>EDIT</em>: I forgot to mention that you'll need to specify the <code>--provider</code> argument when running vagrant commands. I wrote about how to do this in my <a href="/blog/2013/12/21/vagrant-vsftp-and-other-tricks/">second article</a>. You can use <code>--provider=libvirt</code> for each command or include the:
```
export VAGRANT_DEFAULT_PROVIDER=libvirt
```
line in your ~/.bashrc file.

<em>END EDIT</em>

I have found a number of issues with it, but I'll show you which magic knobs I've used so that you can replicate my setup. Let me show you my <em>Vagrantfile</em>:

{{< highlight ruby >}}

# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# NOTE: vagrant-libvirt needs to run in series (not in parallel) to avoid
# trying to create the network twice... eg: vagrant up --no-parallel
# alternatively, you can just create the vm's one at a time manually...

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	# Every Vagrant virtual environment requires a box to build from
	config.vm.box = "precise32"			# choose your own!

	# List each virtual machine
	config.vm.define :vm1 do |vm1|
		vm1.vm.network :private_network,
			:ip => "192.168.142.101",	# choose your own!
			:libvirt__network_name => "default"	# leave it
	end

	config.vm.define :vm2 do |vm2|
		vm2.vm.network :private_network,
			:ip => "192.168.142.102",	# choose your own!
			:libvirt__network_name => "default"	# leave it
	end

	# Provider-specific configuration
	config.vm.provider :libvirt do |libvirt|
		libvirt.driver = "qemu"
		# leave out host to connect directly with qemu:///system
		#libvirt.host = "localhost"
		libvirt.connect_via_ssh = false		# also needed
		libvirt.username = "root"
		libvirt.storage_pool_name = "default"
	end

	# Enable provisioning with Puppet. You might want to use the agent!
	config.vm.provision :puppet do |puppet|
		puppet.module_path = "modules"
		puppet.manifests_path = "manifests"
		puppet.manifest_file = "site.pp"
		# custom fact
		puppet.facter = {
			"vagrant" => "1",
		}
	end
end
{{< /highlight >}}
A few caveats:
<ul>
	<li>The <code>:libvirt__network_name => "default"</code> needs to always be specified. If you don't specify it, or if you specify a different name, you'll get an error:
```
Call to virDomainCreateWithFlags failed: Network not found: no network with matching name 'default'
```
</li>
	<li>With this <em>Vagrantfile</em>, you'll get an IP address from DHCP, and a static IP address from the <em>:ip</em> definition. If you attempt to disable DHCP with <code>:libvirt__dhcp_enabled => false</code> you'll see errors:
```
grep: /var/lib/libvirt/dnsmasq/*.leases: No such file or directory
```
As a result, each machine will have two IP addresses.</li>
	<li>Running <em>vagrant up</em> caused some errors when more than one machine is defined. This was caused by duplicate attempts to create the same network. To work around this, you can either start each virtual machine manually, or use the --no-parallel option when the network is first created:
```
$ vagrant up --no-parallel
<em>[...]</em>
<<a href="https://www.youtube.com/watch?v=MnA4u9CaK7A&html5=1">magic awesome happens here</a>>
```
</li>
</ul>
<span style="text-decoration:underline;">Commands</span>:

The most common commands you'll need are:
<ul>
	<li><code>vagrant init</code> – initialize a directory</li>
	<li><code>vagrant up [machine]</code> – start/build/deploy a machine</li>
	<li><code>vagrant ssh <machine></code> – connect to a machine</li>
	<li><code>vagrant halt [machine]</code> – stop the machine</li>
	<li><code>vagrant destroy [machine]</code> – remove/erase/purge the entire machine</li>
</ul>
I won't go into further details here, because this information is <a href="http://docs.vagrantup.com/v2/">well documented</a>.

<span style="text-decoration:underline;">PolicyKit (polkit)</span>:

At this point you're probably getting annoyed by having to repeatedly type your password to interact with your VM through libvirt. You're probably seeing a dialog like this:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="screenshot-authenticate.png"><img class="alignnone size-full wp-image-635" alt="Screenshot-Authenticate" src="screenshot-authenticate.png" width="100%" height="100%" /></a></td></tr></table></br />

This should look familiar if you've used <em>virt-manager</em> before. When you open <em>virt-manager</em>, and it tries to connect to <code>qemu:///system</code>, PolicyKit does the <em>right thing</em> and ensures that you're allowed to get access to the resource first! The annoying part is that you get repeatedly prompted when you're using <em>Vagrant</em>, because it is constantly opening up and closing new connections. If you're comfortable allowing this permanently, you can add a policy file:
```
[Allow james libvirt management permissions]
Identity=unix-user:james
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes
```
Create this file (you'll need root) as:
```
/etc/polkit-1/localauthority/50-local.d/vagrant.pkla
```
and then shouldn't experience any more prompts when you try to manage libvirt! You'll obviously want to replace the <em><strong>james</strong></em> string with whatever user account you're using. For more information on the format of this file, and to learn other ways to do this read the <a href="http://www.freedesktop.org/software/polkit/docs/0.105/pklocalauthority.8.html">pkla documentation</a>.

If you want to avoid PolicyKit, you can connect to <em>libvirtd</em> over SSH, however I don't have <em>sshd</em> running on my laptop, and I wanted to connect directly. The default vagrant-libvirt example demonstrates this method.

<span style="text-decoration:underline;">Puppet</span>:

Provisioning machines without configuration management wouldn't be very useful. Thankfully, <em>Vagrant</em> integrates nicely with Puppet. The documentation on this is fairly straightforward, so I won't cover this part. I show a simple Puppet deployment in my <em>Vagrantfile</em> above, but a more complex setup involving <code>puppet agent</code> and <em>puppetmasterd</em> is possible too.

<span style="text-decoration:underline;">Conclusion</span>:

Hopefully this makes it easier for you to hack in GNU/Linux land. I look forward to seeing this supported natively in Fedora, but until then, hopefully I've helped out with the heavy lifting.

Happy hacking!

James

