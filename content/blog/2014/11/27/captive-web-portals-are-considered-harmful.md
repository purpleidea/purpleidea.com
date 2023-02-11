+++
date = "2014-11-27 00:46:06"
title = "Captive web portals are considered harmful"
draft = "false"
categories = ["technical"]
tags = ["/cgi-bin/redirect.ha", "AT&amp;T GUI", "HTTP", "HTTPS", "MITM", "cache", "captive portal", "devops", "fedora", "firefox", "gluster", "planetdevops", "planetfedora", "planetpuppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/11/27/captive-web-portals-are-considered-harmful/"
+++

Recently, when I tried to access <a href="http://slashdot.org/">http://slashdot.org/</a> in Firefox, I would see my browser title bar flash briefly to "AT&amp;T GUI", and then I would get redirected to: <code>http://slashdot.org/<strong>cgi-bin/redirect.ha</strong></code> which returns slashdot's custom error 404 page! What is going on? (Read on for answer...)
<ul>
	<li>Did slashdot mess up their <a href="http://httpd.apache.org/docs/current/mod/mod_rewrite.html">mod_rewrite</a> config?
(Nope, works fine in a different browser...)</li>
	<li>Did my <a href="https://www.eff.org/https-everywhere">HTTPS everywhere</a> extension go crazy?
(Nope, still broken when disabled...)</li>
	<li>Are my HTTP requests being <a href="https://en.wikipedia.org/wiki/Man-in-the-middle_attack">MITM</a>-ed?
(Yes, <a href="https://www.schneier.com/blog/archives/2013/09/new_nsa_leak_sh.html">probably by the NSA</a>, but they wouldn't make this kind of mistake...)</li>
	<li>Is my computer p0wned?
(I use <a href="https://fedoraproject.org/">GNU/Linux</a>, so probably not...)</li>
</ul>
<a href="https://duckduckgo.com/?q=AT%26T+GUI+cgi-bin%2Fredirect.ha">A keyword search</a> will show you that others are also affected by this, except that the base domain (slashdot.org) is usually different... One thing that all the links I viewed have in common: none of them seem to know what's happening.

<span style="text-decoration:underline;">Some background</span>:

Recently, I used my laptop with a public WIFI access point. The router behind these access points usually performs a MITM redirection on your HTTP traffic to send you to a <a href="https://en.wikipedia.org/wiki/Captive_portal">captive web portal</a> which you'll need to use before being authorized to route out to the public internet.

After connecting to the wireless <a href="https://en.wikipedia.org/wiki/Service_set_%28802.11_network%29">SSID</a>, whichever site you visit next will get replaced with the portal. This typically can't be an HTTPS url, because they aren't easily MITM-ed without causing a certificate error.

On my Firefox new tab page, the only non-HTTPS site that I visit is http://slashdot.org/ and as a result, I'll click this link when I know I'm expecting a portal... (Seriously slashdot, wtf!)

<span style="text-decoration:underline;">What's happening</span>?

When I visited http://slashdot.org/ on public WIFI, the captive portal web page got permanently cached in my browser, and now every time I attempt to visit slashdot, I actually get the cached, MITM-ed, portal version.

<span style="text-decoration:underline;">How to fix this</span>?

Actually it's very simple: just clear your browser cache. You don't need to delete your cookies or your history. Choose the "Clear Now" button in Firefox. Example:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="clear-cache.png"><img class="alignnone size-medium wp-image-1001" src="clear-cache.png" alt="clear-cache" width="100%" height="100%" /></a></td></tr></table></br />

<span style="text-decoration:underline;">Whose fault is this</span>?
<ul>
	<li>The AT&amp;T portal programmers for <a href="http://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Avoiding_caching">allowing a portal page to be cached</a>.</li>
	<li>Any website that doesn't require HTTPS (and lets themselves get MITM-ed).</li>
	<li>Firefox for not protecting against this (other browsers are affected too!)</li>
	<li>Public WIFI services for using captive portals (just free the internet already!)</li>
</ul>
<span style="text-decoration:underline;">Is there any good news</span>?

It's easily fixed, and there didn't seem to be any malicious code in the cached web portal redirector. It turned out to only include a <a href="http://www.w3.org/TR/WCAG20-TECHS/H76.html">META refresh</a>. Phew :)

Hope this provides an authoritative answer for everyone who is experiencing this problem!

Happy hacking!

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
