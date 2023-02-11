+++
date = "2015-07-08 01:14:19"
title = "Oh-My-Vagrant “Mainstream” mode and COPR RPM's"
draft = "false"
categories = ["technical"]
tags = ["VAGRANT_CWD", "VAGRANT_DOTFILE_PATH", "copr", "fedora", "gluster", "mainstream mode", "makefile", "oh-my-vagrant", "omv", "planetdevops", "planetfedora", "planetpuppet", "python", "rpm", "vagrant", "vagrant-libvirt", "vansible", "vcssh", "vdestroy", "vfwd", "vlog", "vp", "vrm-rf", "vrsync", "vscreen", "vsftp", "vup"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/07/08/oh-my-vagrant-mainstream-mode-and-copr-rpms/"
+++

Making <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant</a> (OMV) more developer accessible and easy to install (from a distribution package like RPM) has always been a goal, but was previously never a priority. This is all sorted out now. In this article, I'll explain how "mainstream" mode works, and how the RPM work was done. (I promise this will be somewhat interesting!)

<strong><span style="text-decoration:underline;">Prerequisites</span>:</strong>

If you haven't read any of the <a href="/tags/oh-my-vagrant/">previous articles about Oh-My-Vagrant</a>, I'd recommend you start there. Many of the articles include screencasts, and combined with the <a href="https://github.com/purpleidea/oh-my-vagrant/tree/master/examples">examples/</a> folder, this is probably the best way to learn OMV, because the <a href="https://github.com/purpleidea/oh-my-vagrant/issues/79">documentation could use some love</a>.

<strong><span style="text-decoration:underline;">Installation</span>:</strong>

OMV is now easily installable on Fedora 22 via COPR. It probably works on other distros and versions, but I haven't tested all of those combinations. This is a colossal improvement from when I <a href="/blog/2013/12/09/vagrant-on-fedora-with-libvirt/" target="_blank">first posted about this publicly in 2013</a>. There is still <a href="https://bugzilla.redhat.com/show_bug.cgi?id=1221304" target="_blank">one annoying bug</a> that I occasionally hit. Let me know if you can reproduce.

Install from COPR:
```
james@computer:~$ sudo dnf copr enable purpleidea/oh-my-vagrant

You are about to enable a Copr repository. Please note that this
repository is not part of the main Fedora distribution, and quality
may vary.

The Fedora Project does not exercise any power over the contents of
this repository beyond the rules outlined in the Copr FAQ at
, and
packages are not held to any quality or security level.

Please do not file bug reports about these packages in Fedora
Bugzilla. In case of problems, contact the owner of this repository.

Do you want to continue? [y/N]: y
Repository successfully enabled.
james@computer:~$ sudo dnf install oh-my-vagrant
Last metadata expiration check performed 0:05:08 ago on Tue Jul  7 22:58:45 2015.
Dependencies resolved.
================================================================================
 Package           Arch     Version            Repository                  Size
================================================================================
Installing:
 oh-my-vagrant     noarch   0.0.7-1            purpleidea-oh-my-vagrant   270 k
 vagrant           noarch   1.7.2-7.fc22       updates                    428 k
 vagrant-libvirt   noarch   0.0.26-2.fc22      fedora                      57 k

Transaction Summary
================================================================================
Install  3 Packages

Total download size: 755 k
Installed size: 2.5 M
Is this ok [y/N]: n
Operation aborted.
james@computer:~$ sudo dnf install -y oh-my-vagrant
Last metadata expiration check performed 0:05:19 ago on Tue Jul  7 22:58:45 2015.
Dependencies resolved.
================================================================================
 Package           Arch     Version            Repository                  Size
================================================================================
Installing:
 oh-my-vagrant     noarch   0.0.7-1            purpleidea-oh-my-vagrant   270 k
 vagrant           noarch   1.7.2-7.fc22       updates                    428 k
 vagrant-libvirt   noarch   0.0.26-2.fc22      fedora                      57 k

Transaction Summary
================================================================================
Install  3 Packages

Total download size: 755 k
Installed size: 2.5 M
Downloading Packages:
(1/3): vagrant-1.7.2-7.fc22.noarch.rpm          626 kB/s | 428 kB     00:00    
(2/3): vagrant-libvirt-0.0.26-2.fc22.noarch.rpm  70 kB/s |  57 kB     00:00    
(3/3): oh-my-vagrant-0.0.7-1.noarch.rpm         243 kB/s | 270 kB     00:01    
--------------------------------------------------------------------------------
Total                                           246 kB/s | 755 kB     00:03     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Installing  : vagrant-1.7.2-7.fc22.noarch                                 1/3 
  Installing  : vagrant-libvirt-0.0.26-2.fc22.noarch                        2/3 
  Installing  : oh-my-vagrant-0.0.7-1.noarch                                3/3 
  Verifying   : oh-my-vagrant-0.0.7-1.noarch                                1/3 
  Verifying   : vagrant-libvirt-0.0.26-2.fc22.noarch                        2/3 
  Verifying   : vagrant-1.7.2-7.fc22.noarch                                 3/3 

Installed:
  oh-my-vagrant.noarch 0.0.7-1                vagrant.noarch 1.7.2-7.fc22       
  vagrant-libvirt.noarch 0.0.26-2.fc22       

Complete!
james@computer:~$
```
If you'd like to avoid typing passwords over and over again when using vagrant, you can add yourself into the vagrant group. 99% of people do this. The downside is that it could allow your user account to get root privileges. Since most developers have a single user environment, it's not a big issue. This is necessary because vagrant uses the <code>qemu:///system</code> connection instead of <code>qemu:///session</code>. If you can help fix this, <a href="https://github.com/pradels/vagrant-libvirt/issues/272">please hack on it</a>.
```
james@computer:~$ groups
james wheel docker
james@computer:~$ sudo usermod -aG vagrant james
# you'll need to logout/login for this change to take effect...
```
Lastly, there is a user session plugin addition that is required. Installation is automatic the first time you create a new OMV project. Let's do that and see how it works!
```
james@computer:~$ mkdir /tmp/omvtest
james@computer:~$ cd !$
cd /tmp/omvtest
james@computer:/tmp/omvtest$ which omv
/usr/bin/omv
james@computer:/tmp/omvtest$ omv init
Oh-My-Vagrant needs to install a modified vagrant-hostmanager plugin.
Is this ok [y/N]: y
Cloning into 'vagrant-hostmanager'...
remote: Counting objects: 801, done.
remote: Total 801 (delta 0), reused 0 (delta 0), pack-reused 801
Receiving objects: 100% (801/801), 132.22 KiB | 0 bytes/s, done.
Resolving deltas: 100% (467/467), done.
Checking connectivity... done.
Branch feat/oh-my-vagrant set up to track remote branch feat/oh-my-vagrant from origin.
Switched to a new branch 'feat/oh-my-vagrant'
sending incremental file list
./
vagrant-hostmanager.rb
vagrant-hostmanager/
vagrant-hostmanager/action.rb
vagrant-hostmanager/command.rb
vagrant-hostmanager/config.rb
vagrant-hostmanager/errors.rb
vagrant-hostmanager/plugin.rb
vagrant-hostmanager/provisioner.rb
vagrant-hostmanager/util.rb
vagrant-hostmanager/version.rb
vagrant-hostmanager/action/
vagrant-hostmanager/action/update_all.rb
vagrant-hostmanager/action/update_guest.rb
vagrant-hostmanager/action/update_host.rb
vagrant-hostmanager/hosts_file/
vagrant-hostmanager/hosts_file/updater.rb

sent 20,560 bytes  received 286 bytes  41,692.00 bytes/sec
total size is 19,533  speedup is 0.94
Patched successfully!
Current machine states:

omv1                      not created (libvirt)

The Libvirt domain is not created. Run `vagrant up` to create it.
james@computer:/tmp/omvtest$ ls
ansible/  docker/  kubernetes/  omv.yaml  puppet/  shell/
james@computer:/tmp/omvtest$
```
You can see that the plugin installation worked perfectly, and that OMV created a few files and folders.

<strong><span style="text-decoration:underline;">More usage</span>:</strong>

You can hide that generated mess in a subfolder if you prefer:
```
james@computer:/tmp/omvtest$ mkdir /tmp/omvtest2
james@computer:/tmp/omvtest$ cd !$
cd /tmp/omvtest2
james@computer:/tmp/omvtest2$ omv init mess
Current machine states:

omv1                      not created (libvirt)

The Libvirt domain is not created. Run `vagrant up` to create it.
james@computer:/tmp/omvtest2$ ls
mess/  omv.yaml@
james@computer:/tmp/omvtest2$ ls -lAh
total 0
drwxrwxr-x. 7 james 160 Jul  7 23:26 mess/
lrwxrwxrwx. 1 james  13 Jul  7 23:26 omv.yaml -> mess/omv.yaml
drwxrwxr-x. 3 james  60 Jul  7 23:26 .vagrant/
james@computer:/tmp/omvtest2$ tree
.
├── mess
│   ├── ansible
│   │   └── modules
│   ├── docker
│   ├── kubernetes
│   │   ├── applications
│   │   └── templates
│   ├── omv.yaml
│   ├── puppet
│   │   └── modules
│   └── shell
└── omv.yaml -> mess/omv.yaml

10 directories, 2 files
james@computer:/tmp/omvtest2$
```
As you can see all the mess is wrapped up in a single folder. This could even be named <code>.omv</code> if you prefer, and should all be committed inside of your project. Now that we're installed, let's get hacking!

<strong><span style="text-decoration:underline;">Mainstream mode</span>:</strong>

Mainstream mode further hides the ruby/<code>Vagrantfile</code> aspect of a <a href="https://en.wikipedia.org/wiki/Vagrant_%28software%29">Vagrant</a> project and extends OMV so that you can define your entire project via the <code>omv.yaml</code> file, without the rest of the OMV project cluttering up your development tree. This makes it possible to have your project use OMV by only committing that one <em>yaml</em> file into the project repo.

The main difference is that you now control everything with the new <code>omv</code> command line tool. It's essentially a smart wrapper around the <code>vagrant</code> command, so any command you used to use <code>vagrant</code> for, you can now substitute in <code>omv</code>. It also saves typing four extra characters!

As it turns out (and by no accident) the <code>omv</code> tool works exactly like the <code>vagrant</code> tool. For example:
```
james@computer:/tmp/omvtest2$ omv status
Current machine states:

omv1                      not created (libvirt)

The Libvirt domain is not created. Run `vagrant up` to create it.
james@computer:/tmp/omvtest2$ omv up
Bringing machine 'omv1' up with 'libvirt' provider...
==> omv1: Box 'centos-7.1' could not be found. Attempting to find and install...
    omv1: Box Provider: libvirt
    omv1: Box Version: >= 0
==> omv1: Adding box 'centos-7.1' (v0) for provider: libvirt
    omv1: Downloading: https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/centos-7.1/centos-7.1.box
[snip]
james@computer:/tmp/omvtest2$ omv destroy
Unlocking shell provisioning for: omv1...
==> omv1: Domain is not created. Please run `vagrant up` first.
james@computer:/tmp/omvtest2$
```
<em>BUT THAT'S NOT ALL...</em>

The existing tools you know and love, like <code>vlog</code>, <a href="/blog/2013/12/21/vagrant-vsftp-and-other-tricks/"><code>vsftp</code></a>, <code>vscreen</code>, <a href="/blog/2014/01/02/vagrant-clustered-ssh-and-screen/"><code>vcssh</code></a>, <code>vfwd</code>, <code>vansible</code>, have all been modified to work with OMV mainstream mode as well. The same goes for common aliases such as <code>vs</code>, <code>vp</code>, <code>vup</code>, <code>vdestroy</code>, <code>vrsync</code>, and the useful (but occasionally dangerous) <code>vrm-rf</code>. Have a look at the above links on my blog and <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/extras/vagrant.bashrc">the source</a> to see what these do. If it's not clear enough, <a href="#comment">let me know</a>!

All of these are now packaged up in the <em>oh-my-vagrant</em> COPR and are installed automatically into <code>/etc/profile.d/oh-my-vagrant.sh</code> for your convenience. Since they're part of the OMV project, you'll get updates when new functions or bug fixes are made.

<strong><span style="text-decoration:underline;">The plumbing</span>:</strong>

Mainstream mode is possible because of an idea <a href="https://github.com/rbarlow">rbarlow</a> had. He gets full credit for the idea, in particular for teaching me about <code>VAGRANT_CWD</code> which is what makes it all work. I <a href="https://github.com/purpleidea/oh-my-vagrant/pull/89">rejected his 6 line prototype</a>, but loved the idea, and since he was busy making <a href="http://www.pulpproject.org/">juice</a>, I got bored one day and hacked on a <a href="https://github.com/purpleidea/oh-my-vagrant/commit/aa764ae79d69475b87f293c43af4f20fd7d1d000">full implementation</a>.
```
james@computer:~/code/oh-my-vagrant$ git diff --stat 853073431d227cbb0ba56aaf4fedd721904de9a8 aa764ae79d69475b87f293c43af4f20fd7d1d000
 DOCUMENTATION.md    | 18 <span style="color:#00ff00;">+++++++++++++++</span>
 bin/omv.sh          | 50 <span style="color:#00ff00;">+++++++++++++++++++++++++++++++++++++++++</span>
 vagrant/Vagrantfile | 65 <span style="color:#ff0000;"><span style="color:#00ff00;">++++++++++++++++++++++++++++++++++</span>-------------------</span>
 3 files changed, 110 insertions(+), 23 deletions(-)
james@computer:~/code/oh-my-vagrant$
```
It turned out it was a little longer, but I artificially inflated this by including some quick doc patches. What does it actually do differently? It sets <code>VAGRANT_CWD</code> and <code>VAGRANT_DOTFILE_PATH</code> so that the vagrant command looks in a different directory for the <code>Vagrantfile</code> and <code>.vagrant/</code> directories. That way, all the plumbing is hidden and part of the RPM.

<strong><span style="text-decoration:underline;">Making the RPM</span>:</strong>

The RPM's happened because <a href="https://github.com/stefwalter">stefw</a> made me feel bad about not having them. He was right to do so. In an case, RPM packaging still scares me. I think <a href="https://www.xkcd.com/1205/">repetitive work</a> scares me even more. That's why I <a href="https://xkcd.com/1319/">automate</a> as much as I can. So <a href="https://twitter.com/purpleidea/status/618167815388794881" target="_blank">after a lot of brain loss</a>, I finally made you an RPM so that you could easily install it. Here's how it went:

<a href="https://github.com/purpleidea/oh-my-vagrant/commit/8ee3fdab7451bb30b56e42c4586e4304b5805faf">I started by adding the magic so that my Makefile could build an RPM</a>.

This made it so I can easily run <code>make srpm</code> to get a new RPM or SRPM.

<a href="https://github.com/purpleidea/oh-my-vagrant/commit/6a6d1f2be89ac0ef932f98368fcf672c7a0d95cc">Then I added COPR integration</a>, so a <code>make copr</code> automatically kicks off a new COPR build. This was the interesting part. You'll need a <a href="https://apps.fedoraproject.org/#FAS">Fedora account</a> for this to work. Once you're logged in, if you go to <a href="https://copr.fedoraproject.org/api">https://copr.fedoraproject.org/api</a> you'll be able to download a snippet to put in your <code>~/.config/copr</code> file. Lastly, the work happens in <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/extras/copr-build.py">copr-build.py</a> where the python <em>copr</em> library does the heavy lifting.

{{< highlight python >}}

#!/usr/bin/python

# README:
# for initial setup, browse to: https://copr.fedoraproject.org/api/
# and it will have a ~/.config/copr config that you can download.
# happy hacking!

import os
import sys
import copr

COPR = 'oh-my-vagrant'
if len(sys.argv) != 2:
    print("Usage: %s <srpm url>" % sys.argv[0])
    sys.exit(1)

url = sys.argv[1]

client = copr.CoprClient.create_from_file_config(os.path.expanduser("~/.config/copr"))

result = client.create_new_build(COPR, [url])
if result.output != "ok":
    print(result.error)
    sys.exit(1)
print(result.message)
{{< /highlight >}}
A build looks like this:
```
james@computer:~/code/oh-my-vagrant$ git tag 0.0.8 # set a new tag
james@computer:~/code/oh-my-vagrant$ make copr 
Running templater...
Running git archive...
Running git archive submodules...
Running rpmbuild -bs...
Wrote: /home/james/code/oh-my-vagrant/rpmbuild/SRPMS/oh-my-vagrant-0.0.8-1.src.rpm
Running SRPMS sha256sum...
/home/james/code/oh-my-vagrant
Running SRPMS gpg...

You need a passphrase to unlock the secret key for
user: "James Shubin (Third PGP key.) <james@shubin.ca>"
4096-bit RSA key, ID 24090D66, created 2012-05-09

gpg: WARNING: The GNOME keyring manager hijacked the GnuPG agent.
gpg: WARNING: GnuPG will not work properly - please configure that tool to not interfere with the GnuPG system!
Running SRPMS upload...
sending incremental file list
SHA256SUMS
SHA256SUMS.asc
oh-my-vagrant-0.0.8-1.src.rpm

sent 8,583 bytes  received 2,184 bytes  4,306.80 bytes/sec
total size is 1,456,741  speedup is 135.30
Build was added to oh-my-vagrant.
james@computer:~/code/oh-my-vagrant$
```
A few minutes later, the COPR build page should look like this:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="omv-copr.png"><img class="size-medium wp-image-1098" src="omv-copr.png" alt="a screenshot of the Oh-My-Vagrant COPR build page for people who like to look at pretty pictures instead of just terminal output" width="100%" height="100%" /></a></td></tr><tr><td> A screenshot of the Oh-My-Vagrant COPR build page for people who like to look at pretty pictures instead of just terminal output.</td></tr></table></br />

There was a bunch of additional fixing and polishing required to get this as seamless as possible for you. Have a look at the <a href="https://github.com/purpleidea/oh-my-vagrant/commits/master">git commits</a> and you'll get an idea of all the work that was done, and you'll probably even learn about some <a href="https://github.com/purpleidea/oh-my-vagrant/commit/853073431d227cbb0ba56aaf4fedd721904de9a8">new</a>, <a href="https://github.com/purpleidea/oh-my-vagrant/commit/cec25b9a9c17a81956cc6457706bab0b358a9708">features</a> I haven't blogged about yet. It was exhausting!

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="https://twitter.com/purpleidea/status/618340109738450944" target="_blank"><img class="wp-image-1091 aligncenter" src="omv-exhausted.png" alt="omv-exhausted" width="100%" height="100%" /></a></td></tr></table></br />

As a result of all this, you can download fresh builds easily. Visit the COPR page to see how things are cooking:
<p style="text-align:center;"><strong><a href="https://copr.fedoraproject.org/coprs/purpleidea/oh-my-vagrant/">https://copr.fedoraproject.org/coprs/purpleidea/oh-my-vagrant/</a></strong></p>
I'll try to keep this pumping out releases regularly. If I lag behind, please holler at me. In any case, please let me know if you appreciate this work. <a href="#comment">Comment</a>, <a href="https://twitter.com/#!/purpleidea">tweeter</a>, or <a href="/contact/">contact me</a>!

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
