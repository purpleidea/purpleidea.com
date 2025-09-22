+++
date = "2010-02-03 12:25:08"
title = "getopt vs. optparse vs. argparse"
draft = "false"
categories = ["technical"]
tags = ["argparse", "getopt", "ivan", "optparse", "programming", "python"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2010/02/03/getopt-vs-optparse-vs-argparse/"
+++

sooner or later you'll end up needing to do some argument parsing. the foolish end up writing their own yucky parser that ends up having a big if statement filled with things like:

<code>if len(sys.argv) &gt; 1</code>

in it. don't do this unless you have a <b>really</b> good excuse.

sooner or later, someone directs you to <a href="http://docs.python.org/library/getopt.html">getopt</a>, and you happily continue on with buggy manual parsing thinking you've "<i>found the way</i>". useful in some circumstances, but should generally be avoided.

since you're a good student, you read the docs, and one chapter later, you find out about <a href="http://docs.python.org/library/optparse.html">optparse</a>. higher level parsing! alright! the library that we all wanted to write, actually exists, and it seems to follow some <a href="http://docs.python.org/library/optparse.html#background">ideals</a> too. this i actually appreciate, and it <i>is</i> lovely to use. you dream about all programs using this common library and unifying the world. consistency is a dream.

you then remember that the positional syntax of cp, git, man, and friends actually <i>does</i> makes sense, and you'd like for them not to change. you go on with life, hacking up optparse when needed. everything is pretty good, and you're a seasoned coder by now, but sooner or later, someone sets you straight with a nice blog post like this.

there's a new kid in town, and it's called <a href="http://code.google.com/p/argparse/">argparse</a>. you read the docs, and you promise yourself to use standard argument styles. subparsers, and types finally exist in a sensible way. you love the inheritance schemes, and you're one step away from being able to complete your parsing code, but you still haven't found that magic place in the manual that hides the precious answer you need. and now you <a href="http://argparse.googlecode.com/svn/tags/r101/doc/other-methods.html#sub-commands">have</a> (probably the fourth code block down from that link- maybe also the fifth). why this way buried in with the api specs, i don't know, but i'm glad it was there.

thanks to <a href="http://www.cs.mcgill.ca/~isavov/">ivan</a> for getting me to check out argparse in the first place.

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
