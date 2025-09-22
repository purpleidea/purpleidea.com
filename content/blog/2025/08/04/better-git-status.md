---
# get with: `date --rfc-3339=seconds`
date: 2025-08-04 21:10:30-04:00
title: "Better git status"
description: "Avoid needing to scroll git status"
categories:
  - "technical"
tags:
  - "columns"
  - "git"
  - "git status"
  - "planetfedora"
  - "tput"

draft: false
---

I've been using `git status` for quite a long time now. Let's make it better.

{{< blog-paragraph-header "My old aliases" >}}

My `~/.gitconfig` has had:

```
[alias]
	s = status
	d = diff
	l = log --show-signature
```

for as long as I can remember. They've served me well.

{{< blog-paragraph-header "The problem" >}}

In one of my [projects](https://github.com/purpleidea/mgmt/), I occasionally
have a bunch of untracked files, particularly when I'm hacking on something new
that isn't committed yet. This may include notes, new tests, and so on. My
terminal is usually between `24` and `37` lines tall. (Eg: run `tput lines`.) If
there's a lot of untracked stuff here, I'll quickly go over this limit and have
to scroll to see what's staged and so on.

{{< blog-paragraph-header "Columns" >}}

Git can display the status in columns like `ls` does. I use
`git status --column=nodense`. I don't like to see column mode when I don't have
to. Git doesn't support doing that magic so I built it.

{{< blog-paragraph-header "Magic git status" >}}

Add the following to your `~/.gitconfig`:

```
[alias]
        #s = status # goodbye old friend
        s = "!f() { rows=$(tput lines); lines=$(git status | wc -l); if [ \"$lines\" -gt \"$rows\" ]; then git status --column=nodense; else git status; fi; }; f"
```

Now whenever you run `git s`, you'll only see the columns when it won't fit.

{{< blog-paragraph-header "Conclusion" >}}

Save seconds of keystrokes, and the hours will take care of themselves.

[Enterprise support, training, and consulting are all available.](https://mgmtconfig.com/)

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
