+++
date = "2015-04-08 03:37:18"
title = "Sharing dev environments with Oh-My-Vagrant"
draft = "false"
categories = ["technical"]
tags = ["gluster", "oh-my-vagrant", "planetfedora", "planetpuppet", "docker", "planetdevops", "puppet", "git", "kubernetes", "ansible", "devops", "fedora", "screencast"]
author = "jamesjustjames"
+++

With <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant</a> (omv) you can set up a dev environment in seconds. (Read the <a href="/post/2014/09/03/introducing-oh-my-vagrant/">omv introduction</a> if you've never used it before!) Since everything is defined in a single <code>omv.yaml</code> file, it is easy to share your cluster prototype with a friend! The one missing feature was associating code with this config file. This is now possible! Let me show you how it works...

In the <code>omv.yaml</code> file there is an <code>extern</code> variable. It is a list of each <em>external</em> repository which you'd like to include. Each element in this list is a hash of key value pairs. Currently four are supported: <em>type</em>, <em>system</em>, <em>repository</em>, <em>directory</em>.

An example will help you visualize this:
```
---
:domain: example.com
:network: 192.168.123.0/24
:image: fedora-21
:<strong>extern</strong>:
- type: git
  system: ansible
  repository: https://github.com/eparis/kubernetes-ansible
  directory: kubernetes
:reallyrm: true
```
In this example, we list one external repository. It is of type <em>git</em>, it is intended for use with the <em>ansible</em> integration provided by omv, the repository is hosted by <em>eparis</em>, and we'll store this in a local directory called <em>kubernetes</em>.

We currently only support git repositories, but patches for other systems are welcome. A few different "systems" are supported, including <em>puppet</em>, <em>docker</em> and <em>kubernetes</em>. They each integrate with omv, and, as a result can pull code and modules into the appropriate places. Any repository path that is valid is acceptable (including local file paths) and lastly, the directory you choose is entirely up to you!

The most important part that I need to mention is the <code>reallyrm</code> variable. If this is set to true, and you remove a git repository from the list, omv will make sure that it removes it! Since some users might not expect this behaviour, it defaults to <em>false</em>, and shouldn't bite you! If you're not comfortable with it, don't use it! I find it incredibly helpful.

Here's a small screencast to show you some examples of this in action:

<a href="https://download.gluster.org/pub/gluster/purpleidea/screencasts/oh-my-vagrant-extern-screencast.ogv">oh-my-vagrant-extern-screencast.ogv</a>

I hope you enjoyed this. Please share and enjoy, and I'll be back soon to explain some more of the features! <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/DOCUMENTATION.md">Documentation</a> patches are appreciated!

Happy hacking,

James

