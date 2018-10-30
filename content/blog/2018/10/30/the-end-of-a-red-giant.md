---
date: 2018-10-30 8:39:00-04:00
title: "The End of a Red Giant"
description: "Thoughts on IBM's acquisition of Red Hat"
categories:
  - "non-technical"
tags:
  - "alv2"
  - "copyleft"
  - "copyright"
  - "fsf"
  - "gpl"
  - "ibm"
  - "legal"
  - "planetfedora"
  - "redhat"
draft: false
---

As I'm sure you've now heard, [Red Hat is being acquired by IBM](https://www.redhat.com/en/about/press-releases/ibm-acquire-red-hat-completely-changing-cloud-landscape-and-becoming-world’s-1-hybrid-cloud-provider).

Reactions have ranged from:

{{< blog-image src="reddit1.png" caption="The first two emotions everyone experienced." scale="100%" >}}

to:

{{< blog-image src="twitter1.png" caption="The classic humourous response." scale="100%" >}}

to:

{{< blog-image src="twitter2.png" caption="The classy response." scale="100%" >}}

to:

{{< blog-image src="reddit2.png" caption="The thing we're all curious about." scale="100%" >}}

to everything in between. If someone were to leak me a copy of the memo-list
_2018-October.txt.gz_ mailman archive, I'd sure love to see that! (Of course I'm
joking and I wouldn't actually ask anyone to do this.)

In any case, the reality about all of this is much more nuanced. I'm going to
try and explain my thoughts as factually as I can.

(Yes, the post title is an astrophysics joke.)

{{< blog-image src="https://imgs.xkcd.com/comics/hertzsprung_russell_diagram.png" caption="A more interesting variant of the Hertzsprung-Russell diagram. Source: https://xkcd.com/2009/" scale="100%" >}}

{{< blog-paragraph-header "A part of history" >}}

[I joined Red Hat in 2014.](/blog/2014/04/02/working-at-redhat/) I became part
of history, and felt very lucky to see inside this special unicorn. Red Hat was
special because they proved that [Copyleft](https://www.gnu.org/licenses/copyleft.en.html)
could be a viable business model. Whatever your opinions on corporations and
licensing are, this is a very interesting data point.

They started with Linux and [GNU](https://www.gnu.org/), and over the years,
added all sorts of projects to the mix:

* [Fedora](https://fedoraproject.org/)
* [libvirt](https://libvirt.org/)
* [GNOME](https://www.gnome.org/)
* [glibc](https://www.gnu.org/software/libc/)
* [GCC](https://www.gnu.org/software/gcc/)
* [GTK+](https://www.gtk.org/)
* [systemd](https://www.freedesktop.org/wiki/Software/systemd/)
* [cockpit](https://cockpit-project.org/)
* [FreeIPA](https://www.freeipa.org/)
* [libguestfs](http://libguestfs.org/)

as well as countless others. Some of these projects even contain entire
ecosystems of spawned child projects. (Everything in GNOME is the obvious
example.)

In my opinion, in addition to being highly elegant and innovative, these
projects all have two things in common:

1. They are all under copyleft licenses like the [GPL](https://en.wikipedia.org/wiki/GNU_General_Public_License).
2. They didn't receive as much drive from upper management as they deserved.

I can't prove these two points are related, and they might not be, but I can't
help think it's worth considering. Some theories:

* Internal, anti-copyleft rhetoric from some individuals persuaded management to
invest in alternate "permissively-licensed" technologies. There certainly are
many different internal views on licensing. It's well-known that there are both
[FSF](https://www.fsf.org/)-members and [ASF](https://www.apache.org/)-members
within Red Hat. The former generally prefer copyleft licensing, while the latter
generally prefer permissive licensing. It's extremely religious and political.

* Passionate developers who understand software better, prefer to spend and
invest their time on copyleft-licensed software where there is a greater chance
that future patches and their code won't be taken proprietary and hidden from
everyone. Good software engineers can get quite attached to their code, and
keeping it in the open can allow them to continue working on the project, even
if they've changed companies.

* Business partners convinced upper management that they were only interested in
permissive licensing. This way, they could build off of Red Hat's shoulders with
their proprietary forks, without having to release any of their added "secret
sauce". This feels very much like giving away a lot of value for free, without
much of a return on investment. I'm actually surprised the shareholders put up
with this, as I always thought it was an easy lawsuit. In fact, AFAICT, Red
Hat's own [Annual Reports](https://investors.redhat.com/financial-information/sec-filings)
and other filings only ever mentioned the GPL (copyleft) until _2016_, when it
suddenly changed a bunch of the text and added mention of the permissive ALv2
license.

{{< blog-paragraph-header "Investment in permissively-licensed projects" >}}

On the flip-side of things, Red Hat upper management has invested heavily in
many permissively-licensed projects. It's up to you to determine how much value
or revenue they have brought to the company. In general they were all more
recent endeavours:

* Openstack
* ManageIQ
* Ovirt / RHEV
* Docker
* Kubernetes
* Openshift
* Opendaylight

I'm extremely biased here, but I've found the top first list to be filled with
projects that I find extremely useful, and this second list with projects that
spend a lot of marketing dollars. What's good design and what is hype? I'm
curious to know if they've gotten a return on their investment in these.

Instead of doubling down and continuing the copyleft tradition, new management
very publicly pushed the "Open Source" terminology and focused more on
non-copyleft projects. [Some believe this to be very political](https://www.gnu.org/philosophy/open-source-misses-the-point.en.html),
where as others believe that "Open Source" is just toned-down, mainstream
nomenclature for ["Free Software"](https://www.gnu.org/philosophy/free-sw.html).
One thing I'm confident of is that you need a healthy balance between copyleft
and permissive, and it's clear to me that we lost that.

In any case, upper management *did* push a lot of top-down decisions onto
engineering and developing these permissively licensed projects. They invested
so much money into these ventures that it wasn't clear to me if we even saw a
return. To be clear, I'm not trying to disrespect OpenStack or Docker, there are
lots of very talented people working on these projects, but they both have some
enormous design flaws too.

Had things been left to engineering, I believe a traditional bottom-up approach
would have ensured a longer term, independent prosperity for Red Hat. It might
also have delayed a $34B dollar valuation, but it also could have cemented our
independence for another 25 years. This is the approach I hope future Red Hat or
IBM takes going forward. I'm a supporter, and an investor, and this is what I
believe would be good for my stock price and the world.

{{< blog-paragraph-header "Even more proof that modern Red Hat dislikes copyleft" >}}

Red Hat recently acquired a GPLv3-licensed piece of software named Ansible. In
general, I don't think this conflicts with my arguments that present-day Red Hat
prefers permissively-licensed software, because in general,
[copyleft doesn't usually apply](/blog/2017/10/17/copyleft-is-dead-long-live-copyleft/)
to automation software used in the Ansible manner.

The real proof comes when you look at how Red Hat released the previously
non-public (proprietary) components from the Ansible project. Instead of
licensing them consistently with the parent project (it would be unheard of not
to) they opted instead to release them as ALv2 (non-copyleft) instead. You can
[see for yourself](https://github.com/ansible/).

{{< blog-paragraph-header "Apart from history" >}}

I am incredibly biased.
[I recently left Red Hat.](/blog/2018/04/04/leaving-redhat/)
I'm not angry. I met a lot of great hackers there. But it was clear that the
bottom-up, engineer-driven, copyleft days were over, and I wanted to spend some
time trying to innovate on [something that I believed in](https://github.com/purpleidea/mgmt/).
My example is miniscule compared to the scope and engineer-years of some of the
top-mentioned copyleft projects, but it does fit the same pattern. (You can
support this effort by [sending me patches](https://github.com/purpleidea/mgmt/)
and [donating to my patreon](https://www.patreon.com/purpleidea)!)

{{< blog-paragraph-header "Did IBM just kill Red Hat?" >}}

No. Most of *my* favourite parts were already dead. When Red Hat switched all of
our company email to Gmail, it was a big nail in the coffin for many of us. If
we're lucky, there will now be less internal pressure on the Red Hat execs to
account for their previous investments, and they can instead focus on building
good products and saving IBM. It's surely hard work to constantly have to
justify yourself to short-term shareholders and instead focus on long term
goals. Red Hat is about _3%_ (by employee count) of IBM. Maybe that part can
hide away inside Big Blue, the same way some of the top Red Hat engineers hid
away inside Red Hat and directed some really great engineering.

{{< blog-paragraph-header "Conclusion" >}}

Red Hat was never special because "open source". Red Hat was special because
they proved copyleft could be a sustainable business model. This space is wide
open again. I look forward to seeing who and how many will take their place.

There are a lot of great engineers at Red Hat that steal away time to work on
projects that benefit both the public good and the company. Let's hope that this
work is still funded at IBM or that those individuals find new funders. I'm
happy to connect good developers that I know, to companies looking to support
their hacking should both parties [contact me](/contact/) and ask.

There's a small chance that the original, bottom-up, engineer-driven, copyleft
culture can spread inside IBM. If it does, I think it could benefit IBM. I'm
happy to consult on these crazy ideas if any of the 400k employees there would
like to ping me. I'm hoping for the best!

In the meantime, I'll still be using [Fedora](https://getfedora.org/) as long as
it plans on staying [honest](https://reproducible-builds.org/).

Happy Hacking,

James

{{< twitter-follow-purpleidea >}}
{{< patreon-support-purpleidea >}}
