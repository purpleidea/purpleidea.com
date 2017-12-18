+++
date = "2016-06-20 12:28:51"
title = "Automatic clustering in mgmt"
draft = "false"
categories = ["technical"]
tags = ["clustering", "devops", "elastic", "embedded", "etcd", "gluster", "golang", "mgmt", "mgmtconfig", "planetdevops", "planetfedora", "planetpuppet", "puppet", "raft"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/06/20/automatic-clustering-in-mgmt/"
+++

In <a href="https://github.com/purpleidea/mgmt/">mgmt</a>, deploying and managing your clustered config management infrastructure needs to be as automatic as the infrastructure you're using mgmt to manage. With mgmt, instead of a centralized data store, we function as a distributed system, built on top of <a href="https://github.com/coreos/etcd">etcd</a> and the <a href="https://en.wikipedia.org/wiki/Raft_(computer_science)">raft protocol</a>.

In this article, I'll cover how this feature works.

<strong><span style="text-decoration:underline;">Foreword</span>:</strong>

Mgmt is a next generation configuration management project. If you haven't heard of it yet, or you don't remember why we use a distributed database, start by reading the previous articles:

<ul>
    <li><a href="/blog/2016/01/18/next-generation-configuration-mgmt/">Next generation config mgmt</a></li>
    <li><a href="/blog/2016/03/14/automatic-edges-in-mgmt/">Automatic edges in mgmt</a></li>
    <li><a href="/blog/2016/03/30/automatic-grouping-in-mgmt/">Automatic grouping in mgmt</a></li>
</ul>

<strong><span style="text-decoration:underline;">Embedded etcd</span>:</strong>

Since mgmt and etcd are both written in <a href="https://en.wikipedia.org/wiki/Golang">golang</a>, the etcd code can be built into the same binary as mgmt. As a result, etcd can be managed directly from within mgmt. Unfortunately, there's currently no recommended API to do this, but I've tried to get such a feature <a href="https://github.com/coreos/etcd/pull/5584">upstream</a> to avoid code duplication in mgmt. If you can help out here, I'd really appreciate it! In the meantime, I've had to <a href="https://github.com/purpleidea/mgmt/commit/d26b503dcaa59707723212db8c2d86af0c1b0d30">copy+paste the necessary portions into mgmt</a>.

<strong><span style="text-decoration:underline;">Clustering mechanics</span>:</strong>

You can deploy an automatically clustered mgmt cluster by following these three steps:

1) If no mgmt servers exist you can start one up by running mgmt normally:

```
./mgmt run --file examples/graph0.yaml
```
2) To add any subsequent mgmt server, run mgmt normally, but point it at any number of existing mgmt servers with the <code>--seeds</code> command:

```
./mgmt run --file examples/graph0.yaml --seeds <ip address:port>
```
3) Profit!

We internally implement a clustering algorithm which does the hard-working of building and managing the etcd cluster for you, so that you don't have to. If you're interested, keep reading to find out how it works!

<strong><span style="text-decoration:underline;">Clustering algorithm</span>:</strong>

The clustering algorithm works as follows:

If you aren't given any seeds, then assume you are the first etcd server (peer) and start-up. If you are given a seeds argument, then connect to that peer to join the cluster as a client. If you'd like to be promoted to a server, then you can "volunteer" by setting a special key in the cluster data store.

The existing cluster of peers will decide if they want additional peers, and if so, they can "nominate" someone from the pool of volunteers. If you have been nominated, you can start-up an etcd peer and peer with the rest of the cluster. Similarly, the cluster can decide to un-nominate a peer, and if you've been un-nominated, then you should shutdown your etcd server.

All cluster decisions are made by consensus using the raft algorithm. In practice this means that the elected cluster leader looks at the state of the system, and makes the necessary nomination changes.

Lastly, if you don't want to be a peer any more, you can revoke your volunteer message, which will be seen by the cluster, and if you were running a server, you should receive an un-nominate message in response, which will let you shutdown cleanly.

<strong><span style="text-decoration:underline;">Disclaimer</span>:</strong>

It's probably worth mentioning that the <a href="https://github.com/purpleidea/mgmt/commit/5363839ac849bd257ec40eba026a7934aa756868">current implementation</a> has a few issues, and at least one <a href="https://en.wikipedia.org/wiki/Race_condition">race</a>. The goal is to have it polished up by the time etcd v3 is released, but it's perfectly usable for testing and experimentation today! If you don't want to automatically cluster, you can always use the <code>--no-server</code> flag, and point mgmt at a manually managed mgmt cluster using the <code>--seeds</code> flag.

<strong><span style="text-decoration:underline;">Testing</span>:</strong>

Testing this feature on a single machine makes development and experimentation easier, so as a result, there are a few flags which make this possible.

<code>--hostname</code> <hostname>
With this flag, you can force your mgmt client to pretend it is running on a host with the above mentioned name. You can use this to specify <code>--hostname h1</code>, or <code>--hostname h2</code>, and so on; one for each mgmt agent you want to run on the same machine.

<code>--server-urls</code> <ip:port>
With this flag you can specify which IP address and port the etcd server will listen on for peer requests. By default this will use <code>127.0.0.1:2379</code>, but when running multiple mgmt agents on the same machine you'll need to specify this manually to avoid collisions. You can specify as many IP address and port pairs as you'd like by separating them with commas or semicolons. The <code>--peer-urls</code> flag is an alias which does the same thing.

