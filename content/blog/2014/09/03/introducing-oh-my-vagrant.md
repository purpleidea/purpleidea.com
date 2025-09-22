+++
date = "2014-09-03 23:19:19"
title = "Introducing: Oh My Vagrant!"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "docker", "fedora", "gluster", "oh-my-vagrant", "planetdevops", "planetfedora", "planetpuppet", "puppet", "vagrant", "vagrant-libvirt"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/09/03/introducing-oh-my-vagrant/"
+++

If you're a reader of my <a href="https://github.com/purpleidea/">code</a> or of <a href="/blog/">this blog</a>, it's no secret that I hack on a lot of <a href="https://en.wikipedia.org/wiki/Puppet_%28software%29">puppet</a> and <a href="https://en.wikipedia.org/wiki/Vagrant_%28software%29">vagrant</a>. Recently I've fooled around with a bit of <a href="https://en.wikipedia.org/wiki/Docker_%28software%29">docker</a>, too. I realized that the <a href="https://github.com/purpleidea/puppet-gluster/blob/master/vagrant/Vagrantfile">vagrant</a>, <a href="https://github.com/purpleidea/puppet-ipa/blob/master/vagrant/Vagrantfile">environments</a> I built for <a href="https://github.com/purpleidea/puppet-gluster/">puppet-gluster</a> and <a href="https://github.com/purpleidea/puppet-ipa/">puppet-ipa</a> needed to be generalized, and they needed new features too. Therefore...

Introducing: <strong>Oh My Vagrant!</strong>

<em>Oh My Vagrant</em> is an attempt to provide an <em>easy</em> to use development environment so that you can be up and hacking <em>quickly</em>, and focusing on the real <em>devops</em> problems. The <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/README">README</a> explains my choice of project name.

<span style="text-decoration:underline;">Prerequisites</span>:

I use a <a href="https://fedoraproject.org/">Fedora 20</a> laptop with <a href="https://github.com/pradels/vagrant-libvirt/">vagrant-libvirt</a>. Efforts are underway to create an RPM of vagrant-libvirt, but in the meantime you'll have to read: <a href="/blog/2014/05/13/vagrant-on-fedora-with-libvirt-reprise/">Vagrant on Fedora with libvirt (reprise)</a>. This should work with other distributions too, but I don't test them very often. Please step up and help test :)

<span style="text-decoration:underline;">The bits</span>:

First clone the <a href="https://github.com/purpleidea/oh-my-vagrant">oh-my-vagrant repository</a> and look inside:
```
git clone --recursive https://github.com/purpleidea/oh-my-vagrant
cd oh-my-vagrant/vagrant/
```
The included <em>Vagrantfile</em> is the current heart of this project. You're welcome to use it as a template and edit it directly, or you can use the facilities it provides. I'd recommend starting with the latter, which I'll walk you through now.

<span style="text-decoration:underline;">Getting started</span>:

Start by running <code>vagrant status</code> (<code>vs</code>) and taking a look at the <code>vagrant.yaml</code> file that appears.
```
james@computer:/oh-my-vagrant/vagrant$ ls
Dockerfile  puppet/  Vagrantfile
james@computer:/oh-my-vagrant/vagrant$ vs
Current machine states:

template1                 not created (libvirt)

The Libvirt domain is not created. Run `vagrant up` to create it.
james@computer:/oh-my-vagrant/vagrant$ cat vagrant.yaml 
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.0
:sync: rsync
:puppet: false
:docker: false
:cachier: false
:vms: []
:namespace: template
:count: 1
:username: ''
:password: ''
:poolid: []
:repos: []
james@computer:/oh-my-vagrant/vagrant$
```
Here you'll see the list of resultant machines that vagrant thinks is defined (currently just <em>template1</em>), and a bunch of different settings in YAML format. The values of these settings help define the vagrant environment that you'll be hacking in.

<span style="text-decoration:underline;">Changing settings</span>:

