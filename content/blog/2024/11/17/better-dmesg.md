---
# get with: `date --rfc-3339=seconds`
date: 2024-11-17 15:52:00-05:00
title: "Better dmesg in five minutes"
description: "How to handle dmesg on a modern computer"
categories:
  - "technical"
tags:
  - "bash"
  - "dmesg"
  - "linux"
  - "planetfedora"
  - "sysctl"

draft: false
---

I last wrote about `dmesg` in [2016](/blog/2016/08/29/live-dmesg-following/). It
has mostly not changed since then, but I've changed my setup slightly. Here's a
short article about what I did so that you can do it too, and so that I can
remember for the next time.

{{< blog-paragraph-header "Previously" >}}

Previous I had a bash alias which looked like this:

```
alias dmesg='dmesg --follow || dmesg'
```

since some machines didn't yet support the `--follow` flag.

{{< blog-paragraph-header "Currently" >}}

Current machines disable reading `dmesg` if you're not root. This is for
security. There's a sysctl flag you can tweak to bypass this for single user
machines where you're not worried about this risk.

```bash
cat /proc/sys/kernel/dmesg_restrict
```

If it's `1`, then you need to be root. `0` means non-root users can use dmesg.

{{< blog-image src="meme.png" caption="Trying to make this article more eye catching and fun!" scale="100%" >}}

{{< blog-paragraph-header "Better dmesg" >}}

Let's fix this permanently so I don't need to keep finding this workaround. I've
now got `~/bin/dmesg` setup as:

```bash
#!/bin/bash

if [ $(cat /proc/sys/kernel/dmesg_restrict) = "1" ]; then
	echo 'dmesg is currently restricted, enter password to enable for user'
	sudo bash -c 'echo 0 > /proc/sys/kernel/dmesg_restrict'
	sudo bash -c 'echo "kernel.dmesg_restrict = 0" > /etc/sysctl.d/10-dmesg.conf'
fi

/usr/bin/dmesg --human --follow "$@"
```

This checks and adds the needed permissions if they're not already set, and it
also runs `dmesg` with my two favourite flags: `--follow` and `--human`.

The manual page will help you with anything else you need.

{{< blog-paragraph-header "Conclusion" >}}

As with last time, try out this snippet!

```bash
$ sudo bash -c 'echo The Technical Blog of James is awesome! > /dev/kmsg'
```

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
