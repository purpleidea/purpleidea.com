+++
date = "2014-10-22 17:22:56"
title = "Testing Evolution's git master and GNOME continuous"
draft = "false"
categories = ["technical"]
tags = ["archive", "continuous", "devops", "email", "evolution", "fedora", "geary", "git", "gmail", "gnome", "gnome continuous", "gpg", "gtkinspector", "guestfs-browser", "libguestfs", "planetdevops", "planetfedora", "planetpuppet", "virt-manager"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/10/22/testing-evolutions-git-master-and-gnome-continuous/"
+++

I've wanted a feature in <a href="https://wiki.gnome.org/Apps/Evolution/">Evolution</a> for a while. It was <a href="https://bugzilla.gnome.org/show_bug.cgi?id=223621">formally requested in 2002</a>, and it just recently <a href="https://git.gnome.org/browse/evolution/commit/?id=f6c0c8226ef8895f15c0221c94869ac5c663694f">got fixed in git master</a>. I only started <a href="https://bugzilla.gnome.org/show_bug.cgi?id=223621#c9">publicly groaning about this missing feature in 2013</a>, and mcrha finally patched it. I tested the feature and found a small bug, <a href="https://git.gnome.org/browse/evolution/commit/?id=ba3c08c7108519658b1d46a49ea3b2a834bc8e79">mcrha patched that too</a>, and I finally re-tested it. Now I'm blogging about this process so that you can get involved too!

<span style="text-decoration:underline;">Why Evolution</span>?
<ul>
	<li>Evolution supports GPG (<a href="https://bugzilla.gnome.org/show_bug.cgi?id=713403">Geary doesn't</a>, Gmail doesn't)</li>
	<li>Evolution has a beautiful composer (Gmail's sucks, just try to reply inline)</li>
	<li>Evolution is <a href="https://www.gnu.org/philosophy/free-sw.html">Open Source</a> and <a href="https://www.gnu.org/philosophy/why-free.html">Free Software</a> (Gmail is proprietary)</li>
	<li>Evolution integrates with GNOME (Gmail doesn't)</li>
	<li>Evolution has lots of fancy, mature features (Geary doesn't)</li>
	<li>Evolution cares about your privacy (<a href="https://en.wikipedia.org/wiki/Gmail#Criticism">Gmail doesn't</a>)</li>
</ul>
<span style="text-decoration:underline;">The feature</span>:

I'd like to be able to select a bunch of messages and click an archive action to move them to a specific folder. <a href="https://en.wikipedia.org/wiki/Gmail">Gmail popularized this idea in 2004</a>, two years after it was proposed for Evolution. It has finally landed.

In your account editor, you can select the "<em>Archive Folder</em>" that you want messages moved to:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="evolution-account-archive-folder.png"><img class="alignnone size-large wp-image-941" src="evolution-account-archive-folder.png" alt="evolution-account-archive-folder" width="100%" height="100%" /></a></td></tr></table></br />

This will let you have a different folder set per account.

<span style="text-decoration:underline;">Archive like Gmail does</span>:

If you use Evolution with a Gmail account, and you want the same functionality as the Gmail archive button, you can accomplish this by setting the Evolution archive folder to point to the Gmail "<em>All Mail</em>" folder, which will cause the Evolution archive action to behave as Gmail's does.

To use this functionality (with or without Gmail), simply select the messages you want to move, and click the "<em>Archive...</em>" button:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="evolution-context-menu-archive.png"><img class="alignnone wp-image-944 size-full" src="evolution-context-menu-archive.png" alt="evolution-context-menu-archive" width="100%" height="100%" /></a></td></tr></table></br />

This is also available via the "<em>Message</em>" menu. You can also activate with the <strong>Control-Alt-a</strong> shortcut. For more information, please <a href="https://bugzilla.gnome.org/show_bug.cgi?id=223621#c11">read the description from mcrha</a>.

<span style="text-decoration:underline;">GNOME Continuous</span>:

Once the feature was patched in git master, I wanted to try it out right away! The easiest way for me to do this, was to use the <a href="https://wiki.gnome.org/Projects/GnomeContinuous">GNOME Continuous</a> project that <a href="http://blog.verbum.org/">walters</a> started. This GNOME project automatically kicks off integration builds of multiple git master trees for the most common GNOME applications.

If you <a href="https://wiki.gnome.org/Projects/GnomeContinuous">follow the Gnome Continuous instructions</a>, it is fairly easy to download an image, and then import it with virt-manager or boxes. Once it had booted up, I logged into the machine, and was able to test Evolution's git master.

<span style="text-decoration:underline;">Digging deep into the app</span>:

If you want to tweak the app for debugging purposes, it is quite easy to do this with <a href="https://blogs.gnome.org/mclasen/2014/05/15/introducing-gtkinspector/">GTKInspector</a>. Launch it with <strong>Control-Shift-i</strong> or <strong>Control-Shift-d</strong>, and you'll soon be poking around the app's internals. You can change the properties you want in real-time, and then you'll know which corresponding changes in the upstream source are necessary.

<span style="text-decoration:underline;">Finding a bug and re-testing</span>:

I did find one small bug with the Evolution patches. I'm glad I found it now, instead of having to wait six months for a new Fedora version. The maintainer fixed it quickly, and all that was left to do was to re-test the new git master. To do this, I updated my GNOME Continuous image.
<ol>
	<li>Click on <strong>Control-Alt-F2</strong> from the virt-manager "Send Key" menu.</li>
	<li>Log in as root (no password)</li>
	<li>Set the password to something by running the <code>passwd</code> command.</li>
	<li>Click on Control-Alt-F1 to return to your GNOME session.</li>
	<li>Open a terminal and run: <code>pkexec bash</code>.</li>
	<li>Enter your root password.</li>
	<li>Run <code>ostree admin upgrade</code>.</li>
	<li>Once it has finished downloading the updates, reboot the vm.</li>
</ol>
You'll now be able to test the newest git master. Please note that it takes a bit of time for it to build, so it is not instant, but it's pretty quick.

<span style="text-decoration:underline;">Taking screenshots</span>:

I took a few screenshots from inside the VM to show to you in this blog post. Extracting them was a bit trickier because I couldn't get SSHD running. To do so, I installed the <a href="http://people.redhat.com/~rjones/guestfs-browser/">guestfs browser</a> on my host OS. It was very straight forward to use it to read the VM image, browse to the <em>~/Pictures/</em> directory, and then download the images to my host. Thanks <a href="https://rwmj.wordpress.com/">rwmjones</a>!

<span style="text-decoration:underline;">Conclusion</span>:

Hopefully this will motivate you to contribute to GNOME early and often! There are lots of great tools available, and lots of applications that need <a href="https://wiki.gnome.org/GnomeLove">some love</a>.

Happy Hacking,

James

