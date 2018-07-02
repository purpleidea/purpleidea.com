---
date: 2018-06-22 13:50:00-04:00
title: "Breaking out of the Slack walled garden"
description: "how to use Slack via IRC since the gateway closed..."
categories:
  - "technical"
tags:
  - "devops"
  - "fedora"
  - "golang"
  - "irc"
  - "irssi"
  - "matterircd"
  - "planetdevops"
  - "planetfedora"
  - "slack"

draft: false
---

I'm old school cool. Real hackers chat on open, distributed platforms. Most
technical discussion can be found on the [Freenode](https://freenode.net/) IRC
network. It's not perfect, but the advantages clearly outweigh the drawbacks.

Recently, I needed to join an existing large "community" on the centralized,
proprietary [walled garden](https://en.wikipedia.org/wiki/Closed_platform) that
is the [Slack](https://slack.com/) network.

{{< blog-paragraph-header "The Problem" >}}

Connecting to the the Slack server requires that you use either the proprietary
client or their proprietary web app. There's zero chance I will install the
former on my machine, and the latter uses an absurd amount of browser memory and
CPU. I'm already happy with my [*irssi*](https://irssi.org/) experience, and I
didn't want to need another app.

Initially, Slack offered an IRC bridge as part of its
[embrace, extend, and extinguish](https://en.wikipedia.org/wiki/Embrace,_extend,_and_extinguish)
strategy, but this is now
[closed](https://it.slashdot.org/story/18/03/08/2049255/slack-is-shutting-down-its-irc-gateway).

{{< blog-paragraph-header "The Solution" >}}

Don't use Slack! Move your team to Freenode or run your own private IRC server.
This lets everyone use the client of their choice on the [platform](https://www.gnu.org/)
of their choice.

Luckily there's a workaround if you need to infiltrate an existing Slack
community. ;) Here's how I did it.

{{< blog-paragraph-header "Workaround: Step 1: Token" >}}

Log into Slack via the web browser and get a "legacy token". You can get one
from [this web page](https://api.slack.com/custom-integrations/legacy-tokens).
Apparently an administrator needs to allow this per-user, but since nobdy was
responsive, user [42wim](https://twitter.com/42wim/status/1005200618808586240)
pointed out that you could just sniff for the token being used in the web ui.

I was unable to find it using Firefox, but if you open up the `Chrome Developer
tools`, under the `Network` section, there's a `WS` (web socket) tab which will
show you your token:

{{< blog-image src="slack-token.png" alt="here's what finding your token looks like, they all seem to start with xoxs-" scale="100%" >}}

Do this with care, since I have no idea how to revoke this token if it is lost.
Perhaps changing your password will cause it to change, but I haven't tested it.
Nobody knows how long this token will last, but if things stop working you know
how to go find it again.

{{< blog-paragraph-header "Workaround: Step 2: IRC Server" >}}

Now we need to run a small local IRC server which speaks `Slack` protocol, and
maps this to the standard IRC protocol that your IRC client will understand.
There are three projects I've found that do this.

1. [https://github.com/42wim/matterircd/](https://github.com/42wim/matterircd/)

2. [https://github.com/insomniacslk/irc-slack](https://github.com/insomniacslk/irc-slack)

3. [https://github.com/nolanlum/tanya/](https://github.com/nolanlum/tanya/)

They're all easy to setup and install. I tested that the first two work, but I
felt slightly more happy with the first option. They both happen to use
`golang`, and once a recent version is installed, you can build a copy with:

```bash
go get github.com/42wim/matterircd
```

This produces a build of the latest `git master`, but if you'd prefer a released
version you can look for the [latest tag](https://github.com/42wim/matterircd/releases).
In my case it was `v0.17.3`. You can then:

```bash
git clone --recursive github.com/42wim/matterircd
git checkout v0.17.3
go build
```

I experienced a number of crashes with wim promptly fixed, and I think things
are now pretty stable. I'm currently running a git version:
`a0ab000e02cfaedc136acd1da34afacdb7bf1791`. If you find any issues, wim has been
very responsive in fixing them.

Both of these installation methods should produce a `matterircd` binary. The
former will cause it to appear in your `$GOPATH/bin/`. This is often found at
`~/go/bin/`. The latter will produce it in your `go build` working directory. In
either case, I copied that to the
[server where I run my IRC client](https://purpleidea.com/blog/2013/10/18/desktop-notifications-for-irssi-in-screen-through-ssh-in-gnome-terminal/).
In that `screen` session I then ran it:

```bash
[james@computer ~]$ ./bin/matterircd
INFO[2018-06-19T15:51:04-04:00] Running version 0.18.2-dev                    module=matterircd
INFO[2018-06-19T15:51:04-04:00] WARNING: THIS IS A DEVELOPMENT VERSION. Things may break.  module=matterircd
INFO[2018-06-19T15:51:04-04:00] Listening on 127.0.0.1:6667                   module=matterircd
```

You could probably add a systemd service for this, but I didn't bother.

{{< blog-paragraph-header "Workaround: Step 3: IRC Client" >}}

I use `irssi` but have never had great success getting the internal CLI to work
properly. As a result, I disobeyed the instructions, quit `irssi`, and then
edited the `~/.irssi/config` file. I added the following sections...

In the `chatnets = { ... };` block I added:

```
teamname = {
  type = "IRC";
  nick = "purpleidea";
};
```

In the `servers = ( ... );` block I added:

```
{
  address = "localhost";
  chatnet = "teamname";
  password = "xoxs-your-secret-token-is-here...";
  port = "6667";
  use_ssl = "no";
  ssl_verify = "no";
  autoconnect = "yes";
},
```

In the `channels = ( ... );` block I added:

```
{ name = "#chan1"; chatnet = "teamname"; autojoin = "yes"; },
{ name = "#whatever"; chatnet = "teamname"; autojoin = "yes"; },
```

In the above blocks you'll naturally want to replace `teamname` with the name
you'd like to give to this slack network. You'll also need to replace the
`xoxs-your-secret-token-is-here...` string with the value that you found in part
1.

Now start `irssi`. If all goes well, you should be connected! In the `irssi`
status window you should see:

```
06:50 [teamname] -!- Irssi: Connecting to localhost [127.0.0.1] port 6667
06:50 [teamname] -!- Irssi: Connection to localhost established
06:50 [teamname] -!- Welcome! purpleidea!james@localhost.localdomain
06:50 [teamname] -!- Your host is matterircd, running version 0.17.4-dev
06:50 [teamname] -!- This server was created Mon Jun 11 06:50:56 EDT 2018
06:50 [teamname] -!- matterircd 0.17.4-dev o o debugmode false
06:50 [teamname] -!- There are 3 users and 0 services on 1 servers
06:50 [teamname] -!- - matterircd Message of the Day -
06:50 [teamname] -!- End of /MOTD command.
```

In the `screen` window running `matterircd` you should see:

```
INFO[2018-06-19T15:51:16-04:00] New connection: 127.0.0.1:44958               module=matterircd
```

You can now join more channels and even direct message other users. The complete
list of users should show up in a special `&users` channel. Most things work as
expected.

{{< blog-paragraph-header "Additional Information" >}}

Some IRC clients (apparently Pidgin) convert a window close action into a Slack
channel leave action. If that was an invite-only channel, you might need to be
re-invited in order to re-join.

As I write this article, [wim](https://twitter.com/42wim/status/1006308492897148928)
has added automatic token fetching to matterircd [v0.18.0](https://github.com/42wim/matterircd/releases/tag/v0.18.0).
I haven't tested it, but if you'd rather use your password directly, this looks
like it should do it. You'd probably want to replace the use of the token in the
`password = "xoxs-your-secret-token-is-here...";` line with your actual
password.

{{< blog-paragraph-header "Conclusion" >}}

Hope you enjoyed this. Tell your friends to pick regular IRC instead.

Happy Hacking,

James

{{< twitter-follow-purpleidea >}}
{{< patreon-support-purpleidea >}}
