+++
date = "2014-05-13 18:58:06"
title = "Vagrant on Fedora with libvirt (reprise)"
draft = "false"
categories = ["technical"]
tags = ["devops", "fedora", "fedora 20", "gluster", "libvirt", "planetdevops", "planetfedora", "planetpuppet", "polkit", "puppet", "puppet-gluster", "vagrant", "vagrant-libvirt", "virsh", "virt-manager"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/05/13/vagrant-on-fedora-with-libvirt-reprise/"
+++

<a href="http://www.vagrantup.com/">Vagrant</a> has become the <em>de facto</em> tool for <em>devops</em>. Faster iterations, clean environments, and less overhead. This <em>isn't</em> an article about <em>why</em> you should use Vagrant. This is an article about <em>how</em> to get up and running with Vagrant on Fedora with libvirt <em>easily</em>!

<span style="text-decoration:underline;">Background</span>:

This article is an update of my original <a href="/blog/2013/12/09/vagrant-on-fedora-with-libvirt/">Vagrant on Fedora with libvirt</a> article. There is still lots of good information in that article, but this one should be easier to follow and uses updated versions of Vagrant and vagrant-libvirt.

<span style="text-decoration:underline;">Why vagrant-libvirt</span>?

Vagrant ships by default with support for virtualbox. This makes sense as a default since it is available on Windows, Mac, and GNU/Linux. Real hackers use GNU/Linux, and in my opinion the best tool for GNU/Linux is <a href="https://github.com/pradels/vagrant-libvirt/">vagrant-libvirt</a>. Proprietary, closed source platforms aren't hackable and therefore aren't cool!

Another advantage to using the <a href="https://github.com/pradels/vagrant-libvirt/">vagrant-libvirt</a> plugin is that it plays nicely with the existing ecosystem of <a href="http://libvirt.org/apps.html">libvirt tools</a>. You can use virsh, virt-manager, and guestfish alongside Vagrant, and if your development work needs to go into production, you can be confident in knowing that it was already tested on the same awesome KVM virtualization platform that your servers run.

<span style="text-decoration:underline;">Prerequisites</span>:

Let's get going. What do you need?
<ul>
	<li>A Fedora 20 machine</li>
</ul>
I recommend hardware that supports VT extensions. Most does these days. This should also work with other GNU/Linux distro's, but I haven't tested them.

<span style="text-decoration:underline;">Installation</span>:

I'm going to go through this in a logical hacking order. This means you could group all the <code>yum install</code> commands into a single execution at the beginning, but you would learn much less by doing so.

First install some of your favourite hacking dependencies. I did this on a minimal, headless F20 installation. You might want to add some of these too:
```
# yum install -y wget tree vim screen mtr nmap telnet tar git
```
Update the system to make sure it's fresh:
```
# yum update -y
```
<strong><span style="text-decoration:underline;">Update</span>:</strong> I'm actually now using vagrant 1.6.5, and you should try that instead. It should work for you too. Modify the below to match the newer version.

Download Vagrant version 1.5.4. No, don't use the latest version, it probably won't work! Vagrant has new releases practically as often as there are sunsets, and they typically cause lots of breakages.
```
$ wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.4_x86_64.rpm
```
and install it:
```
# yum install -y vagrant_1.5.4_x86_64.rpm
```
<span style="text-decoration:underline;">RVM installation</span>:

In order to get vagrant-libvirt working, you'll need some ruby dependencies. It turns out that <a href="https://rvm.io/">RVM</a> seems to be the best way to get exactly what you need. Use the sketchy RVM installer:
```
# \curl -sSL https://get.rvm.io | bash -s stable
```
If you don't know why that's sketchy, then you probably shouldn't be hacking! I did that as root, but it probably works when you run it as a normal user. At this point <code>rvm</code> should be installed. The last important thing you'll need to do is to add yourself to the <code>rvm</code> group. This is only needed if you installed rvm as root:
```
# usermod -aG rvm <username>
```
You'll probably need to logout and log back in for this to take effect. Run:
```
$ groups
```
to make sure you can see <em>rvm</em> in the list. If you ran rvm as root, you'll want to source the <code>rvm.sh</code> file:
```
$ source /etc/profile.d/rvm.sh
```
or simply use a new terminal. If you ran it as a normal user, I think RVM adds something to your <code>~/.bashrc</code>. You might want to reload it:
```
$ source ~/.bashrc
```
At this point RVM should be working. Let's see which ruby's it can install:
```
$ rvm list known
```
Ruby version <code>ruby-2.0.0-p353</code> seems closest to what is available on my Fedora 20 machine, so I'll use that:
```
$ rvm install ruby-2.0.0-p353
```
If the exact patch number isn't available, choose what's closest. Installing ruby requires a bunch of dependencies. The <code>rvm install</code> command will ask yum for a bunch of dependencies, but if you'd rather install them yourself, you can run:
```
# yum install -y patch libyaml-devel libffi-devel glibc-headers autoconf gcc-c++ glibc-devel patch readline-devel zlib-devel openssl-devel bzip2 automake libtool bison
```
<span style="text-decoration:underline;">GEM installation</span>:

Now we need the GEM dependencies for the vagrant-libvirt plugin. These GEM's happen to have their own build dependencies, but thankfully I've already figured those out for you:
```
# yum install -y libvirt-devel libxslt-devel libxml2-devel
```
<strong><span style="text-decoration:underline;">Update</span>:</strong> Typically we used to now have to install the nokogiri dependencies. With newer versions of vagrant-libvirt, this is no longer necessarily required. Consider skipping this step, and trying to install the vagrant-libvirt plugin without specifying a version. If it doesn't work, try vagrant-libvirt version 0.0.20, if that doesn't work, install nokogiri. Feel free to post your updated experiences in the comments!

Now, install the <em>nokogiri</em> gem that vagrant-libvirt needs:
```
$ gem install nokogiri -v '1.5.11'
```
and finally we can install the actual vagrant-libvirt plugin:
```
$ vagrant plugin install --plugin-version 0.0.16 vagrant-libvirt
```
You don't have to specify the --plugin-version 0.0.16 part, but doing so will make sure that you get a version that I have tested to be compatible with Vagrant 1.5.4 should a newer vagrant-libvirt release not be compatible with the Vagrant version you're using. If you're feeling brave, please test newer versions, <a href="https://github.com/pradels/vagrant-libvirt/issues/new">report bugs</a>, and write patches!

<span style="text-decoration:underline;">Making Vagrant more useful</span>:

Vagrant should basically work at this point, but it's missing some awesome. I'm proud to say that I wrote this awesome. I recommend my bash function and alias additions. If you'd like to include them, you can run:
```
$ wget https://gist.githubusercontent.com/purpleidea/8071962/raw/ee27c56e66aafdcb9fd9760f123e7eda51a6a51e/.bashrc_vagrant.sh
$ echo '. ~/.bashrc_vagrant.sh' >> ~/.bashrc
$ . ~/.bashrc    # reload
```
to pull in my most used Vagrant aliases and functions. I've written about them before. If you're interested, please read:
<ul>
	<li><a href="/blog/2013/12/21/vagrant-vsftp-and-other-tricks/">Vagrant vsftp and other tricks</a></li>
	<li><a href="/blog/2014/01/02/vagrant-clustered-ssh-and-screen/">Vagrant clustered SSH and ‘screen’</a></li>
</ul>
<span style="text-decoration:underline;">KVM/QEMU installation</span>:

As I mentioned earlier, I'm assuming you have a minimal Fedora 20 installation, so you might not have all the libvirt pieces installed! Here's how to install any potentially missing pieces:
```
# yum install -y libvirt{,-daemon-kvm}
```
This should pull in a whole bunch of dependencies too. You will need to start and (optionally) enable the libvirtd service:
```
# systemctl start libvirtd.service
# systemctl enable libvirtd.service
```
You'll notice that I'm using the <em>systemd</em> commands instead of the deprecated <code>service</code> command. My biggest (only?) gripe with systemd is that the command line tools aren't as friendly as they could be! The <code>systemctl</code> equivalent requires more typing, and make it harder to start or stop the same service in quick succession, because it buries the <em>action</em> in the <em>middle</em> of the command instead of leaving it at the <em>end</em>!

The libvirtd service should finally be running. On my machine, it comes with a <em>default</em> network which got in the way of my vagrant-libvirt networking. If you want to get rid of it, you can run:
```
# virsh net-destroy default
# virsh net-undefine default
```
and it shouldn't bother you anymore. One last hiccup. If it's your first time installing KVM, you might run into <a href="https://bugzilla.redhat.com/show_bug.cgi?id=950436">bz#950436</a>. To workaround this issue, I had to run:
```
# rmmod kvm_intel
# rmmod kvm
# modprobe kvm
# modprobe kvm_intel
```
Without this "module re-loading" you might see this error:
```
Call to virDomainCreateWithFlags failed: internal error: Process exited while reading console log output: char device redirected to /dev/pts/2 (label charserial0)
Could not access KVM kernel module: Permission denied
failed to initialize KVM: Permission denied
```
<span style="text-decoration:underline;">Additional installations</span>:

To make your machine somewhat more palatable, you might want to consider installing bash-completion:
```
# yum install -y bash-completion
```
You'll also probably want to add the PolicyKit (polkit) <code>.pkla</code> file that I recommend in my <a href="/blog/2013/12/09/vagrant-on-fedora-with-libvirt/">earlier article</a>. Typically that means adding something like:
```
[Allow james libvirt management permissions]
Identity=unix-user:james
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes
```
as root to somewhere like:
```
/etc/polkit-1/localauthority/50-local.d/vagrant.pkla
```
Your machine should now be setup perfectly! The last thing you'll need to do is to make sure that you get a Vagrantfile that does things properly! Here are some recommendations.

<span style="text-decoration:underline;">Shared folders</span>:

Shared folders are a mechanism that Vagrant uses to pass data into (and sometimes out of) the virtual machines that it is managing. Typically you can use NFS, rsync, and some provider specific folder sharing like <a href="http://www.linux-kvm.org/page/9p_virtio">9p</a>. Using rsync is the simplest to set up, and works exceptionally well. Make sure you include the following line in your Vagrantfile:
```
config.vm.synced_folder './', '/vagrant', type: 'rsync'
```
If you want to see an example of this in action, you can have a look at my <a href="https://github.com/purpleidea/puppet-gluster/blob/master/vagrant/gluster/Vagrantfile#L267">puppet-gluster Vagrantfile</a>. If you are using the <a href="https://docs.vagrantup.com/v2/provisioning/puppet_apply.html">puppet apply</a> provisioner, you will have to set it to use rsync as well:
```
puppet.synced_folder_type = 'rsync'
```
<span style="text-decoration:underline;">KVM performance</span>:

Due to a regression in vagrant-libvirt, the default driver used for virtual machines is <em>qemu</em>. If you want to use the accelerated KVM domain type, you'll have to <a href="https://github.com/purpleidea/puppet-gluster/blob/master/vagrant/Vagrantfile#L578">set</a> it:
```
libvirt.driver = 'kvm'
```
This typically gives me a <em>5x</em> performance increase over plain qemu. <a href="https://github.com/pradels/vagrant-libvirt/pull/182">This fix is available in the latest vagrant-libvirt version.</a> <a href="https://github.com/pradels/vagrant-libvirt/pull/185">The default has been set to KVM in the latest git master.</a>

<span style="text-decoration:underline;">Dear internets</span>!

I think this was fairly straightforward. You could probably even put all of these commands in a shell script and just run it to get it all going. What we really need is proper RPM packaging. If you can help out, that would be excellent!

If we had a version of vagrant-libvirt alongside a matching Vagrant version in Fedora, then developers and hackers could target that, and we could easily exchange dev environments, hackers could distribute product demos as full vagrant-libvirt clusters, and I could stop having to write these types of articles ;)

I hope this was helpful to you. Please let me know in the <a href="#comments">comments</a>.

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
