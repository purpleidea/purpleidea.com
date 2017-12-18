+++
date = "2009-07-13 10:05:05"
title = "logging out of $SESSION"
draft = "false"
categories = ["technical"]
tags = ["evanescent", "programming"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/07/13/logging-out-of-session/"
+++

the <a href="http://www.cs.mcgill.ca/~james/code/">software</a> (evanescent) that i'm working on is supposed to log out the user from its current X session. originally i had some yucky looking code that ran a kill on gnome-session, which quickly got replaced with:
```
os.system('gnome-session-save --logout-dialog')
```
i've decided this was still a little crufty, so i've recently replaced this with:
```
bus = dbus.SessionBus()
remote_object = bus.get_object('org.gnome.SessionManager', '/org/gnome/SessionManager')
# specify the dbus_interface in each call
remote_object.Logout(0, dbus_interface='org.gnome.SessionManager')
# or create an Interface wrapper for the remote object
#iface = dbus.Interface(remote_object, 'org.gnome.SessionManager')
#iface.Logout(0)
# introspection is automatically supported
#print remote_object.Introspect(dbus_interface='org.freedesktop.DBus.Introspectable')
```
<a href="http://www.gnome.org/~mccann/gnome-session/docs/gnome-session.html#org.gnome.SessionManager.Logout">documentation</a> can be found, although it took a little digging. the only catch is that this is gnome specific, and you need different code for kde, and each other DE. thanks to <a href="http://www.purinchu.net/wp/2009/06/12/oh-fun/">http://www.purinchu.net/wp/2009/06/12/oh-fun/</a> for the kde version of the above.

help! please contribute information on making this work on other platforms, and/or how to detect which platform is running. at the moment my ugly solution is:
```
if os.name == 'nt': return 'windows'
elif os.getenv('KDE_FULL_SESSION') == 'true': return 'kde'
elif os.getenv('GNOME_DESKTOP_SESSION_ID') != '': return 'gnome'
else: return ''
```
hth

ps: i'm unable to indent code in wordpress (i'm sure it's my fault somehow) so the above code was trimmed to give you the right idea, without being complete. leave a message if you want some source files.

