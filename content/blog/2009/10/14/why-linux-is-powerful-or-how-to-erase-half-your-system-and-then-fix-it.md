+++
date = "2009-10-14 16:00:57"
title = "why linux is powerful or: how to erase half your system and then fix it"
draft = "false"
categories = ["technical"]
tags = ["apt-get", "bad", "dpkg", "linux", "makefile"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/10/14/why-linux-is-powerful-or-how-to-erase-half-your-system-and-then-fix-it/"
+++

after a brief bout of stupidity i quickly realized that my makefile had gone awry and was quickly eating through my filesystem.

after ^C killing it, it seems i only took out most of /lib/* and /usr/sbin/* -- who needs those anyways... apparently almost everyone.

what happened next. well it turns out i was lucky and had a few shells and a webbrowser open-- attempts to launch new programs will fail, but existing programs are already loaded in memory so i was able to work.

since almost everything was broken, i first had to get dpkg and apt/apt-utils going again. after much anguish, i manually installed the missing library files and binaries from <a href="http://packages.ubuntu.com/">http://packages.ubuntu.com/</a> and i was on my way with apt.

if you're manually installing files from .deb's use:
```
dpkg -x <package_file.deb> outputfolder/
```

which will let you get in and use mv and cp to put back the missing .so files.
once some basic tools were working, you can try and fix up your tool chain doing things like:
```
sudo apt-get --reinstall install <package_name>
```

it's good to do this to apt-utils, dpkg, and whatever other utilities are throwing library errors. the packages themselves need various utilities installed, and as you get a missing abc.so file, find out what package it needs with:
```
dpkg -S <filename>
```

my apt seems to be back, but many utilities still aren't. finding out what should go in /lib was a little harder but i was able to get a list of packages like this:

(find out what *should* be installed)
```
dpkg --get-selections > installed-software
```

(list which files come from these packages, sort and uniq it)
```
dpkg -L `cat installed-software` | sort | uniq > uniq-software
```

(find what we deleted)
```
cat uniq-software | grep ^/lib/ > missing-software
```

(which packages does this come from, sort and uniq it. (might get too long argument list))
```
dpkg -S `cat missing-software` > package-list
```

(find the package name by itself, get rid of the colons, sort, uniq)
```
cat package-list | awk '{print $1}' | sed -e 's/://' | sed -e 's/,//' | sort | uniq > reinstall-me
```

(do the reinstall)
```
sudo apt-get --reinstall install `cat reinstall-me`
```

at the moment this is running, and i luckily had a cd lying around to help speed up the process. use:
```
apt-cdrom add
```

(with the cd in the drive) to add it to your /etc/apt/sources.list

turns out this eventually failed with some obscure errors... it ultimately might be a more concise list if you know what got killed, but i think the sheer number of packages i messed up and that needed to get updated somehow confused apt with some cyclical cycles, and i had to go about it slightly more manually and generally.

first of all, when every i had an annoying library error, i ran this script:
```
#!/bin/bash
in=`echo $1 | sed -e 's/://'`
fix=`dpkg -S $in | awk '{print $1}' | sed -e 's/://'`
sudo apt-get -y --reinstall install $fix
```

which would reinstall the missing library. since i ended up doing this rather repetitively, it helped a lot.

secondly, i was forced to run something like this:
```
for i in `cat get-selections`; do
sudo apt-get -y --reinstall install $i;
done
```

which reinstalls each package. slowly after pruning the list for problem packages, and deleting the successful ones, my system came back. at one point you won't have to run them individually, and you can run:
```
sudo apt-get --reinstall install `cat get-selections`
```

and be done! i finished with a:
```
do-release-upgrade
```

and now things are looking great. luckily no important user files were squished, and hopefully this is a good reference for you. i hopefully won't have to reference it again for all the dpkg commands i'll forget.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
