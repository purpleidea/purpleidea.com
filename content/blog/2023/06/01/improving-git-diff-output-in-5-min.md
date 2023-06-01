---
date: 2023-06-01 18:20:00-04:00
title: "Improving git diff output in 5 min"
description: "How to get rid of the annoying a/ and b/ prefixes."
categories:
  - "technical"
tags:
  - "devops"
  - "diff"
  - "fedora"
  - "git"
  - "planetdevops"
  - "planetfedora"
draft: false
---

Everyone uses `git diff`. But there's that odd annoyance that you've probably
seen before but are so used to that you've forgotten about it. The `a/` and `b/`
prefixes...

{{< blog-paragraph-header "Example" >}}

```bash
james@computer:~/code/mgmt (feat/cool-feature)$ git diff
diff --git a/lang/funcs/core/os/readfile_func.go b/lang/funcs/core/os/readfile_func.go
index 206ba798d..48ac29dc7 100644
--- a/lang/funcs/core/os/readfile_func.go
+++ b/lang/funcs/core/os/readfile_func.go
@@ -228,6 +228,8 @@ func (obj *ReadFileFunc) Stream() error {

 // Close runs some shutdown code for this function and turns off the stream.
 func (obj *ReadFileFunc) Close() error {
+       // TODO: Port to the new ctx-in-Stream close API.
+       // Hello blog readers!
        close(obj.closeChan)
        obj.wg.Wait()     // block so we don't exit by the closure of obj.events
        close(obj.events)
```

{{< blog-paragraph-header "What are they for?" >}}

The `git diff` command shows these to help you differentiate between the source
and the destination files. In most cases you are in the midst of looking at and
writing code, so you'll probably instinctively know whether you or something
just added or deleted those lines. (Because if you flipped `a` and `b` you'd
have the opposite diff.)

{{< blog-paragraph-header "The fix" >}}

You can customize these with `--src-prefix=<prefix>` and  `--dst-prefix=<prefix>`.
Even better, I just turn them off with `--no-prefix`.

{{< blog-paragraph-header "What about my .gitconfig ?" >}}

Just run:

```bash
$ git config --global diff.noprefix true
```

Alternatively you can add to your `~/.gitconfig` directly with:

```bash
# turn off the stupid a/ b/ prefixes in `git diff`
[diff]
	noprefix = true
```

{{< blog-paragraph-header "New output" >}}

```bash
james@computer:~/code/mgmt (feat/cool-feature)$ git diff
diff --git lang/funcs/core/os/readfile_func.go lang/funcs/core/os/readfile_func.go
index 206ba798d..a8c82293e 100644
--- lang/funcs/core/os/readfile_func.go
+++ lang/funcs/core/os/readfile_func.go
@@ -228,6 +228,8 @@ func (obj *ReadFileFunc) Stream() error {

 // Close runs some shutdown code for this function and turns off the stream.
 func (obj *ReadFileFunc) Close() error {
+       // TODO: Port to the new ctx-in-Stream close API.
+       // Please send me some cool patches or donations!
        close(obj.closeChan)
        obj.wg.Wait()     // block so we don't exit by the closure of obj.events
        close(obj.events)
```

{{< blog-paragraph-header "Why this is annoying?" >}}

If you're copy+pasting from the terminal, you'd have to manually select the
string without the prefix, as by default word barriers select the whole thing.
Note the difference:

Before:
{{< blog-image src="git-diff-before.png" alt="Definitely a small detail, but it's so easy to optimize!" scale="100%" >}}

After:
{{< blog-image src="git-diff-after.png" alt="So much better and cleaner!" scale="100%" >}}

{{< blog-paragraph-header "Future work" >}}

Unfortunately the diff output in `git add -p` does not obey the same setting. I
briefly looked at writing a patch for this, but my C skills and knowledge of the
git codebase itself aren't good enough at the moment. If you could make this
happen or open an issue with the git team, please do!

{{< blog-paragraph-header "Conclusion" >}}

I hope you enjoyed this. Please leave me a comment if this taught you something
new!

{{< blog-paragraph-header "Postscript" >}}

It probably took me more time to write this blog post than what I'll save in
copy+paste time cumulatively over the next year, but here we are.

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
