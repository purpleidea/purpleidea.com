---
# get with: `date --rfc-3339=seconds`
date: 2025-05-14 19:45:00-04:00
title: "Running etcd over SSH"
description: "Using authorized_keys options to securely tunnel"
categories:
  - "technical"
tags:
  - "authorized_keys"
  - "etcd"
  - "localhost"
  - "mgmt"
  - "mgmtconfig"
  - "planetfedora"
  - "ssh"

draft: false
---

Want to tunnel etcd traffic over SSH? Here's a pitfall I ran into.

{{< blog-paragraph-header "The problem" >}}

[Mgmt](https://mgmtconfig.com/) supports tunnelling the `etcd` traffic over SSH.
This is quite useful, because it means that for it to connect to etcd, it
doesn't need to open up any new ports other than `22`.

You can run the agent like so:

```bash
mgmt run --ssh-url=etcd@etcdserver:22 --seeds=http://127.0.0.1:2379 --no-server --no-magic empty
```

and it just works!

{{< blog-paragraph-header "Lockdown" >}}

It's no fun giving out more access than is really necessary, so I added this
line to the `etcd` user account in their `~/.ssh/authorized_keys` file:

```
command="echo 'Port forwarding only'; exit",no-agent-forwarding,no-pty,no-user-rc,no-X11-forwarding,permitopen="localhost:2379" ssh-...
```

Note the actual key being used is ellipsized for brevity and customer privacy.

Things should be working, but they weren't.

{{< blog-paragraph-header "Golang" >}}

I initially suspect something amiss with the `golang` bindings. Perhaps they
didn't support the "only-port-forwarding" mode? While debugging the code, it
would fail at this line when opening the internal tunnel:

```golang
import "golang.org/x/crypto/ssh"

sshConfig := &ssh.ClientConfig{
	User: "etcd",
	// ...
}
sshClient, err := ssh.Dial("tcp", "etcdserver:22", sshConfig)
// ...
tunnel, err := sshClient.Dial("tcp", "127.0.0.1:2379")
// ssh: rejected: administratively prohibited (open failed)
```

What's going on? What does that error even mean.

{{< blog-paragraph-header "Debugging" >}}

I tried the venerable `ssh` utility and things worked fine:

```
ssh -N etcd@etcdserver -p 22 -L 2379:localhost:2379 -v
```

{{< alert type="blue" >}}
Try and spot the issue yourself before continuing on... In case your curious,
the LLM's couldn't figure this out either.
{{< /alert >}}

{{< blog-paragraph-header "The answer" >}}

Give up? Amazingly, `ssh` treats `localhost` and `127.0.0.1` differently. This
means you must be consistent everywhere, or you'll get this error. Since
`localhost` could resolve differently in certain rare situations, I've changed
everything to use `127.0.0.1` and now things work as expected.

{{< blog-paragraph-header "Fixed" >}}

My updated `authorized_keys` now looks like:

```
command="echo 'Port forwarding only'; exit",no-agent-forwarding,no-pty,no-user-rc,no-X11-forwarding,permitopen="127.0.0.1:2379" ssh-...
```

{{< blog-paragraph-header "Conclusion" >}}

If you like hacking on this part of the stack, get involved with [mgmt](https://github.com/purpleidea/mgmt/)
and you'll have a lot of fun!

[Enterprise support, training, and consulting are all available.](https://m9rx.com/)

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