The settings exist so that your vagrant environment is <em>dynamic</em> and can be changed <em>quickly</em>. You can change the settings by editing the <code>vagrant.yaml</code> file. They will be used by vagrant when it runs. You can also change them at runtime with <code>--vagrant-foo</code> flags. Running a <em>vagrant status</em> will show you how vagrant currently sees the environment. Let's change the number of machines that are defined. Note the location of the <code>--vagrant-count</code> flag and how it doesn't work when positioned incorrectly.
```
james@computer:/oh-my-vagrant/vagrant$ vagrant status --vagrant-count=4
<span style="color:#ff0000;">An invalid option was specified. The help for this command</span>
<span style="color:#ff0000;">is available below.</span>

<span style="color:#ff0000;">Usage: vagrant status [name]</span>
<span style="color:#ff0000;">    -h, --help                       Print this help</span>
james@computer:/oh-my-vagrant/vagrant$ vagrant --vagrant-count=4 status
Current machine states:

template1                 not created (libvirt)
template2                 not created (libvirt)
template3                 not created (libvirt)
template4                 not created (libvirt)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
james@computer:/oh-my-vagrant/vagrant$ cat vagrant.yaml 
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.0
:sync: rsync
:puppet: false
:docker: false
:cachier: false
:vms: []
:namespace: template
:count: 4
:username: ''
:password: ''
:poolid: []
:repos: []
james@computer:/oh-my-vagrant/vagrant$
```
As you can see in the above example, changing the <em>count</em> variable to <strong>4</strong>, causes vagrant to see a possible <em>four</em> machines in the vagrant environment. You can change as many of these parameters at a time by using the <code>--vagrant-</code> flags, or you can edit the <code>vagrant.yaml</code> file. The latter is much easier and more expressive, in particular for expressing complex data types. The former is much more powerful when building one-liners, such as:
```
vagrant --vagrant-count=8 --vagrant-namespace=gluster up gluster{1..8}
```
which should bring up eight hosts in parallel, named <em>gluster1</em> to <em>gluster8</em>.

<span style="text-decoration:underline;">Other VM's</span>:

Since one often wants to be more expressive in machine naming and heterogeneity of machine type, you can specify a list of machines to define in the <code>vagrant.yaml</code> file <code>vms</code> array. If you'd rather define these machines in the <em>Vagrantfile</em> itself, you can also set them up in the <code>vms</code> array defined there. It is empty by default, but it is easy to uncomment out one of the many examples. These will be used as the defaults if nothing else overrides the selection in the <code>vagrant.yaml</code> file. I've uncommented a few to show you this functionality:
```
james@computer:/oh-my-vagrant/vagrant$ grep example[124] Vagrantfile 
    {:name => 'example1', :docker => true, :puppet => true, },    # example1
    {:name => 'example2', :docker => ['centos', 'fedora'], },    # example2
    {:name => 'example4', :image => 'centos-6', :puppet => true, },    # example4
james@computer:/oh-my-vagrant/vagrant$ rm vagrant.yaml # note that I remove the old settings
james@computer:/oh-my-vagrant/vagrant$ vs
Current machine states:

template1                 not created (libvirt)
example1                  not created (libvirt)
example2                  not created (libvirt)
example4                  not created (libvirt)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
james@computer:/oh-my-vagrant/vagrant$ cat vagrant.yaml 
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.0
:sync: rsync
:puppet: false
:docker: false
:cachier: false
:vms:
- :name: example1
  :docker: true
  :puppet: true
- :name: example2
  :docker:
  - centos
  - fedora
- :name: example4
  :image: centos-6
  :puppet: true
:namespace: template
:count: 1
:username: ''
:password: ''
:poolid: []
:repos: []
james@computer:/oh-my-vagrant/vagrant$ vim vagrant.yaml # edit vagrant.yaml file...
james@computer:/oh-my-vagrant/vagrant$ cat vagrant.yaml 
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.0
:sync: rsync
:puppet: false
:docker: false
:cachier: false
:vms:
- :name: example1
  :docker: true
  :puppet: true
- :name: example4
  :image: centos-7.0
  :puppet: true
:namespace: template
:count: 1
:username: ''
:password: ''
:poolid: []
:repos: []
james@computer:/oh-my-vagrant/vagrant$ vs
Current machine states:

template1                 not created (libvirt)
example1                  not created (libvirt)
example4                  not created (libvirt)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
james@computer:/oh-my-vagrant/vagrant$
```
The above output might seem a little long, but if you try these steps out in your terminal, you should get a hang of it fairly quickly. If you poke around in the <em>Vagrantfile</em>, you should see the format of the <code>vms</code> array. Each element in the array should be a dictionary, where the keys correspond to the flags you wish to set. Look at the examples if you need help with the formatting.

