+++
date = "2015-04-20 04:35:43"
title = "Docker containers in Oh-My-Vagrant"
draft = "false"
categories = ["technical"]
tags = ["centos", "devops", "docker", "fedora", "git", "gluster", "kubernetes", "oh-my-vagrant", "planetdevops", "planetfedora", "planetpuppet", "puppet", "screencast", "vagrant", "vagrant-libvirt"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/04/20/docker-containers-in-oh-my-vagrant/"
+++

The <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant</a> (omv) project is an easy way to bootstrap a development environment. It is particularly useful for spinning up an arbitrary number of virtual machines in Vagrant without writing ruby code. For multi-machine container development, <em>omv</em> can be used to help this happen more naturally.

Oh-My-Vagrant can be very useful as a docker application development environment. I've made a quick (<9min) screencast demoing this topic. Please have a look:

<a href="https://dl.fedoraproject.org/pub/alt/purpleidea/screencasts/oh-my-vagrant-docker-screencast.ogv">https://dl.fedoraproject.org/pub/alt/purpleidea/screencasts/oh-my-vagrant-docker-screencast.ogv</a>

If you watched the screencast, you should have a good overview of what's possible. Let's discuss some of these features in more detail.

<span style="text-decoration:underline;">Pull an arbitrary list of docker images</span>:

If you use an image that was baked with <a href="https://github.com/purpleidea/vagrant-builder">vagrant-builder</a>, you can make sure that an arbitrary list of docker images will be pre-cached into the base image so that you don't have to wait for the slow docker registry every time you boot up a development vm.

This is easily seen in the CentOS-7.1 <a href="https://github.com/purpleidea/vagrant-builder/blob/master/v7/versions/centos-7.1-docker.sh#L15">image definition file seen here</a>. Here's an excerpt:
```
VERSION='centos-7.1'
POSTFIX='docker'
SIZE='40'
DOCKER='centos fedora'		# list of docker images to include
```
The <a href="https://www.gluster.org/">GlusterFS</a> community <a href="https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/centos-7.1-docker/">gracefully hosts a copy of this image here</a>.

If you'd like to add images to a vm you can add a list of things to pull in the <em>docker</em> <code>omv.yaml</code> variable:
```
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.1-docker
:docker:
- ubuntu
- busybox
:count: 1
: vms: []
```
This key is also available in the vms array.<em>
</em>

<span style="text-decoration:underline;">Automatic docker builds</span>:

If you have a <code>Dockerfile</code> in a <code>vagrant/docker/*/</code> folder, then it will get automatically added to the running vagrant vm, and built every time you run a <code>vagrant up</code>. If the machine is already running, and you'd like to rebuild it from your local working directory, you can run: <code>vagrant rsync && vagrant provision</code>.

<span style="text-decoration:underline;">Automatic docker environments</span>:

Building and defining docker applications can be a tricky process, particularly because the techniques are still quite new to developers. With Oh-My-Vagrant, this process is simplified for container developers because you can build an <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/examples/docker-build.yaml#L9">enhanced <code>omv.yaml</code> file</a> which defines your app for you:
```
---
:domain: example.com
:network: 192.168.123.0/24
:image: centos-7.0-docker
:extern:
- type: git
  system: docker
  repository: https://github.com/purpleidea/docker-simple1
  directory: simple-app1
:docker: []
:vms: []
:count: 3
```
By listing multiple git repos in your <code>omv.yaml</code> file, they will be automatically pulled down and built for you. An example of the above running would look similar to this:
```
$ time vup omv1
Cloning into 'simple-app1'...
remote: Counting objects: 6, done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 6
Unpacking objects: 100% (6/6), done.
Checking connectivity... done.

Bringing machine 'omv1' up with 'libvirt' provider...
==> omv1: Creating image (snapshot of base box volume).
==> omv1: Creating domain with the following settings...
==> omv1:  -- Name:              omv_omv1
==> omv1:  -- Domain type:       kvm
==> omv1:  -- Cpus:              1
==> omv1:  -- Memory:            512M
==> omv1:  -- Base box:          centos-7.0-docker
==> omv1:  -- Storage pool:      default
==> omv1:  -- Image:             /var/lib/libvirt/images/omv_omv1.img
==> omv1:  -- Volume Cache:      default
==> omv1:  -- Kernel:            
==> omv1:  -- Initrd:            
==> omv1:  -- Graphics Type:     vnc
==> omv1:  -- Graphics Port:     5900
==> omv1:  -- Graphics IP:       127.0.0.1
==> omv1:  -- Graphics Password: Not defined
==> omv1:  -- Video Type:        cirrus
==> omv1:  -- Video VRAM:        9216
==> omv1:  -- Command line : 
==> omv1: Starting domain.
==> omv1: Waiting for domain to get an IP address...
==> omv1: Waiting for SSH to become available...
==> omv1: Starting domain.
==> omv1: Waiting for domain to get an IP address...
==> omv1: Waiting for SSH to become available...
==> omv1: Creating shared folders metadata...
==> omv1: Setting hostname...
==> omv1: Rsyncing folder: /home/james/code/oh-my-vagrant/vagrant/ => /vagrant
==> omv1: Configuring and enabling network interfaces...
==> omv1: Running provisioner: shell...
    omv1: Running: inline script
==> omv1: Running provisioner: docker...
    omv1: Configuring Docker to autostart containers...
==> omv1: Running provisioner: docker...
    omv1: Configuring Docker to autostart containers...
==> omv1: Building Docker images...
==> omv1: -- Path: /vagrant/docker/simple-app1
==> omv1: Sending build context to Docker daemon 54.27 kB
==> omv1: Sending build context to Docker daemon 
==> omv1: Step 0 : FROM fedora
==> omv1:  ---> 834629358fe2
==> omv1: Step 1 : MAINTAINER James Shubin <james@shubin.ca>
==> omv1:  ---> Running in 2afded16eec7
==> omv1:  ---> a7baf4784f57
==> omv1: Removing intermediate container 2afded16eec7
==> omv1: Step 2 : RUN echo Hello and welcome to the Technical Blog of James > README
==> omv1:  ---> Running in 709b9dc66e9b
==> omv1:  ---> b955154474f4
==> omv1: Removing intermediate container 709b9dc66e9b
==> omv1: Step 3 : ENTRYPOINT python -m SimpleHTTPServer
==> omv1:  ---> Running in 76840da9e963
==> omv1:  ---> b333c179dd56
==> omv1: Removing intermediate container 76840da9e963
==> omv1: Step 4 : EXPOSE 8000
==> omv1:  ---> Running in ebf83f08328e
==> omv1:  ---> f13049706668
==> omv1: Removing intermediate container ebf83f08328e
==> omv1: Successfully built f13049706668

real	1m12.221s
user	0m5.923s
sys	0m0.932s
```
All that happened in about a minute!

<span style="text-decoration:underline;">Conclusion</span>:

I hope these tools help, if you're following my <a href="https://github.com/purpleidea/oh-my-vagrant">git commits</a>, you'll notice that there are some new features I haven't blogged about yet. <a href="http://kubernetes.io/">Kubernetes</a> integration exists, so please have a look, and hopefully I'll have some screencasts and blog posts about this shortly.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