<code>--client-urls</code> <ip:port>
This flag specifies which IP address and port the etcd server will listen on for client connections. It defaults to <code>127.0.0.1:2380</code>, but you'll occasionally want to specify this manually for the same reasons as mentioned above. You can specify as many IP address and port pairs as you'd like by separating them with commas or semicolons. This is the address that will be used by the <code>--seeds</code> flag when joining an existing cluster.

<strong><span style="text-decoration:underline;">Elastic clustering</span>:</strong>

In the future, you'll be able to specify a much more elaborate method to decide how many hosts should be promoted into peers, and which hosts should be nominated or un-nominated when growing or shrinking the cluster.

At the moment, we do the grow or shrink operation when the current peer count does not match the requested cluster size. This value has a default of 5, and can even be changed dynamically. To do so you can run:

```
ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2379 put /_mgmt/idealClusterSize 3
```
You can also set it at start-up by using the <code>--ideal-cluster-size</code> flag.

<strong><span style="text-decoration:underline;">Example</span>:</strong>

Here's a real example if you want to dive in. Try running the following four commands in separate terminals:

```
./mgmt run --file examples/etcd1a.yaml --hostname h1 --ideal-cluster-size 3
./mgmt run --file examples/etcd1b.yaml --hostname h2 --seeds http://127.0.0.1:2379 --client-urls http://127.0.0.1:2381 --server-urls http://127.0.0.1:2382
./mgmt run --file examples/etcd1c.yaml --hostname h3 --seeds http://127.0.0.1:2379 --client-urls http://127.0.0.1:2383 --server-urls http://127.0.0.1:2384
./mgmt run --file examples/etcd1d.yaml --hostname h4 --seeds http://127.0.0.1:2379 --client-urls http://127.0.0.1:2385 --server-urls http://127.0.0.1:2386
```
Once you've done this, you should have a three host cluster! Check this by running any of these commands:

```
ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2379 member list
ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2381 member list
ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2383 member list
```
Note that you'll need a v3 beta version of the <code>etcdctl</code> command which you can get by running <code>./build</code> in the <a href="https://github.com/coreos/etcd">etcd git repo</a>.

To grow your cluster, try increasing the desired cluster size to five:

```
ETCDCTL_API=3 etcdctl --endpoints 127.0.0.1:2381 put /_mgmt/idealClusterSize 5
```
You should see the last host start-up an etcd server. If you reduce the <code>idealClusterSize</code>, you'll see servers shutdown! You're responsible if you destroy the cluster by setting it too low! You can then try growing your cluster again, but unfortunately due to a bug, hosts can't be re-used yet, and you'll get a "bind: address already in use" error. We hope to have this fixed shortly!

<strong><span style="text-decoration:underline;">Security</span>:</strong>

Unfortunately no authentication security or transport security has been implemented yet. We have a great design, but are busy working on other parts of the project at the moment. If you'd like to help out here, <a href="/contact/">please let us know</a>!

<strong><span style="text-decoration:underline;">Future work</span>:</strong>

There's still a lot of work to do, to improve this feature. The biggest challenge has been getting a reasonable <a href="https://github.com/coreos/etcd/pull/5584">embedded server API upstream</a>. It's not clear whether this patch can be made to work or if something different will need to be written, but <a href="https://github.com/openshift/origin/tree/master/pkg/cmd/server/etcd/etcdserver">at least one other project</a> looks like it could benefit from this as well.

<strong><span style="text-decoration:underline;">Video</span>:</strong>

<a href="https://www.youtube.com/watch?v=KVmDCUA42wc">A recording from the recent Berlin CoreOSFest 2016 has been published!</a> I demoed these recent features, but one interesting note is that I am actually presenting an earlier version of the code which used the etcd V2 API. I've since ported the code to V3, but it is functionally similar. It's probably worth mentioning, that I found the V3 API to be more difficult, but also more correct and powerful. I think it is a net improvement to the project.

<strong><span style="text-decoration:underline;">Community</span>:</strong>

I can't end this blog post without mentioning some of the great stuff that's been happening in the mgmt community! In particular, <a href="https://ffrank.github.io/">Felix</a> has written <a href="https://github.com/purpleidea/mgmt/commit/8f83ecee65e070da53fc884e5a7ddbf93b7af1f6">some great code</a> to run existing Puppet code on mgmt. <a href="https://ffrank.github.io/features/2016/06/19/puppet-powered-mgmt/">Check out his work!</a>

<strong><span style="text-decoration:underline;">Upcoming speaking</span>:</strong>

I've got some upcoming speaking in <a href="https://2016.opensource.hk/topics/next-generation-config-mgmt/">Hong Kong at HKOSCon16</a> and in <a href="https://debconf16.debconf.org/">Cape Town at DebConf16</a> about the project. Please ping me if you'll be in one of these cities and would like to hack on mgmt or just chat about the project. I'm happy to give some impromptu demos if you ask!

Thanks for reading!

Happy Hacking,

James

PS: We now have a <a href="https://twitter.com/mgmtconfig">community run twitter account</a>. Check us out!

