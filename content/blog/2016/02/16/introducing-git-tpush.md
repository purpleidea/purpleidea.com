+++
date = "2016-02-16 12:15:06"
title = "Introducing: git tpush"
draft = "false"
categories = ["technical"]
tags = ["ci", "git-tpush", "planetdevops", "bash", "gluster", "planetpuppet", "devops", "puppet", "tpush", "planetfreeipa", "travis", "github", "hub", "tput", "git", "planetfedora", "jenkins", "planetipa"]
author = "jamesjustjames"
+++

On today's issue of "one hour hacks", I'll show you how you can stop your git drive-by's to git master from breaking your CI tests... Let's continue!

<strong><span style="text-decoration:underline;">The problem</span>:</strong>

Sometimes I've got a shitty one-line patch that I want to push to <code>git master</code>. I'm usually right, and everything tests out fine, but usually isn't always, and then I look silly while I frantically try to fix <code>git master</code> on a <a href="https://github.com/purpleidea/mgmt/">project that I maintain</a>. Let's use tools to hide our human flaws!

<strong><span style="text-decoration:underline;">How you're really supposed to do it</span>:</strong>

Good hackers know that you're supposed to:
<ul>
	<li>checkout a new feature branch for your patch
<ul>
	<li><code>checkout -b feat/foo</code></li>
</ul>
</li>
	<li>write the patch and commit it
<ul>
	<li><code>git add -p && git commit -m 'my foo'</code></li>
</ul>
</li>
	<li>push that branch up to origin
<ul>
	<li><code>git push origin feat/foo</code></li>
</ul>
</li>
	<li>wait for the tests to succeed
<ul>
	<li><code>hub ci-status && sleep 1m && ...</code></li>
</ul>
</li>
	<li>merge and push to git master
<ul>
	<li><code>git checkout master && git merge feat/foo && git push</code></li>
</ul>
</li>
	<li>delete your local branch
<ul>
	<li><code>git branch -d feat/foo</code></li>
</ul>
</li>
	<li>delete the remote branch
<ul>
	<li><code>git push origin :feat/foo</code></li>
</ul>
</li>
	<li>mourn all the lost time it took to push this patch
<ul>
	<li><code>cat && drink && sleep 8h</code></li>
</ul>
</li>
</ul>
If it happens to fail, you have to remember what the safe <code>git reset</code> command is, and then you have to start all over!

<strong><span style="text-decoration:underline;">How do we make this easy</span>?</strong>

<a href="https://github.com/purpleidea/mgmt/">I write tools</a>, so I sat down and wrote a cheap little bash script to do it for me! Sharing is caring, so please enjoy a copy!

<strong><span style="text-decoration:underline;">How does it work</span>?</strong>

It actually just does all of the above for you automatically, and it automatically cleans up all of the temporary branches when it's done! Here are two example runs to help show you the tool in action:

<strong><span style="text-decoration:underline;">A failure scenario</span>:</strong>

