+++
date = "2013-09-26 00:43:50"
title = "Installing missing GNOME games"
draft = "false"
categories = ["technical"]
tags = ["gaming", "gnome", "gnome-games", "gnu+linux", "nibbles", "pgo", "planetfedora"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/26/installing-missing-gnome-games/"
+++

I just realized that my Fedora 19 installation didn't have any of the GNOME games installed by default any more. I guess there's no love for <a href="https://en.wikipedia.org/wiki/Nibbles_%28video_game%29">nibbles</a>. Here's a quick one-liner to get them all back:
```
$ sudo yum search game | grep gnome | awk '{print $1}' | xargs sudo yum install -y
Loaded plugins: etckeeper, langpacks, refresh-packagekit
Package gnome-nibbles-3.8.0-2.fc19.x86_64 already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package gnome-chess.x86_64 0:3.8.3-2.fc19 will be installed
--> Processing Dependency: gnuchess for package: gnome-chess-3.8.3-2.fc19.x86_64
---> Package gnome-hearts.x86_64 0:0.3-12.fc19 will be installed
---> Package gnome-klotski.x86_64 0:3.8.2-2.fc19 will be installed
---> Package gnome-mahjongg.x86_64 0:3.8.0-3.fc19 will be installed
---> Package gnome-mines.x86_64 0:3.8.1-3.fc19 will be installed
---> Package gnome-robots.x86_64 0:3.8.1-3.fc19 will be installed
---> Package gnome-sudoku.noarch 1:3.8.1-3.fc19 will be installed
---> Package gnome-tetravex.x86_64 0:3.8.1-2.fc19 will be installed
--> Running transaction check
---> Package gnuchess.x86_64 0:6.0.3-1.fc19 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package               Arch          Version                Repository     Size
================================================================================
Installing:
 gnome-chess           x86_64        3.8.3-2.fc19           fedora        2.6 M
 gnome-hearts          x86_64        0.3-12.fc19            fedora        365 k
 gnome-klotski         x86_64        3.8.2-2.fc19           fedora        1.2 M
 gnome-mahjongg        x86_64        3.8.0-3.fc19           fedora        3.8 M
 gnome-mines           x86_64        3.8.1-3.fc19           fedora        2.7 M
 gnome-robots          x86_64        3.8.1-3.fc19           fedora        1.4 M
 gnome-sudoku          noarch        1:3.8.1-3.fc19         fedora        2.5 M
 gnome-tetravex        x86_64        3.8.1-2.fc19           fedora        1.7 M
Installing for dependencies:
 gnuchess              x86_64        6.0.3-1.fc19           fedora        2.6 M

Transaction Summary
================================================================================
Install  8 Packages (+1 Dependent package)

Total download size: 19 M
Installed size: 54 M
Downloading packages:
(1/9): gnome-chess-3.8.3-2.fc19.x86_64.rpm                 | 2.6 MB   00:04     
(2/9): gnome-mines-3.8.1-3.fc19.x86_64.rpm                 | 2.7 MB   00:05     
(3/9): gnome-klotski-3.8.2-2.fc19.x86_64.rpm               | 1.2 MB   00:05     
(4/9): gnome-robots-3.8.1-3.fc19.x86_64.rpm                | 1.4 MB   00:01     
(5/9): gnome-tetravex-3.8.1-2.fc19.x86_64.rpm                                                                                          | 1.7 MB  00:00:03     
(6/9): gnome-hearts-0.3-12.fc19.x86_64.rpm                                                                                             | 365 kB  00:00:10     
(7/9): gnuchess-6.0.3-1.fc19.x86_64.rpm                                                                                                | 2.6 MB  00:00:04     
(8/9): gnome-mahjongg-3.8.0-3.fc19.x86_64.rpm                                                                                          | 3.8 MB  00:00:11     
(9/9): gnome-sudoku-3.8.1-3.fc19.noarch.rpm                                                                                            | 2.5 MB  00:00:06     
--------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                         1.5 MB/s |  19 MB     00:12     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
etckeeper: pre transaction commit
  Installing : gnuchess-6.0.3-1.fc19.x86_64                                                                                                               1/9 
  Installing : gnome-chess-3.8.3-2.fc19.x86_64                                                                                                            2/9 
  Installing : gnome-klotski-3.8.2-2.fc19.x86_64                                                                                                          3/9 
  Installing : gnome-tetravex-3.8.1-2.fc19.x86_64                                                                                                         4/9 
  Installing : gnome-mines-3.8.1-3.fc19.x86_64                                                                                                            5/9 
  Installing : 1:gnome-sudoku-3.8.1-3.fc19.noarch                                                                                                         6/9 
  Installing : gnome-hearts-0.3-12.fc19.x86_64                                                                                                            7/9 
  Installing : gnome-mahjongg-3.8.0-3.fc19.x86_64                                                                                                         8/9 
  Installing : gnome-robots-3.8.1-3.fc19.x86_64                                                                                                           9/9 
etckeeper: post transaction commit
  Verifying  : gnome-chess-3.8.3-2.fc19.x86_64                                                                                                            1/9 
  Verifying  : gnuchess-6.0.3-1.fc19.x86_64                                                                                                               2/9 
  Verifying  : gnome-robots-3.8.1-3.fc19.x86_64                                                                                                           3/9 
  Verifying  : gnome-mahjongg-3.8.0-3.fc19.x86_64                                                                                                         4/9 
  Verifying  : gnome-hearts-0.3-12.fc19.x86_64                                                                                                            5/9 
  Verifying  : 1:gnome-sudoku-3.8.1-3.fc19.noarch                                                                                                         6/9 
  Verifying  : gnome-mines-3.8.1-3.fc19.x86_64                                                                                                            7/9 
  Verifying  : gnome-tetravex-3.8.1-2.fc19.x86_64                                                                                                         8/9 
  Verifying  : gnome-klotski-3.8.2-2.fc19.x86_64                                                                                                          9/9 

Installed:
  gnome-chess.x86_64 0:3.8.3-2.fc19    gnome-hearts.x86_64 0:0.3-12.fc19     gnome-klotski.x86_64 0:3.8.2-2.fc19    gnome-mahjongg.x86_64 0:3.8.0-3.fc19   
  gnome-mines.x86_64 0:3.8.1-3.fc19    gnome-robots.x86_64 0:3.8.1-3.fc19    gnome-sudoku.noarch 1:3.8.1-3.fc19     gnome-tetravex.x86_64 0:3.8.1-2.fc19   

Dependency Installed:
  gnuchess.x86_64 0:6.0.3-1.fc19                                                                                                                              

Complete!
$
```
This isn't a master hack, but it's good to think about using command line magic to do your day-to-day tasks.

Happy gaming,

James

PS: I also updated the blog's theme. Let me know if you hate it.

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
