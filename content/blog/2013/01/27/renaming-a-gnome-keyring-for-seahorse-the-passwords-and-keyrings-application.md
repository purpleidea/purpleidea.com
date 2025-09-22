+++
date = "2013-01-27 15:33:50"
title = "Renaming a GNOME keyring (for seahorse, the passwords and keyrings application)"
draft = "false"
categories = ["technical"]
tags = ["gnome", "gnome-keyring", "hacks", "pgo", "seahorse"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/01/27/renaming-a-gnome-keyring-for-seahorse-the-passwords-and-keyrings-application/"
+++

The GNOME Keyring is a great tool to unify password management across the desktop. Sadly, Firefox is the one application that doesn't support this natively. (Chrome actually does!)

Seahorse is a useful tool to browse and manage your keyrings. Each keyring is physically stored in: <em>~/.gnome2/keyrings/<strong>$something</strong>.keyring</em>

Usually the "<strong><em>$something</em></strong>", matches the name of the keyring, however the real name comes from within the file. I had an older ubuntu machine running GNOME, and I wanted to import my keyring. Here's how I did it:
<ol>
	<li>Copy <em>~/.gnome2/keyrings/login.keyring</em> (from the ubuntu machine) to <em>~/.gnome2/keyrings/ubuntu.keyring</em> (on the new machine)</li>
	<li>Open up seahorse and change the keyring password of this "login" keyring to the empty string. This stores the passwords in a plain text format, which is briefly necessary.</li>
	<li>Edit the <em>ubuntu.keyring</em> file. There will be an obvious "display-name" section at the top of the file to edit. I changed it to:
```
[keyring]
display-name=ubuntu
```
</li>
	<li>After restarting seahorse, I now changed the password back to something secure. If this process worked, you should already see the new keyring name in your keychain list.</li>
</ol>
Obviously this is a bit of a hack, and a proper rename function would be preferable, but until that exists, hopefully this will fill a niche if you're stuck and you want to pull in an old keyring into your already populated $HOME.

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
