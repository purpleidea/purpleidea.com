+++
date = "2013-12-21 11:58:49"
title = "Vagrant vsftp and other tricks"
draft = "false"
categories = ["technical"]
tags = ["NFS", "apt", "bash", "cache", "caching", "devops", "fedora", "gluster", "libvirt", "planetdevops", "planetfedora", "planetpuppet", "pulp", "pulpproject", "puppet", "rsync", "sftp", "vagrant", "vagrant-cachier", "vagrant-libvirt", "vsftp", "yum"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/12/21/vagrant-vsftp-and-other-tricks/"
+++

<a title="Vagrant on Fedora with libvirt" href="/blog/2013/12/09/vagrant-on-fedora-with-libvirt/">As I previously wrote, I've been busy with Vagrant on Fedora with libvirt</a>, and have even been <a href="https://github.com/mitchellh/vagrant/pull/2677">submitting</a>, <a href="https://github.com/fgrehm/vagrant-cachier/pull/68">patches</a> and <a href="https://github.com/mitchellh/vagrant/issues/2680">issues</a>! (<a href="https://github.com/pradels/vagrant-libvirt/issues/107">This "<em>closed</em>" issue needs solving!</a>) Here are some of the tricks that I've used while hacking away.

<strong><span style="text-decoration:underline;">Default provider</span>:</strong>

I should have mentioned this in my earlier article but I forgot: If you're always using the same provider, you might want to set it as the default. In my case I'm using <a href="https://github.com/purpleidea/vagrant-libvirt">vagrant-libvirt</a>. To do so, add the following to your <code>.bashrc</code>:
```
export VAGRANT_DEFAULT_PROVIDER=libvirt
```
This helps you avoid having to add <code>--provider=libvirt</code> to all of your vagrant commands.

<strong><span style="text-decoration:underline;">Aliases</span>:</strong>

All good hackers use shell (in my case bash) aliases to make their lives easier. I normally keep all my aliases in <code>.bash_aliases</code>, but I've grouped them together with some other vagrant related items in my <code>.bashrc</code>:

{{< highlight bash >}}
alias vp='vagrant provision'
alias vup='vagrant up'
alias vssh='vagrant ssh'
alias vdestroy='vagrant destroy'
{{< /highlight >}}
<strong><span style="text-decoration:underline;">Bash functions</span>:</strong>

There are some things aliases just can't do. For those situations, a bash function might be most appropriate. These go inside your <code>.bashrc</code> file. I'd like to share two with you:

<strong><span style="text-decoration:underline;">Vagrant logging</span>:</strong>

Sometimes it's useful to get more information from the vagrant command that is running. To do this, you can set the <code>VAGRANT_LOG</code> environment variable to <code>info</code>, or <code>debug</code>.

{{< highlight bash >}}
function vlog {
	VAGRANT_LOG=info vagrant "$@" 2> vagrant.log
}
{{< /highlight >}}
This is usually helpful for debugging a vagrant issue. When you use the <code>vlog</code> command, it works exactly as the normal <code>vagrant</code> command, but it spits out a <code>vagrant.log</code> logfile into the working directory.

<strong><span style="text-decoration:underline;">Vagrant sftp</span>:</strong>

Vagrant provides an <code>ssh</code> command, but it doesn't offer an <code>sftp</code> command. The <code>sftp</code> tool is fantastically useful when you want to quickly push or pull a file over ssh. First I'll show you the code so that you can practice reading bash:

{{< highlight bash >}}
# vagrant sftp
function vsftp {
	[ "$1" = '' ] || [ "$2" != '' ] && echo "Usage: vsftp  - vagrant sftp" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	f="$d/$1.config"

	# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
	if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
		mkdir -p "$d"
		# we cache the lookup because this command is slow...
		vagrant ssh-config "$1" > "$f" || rm "$f"
	fi
	[ -e "$f" ] && sftp -F "$f" "$1"
}
{{< /highlight >}}
This <code>vsftp</code> command will work from anywhere in the vagrant project root directory or deeper. It does this by first searching upwards until it gets to that directory. When it finds it, it creates a <code>.ssh/</code> directory there, and stores the proper <code>ssh_config</code> stubs needed for <code>sftp</code> to find the machines. Then the <code>sftp -F</code> command runs, connecting you to your guest machine.

You'll notice that the first time you connect takes longer than the second time. This is because the <code>vsftp</code> function caches the <code>ssh_config</code> file store operation. You might want to set a different timeout, or disable it altogether. I should also mention that this script searches for a <code>Vagrantfile</code> and <code>.vagrant/</code> directory to identify the project root. If there is a more "correct" method, please let me know.

I'm particularly proud of this because it was a fun (and useful) hack. This function, and all the above <code>.bashrc</code> material is <a href="https://gist.github.com/purpleidea/8071962">available here as an easy download</a>.

<strong><span style="text-decoration:underline;">NFS folder syncing/mounting</span>:</strong>

The vagrant-libvirt provider supports one way folder "synchronization" with <code>rsync</code>, and NFS mounting if you want two-way synchronization. I would love if libvirt/vagrant-libvirt had support for real folder sharing via <a href="http://wiki.libvirt.org/page/Qemu_guest_agent">QEMU guest agent</a> and/or <a href="http://wiki.qemu.org/Documentation/9psetup">9p</a>. Getting it to work wasn't trivial. Here's what I had to do:

<strong><span style="text-decoration:underline;">Vagrantfile</span>:</strong>

Define your "synced_folder" so that you add the <code>:mount_options</code> array:

{{< highlight ruby >}}
config.vm.synced_folder "nfs/", "/tmp/nfs", :nfs => true, :mount_options => ['rw', 'vers=3', 'tcp']
{{< /highlight >}}
When you specify anything in the <code>:mount_options</code> array, it erases all the defaults. The defaults are: <code>vers=3,udp,rw</code>. Obviously, choose your own directory paths! I'd rather see this use <em>NFSv4</em>, but it would have taken slightly more fighting. <a href="https://github.com/mitchellh/vagrant/issues/2699">Please become a warrior today!</a>

<strong><span style="text-decoration:underline;">Firewall</span>:</strong>

Firewalling is not automatic. To work around this, you'll need to run the following commands before you use your NFS mount:
```
# systemctl restart nfs-server # this as root, the rest will prompt
$ firewall-cmd --permanent --zone public --add-service mountd
$ firewall-cmd --permanent --zone public --add-service rpc-bind
$ firewall-cmd --permanent --zone public --add-service nfs
$ firewall-cmd --reload
```
You should only have to do this once, but possibly each reboot. If you like, you can patch those commands to run at the top of your <code>Vagrantfile</code>. <a href="https://github.com/mitchellh/vagrant/issues/2447">If you can help fix this issue permanently, the bug is here.</a>

<strong><span style="text-decoration:underline;">Sudo</span>:</strong>

The use of <code>sudo</code> to automatically edit <code>/etc/exports</code> is a neat trick, but it can cause some problems:
<ol>
	<li><a href="https://github.com/mitchellh/vagrant/issues/2643">It is often not needed</a></li>
	<li><a href="https://github.com/mitchellh/vagrant/issues/2642">It annoyingly prompts you</a></li>
	<li><a href="https://github.com/mitchellh/vagrant/issues/2680">It can bork your stdin</a></li>
</ol>
You get internet karma from me if you can help <em>permanently</em> solve any of those three problems.

<strong><span style="text-decoration:underline;">Package caching</span>:</strong>

As part of my deployments, Puppet installs a lot of packages. Repeatedly hitting a public mirror isn't a very friendly thing to do, it wastes bandwidth, and it's slower than having the packages locally! Setting up a proper mirror is a nice solution, but it comes with a management overhead. <a href="http://www.pulpproject.org/">There is really only one piece of software that manages repositories properly</a>, but using <a href="http://www.pulpproject.org/">pulp</a> has its own overhead, and is beyond the scope of this article. Because we're not using our own local mirror, this won't allow you to work entirely offline, as the metadata still needs to get downloaded from the net.

<strong><span style="text-decoration:underline;">Installation</span>:</strong>

As an interim solution, we can use <a href="https://github.com/fgrehm/vagrant-cachier">vagrant-cachier</a>. This plugin adds <em>synced_folder</em>'s to the apt/yum cache directories. Sneaky! Since this requires two-way sync, you'll need to get NFS folder syncing/mounting working first. Luckily, I've already taught you that!

To pass the right options through to vagrant-cachier, you'll need <a href="https://github.com/fgrehm/vagrant-cachier/pull/68">this patch</a>. I'd recommend first installing the plugin with:
```
$ vagrant plugin install vagrant-cachier
```
and then patching your vagrant-cachier manually. On my machine, the file to patch is found at:
```
~/.vagrant.d/gems/gems/vagrant-cachier-0.5.0/lib/vagrant-cachier/provision_ext.rb
```
<strong><span style="text-decoration:underline;">Vagrantfile</span>:</strong>

Here's what I put in my <code>Vagrantfile</code>:

{{< highlight ruby >}}
# NOTE: this doesn't cache metadata, full offline operation not possible
config.cache.auto_detect = true
config.cache.enable :yum		# choose :yum or :apt
if not ARGV.include?('--no-parallel')	# when running in parallel,
	config.cache.scope = :machine	# use the per machine cache
end
config.cache.enable_nfs = true	# sets nfs => true on the synced_folder
# the nolock option is required, otherwise the NFSv3 client will try to
# access the NLM sideband protocol to lock files needed for /var/cache/
# all of this can be avoided by using NFSv4 everywhere. die NFSv3, die!
config.cache.mount_options = ['rw', 'vers=3', 'tcp', 'nolock']
{{< /highlight >}}
Since multiple package managers operating on the same cache can cause locking issues, this plugin lets you decide if you want a shared cache for all machines, or if you want separate caches. I know that when I use the <code>--no-parallel</code> option it's safe (enough) to use a common cache because Puppet does all the package installations, and they all happen during each of their first provisioning runs which are themselves sequential.

This isn't perfect, it's a hack, but hacks are fun, and in this case, very useful. If things really go wrong, it's easy to rebuild everything! I still think a few sneaky bugs remain in vagrant-cachier with libvirt, so please find, report, and patch them if you can, although it might be NFS that's responsible.

<strong><span style="text-decoration:underline;">Puppet integration</span>:</strong>

Integration with Puppet makes this all worthwhile. There are two scenarios:
<ol>
	<li>You're using a puppetmaster, and you care about things like <a href="http://docs.puppetlabs.com/puppet/3/reference/lang_exported.html">exported resources</a> and multi-machine systems.</li>
	<li>You don't have a puppetmaster, and you're running standalone "single machine" code.</li>
</ol>
The correct answer is #1. Standalone Puppet code is bad for a few reasons:
<ol type="a">
	<li>It neglects the multi-machine nature of servers, and software.</li>
	<li>You're not able to use useful features like exported resources.</li>
	<li>It's easy to (unknowingly) write code that won't work <em>with</em> a puppetmaster.</li>
</ol>
If you'd like to see some code which was intentionally written to only work without a puppetmaster (and the puppetmaster friendly equivalent) have a look at my <a title="Pushing Puppet at Puppet Camp DC, LISA 2013" href="/blog/2013/11/05/pushing-puppet-at-puppet-camp-dc-lisa-2013/">Pushing Puppet</a> material.

There is one good reason for standalone Puppet code, and that is: <a href="https://en.wikipedia.org/wiki/Bootstrapping#Computing">bootstrapping</a>. In particular, bootstrapping the Puppet server.

<strong><span style="text-decoration:underline;">DNS</span>:</strong>

You need some sort of working DNS setup for this to function properly. Whether that involves hacking up your <code>/etc/hosts</code> files, using one of the vagrant DNS plugins, or running dnsmasq/bind is up to you. I haven't found an elegant solution yet, hopefully not telling you what I've done will push you to come up with something awesome!

<strong><span style="text-decoration:underline;">The :puppet_server provisioner</span>:</strong>

This is the vagrant (puppet agent) provisioner that lets you talk to a puppet server. Here's my config:

{{< highlight ruby >}}
vm.vm.provision :puppet_server do |puppet|
	puppet.puppet_server = 'puppet'
	puppet.options = '--test'    # see the output
end
{{< /highlight >}}
I've added the <code>--test</code> option so that I can see the output go by in my console. I've also disabled the <em>puppet</em> service on boot in my base machine image, so that it doesn't run before I get the chance to watch it. If your base image already has the <em>puppet</em> service running on boot, you can disable it with a shell provisioner. That's it!

<strong><span style="text-decoration:underline;">The :puppet provisioner</span>:</strong>

This is the standalone vagrant (puppet apply) provisioner. It seems to get misused quite a lot! As I mentioned, I'm only using it to bootstrap my puppet server. That's why it's a useful provisioner. Here's my config:

{{< highlight ruby >}}
vm.vm.provision :puppet do |puppet|
	puppet.module_path = 'puppet/modules'
	puppet.manifests_path = 'puppet/manifests'
	puppet.manifest_file = 'site.pp'
	# custom fact
	puppet.facter = {
		'vagrant' => '1',
	}
end
{{< /highlight >}}
The <code>puppet/{modules,manifests}</code> directories should exist in your project root. I keep the <code>puppet/modules/</code> directory fresh with a make script that rsync's code in from my git directories, but that's purely a personal choice. I added the custom fact as an example. All that's left is for this code to build a puppetmaster!

<strong><span style="text-decoration:underline;">Building a puppetmaster</span>:</strong>

Here's my <code>site.pp</code>:

{{< highlight ruby >}}
node puppet {	# puppetmaster

	class { '::puppet::server':
		pluginsync => true,	# do we want to enable pluginsync?
		storeconfigs => true,	# do we want to enable storeconfigs?
		autosign => ['*'],	# NOTE: this is a temporary solution
		#repo => true,		# automatic repos (DIY for now)
		start => true,
	}

	class { '::puppet::deploy':
		path => '/vagrant/puppet/',	# puppet folder is put here...
		backup => false,		# don't use puppet to backup...
	}
}
{{< /highlight >}}
As you can see, I <em>include</em> two classes. The first one installs and configures the <em>puppetmaster</em>, <em>puppetdb</em>, and so on. The second class runs an <code>rsync</code> from the vagrant deployed <code>/vagrant/puppet/</code> directory to the proper directories inside of <code>/etc/puppet/</code> and wherever else is appropriate. Each time I want to push new puppet code, I run <code>vp puppet</code> and then <code>vp <host></code> of whichever host I want to test. You can even combine the two commands into a one-liner with <code>&&</code> if you'd like.

<strong><span style="text-decoration:underline;">The puppet-puppet module</span>:</strong>

This is the hairy part. I've always had an issue with this module. I recently ripped out support for a lot of the old puppet 0.24 era features, and I've only since tested it on the recent 3.x series. A lot has changed from version to version, so it has been hard to follow this and keep it sane. There are serious improvements that could be made to the code. In fact, I wouldn't recommend it unless you're okay hacking on Puppet code:

<a href="https://github.com/purpleidea/puppet-puppet">https://github.com/purpleidea/puppet-puppet</a>

<strong><a href="https://www.youtube.com/watch?v=N1uIIY2glaY&html5=1"><span style="text-decoration:underline;">Most importantly</span></a>:</strong>

This was a long article! I could have split it up into multiple posts, gotten more internet traffic karma, and would have seemed like a much more prolific blogger as a result, but I figured you'd prefer it all in one big lot, and without any suspense. Prove me right by <a title="donate" href="/donate/">leaving me a tip</a>, and giving me your <a href="#comments">feedback</a>.

Happy hacking!

James

PS: You'll want to be able to follow along with everything in this article if you want to use the upcoming <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a>+Vagrant infrastructure that I'll be releasing.

PPS: Heh heh heh...

PPPS: Get it? Vagrant -&gt; Oscar the Grouch -&gt; Muppets -&gt; Puppet

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
