---
title: "Mgmt Config"
image: "mgmt-config.png"
ordering: "a"
draft: false
---

After having spent well over five years using and writing
[Puppet](https://en.wikipedia.org/wiki/Puppet_(software)), I decided that I had
some designs for a next generation automation tool. This eventually became what
is now known as [`Mgmt Config` or `mgmt`](https://github.com/purpleidea/mgmt/).

{{< blog-image src="graph8.png" caption="Mgmt runs as a distributed system." scale="50%" >}}

The project has a number of novel features, including an event-based execution
engine, a reactive domain specific language (DSL) and the ability to execute in
parallel. A cluster of `mgmt` agents can self-coordinate and run as a
distributed system using the [`raft`](https://en.wikipedia.org/wiki/Raft_(computer_science))
consensus algorithm.

<table><tr><td>
{{< blog-image src="autogroup1.png" caption="Mgmt can automatically transform this..." scale="100%" >}}
</td><td>
{{< blog-image src="autogroup2.png" caption="...into this more efficient version!" scale="100%" >}}
</td></tr></table>

Mgmt uses special graph theory algorithms to analyze and transform the stream of
execution graphs that are produced when running the DSL. As a result, the work
done is safer, more intelligent, and maximally efficient.

### Speaking and Sharing

Mgmt has been shared at a number of conferences all over the world.

<table><tr><td>
{{< blog-image src="speaking1.png" caption="James showing off some lives demos of mgmt." scale="100%" >}}
</td><td>
{{< blog-image src="speaking2.png" caption="A full-house for James giving an mgmt talk." scale="100%" >}}
</td></tr></table>

It has received great feedback and code submissions from over *75* unique
contributors. [A list with both recordings and ratings is available here.](https://purpleidea.com/talks/)

### Project page

The entire source code and main project page is
[available here](https://github.com/purpleidea/mgmt/).
