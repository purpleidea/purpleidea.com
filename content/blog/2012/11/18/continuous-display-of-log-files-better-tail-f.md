+++
date = "2012-11-18 01:02:22"
title = "continuous display of log files (better tail -f)"
draft = "false"
categories = ["technical"]
tags = ["devops", "file descriptor", "gluster", "tail -f"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/11/18/continuous-display-of-log-files-better-tail-f/"
+++

All good sysadmins know about using <em>tail -f</em> to <em>follow</em> a log file. I use this all the time to follow <em>/var/log/messages</em> and my gluster logs in particular. Maybe everyone already knows this, but it deserves a PSA: after a certain amount of time (~days) it seems that new messages don't appear!

What happens by default is that <em>tail -f</em> follows the file <span style="text-decoration:underline;">descriptor</span>, not the file <span style="text-decoration:underline;">name</span>, so when your log files get rotated, the file descriptor still points to the (now renamed) file which no longer gets updates any more.

The solution is to get tail to follow the file <span style="text-decoration:underline;">name</span> you're interested in:
```
tail --follow=name /var/log/messages
```
<strong>EDIT:</strong> Fortunately there is a shorter way of running this too, you can use:
```
tail -F
```
on any up to date version of tail to get the same result. This adds in <em>--retry</em> to the <em>--folllow=name</em> argument.

Happy hacking!

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
