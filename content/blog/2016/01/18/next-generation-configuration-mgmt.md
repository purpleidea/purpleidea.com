+++
date = "2016-01-18 00:52:10"
title = "Next generation configuration mgmt"
draft = "false"
categories = ["technical"]
tags = ["ansible", "bash", "chef", "config management", "dag", "dbus", "devops", "distributed", "etcd", "events", "fedora", "gluster", "golang", "graph", "graphviz", "idempotent", "inotify", "linux", "mgmt", "mgmtconfig", "monitoring", "ng", "orchestrator", "packagekit", "parallel", "paxos", "planetdevops", "planetfedora", "planetipa", "planetpuppet", "prototype", "puppet", "raft", "systemd", "toposort"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/01/18/next-generation-configuration-mgmt/"
+++

It's no secret to the readers of this blog that I've been active in the configuration management space for some time. I owe most of my knowledge to what I've learned while working with <a href="https://en.wikipedia.org/wiki/Puppet_%28software%29">Puppet</a> and from other hackers working in and around various other communities.

<a href="/blog/2013/11/17/iteration-in-puppet">I've published</a>, <a href="/blog/2013/02/20/automatic-hiera-lookups-in-puppet-3-x">a number</a>, <a href="/blog/2012/11/07/preventing-duplicate-parameter-values-in-puppet-types">of articles</a>, <a href="/blog/2013/05/14/overriding-attributes-of-collected-exported-resources">in an</a>, <a href="/blog/2012/08/23/how-to-avoid-cluster-race-conditions-or-how-to-implement-a-distributed-lock-manager-in-puppet">attempt</a>, <a href="/blog/2014/07/24/hybrid-management-of-freeipa-types-with-puppet">to push</a>, <a href="/blog/2014/06/06/securely-managing-secrets-for-freeipa-with-puppet">the field</a>, <a href="/blog/2014/06/04/hiera-data-in-modules-and-os-independent-puppet">forwards</a>, <a href="/blog/2014/03/24/introducing-puppet-execagain">and to</a>, <a href="/blog/2012/11/14/setting-timed-events-in-puppet">share the</a>, <a href="/blog/2013/06/04/collecting-duplicate-resources-in-puppet">knowledge</a>, <a href="/blog/2013/09/28/finite-state-machines-in-puppet">that I've</a>, <a href="/blog/2012/11/20/recursion-in-puppet-for-no-particular-reason">learned</a>, <a href="/blog/2013/11/27/advanced-recursion-and-memoization-in-puppet">with others</a>. I've spent many nights thinking about these problems, but it is not without some chagrin that I realized that the current state-of-the-art in configuration management cannot easily (or elegantly) solve all the problems for which I wish to write solutions.

To that end, I'd like to formally present my idea (and code) for a next generation configuration management prototype. I'm calling my tool <em>mgmt</em>.

<strong><span style="text-decoration:underline;">Design triad</span></strong>

<em>Mgmt</em> has three unique design elements which differentiate it from other tools. I'll try to cover these three points, and explain why they're important. The summary:
<ol>
	<li><strong>Parallel execution</strong>, to run all the resources concurrently (where possible)</li>
	<li><strong>Event driven</strong>, to monitor and react dynamically only to changes (when needed)</li>
	<li><strong>Distributed topology</strong>, so that scale and centralization problems are replaced with a robust distributed system</li>
</ol>
The <a href="https://github.com/purpleidea/mgmt/">code</a> is available, but you may prefer to read on as I dive deeper into each of these elements first.

<strong>1) <span style="text-decoration:underline;">Parallel execution</span></strong>

Fundamentally, all configuration management systems represent the dependency relationships between their resources in a <a href="https://en.wikipedia.org/wiki/Graph_%28abstract_data_type%29">graph</a>, typically one that is <a href="https://en.wikipedia.org/wiki/Directed_acyclic_graph">directed and acyclic</a>.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph1.png" rel="attachment wp-att-1322"><img class="size-full wp-image-1322" src="graph1.png" alt="directed acyclic graph g1, showing the dependency relationships with black arrows, and the linearized dependency sort order with red arrows." width="100%" height="100%" /></a></td></tr><tr><td> Directed acyclic graph g1, showing the dependency relationships with black arrows, and the linearized dependency sort order (a topological sort) with red arrows.</td></tr></table></br />

