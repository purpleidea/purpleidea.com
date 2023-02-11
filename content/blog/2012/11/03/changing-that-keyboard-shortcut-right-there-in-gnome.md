+++
date = "2012-11-03 03:12:39"
title = "changing *that* keyboard shortcut right there (in gnome)"
draft = "false"
categories = ["technical"]
tags = ["dconf/gsettings", "gnome", "gtk", "keyboard shortcuts", "magic", "pgo", "shortcuts"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/11/03/changing-that-keyboard-shortcut-right-there-in-gnome/"
+++

I love my keyboard shortcuts, and I sometimes I want to change them. If you're ever in a gnome application and wanted to change *that one right there*, you can now live-edit them!

In a terminal, first enable this feature:
```
gsettings set org.gnome.desktop.interface can-change-accels true
```
Next, hover over the menu item shortcut that you want to change. Enter the shortcut you want. It should update immediately! I like to disable this live-editing, so that I don't accidentally change any shortcuts. To do so run:
```
gsettings set org.gnome.desktop.interface can-change-accels false
```
Too bad firefox doesn't support this. This is one more reason why native GTK apps make your entire experience blend together (consistent) and more magic!

Happy hacking!

James

PS: If you're curious, I used this to change the gnome-terminal and gedit cycle tab left/right actions to instead respond to the thinkpad back/forward keys which are conveniently located right above the left and right arrow keys respectively.

Source: <a href="http://library.gnome.org/users/evolution/3.3/change-keyboard-shortcuts.html.en">http://library.gnome.org/users/evolution/3.3/change-keyboard-shortcuts.html.en</a>

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
