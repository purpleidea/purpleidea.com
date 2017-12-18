+++
date = "2015-03-16 05:36:19"
title = "Fancy git aliases and git cherryfetch"
draft = "false"
categories = ["technical"]
tags = ["bash", "cherry-pick", "cherryfetch", "devops", "fedora", "git", "git alias", "git rebase", "gluster", "planetdevops", "planetfedora", "planetpuppet", "puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/03/16/fancy-git-aliases-and-git-cherryfetch/"
+++

Here are two quick <a href="https://en.wikipedia.org/wiki/Git_%28software%29">git</a> tricks that I've added to my toolbox lately...

I wanted to create a git alias that takes in argv from the command, but in the middle of the command. Here's the hack that I came up with for the <code>[alias]</code> section of my <code>~/.gitconfig</code>:
```
[alias]

    # cherryfetch fetches a repo ($1) / branch ($2) and applies it rebased!
    # the && true at the end eats up the appended args
    cherryfetch = !git fetch "$1" "$2" && git cherry-pick HEAD..FETCH_HEAD && true
```
<span style="text-decoration:underline;">Explanation</span>:

The git alias is called "<em>cherryfetch</em>". It starts with an exclamation point (<code>!</code>) which means it's a command to execute. It uses <code>$1</code> and <code>$2</code> as arguments, which thankfully exist in this environment! Because running a git alias causes the arguments to get appended to the command, the <code>&&</code> true part exists at the end to receive those commands so that they are silently ignored! This works because the command:
```
$ true ignored command line arguments
```
Does absolutely nothing but return success. Better naming suggestions for my alias are welcome!

<span style="text-decoration:underline;">What does this particular alias do</span>?

Too often I receive a patch which has not been rebased against *<em>my</em>* current git master. This happens because the patch author started hacking on the feature against current git master, but git master grew new commits before the patch was done. The best solution is to ask the author to rebase against git master and resubmit, but when I'm feeling helpful, I can now use <code>git cherryfetch</code> to do the same thing! When their patch is unrelated to my changes, this works perfectly.

<span style="text-decoration:underline;">Example</span>:
```
$ git cherryfetch https://github.com/example_user/puppet-gluster.git feat/branch_name
From https://github.com/example_user/puppet-gluster
* branch            feat/branch_name -> FETCH_HEAD
[master abcdef01] Pi day is awesome, but Tau day is better! purpleidea/puppet-gluster#feat/branch_name
Author: Example User <user@example.com>
Date: Tue Mar 14 09:26:53 2015 -0400
4 file changed, 42 insertions(+), 13 deletions(-)
```
<span style="text-decoration:underline;">Manual learning</span>:

If you were to do the same thing manually, this operation is the equivalent of checking out a branch at the same commit this patch applies to, pulling the patch down (causing a fast-forward) running a <code>git rebase master</code>, switching to master and merging your newly rebased branch in.

My version is faster, isn't it?

Happy hacking!

James

<strong>Update:</strong> I've updated the alias so that it works with N commits. Thanks to <a href="https://twitter.com/dev_el_ops"> David Schmitt</a> for pointing it out, and <a href="https://twitter.com/felis_rex">Felix Frank</a> for finding a nicer solution!

