+++
date = "2012-11-26 05:42:20"
title = "visible close buttons on every firefox tab (including the last one)"
draft = "false"
categories = ["technical"]
tags = ["close", "firefox", "tab", "tab-close-button"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/11/26/visible-close-buttons-on-every-firefox-tab-including-the-last-one/"
+++

<a title="more rows and columns on firefox new tab page" href="/blog/2012/11/24/more-rows-and-columns-on-firefox-new-tab-page/">After hacking around with a few firefox internals the other day</a>, I decided there was another little annoyance that I had... When I'm acting insane and <a href="http://reddit.com/">using my mouse to open and close tabs</a>, the per tab close button disappears when there is only one tab left! <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=455990">This is apparently a feature</a>, and while I can respect it as a default, it certainly isn't an option for me. Thankfully, there are a lot of common minded individuals on the net, and the (hack) solution already existed. Here's to explaining it clearly:
<ol>
	<li>Create/edit a <a href="http://kb.mozillazine.org/UserChrome.css">userChrome.css </a>file in your profile directory. For me this path was:
```
~/.mozilla/firefox/xxxxxxxx.default/chrome/userChrome.css
```
</li>
	<li>Insert the following and <em>restart </em>firefox:
```
.tab-close-button {display: -moz-box !important; }
```
</li>
	<li>Share and Enjoy!</li>
</ol>
Happy hacking,

James

PS: In case it's not blatantly obvious, I didn't invent any of this, but I am writing about it for your enjoyment, and for my own lousy memory.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