Here I add a patch with some trailing whitespace, which will easily get caught by the automatic test suite. You'll note that I actually had to force the commit locally with <code>git commit -n</code>, because the <code>pre-commit</code> hook actually caught this first. You could extend this script to run your test suite locally before you push the patch, but that defeats the idea of a drive-by.
```
james@computer:~/code/mgmt$ git add -p
diff --git a/README.md b/README.md
index 277aa73..2c31356 100644
--- a/README.md
+++ b/README.md
@@ -34,6 +34,7 @@ Please get involved by working on one of these items or by suggesting something
 Please grab one of the straightforward [#mgmtlove](https://github.com/purpleidea/mgmt/labels/mgmtlove) issues if you're a first time contributor.
 
 ## Bugs:
+Some bugs are caused by bad drive-by patches to git master! 
 Please set the `DEBUG` constant in [main.go](https://github.com/purpleidea/mgmt/blob/master/main.go) to `true`, and post the logs when you report the [issue](https://github.com/purpleidea/mgmt/issues).
 Bonus points if you provide a [shell](https://github.com/purpleidea/mgmt/tree/master/test/shell) or [OMV](https://github.com/purpleidea/mgmt/tree/master/test/omv) reproducible test case.
 
Stage this hunk [y,n,q,a,d,/,e,?]? y
<stdin>:9: trailing whitespace.
Some bugs are caused by bad drive-by patches to git master! 
warning: 1 line adds whitespace errors.

james@computer:~/code/mgmt$ git commit -m 'XXX this is a bad patch'
README.md:37: trailing whitespace.
+Some bugs are caused by bad drive-by patches to git master! 
james@computer:~/code/mgmt$ git commit -nm 'XXX this is a bad patch'
[master 8b29fb3] XXX this is a bad patch
 1 file changed, 1 insertion(+)
james@computer:~/code/mgmt$ git tpush 
tpush branch is: tpush/test-0
Switched to a new branch 'tpush/test-0'
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 357 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To git@github.com:purpleidea/mgmt.git
 * [new branch]      tpush/test-0 -> tpush/test-0
Switched to branch 'master'
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
- CI is starting...
/ Waiting for CI...
- Waiting for CI...
\ Waiting for CI...
| Waiting for CI...
Deleted branch tpush/test-0 (was 8b29fb3).
To git@github.com:purpleidea/mgmt.git
 - [deleted]         tpush/test-0
Upstream CI failed with:
failure: https://travis-ci.org/purpleidea/mgmt/builds/109472293
Fix branch 'master' with:
git commit --amend
or:
git reset --soft HEAD^
Happy hacking!
```
<strong><span style="text-decoration:underline;">A successful scenario</span>:</strong>

In this example, I amended the previous patch in my local copy of <code>git master</code> (which never got pushed to the public git master!) and then I ran <code>git tpush</code> again.
```
james@computer:~/code/mgmt$ git commit --amend
[master 1186d63] Add a link to my article about debugging golang
 Date: Mon Feb 15 17:28:01 2016 -0500
 1 file changed, 1 insertion(+)
james@computer:~/code/mgmt$ git tpush 
tpush branch is: tpush/test-0
Switched to a new branch 'tpush/test-0'
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 397 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To git@github.com:purpleidea/mgmt.git
 * [new branch]      tpush/test-0 -> tpush/test-0
Switched to branch 'master'
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
- CI is starting...
/ Waiting for CI...
- Waiting for CI...
\ Waiting for CI...
| Waiting for CI...
Deleted branch tpush/test-0 (was 1186d63).
To git@github.com:purpleidea/mgmt.git
 - [deleted]         tpush/test-0
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 397 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To git@github.com:purpleidea/mgmt.git
   6e68d6d..1186d63  master -> master
Done!
```
Please take note of the "Waiting for CI..." text. This is actually a spinner which updates itself. Run this tool yourself to get the full effect! This avoids having 200 line scrollback in your terminal while you wait for your CI to complete.

Lastly, you'll note that I run <code>git tpush</code> instead of <code>git-tpush</code>. This is because I added an alias to my ~/.gitconfig. It's quite easy, just add:
```
tpush = !git-tpush
```
under the <code>[alias]</code> section, and ensure the <code>git-tpush</code> shell script is in your <code>~/bin/</code> folder and is executable.

<strong><span style="text-decoration:underline;">Pre-requisites</span>:</strong>

This actually depends on the <a href="https://github.com/github/hub">hub</a> command line tool which knows how to ask our CI about the test status. It sucks using a distributed tool like git with a centralized thing like github, but it's still pretty easy for me to move away if they go bad. You'll also want the <code>tput</code> installed if you want the fancy spinner, but that comes with most GNU/Linux distros by default.

<strong><span style="text-decoration:underline;">The code</span>:</strong>

<a href="https://gist.github.com/purpleidea/1b769e2cd1bd7b01a406">Grab a copy here!</a>

Happy hacking,

James

PS: No, I couldn't think of a better name than git-tpush, if you don't like it feel free to rename it yourself!

