+++
date = "2017-07-12 10:09:46"
title = "Extracting movies from libreoffice"
draft = "false"
categories = ["technical"]
tags = ["fedora", "file-roller", "gnome", "libreoffice", "ods", "planetfedora"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2017/07/12/extracting-movies-from-libreoffice/"
+++

I have a short movie that I imported into a <a href="https://libreoffice.org/">libreoffice</a> presentation. I wanted a copy of that movie back, but I couldn't figure out how to extract a copy. In desperation, I figured I'd try opening the file with <a href="https://wiki.gnome.org/Apps/FileRoller">file-roller</a>, the <a href="https://gnome.org/">GNOME</a> archive manager.

```
james@computer:/tmp$ file mgmt-berlin-osdc-17may2017.odp 
mgmt-berlin-osdc-17may2017.odp: OpenDocument Presentation
james@computer:/tmp$ mkdir out
james@computer:/tmp$ file-roller -f mgmt-berlin-osdc-17may2017.odp -e out/
[snip]
james@computer:/tmp$ cd out/
james@computer:/tmp/out$ ls
Configurations2/ Media/ meta.xml Pictures/ styles.xml
content.xml META-INF/ mimetype settings.xml Thumbnails/
james@computer:/tmp/out$
```
To my amazement, this worked perfectly! I found my video in the <em>Media/</em> folder, and out it came! You can do this entirely with the GUI if you prefer:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="file-roller-ods.png"><img class="alignnone size-full wp-image-2359" src="file-roller-ods.png" alt="file-roller-ods" width="100%" height="100%" /></a></td></tr><tr><td>This is the graphical view of file-roller, opening up a libreoffice <em>.ods</em> presentation file.</td></tr></table></br />

As you can assume, pictures are also available. I haven't cared to dig much further, but hopefully you enjoyed this tip!

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
