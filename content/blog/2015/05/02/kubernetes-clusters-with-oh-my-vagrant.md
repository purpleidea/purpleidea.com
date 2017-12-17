+++
date = "2015-05-02 00:07:11"
title = "Kubernetes clusters with Oh-My-Vagrant"
draft = "false"
categories = ["technical"]
tags = ["fedora", "openshift", "atomic", "containers", "docker", "gluster", "google", "kubernetes", "oh-my-vagrant", "planetpuppet", "borg", "pods", "planetdevops", "planetfedora", "screencast", "systemd-nspawn", "devops", "redhat", "json"]
author = "jamesjustjames"
+++

I've added the ability to deploy a <a href="https://github.com/GoogleCloudPlatform/kubernetes">Kubernetes</a> cluster with <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant</a> (<em>omv</em>). I've also built an automated developer experience so that you can test your Kubernetes powered app in minutes. If you want to redeploy a new version, or see how your app behaves during a <a href="https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/kubectl_rolling-update.md">rolling update</a>, you can use <em>omv</em> to test this out in minutes! I've recorded a <a href="https://download.gluster.org/pub/gluster/purpleidea/screencasts/oh-my-vagrant-kubernetes-screencast.ogv">screencast</a> (~15 min), if you'd like to see some of this in action.

<span style="text-decoration:underline;">Background</span>:

Kubernetes is a container cluster manager. It groups containers into <a href="https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/pods.md">pods</a>, and those pods get scheduled to run on a certain machine in the cluster. We'll be talking about <a href="https://en.wikipedia.org/wiki/Docker_%28software%29">Docker containers</a> in this article, although there are lots of great new technologies such as <a href="http://0pointer.net/blog/systemd-for-administrators-part-xxi.html">nspawn</a>.

An <em>advantage</em> of using Kubernetes is that it was created by a team at Google, who has a lot of experience running containers. A lot of smart folks (including many from <a href="https://redhat.com/">Red Hat</a>) are working on this project too! It is becoming the foundation for other software such as <a href="https://blog.openshift.com/openshift-v3-deep-dive-docker-kubernetes/">OpenShift v3</a>. Google has released a <a href="https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/43438.pdf">paper</a> on their earlier work (Borg), which is interesting, but lacks many details, and (unsurprisingly) no source code is present.

Some big <em>disadvantages</em> include the requirement of a <a href="https://sfconservancy.org/blog/2014/jun/09/do-not-need-cla/">CLA</a> to contribute to the project, and the lack of good documentation and articles about it. Kubernetes itself, can't yet be decentralized, but this might change in the future. It's (currently) very difficult to construct the <em>foo.json</em> files required to build an application.

While the project is open source (ALv2) I've gotten the feeling that Google has a pretty strong hold on the project and has some changes to make before the community really trusts them. This can be a learning experience for any company where proprietary software is the culture. I wish them well on their <a href="https://www.gnu.org/philosophy/free-sw.html">journey</a>!

<span style="text-decoration:underline;">Oh-My-Vagrant integration</span>:

To deploy a Kubernetes cluster with <em>omv</em>, the <code>kubernetes</code> variable needs to be set to something meaningful. It's also recommended that you boot up a minimum of <em>three</em> machines. Here is an except from an <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/examples/docker-kubernetes.yaml">example</a> <code>omv.yaml</code> config:
```
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.1-docker
:sync: rsync
:extern:
- type: git
  system: docker
  repository: https://github.com/purpleidea/docker-simple1
  directory: docker-simple1
- type: git
  system: kubernetes
  repository: https://github.com/purpleidea/kube-simple1
  directory: kube-simple1
:puppet: false
:docker: []
:kubernetes:
  applications:
  - kube-simple1/simple1.json
:vms: []
:namespace: omv
:count: 3
```
In the above example, you can see that we've only listed one Kubernetes application, but an arbitrary number can be included. The <code>kubernetes</code> variable can also accept a key named <code>master</code> if you'd like to choose which of your vm's should be the primary. If you don't specify this, the first vagrant machine will be chosen.

In the list of applications, instead of only specifying the .json file, you can instead specify a dictionary of key/value pairs. The .json key (<code>file</code>) is required, but you can also specify additional keys, such as the <em>boolean</em> key <code>roll</code>. When <em>true</em>, it will cause a rolling update to occur instead of a normal" update.

If you're interested to see what needs to be done to set up Kubernetes, the bulk of the work was done by me in <a href="https://github.com/purpleidea/oh-my-vagrant/commit/1f26e5bda5d7585f7b26babcb56a529cc34b96bd">1f26</a>, but figuring out manual steps was only possible thanks to the work of my hacker friends: <a href="https://twitter.com/collier_s">scollier</a> and <a href="https://github.com/eparis/">eparis</a>.

Due to the power of the <em>omv</em> project, when you <code>vagrant up</code>, the necessary docker and Kubernetes projects listed in the <code>extern</code> variable will be automatically cloned and pulled into your <em>omv</em> environment.

<span style="text-decoration:underline;">Screencast</span>:

You're probably due for a screencast (~15 min). Have a watch, and then if you need review, go back and read what I've written above.

<a href="https://download.gluster.org/pub/gluster/purpleidea/screencasts/oh-my-vagrant-kubernetes-screencast.ogv">https://download.gluster.org/pub/gluster/purpleidea/screencasts/oh-my-vagrant-kubernetes-screencast.ogv</a>

(Thanks to the Gluster community for generously hosting this video!)

<span style="text-decoration:underline;">Final thoughts</span>:

I haven't talked about networking, or actually building applications.

Container network might be a lot easier if you use an overlay network like <a href="https://github.com/purpleidea/oh-my-vagrant/issues/76">flannel</a>. Unfortunately, this isn't yet built into Oh-My-Vagrant, but is in the list of <a href="https://github.com/purpleidea/oh-my-vagrant/issues/76">feature requests</a> if someone shows some interest.

Building useful applications is harder. In my screencast, you'll see where to put the code, and how to iterate on it, but not what kind of code to write, or architecturally how your multi-container applications should work. Unfortunately this is out of scope for today's article! My goal was to make it easy for you to focus on that topic, instead of having to figure out how to build the infrastructure. Hopefully Oh-My-Vagrant helps you accomplish that!

Happy hacking,

James

&nbsp;

