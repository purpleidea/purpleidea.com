+++
date = "2012-07-05 18:56:40"
title = "gnome3+others glipper/klipper replacement"
draft = "false"
categories = ["technical"]
tags = ["clipboard", "gnome", "gnome3", "gpaste", "pgo", "xsel"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/07/05/gnome3others-glipperklipper-replacement/"
+++

So a friend of mine uses kde4 for its klipper feature. Turns out he's right that it's an awesome feature! I realized I couldn't let gnome3 take second place to a clipboard app, so after a bit of searching...
```
$ sudo yum install gnome-shell-extension-gpaste gpaste xsel
```
Next hit up: <a href="https://extensions.gnome.org/local/">https://extensions.gnome.org/local/</a> to flip on the extension. I had to first type: ALT-F2, "r" (to restart the gnome shell). Don't worry your apps won't die. And then I flipped it on.

Clicking on the new shell icon will let you change your pastes, as well as the gpaste preferences that you use. I like to combine this with xsel, so that I can:
```
$ echo this will be seen in gpaste | xsel
```
...and presto!

Happy hacking!

