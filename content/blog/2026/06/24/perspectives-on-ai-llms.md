---
# get with: `date --rfc-3339=seconds`
date: 2026-06-24 04:35:00-04:00
title: "My perspectives on AI/LLMs"
description: "My analysis and experiences using AI/LLMs"
categories:
  - "non-technical"
tags:
  - "ai"
  - "config management"
  - "copyleft"
  - "copyright"
  - "developer tools"
  - "devops"
  - "fedora"
  - "free software"
  - "golang"
  - "llm"
  - "mgmt"
  - "mgmtconfig"
  - "open source"
  - "performance"
  - "planetfedora"
  - "software engineering"
  - "testing"
draft: false
---

There's a lot of talk about "AI" and "LLMs" recently. Here are my thoughts,
experiences, and perspectives about all that. There seems to be a growing rift
in the software industry about these tools. I'm publishing this post to make my
opinions as clear as possible. Of note, I've provided specific git commit
examples of some interesting results I've had when using these models.

<br />
{{< blog-image src="watercolour.png" caption="Watercolour painted by a human artist." scale="100%" >}}

{{< blog-paragraph-header "Background" >}}

For a very long time, I have been, and still am, a strong Free Software
advocate. Everyone who knows me knows what I stand for. I'm about actions and
results, not just talk. I've spent a great amount of personal time and money
[writing Free Software](https://github.com/purpleidea/mgmt/) because I believe
it's an important thing that our society needs. Without the four freedoms, we
empower hegemons to control our computing, our data and our lives. AI and LLMs
will accelerate our demise or uplift us. Let's be smart about this.

<br />
{{< alert type="danger" >}}
The bad...
{{< /alert >}}

{{< blog-paragraph-header "Copyright" >}}

All of the usable "frontier" models that produce interesting results were
trained on millions of copyrighted (both permissive and copyleft) works. When I
write software like [mgmt](https://mgmtconfig.com/) I give it away for free. The
catch is that it comes with both a social and legal obligation that derivative
works must also be "Free". I'm glad that the world's corpus of knowledge can be
used to produce innovative breakthroughs, but the fruit must be used to benefit
the world; it must not be opaque, closed, or controlled by just one or two U.S.
companies. The remediations are simple. From basic to impactful:

1. Mandate that the companies release the full corpus of training data
2. Mandate that the companies release the full model weights
3. Mandate that the companies release the full (algorithmic) code for training
and inference

NOTE: There are more subtleties here in terms of fine-tuning and other aspects,
but we'll keep it simple for now.

{{< blog-paragraph-header "Copyright Washing" >}}

This happens when someone uses AI/LLM tooling to "reimplement" a project and
releases it under a different license with different copyright holders. Often
this also changes the language of implementation, but that is not required. This
entirely negates the force of [copyleft](https://en.wikipedia.org/wiki/Copyleft)
and should be an illegal practice. I think this is substantially different from
the [clean-room](https://en.wikipedia.org/wiki/Clean-room_design) approach. It
is quite different because it innately relies on the patterns and test cases in
the original work to build the transformed derivative. By all sane and not
corrupt interpretations, it must be seen as a derivative work and copyleft must
apply. Unfortunately the legal systems of most countries have not caught up to
the advances in technology, so we'll need your help to encourage your
political representatives to do the right thing.

{{< blog-paragraph-header "Environmental" >}}

There are legitimate concerns about the environmental cost of all the energy
required to train and run these models. Overall I think the issues are related
to government policy failures in moving more quickly toward renewable energy
sources. There's plenty of sunshine around the world for all our near-term
needs, and hopefully we'll use more of it to power our world. Using gas turbines
to power data centres is horrendous.

{{< blog-paragraph-header "Price" >}}

It's not clear how significantly the models are being subsidized, but they
clearly are, and at some point cheap inference is going to be a lot harder to
find. Hopefully the open source models will get a lot better before all but the
biggest companies get priced out.

If you don't believe me, try using any of the frontier models via the Amazon
Bedrock API rather than your personal subscription. You'll likely be paying 10x
what you might normally pay. This is what many companies already shell out.

I've found it incredibly hard to figure out exactly "what you're paying for" in
terms of tokens when using one of the mainstream subscriptions. The companies
are very opaque about this, and I'm sure it's not an accident.

{{< blog-paragraph-header "Sneaky Dealing" >}}

It's also not clear how much they throttle performance (due to demand) and when
and why they degrade the service. It's hard to measure because these workloads
are stochastic, but my personal belief is that it's absolutely happening. I
don't have enough data on this.

After Anthropic's "Fable" was revoked, my subsequent use of "Opus 4.8" felt
significantly "dumber". No, I don't think this is a perception bias, because I
used "Fable" only briefly, but I saw concrete mistakes using "Opus 4.8" that I
never saw in any of my earlier "Opus" use.

It needs to be illegal to keep any of these practices opaque. We need strong
whistleblower laws that reward the reporter with a percentage of the fine when
these infractions are found to be occurring.

{{< blog-paragraph-header "Trust" >}}

The harness that the model uses locally in your development environment needs to
be 100% open source. We must not allow proprietary tools to invade our machines.
We need to be able to trust our local tools to protect our systems and data from
third-party abuse. We don't want them leaking private data or running amok. The
biggest offender here is Anthropic. Their tool (Claude Code) works the best, but
is officially still proprietary. They encrypt a lot of the "thinking" data and
are playing games with how you use their tool. In contrast OpenAI has a tool
(Codex) which is open source. Unfortunately the quality isn't as good. Hopefully
it will get better.

{{< blog-paragraph-header "Privacy" >}}

All of your code, thought processes, and more are not private at all when using
these systems. I guarantee that companies and governments are using this data
you send them for anti-competitive business intelligence and more. They'll claim
otherwise, but that much good quality information never goes unharvested. We'll
need serious laws and penalties for those that breach these protections, but the
only long-term solution is running local model inference.

These systems are ideal data-gathering machines for any organization or country
that wants to be a hegemon, and also an amazing tool for processing large
amounts of data. AI/LLMs can let you build human-readable queries to search for
political opponents, business competitors and more. Don't let them get away with
this.

{{< blog-paragraph-header "Learning" >}}

I was once worried that the "new generation" of software developers would start
from a younger age than I did, and would quickly surpass me. That fear proved
unfounded because while in my youngest years I read paper books and learned how
basic computing works, the new generation learned how to "swipe" on a screen and
consume proprietary products without exploration. I never felt surpassed.

I spent years grinding without any AI/LLM assistance. I suffered. I worked long
nights. I moved printf statements around and recompiled incessantly. I learned.
So many juniors (and seniors) take the "easy out" and let the tool "get the
answer". This is bad because you don't learn the art yourself, and if you do
learn anything, you may learn something sub-optimal from a model!

If you're starting a career in software engineering, I recommend that you avoid
these tools for at least five years. If you're more experienced, make sure you
keep exercising your skills, or you *will* lose them. Be diligent, don't be
lazy.

I don't merge a single line of slop. I carefully review and edit everything. I
hope you do the same. There's a belief that reinforcement learning on
machine-generated code leads to eventual model collapse. If this is true, and we
don't polish our code significantly, then we'll hit a future plateau we won't be
able to surpass.

{{< blog-paragraph-header "Art" >}}

I personally don't like the so-called "art" being generated. (I'm not talking
about code, even though I consider a lot of that to be art.) I don't even like
the [CGI](https://en.wikipedia.org/wiki/Computer-generated_imagery) in most
movies, so perhaps I'm more sensitive here. I don't want to read
AI/LLM-generated books or poems, or listen to generated music. I most recently
hired a graphic designer to "manually" draw me a logo. Push back on this kind of
thing and we'll be fine.

{{< blog-paragraph-header "Worker displacement" >}}

This tooling will put many people out of a job, particularly the lower-skilled
workers who don't have the experience to know when to push back on sub-optimal
code or who don't know how to direct the models to get the correct architectural
result. They'll also create new jobs as the reach of computing expands even
further.

We're going through a big upheaval.

{{< blog-paragraph-header "AI Safety" >}}

There's a growing number of people working on "AI safety". A friend of mine is a
world-class programmer, AI safety activist, and much-appreciated mgmt
contributor. He has written some great interactive blog posts about this. Please
read: [https://gelisam.blogspot.com/](https://gelisam.blogspot.com/) for more!

There are some nice interactive demos too:

[https://gelisam.com/ai-safety-via-static-analysis/](https://gelisam.com/ai-safety-via-static-analysis/)

My personal belief is that there are genuine AI safety concerns on the horizon,
but the "[singularity](https://en.wikipedia.org/wiki/Technological_singularity)"
is not the most immediate threat. That doesn't mean we shouldn't study and
prepare for this scenario. We should be vigilant and constantly re-evaluating.
Hopefully these tools aren't used to try to win a global war.

The near-term dangers that I see revolve around single-country control and the
extinction of the commons. The above paragraphs detail some of these points. The
biggest worry is that of asymmetric power.

<br />
{{< alert type="warning" >}}
The reaction...
{{< /alert >}}

{{< blog-paragraph-header "Fear" >}}

The reactions have been extremely polarized. This has been a major technological
leap, and many do not understand the implications of what's happening, and how
quickly it is moving. I'm lucky that I think I understand what's going on. I
know many people with misperceptions about what's happening. Some are scared.
Some are angry. Many people feel angry, scared and powerless.

Some of the least qualified elevator operators are going to need to find a new
career and the worst thing is that all of those lift operations are currently
being handled by only one or two vendors. People are rightfully upset. They are
not just reacting to the technology itself; they are reacting to the
concentration of power around it.

That reaction is reasonable. A lot of workers are being told that tools trained
on the public commons, including copyleft software, may now be used to replace
or devalue their labour. Worse, the most powerful versions of these tools are
controlled by a small number of vendors in a single country.

Try to lead with empathy. Don't force tool use, and do be an effective ally and
work to solve the problems above: openness, privacy, copyright, trust, and
control. If we tackle these problems, I think everyone will breathe a huge sigh
of relief.

For the moment I'm trying to take the approach that we can also use this to
build more (slop-free, high-quality) Free Software. I'd like to continue with
some precise examples.

<br />
{{< alert type="success" >}}
The good...
{{< /alert >}}

{{< blog-paragraph-header "Motivation" >}}

We've all had that annoying bug that was painful to track down. Or that feature
branch we just couldn't find motivation to finish. Sometimes you just feel
overwhelmed with the task at hand. All of this is normal and okay. I've felt
this way too. What surprised me is how much AI/LLMs helped in this area. I've
been able to fearlessly destroy errant bugs, tough performance challenges, and
perform big pathfinding research that would have otherwise been too expensive a
task for me to undertake!

Some of the "less fun" bits of code, I'll leave entirely up to LLMs. Do I really
care about debugging a `Makefile` issue?

{{< blog-paragraph-header "Languages" >}}

Statically typed languages that are simpler, faster to compile and iterate on
are simply better for AI/LLMs. I think that `golang` is a perfect fit here.
There's a strong case for even more strongly typed languages like `haskell`. If
I was proficient in `haskell`, I'm sure I'd have an even greater delta increase
of productivity. What's abundantly clear is that continuing to use `python` is
not a good long-term strategy. I'd also argue that the use of `rust` makes
overall development speed slower. (Only use `rust` if you absolutely need that
kind of low-level optimization. `Rust` should only be replacing `C` and `C++`.)
For most programming uses today, I think `golang` is a good choice for most new
projects. Too many choose the "language they want to work with" (eg: the one
they want to learn for their next job/career) rather than the "right language
for the job".

[Here's a recent interview from Simon Peyton Jones saying the same thing.](https://www.youtube.com/watch?v=xcB_LF3cdqw&t=4285s)
(I wouldn't specifically recommend this interview but it's a good SPJ source.)

{{< blog-paragraph-header "Testing" >}}

Most people don't enjoy writing tests. I'm one of those people. What I mostly
care about when testing is whether the code base changes or not.

I'll confess: I'm even okay with merging tests which are "slightly slop". It's
my one exception. They're usually stand-alone functions, so the overall code
quality doesn't matter too much. You likely also need some well-written test
harnesses too, so don't skimp everywhere! But if you want to move forward
quickly, I'll totally merge an entirely AI/LLM-written test if I think it
enforces a new invariant on my code.

One caveat: absolutely do not merge tests that aren't correct! Future model use
can read these tests and assume you wish to enforce a certain invariant which
was unintended. As a result, this can prevent you from generating the "correct"
code. Sometimes you can work around this by telling the models to ignore the
tests, or by telling them that part of the goal is to find any "broken" tests.

In one amazing example, I had a strange send/recv bug which I couldn't quite
figure out. Attempts at asking the models to fix the bug were not successful.
My personal attempts at reproducing the bug took a lot of time, and it wouldn't
always trigger. I then decided to ask the AI/LLMs to try to at least write a
reproducible test case to trigger the bug. (This test would naturally fail!)
To my surprise and delight, this worked perfectly, and by inspecting the test, I
was then able to quickly write the actual fix myself!

[e381043f8b10e4b7f509fc9c6b9fd0a2e47bc1bc](https://github.com/purpleidea/mgmt/commit/e381043f8b10e4b7f509fc9c6b9fd0a2e47bc1bc)

{{< blog-paragraph-header "Bugs" >}}

AI/LLMs are incredibly good at finding and fixing bugs. A recent example: A user
reported an unusual error that I had never seen before. They had already
attempted to debug this themselves by looking at dbus traces and much more. I
believe they were into it for several hours when they reached out for help.
*While simultaneously screen sharing with them to debug the issue*, I decided to
paste the issue into `Claude Opus 4.7` and `Codex GPT 5.5` and I had a working
fix in less than five minutes. The model referenced the source of the issue
which I had overlooked in the docs. I confirmed the analysis and the fix, and it
was merged shortly after. All the details are here if you're curious:

[28d81c6a06c30f263182f66e0a9dac91ae50d5c5](https://github.com/purpleidea/mgmt/commit/28d81c6a06c30f263182f66e0a9dac91ae50d5c5)

For over a month, I'd been occasionally hitting a rare heisenbug. I didn't know
what caused it, and in order to reproduce it, the setup was quite involved. It
would take quite a long time to iterate through the debugging loop, and to be
quite honest, I was borderline depressed thinking about this challenge that I
didn't know how to approach. The bug only appeared in a complex "distributed
systems" scenario, and that was non-trivial to reproduce.

Verifying the fix was trivial. It turned out to be in one of my least favourite
parts of the code, the complex graph shape functions. The diff is beautiful. It
even patched the "explainer comments" that we had written to remind ourselves of
how this function worked. It also patched the same bug in a different function.
This was a turning point for me.

[2266c3c8e9f0cce1960f54a4ce23c516c847b074](https://github.com/purpleidea/mgmt/commit/2266c3c8e9f0cce1960f54a4ce23c516c847b074)

{{< blog-paragraph-header "Quality" >}}

The models are exceptionally useful tools. If you can't accept that, then you
are most likely "holding them wrong". I've noticed that I get better results
when I'm working within what I would call a "higher quality" code base. If
you're building within a badly structured, architecturally poor, bug-ridden slop
project, expect to generate more of the same. Everyone who invested in quality
in the past, is getting a payoff today.

The two commits below were virtually entirely generated from an LLM prompt. If
you compare them to the existing (hand-written) functions in the same folder,
you'll see they have an uncanny similarity. The models can match the code and
commenting style of your existing project.

I personally find this kind of graph shape logic very difficult to write, so
this easily saved me a week of procrastination and suffering.

[8290310fc46b5431cb6162fc4d6ae531158dfe85](https://github.com/purpleidea/mgmt/commit/8290310fc46b5431cb6162fc4d6ae531158dfe85)
[49e98ddae3ac3cf2bcf1307c3d5f7cd92ae14396](https://github.com/purpleidea/mgmt/commit/49e98ddae3ac3cf2bcf1307c3d5f7cd92ae14396)

{{< blog-paragraph-header "Algorithmic Problems" >}}

I'm personally a terrible algorithmist. But I can definitely measure performance
and write and run tests! Sometimes if I'm stuck, I'll ask a model to help me
out! Here's an example of where I wasn't sure about the `yacc` precedence tables
and I wanted help writing new tests (that I could verify) and fix issues:

[ea32b8aea793fb97eabbe9ef7276ad6d07586989](https://github.com/purpleidea/mgmt/commit/ea32b8aea793fb97eabbe9ef7276ad6d07586989)

{{< blog-paragraph-header "Research and Pathfinding" >}}

I've also used the models to perform "research" to quickly explore a particular
approach which would have otherwise possibly led me down multiple dead ends. I
can then look at the code, learn about some of the implications, and then work
on polishing it or exploring a different avenue!

In a similar vein, I've been pondering a few refactors, which might change quite
a lot of lines of code. Instead of embarking head-first, I asked the AI/LLM
tools to explore them. I was then able to determine if the implications were
worth it or not. This took very little effort and provided a lot of value.

{{< blog-paragraph-header "Specification Loops" >}}

When I implemented the "etcd/fs" package, I knew that I surely gotten many of
the "POSIX" semantics wrong. Since I was the only consumer, and I knew the
extent of the API surface that I needed, I didn't dwell on those issues, and
decided to leave those potential bugs for "future James"! To my delight, that
work became much easier. I asked the AI/LLM to find issues with the code, then
*first* write a test case (that should fail), *then* write and merge the fix,
*then* confirm the test now passed, and then continue with the next fix. In
about an hour or so, it had generated about `18` separate commits, each with a
proper test and fix. It was a joy to watch.

From: [b676e7fa3ba3a5833d1acaa72961d43042eba62a](https://github.com/purpleidea/mgmt/commit/b676e7fa3ba3a5833d1acaa72961d43042eba62a)
To: [defcbfe84ce3995092208b295ceafc68e1c0a120](https://github.com/purpleidea/mgmt/commit/defcbfe84ce3995092208b295ceafc68e1c0a120)

View the whole range with:

`git log cfa6366650e5aefc9cc43dc53389ba6ddb6877ab..defcbfe84ce3995092208b295ceafc68e1c0a120`

{{< blog-paragraph-header "Performance" >}}

LLMs are amazing at performance engineering. They can even parse `*.pprof` files
and perform flamegraph analysis. In one example, I knew I wanted to improve the
performance of my `mgmt deploy` operations. I could have dug into it myself, but
it would have been a long ordeal. I manually performed the `pprof` collection,
and then put the tool to work. This resulted in a 500% speedup!

[cfa6366650e5aefc9cc43dc53389ba6ddb6877ab](https://github.com/purpleidea/mgmt/commit/cfa6366650e5aefc9cc43dc53389ba6ddb6877ab)

In another scenario, I increased performance, and reduced memory use and
allocations by roughly 20% to 100%. This is huge, especially for the
amount of effort it required.

[a0649911ef17f120a37db1685c8afe0a0fd72fdf](https://github.com/purpleidea/mgmt/commit/a0649911ef17f120a37db1685c8afe0a0fd72fdf)

I've even had more recent successes. Check out the latest
[release notes](https://github.com/purpleidea/mgmt/releases/tag/1.1.0) for more
examples of performance engineering wins. They know how to run `benchstat` too!

<br />
{{< alert type="blue" >}}
Looking to the future...
{{< /alert >}}

{{< blog-paragraph-header "But Proprietary..." >}}

The most extreme or vocal anti-AI/LLM protesters would be wise to at least
remember Stallman's essay. He used proprietary compilers:
[https://www.gnu.org/philosophy/when-free-depends-on-nonfree.html](https://www.gnu.org/philosophy/when-free-depends-on-nonfree.html)
He is certainly an imperfect human, but there is a lesson here worth knowing. I
personally believe that I'm having a net benefit to the world of software
freedom. We don't win because we're more Free, we win because we're better. Use
the resources that you can to produce higher quality, safer, more Free Software!

{{< blog-paragraph-header "Diminishing Returns" >}}

Are the models getting better at a linear rate? Exponential? Is it logarithmic?
It's not clear to me, but I wouldn't be surprised if it's sub-linear, at least
for the next short while. I suspect we'll need some or all of the below before
we see a major jump that should make us fear the impending singularity doom...

1. Better data

We'll need better-curated compendia of data. If you look at what's being used
today, there are large amounts of garbage that go into training the models. It's
almost amazing how robust they are to this already. Curation keeps improving. It
is a major risk to be opaque about that process, since some groups will try to
encode their values (for proselytizing) which are not universal.

2. Better algorithms

The transformer architecture was a big revolution for the current models. I
expect we'll see another big jump when we find out what follows. Some people are
already working on this.

3. More power and compute

Will we need nuclear fusion? Will we need room-temperature semiconductors? Will
we need quantum computers? By the time all three of those have been "solved" to
a first approximation, I'd wager we should be on the lookout for a practical
singularity.

{{< blog-paragraph-header "Why?" >}}

I'm bullish on AI/LLMs because I want to accelerate human progress. I want to
accelerate science and learn more about
[fundamental physics](https://en.wikipedia.org/wiki/Theory_of_everything). I
want to cure diseases like cancer and [aging](https://en.wikipedia.org/wiki/Senescence).
It's why we're here. These answers are possible in our lifetimes.

<br />
{{< alert type="info" >}}
The conclusion...
{{< /alert >}}

{{< blog-paragraph-header "Conclusion" >}}

These tools are dangerous when opaque and centralized, useful when carefully
reviewed, and most valuable when used to produce better Free Software. Join me!

This blog post was written 100% by hand. I hope it was interesting for you to
read. I hope it will be a useful "sign to tap" if trolls ever accuse me of slop
or anything less than a commitment to advancing high-quality Free Software. I
hope the specific examples have been interesting to you. They were beautiful
discoveries for me.

[I've just released a new version of mgmt.](https://github.com/purpleidea/mgmt/releases/tag/1.1.0)
I think it's the highest quality release I've ever put out, and AI/LLM tooling
was certainly part of helping me achieve that. Give it a try and tell me if you
agree!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