<span style="text-decoration:underline;">Other settings</span>:

As you saw, other settings are available. There are a few notable ones that are worth mentioning. This will also help explain some of the other features that this <em>Vagrantfile</em> provides.
<ul>
	<li><em>domain</em>: This sets the domain part of each vm's <a href="https://en.wikipedia.org/wiki/Fully_qualified_domain_name">FQDN</a>. The default is <em>example.com</em>, which should work for most environments, but you're welcome to change this as you see fit.</li>
	<li><em>network</em>: This sets the network that is used for the vm's. You should pick a <em>network</em>/<a href="https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing"><em>cidr</em></a> that doesn't conflict with any other networks on your machine. This is particularly useful when you have multiple vagrant environments hosted off of the same laptop.</li>
	<li><em>image</em>: This is the default base image to use for each machine. It can be overridden per-machine in the vm's list of dictionaries.</li>
	<li><em>sync</em>: This is the sync type used for vagrant. <em>rsync</em> is the default and works in all environments. If you'd prefer to fight with the <em>nfs</em> mounts, or try out <em>9p</em>, both those options are available too.</li>
	<li><em>puppet</em>: This option enables or disables integration with puppet. It is possible to override this per machine. This functionality will be expanded in a future version of <em>Oh My Vagrant</em>.</li>
	<li><em>docker</em>: This option enables and lists the docker images to set up per vm. It is possible to override this per machine. This functionality will be expanded in a future version of <em>Oh My Vagrant</em>.</li>
	<li><em>namespace</em>: This sets the namespace that your Vagrantfile operates in. This value is used as a prefix for the numbered vm's, as the libvirt network name, and as the primary puppet module to execute.</li>
</ul>
<span style="text-decoration:underline;">More on the <em>docker</em> option</span>:

For now, if you specify a list of docker images, they will be automatically pulled into your vm environment. It is recommended that you pre-cache them in an existing base image to save bandwidth. Custom base vagrant images can be easily be built with <a href="https://github.com/purpleidea/vagrant-builder">vagrant-builder</a>, but this process is currently undocumented.

I'll try to write-up a post on this process if there are enough requests. To keep you busy in the meantime, <a href="https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/centos-7.0-docker/">I've published a CentOS 7 vagrant base image that includes docker images for CentOS and Fedora</a>. It is being graciously hosted by the <a href="https://www.gluster.org/">GlusterFS community</a>.

<span style="text-decoration:underline;">What other magic does this all do</span>?

There is a certain amount of magic glue that happens behind the scenes. Here's a list of some of it:
<ul>
	<li>Idempotent /etc/hosts based DNS</li>
	<li>Easy docker base image installation</li>
	<li>IP address calculations and assignment with <em>ipaddr</em></li>
	<li>Clever cleanup on '<em>vagrant destroy</em>'</li>
	<li>Vagrant docker base image detection</li>
	<li>Integration with Puppet</li>
</ul>
If you don't understand what all of those mean, and you don't want to go source diving, don't worry about it! I will explain them in greater detail when it's important, and hopefully for now everything "just works" and stays out of your way.

<span style="text-decoration:underline;">Future work</span>:

There's still a lot more that I have planned, and some parts of the <em>Vagrantfile</em> need clean up, but I figured I'd try and release this early so that you can get hacking right away. If it's useful to you, please leave a <a href="#comments">comment</a> and let me know.

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
