+++
date = "2014-05-06 19:34:13"
title = "Keeping git submodules in sync with your branches"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "git", "git hooks", "git submodules", "gluster", "planetdevops", "planetfedora", "planetpuppet", "post-checkout", "puppet", "puppet-gluster"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/05/06/keeping-git-submodules-in-sync-with-your-branches/"
+++

This is a quick trick for making working with <a href="http://www.git-scm.com/book/en/Git-Tools-Submodules"><em>git submodules</em></a> more magic.

One day you might find that using <em>git submodules</em> is needed for your project. It's probably not necessary for everyday hacking, but if you're glue<em>-ing</em> things together, it can be quite useful. <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> uses <a href="https://github.com/purpleidea/puppet-gluster/tree/master/vagrant/gluster/puppet/modules">this technique</a> to easily include all the dependencies needed for a <a title="Automatically deploying GlusterFS with Puppet-Gluster + Vagrant!" href="/blog/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/">Puppet-Gluster+Vagrant automatic deployment</a>.

If you're a good hacker, you develop things in separate feature branches. Example:

```
cd code/projectdir/
git checkout -b feat/my-cool-feature
# hack hack hack
git add -p
# add stuff
git commit -m 'my cool new feature'
git push
# yay!
```

The problem arises if you <em>git pull</em> inside of a <em>git submodule</em> to update it to a particular commit. When you switch branches, the <em>git submodule</em>'s branch doesn't move along with you! Personally, I think this is a bug, but perhaps it's not. In any case, here's the fix:

add:

```
#!/bin/bash
exec git submodule update
```

to your:

```
<projectdir>/.git/hooks/post-checkout
```

and then run:

```
chmod u+x <projectdir>/.git/hooks/post-checkout
```

and you're good to go! Here's an example:

```
james@computer:~/code/puppet/puppet-gluster$ git checkout feat/yamldata
M vagrant/gluster/puppet/modules/puppet
Switched to branch 'feat/yamldata'
Submodule path 'vagrant/gluster/puppet/modules/puppet': checked out 'f139d0b7cfe6d55c0848d0d338e19fe640a961f2'
james@computer:~/code/puppet/puppet-gluster (feat/yamldata)$ git checkout master
M vagrant/gluster/puppet/modules/puppet
Switched to branch 'master'
Your branch is up-to-date with 'glusterforge/master'.
Submodule path 'vagrant/gluster/puppet/modules/puppet': checked out '07ec49d1f67a498b31b4f164678a76c464e129c4'
james@computer:~/code/puppet/puppet-gluster$ cat .git/hooks/post-checkout
#!/bin/bash
exec git submodule update
james@computer:~/code/puppet/puppet-gluster$
```
Hope that helps you out too! If someone knows of a use-case when you don't want this functionality, please let me know! Many thanks to <em>#git</em> for helping me solve this issue!

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
