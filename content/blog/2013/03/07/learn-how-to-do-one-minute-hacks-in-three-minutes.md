+++
date = "2013-03-07 18:38:45"
title = "learn how to do one minute hacks, in three minutes"
draft = "false"
categories = ["technical"]
tags = ["1 minute hack", "dconf", "gedit", "gnome", "gsettings", "hack", "pgo", "recent-files"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/03/07/learn-how-to-do-one-minute-hacks-in-three-minutes/"
+++

I write this technical blog for you to enjoy, and to help me remember. So where do I get all this knowledge? I figure it out! Here's how I learned to fix a small gedit annoyance in one minute, and within the next three, you'll be able to do the same for other types of problems too. Ready? Set? Go!

I use gedit enough, that when I hack, I often end up using up more than the five allotted spaces in the "recent files" sections. I wanted to see eight. Since I knew it would have been silly for the developers to hard code the number five, I decided there was a chance that they stored it in the <a href="https://live.gnome.org/dconf">dconf</a> settings. (BTW, there's also an amazing "<a href="http://seilo.geekyogre.com/2011/12/gedit-plugins-now-has-the-dashboard/">Dashboard</a>" plugin which I use for more complex recent-files searching...)

Enter <a href="https://developer.gnome.org/dconf/unstable/dconf-editor.html"><em>dconf-editor</em></a>. Run this, and start browsing through the hierarchy. You'll notice that the <em>org.gnome.*</em> hierarchy has a lot going on. Look around, and you'll find a "<em>gedit</em>" section. Once there, you'll probably recognize some of the key names, as preferences you've seen. I searched for the number 5 and I found it next to a 'max-recents' key.

You can edit this with the editor, or for your convenience, just run:
```
gsettings set org.gnome.gedit.preferences.ui max-recents 8
```
the corresponding 'read' command is:
```
gsettings get org.gnome.gedit.preferences.ui max-recents
```
of course. The interesting thing about these settings, is that if coded properly, their actions are "live". Which means, you can toggle them on and off, and in most cases, you'll see the results immediately. Similarly, if you toggle a particular setting in gedit, you should see the changes instantly in dconf-editor.

Have fun playing with this and,

Happy hacking,

James

