+++
date = "2013-04-25 04:10:10"
title = "Upgrading to centos 6.4 with shorewall onboard"
draft = "false"
categories = ["technical"]
tags = ["centos 6.4", "shorewall", "upgrading", "centos", "devops", "selinux"]
author = "jamesjustjames"
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

&nbsp;