Unfortunately, the execution of this graph typically has a single worker that runs through a linearized, <a href="https://en.wikipedia.org/wiki/Topological_sorting">topologically sorted</a> version of it. There is no reason that a graph with a number of <a href="https://en.wikipedia.org/wiki/Connectivity_%28graph_theory%29">disconnected parts</a> cannot run each separate section in parallel with each other.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph2.png" rel="attachment wp-att-1323"><img class="size-full wp-image-1323" src="graph2.png" alt="g2" width="100%" height="100%" /></a></td></tr><tr><td> Graph g2 with the red arrows again showing the execution order of the graph. Please note that this graph is composed of two disconnected parts: one diamond on the left and one triplet on the right, both of which can run in parallel. Additionally, nodes 2a and 2b can run in parallel only after 1a has run, and node 3a requires the entire left diamond to have succeeded before it can execute.</td></tr></table></br />

Typically, some nodes will have a common dependency, which once met will allow its children to all execute simultaneously.

This is the first major design improvement that the <em>mgmt</em> tool implements. It has obvious improvements for performance, in that a long running process in one part of the graph (eg: a package installation) will cause no delay on a separate disconnected part of the graph which is in the process of converging unrelated code. It also has other benefits which we will discuss below.

In practice this is particularly powerful since most servers under configuration management typically combine different modules, many of which have no inter-dependencies.

An example is the best way to show off this feature. Here we have a set of four long (10 second) running processes or <em>exec</em> resources. Three of them form a linear dependency chain, while the fourth has no dependencies or prerequisites. I've asked the system to exit after it has been converged for five seconds. As you can see in the example, it is finished five seconds after the limiting resource should be completed, which is the longest running delay to complete in the whole process. That limiting chain took 30 seconds, which we can see in the log as being from three 10 second executions. The logical total of about 35 seconds as expected is shown at the end:
```
$ time ./mgmt run --file graph8.yaml --converged-timeout=5 --graphviz=example1.dot
22:55:04 This is: mgmt, version: 0.0.1-29-gebc1c60
22:55:04 Main: Start: 1452398104100455639
22:55:04 Main: Running...
22:55:04 Graph: Vertices(4), Edges(2)
22:55:04 Graphviz: Successfully generated graph!
22:55:04 State: graphStarting
22:55:04 State: graphStarted
22:55:04 Exec[exec4]: Apply //exec4 start
22:55:04 Exec[exec1]: Apply //exec1 start
22:55:14 Exec[exec4]: Command output is empty! //exec4 end
22:55:14 Exec[exec1]: Command output is empty! //exec1 end
22:55:14 Exec[exec2]: Apply //exec2 start
22:55:24 Exec[exec2]: Command output is empty! //exec2 end
22:55:24 Exec[exec3]: Apply //exec3 start
22:55:34 Exec[exec3]: Command output is empty! //exec3 end
22:55:39 Converged for 5 seconds, exiting! //converged for 5s
22:55:39 Interrupted by exit signal
22:55:39 Exec[exec4]: Exited
22:55:39 Exec[exec1]: Exited
22:55:39 Exec[exec2]: Exited
22:55:39 Exec[exec3]: Exited
22:55:39 Goodbye!

real    0m35.009s
user    0m0.008s
sys     0m0.008s
$
```
Note that I've edited the example slightly to remove some unnecessary log entries for readability sake, and I have also added some comments and emphasis, but aside from that, this is actual output! The tool also generated <a href="https://en.wikipedia.org/wiki/Graphviz">graphviz</a> output which may help you better understand the problem:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="example1-dot.png" rel="attachment wp-att-1338"><img class="aligncenter size-full wp-image-1338" src="example1-dot.png" alt="example1.dot" width="100%" height="100%" /></a></td></tr><tr><td> This example is obviously contrived, but is designed to illustrate the capability of the <em>mgmt</em> tool.</td></tr></table></br />

