+++
date = "2013-04-25 04:10:10"
title = "Upgrading to centos 6.4 with shorewall onboard"
draft = "false"
categories = ["technical"]
tags = ["centos", "centos 6.4", "devops", "selinux", "shorewall", "upgrading"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/04/25/upgrading-to-centos-6-4-with-shorewall-onboard/"
+++

In case you upgrade your CentOS 6.x box to version 6.4, the shorewall service might complain. With a scary message:
```
ERROR: Your kernel/iptables do not include state match support.
No version of Shorewall will run on this system
```
This is selinux at work, and the problem can easily be solved by running:
```
# restorecon -Rv /sbin
```
Thanks shorewall-users and

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
