+++
date = "2016-07-18 16:41:47"
title = "Ten minute hacks: Hacking airplane headphones"
draft = "false"
categories = ["technical"]
tags = ["airplane", "audio", "devops", "fedora", "figure eight", "hack", "hacks", "headphones", "negative", "planetdevops", "planetfedora", "planetfreeipa", "planetipa", "planetpuppet", "positive", "puppet", "splice", "stereo", "ten minute hacks"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/07/18/ten-minute-hacks-hacking-airplane-headphones/"
+++

I was stuck on a 14 hour flight last week, and to my disappointment, only one of the two headphone speakers were working. The plane's media centre has an audio connector that looks like this:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="airplane-headphones-jack.jpg"><img class="wp-image-1856 size-large" src="airplane-headphones-jack.jpg" alt="airplane-headphones-jack" width="100%" height="100%" /></a></td></tr><tr><td> Someone should consider probing this USB port.</td></tr></table></br />

The hole to the left is smaller than a 3.5mm headphone jack, and designed for a proprietary headphone connector that I didn't have, and the two holes to the right are part of a different proprietary connector which match with the cheap airline headphones to provide the left and right audio channels.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="airplane-headphones-connected.jpg"><img class="wp-image-1855 size-large" src="airplane-headphones-connected.jpg" alt="airplane-headphones-connected" width="100%" height="100%" /></a></td></tr><tr><td> Completely reversible, and therefore completely ambiguous. <a href="https://en.wikipedia.org/wiki/Stereophonic_sound#History">Stereo is so 1880's anyways.</a></td></tr></table></br />

By reversing the connector, I was quickly able to determine that the headphones were not faulty, because this swapped the missing audio channel to the other ear. It's also immediately obvious that since there are no left vs. right polarity markings on either the receptacle or the headphones, there's a 50% chance that you'll get reverse stereo.

With the fault identified, and lots of time to kill, I decided to try to hack a workaround. I borrowed some tweezers from a nearby passenger, and slowly ripped off some of the exterior plastic to expose the signal wires. To my surprise there were actually four wires, instead of three using a shared ground.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="airplane-headphones-separated.jpg"><img class="wp-image-1852 size-large" src="airplane-headphones-separated.jpg" alt="airplane-headphones-separated" width="100%" height="100%" /></a></td></tr><tr><td> Headphone wires stripped, exposed and ready for splicing.</td></tr></table></br />

With a bit of care this only took about five minutes. The next step was to "patch" the working positive and ground wires from the working channel, into the speaker from the broken channel. I did this by trial and error using a bit of intuition to try to keep both speakers in phase.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="airplane-headphones-spliced.jpg"><img class="wp-image-1854 size-large" src="airplane-headphones-spliced.jpg" alt="airplane-headphones-spliced" width="100%" height="100%" /></a></td></tr><tr><td> After a twist splice and using paper as an insulator.</td></tr></table></br />

A small scrap of paper acted as an insulator to prevent short circuits between the positive and negative wires. Lastly, a <a href="https://en.wikipedia.org/wiki/Figure-eight_loop">figure eight on a bight</a> was tied to isolate the weak splice from any tension, thus preventing damage and disconnects.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="airplane-headphones-knotted.jpg"><img class="wp-image-1853 size-large" src="airplane-headphones-knotted.jpg" alt="airplane-headphones-knotted" width="100%" height="100%" /></a></td></tr><tr><td> All wrapped up neatly and tied with a knot.</td></tr></table></br />

The finished product worked beautifully, despite now only providing <a href="https://en.wikipedia.org/wiki/Monaural">monaural</a> audio and is about five centimetres shorter, which is still perfectly usable since the seats hardly recline. The flight staff weren't angry that I had cannibalized their headphones, but also didn't understand how my contraption was able to solve the problem.

This fun little ten minute hack helped provide some distraction in economy class, and maybe it will be useful to you since I doubt they've repaired the media system in the seat! If you work for Emirates, let me know and I'll give you the seat and flight number.

Happy hacking!

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
