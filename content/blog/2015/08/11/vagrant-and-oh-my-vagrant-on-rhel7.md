+++
date = "2015-08-11 15:09:16"
title = "Vagrant and Oh-My-Vagrant on RHEL7"
draft = "false"
categories = ["technical"]
tags = ["centos", "centos7", "devops", "fedora", "freeipa", "gluster", "oh-my-vagrant", "omv", "planetdevops", "planetfedora", "planetipa", "planetpuppet", "puppet", "rhel", "rhel7", "vagrant", "vagrant-libvirt"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/08/11/vagrant-and-oh-my-vagrant-on-rhel7/"
+++

My <a href="https://redhat.com/">employer</a> keeps paying me, which I appreciate, so it's good to spend some time to make sure RHEL7 customers get a great developer experience! So here's how to make vagrant, vagrant-libvirt and <a href="/tags/oh-my-vagrant/">Oh-My-Vagrant</a> work on <a href="http://red.ht/1Aowjfh">RHEL 7+</a>. The same steps should work for CentOS 7+.

I'll first paste the commands you need to run, and then I'll explain what's happening for those that are interested:
```
# run these commands, and then get hacking!
# this requires the rhel-7-server-optional-rpms repo enabled
sudo subscription-manager repos --enable rhel-7-server-optional-rpms
sudo yum install -y gcc ruby-devel libvirt-devel libvirt qemu-kvm
sudo systemctl start libvirtd.service
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.rpm
sudo yum install -y vagrant_1.7.4_x86_64.rpm
vagrant plugin install vagrant-libvirt
wget https://copr.fedoraproject.org/coprs/purpleidea/vagrant-libvirt/repo/epel-7/purpleidea-vagrant-libvirt-epel-7.repo
sudo cp -a purpleidea-vagrant-libvirt-epel-7.repo /etc/yum.repos.d/
sudo yum install -y vagrant-libvirt    # noop plugin for oh-my-vagrant dependency
wget https://copr.fedoraproject.org/coprs/purpleidea/oh-my-vagrant/repo/epel-7/purpleidea-oh-my-vagrant-epel-7.repo
sudo cp -a purpleidea-oh-my-vagrant-epel-7.repo /etc/yum.repos.d/
sudo yum install -y oh-my-vagrant
. /etc/profile.d/oh-my-vagrant.sh # logout/login or source
```
Let's go through it line by line.
```
sudo subscription-manager repos --enable rhel-7-server-optional-rpms
```
Make sure you have the optional repos enabled, which are needed for the ruby-devel package.
```
sudo yum install -y gcc ruby-devel libvirt-devel libvirt
sudo systemctl start libvirtd.service
```
Other than the base os, these are the dependencies you'll need. If you have some sort of super minimal installation, and find that there is another dependency needed, please let me know and I'll update this article. Usually libvirt is already installed, and libvirtd is started, but this includes those two operations in case they are needed.
```
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.rpm
sudo yum install -y vagrant_1.7.4_x86_64.rpm
```
Vagrant has finally landed in Fedora 22, but unfortunately it's not in RHEL or any of the software collections yet. As a result, we install it from the upstream.
```
vagrant plugin install vagrant-libvirt
```
Similarly, vagrant-libvirt hasn't been packaged for RHEL either, so we'll install it into the users home directory via the vagrant plugin system.
```
wget https://copr.fedoraproject.org/coprs/purpleidea/vagrant-libvirt/repo/epel-7/purpleidea-vagrant-libvirt-epel-7.repo
sudo cp -a purpleidea-vagrant-libvirt-epel-7.repo /etc/yum.repos.d/
sudo yum install -y vagrant-libvirt    # noop plugin for oh-my-vagrant dependency
```
Since there isn't a vagrant-libvirt RPM, and because <a href="/blog/2015/07/08/oh-my-vagrant-mainstream-mode-and-copr-rpms/">the RPM's for Oh-My-Vagrant</a> depend on that "requires" to install correctly, I built an empty vagrant-libvirt RPM so that Oh-My-Vagrant thinks the dependency has been met in system wide RPM land, when it's actually been met in the user specific home directory space. I couldn't think of a better way to do this, and as a result, you get to read about the exercise that prompted my <a href="/blog/2015/08/11/making-an-empty-rpm/">recent "empty RPM" article.</a>
```
wget https://copr.fedoraproject.org/coprs/purpleidea/oh-my-vagrant/repo/epel-7/purpleidea-oh-my-vagrant-epel-7.repo
sudo cp -a purpleidea-oh-my-vagrant-epel-7.repo /etc/yum.repos.d/
sudo yum install -y oh-my-vagrant
```
This last part installs Oh-My-Vagrant from the COPR. There is no "<code>dnf enable</code>" command in RHEL, so we manually <code>wget</code> the repo file into place.
```
. /etc/profile.d/oh-my-vagrant.sh # logout/login or source
```
Lastly if you'd like to reuse your current terminal session, source the <code>/etc/profile.d/</code> file that is installed, otherwise close and reopen your terminal.

You'll need to do an <code>omv init</code> at least once to make sure all the user plugins are installed, and you should be ready for your first <code>vagrant up</code>! Please note, that the above process definitely includes some dirty workarounds until vagrant is more easily consumable in RHEL, but I wanted to get you hacking earlier rather than later!

I hope this article helps you hack it out in RHEL land, be sure to read about <a href="/blog/2015/02/23/building-rhel-vagrant-boxes-with-vagrant-builder/">how to build your own <em>custom</em> RHEL vagrant boxes</a> too!

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
