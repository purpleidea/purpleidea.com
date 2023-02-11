+++
date = "2016-11-30 23:59:49"
title = "A revisionist history of configuration management"
draft = "false"
categories = ["technical"]
tags = ["ansible", "bash", "cfengine", "chef", "devops", "docker", "fedora", "mgmt", "mgmtconfig", "planet", "planetfedora", "planetpuppet", "puppet", "ruby", "send/recv", "systemd-nspawn"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/11/30/a-revisionist-history-of-configuration-management/"
+++

I've got a brand new core feature in mgmt called <em>send/recv</em> which I plan to show you shortly, but first I'd like to start with some background.

<span style="text-decoration:underline;">History</span>

This is <em>my</em> historical perspective and interpretation about the last twenty years in configuration management. It's likely inaccurate and slightly revisionist, but it should be correct enough to tell the design story that I want to share.

Sometime after people started to realize that writing bash scripts wasn't a safe, scalable, or reusable way to automate systems, <em>CFEngine</em> burst onto the scene with the first real solution to this problem. I think it was mostly all quite sane, but it wasn't a tool which let us build autonomous systems, so people eventually looked elsewhere.

Later on, a new tool called <em>Puppet</em> appeared, and advertised itself as a "CFEngine killer". It was written in a flashy new language called <em>Ruby</em>, and started attracting a community. I think it had some great ideas, and in particular, the idea of a safe declarative language was a core principle of the design.

I first got into configuration management around this time. My first exposure was to Puppet version 0.24, IIRC. Two major events followed.

<ol>
    <li>Puppet (the company, previously named "Reductive Labs") needed to run a business (rightly so!) and turned their GPL licensed project, into an ALv2 licensed one. This opened the door to an <a href="https://en.wikipedia.org/wiki/Open_core">open-core</a> business model, and I think was ultimately a detriment to the Puppet community.</li>
    <li>Some felt that the Puppet DSL (language) was too restrictive, and that this was what prevented them from building autonomous systems. They eventually started a project called <em>Chef</em> which let you write your automation using straight Ruby code. It never did lead them to build autonomous systems.</li>
</ol>

At this point, as people began to feel that the complexity (in particular around multi-machine environments) starting to get too high, a flashy new orchestrator <em>called </em><em>Ansible</em> appeared. While I like to put centralized orchestrators in a different category than configuration management, it sits in the same problem space so we'll include it here.

Ansible tried to solve the complexity and multi-machine issue by determining the plan of action in advance, and then applying those changes remotely over SSH. Instead of a brand new "language", they ended up with a fancy YAML syntax which has been loved by many and disliked by others. You also couldn't really exchange host-local information between hosts at runtime, but this was a more advanced requirement anyway. They never did end up building reactive, autonomous systems, but this might not have been a goal.

Sometime later, container technology had a <a href="https://en.wiktionary.org/wiki/renaissance#French">renaissance</a>. The popular variant that caused a stir was called <em>Docker</em>. This dominant form was one in which you used a bash script wrapped in some syntactic sugar (a "Dockerfile") to build your container images. Many believed (although incorrectly) that container technology would be a replacement for this configuration management scene. The solution was to build these blobs with shell scripts, and to mix-in the mostly useless concept of image layering.

They seem to have taken the renaissance too literally, and when they revived container technology, they also brought back using the shell as a build primitive. While I am certainly a fan and user of bash, and I do appreciate the nostalgia, it isn't the safe, scalable design that I was looking for.

Docker is definitely in a different category than configuration management, and in fact, I think the two are actually complementary, and even though I prefer systemd-nspawn, we'll mention Docker here so that I can publicly discredit the notion that it sits in or replaces this problem space.

While in some respects they got much closer to being able to build autonomous systems, you had to rewrite your software to be able to fit into this model, and even then, there are many shortcomings that still haven't been resolved.

<span style="text-decoration:underline;">Analysis</span>

On the path to autonomous systems, there is certainly a lot of trial and error. I don't pretend to think that I have solved this problem, but I think I'll get pretty close.

<ul>
    <li>Where CFEngine chose the C language for portability, it lacked safety, and</li>
    <li>Where Puppet chose a declarative language for safety, it lacked power, and</li>
    <li>Where Chef chose raw code for power, it lacked simplicity, and</li>
    <li>Where Ansible chose an orchestrator for simplicity, it lacked distribution and</li>
    <li>Where Docker chose multiple instances for distribution, it lacked coordination.</li>
</ul>

I believe that instead the answer to all of these is still ahead. When discussing power, I think the main mistake was the lack of a sufficiently advanced resource primitive. The <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">event based engine in mgmt</a> is intended to be the main aspect of this solution, but not the whole story. For another piece of this story, I invented something I'm calling <em>send/recv</em>.

<span style="text-decoration:underline;">Send/Recv</span>

I'd like to go into this today, but I think I'm going to split this discussion into a separate blog post. Expect something here within a week!

If you hate the suspense, become a contributor and be involved in these discussions! We're hanging out in #mgmtconfig on [Libera.chat](https://libera.chat/). I also hold occasional videoconferences with code contributors where we talk about the future.

<span style="text-decoration:underline;">Thanks</span>

I learned a tremendous amount from all of these earlier tools and communities, and even though I am working on a next generation tool, I would never be where I am now if it wasn't for all of those who came before me. I'm even trying to borrow ideas where it is appropriate to do so! I welcome all of those communities into the mgmt circle, and I hope that their users all continue to positively influence the design of mgmt.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