Hopefully you'll be able to come up with more practical examples.

<strong>2) <span style="text-decoration:underline;">Event driven</span></strong>

All configuration management systems have some notion of <a href="https://en.wikipedia.org/wiki/Idempotence">idempotence</a>. Put simply, an idempotent operation is one which can be applied multiple times without causing the result to <a href="https://en.wikipedia.org/wiki/Convergence_(mathematics)">diverge</a> from the desired state. In practice, each individual resource will typically check the state of the element, and if different than what was requested, it will then apply the necessary transformation so that the element is brought to the desired state.

The current generation of configuration management tools, typically checks the state of <em>each</em> element once every 30 minutes. Some do it more or less often, and some do it only when manually requested. In all cases, this can be an expensive operation due to the size of the graph, and the cost of each <em>check</em> operation. This problem is compounded by the fact that the graph doesn't run in parallel.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph3.png" rel="attachment wp-att-1325"><img class="size-full wp-image-1325" src="graph3.png" alt="g3" width="100%" height="100%" /></a></td></tr><tr><td> In this time / state sequence diagram g3, time progresses from left to right. Each of the three elements (from top to bottom) want to converge on states a, b and c respectively. Initially the first two are in states x and y, where as the third is already converged. At t1 the system runs and converges the graph, which entails a state change of the first and second elements. At some time t2, the elements are changed by some external force, and the system is no longer converged. We won't notice till later! At this time t3 when we run for the second time, we notice that the second and third elements are no longer converged and we apply the necessary operations to fix this. An unknown amount of time passed where our cluster was in a diverged or unhealthy state. Traditionally this is on the order of 30 minutes.</td></tr></table></br />

More importantly, if something diverges from the requested state you might wait 30 minutes before it is noticed and repaired by the system!

The <em>mgmt</em> system is unique, because I realized that an event based system could fulfill the same desired behaviour, and in fact it offers a more general and powerful solution. This is the second major design improvement that the <em>mgmt</em> tool implements.

These events that we're talking about are <a href="https://en.wikipedia.org/wiki/Inotify">inotify</a> events for file changes, <a href="https://en.wikipedia.org/wiki/Systemd">systemd</a> events (from <a href="https://en.wikipedia.org/wiki/D-Bus">dbus</a>) for service changes, <a href="https://en.wikipedia.org/wiki/PackageKit">packagekit</a> events (from dbus again) for package change events, and events from <a href="https://github.com/purpleidea/mgmt/blob/master/exec.go#L18">exec</a> calls, timers, network operations and more! In the inotify example, on first run of the <em>mgmt</em> system, an inotify watch is taken on the file we want to manage, the state is checked and it is converged if need be. We don't ever need to check the state again unless inotify tells us that something happened!

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph4.png" rel="attachment wp-att-1327"><img class="size-full wp-image-1327" src="graph4.png" alt="g4" width="100%" height="100%" /></a></td></tr><tr><td> In this time / state sequence diagram g4, time progresses from left to right. After the initial run, since all the elements are being continuously monitored, the instant something changes, <em>mgmt</em> reacts and fixes it almost instantly.</td></tr></table></br />

Astute config mgmt hackers might end up realizing three interesting consequences:
<ol>
	<li>If we don't want the <em>mgmt</em> program to continuously monitor events, it can be told to exit after the graph converges, and run again 30 minutes later. This can be done with my system by running it from cron with the <a href="https://github.com/purpleidea/mgmt/blob/master/DOCUMENTATION.md#--converged-timeout-seconds"><code>--converged-timeout=1</code></a>, flag. This effectively offers the same behaviour that current generation systems do for the administrators who do not want to experiment with a newer model. Thus, the current systems are a special, simplified model of <em>mgmt</em>!</li>
	<li>It is possible that some resources don't offer an event watching mechanism. In those instances, a fallback to polling is possible for that specific resource. Although there currently aren't any missing event APIs that your narrator knows about at this time.</li>
	<li>A monitoring system (read: nagios and friends) could probably be built with this architecture, thus demonstrating that my world view of configuration management is actually a generalized version of system monitoring! They're the same discipline!</li>
