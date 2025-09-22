---
date: 2018-04-04 06:27:35-05:00
title: "Leaving Red Hat"
description: "purpleidea is moving on..."
categories:
  - "non-technical"
tags:
  - "devops"
  - "fedora"
  - "gluster"
  - "planetdevops"
  - "planetfedora"
  - "planetpuppet"
  - "puppet"
  - "redhat"
  - "mgmtconfig"
draft: false
---

I've spent about [four years at Red Hat](/blog/2014/04/02/working-at-redhat/),
and now it's time to move on...

*TL;DR:* had to leave Red Hat and start [Patreon](https://www.patreon.com/purpleidea)
to fund [mgmt](https://github.com/purpleidea/mgmt/).

What follows is a bit of historical rambling, and some forward looking
statements.

{{< blog-paragraph-header "Retrospective" >}}

Long-time readers of my blog will know that I was very active in the
[puppet ecosystem](/tags/puppet/) for many years. I learned a lot while writing
puppet code, and while building some of my
[outrageous puppet hacks](https://www.youtube.com/watch?v=hXIEJEE5d_4). Over
this time, I had quietly put together some design notes and a prototype for some
"future tool" ideas. I had code-named this project "*puppet-ng*".

I reached out to Puppetlabs to share some of these ideas in late 2013. Shortly
after, during a hiring interview with their CTO, I presented some of my designs,
but was told that they weren't interested.

Around the same time, Red Hat had been showing interest in my Puppet work,
particularly around [Puppet-Gluster](https://github.com/purpleidea/puppet-gluster).
They offered me a job in their Systems Engineering team, and I accepted.

Over the years I worked on a number of different projects. Initially
[Puppet-Gluster](https://github.com/purpleidea/puppet-gluster),
[Puppet-IPA](https://github.com/purpleidea/puppet-ipa),
[Oh-My-Vagrant](https://github.com/purpleidea/oh-my-vagrant), as well as other
odd projects and hacks.

As part of the Systems Engineering team, we were responsible for glueing
different products together. I made the case that the *glue* that we were using
at the time wasn't effective, and that I had some designs and a prototype for a
[better mouse trap](https://en.wikipedia.org/wiki/Build_a_better_mousetrap,_and_the_world_will_beat_a_path_to_your_door).
A number of great engineers (including the CTO) liked the idea, and so I got to
hacking.

{{< blog-image src="the_general_problem.png" caption="hopefully you'll one day see me as a master artisan with great foresight (read the xkcd alt-text at https://m.xkcd.com/974/)" alt="building general purpose automation" >}}

I released the first public [prototype](https://github.com/purpleidea/mgmt/commit/25ad05cce36d55ce1c55fd7e70a3ab74e321b66e)
in September 2015. As any hacker can tell you, [naming is hard](https://xkcd.com/910/),
and so after exhausting all the other ideas, and wishing to avoid a trademark
dispute with Puppetlabs, I settled on `mgmt`.

Shortly after, [Red Hat acquired Ansible](https://www.redhat.com/en/about/press-releases/red-hat-acquire-it-automation-and-devops-leader-ansible).
Ansible is a fine piece of software, but has a completely different focus than
`mgmt`. Even in 2014, I was well-aware of Ansible, and even an Ansible
predecessor named [func](https://en.wikipedia.org/wiki/Fedora_Unified_Network_Controller).
As anyone who has seen an [`mgmt` presentation](https://purpleidea.com/talks/)
can tell you, they're completely different in scope. Ansible is an on-demand,
centralized orchestrator, whereas `mgmt` is real-time, decentralized automation.

Nevertheless, things slowly got more politically complicated at Red Hat, and it
was impossible to get funding for additional engineers. Ultimately, Red Hat set
my time quota for `mgmt` to [zero](/blog/2017/10/17/copyleft-is-dead-long-live-copyleft.md)
and assigned me to work on some projects that I wasn't passionate about.

{{< blog-image src="dilbert.png" caption="from http://dilbert.com/strip/1994-04-30" alt="a comic" >}}

I'm sad to have to leave Red Hat, but that's the cost I'll pay to be able to
hack on what I believe in. I wasn't given the chance to write a "good-bye"
email, so this will have to suffice. There are a lot of incredible engineers at
Red Hat, and it was my pleasure and privilege to meet and work with so many of
you. Hopefully you'll be able to steal away some of your time to send me
[patches](https://github.com/purpleidea/mgmt/) and help promote my project.

{{< blog-paragraph-header "Future" >}}

It should be no surprise that I want to spend *100%* of my time hacking on
`mgmt`. I don't have any clear plan for funding at the moment, so I will be
living off of my savings while I try to get it minimally viable.

I've decided to experiment with a [Patreon Campaign](https://www.patreon.com/purpleidea).
It probably won't amount to a full-time salary, but I'm hoping people will step
up and pay for the kind of software that they believe in and want.

Alternatively, if you can't afford a recurring donation, one-time
[PayPal donations](https://paypal.me/purpleidea) are appreciated as well. Cash
and cheque are fine too if you prefer to avoid fees!

Longer term plans for me and `mgmt` are not decided yet, so until I sort out my
future, please [give me a shout](/contact/). I love to chat, and I'm available
if you'd like to hire me to work on `mgmt` or to present at your [conference](/talks/).

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
