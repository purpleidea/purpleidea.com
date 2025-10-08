---
# get with: `date --rfc-3339=seconds`
date: 2025-09-25 01:07:56-04:00
title: "10 years of mgmt"
description: "I can't believe it's been 10 years"
categories:
  - "non-technical"
tags:
  - "config management"
  - "distributed"
  - "events"
  - "mgmt"
  - "mgmtconfig"
  - "m9rx"
  - "parallel"
  - "planetfedora"

draft: false
---

I publicly released [mgmt](https://mgmtconfig.com/) to the internet 10 years
ago. I can't believe it's been 10 years. In this post I'll talk about:

* The new `mgmt` company
* A one-time new customer offer
* Unexpected wins
* Past failures
* Some history
* A new release

And more...

{{< blog-paragraph-header "The company" >}}

I've officially started a company. I've been working on this for some time now,
and it's time to let you all know about it officially. As you already know
(`mgmt`, `purpleidea`, etc...) I've never been great at naming. The company is
called:

<br />

{{< blog-image src="m9rx_logo_wide_reversed.png" url="https://m9rx.com/" alt="m9rx corporation" scale="100%" >}}

Most of the company offerings are based around [mgmt](https://github.com/purpleidea/mgmt/).
We're offering services, support, training and products around full automation
solutions. I've got lots of exciting things deployed to customers and we're
busy testing new products. I hope you can be a part of this.

{{< blog-paragraph-header "10 year deal" >}}

It's early days, and we haven't published our product brochures yet as we're
still testing and perfecting for our first customers. The products we have:

* Automated (physical and virtual) provisioning
* Automated virtual machine host configuration and lifecycle management
(including eventual clustering)
* Automated workstation and laptop configuration and lifecycle management
* Automated router management (with clustered wireguard inter-networking)
* Automated simple container / virtual machine scheduling
* And much more!

These automation suites all come as a yearly subscription. For our early
adopters, for a limited time, we're now offering a
[**ten year subscription for $10,000**](https://m9rx.com/news/10-years-of-mgmt/).
This offer comes with basic support, and let's you run these products on up to
10 machines or 100 cores. (Your choice.) You'll also get access to our insiders
channel where you get early access to inside information and more.

We also have discounts on training, consulting, and more.

If you're interested, or for more information, [contact](https://m9rx.com/contact/)
us by form, email or telephone. This deal is available for a limited time.

The goal of this is to reward our early customers and help us stay as
independent as possible so we can do right by our users and community.

{{< blog-paragraph-header "Unexpected wins" >}}

When I first started the [mgmt](https://github.com/purpleidea/mgmt/) project, I
was mostly thinking about building a better [Puppet](https://en.wikipedia.org/wiki/Puppet_(software)).
Sometime along the road while I was building `mgmt`, I realized that it could
actually be a possible solution for modelling and building autonomous, reactive
systems. I've since proven this to myself, and I've been slowly sharing this
lesson with more and more of you. It motivates me to know that this leads us to
a path where we'll eventually have both small personal and giant corporate
clusters of computers that all self-manage without human intervention. The days
of the classic sysadmin are numbered. My one missing automation piece, is a
robot to replace failed hard drives and other components. Build me that robot
and give me an API, and I'll integrate it with `mgmt`.

{{< blog-paragraph-header "Past failures" >}}

I was never good at marketing. I got distracted by the necessary need to pay
bills instead of always having 100% of my time focused on `mgmt`. I was possibly
too focused on core designs, architecture and algorithms, rather than
immediately focusing on user use-cases. One person has called this my "art
project". I failed to convince enough of the Free Software or open source
community to develop it with me. These days it seems to be mostly about getting
things for free, rather than investing in our shared software future. I still
believe in the software and in Free Software, and it seems that commercializing
it is the only sustainable path forwards.

{{< blog-paragraph-header "A new release" >}}

The latest `mgmt` release is now available. It's remarkably powerful and
polished, and I've been having a huge amount of fun writing and running `mcl`
code. All of you that know me well, know that I'm committed to open source and I
hope you'll return the favour and support a business model built on those
values.

[Feel free to download the latest version today.](https://github.com/purpleidea/mgmt/releases/)

{{< blog-paragraph-header "Conclusion" >}}

[Enterprise products, services, support, and training are all available.](https://m9rx.com/)

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