</ol>
Here is a small real-world example to demonstrate this feature. I have started the agent, and I have told it to create three files (f1, f2, f3) with the contents seen below, and also, to ensure that file f4 is not present. As you can see the <em>mgmt</em> system responds quite quickly:
```
james@computer:/tmp/mgmt$ ls
f1  f2  f3
james@computer:/tmp/mgmt$ cat *
i am f1
i am f2
i am f3
james@computer:/tmp/mgmt$ rm -f f2 && cat f2
i am f2
james@computer:/tmp/mgmt$ echo blah blah > f2 && cat f2
i am f2
james@computer:/tmp/mgmt$ touch f4 && file f4
f4: cannot open `f4' (No such file or directory)
james@computer:/tmp/mgmt$ ls
f1  f2  f3
james@computer:/tmp/mgmt$
```
That's fast!

<strong>3) <span style="text-decoration:underline;">Distributed topology</span></strong>

All software typically runs with some sort of topology. Puppet and <a href="https://en.wikipedia.org/wiki/Chef_%28software%29">Chef</a> normally run in a <a href="https://en.wikipedia.org/wiki/Client%E2%80%93server_model">client server topology</a>, where you typically have one server with many clients, each running an agent. They also both offer a standalone mode, but in general this is not more interesting than running a fancy bash script. In this context, I define interesting as "relating to clustered, multiple machine architectures".

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph5.png" rel="attachment wp-att-1329"><img class="size-full wp-image-1329" src="graph5.png" alt="g5" width="100%" height="100%" /></a></td></tr><tr><td> Here in graph g5 you can see one server which has three clients initiating requests to it.</td></tr></table></br />

This traditional model of computing is well-known, and fairly easy to reason about. You typically put all of your code in one place (on the server) and the clients or agents need very little personalized configuration to get working. However, it can suffer from performance and scalability issues, and it can also be a single point of failure for your infrastructure. Make no mistake: if you manage your infrastructure properly, then when your configuration management infrastructure is down, you will be unable to bring up new machines or modify existing ones! This can be a disastrous type of failure, and is one which is seldom planned for in disaster recovery scenarios!

Other systems such as <a href="https://en.wikipedia.org/wiki/Ansible_%28software%29">Ansible</a> are actually <a href="https://en.wikipedia.org/wiki/Orchestration_%28computing%29">orchestrators</a>, and are not technically configuration management in my opinion. That doesn't mean they don't share much of the same problem space, and in fact they are usually idempotent and share many of the same properties of traditional configuration management systems. They are useful and important tools!

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph6.png" rel="attachment wp-att-1330"><img class="aligncenter size-full wp-image-1330" src="graph6.png" alt="graph6" width="100%" height="100%" /></a></td></tr></table></br />

The key difference about an orchestrator, is that it typically operates with a push model, where the server (or the sysadmin laptop) initiates a connection to the machines that it wants to manage. One advantage is that this is sometimes very easy to reason about for multi machine architectures, however it shares the usual downsides around having a single point of failure. Additionally there are some very real performance considerations when running large clusters of machines. In practice these clusters are typically segmented or divided in some logical manner so as to lessen the impact of this, which unfortunately detracts from the aforementioned simplicity of the solution.

Unfortunately with either of these two topologies, we can't immediately detect when an issue has occurred and respond immediately without sufficiently advanced third party <a href="https://en.wikipedia.org/wiki/System_monitoring">monitoring</a>. By itself, a machine that is being managed by orchestration, cannot detect an issue and communicate back to its operator, or tell the cluster of servers it peers with to react accordingly.

The good news about current and future generation topologies is that algorithms such as the <a href="https://en.wikipedia.org/wiki/Paxos_%28computer_science%29">Paxos family</a> and <a href="https://en.wikipedia.org/wiki/Raft_%28computer_science%29">Raft</a> are now gaining wider acceptance and good implementations now exist as Free Software. <em>Mgmt</em> depends on these algorithms to create a mesh of agents. There are no clients and servers, only peers! Each peer can choose to both <em>export</em> and <em>collect</em> data from a distributed data store which lives as part of the cluster of peers. The software that currently implements this data store is a marvellous piece of engineering called <a href="https://en.wikipedia.org/wiki/Etcd">etcd</a>.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph7.png" rel="attachment wp-att-1331"><img class="wp-image-1331 size-full" src="graph7.png" alt="graph7" width="100%" height="100%" /></a></td></tr><tr><td> In graph g7, you can see what a fully interconnected graph topology might look like. It should be clear that the numbed of connections (or edges) is quite large. Try and work out the number of edges required for a fully connected graph with 128 nodes. Hint, it's large!</td></tr></table></br />

In practice the number of connections required for each peer to connect to each other peer would be too great, so instead the cluster first achieves <a href="https://en.wikipedia.org/wiki/Consensus_%28computer_science%29">distributed consensus</a>, and then the elected leader picks a certain number of machines to run etcd masters. All other agents then connect through one of these masters. The distributed data store can easily handle failures, and agents can reconnect seamlessly to a different temporary master should they need to. If there is a lack or an abundance of transient masters, then the cluster promotes or demotes an agent automatically by asking it to start or stop an etcd process on its host.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="graph8.png" rel="attachment wp-att-1332"><img class="size-full wp-image-1332" src="graph8.png" alt="g8" width="100%" height="100%" /></a></td></tr><tr><td> In graph g8, you can see a tightly interconnected centre of nodes running both their configuration management tasks, but also etcd masters. Each additional peer picks any of them to connect to. As the number of nodes scale, it is far easier to scale such a cluster. Future algorithm designs and optimizations should help this system scale to unprecedented host counts. It should go without saying that it would be wise to ensure that the nodes running etcd masters are in different failure domains.</td></tr></table></br />

By allowing hosts to export and collect data from the distributed store, we actually end up with a mechanism that is quite similar to what Puppet calls <a href="https://docs.puppetlabs.com/puppet/latest/reference/lang_exported.html">exported resources</a>. In my opinion, the mechanism and data interchange is actually a brilliant idea, but with some obvious shortcomings in its implementation. This is because for a cluster of N nodes, each wishing to exchange data with one another, puppet must run N times (once on each node) and then N-1 times for the entire cluster to see all of the exchanged data. Each of these runs requires an entire sequential run through every resource, and an expensive check of each resource, each time.

In contrast, with <em>mgmt</em>, the graph is redrawn only when an etcd event notifies us of a change in the data store, and when the new graph is applied, only members who are affected either by a change in definition or dependency need to be re-run. In practice this means that a small cluster where the resources themselves have a negligible apply time, can converge a complete connected exchange of data in less than one second.

An example demonstrates this best.
<ul>
	<li>I have three nodes in the system: A, B, C.</li>
	<li>Each creates four files, two of which it will export.</li>
	<li>On host A, the two files are: /tmp/mgmt<strong>A</strong>/f1<strong>a</strong> and /tmp/mgmt<strong>A</strong>/f2<strong>a</strong>.</li>
	<li>On host A, it exports: /tmp/mgmt<strong>A</strong>/f3<strong>a</strong> and /tmp/mgmt<strong>A</strong>/f4<strong>a</strong>.</li>
	<li>On host A, it collects all available (exported) files into: /tmp/mgmt<strong>A</strong>/</li>
	<li>It is done similarly with B and C, except with the letters B and C substituted in to the <strong>emphasized</strong> locations above.</li>
	<li>For demonstration purposes, I startup the <em>mgmt</em> engine first on A, then B, and finally C, all the while running various terminal commands to keep you up-to-date.</li>
</ul>
As before, I've trimmed the logs and annotated the output for clarity:
```
james@computer:/tmp$ rm -rf /tmp/mgmt* # clean out everything
james@computer:/tmp$ mkdir /tmp/mgmt{A..C} # make the example dirs
james@computer:/tmp$ tree /tmp/mgmt* # they're indeed empty
/tmp/mgmtA
/tmp/mgmtB
/tmp/mgmtC

