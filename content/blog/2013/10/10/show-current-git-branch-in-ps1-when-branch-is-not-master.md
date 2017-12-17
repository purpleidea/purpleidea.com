+++
date = "2013-10-10 22:16:28"
title = "Show current git branch in PS1 when branch is not master"
draft = "false"
categories = ["technical"]
tags = ["planetfedora", "devops", "git", "gluster", "bashrc", "bash", "ps1"]
author = "jamesjustjames"
+++

Short post, long command...

I've decided to start showing the current <a title="git" href="http://ttboj.wordpress.com/code/git/">git</a> branch in my <em>PS1</em>. However, since I don't want to know when I'm on <em>master</em>, I had to write a new PS1 that I haven't yet seen anywhere. Add the following to your <em>.bashrc</em>:
```
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
if [ -e /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    . /usr/share/git-core/contrib/completion/git-prompt.sh
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$([ "$(__git_ps1 %s)" != "" -a "$(__git_ps1 %s)" != "master" ] && (echo -e " (\[33[32m\]"$(__git_ps1 "%s")"\[33[0m\])") || echo "")\$ '
fi
```
This keeps my PS1 short for when I'm hacking on personal repositories that only have a single branch. Keep in mind that you might have to change the path to <em>git-prompt.sh</em> depending on what OS you're using.

<span style="text-decoration:underline;">Example</span>:
```
james@computer:~/code/puppet$ cd puppet-gluster
james@computer:~/code/puppet/puppet-gluster$ git checkout -b cool-new-feature
Switched to a new branch 'cool-new-feature'
james@computer:~/code/puppet/puppet-gluster (<span style="color:#00ff00;">cool-new-feature</span>)$ # tada !
```
The branch name is coloured to match the default colours that git uses to colour branches.

Happy hacking,

James

&nbsp;

