+++
date = "2012-06-04 22:31:41"
title = "fedora 14 to 17 upgrade"
draft = "false"
categories = ["technical"]
tags = ["pgo", "upgrade", "fedora", "planetfedora"]
author = "jamesjustjames"
+++

I've been reluctantly dreading the switch to gnome 3 + shell until it's been ironed out a little bit more than gnome 3.0 - finally took the plunge. overall it's working well. here are some (hopefully) useful notes:
<ul>
	<li>preupgrade 14-&gt;17 in one step doesn't work. it lets you wait an hour for all the downloads to finish, but once you've rebooted, the preupgrade installer tells you it can't jump this far. fail. reboot into f14, yum clean all, rm -rf /var/cache/yum/preupgrade/* ? and preupgrade to f15. boot into that, and then jumping directly to f17 works great.</li>
	<li>remove default f17 ugly fireworks background. the gnome3 default is pretty.</li>
	<li>gnome-tweak-tool is essential. try all the options until you figure out which ones you want. listing my personal preferences here is far too boring for the internet.</li>
	<li>dash click fix extension was essential for me. also: https://extensions.gnome.org/review/download/1323.shell-extension.zip which does the same thing, but for application launcher entries. this allows gnome-shell to behave properly and launch applications where i want them.</li>
	<li>i also added: "Remove user name" and "Remove a11y" extensions.</li>
	<li>"system-monitor", is close to what i want, but is not good enough yet. disks access/writes don't show, and it's got a super ugly popup window. old gnome-system-monitor applet was PERFECT. Please bring it back or fix this one.</li>
	<li>choose non-ugly background for gdm: # sudo -u gdm dbus-launch gnome-control-center</li>
</ul>
Hope this helped! Happy hacking,

James

