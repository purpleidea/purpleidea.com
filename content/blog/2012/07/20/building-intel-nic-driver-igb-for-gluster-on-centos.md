+++
date = "2012-07-20 18:47:50"
title = "building intel nic driver (igb) for gluster on centos"
draft = "false"
categories = ["technical"]
tags = ["devops", "gluster"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/07/20/building-intel-nic-driver-igb-for-gluster-on-centos/"
+++

I've been having some strange networking issues with gluster. "Eco__" from #gluster suggested I try an up to date Intel nic driver. Here are the steps I followed to make that happen. No news yet on if that solved the problem.

Currently my system is using the igb (intel gigabit) driver. To find out what version you are running:
```
# modinfo -F version igb
3.2.10-k
```
I found a newer version from the <a href="ftp://ftp.supermicro.com/driver/LAN/Intel/">supermicro ftp site</a>. A download and a decompress later, I found an: igb-3.4.7.tar.gz file hiding out. Thanks to the kind people at Intel, this was fairly easy to compile and install. First install some deps:
```
# yum install /usr/bin/{rpmbuild,gcc,make} kernel-devel
```
Use rpmbuild to make yourself an rpm:
```
# rpmbuild -tb igb-3.4.7.tar.gz
[snip]
```
Your rpm package should appear in rpmbuild/RPMS/
In my case, I added this to my local cobbler repo, and pushed it to all my gluster nodes. You might prefer a simple:
```
# yum install igb-3.4.7-1.x86_64.rpm
```
Please note that I believe it's important to build this module on the same kind of OS/Hardware that you're using it for. Since my storage hosts are all identical, this wasn't a problem.

Happy hacking!
James

EDIT: tru_tru from #gluster pointed out that this module actually exists in <a href="http://elrepo.org">elrepo</a>, the wonderful people who also provide drbd modules. I haven't tested it, but I'm sure it's excellent.

