---
# get with: `date --rfc-3339=seconds`
date: 2026-10-01 18:05:00-04:00
title: "Faster DNF updates"
description: "I want to saturate my crappy Canadian internet connection"
categories:
  - "technical"
tags:
  - "devops"
  - "dnf"
  - "dnf5"
  - "fedora"
  - "fedora-upgrade"
  - "internet"
  - "linux"
  - "mgmt"
  - "mgmtconfig"
  - "mirror"
  - "planetfedora"
draft: false
---

We've all sat through a very slow `dnf update`. While in a rush to get out the
door, I realized it was going much slower than it should.

{{< blog-paragraph-header "Let's go faster" >}}

It seems the mirrors limit the maximum speed of each single file.

So I added the following under the existing `[main]` section in my
`/etc/dnf/dnf.conf`:

```ini
fastestmirror=True
max_parallel_downloads=16
```

It turns out you can even set this to `20`, but `16` seemed plenty for me. Note
that this is *not* the `max_downloads_per_mirror` option, so I am not hosing any
one particular mirror by doing this.

In my testing, these settings sped things up. Note that `fastestmirror` uses TCP
latency rather than available bandwidth to choose a mirror, so your results may
vary.

{{< blog-paragraph-header "CLI" >}}

You can enable these settings for a one-shot CLI run with:

```bash
dnf update --setopt=fastestmirror=True --setopt=max_parallel_downloads=16
```

{{< blog-paragraph-header "mgmt config" >}}

If you use [mgmt config](https://github.com/purpleidea/mgmt/), then you get this
automatically without even thinking about it. Use our `misc.dnf_update` class to
just update the right way.

We're building a growing compendium of "just works in a polished and tuned way"
configurations, and we'd love to share them with you.

{{< blog-paragraph-header "Tail" >}}

The remaining bottleneck appears when a large download is still running after
all the smaller downloads have finished. Prioritizing the largest files first
could reduce that tail latency. Upstream feature request, anyone?

{{< blog-image src="tail.png" caption="Watch chromium and firefox race." scale="100%" >}}

{{< blog-paragraph-header "Upstream" >}}

If anyone can propose a higher parallel-download default and the scheduling
feature to the right people, I'd appreciate it.

{{< blog-paragraph-header "Upgrade" >}}

I never upgrade my Fedora until about two weeks or so after the N-1 release, and
since `Fedora 45` is just around the corner, it will be soon time to upgrade to
`Fedora 44`. To do so you can use:

```bash
sudo dnf system-upgrade download --setopt=fastestmirror=True --setopt=max_parallel_downloads=16 --releasever=44
```

{{< blog-paragraph-header "Conclusion" >}}

Overall, this reduced my overall download time from a projected three hours to
under ten minutes.

I'm not sure why the parallel-download default isn't higher, but I hope this
makes your day go by faster.

Happy hacking!

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
