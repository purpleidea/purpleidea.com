+++
date = "2013-08-04 05:02:18"
title = "Upgrading from Fedora 18 to Fedora 19"
draft = "false"
categories = ["technical"]
tags = ["evolution", "fedora", "fedora 19", "fedup", "gedit", "gnome", "gnome shell", "pgo", "planetfedora", "upgrade fedora", "upgrading", "yum"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/08/04/upgrading-from-fedora-18-to-fedora-19/"
+++

It was time to take the plunge and upgrade from Fedora 18 to Fedora 19. <a title="Picking up the pieces after a Fedora 18 install" href="/blog/2013/02/12/picking-up-the-pieces-after-a-fedora-18-install/">Fedora 18 was one of the worst releases ever</a>, so I figured it could only get better. I ran my backups as usual, however this time I didn't seem to need them, the upgrade process went off without a hitch! <a href="https://fedoraproject.org/wiki/FedUp">I used the fedup-cli process over the network.</a> I always run these things inside of screen.

Here are my post install notes and comments:

<strong><span style="text-decoration:underline;">Brown folder icons</span>:</strong>

Someone broke the icon theme, and folders are now an ugly brown. Even though you'll see a "Fedora" entry in the GNOME tweak tool, icon theme section, it won't work. You need to install a theme package first:
```
# yum install fedora-icon-theme
```
tweak tool will now let you fix the brown icon issue.

<strong><span style="text-decoration:underline;">Dash doesn't launch new windows</span>:</strong>

The GNOME shell is back to its old habit of trying to imitate Mac OSX. Thankfully there's an official extension to fix this: <a href="https://extensions.gnome.org/extension/600/launch-new-instance/">https://extensions.gnome.org/extension/600/launch-new-instance/</a>

If you search for "<em>Classic Mode</em>" on <a href="https://extensions.gnome.org/">https://extensions.gnome.org/</a> you'll find some other useful add ons. You might enjoy: <a href="https://extensions.gnome.org/extension/15/alternatetab/">AlternateTab</a>, <a href="https://extensions.gnome.org/extension/586/avoid-overview/">AvoidOverview</a>, and <a href="https://extensions.gnome.org/extension/120/system-monitor/">SystemMonitor</a>.

<strong><span style="text-decoration:underline;">Evolution is snappier</span>:</strong>

Congratulations to the evolution developers, this release seems a bit snappier! I haven't tested it thoroughly, however closing evolution now happens in under ten seconds! Usually it would either hang or take much longer to close. Keep up the good work!

<strong><span style="text-decoration:underline;">Clocks deletes your old clocks</span>:</strong>

The clocks application deleted all the clocks that I had added. I suppose there are worse forms of data loss, but this is still pretty unprofessional! I had added one for every new place I had visited. Goodbye memories!

<strong><span style="text-decoration:underline;">YUM breaks pexpect scripts</span>:</strong>

A new version of YUM, now prompts you differently:
```
# yum install foobar[...]
Is this ok [y/d/N]:
```
No it's not okay that you're confusing my brain by adding a <strong>d</strong>. I actually don't have any pexpect scripts depending on this, but after years of seeing <em>y/N</em>, the change is not welcomed. It should have been handled with a YUM <em>download</em> target instead.

<strong><span style="text-decoration:underline;">Password prompts are annoying</span>:</strong>

The GNOME shell handles most of the password prompts. This makes sense because it can help prevent you typing your password into a chat room. The problem is that if you need to run an external password manager to find a password, you're out of luck. Maybe someone can add an option to minimize the focus stealing window. In addition, the "remember password" checkbox should NOT be on by default! It still is for evolution, and perhaps other apps too.

<strong><span style="text-decoration:underline;">GNOME shell isn't smooth, but it's better</span>:</strong>

Fedora 17 provided a smooth GNOME shell experience. Fedora 18, somehow killed the performance, and no fixes could be found. The performance seems to be a bit better in Fedora 19, but it's still not perfect. Drivers are probably partly to blame.

New version of Gedit breaks some things:

The Gedit dashboard plugin no longer seems to work. After debugging the issue, it seems to be a packaging problem. To fix:
```
# yum install python3-dbus
```
and dashboard should work when enabled. The gedit-autotab plugin is thoroughly broken. I'd love to get that working again for <a href="https://github.com/purpleidea/gedit-plugins/tree/smarterspaces">smarter spaces</a>!

<strong><span style="text-decoration:underline;">EDIT: Here are some notes on my former `smarter-spaces` work</span></strong>:
<table><tr><td>
Today, I am a gedit-plugins hacker! Here you'll find my first code contribution to gedit-plugins. I'm calling it "SmarterSpaces". This is an extension to the excellent "<a href="https://live.gnome.org/GeditPlugins">SmartSpaces</a>" plugin.

This plugin automatically treats the usage of spaces for indentation as if they were tabs. Now even though someone chose the wrong character for indentation, you don't have to waste time mashing your cursor keys to move through all those <em>0x20h</em>'s. Alternatively, you could use <a href="http://en.wikipedia.org/wiki/Vim_%28text_editor%29">vim</a>. :)

To install this plugin you need to put: <em>smarterspaces.py</em>, <em>smarterspaces.plugin</em> and <em>org.gnome.gedit.plugins.smarterspaces.gschema.xml</em> in your <em>~/.local/share/gedit/plugins</em> directory. The code is <a href="http://www.gnu.org/licenses/gpl.html">GPLv.3+</a>, so share and enjoy under these terms.

It is recommended that you use this plugin in combination with the <em>autotab</em> and/or <em>modelines</em> plugins.

I have tested this code, and it works perfectly for me. Please have a look at the source comments, for a few unresolved items.

For more information, you can read my <a href="https://mail.gnome.org/archives/gedit-list/2013-February/msg00000.html">original mailing list announcement</a> and the <a href="https://bugzilla.gnome.org/show_bug.cgi?id=693283">bugzilla entry</a>.

It would be awesome if someone could point me to, or hack together something similar in vim. Maybe purists don't need this kind of functionality, but dammit, sometimes I use my arrow keys while in insert mode.
</td></tr></table>

That's all for now,

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
