+++
date = "2016-03-14 00:50:48"
title = "Automatic edges in mgmt"
draft = "false"
categories = ["technical"]
tags = ["apt-get", "autoedge", "autoedges", "deb", "devops", "dnf", "dpkg", "gluster", "libvirt", "mgmt", "mgmtconfig", "network", "packagekit", "pkcon", "pkg", "planetdevops", "planetfedora", "planetpuppet", "puppet", "rpm", "systemd", "yum"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/03/14/automatic-edges-in-mgmt/"
+++

It's been <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">two months since I announced mgmt</a>, and now it's time to continue the story by telling you more about the design of <a href="https://github.com/purpleidea/mgmt/">what's now in git master</a>. Before I get into those details, let me quickly <a href="https://www.youtube.com/watch?v=M4vqr3_ROIk&t=748&html5=1">recap</a> what's happened since then.

<span style="text-decoration:underline;">Mgmt community recap</span>:

<ul>
    <li>I gave the first public presentation about mgmt at <a href="http://cfgmgmtcamp.eu/schedule/speakers/JamesShubin.html">CfgMgmtCamp</a>.</li>
    <li>I repeated the talk at <a href="https://devconfcz2016.sched.org/event/5m14/next-generation-config-mgmt">DevConf.cz</a>. <a href="https://www.youtube.com/watch?v=GVhpPF0j-iE&html5=1">The video recording is available.</a></li>
    <li>Felix wrote about his work <a href="https://ffrank.github.io/features/2016/02/18/from-catalog-to-mgmt/">cross compiling puppet code to mgmt</a>.</li>
    <li><a href="https://github.com/purpleidea/mgmt/graphs/contributors">Three new contributors</a> got their feet wet in git master.</li>
    <li><a href="https://github.com/purpleidea/mgmt/#on-the-web">Mgmt got a lot more attention on the web...</a></li>
</ul>

Okay, time to tell you what's new in mgmt!

<span style="text-decoration:underline;">Types vs. resources</span>:

Configuration management systems have the concept of primitives for the basic building blocks of functionality. The well-known ones are "package", "file", "service" and "exec" or "execute". <a href="https://docs.chef.io/resource.html">Chef calls these "resources"</a>, while <a href="https://docs.puppetlabs.com/puppet/latest/reference/type.html">puppet (misleadingly) calls them "types"</a>.

I made the mistake of calling the primitives in mgmt, "types", no doubt due to <a href="/tags/puppet/">my extensive background in puppet</a>, however this overloads the word because it usually refers to <a href="https://en.wikipedia.org/wiki/Type_system">programming types</a>, so I've decided not to use it any more to refer to these primitives. The Chef folks got this right! From now on they'll be <a href="https://github.com/purpleidea/mgmt/commit/3a8538437743d2151c73c108f75a93d6f1fbff17">referred to as "resources"</a> or "res" when abbreviated.

Mgmt now has: "<a href="https://github.com/purpleidea/mgmt/blob/master/resources.go#L18">noop</a>", "<a href="https://github.com/purpleidea/mgmt/blob/master/file.go#L18">file</a>", "<a href="https://github.com/purpleidea/mgmt/blob/master/svc.go#L18">svc</a>", "<a href="https://github.com/purpleidea/mgmt/blob/master/exec.go#L18">exec</a>", and now: "<a href="https://github.com/purpleidea/mgmt/blob/master/pkg.go#L18">pkg</a>"...

<span style="text-decoration:underline;">The package (pkg) resource</span>:

The most obvious change to mgmt, is that it now has a <a href="https://github.com/purpleidea/mgmt/commit/3b5678dd91945427b0fb8a86992c7d9117819ff6">package resource</a>. I've named it "pkg" because we hackers prefer to keep strings short. Creating a pkg resource is difficult for two reasons:

<ol>
    <li>Mgmt is event based</li>
    <li>Mgmt should support many package managers</li>
</ol>

Event based systems would involve an inotify watch on the <code>rpmdb</code> (or a similar watch on <code>/var/lib/dpkg/</code>), and the logic to respond to it. This engineering problem boils down to being able to support the entire matrix of possible GNU/Linux packaging systems. Yuck! Additionally, it would be particularly unfriendly if we primarily supported RPM and DNF based systems, but left the DPKG and APT backend out as "an exercise for the community".

Therefore, we solve both of these problems by basing the pkg resource on the excellent <a href="https://www.freedesktop.org/software/PackageKit/">PackageKit project</a>! PackageKit provides the events we need, and more importantly, it <a href="https://www.freedesktop.org/software/PackageKit/pk-matrix.html">supports many backends</a> already! If there's ever a new backend that needs to be added, you can add it upstream in PackageKit, and everyone (including mgmt) will benefit from your work.

As a result, I'm proud to announce that both Debian and Fedora, (and many other friends) all got a working pkg resource on day one. Here's a small demo:

Run mgmt:

```
root@debian:~/mgmt# time ./mgmt run --file examples/pkg1.yaml 
18:58:25 main.go:65: This is: mgmt, version: 0.0.2-41-g963f025<em>
[snip]</em>
18:18:44 pkg.go:208: Pkg[powertop]: CheckApply(true)
18:18:44 pkg.go:259: Pkg[powertop]: Apply
18:18:44 pkg.go:266: Pkg[powertop]: Set: installed...
18:18:52 pkg.go:284: Pkg[powertop]: Set: installed success!
```
The "powertop" package will install... Now while mgmt is still running, remove powertop:

```
root@debian:~# pkcon remove powertop
Resolving                     [=========================]         
Testing changes               [=========================]         
Finished                      [=========================]         
Removing                      [=========================]         
Loading cache                 [=========================]         
Running                       [=========================]         
Removing packages             [=========================]         
Committing changes            [=========================]         
Finished                      [=========================]         
root@debian:~# which powertop
/usr/sbin/powertop
```
It gets installed right back! Similarly, you can do it like this:

```
root@debian:~# apt-get -y remove powertop
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libnl-3-200 libnl-genl-3-200
Use 'apt-get autoremove' to remove them.
The following packages will be REMOVED:
  powertop
0 upgraded, 0 newly installed, 1 to remove and 80 not upgraded.
After this operation, 542 kB disk space will be freed.
(Reading database ... 47528 files and directories currently installed.)
Removing powertop (2.6.1-1) ...
Processing triggers for man-db (2.7.0.2-5) ...
root@debian:~# which powertop
/usr/sbin/powertop
```
And it will also get installed right back! Try it yourself to see it happen "live"! Similar behaviour can be seen on Fedora and other distros.

As a quite aside. If you're a C hacker, and you would like to help with the upstream PackageKit project, they would surely love your contributions, and in particular, we here working on mgmt would especially like it if you worked on any of the open issues that we've uncovered. In order from increasing to decreasing severity, they are: <a href="https://github.com/hughsie/PackageKit/issues/118">#118 (please help!)</a>, <a href="https://github.com/hughsie/PackageKit/issues/117">#117 (needs love)</a>, <a href="https://github.com/hughsie/PackageKit/issues/110">#110 (needs testing)</a>, and <a href="https://github.com/hughsie/PackageKit/issues/116">#116 (would be nice to have)</a>. If you'd like to test mgmt on your favourite distro, and report and fix any issues, that would be helpful too!

<span style="text-decoration:underline;">Automatic edges</span>:

Since we're now hooked into the pkg resource, there's no reason we can't use that wealth of knowledge to make mgmt more powerful. For example, the PackageKit API can give us the list of files that a certain package would install. Since any file resource would obviously want to get "applied" after the package is installed, we use this information to automatically generate the relationships or "edges" in the graph. This means that module authors don't have to waste time manually adding or updating the "require" relationships in their modules!

For example, the <code>/etc/drbd.conf</code> file, will want to require the <code>drbd-utils</code> package to be installed first. With traditional config management systems, without this dependency chain, after one run, your system will not be in a converged state, and would require another run. With mgmt, since it is event based, it <em>would</em> converge, except it might run in a sub-optimal order. That's one reason why we add this dependency for you automatically.

This is represented via what mgmt calls the "AutoEdges" API. (If you can think of a better name, please tell me now!) It's also worth noting that this isn't entirely a novel idea. Puppet has a concept of "autorequires", which is used for some of their resources, but doesn't work with packages. I'm particularly proud of my design, because in my opinion, I think the API and mechanism in mgmt are much more powerful and logical.

Here's a small demo:

```
james@fedora:~$ ./mgmt run --file examples/autoedges3.yaml 
20:00:38 main.go:65: This is: mgmt, version: 0.0.2-42-gbfe6192
<em>[snip]</em>
20:00:38 configwatch.go:54: Watching: examples/autoedges3.yaml
20:00:38 config.go:248: Compile: Adding AutoEdges...
20:00:38 config.go:313: Compile: Adding AutoEdge: Pkg[drbd-utils] -> Svc[drbd]
20:00:38 config.go:313: Compile: Adding AutoEdge: Pkg[drbd-utils] -> File[file1]
20:00:38 config.go:313: Compile: Adding AutoEdge: Pkg[drbd-utils] -> File[file2]
20:00:38 main.go:149: Graph: Vertices(4), Edges(3)
<em>[snip]</em>
```
Here we define four resources: pkg (<code>drbd-utils</code>), svc (<code>drbd</code>), and two files (<code>/etc/drbd.conf</code> and <code>/etc/drbd.d/</code>), both of which happen to be listed inside the RPM package! The AutoEdge magic works out these dependencies for us by examining the package data, and as you can see, adds the three edges. Unfortunately, there is no elegant way that I know of to add an automatic relationship between the svc and any of these files at this time. Suggestions welcome.

Finally, we also use the same interface to make sure that a parent directory gets created before any managed file that is a child of it.

<span style="text-decoration:underline;">Automatic edges internals</span>:

How does it work? Each resource has a method to generate a "unique id" for that resource. This happens in the "UIDs" method. Additionally, each resource has an "AutoEdges" method which, unsurprisingly, generates an "AutoEdge" object (struct). When the compiler is generating the graph and adding edges, it calls two methods on this AutoEdge object:

<ol>
    <li>Next()</li>
    <li>Test(...)</li>
</ol>

The Next() method produces a list of possible matching edges for that resource. Whichever edges match are added to the graph, and the results of each match is fed into the Test(...) function. This information is used to tell the resource whether there are more potential matches available or not. The process iterates until Test returns false, which means that there are no other available matches.

This ensures that a file: <code>/var/lib/foo/bar/baz/</code> will first seek a dependency on <code>/var/lib/foo/bar/</code>, but be able to fall back to <code>/var/lib/</code> if that's the first file resource available. This way, we avoid adding more resource dependencies than necessary, which would diminish the amount of <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">parallelism</a> possible, while running the graph.

Lastly, it's also worth noting that users can choose to disable AutoEdges per resource if they so desire. If you've got an idea for a clever automatic edge, please <a href="/contact/">contact me</a>, send a patch, or leave the information in the <a href="#comments">comments</a>!

<span style="text-decoration:underline;">Contributing</span>:

Good ideas and designs help, but <a href="https://webchat.freenode.net/?channels=#mgmtconfig">contributors is what will make the project</a>. All sorts of help is appreciated, and you can join in even if you're not an "expert". I'll try and tag "easy" or "first time" patches with the "<a href="https://github.com/purpleidea/mgmt/labels/mgmtlove">mgmtlove</a>" tag. Feel free to work on other issues too, or <a href="https://github.com/purpleidea/mgmt/issues/">suggest something</a> that you think will help! Want to add more interesting resources! Anyone want to write a libvirt resource? How about a network resource? Use your imagination!

Lastly, thanks to both <a href="https://github.com/hughsie/">Richard</a> and <a href="https://github.com/ximion/">Matthias Klumpp</a> in particular from the <a href="https://github.com/hughsie/PackageKit/">PackageKit project</a> for their help so far, and to everyone else who has contributed in some way.

That's all for today. I've got more exciting things coming. Please <a href="https://github.com/purpleidea/mgmt/">contribute</a>!

Happy Hacking!

James

