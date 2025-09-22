---
# get with: `date --rfc-3339=seconds`
date: 2024-01-28 17:04:30-05:00
title: "Git branch filtering"
description: "How to make git branch filtering more palatable"
categories:
  - "technical"
tags:
  - "bash"
  - "branch"
  - "git"
  - "linux"
  - "planetfedora"

draft: false
---

If you have more than one git branch up in the air at the same time, having a
system to track them and filter them is essential. Here are the stages I went
through with `git branch`.

{{< blog-image src="git_2x.png" url="https://xkcd.com/1597/" caption="xkcd reminds us that we're insane" scale="50%" >}}

{{< blog-paragraph-header "Prefixes" >}}

My first tip involves using a memorable prefix. For new features I name my
branches with `feat/`. For example `feat/my-new-feature`. Yes the slash and the
dashes are treated like any regular character. I also commonly use `bug/`. You
can see all of the branches with `git branch -a`.

{{< blog-paragraph-header "Sorting" >}}

I found I wanted the most recently used branches at the bottom. Let's add an
alias to do that. In your `~/.gitconfig` file, in the `[alias]` section, add:

```
rbranch = for-each-ref --sort='committerdate' --format="%20%20%(refname:short)" refs/heads/
```

This even adds the two spaces that you normally see with `git branch`.

{{< blog-paragraph-header "Aliases" >}}

I then improved things with a git alias. I use `r` for that, since I list all my
branches fairly often.

```
r = rbranch
```

{{< blog-paragraph-header "Filtering" >}}

I previously wanted to filter things with grep. Many years ago I couldn't get
this working. I eventually ended up with:

```
rbranch = for-each-ref --sort='committerdate' --format="%20%20%(refname:short)" --exclude 'refs/heads/delete/*' --exclude 'refs/heads/old/*' refs/heads/
```

The above command filters out branches that have a short name starting with
`old/` or `delete/`, which are two prefixes I use temporarily for old branches
and ones I plan to eventually delete.

Git matches on the actual ref name. Keep in mind that it uses the full refname,
so if you added a `--format` option, remove that to see what it's actually
matching against when debugging.

{{< blog-paragraph-header "Maximum count" >}}

I don't like filling my whole terminal when I usually only care about the last
20 or so active branches. You can use the `--count` option to filter this down.
Unfortunately for me, I want to see the newest ones at the bottom.

{{< blog-paragraph-header "Finally" >}}

It was at this point, that I dug back into my git alias issues, and got bash
pipes working. I decided to rewrite it all in terms of a shell command which is
enclosed in the git alias. I also swapped out the `--exclude` matching for grep
which can be more succinct. I'm now left with:

```
rbranch = ! git for-each-ref --sort='-committerdate' --format='%20%20%(refname:short)' refs/heads/ | grep -v --max-count 20 -E '^  (delete|old)/' | tac
```

Note that including the dash as a prefix in sort, we get this in the reverse
order. We then filter those through grep, matching with `-v` for excludes, and
also limiting the number to 20. We finally run everything through `tac` (which
is like `cat` but does things in reverse order, get it?) to finish things off.

{{< blog-paragraph-header "Example" >}}

Combined with my ability to [show the current git branch in PS1](/blog/2013/10/10/show-current-git-branch-in-ps1-when-branch-is-not-master/)
I now have a pretty nifty setup.

```bash
james@hostname:~/code/mgmt (feat/new-magic)$ git r
  bug/race-condition
  feat/world-peace
  feat/remote-resource
  bug/off-by-one-error
  master
  feat/world-domination
  feat/graph-shape
  feat/mcl-provisioner
```

{{< blog-paragraph-header "Conclusion" >}}

I hope that makes your git filtering easier!

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