0 directories, 0 files
james@computer:/tmp$ # run node A, it converges almost instantly
james@computer:/tmp$ tree /tmp/mgmt*
/tmp/mgmtA
├── f1a
├── f2a
├── f3a
└── f4a
/tmp/mgmtB
/tmp/mgmtC

0 directories, 4 files
james@computer:/tmp$ # run node B, it converges almost instantly
james@computer:/tmp$ tree /tmp/mgmt*
/tmp/mgmtA
├── f1a
├── f2a
├── f3a
├── f3b
├── f4a
└── f4b
/tmp/mgmtB
├── f1b
├── f2b
├── f3a
├── f3b
├── f4a
└── f4b
/tmp/mgmtC

0 directories, 12 files
james@computer:/tmp$ # run node C, exit 5 sec after converged, output:
james@computer:/tmp$ time ./mgmt run --file examples/graph3c.yaml --hostname c --converged-timeout=5
01:52:33 main.go:65: This is: mgmt, version: 0.0.1-29-gebc1c60
01:52:33 main.go:66: Main: Start: 1452408753004161269
01:52:33 main.go:203: Main: Running...
01:52:33 main.go:103: Etcd: Starting...
01:52:33 config.go:175: Collect: file; Pattern: /tmp/mgmtC/
01:52:33 main.go:148: Graph: Vertices(8), Edges(0)
01:52:38 main.go:192: Converged for 5 seconds, exiting!
01:52:38 main.go:56: Interrupted by exit signal
01:52:38 main.go:219: Goodbye!

