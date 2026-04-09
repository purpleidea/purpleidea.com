---
# get with: `date --rfc-3339=seconds`
date: 2026-04-09 02:23:52-04:00
title: "The switch as an ordinary GNU/Linux server"
description: "I can't believe it's been over 11 years"
categories:
  - "technical"
tags:
  - "asic"
  - "config management"
  - "cumulus"
  - "cumulusnetworks"
  - "devops"
  - "fedora"
  - "golang"
  - "ifup/ifdown"
  - "iproute2"
  - "iptables"
  - "mgmt"
  - "mgmtconfig"
  - "nda"
  - "networkd"
  - "nftables"
  - "novarq"
  - "planetfedora"
  - "selinux"
  - "shorewall"
  - "switch"
  - "switchd"
  - "switchdev"
  - "systemd"
  - "trident"
  - "udev"
draft: false
---

[In 2014 I wrote an article about the switch as an ordinary GNU/Linux server.](/blog/2014/11/04/the-switch-as-an-ordinary-gnulinux-server/)
This had been my dream since my early days using Linux to build routers and I
didn't know why we didn't use the same management interfaces on switches as we
did on Linux. The folks at *Cumulus Networks* made this a reality and in 2014
they were kind enough to give me access to some hardware to test things out.

The fact that we manage the [switches](https://en.wikipedia.org/wiki/Network_switch)
in our data centres differently than any other server is patently absurd, but we
do so because we want to harness the power of a tiny bit of [silicon](https://en.wikipedia.org/wiki/Silicon#Electronic_grade)
which happens to be able to dramatically speed up the switching bandwidth.

{{< blog-image src="absurd.png" caption="beware of proprietary silicon, it's absurd!" scale="100%" >}}

{{< blog-paragraph-header "A new competitor emerges" >}}

There has been much to this story in the intervening years since, but you can go
read about that history elsewhere. One recent development caught my eye, a new
company by the name of [Novarq is selling a new switch](https://novarq.com/pages/tactical-1000)
claiming to carry on this tradition.

{{< blog-image src="novarq-tactical-1000.png" caption="the switch in question" scale="100%" >}}

They were kind enough to have a short chat with me and to give me access to some
hardware to test it out. No money exchanged hands, and I wasn't told what I
could or couldn't say. What follows is my honest review and advice which I
publish in the hopes of helping them succeed for the selfish reason that I think
the switching and automation world would be a better place by being able to
manage all of your hardware in the exact same way.

{{< blog-paragraph-header "Getting Started" >}}

### Logging in...

```bash
ssh root@<censored> -p <censored>
Linux bookworm-tactical1000 7.0.0-rc4-next-20260320 #1 SMP PREEMPT Thu Apr  2 20:56:11 CEST 2026 aarch64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Mon Apr  6 18:30:36 2026 from <censored>
root@bookworm-tactical1000:~#
```

### Being curious...

```bash
root@bookworm-tactical1000:~# cat .bash_history

ping 172.16.255.2
ping 172.16.222.223
ping 1.1.1.1
ping 172.16.223.183
apt update
nmap
apt install nmap
nmap -sn 172.16.0.1/16
nmap -sn 172.16.222.223
apt purge nmap
cat .bash_history
echo "" > .bash_history
htop
top
exit
ls
exit
root@bookworm-tactical1000:~#
```

Secrets are gone!

### Setup

```bash
root@bookworm-tactical1000:~# screen
-bash: screen: command not found
root@bookworm-tactical1000:~# apt install screen
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libblas3 liblinear4 liblua5.3-0 libpcap0.8 libpcre3 libssh2-1 lua-lpeg nmap-common
Use 'apt autoremove' to remove them.
The following additional packages will be installed:
  libutempter0
Suggested packages:
  byobu | screenie | iselect
The following NEW packages will be installed:
  libutempter0 screen
0 upgraded, 2 newly installed, 0 to remove and 3 not upgraded.
Need to get 574 kB of archives.
After this operation, 1172 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 https://deb.debian.org/debian bookworm/main arm64 libutempter0 arm64 1.2.1-3 [8964 B]
Get:2 https://deb.debian.org/debian bookworm/main arm64 screen arm64 4.9.0-4 [565 kB]
Fetched 574 kB in 1s (970 kB/s)
Selecting previously unselected package libutempter0:arm64.
(Reading database ... 15806 files and directories currently installed.)
Preparing to unpack .../libutempter0_1.2.1-3_arm64.deb ...
Unpacking libutempter0:arm64 (1.2.1-3) ...
Selecting previously unselected package screen.
Preparing to unpack .../screen_4.9.0-4_arm64.deb ...
Unpacking screen (4.9.0-4) ...
Setting up libutempter0:arm64 (1.2.1-3) ...
Setting up screen (4.9.0-4) ...
Processing triggers for libc-bin (2.36-9+deb12u13) ...
Processing triggers for debianutils (5.7-0.5~deb12u1) ...
root@bookworm-tactical1000:~#
```

In total I installed `bash-completion`, `bridge-utils`, `ethtool`, `man`,
`psmisc`, `pciutils`, `screen`, `tree`.

### Exploring

```bash
root@bookworm-tactical1000:~# pstree
systemd-+-agetty
        |-cron
        |-dbus-daemon
        |-dhclient
        |-login---bash
        |-sshd---sshd---bash---screen---screen---bash---pstree
        |-systemd---(sd-pam)
        |-systemd-journal
        |-systemd-logind
        |-systemd-timesyn---{systemd-timesyn}
        `-systemd-udevd
root@bookworm-tactical1000:~#
```

Surprisingly little going on.

```bash
root@bookworm-tactical1000:~# uname -a
Linux bookworm-tactical1000 7.0.0-rc4-next-20260320 #1 SMP PREEMPT Thu Apr  2 20:56:11 CEST 2026 aarch64 GNU/Linux
```

ARM64 hardware as expected. This is a mostly stock Debian AIUI.

```bash
root@bookworm-tactical1000:~# cat /proc/cpuinfo
processor       : 0
BogoMIPS        : 500.00
Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 cpuid
CPU implementer : 0x41
CPU architecture: 8
CPU variant     : 0x0
CPU part        : 0xd03
CPU revision    : 4
root@bookworm-tactical1000:~# free -g
               total        used        free      shared  buff/cache   available
Mem:               1           0           1           0           0           1
Swap:              0           0           0
root@bookworm-tactical1000:~# free -m
               total        used        free      shared  buff/cache   available
Mem:            1985         136        1621           0         295        1849
Swap:              0           0           0
root@bookworm-tactical1000:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       974M  567M  340M  63% /
devtmpfs        977M     0  977M   0% /dev
tmpfs           993M     0  993M   0% /dev/shm
tmpfs           398M  572K  397M   1% /run
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           199M     0  199M   0% /run/user/0
root@bookworm-tactical1000:~#
```

This machine is not fast. Storage and RAM are a bit tight.

```bash
root@bookworm-tactical1000:~# ps auxww
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.5 103212 11740 ?        Ss   Apr03   0:10 /sbin/init
root           2  0.0  0.0      0     0 ?        S    Apr03   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    Apr03   0:00 [pool_workqueue_release]
root           4  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-rcu_gp]
root           5  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-sync_wq]
root           6  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-kvfree_rcu_reclaim]
root           7  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-slub_flushwq]
root           8  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-netns]
root          13  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-mm_percpu_wq]
root          14  0.0  0.0      0     0 ?        S    Apr03   0:00 [ksoftirqd/0]
root          15  0.0  0.0      0     0 ?        I    Apr03   0:00 [rcu_preempt]
root          16  0.0  0.0      0     0 ?        S    Apr03   0:00 [rcu_exp_par_gp_kthread_worker/0]
root          17  0.0  0.0      0     0 ?        S    Apr03   0:00 [rcu_exp_gp_kthread_worker]
root          18  0.0  0.0      0     0 ?        S    Apr03   0:00 [migration/0]
root          19  0.0  0.0      0     0 ?        S    Apr03   0:00 [cpuhp/0]
root          20  0.0  0.0      0     0 ?        S    Apr03   0:00 [kdevtmpfs]
root          21  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-inet_frag_wq]
root          22  0.0  0.0      0     0 ?        I    Apr03   0:00 [rcu_tasks_kthread]
root          23  0.0  0.0      0     0 ?        S    Apr03   0:00 [kauditd]
root          25  0.0  0.0      0     0 ?        S    Apr03   0:00 [oom_reaper]
root          26  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-writeback]
root          27  0.0  0.0      0     0 ?        S    Apr03   0:02 [kcompactd0]
root          28  0.0  0.0      0     0 ?        SN   Apr03   0:00 [ksmd]
root          29  0.0  0.0      0     0 ?        SN   Apr03   0:02 [khugepaged]
root          30  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-kblockd]
root          31  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-kintegrityd]
root          32  0.0  0.0      0     0 ?        S    Apr03   0:00 [watchdogd]
root          33  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-quota_events_unbound]
root          36  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-rpciod]
root          37  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-xprtiod]
root          38  0.0  0.0      0     0 ?        S    Apr03   0:00 [kswapd0]
root          39  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-nfsiod]
root          40  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/u5:0]
root          68  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-e00c0000.switch-mact]
root          69  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-e00c0000.switch-stats]
root          70  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/23-sparx5-ptp]
root          71  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-uas]
root          72  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-sdhci]
root          73  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/26-mmc0]
root          75  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-mld]
root          76  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-ipv6_addrconf]
root          77  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-mmc_complete]
root          79  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/29-sfp0-mod-def0]
root          80  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/30-sfp0-los]
root          81  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/31-sfp0-tx-fault]
root          82  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/32-sfp1-mod-def0]
root          83  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/33-sfp1-los]
root          84  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/34-sfp1-tx-fault]
root          85  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/35-sfp2-mod-def0]
root          86  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/36-sfp2-los]
root          87  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/37-sfp2-tx-fault]
root          88  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/38-sfp3-mod-def0]
root          89  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/39-sfp3-los]
root          90  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/40-sfp3-tx-fault]
root          91  0.0  0.0      0     0 ?        S    Apr03   0:02 [jbd2/mmcblk0p5-8]
root          92  0.0  0.0      0     0 ?        I<   Apr03   0:00 [kworker/R-ext4-rsv-conversion]
root         121  0.0  0.4  49956  8948 ?        Ss   Apr03   0:02 /lib/systemd/systemd-journald
root         137  0.0  0.3  24892  6316 ?        Ss   Apr03   0:00 /lib/systemd/systemd-udevd
systemd+     141  0.0  0.3  90524  7088 ?        Ssl  Apr03   0:02 /lib/systemd/systemd-timesyncd
root         220  0.0  0.1   4116  2360 ?        Ss   Apr03   0:00 /usr/sbin/cron -f
message+     238  0.0  0.1   8508  3908 ?        Ss   Apr03   0:01 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
root         242  0.0  0.3  17216  7416 ?        Ss   Apr03   0:01 /lib/systemd/systemd-logind
root         362  0.0  0.1   5524  3572 ?        Ss   Apr03   0:00 dhclient -4 -v -i -pf /run/dhclient.eth28.pid -lf /var/lib/dhcp/dhclient.eth28.leases -I -df /var/lib/dhcp/dhclient6.eth28.leases eth28
root         366  0.0  0.0      0     0 ?        S    Apr03   0:00 [irq/20-e20101a8.mdio-mii:03]
root         397  0.0  0.0   2652  1572 tty1     Ss+  Apr03   0:00 /sbin/agetty -o -p -- \u --noclear - linux
root         398  0.0  0.1   7856  3528 ttyAT0   Ss   Apr03   0:00 /bin/login -p --
root         399  0.0  0.4  16352  8928 ?        Ss   Apr03   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         406  0.0  0.4  19548 10152 ?        Ss   Apr03   0:00 /lib/systemd/systemd --user
root         407  0.0  0.2 104276  4820 ?        S    Apr03   0:00 (sd-pam)
root         413  0.0  0.1   4468  3496 ttyAT0   S+   Apr03   0:00 -bash
root        2722  0.0  0.0      0     0 ?        I<   Apr05   0:00 [kworker/0:1H-kblockd]
root        3158  0.0  0.0      0     0 ?        I    06:57   0:00 [kworker/0:0-mm_percpu_wq]
root        3424  0.0  0.0      0     0 ?        I    15:49   0:06 [kworker/u4:0-events_power_efficient]
root        3462  0.0  0.0      0     0 ?        I    17:30   0:06 [kworker/u4:4-events_power_efficient]
root        3701  0.0  0.0      0     0 ?        I    18:59   0:00 [kworker/0:3]
root        3704  0.0  0.0      0     0 ?        I    19:00   0:00 [kworker/u4:1-events_unbound]
root        3733  0.0  0.1   4648  2824 ?        Ss   19:02   0:00 SCREEN
root        3734  0.0  0.1   4048  3276 pts/1    Ss   19:02   0:00 /bin/bash
root        4098  0.1  0.0      0     0 ?        I    19:05   0:01 [kworker/u4:2-events_unbound]
root        5180  0.0  0.5  19704 10356 ?        Ss   19:17   0:00 sshd: root@notty
root        5186  0.0  0.0   2840  1988 ?        Ss   19:17   0:00 /usr/lib/openssh/sftp-server
root        5187  0.0  0.5  19544 10296 ?        Ss   19:17   0:00 sshd: root@pts/0
root        5193  0.0  0.1   4048  3236 pts/0    Ss   19:18   0:00 -bash
root        5196  0.0  0.1   3944  2408 pts/0    S+   19:18   0:00 screen -xRR
root        5291  0.0  0.0      0     0 ?        I<   19:21   0:00 [kworker/0:2H]
root        5310  0.0  0.0      0     0 ?        I    19:26   0:00 [kworker/u4:3-events_power_efficient]
root        5314  200  0.1   8056  3904 pts/1    R+   19:29   0:00 ps auxww
root@bookworm-tactical1000:~#
```

Mostly what you'd expect.

```bash
root@bookworm-tactical1000:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:01 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:02 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:03 brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:04 brd ff:ff:ff:ff:ff:ff
6: eth4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:05 brd ff:ff:ff:ff:ff:ff
7: eth5: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:06 brd ff:ff:ff:ff:ff:ff
8: eth6: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:07 brd ff:ff:ff:ff:ff:ff
9: eth7: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:08 brd ff:ff:ff:ff:ff:ff
10: eth8: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:09 brd ff:ff:ff:ff:ff:ff
11: eth9: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:0a brd ff:ff:ff:ff:ff:ff
12: eth10: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:0b brd ff:ff:ff:ff:ff:ff
13: eth11: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:0c brd ff:ff:ff:ff:ff:ff
14: eth12: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:0d brd ff:ff:ff:ff:ff:ff
15: eth13: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:0e brd ff:ff:ff:ff:ff:ff
16: eth14: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:0f brd ff:ff:ff:ff:ff:ff
17: eth15: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:10 brd ff:ff:ff:ff:ff:ff
18: eth16: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:11 brd ff:ff:ff:ff:ff:ff
19: eth17: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:12 brd ff:ff:ff:ff:ff:ff
20: eth18: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:13 brd ff:ff:ff:ff:ff:ff
21: eth19: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:14 brd ff:ff:ff:ff:ff:ff
22: eth20: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:15 brd ff:ff:ff:ff:ff:ff
23: eth21: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:16 brd ff:ff:ff:ff:ff:ff
24: eth22: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:17 brd ff:ff:ff:ff:ff:ff
25: eth23: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:18 brd ff:ff:ff:ff:ff:ff
26: eth24: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:19 brd ff:ff:ff:ff:ff:ff
27: eth25: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:1a brd ff:ff:ff:ff:ff:ff
28: eth26: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:1b brd ff:ff:ff:ff:ff:ff
29: eth27: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 5e:37:b6:54:3b:1c brd ff:ff:ff:ff:ff:ff
30: eth28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5e:37:b6:54:3b:1e brd ff:ff:ff:ff:ff:ff
    inet 192.168.99.100/24 brd 192.168.99.255 scope global dynamic eth28
       valid_lft 5587sec preferred_lft 5587sec
    inet6 fe80::5c37:b6ff:fe54:3b1e/64 scope link
       valid_lft forever preferred_lft forever
