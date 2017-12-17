+++
date = "2016-07-18 16:41:47"
title = "Ten minute hacks: Hacking airplane headphones"
draft = "false"
categories = ["technical"]
tags = ["ten minute hacks", "fedora", "hacks", "planetfreeipa", "devops", "negative", "planetdevops", "airplane", "positive", "planetipa", "figure eight", "planetpuppet", "headphones", "hack", "planetfedora", "puppet", "splice", "stereo", "audio"]
author = "jamesjustjames"
+++

I was stuck on a 14 hour flight last week, and to my disappointment, only one of the two headphone speakers were working. The plane's media centre has an audio connector that looks like this:

[caption id="attachment_1856" align="aligncenter" width="584"]<a href="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-jack.jpg"><img class="wp-image-1856 size-large" src="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-jack.jpg?w=584" alt="airplane-headphones-jack" width="584" height="779" /></a> Someone should consider probing this USB port.[/caption]

The hole to the left is smaller than a 3.5mm headphone jack, and designed for a proprietary headphone connector that I didn't have, and the two holes to the right are part of a different proprietary connector which match with the cheap airline headphones to provide the left and right audio channels.

[caption id="attachment_1855" align="aligncenter" width="584"]<a href="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-connected.jpg"><img class="wp-image-1855 size-large" src="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-connected.jpg?w=584" alt="airplane-headphones-connected" width="584" height="779" /></a> Completely reversible, and therefore completely ambiguous. <a href="https://en.wikipedia.org/wiki/Stereophonic_sound#History">Stereo is so 1880's anyways.</a>[/caption]

By reversing the connector, I was quickly able to determine that the headphones were not faulty, because this swapped the missing audio channel to the other ear. It's also immediately obvious that since there are no left vs. right polarity markings on either the receptacle or the headphones, there's a 50% chance that you'll get reverse stereo.

With the fault identified, and lots of time to kill, I decided to try to hack a workaround. I borrowed some tweezers from a nearby passenger, and slowly ripped off some of the exterior plastic to expose the signal wires. To my surprise there were actually four wires, instead of three using a shared ground.

[caption id="attachment_1852" align="aligncenter" width="584"]<a href="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-separated.jpg"><img class="wp-image-1852 size-large" src="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-separated.jpg?w=584" alt="airplane-headphones-separated" width="584" height="438" /></a> Headphone wires stripped, exposed and ready for splicing.[/caption]

With a bit of care this only took about five minutes. The next step was to "patch" the working positive and ground wires from the working channel, into the speaker from the broken channel. I did this by trial and error using a bit of intuition to try to keep both speakers in phase.

[caption id="attachment_1854" align="aligncenter" width="584"]<a href="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-spliced.jpg"><img class="wp-image-1854 size-large" src="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-spliced.jpg?w=584" alt="airplane-headphones-spliced" width="584" height="438" /></a> After a twist splice and using paper as an insulator.[/caption]

A small scrap of paper acted as an insulator to prevent short circuits between the positive and negative wires. Lastly, a <a href="https://en.wikipedia.org/wiki/Figure-eight_loop">figure eight on a bight</a> was tied to isolate the weak splice from any tension, thus preventing damage and disconnects.

[caption id="attachment_1853" align="aligncenter" width="584"]<a href="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-knotted.jpg"><img class="wp-image-1853 size-large" src="https://ttboj.files.wordpress.com/2016/07/airplane-headphones-knotted.jpg?w=584" alt="airplane-headphones-knotted" width="584" height="779" /></a> All wrapped up neatly and tied with a knot.[/caption]

The finished product worked beautifully, despite now only providing <a href="https://en.wikipedia.org/wiki/Monaural">monaural</a> audio and is about five centimetres shorter, which is still perfectly usable since the seats hardly recline. The flight staff weren't angry that I had cannibalized their headphones, but also didn't understand how my contraption was able to solve the problem.

This fun little ten minute hack helped provide some distraction in economy class, and maybe it will be useful to you since I doubt they've repaired the media system in the seat! If you work for Emirates, let me know and I'll give you the seat and flight number.

Happy hacking!

James

