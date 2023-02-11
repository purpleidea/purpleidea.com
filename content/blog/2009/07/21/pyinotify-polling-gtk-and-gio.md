+++
date = "2009-07-21 10:19:52"
title = "[py]inotify, polling, gtk and gio"
draft = "false"
categories = ["technical"]
tags = ["dbus", "evanescent", "gio", "gtk", "inotify", "programming"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/07/21/pyinotify-polling-gtk-and-gio/"
+++

i have this software with a gtk mainloop, using dbus and all that fun stuff that seems to play together nicely. i know about the kernel <a href="http://en.wikipedia.org/wiki/Inotify">inotify</a> support, and i wanted it to get integrated with that above stack. i thought i was supposed to do it with <a href="http://trac.dbzteam.org/pyinotify">pyinotify</a> and <a href="http://www.pygtk.org/pygtk2reference/gobject-functions.html#function-gobject--io-add-watch">io_add_watch</a>, but on closer inspection into the pyinotify code it turns out that it seems to actually use <a href="http://trac.dbzteam.org/pyinotify/browser/pyinotify.py">polling</a>! (search for: select.poll)

thinking i was confused, i emailed a friend to see if he could confirm my suspicions. we both weren't 100% sure, a little searching later i was convinced when i found <a href="http://www.tenshu.net/archives/2008/10/24/using-inotify-in-a-pygtk-application-without-pyinotify/">this</a> blog posting. i'm surprised i didn't find out about this sooner. in any case, my application seems to be happy now.

as a random side effect, it seems that when a file is written, i still see the G_FILE_MONITOR_EVENT_ATTRIBUTE_CHANGED *after* the G_FILE_MONITOR_EVENT_CHANGES_DONE_HINT event, which i would have expected to always come last. maybe this is a bug, or maybe this is something magical that $EDITOR is doing- in any case it doesn't affect me, i just wasn't sure if it was a bug or not. to make it harder, different editors save the file in different ways. gedit seems to first delete the file, and then create it again-- or at least from what i see in the gio debug.

the code i'm using to test all this is:

{{< highlight python >}}
#!/usr/bin/python
import gtk
import gio
count = 0
def file_changed(monitor, file, unknown, event):
	global count
	print 'debug: %d' % count
	count = count + 1
	print 'm: %s' % monitor
	print 'f: %s' % file
	print 'u: %s' % unknown
	print 'e: %s' % event
	if event == gio.FILE_MONITOR_EVENT_CHANGES_DONE_HINT:
		print "file finished changing"
	print '#'*79
	print 'n'
myfile = gio.File('/tmp/gio')
monitor = myfile.monitor_file()
monitor.connect("changed", file_changed)
gtk.main()
{{< /highlight >}}

(very similar to the aforementioned blog post)

and if you want to see how i'm using it in the particular app, the latest version of evanescent is now <a href="http://www.cs.mcgill.ca/~james/code/">available</a>. (look inside of evanescent-client.py)

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