root@bookworm-tactical1000:~#
```

Lots of beautiful ports! They may wish to use a different name for the ports to
[aid in automation](https://github.com/systemd/systemd/issues/16665#issuecomment-669167184).

```bash
root@bookworm-tactical1000:~# tree /etc/udev/
/etc/udev/
|-- hwdb.d
|-- rules.d
`-- udev.conf

3 directories, 1 file
root@bookworm-tactical1000:~# tree /etc/systemd/network
/etc/systemd/network

0 directories, 0 files
root@bookworm-tactical1000:~# brctl show
root@bookworm-tactical1000:~# networkctl
WARNING: systemd-networkd is not running, output will be incomplete.

IDX LINK  TYPE     OPERATIONAL SETUP
  1 lo    loopback -           unmanaged
  2 eth0  ether    -           unmanaged
  3 eth1  ether    -           unmanaged
  4 eth2  ether    -           unmanaged
  5 eth3  ether    -           unmanaged
  6 eth4  ether    -           unmanaged
  7 eth5  ether    -           unmanaged
  8 eth6  ether    -           unmanaged
  9 eth7  ether    -           unmanaged
 10 eth8  ether    -           unmanaged
 11 eth9  ether    -           unmanaged
 12 eth10 ether    -           unmanaged
 13 eth11 ether    -           unmanaged
 14 eth12 ether    -           unmanaged
 15 eth13 ether    -           unmanaged
 16 eth14 ether    -           unmanaged
 17 eth15 ether    -           unmanaged
 18 eth16 ether    -           unmanaged
 19 eth17 ether    -           unmanaged
 20 eth18 ether    -           unmanaged
 21 eth19 ether    -           unmanaged
 22 eth20 ether    -           unmanaged
 23 eth21 ether    -           unmanaged
 24 eth22 ether    -           unmanaged
 25 eth23 ether    -           unmanaged
 26 eth24 ether    -           unmanaged
 27 eth25 ether    -           unmanaged
 28 eth26 ether    -           unmanaged
 29 eth27 ether    -           unmanaged
 30 eth28 ether    -           unmanaged

30 links listed.
root@bookworm-tactical1000:~# cat /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source /etc/network/interfaces.d/*
root@bookworm-tactical1000:~# ls /etc/network/interfaces.d/
dhcp
root@bookworm-tactical1000:~# cat /etc/network/interfaces.d/dhcp
auto lo
iface lo inet loopback

auto eth28
iface eth28 inet dhcp
root@bookworm-tactical1000:~#

```

