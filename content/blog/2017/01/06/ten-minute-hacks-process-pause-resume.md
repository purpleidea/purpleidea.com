+++
date = "2017-01-06 05:57:08"
title = "Ten minute hacks: Process pause & resume"
draft = "false"
categories = ["technical"]
tags = ["FOSDEM", "bash", "cfgmgmtcamp", "continue", "devconf.cz", "devops", "fedora", "hack", "hacks", "pause", "planetdevops", "planetfedora", "planetpuppet", "puppet", "resume", "signals", "ten minute hacks"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2017/01/06/ten-minute-hacks-process-pause-resume/"
+++

I'm old school and still rocking an old X220 laptop <a href="/blog/2014/02/02/scathing-review-of-the-lenovo-x240/">because I didn't like the new ones</a>. My battery life isn't as great as I'd like it to be, but it gets worse when some "webapp" (which I'd much rather have as a native <a href="https://en.wikipedia.org/wiki/GTK%2B">GTK+</a> app) causes Firefox to rev my CPU with their websocket (hi gmail!) poller.

This seems to happen most often on planes or when I'm disconnected from the internet. Since it's difficult to know which tab is the offending one, and since I might want to keep that tabs state anyway, I decided to write a little shell script to pause and resume misbehaving processes.

After putting it into my <code>~/bin/</code> and running <code>chmod u+x ~/bin/pause-continue.sh</code> on it, you can now:

```
james@computer:~$ pause-continue.sh firefox
Stopping 'firefox'...
[press any key to continue]
Continuing 'firefox'...
james@computer:~$ echo $?
0
james@computer:~$
```
<a href="/blog/2014/01/29/show-the-exit-status-in-your-ps1/">Error codes work iirc.</a>

The code is trivially simple, with an added curses hack to make this <em>13%</em> more fun. It sends a <code>SIGSTOP</code> signal initially, and then when you press a key it resumes it with <code>SIGCONT</code>. <a href="https://gist.github.com/purpleidea/79e18e66f42ff34d96d4a1fe835124d1">Here it is the code.</a>

You should obviously substitute in the name of the process that you'd like to pause and resume. If your process breaks because it didn't deal well with the signals, then you get to keep both pieces!

This should help me on my upcoming travel! I'll be presenting some of my <a href="/tags/mgmtconfig/">mgmtconfig</a> work at <a href="https://devconf.cz/schedule.html">DevConf.cz</a>, <a href="https://fosdem.org/2017/schedule/event/mgmt/">FOSDEM</a> and <a href="http://cfgmgmtcamp.eu/schedule/index.html#future">CfgMgmtCamp.eu</a>! CfgMgmtCamp will also have a <a href="http://cfgmgmtcamp.eu/schedule/index.html#mgmt">short mgmt track</a> (looking forward to seeing <a href="https://twitter.com/felis_rex">Felix</a> present!) and we'll be around to <a href="http://cfgmgmtcamp.eu/fringe.html#mgmt">hack on the 8th during fringe</a> (the day after the official camp) if you'd like help to get your patch merged! I'm looking forward to it!

Happy hacking!

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
