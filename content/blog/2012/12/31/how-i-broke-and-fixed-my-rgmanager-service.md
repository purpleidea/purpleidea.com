+++
date = "2012-12-31 00:34:45"
title = "How I broke (and fixed) my rgmanager service"
draft = "false"
categories = ["technical"]
tags = ["clustat", "clustering", "rgmanager", "clusvcadm", "devops"]
author = "jamesjustjames"
+++

<a href="https://fedorahosted.org/cluster/wiki/RGManager">Rgmanager</a>, clustat and clusvcadm are useful tools in cluster land. I recently built a custom resource which I added to one of my service chains. Upon inspecting clustat, I noticed:
```
[root@server1 ~]# clustat
Member Status: Quorate

Member Name                             ID   Status
------ ----                             ---- ------
server1                                 1 Online, Local, rgmanager
server2                                 2 Online, rgmanager

Service Name                   Owner (Last)                   State
------- ----                   ----- ------                   -----
service:service-main-server1   (server1)                      <strong>failed</strong>

```
Looking at <em>/var/log/messages</em>, I found:
```
server1 rgmanager: [script] script:shorewall-reload: start of shorewall-reload.sh failed (returned 2)
server1 rgmanager: start on script "shorewall-reload" returned 1 (generic error)
```
This was peculiar, because my script didn't have an exit code of <em>2</em> anywhere. It was due to a syntax error (woops)! Moving on with the syntax error fixed, I had trouble getting the service going again. In the logs I found these:
```
server1 rgmanager: #68: Failed to start service:service-main-server1; return value: 1
server1 rgmanager: Stopping service service:service-main-server1
server1 rgmanager: #12: RG service:service-main-server1 failed to stop; intervention required
server1 rgmanager: Service service:service-main-server1 is failed
server1 rgmanager: #13: Service service:service-main-server1 failed to stop cleanly
```
Running commands like: <em>clusvcadm -e service-main-server1</em> didn't help. It turns out that you have to first convince rgmanager that you truly <em>fixed</em> the problem, by first disabling the service. Now you can safely enable it and things should work smoothly:
```
clusvcadm -d service-main-server1
clusvcadm -e service-main-server1
```
Hopefully you've now got your feet wet with this clustering intro! Remember that you can look in the logs for clues and run <em>clustat -i 1</em> in a screen session to keep tabs on things.

Happy Hacking,

James

&nbsp;

