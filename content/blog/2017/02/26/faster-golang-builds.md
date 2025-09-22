+++
date = "2017-02-26 17:02:35"
title = "Faster golang builds"
draft = "false"
categories = ["technical"]
tags = ["$GOPATH", "GNU", "XDG", "devops", "etcd", "fedora", "gcc", "gluster", "go build", "golang", "mgmtconfig", "planetdevops", "planetfedora", "posix", "prometheus"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2017/02/26/faster-golang-builds/"
+++

I've been hacking in <a href="https://en.wikipedia.org/wiki/Golang">golang</a> since before version 1.4, and the speed at which my builds finished has been mostly trending downwards. Let's look into the reasons and some fixes. TL;DR click-bait title: "Get 4x faster golang builds with this one trick!".

Here are the three reasons my builds got slower:

<span style="text-decoration:underline;">The compiler</span>

Before version 1.5, the compiler was written in C but <a href="https://golang.org/doc/go1.5#c">with that release, it moved to being pure golang</a>. This unfortunately reduced build performance quite measurably, even though it was the right decision for the project.

There have been slight improvements with newer versions, however Google's focus has been <a href="https://golang.org/doc/go1.7#compiler">improving runtime performance</a> instead of build performance. This is understandable since they want to save lots of electricity dollars at scale, which is not as helpful for smaller shops where the developer iteration cycle is the metric to optimize.

This could still be improved if folks wanted to put in the effort. A <a href="https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#Optimize-Options">gcc style -O0 option</a> could help. The sad thing about this whole story is that "instant" builds were a major marketing feature of early golang presentations.

<span style="text-decoration:underline;">Project size</span>

Over time, my <a href="https://github.com/purpleidea/mgmt/">main project (mgmt)</a> has gotten much bigger! It compiles in a number of libraries, including <a href="https://github.com/coreos/etcd">etcd</a>, <a href="https://github.com/prometheus/prometheus/">prometheus</a>, and more! This naturally increases build time and is a mostly unavoidable consequence of building cool things and <a href="https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants">standing on giants</a>!

This mostly can't be helped, but it can be mitigated...

<span style="text-decoration:underline;">Dependency caching</span>

When you build a project and all of its dependencies, the unchanged dependencies shouldn't need to be rebuilt! Unfortunately golang does a great job of silently rebuilding things unnecessarily. Here's why...

When you run a build, golang will attempt to re-use any common artefacts from previous builds. If the golang versions or library versions don't match, these won't be used, and the compiler will redo this work. Unfortunately, by default, those results won't be saved, causing you to waste CPU cycles every time you test!

When the intermediate results are kept, they are found in your <code>$GOPATH/pkg/</code>. To save them, you need to either run <code>go install</code> (which makes a mess in your <code>$GOPATH/bin/</code>, or you can run <strong><a href="https://github.com/purpleidea/mgmt/commit/46c6d6f6565a5e01c4fc3d7249f87a1a6a487ab8"><code>go build -i</code></a></strong>. (Thanks to <a href="https://twitter.com/davecheney/status/835772875139244032">Dave for the tip</a>!)

The sad part of this story is that these aren't cached by default, and stale results aren't discarded by default! If you're experiencing slow builds, you should <code>rm -rf $GOPATH/pkg/</code> and then <code>go build -i</code>. After one successful build, future builds should be much faster!

<span style="text-decoration:underline;">Example</span>

```
james@computer:~/code/mgmt$ time go build    # before

real    0m28.152s
user    1m17.097s
sys     0m5.235s

james@computer:~/code/mgmt$ time go build -i    # after

real    0m8.129s
user    0m12.014s
sys     0m0.839s
```
<span style="text-decoration:underline;">Debugging</span>

If you want to debug what's going on, you can always run <code>go build -x</code>.

<span style="text-decoration:underline;">Blame!</span>

I don't like assigning blame, but this feels like a case of the golang tools being obtuse, and the man pages being non-existent. The golang project has a lot of maturing to do to integrate sanely with a <a href="https://fedoraproject.org/">stock</a> <a href="https://www.gnu.org/">GNU</a> environment:

<ul>
    <li>build intermediates could be saved and discarded by default</li>
    <li><code>man go build</code> could exist and provide useful information</li>
    <li><del><code>go build --help</code></del> <code>go help build</code> could provide more useful information</li>
    <li>POSIX style flags could be used (eg: <code>--help</code>)</li>
    <li>build cache could be stored in <a href="https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables"><code>$XDG_CACHE_HOME</code></a>.</li>
</ul>

Hope this helped improve your golang experience! I always knew something was going in in <code>$GOPATH/pkg/</code>, but I think it's pretty absurd that I only fully understood it now. My builds are about 4x faster now. :)

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
