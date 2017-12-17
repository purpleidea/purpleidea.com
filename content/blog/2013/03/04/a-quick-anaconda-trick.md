+++
date = "2013-03-04 05:00:43"
title = "A quick anaconda trick"
draft = "false"
categories = ["technical"]
tags = ["kickstart", "fstype", "devops", "anaconda"]
author = "jamesjustjames"
+++

Here's a quick <a href="https://fedoraproject.org/wiki/Anaconda/Kickstart">anaconda</a> solution that I am now using in some of my kickstart files...

I wanted to bootstrap a machine and do all the partitioning and logical volume creation, but not format or mount one of the logical volumes. The magic parameter I needed was:
```
--fstype=none
```
This seems to work perfectly for me. It's not 100% intuitive to me, but it does work. I hope it's not an accidental bug in the anaconda code! The full text of my partitioning is:
```
clearpart --all --drives=sda
part /boot --fstype=ext4 --size=1024
part pv.01 --grow --size=1024
volgroup VolGroup00 --pesize=4096 pv.01
logvol / --fstype=ext4 --name=root --vgname=VolGroup00 --size=65536
logvol swap --name=swap --vgname=VolGroup00 --size=16384
logvol /foo --name=foo --vgname=VolGroup00 --fstype=none --grow --size=1
```
Now all that anaconda is missing is support for RAID1 EFI /boot.

Happy hacking,

James

