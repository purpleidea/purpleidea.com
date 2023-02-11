+++
date = "2014-11-27 20:28:54"
title = "Replying to mailing lists with Evolution"
draft = "false"
categories = ["technical"]
tags = ["devops", "email", "evolution", "evolution mail", "fedora", "gluster", "group reply", "mail filters", "mailing-list", "mailman", "mutt", "planetdevops", "planetfedora", "planetpuppet", "reply", "reply-to-all", "vim"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/11/27/replying-to-mailing-lists-with-evolution/"
+++

I use the <a href="http://en.wikipedia.org/wiki/Evolution_%28software%29">Evolution</a> mail <a href="https://en.wikipedia.org/wiki/Mail_user_agent">client</a>. It does have a few annoying bugs, but it has a plethora of great features too! Hopefully this post will inspire you to help hack on this piece of software and fix the bugs!

<span style="text-decoration:underline;">Mailing list etiquette</span>:

When replying to mailing lists, it's typically very friendly to include the email address of the person you're replying to in the <em>to</em> or <em>cc</em> fields along with the mailing list address. This lets that person know that someone has answered their question. In some cases, if they're not subscribed to that mailing list, (if you don't do this), then they might not see your reply at all.

To enable this feature, there is a check box inside of the Evolution mail preferences. It is labelled: "<em>Ignore Reply-To: for mailing lists</em>".

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="evolution-ignore-reply-to.png"><img class="size-medium wp-image-1005" src="evolution-ignore-reply-to.png" alt="You can find this option in the Evolution &quot;Composer Preferences&quot; tab, under the &quot;Replies and Forwards&quot; heading." width="100%" height="100%" /></a></td></tr><tr><td> You can find this option in the Evolution "Composer Preferences" tab, under the "Replies and Forwards" heading.</td></tr></table></br />

This works, because by default, most mailing lists set the "Reply-To:" address to be that of the mailing list. In this case, when you click "Group Reply" ("Reply to all") in your MUA, then that field will be ignored, and the correct recipients will be selected in your composer window.

If instead you simply click "Reply", then you will be prompted to choose the kind of reply you'd like to send.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="evolution-send-private-reply.png"><img class="alignnone size-medium wp-image-1006" src="evolution-send-private-reply.png" alt="evolution-send-private-reply" width="100%" height="100%" /></a></td></tr></table></br />

<span style="text-decoration:underline;">Doesn't this annoy users</span>?

No, this actually gives the recipients <a href="https://www.redhat.com/archives/fedora-devel-list/2008-January/msg00861.html">more choice</a>! If they'd prefer not to see your reply in their inbox, they can set up a filter so that mail that <em>includes</em> the mailing list address goes to a special folder. If they prefer to see your reply in their inbox, then they can configure their filters so that mail that comes <em>exclusively</em> from the mailing list address goes to a specific folder.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="evolution-mailing-list-filter.png"><img class="size-large wp-image-1009" src="evolution-mailing-list-filter.png" alt="Instead of choosing the &quot;contains&quot; (in_array) operator, you could have chosen &quot;is&quot; (equals)." width="100%" height="100%" /></a></td></tr><tr><td> Instead of choosing the "contains" (in_array) operator, you could have chosen "is" (equals).</td></tr></table></br />

<span style="text-decoration:underline;">Won't this cause duplicate messages being sent to the user</span>?

Again, that's up to the user. Most mailing lists allow you to configure this setting.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="mailman-avoid-duplicate-copies-of-messages.png"><img class="size-medium wp-image-1007" src="mailman-avoid-duplicate-copies-of-messages.png" alt="In this particular example, it is a very low-volume list, therefore I don't filter messages into a separate folder, they go to my inbox, so there's no need to get two copies." width="100%" height="100%" /></a></td></tr><tr><td> This particular example is of a very low-volume list, therefore I don't filter messages into a separate folder; they go to my inbox, so there's no need to get two copies.</td></tr></table></br />

Ultimately, Evolution is a great MUA, which has the best message composer available. Some might prefer mutt+vim, but for my money, I'll stick with Evolution for now.

Happy hacking,

James

PS: If you hack on Evolution, and write a good feature that I like, or fix a bug that affects me, I'm happy to feature you on this blog and tweet about you as soon as your code hits <a href="https://git.gnome.org/browse/evolution/">git master</a>! &lt;/free promotion for good hackers!&gt;

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
