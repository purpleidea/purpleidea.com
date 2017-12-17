+++
date = "2013-01-03 04:25:15"
title = "Clustering virtual machines with rgmanager and clusvcadm"
draft = "false"
categories = ["technical"]
tags = ["virtual machine", "vm", "audit.log", "clustering", "devops", "virsh", "clusvcadm", "rgmanager", "selinux"]
author = "jamesjustjames"
+++

This <em>could</em> be a post detailing how to host clustered virtual machines with <a href="https://fedorahosted.org/cluster/wiki/RGManager">rgmanager</a> and clusvcadm, but that is a longer story and there is much work to do. For now, I will give you a short version including an informative "gotcha".

With my cluster up and running, I added a virtual machine entry to my <em>cluster.conf</em>:
```
<vm name="test1" domain="somedomain" path="/shared/vm/" autostart="0" exclusive="0" recovery="restart" use_virsh="1" />
```
This goes inside the <em><rm></em> block. As a benchmark, please note that starting the machine with <em>virsh</em> worked perfectly:
```
[root@server1 ~]# virsh create /shared/vm/test1.xml --console
(...The operation worked perfectly!)
```
However, when I attempted to use the cluster aware tools, all I got was failure:
```
[root@server1 ~]# clusvcadm -e 'vm:test1' -m server1
Member server1 trying to enable vm:test1...<strong>Failure</strong>
```
Whenever I think I've done everything right, but something is still not working, I first check to see if I can blame someone else. Usually that someone is <a href="http://en.wikipedia.org/wiki/Security-Enhanced_Linux">selinux</a>. Make no mistake, selinux is a good thing<sup>™</sup>, however it does still cause me pain.

The first clue is to remember that <em>/var/log/</em> contains other files besides "<em>messages</em>". Running a <a title="continuous display of log files (better tail -f)" href="http://ttboj.wordpress.com/2012/11/18/continuous-display-of-log-files-better-tail-f/">tail</a> on <em>/var/log/audit/audit.log</em> while simultaneously running the above <em>clusvcadm</em> command revealed:
```
type=AVC msg=audit(1357202069.310:10904): avc:  denied  { read } for  pid=15675 comm="virsh" name="test1.xml" dev=drbd0 ino=198628 scontext=unconfined_u:system_r:xm_t:s0 tcontext=unconfined_u:object_r:default_t:s0 tclass=file
type=SYSCALL msg=audit(1357202069.310:10904): arch=c000003e syscall=2 success=no exit=-13 a0=24259e0 a1=0 a2=7ffff03af0d0 a3=7ffff03aee10 items=0 ppid=15609 pid=15675 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=1 comm="virsh" exe="/usr/bin/virsh" subj=unconfined_u:system_r:xm_t:s0 key=(null)
```
I am not a magician, but if I was, I would probably understand what all of that means. For now, let's pretend that we do. Closer inspection (or grep) will reveal:
<ul>
	<li>"<em>test1.xml</em>" (the definition for the virtual machine)</li>
</ul>
and:
<ul>
	<li>"/usr/bin/virsh" (the command that I expect rgmanager's <em>/usr/share/cluster/vm.sh</em> script to run)</li>
</ul>
A quick:
```
[root@server1 ~]# selinuxenabled && echo t || echo f
t
```
to confirm that selinux is auditing away, and a short:
```
[root@server1 ~]# /bin/echo 0 > /selinux/enforce
```
to temporarily test my theory, and:
```
[root@server1 ~]# clusvcadm -e 'vm:test1' -m server1
Member server1 trying to enable vm:test1...<strong>Success</strong>
vm:test1 is now running on server1
```
Presto change-o, the diagnosis is complete. This is a development system, and so for the time being, I will accept defeat and workaround this problem by turning selinux off, but this is most definitely the wrong solution. If you're an selinux guru who knows the proper fix, please let me know! Until then,

Happy Hacking,

James

&nbsp;

