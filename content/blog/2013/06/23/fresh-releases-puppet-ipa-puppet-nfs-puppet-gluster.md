+++
date = "2013-06-23 09:22:32"
title = "Fresh releases! puppet-ipa, puppet-nfs, puppet-gluster"
draft = "false"
categories = ["technical"]
tags = ["NFS", "NFSv4", "cobbler", "devops", "examples", "freeipa", "gluster", "kerberos", "keytab", "planetpuppet", "puppet", "puppet module", "puppet-cobbler", "puppet-gluster", "puppet-ipa", "puppet-nfs", "security"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/06/23/fresh-releases-puppet-ipa-puppet-nfs-puppet-gluster/"
+++

I've been a little slow in making release announcements, so here's some news:

I've just released the third stage of my <a href="https://github.com/purpleidea/puppet-ipa">puppet-ipa</a> module. At the moment it now supports installation, managing of hosts, and managing of services. It integrates with my <a href="https://github.com/purpleidea/puppet-nfs">puppet-nfs</a> module to allow you to easily setup and run an NFSv4 kerberized server and client.

While we're at it, that's some more news: I've just released a <a href="https://github.com/purpleidea/puppet-nfs">puppet-nfs</a> module to make your <em>/etc/exports</em> management easier. It's designed to manage other security types, or even to work without kerberos or any authentication at all, but I haven't tested those.

Back to <a href="https://github.com/purpleidea/puppet-ipa/">puppet-ipa</a> for a moment. I'd like you to know that I went to great lengths to make this a very versatile module. Some users probably want certain resources managed by puppet, and others not. <a href="https://github.com/purpleidea/puppet-ipa/blob/master/examples/host-excludes.pp">With the included features, you can even specify exclusion criteria so that a certain pattern of hosts aren't touched by puppet.</a> This is useful if you're slowly converting your ipa setup to be managed by puppet.

You can use <a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/init.pp#L549"><em>$watch</em></a> and <a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/init.pp#L550"><em>$modify</em></a>, two <a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/init.pp#L548">special parameters</a> that I added to precisely control what kind of changes you want to allow puppet to make. These are kind of complicated to explain, but suffice it to say that this module should handle whatever situation you're in.

For the security minded folks, <a href="https://github.com/purpleidea/puppet-ipa/">puppet-ipa</a>, <strong><em>never</em></strong> transfers or touches a keytab file. It will securely and automatically provision your hosts and services without storing secret information in puppet. The module isn't finished, but it's built right.

Gluster users might find this particular trio useful for offering gluster backed, kerberized, NFS exports. <a href="https://github.com/purpleidea/puppet-gluster/blob/master/examples/gluster-nfs-ipa-example.pp">Here's an example that I made just for you.</a>

Since you sound like you're having fun deploying servers like crazy, it's probably useful to have a <a href="https://github.com/purpleidea/puppet-cobbler">puppet-cobbler</a> module. I've released this module because it's useful to me, however it really isn't release ready, but I think it's better than some (most?) of the other <a href="https://github.com/purpleidea/puppet-cobbler">puppet-cobbler</a> code that's out there. One other warning is that I have a large rearchitecturing planned for this module, so don't get too attached. It's going to get <em>better!</em>

So that's your lot for today, have fun, and

Happy Hacking!

James

PS: If you're in a giving mood, I'm in the need for some x86_64 compatible test hardware. If you're able to <a title="donate" href="/donate/">donate</a>, please let me know!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