Nothing happening here...

{{< blog-paragraph-header "Hardware" >}}

Overall the hardware left me wanting more. I think this is a good start, but
it's not the "enterprise-grade" switch I was hoping for for the simple reason
that I don't know any businesses that can live without 48 port switches or PoE.
I think this is firmly in the [SMB](https://en.wikipedia.org/wiki/Small_and_medium_enterprises)
category for now, and I hope they break through into the mainstream. I think
it's an excellent jumping point to help them build their upstream relationships
and prepare for the next steps.

```bash
root@bookworm-tactical1000:~# lspci -v
pcilib: Cannot open /proc/bus/pci
lspci: Cannot find any working access method.
root@bookworm-tactical1000:~# ls /sys/bus/pci
ls: cannot access '/sys/bus/pci': No such file or directory
root@bookworm-tactical1000:~# cat /proc/1/cgroup
0::/init.scope
root@bookworm-tactical1000:~# zcat /proc/config.gz > zconfig
root@bookworm-tactical1000:~# cat zconfig | grep PCI
CONFIG_HAVE_PCI=y
CONFIG_GENERIC_PCI_IOMAP=y
# CONFIG_PCI is not set
# CONFIG_COMMON_CLK_RS9_PCIE is not set
root@bookworm-tactical1000:~# lsmod
Module                  Size  Used by
root@bookworm-tactical1000:~#
```

{{< blog-paragraph-header "Performance" >}}

I wasn't able to assess performance, since this was really a standalone test
rig. The ASIC in this switch is the `Microchip LAN9696` which isn't hugely
powerful, but should do for most use-cases. I'm not an ASIC specialist, so I
look to others. I asked [@azonenberg@ioc.exchange](https://mastodon.social/@azonenberg@ioc.exchange)
what he thought to which he replied:

{{< blog-image src="azonenberg.png" caption="Restricted datasheet so I have no thoughts other than “I wouldn't use it in a design”" scale="100%" >}}

I do know that this chip can't handle 48 ports, so that limits its future use.
Maybe Microchip have something else that would suit that purpose? I can live
with a restricted datasheet as long as Novarq can fully implement what's needed
in the open.

{{< blog-paragraph-header "Operating system" >}}

Despite my great love for the Debian project and what it stands for, I do not
see it as a technologically forward-thinking distro. As a result, I rarely recommend
its use these days. I'd love to see this switch running a modern upstream like
Fedora. That would demonstrate its worth as a modern peer in my GNU+Linux
datacentre stack.

I want to see `systemd-networkd` and other modern networking tools being used. I
also want to see a good declarative configuration story in this space. All of
this is lacking at the moment.

My understanding is that all of the relevant Linux kernel patches and userspace
tweaks are not upstream yet, but that this work is well underway, and `Novarq`
has assured me that this is a core goal. Great job folks!

{{< blog-paragraph-header "Switchdev" >}}

[Switchdev](https://docs.kernel.org/networking/switchdev.html) is the name of
the Linux kernel magic that offloads (forwards) the data plane work from the
kernel. Basically you use the familiar Linux `ip` and `iptables` commands you're
used to, and Linux causes the ASIC to do the packet pushing on your behalf.

On the subject of integrating with the standard interfaces, more work may be
needed, and TBQH, I'm not the hardware specialist here.

```bash
root@bookworm-tactical1000:~# ethtool -p eth28
Cannot identify NIC: Operation not supported
root@bookworm-tactical1000:~# lspci -v
pcilib: Cannot open /proc/bus/pci
lspci: Cannot find any working access method.
root@bookworm-tactical1000:~# devlink dev eswitch show
Failed to connect to devlink Netlink
root@bookworm-tactical1000:~# bridge fdb show
33:33:00:00:00:01 dev eth0 self permanent
33:33:00:00:00:01 dev eth1 self permanent
33:33:00:00:00:01 dev eth2 self permanent
33:33:00:00:00:01 dev eth3 self permanent
33:33:00:00:00:01 dev eth4 self permanent
33:33:00:00:00:01 dev eth5 self permanent
33:33:00:00:00:01 dev eth6 self permanent
33:33:00:00:00:01 dev eth7 self permanent
33:33:00:00:00:01 dev eth8 self permanent
33:33:00:00:00:01 dev eth9 self permanent
33:33:00:00:00:01 dev eth10 self permanent
33:33:00:00:00:01 dev eth11 self permanent
33:33:00:00:00:01 dev eth12 self permanent
33:33:00:00:00:01 dev eth13 self permanent
33:33:00:00:00:01 dev eth14 self permanent
33:33:00:00:00:01 dev eth15 self permanent
33:33:00:00:00:01 dev eth16 self permanent
33:33:00:00:00:01 dev eth17 self permanent
33:33:00:00:00:01 dev eth18 self permanent
33:33:00:00:00:01 dev eth19 self permanent
33:33:00:00:00:01 dev eth20 self permanent
33:33:00:00:00:01 dev eth21 self permanent
33:33:00:00:00:01 dev eth22 self permanent
33:33:00:00:00:01 dev eth23 self permanent
33:33:00:00:00:01 dev eth24 self permanent
33:33:00:00:00:01 dev eth25 self permanent
33:33:00:00:00:01 dev eth26 self permanent
33:33:00:00:00:01 dev eth27 self permanent
33:33:00:00:00:01 dev eth28 self permanent
01:00:5e:00:00:01 dev eth28 self permanent
33:33:ff:54:3b:1e dev eth28 self permanent
root@bookworm-tactical1000:~# cd /sys/class/net/eth28/
root@bookworm-tactical1000:/sys/class/net/eth28# ls -l
total 0
-r--r--r--  1 root root 4096 Apr  3 09:00 addr_assign_type
-r--r--r--  1 root root 4096 Apr  6 22:13 addr_len
-r--r--r--  1 root root 4096 Apr  3 09:00 address
-r--r--r--  1 root root 4096 Apr  6 22:13 broadcast
-rw-r--r--  1 root root 4096 Apr  6 22:13 carrier
-r--r--r--  1 root root 4096 Apr  6 22:13 carrier_changes
-r--r--r--  1 root root 4096 Apr  6 22:13 carrier_down_count
-r--r--r--  1 root root 4096 Apr  6 22:13 carrier_up_count
-r--r--r--  1 root root 4096 Apr  6 22:13 dev_id
-r--r--r--  1 root root 4096 Apr  6 22:13 dev_port
lrwxrwxrwx  1 root root    0 Apr  6 22:13 device -> ../../../e00c0000.switch
-r--r--r--  1 root root 4096 Apr  6 22:13 dormant
-r--r--r--  1 root root 4096 Apr  6 22:13 duplex
-rw-r--r--  1 root root 4096 Apr  6 22:13 flags
-rw-r--r--  1 root root 4096 Apr  6 22:13 gro_flush_timeout
-rw-r--r--  1 root root 4096 Apr  6 22:13 ifalias
-r--r--r--  1 root root 4096 Apr  6 22:13 ifindex
-r--r--r--  1 root root 4096 Apr  3 09:00 iflink
-r--r--r--  1 root root 4096 Apr  6 22:13 link_mode
-rw-r--r--  1 root root 4096 Apr  6 22:13 mtu
-r--r--r--  1 root root 4096 Apr  3 09:00 name_assign_type
-rw-r--r--  1 root root 4096 Apr  6 22:13 napi_defer_hard_irqs
-rw-r--r--  1 root root 4096 Apr  6 22:13 netdev_group
lrwxrwxrwx  1 root root    0 Apr  6 22:13 of_node -> ../../../../../../firmware/devicetree/base/axi/switch@e00c0000/ethernet-ports/port@29
-r--r--r--  1 root root 4096 Apr  6 22:13 operstate
lrwxrwxrwx  1 root root    0 Apr  6 22:13 phydev -> ../../../e20101a8.mdio/mdio_bus/e20101a8.mdio-mii/e20101a8.mdio-mii:03
-r--r--r--  1 root root 4096 Apr  3 09:00 phys_port_name
-r--r--r--  1 root root 4096 Apr  6 22:13 phys_switch_id
drwxr-xr-x  2 root root    0 Apr  6 22:13 power
-rw-r--r--  1 root root 4096 Apr  6 22:13 proto_down
drwxr-xr-x 11 root root    0 Apr  6 22:13 queues
-r--r--r--  1 root root 4096 Apr  6 22:13 speed
drwxr-xr-x  2 root root    0 Apr  6 22:13 statistics
lrwxrwxrwx  1 root root    0 Jun 26  2025 subsystem -> ../../../../../../class/net
-r--r--r--  1 root root 4096 Apr  6 22:13 testing
-rw-r--r--  1 root root 4096 Apr  6 22:13 threaded
-rw-r--r--  1 root root 4096 Apr  6 22:13 tx_queue_len
-r--r--r--  1 root root 4096 Apr  3 09:00 type
-rw-r--r--  1 root root 4096 Jun 26  2025 uevent
root@bookworm-tactical1000:/sys/class/net/eth28# cat phys_switch_id
5e37b6543b00
root@bookworm-tactical1000:/sys/class/net/eth28# cat phys_port_name
p29
root@bookworm-tactical1000:/sys/class/net/eth28#
```

Not sure what's going on here... Perhaps there's still some work to do.

```bash
root@bookworm-tactical1000:~# ethtool eth28
Settings for eth28:
        Supported ports: [ TP    MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Advertised pause frame use: Symmetric Receive-only
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
                                             1000baseT/Full
        Link partner advertised pause frame use: Symmetric Receive-only
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Auto-negotiation: on
        master-slave cfg: preferred master
        master-slave status: master
        Port: Twisted Pair
        PHYAD: 3
        Transceiver: external
        MDI-X: Unknown (auto)
        Link detected: yes
root@bookworm-tactical1000:~#
```

{{< blog-paragraph-header "Bridging" >}}

I want a switch, so I assume I need to...

```bash
root@bookworm-tactical1000:~# ip link add br0 type bridge
root@bookworm-tactical1000:~# ip link set eth6 master br0
root@bookworm-tactical1000:~# ip link set eth7 master br0
root@bookworm-tactical1000:~# brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.eeed49fda19c       no              eth6
                                                        eth7
root@bookworm-tactical1000:~# bridge -s link
8: eth6: <BROADCAST,MULTICAST> mtu 1500 master br0 state disabled priority 32 cost 100
9: eth7: <BROADCAST,MULTICAST> mtu 1500 master br0 state disabled priority 32 cost 100
root@bookworm-tactical1000:~#
```

Again, I couldn't test this, so I hope good documentation is coming soon.

{{< blog-paragraph-header "Mgmt Config" >}}

I tried to build [`mgmt`](https://github.com/purpleidea/mgmt/) directly on the
switch, but the debian golang version is so ancient, and it wasn't immediately
obvious how to get something modern on there so I gave up and did a cross-build:

```bash
time env CGO_ENABLED=0 GOARCH=arm64 go build -ldflags=github.com/purpleidea/mgmt="-X main.program=mgmt -X main.version=tactical" -o mgmt-linux-arm64 -tags 'noaugeas novirt nodocker'
```

With all the main components compiled in, `mgmt` sits at a whopping `157M`. It
could be trimmed down to optimize for this hardware, but there hasn't been a
customer request for this yet.

```bash
root@bookworm-tactical1000:~# ./mgmt-linux-arm64 --version
tactical
```

Made a custom version for the test =D

```bash
root@bookworm-tactical1000:~# ./mgmt-linux-arm64 run --tmp-prefix lang hello0.mcl
This is: mgmt, version: tactical
Copyright (C) James Shubin and the project contributors
Written by James Shubin <james@shubin.ca> and the project contributors
21:37:16 main: start: 1775511436860679385
21:37:16 cli: lang: lexing/parsing...
21:37:16 cli: lang: import: /root/
21:37:16 cli: lang: running type unification...
21:37:16 cli: lang: unification: found a solution of length: 6
21:37:16 cli: lang: collecting files...
21:37:16 main: warning: working prefix directory is temporary!
21:37:16 main: working prefix is: /tmp/mgmt-bookworm-tactical1000-3992880798
21:37:23 pgp: created key: 07CE4F49
21:37:23 main: no seeds specified!
21:37:23 etcd: running...
21:37:23 etcd: waiting for server...
21:37:23 etcd: server: runServer: (newCluster=true): bookworm-tactical1000=http://localhost:2380
21:37:23 etcd: server: starting...
21:37:23 etcd: server: ready
21:37:23 main: etcd is ready!
21:37:23 main: waiting...
21:37:23 main: running...
21:37:23 gapi: lang: lexing/parsing...
21:37:23 gapi: lang: lexing/parsing took: 2.49542ms
21:37:23 gapi: lang: import: /
21:37:23 gapi: lang: interpolating took: 67.272µs
21:37:23 gapi: lang: scope building took: 661.277µs
21:37:23 gapi: lang: running type unification...
21:37:23 gapi: lang: unification: found a solution of length: 6
21:37:23 gapi: lang: type unification took: 1.575736ms
21:37:23 gapi: lang: building function graph...
21:37:23 gapi: lang: building function graph took: 243.234µs
21:37:23 gapi: lang: function graph: Vertices(3), Edges(0)
21:37:23 gapi: lang: function engine initializing...
21:37:23 main: waiting...
21:37:23 gapi: lang: stream...
21:37:23 gapi: lang: function engine starting...
21:37:23 gapi: lang: interpret: interpreting...
21:37:23 gapi: generating new graph...
21:37:23 main: new graph took: 1.104µs
21:37:23 engine: autoedge: building...
21:37:23 main: auto edges took: 425.135µs
21:37:23 engine: autogroup: algorithm: wrappedGrouper: NonReachabilityGrouper...
21:37:23 main: auto grouping took: 378.495µs
21:37:23 main: resource topological sort took: 14.776µs
21:37:23 main: send/recv building took: 848ns
21:37:23 main: commit...
21:37:23 engine: graph sync...
21:37:23 main: export cleanup took: 36.616µs
21:37:23 main: graph: Vertices(1), Edges(0)
21:37:23 main: waiting...
21:37:23 engine: file[/tmp/mgmt-hello-world]: copy 29 bytes
^C21:37:26 interrupted by ^C
21:37:26 main: destroy...
21:37:26 main: deploy: exited
21:37:26 main: loop: exited
21:37:26 engine: graph sync...
21:37:26 etcd: server: runServer: done!
21:37:26 etcd: exited!
21:37:26 main: goodbye!
root@bookworm-tactical1000:~#
```

It works!

The next step would be using the `net` resource to manage these ports. It would
also make sense to have add a `bridge` resource as well.

An understated elegant aspect to the design of `mgmt` is that since it works as
a distributed system, it can receive the "algorithm" (of mcl code) and then
operate autonomously from the rest of the cluster to perform changes. If for
example, the network connection to the rest of the cluster goes down, this isn't
a problem. It will perform it's work, and then reconnect when ready. This means
you can modify switch topologies without worrying about the SSH connection
failing midway like you might with other tools.

Furthermore, you can programmatically "roll back" a change and then notify the
sysadmin if a reconfiguration subsequently didn't pass a "network health check"
meaning `mgmt` can make it harder to lock yourself out from remote management!

{{< blog-paragraph-header "Golang" >}}

The initial blog post that caught my eye was [this one](https://novarq.com/blogs/insights/beyond-linux-bare-metal-go-on-tactical-1000-with-tamago)
about running `golang` directly on the switch. I was curious, but *switchdev* is
what caused me to stick around and dig deeper. I think it might be cute in some
specialized scenarios to run a pure golang switch, but that's not the mainstream
and switchdev could be and that doesn't preclude adding golang on top if you've
got a mainstream GNU+Linux distro.

{{< blog-paragraph-header "Openness" >}}

Their site proclaims: "OPEN STANDARDS. OPEN INFRASTRUCTURE. YOUR SOVEREIGNTY.".
I love this, I'm onboard. But to succeed you have to be _better_, since freedom
isn't as marketable as we'd all like. Once you're better, you have to make sure
you hold onto those values!

{{< blog-paragraph-header "Provisioning" >}}

The switch came fully provisioned so I don't know how you would do a base
install. I would hope that it can UEFI (PXE) netboot like all of my other
servers.

{{< blog-paragraph-header "Port numbering" >}}

Just a small thought for the future. Look at a 48 port patch panel.

{{< blog-image src="48-port-patch-panel.jpg" caption="48 port patch panel" scale="100%" >}}

Now look at a 48 port switch...

{{< blog-image src="48-port-switch.jpg" caption="48 port switch" scale="100%" >}}

It would be so awesome if the switch vendors did the numbering left-to-right,
top-to-bottom, like reading a book. This is less of an issue with the 24 port
switches, but I hope we'll be past those soon. Just an idea.

{{< blog-paragraph-header "Conclusion" >}}

I'm looking forward to seeing more from these folks. What's missing:

* 1U, 48 port switch (w/ 2-4 10G uplinks) and PoE.
* Fully upstream so anyone can install a stock aarch64 distro like Fedora.
* Better CPU, more RAM and more storage. RAID 1 would be sweet.
* Light documentation for recommended best practices.
* Great automation story.

I hope to help out with that last point some day, and [mgmt](https://mgmtconfig.com/)
and [m9rx.com](https://m9rx.com) are here to build with anyone who wants to see
their hardware magically come to life. You do the hard electrical engineering,
we'll make usability a dream.

Happy hacking!

James

PS: Special thanks to Luka Perkov and Todd Gregory for setting this all up for
me. Best of luck to you all!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
