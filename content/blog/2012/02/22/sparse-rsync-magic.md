+++
date = "2012-02-22 18:50:51"
title = "sparse rsync magic"
draft = "false"
categories = ["technical"]
tags = ["devops", "rsync", "sparse"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/02/22/sparse-rsync-magic/"
+++

Dear internets,

Once upon a time, I had one of those "brain teaser-of-the-day" calendars. Free business tip: someone should make an 'rsync' version. That would be brilliant. (If you don't know what rsync is, then you should probably go read a different blog.)

Anyone who's used kvm might know, linux virtual machines can have sparse .raw file backing stores. This means the operating system could think it has one TiB of space, when it is actually sharing a one TiB physical harddrive with many others.

<strong>Tip #1: man ls</strong>
```
# ls -lAhs
29G -rwxr-xr-x. 1 qemu qemu 1000G Feb 22 18:39 cobbler.raw
```

You'll notice that the 's' flag shows you how much space the file is actually taking up on your harddrive. This gives me lots of room to grow my cobbler virtual machine, without having to actually resize partitions, lv's or filesystems.

Warning: Make sure to monitor your individual virtual machines, because if the .raw files grow bigger than the size of your host filesystem then they'll freeze.

<strong>Tip #2: use rsync like a boss</strong>
This all started out about rsync, remember ? As anyone who's tried might know, running an rsync on your images/ directory as the source will cause your destination to swell to the size of the virtual hard drives! Solution? add in -S and enjoy the rsync magic.

Happy hacking!

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