real    0m5.084s
user    0m0.034s
sys    0m0.031s
james@computer:/tmp$ tree /tmp/mgmt*
/tmp/mgmtA
├── f1a
├── f2a
├── f3a
├── f3b
├── f3c
├── f4a
├── f4b
└── f4c
/tmp/mgmtB
├── f1b
├── f2b
├── f3a
├── f3b
├── f3c
├── f4a
├── f4b
└── f4c
/tmp/mgmtC
├── f1c
├── f2c
├── f3a
├── f3b
├── f3c
├── f4a
├── f4b
└── f4c

0 directories, 24 files
james@computer:/tmp$
```
Amazingly, the cluster converges in <em>less</em> than one second. Admittedly it didn't have large amounts of <a href="https://en.wikipedia.org/wiki/Input/output">IO</a> to do, but since those are fixed constants, it still shows how fast this approach should be. Feel free to do your own tests to verify.

<strong><span style="text-decoration:underline;">Code</span></strong>

<a href="https://github.com/purpleidea/mgmt/">The code is publicly available and has been for some time.</a> I wanted to release it early, but I didn't want to blog about it until I felt I had the initial design triad completed. It is written entirely in <a href="https://en.wikipedia.org/wiki/Golang">golang</a>, which I felt was a good match for the design requirements that I had. It is my first major public golang project, so I'm certain there are many things I could be doing better. As a result, I welcome your criticism and patches, just please try and keep them constructive and respectful! The project is entirely <a href="https://www.gnu.org/philosophy/free-sw.html">Free Software</a>, and I plan to keep it that way. <a href="https://www.redhat.com/en/about/blog/open-source-or-open-core-why-should-you-care">As long as Red Hat is involved, I'm pretty sure you won't have to deal with any open core compromises!</a>

<strong><span style="text-decoration:underline;">Community</span></strong>

There's an IRC channel going. It's <a href="https://web.libera.chat/?channels=#mgmtconfig">#mgmtconfig on Libera.chat</a>. Please come hangout! If we get bigger, we'll add a mailing list.

<strong><span style="text-decoration:underline;">Caveats</span></strong>

There are a few caveats that I'd like to mention. Please try to keep these in mind.
<ul>
	<li>This is still an early prototype, and as a result isn't ready for production use, or as a replacement for existing config management software. If you like the design, please contribute so that together we can turn this into a mature system faster.</li>
	<li>There are some portions of the code which are notably absent. In particular, there is no lexer or parser, nor is there a design for what the graph building language (DSL) would look like. This is because I am not a specialist in these areas, and as a result, while I have some ideas for the design, I don't have any useful code yet. For testing the engine, there is a (quickly designed) YAML <a href="https://github.com/purpleidea/mgmt/tree/master/examples">graph definition</a> parser available in the code today.</li>
	<li>The etcd master election/promotion portion of the code is not yet available. Please stay tuned!</li>
	<li>There is no design document, roadmap or useful documentation currently available. I'll be working to remedy this, but I first wanted to announce the project, gauge interest and get some intial feedback. Hopefully others can contribute to the docs, and I'll try to write about my future design ideas as soon as possible.</li>
	<li>The name <em>mgmt</em> was the best that I could come up with. If you can propose a better alternative, I'm open to the possibility.</li>
	<li>I work for <a href="https://redhat.com/">Red Hat</a>, and at first it might seem confusing to announce this work alongside our existing well-known <a href="https://access.redhat.com/products/red-hat-satellite">Puppet</a> and <a href="https://www.redhat.com/en/about/press-releases/red-hat-acquire-it-automation-and-devops-leader-ansible">Ansible</a> teams. To clarify, this is a prototype of some work and designs that I started before I was employed at Red Hat. I'm grateful that they've been letting me work on interesting projects, and I'm very pleased that my managers have had the vision to invest in future technologies and projects that (I hope) might one day become the de facto standard.</li>
</ul>
<strong><span style="text-decoration:underline;">Presentations</span></strong>

It is with great honour, that my first public talk about this project will be at <a href="http://cfgmgmtcamp.eu/">Config Management Camp 2016</a>. I am thrilled to be <a href="http://cfgmgmtcamp.eu/schedule/speakers/JamesShubin.html">speaking</a> at such an excellent conference, where I am sure the subject matter will be a great fit for all the respected domain experts who will be present. <a href="http://cfgmgmtcamp.eu/schedule/speakers/JamesShubin.html">Find me on the schedule, and please come to my session.</a>

I'm also fortunate enough to be <a href="https://devconfcz2016.sched.org/event/5m14/next-generation-config-mgmt">speaking about the same topic, just four days later</a> in <a href="https://en.wikipedia.org/wiki/Brno">Brno</a>, at <a href="http://devconf.cz/">DevConf.CZ</a>. It's a free conference, in an excellent city, and you'll be sure to find many excellent technical sessions and hackers!

I hope to see you at one of these events or at a future conference. If you'd like to have me speak at your conference or event, please <a href="/contact/">contact me</a>!

<strong><span style="text-decoration:underline;">Conclusion</span></strong>

Thank you for reading this far! I hope you appreciate my work, and I promise to tell you more about some of the novel designs and properties that I have planned for the future of <em>mgmt</em>. Please leave me your comments, even if they're just +1's.

Happy hacking!

<a href="https://twitter.com/#!/purpleidea">James</a>

<br />

<strong><span style="text-decoration:underline;">Post scriptum</span></strong>

There seems to be a new trend about calling certain types of management systems or designs "choreography". Since this term is sufficiently overloaded and without a clear definition, I choose to avoid it, however it's worth mentioning that some of the ideas from some of the definitions of this word as pertaining to the configuration management field match what I'm trying to do with this design. Instead of using the term "choreography", I prefer to refer to what I'm doing as "configuration management".

Some early peer reviews suggested this might be a "puppet-killer". In fact, I actually see it as an opportunity to engage with the puppet community and to share my design and engine, which I hope some will see as a more novel solution. Existing puppet code could be fed through a cross compiler to output a graph that actually runs on my engine. While I plan to offer an easier to use and more powerful <a href="https://en.wikipedia.org/wiki/Domain-specific_language">DSL language</a>, <a href="https://en.wikipedia.org/wiki/Pareto_principle">the 80%</a> of existing puppet code isn't more than plumbing, package installation, and simple templating, so a gradual migration would be possible, where the multi-system configuration management parts are implemented using my new patterns instead of with slowly converging puppet. The same things could probably also be done with other languages like Chef. Anyone from Puppet Labs, Chef Software Inc., or the greater hacker community is welcome to contact me personally if they'd like to work on this.

Lastly, but most importantly, thanks to everyone who has discussed these ideas with me, reviewed this article, and contributed in so many ways. You're awesome!

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
