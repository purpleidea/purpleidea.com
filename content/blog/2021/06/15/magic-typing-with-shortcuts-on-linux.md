---
# get with: `date --rfc-3339=seconds`
date: 2021-06-16 00:40:00-04:00
title: "Magic typing with shortcuts on Linux"
description: "How to workaround bad software by automating your typing."
categories:
  - "technical"
tags:
  - "gnu"
  - "linux"
  - "planetfedora"
  - "wayland"
  - "X"
  - "xdotool"
  - "ydotool"

draft: false
---

Ever find yourself typing more characters than is necessary when using some
annoying application or website? Here's a quick hack around that.

{{< blog-paragraph-header "Intro" >}}

There's a magic program called `xdotool` written by [Jordan Sissel](https://twitter.com/jordansissel/)
that solves this problem. I've known about his excellent work for years, but
only today did I learn he also wrote `xdotool`. It's named as such because it
tells the `X` server to do something for you.

{{< blog-paragraph-header "Make it type" >}}

You might want to look at `man xdotool` to learn all that it's capable of, but
for now, open a terminal and try running:

```bash
xdotool type 'echo james is awesome' ; xdotool key Return`
```

This should type that command out and also simulate an enter press for you.

{{< blog-paragraph-header "Shortcuts" >}}

I needed to use a piece of legacy wiki software to write up some docs. I
commonly add `code blocks like this` into the body, and with modern tools it's
as simple as typing a [backtick](https://en.wikipedia.org/wiki/Grave_accent).
With this software, you need to enclose your text within `{{code}}` and
`{{/code}}` blocks. (No I have no idea why the designer thought this was a good
idea.) These are annoying to constantly type so I decided to wrap it with a
keyboard shortcut.

Open up GNOME's _Keyboard Shortcuts_ dialog and add a new entry at the bottom.

{{< blog-image src="gnome-keyboard-shortcuts.png" caption="This is what the GNOME keyboard shortcuts dialog looks like." scale="100%" >}}

I chose a shortcut like `Control-Alt-O`. To test, I then opened up a text editor
and typed the shortcut to run it... And gnome-calculator opened. Hmmm, what's
happening?

{{< blog-paragraph-header "Modifiers" >}}

As it turns out, it's as if someone was typing those characters, but you'll
remember that you're still holding the `Control` and `Alt` keys... So as
`xdotool` types the `C` in `{{code}}` it's as if someone pressed
`Control-Alt-C` which in my case opens the calculator! Thankfully, there's an
easy solution to this. Add the `--clearmodifiers` flag and this problem goes
away. Your command should now look like:

```bash
xdotool type --clearmodifiers '{{code}}{{/code}}'
```

{{< blog-paragraph-header "Wayland" >}}

Of course, if you can, you should try and switch to using `wayland` instead of
`X`. I'm still using `X` because of regressions in some GNOME/GTK apps.
Thankfully, there's a `ydotool` that seems to do the same kind of thing for
wayland. There are **rpm** packages available for both tools on Fedora.
Unfortunately, the `ydotool` doesn't seem to support the `--clearmodifiers`
flag, so if you want to simulate that, I recommend using this form instead:

```bash
bash -c 'sleep 0.5s && ydotool type "{{code}}{{/code}}"'
```

This will give you a moment to type the shortcut and release the modifier keys
before the actual magic typing occurs. Feel free to customize the delay to your
suiting.

{{< blog-paragraph-header "Passwords" >}}

You should definitely not use this to type your passwords. You should also
definitely not use this to type your `yubikey` prefixes. But if you were to, it
might look something like this:

```bash
bash -c 'sleep 0.5s && xdotool type --clearmodifiers hunter2 && xdotool key --clearmodifiers Return'
```

if `hunter2` was your password. For `yubikey` pin prefixes (this is where you
start by typing a prefix of characters, and then press your `yubikey` to enter
the remaining "half") you might want something like:

```bash
bash -c 'sleep 0.5s && xdotool type --clearmodifiers 12345 && mpv /usr/share/sounds/gnome/default/alerts/sonar.ogg'
```

to give you a short audible notification when it's time for you to press the
physical button.

{{< blog-image src="spaceballs-12345.png" scale="100%" >}}

{{< blog-image src="spaceballs-luggage.png" caption="It's probably safe since none of us have used our luggage in a long time." scale="100%" >}}

This is not the least safe approach to things since this doesn't work through
the GNOME screen locker, so as long as you keep your screen locked, it's not too
terrible.

{{< blog-paragraph-header "Future" >}}

Of course it would be really marvellous if someone spent some time innovating in
the local password manager space. Imagine that this was integrated into
`gnome-keyring` and GTK. (Kind of like how the emoji hooks work-- press ^. to
see the pop-up, that's `<control>` and the period character. Imagine getting a
dialog there to choose a password, and options to press enter or notify with a
bell sound after it typed it for you.)

{{< blog-paragraph-header "Conclusion" >}}

I hope this was useful to you! I hope it made you think about hacks that can
make your daily work go by easier. That's the power of GNU and Linux.

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
