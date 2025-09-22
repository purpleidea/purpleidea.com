+++
date = "2013-02-04 10:56:35"
title = "How to send and receive files like a professional"
draft = "false"
categories = ["technical"]
tags = ["devops", "droopy", "dropbox", "icq", "pgo", "python", "receive-file", "send-file", "simplehttpserver", "ssl", "woof"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/02/04/how-to-send-and-receive-files-like-a-professional/"
+++

Everyone needs to send and receive files sometimes. Traditionally people send files as email attachments. This still works great, and supports encryption, but many mail servers are slow and cap the upper file size limit.

ICQ was a great solution back in the 1990's, but those days are now over. (I still remember my number.)

A lot of folks use dropbox, which requires a dropbox account, and for you to trust them with your files.

If you want a simple solution that doesn't need internet access (if you're on a LAN, for example) you can use <a href="http://stackp.online.fr/?p=28"><em>droopy</em></a> and <a href="http://www.home.unix-ag.org/simon/woof"><em>woof</em></a>. These are two shell scripts that I keep in my ~/bin/. Droopy lets you receive a file from a sender, and woof lets you send one their way. Unfortunately, they don't support ssl. This could be a project for someone. (<a href="http://www.piware.de/2011/01/creating-an-https-server-in-python/">Hint</a>)

I recently patched droopy to add inline image support. I've emailed my <a href="https://gist.githubusercontent.com/purpleidea/a25a4c47621e339d9c88cb848e104c82/raw/6884fbf399610f4804fef27175ec044437da3c43/inline_images.patch">patch</a> to the author, but until it gets merged, you can get my patched version <a href="https://gist.githubusercontent.com/purpleidea/6c3ca7b7c1335f6131c1d38d7b59beab/raw/19153ebe8d0765ee3958a31fb79a1f693def0baf/droopy.py">here</a>. (AGPLv.3+)

Hopefully these are helpful to you.

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
