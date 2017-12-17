+++
date = "2013-02-12 01:15:38"
title = "Picking up the pieces after a Fedora 18 install"
draft = "false"
categories = ["technical"]
tags = ["fedora", "fedup", "gnome", "nautilus", "pgo", "fedora18", "nemo", "upgrading"]
author = "jamesjustjames"
+++

I love GNOME and Fedora, but "upgrading" from Fedora 17 to 18 did not go well for me. I recommend you wait until either these are all fixed, or Fedora 19+ suits your needs. Here are a list of problems I had, and some workarounds. Hopefully proper patches to these bugs will get merged quickly, so that you don't need to use these fixes.

<strong><span style="text-decoration:underline;">Problem</span>:</strong> Boot fails after upgrade from Fedora 17 to Fedora 18. I used the new "fedup" method.

<strong><span style="text-decoration:underline;">Workaround</span>:</strong> I did a fresh install. Make sure you have backups first, of course. I didn't feel like spending a lot of time debugging why it broke.

<strong><span style="text-decoration:underline;">Problem</span>:</strong> The <Backspace> key no longer goes "up" in nautilus. I hope this wasn't a "feature removal".

<strong><span style="text-decoration:underline;">Workaround</span>:</strong> Add:
```
(gtk_accel_path "<Actions>/ShellActions/Up" "BackSpace")
```
to your: <em>~/.config/nautilus/accels</em> and restart nautilus of course.

<strong><span style="text-decoration:underline;">Problem</span>:</strong> Split view (extra pane) functionality is missing in nautilus 3.6

<strong><span style="text-decoration:underline;">Workaround</span>:</strong> The GNOME developers plan to eventually replace this in a similar form. Until then, you can install the nemo file manager, which is a fork of nautilus 3.4 and is packaged in Fedora 18. (<em>yum install nemo nemo-open-terminal</em>)

<strong><span style="text-decoration:underline;">Problem</span>:</strong> GNOME Shell background is entirely black in overview mode.

<strong><span style="text-decoration:underline;">Workaround</span>:</strong> Using <em>gnome-tweak-tool</em>, under the "<em>Desktop</em>" section, set "<em>Have file manager handle the desktop</em>", to "<em>OFF</em>". Unfortunately, this disables viewing of files on your desktop. This wasn't a problem in Fedora 17.

<strong><span style="text-decoration:underline;">Problem</span>:</strong> Restarting the X server with the familiar Control-Alt-Backspace, can't be enabled in the keyboard shortcuts menu as it used to.

<strong><span style="text-decoration:underline;">Workaround</span>:</strong> This option is now hidden in the <em>gnome-tweak-tool</em> under <em>typing</em>: <span style="text-decoration:underline;">terminate</span>.

I hope this scratches your itches!

Happy hacking,

James

