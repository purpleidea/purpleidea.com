+++
date = "2013-10-15 16:52:29"
title = "GNOME Montreal Summit"
draft = "false"
categories = ["technical"]
tags = ["abiword", "accessibility", "montreal", "aicd", "planetfedora", "yorba", "pgo", "summit", "hacking hearts", "jhbuild", "geary", "gnome", "gnome boxes", "gnome continuous", "gnome summit", "gtk"]
author = "jamesjustjames"
+++

This October 12th to 14th Montreal hosted the <a href="https://www.gnome.org/">GNOME</a> <del>boston</del> summit. Many thanks to <a href="http://www.canonical.com/">Canonical</a> for sponsoring breakfast, <a href="http://www.savoirfairelinux.com/en/">Savoir Faire Linux</a> for hosting a great <em><a href="https://en.wikipedia.org/wiki/Cinq_%C3%A0_sept">6 à 10</a></em> with fancy snacks, and <a href="http://www.redhat.com/">RedHat</a> for sponsoring a <a href="https://en.wikipedia.org/wiki/Pool_%28cue_sports%29">pool</a> night. What follows is some technical commentary about stuff that went on.

<span style="text-decoration:underline;">JHBuild</span>

<a href="https://wiki.gnome.org/Jhbuild">JHBuild</a> is a tool to make it easy to download/clone (from git) and compile all the GNOME modules and applications. It was easy to get going. I (mostly) followed the steps listed on the <a href="https://wiki.gnome.org/HowDoI/Jhbuild">JHBuild HowDoI wiki page</a>. I kept my <em>.jhbuildrc</em> in my home directory instead of <em>~/.config/</em>. On my Fedora 19 machine, I found certain unlisted dependencies were missing to build everything. You can figure these out yourself when your builds fail, or just run the following command to install them beforehand:
```
# yum install /usr/bin/{g++,a2x,gnome-doc-prepare} python-rdflib lua-devel
```
The abridged list of commands that I ran includes:
```
$ git clone git://git.gnome.org/jhbuild
$ ./autogen.sh --simple-install
$ make
$ make install
$ ln -s ~/.local/bin/jhbuild ~/bin/jhbuild
$ jhbuild sysdeps --install
$ jhbuild buildone gnome-themes-standard    # i was impatient to get this early
$ jhbuild update                            # at home on fast network
$ jhbuild build --no-network                # can be run offline if you like
$ jhbuild run gedit
$ jhbuild shell                             # then run `env` inside the shell
```
You want to properly understand the context and working directory for each of these, but it should help get you to understand the process more quickly. One thing to realize is that the <em>jhbuild run </em> actually just runs a command from your $PATH, but from within the jhbuild environment, with modified <em>$PATH</em> and prefix variables. Run:
```
$ jhbuild run env
```
to get a better understanding of what changes. When patching, I recommend you <em>clone</em> locally from the mirrored git clones into your personal <em>~/code/</em> hacking directory. This way JHBuild can continue to do its thing, and keep the checkouts at master without your changes breaking the process.

<span style="text-decoration:underline;">Boxes</span>

Boxes is a simple <a href="http://virt-manager.org/">virtual machine manager</a> for the GNOME desktop.

<a href="http://zee-nix.blogspot.ca/">Zeeshan</a> talked about some of the work he's been doing in <a href="https://en.wikipedia.org/wiki/Boxes_%28software%29">boxes</a>. <a href="http://blogs.gnome.org/mccann/">William Jon McCann</a> reviewed some of the UI bugs, and I proposed the idea of integrating puppet modules so that a user could pick a module, and have a test environment running in minutes. This could be a way for users to try <a href="https://github.com/purpleidea/puppet-gluster">GlusterFS</a> or <a href="https://github.com/purpleidea/puppet-ipa">FreeIPA</a>.

<span style="text-decoration:underline;">GNOME Continuous</span>

<a href="https://wiki.gnome.org/GnomeContinuous">GNOME continuous</a> (formerly known as GNOME-OSTree) is a project by <a href="http://blog.verbum.org/">Colin Walters</a>. It is amazing for two reasons in particular:
<ol>
	<li>It does <a href="https://en.wikipedia.org/wiki/Continuous_integration">continuous integration</a> testing on a running OS image built from GNOME git master. This has enabled Colin to catch when commits break apps. It even takes <a href="http://build.gnome.org/ostree/buildmaster/builds/">screenshots</a> so that you see what the running apps look like.</li>
	<li>It provides bootable GNOME images that you can run locally in a vm. The images are built from GNOME git master. While there are no security updates, and this is not recommended for normal use, it is a great way to test out the bleeding edge of GNOME and report bugs early. It comes with an atomic upgrade method to keep your image up to date with the latest commits.</li>
</ol>
My goal is to try to run the bootable image for an hour every month. This way, I'll be able to catch GNOME bugs early before they trickle down into Fedora and other GNOME releases.

<span style="text-decoration:underline;">Abiword 3.0</span>

<a href="http://www.figuiere.net/hub/blog/">Hubert Figuière</a> released <a href="http://abisource.com/mailinglists/abisource-announce/2013/Oct/0000.html">AbiWord 3.0</a> which supports GTK+ 3. Cool.

<span style="text-decoration:underline;">A11y</span>

Some of the <a href="https://wiki.gnome.org/Accessibility">A11y</a> team was present and hacking away. I learned more about how the accessibility tools are used. This is an important technology even if you aren't using them at the moment. With age, and accident, the current A11y technologies might one day be useful to you!

<span style="text-decoration:underline;">Hacking Hearts</span>

<a href="http://blogs.gnome.org/gnomg/">Karen Sandler</a> was kind enough to tell me about her heart condition and the proprietary software inside of her <a href="https://en.wikipedia.org/wiki/Implantable_cardioverter-defibrillator">pacemaker defibrillator</a>. Hopefully hackers can convince manufacturers that <a href="http://www.gnu.org/philosophy/free-sw.html">we need to have access to the source</a>.

<span style="text-decoration:underline;">Yorba and Geary</span>

<a href="http://blog.yorba.org/author/jim">Jim Nelson</a> is a captivating conversationalist, and it was kind of him to tell me about his work on <a href="http://www.yorba.org/projects/geary/">Geary</a> and <a href="https://en.wikipedia.org/wiki/Vala_%28programming_language%29">Vala</a>, and to listen to my ideas about GPG support in email clients. I look forward to seeing Geary's future. I also <a href="https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol#Disadvantages">learned a bit more about IMAP</a>.

<span style="text-decoration:underline;">Future?</span>

I had a great time at the summit, and it was a pleasure to meet and hangout with the GNOME hackers. You're always welcome in Montreal, and I hope you come back soon.

Happy Hacking,

James

