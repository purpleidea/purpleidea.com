---
# get with: `date --rfc-3339=seconds`
date: 2024-03-02 19:54:00-05:00
title: "Bash $PATH filtering"
description: "How to filter things out of bash completion"
categories:
  - "technical"
tags:
  - "bash"
  - "execignore"
  - "fedora"
  - "filter"
  - "linux"
  - "path"
  - "planetfedora"

draft: false
---

As most modern GNU+Linux distro users already know, you get a lot of [tools](https://en.wikipedia.org/wiki/GNU)
included for free! Many of these may clutter up your `$PATH` and make `bash` tab
completion more difficult than it has to be. Here's a way to improve this!

{{< blog-paragraph-header "A mess" >}}

Here's what I see when I tab-complete `cd<TAB>`:

```bash
james@computer:~$ cd
cd                 cddb_query         cd-info            cd-read
cd-convert         cd-drive           cd-it8             cdrecord
cd-create-profile  cd-fix-profile     cdmkdir            cdtmpmkdir
cdda-player        cd-iccdump         cd-paranoia
```

I genuinely only use three of those commands.

{{< blog-image src="tab-complete-all-the-things.jpg" caption="let's make some tab completions more complete" scale="100%" >}}

{{< blog-paragraph-header "Bash to the rescue" >}}

It turns out the `bash` authors already thought of this. There's an `EXECIGNORE`
variable that you can set, and it will filter things out. Look what happens when
you set it:

```bash
james@computer:~$ EXECIGNORE='*/py*:*/cd*'
james@computer:~$ cd
cd          cdmkdir     cdtmpmkdir
```

I rarely use any python things (and this is only an example) and I actually
don't need any of those `cd*` commands in my `$PATH`. Pass in a `colon`
separated list of patterns to ignore, and magically things just work!

If you include this variable in your `~/.bashrc` then it will load automatically
every time you open a new terminal.

{{< blog-paragraph-header "Which cd commands are those?" >}}

If you noticed the `cdmkdir` and `cdtmpmkdir` commands and wondered why they
didn't disappear, that's because they're mine!

```bash
james@computer:~$ which cdmkdir
cdmkdir ()
{
    mkdir "$@" && cd "${@: -1}"
}
james@computer:~$ which cdtmpmkdir
cdtmpmkdir ()
{
    cd `mktemp --tmpdir -d tmp.XXX`
}
```

{{< blog-paragraph-header "Specifics" >}}

From the [manual](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html):

<i>
A colon-separated list of shell patterns (see [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html))
defining the list of filenames to be ignored by command search using `PATH`.
Files whose full pathnames match one of these patterns are not considered
executable files for the purposes of completion and command execution via `PATH`
lookup. This does not affect the behavior of the `[`, `test`, and `[[` commands.
Full pathnames in the command hash table are not subject to `EXECIGNORE`. Use
this variable to ignore shared library files that have the executable bit set,
but are not executable files. The pattern matching honors the setting of the
`extglob` shell option.
</i>

{{< blog-paragraph-header "Conclusion" >}}

I hope that makes your bash tab completion filtering easier!

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
