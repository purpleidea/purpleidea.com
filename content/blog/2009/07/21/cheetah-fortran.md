+++
date = "2009-07-21 16:59:50"
title = "cheetah == fortran"
draft = "false"
categories = ["technical"]
tags = ["cheetah", "fortran", "programming", "python"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/07/21/cheetah-fortran/"
+++

turns out the <a href="http://www.cheetahtemplate.org/">cheetah</a> python templating engine (2.0 since year 2006) is quite reminiscent of <a href="http://en.wikipedia.org/wiki/Fortran">fortran</a> (since the 1950's) in their use of the <strong>#slurp</strong> directive (cheetah) and the <strong>$</strong> string. either one, when appended to the end of a string, remove the implicit newline which usually gets printed. it took me ages to figure out how to suppress newline printing back when i did someone's fortran homework, now i've had to struggle with it all over again.

i'm not a language designer, but it never seemed like the best idea to me! but what do i know? i hope this saves someone an hour of searching.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
