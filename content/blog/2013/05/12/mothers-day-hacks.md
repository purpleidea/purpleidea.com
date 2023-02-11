+++
date = "2013-05-12 07:32:45"
title = "Mothers day hacks"
draft = "false"
categories = ["technical"]
tags = ["bash", "google doodle", "hack", "mothers day", "pgo", "rube goldberg", "shell"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/05/12/mothers-day-hacks/"
+++

Firstly Happy Mother's day to my mother.

Google is, as usual, busily releasing <a href="http://www.google.com/doodles/">doodles</a>. Today, the doodle takes you through a <a href="https://en.wikipedia.org/wiki/Rube_Goldberg">Rube Goldberg</a> -esque sequence, giving you four decisions to make along the way. Each decision gives you one of three different choices, and at the end, a unique drawing is displayed. I expect:
```
3 * 3 * 3 * 3 = 81
```
different permutations. At the end of the process, you can print your image. I got directed to:

<a href="https://www.google.ca/logos/2013/mom/print/3311.html">https://www.google.ca/logos/2013/mom/print/3311.html</a>

which suspiciously has a four digit filename composed of three's and ones. Inspecting the file in firefox shows that the main image url is:

<a href="https://www.google.ca/logos/2013/mom/hdcards/3311.jpg">https://www.google.ca/logos/2013/mom/hdcards/3311.jpg</a>

with a similarly suspicious "<em>3311</em>". I decided that I wanted to see all the permutations without having to refresh google's page. Jumping to a terminal, and using some bash expansion magic:
```
$ cd /tmp
$ mkdir hack1
$ cd hack1/
$ wget https://www.google.ca/logos/2013/mom/hdcards/{1..3}{1..3}{1..3}{1..3}.jpg
[snip]
FINISHED --2013-05-12 07:07:22--
Total wall clock time: 1m 23s
Downloaded: 81 files, 138M in 1m 19s (1.75 MB/s)
```
I am pleased to see that 81 files have downloaded, and that they're all unique:
```
$ md5sum * | sort | uniq | wc -l
81
```
and all png's:
```
$ file * | awk '{print $2}' | sort | uniq | wc -l
1
$ file * | head -1
1111.jpg: JPEG image data, EXIF standard
```
Now I can very easily browse through the images with eog, and select my favourite.

Hope this has been instructive,

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
