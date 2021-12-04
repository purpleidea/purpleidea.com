+++
date = "2016-10-07 15:33:17"
title = "Remote execution in mgmt"
draft = "false"
categories = ["technical"]
tags = ["agent-less", "devops", "fedora", "gluster", "golang", "kickstart", "mgmt", "mgmtconfig", "oh-my-vagrant", "orchestrator", "planetdevops", "planetfedora", "planetfreeipa", "planetipa", "planetpuppet", "puppet", "remote execution", "ssh", "tftp", "vagrant"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/10/07/remote-execution-in-mgmt/"
+++

Bootstrapping a cluster from your laptop, or managing machines without needing to first setup a separate config management infrastructure are both very reasonable and fundamental asks. I was particularly inspired by <a href="https://github.com/ansible/ansible">Ansible</a>'s agent-less remote execution model, but never wanted to build a centralized orchestrator. <a href="https://en.wikipedia.org/wiki/You_can%27t_have_your_cake_and_eat_it">I soon realized that I could have my ice cream and eat it too.</a>

<span style="text-decoration:underline;">Prior knowledge</span>

If you haven't read the earlier articles about mgmt, then I recommend you start with those, and then come back here. The first and fourth are essential if you're going to make sense of this article.

<ul>
    <li><a href="/blog/2016/01/18/next-generation-configuration-mgmt/">Next generation config mgmt</a></li>
    <li><a href="/blog/2016/03/14/automatic-edges-in-mgmt/">Automatic edges in mgmt</a></li>
    <li><a href="/blog/2016/03/30/automatic-grouping-in-mgmt/">Automatic grouping in mgmt</a></li>
    <li><a href="/blog/2016/06/20/automatic-clustering-in-mgmt/">Automatic clustering in mgmt</a></li>
</ul>

<span style="text-decoration:underline;">Limitations of existing orchestrators</span>

Current orchestrators have a few limitations.

<ol>
    <li>They can be a single point of failure</li>
    <li>They can have scaling issues</li>
    <li>They can't respond instantaneously to node state changes (they poll)</li>
    <li>They can't usually redistribute remote node run-time data between nodes</li>
</ol>

Despite these limitations, orchestration is still very useful because of the facilities it provides. Since these facilities are essential in a next generation design, I set about integrating these features, but with a novel twist.

<span style="text-decoration:underline;">Implementation, Usage and Design
</span>

Mgmt is written in golang, and that decision was no accident. One benefit is that it simplifies our remote execution model.

To use this mode you run <code>mgmt</code> with the <code>--remote</code> flag. Each use of the <code>--remote</code> argument points to a different remote graph to execute. Eventually this will be integrated with the DSL, but this plumbing is exposed for early adopters to play around with.

<span style="text-decoration:underline;">Startup</span> <em>(part one)</em><span style="text-decoration:underline;">
</span>

Each invocation of <code>--remote</code> causes mgmt to remotely connect over SSH to the target hosts. This happens in parallel, and runs up to <code>--cconns</code> simultaneous connections.

<code></code>A temporary directory is made on the remote host, and the <code>mgmt</code> binary and graph are copied across the wire. Since mgmt compiles down to a <a href="https://golang.org/doc/faq#Why_is_my_trivial_program_such_a_large_binary">single statically compiled binary</a>, it simplifies the transfer of the software. The binary is cached remotely to speed up future runs unless you pass the <code>--no-caching</code> option.

A TCP connection is tunnelled back over SSH to the originating hosts etcd server which is embedded and running inside of the initiating mgmt binary.

<span style="text-decoration:underline;">Execution</span> <em>(part two)</em><span style="text-decoration:underline;">
</span>

The remote mgmt binary is now run! It wires itself up through the SSH tunnel so that its internal etcd client can connect to the etcd server on the initiating host. This is particularly powerful because remote hosts can now participate in resource exchanges as if they were part of a regular etcd backed mgmt cluster! They don't connect directly to each other, but they can share runtime data, and only need an incoming SSH port open!

<span style="text-decoration:underline;">Closure</span> <em>(part three)</em><span style="text-decoration:underline;">
</span>

At this point mgmt can either keep running continuously or it can close the connections and shutdown.

In the former case, you can either remain attached over SSH, or you can disconnect from the child hosts and let this new cluster take on a new life and operate independently of the initiator.

In the latter case you can either shutdown at the operators request (via a <code>^C</code> on the initiator) or when the cluster has simultaneously converged for a number of seconds.

This second possibility occurs when you run mgmt with the familiar <code>--converged-timeout</code> parameter. It is indeed clever enough to also work in this distributed fashion.

<span style="text-decoration:underline;">Diagram</span>

I've used by poor libreoffice draw skills to make a diagram. Hopefully this helps out my visual readers.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="remote-execution.png"><img class="aligncenter size-full wp-image-1894" src="remote-execution.png" alt="remote-execution" width="100%" height="100%" /></a></td></tr></table></br />

If you can improve this diagram, please <a href="/contact/">let me know</a>!

<span style="text-decoration:underline;">Example</span>

I find that using one or more vagrant virtual machines for the remote endpoints is the best way to test this out. In my case I use <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant</a> to set up these machines, but the method you use is entirely up to you! Here's a sample remote execution. Please note that I have omitted a number of lines for brevity, and added emphasis to the more interesting ones.

```
james@hostname:~/code/mgmt$ ./mgmt run --remote examples/remote2a.yaml --remote examples/remote2b.yaml --tmp-prefix
17:58:22 main.go:76: This is: mgmt, version: 0.0.5-3-g4b8ad3a
17:58:23 remote.go:596: Remote: Connect...
17:58:23 remote.go:607: Remote: Sftp...
17:58:23 remote.go:164: Remote: Self executable is: /home/james/code/gopath/src/github.com/purpleidea/mgmt/mgmt
17:58:23 remote.go:221: Remote: Remotely created: /tmp/mgmt-412078160/remote
17:58:23 remote.go:226: Remote: Remote path is: /tmp/mgmt-412078160/remote/mgmt
17:58:23 remote.go:221: Remote: Remotely created: /tmp/mgmt-412078160/remote
17:58:23 remote.go:226: Remote: Remote path is: /tmp/mgmt-412078160/remote/mgmt
17:58:23 remote.go:235: Remote: Copying binary, please be patient...
17:58:23 remote.go:235: Remote: Copying binary, please be patient...
17:58:24 remote.go:256: Remote: Copying graph definition...
17:58:24 remote.go:618: Remote: Tunnelling...
17:58:24 remote.go:630: Remote: Exec...
17:58:24 remote.go:510: Remote: Running: /tmp/mgmt-412078160/remote/mgmt run --hostname '192.168.121.201' --no-server --seeds 'http://127.0.0.1:2379' --file '/tmp/mgmt-412078160/remote/remote2a.yaml' --depth 1
17:58:24 etcd.go:2088: Etcd: Watch: Path: /_mgmt/exported/
17:58:24 main.go:255: Main: Waiting...
17:58:24 remote.go:256: Remote: Copying graph definition...
17:58:24 remote.go:618: Remote: Tunnelling...
17:58:24 remote.go:630: Remote: Exec...
17:58:24 remote.go:510: Remote: Running: /tmp/mgmt-412078160/remote/mgmt run --hostname '192.168.121.202' --no-server --seeds 'http://127.0.0.1:2379' --file '/tmp/mgmt-412078160/remote/remote2b.yaml' --depth 1
17:58:24 etcd.go:2088: Etcd: Watch: Path: /_mgmt/exported/
17:58:24 main.go:291: Config: Parse failure
17:58:24 main.go:255: Main: Waiting...
^C17:58:48 main.go:62: Interrupted by ^C
17:58:48 main.go:397: Destroy...
17:58:48 remote.go:532: Remote: Output...
|    17:58:23 main.go:76: This is: mgmt, version: 0.0.5-3-g4b8ad3a
|    17:58:47 main.go:419: Goodbye!
17:58:48 remote.go:636: Remote: Done!
17:58:48 remote.go:532: Remote: Output...
|    17:58:24 main.go:76: This is: mgmt, version: 0.0.5-3-g4b8ad3a
|    17:58:48 main.go:419: Goodbye!
17:58:48 remote.go:636: Remote: Done!
17:58:48 main.go:419: Goodbye!
```
You should see that we kick off the remote executions, and how they are wired back through the tunnel. In this particular case we terminated the runs with a <code>^C</code>.

The example configurations I used are available <a href="https://github.com/purpleidea/mgmt/blob/master/examples/remote2a.yaml">here</a> and <a href="https://github.com/purpleidea/mgmt/blob/master/examples/remote2b.yaml">here</a>. If you had a terminal open on the first remote machine, after about a second you would have seen:

```
[root@omv1 ~]# ls -d /tmp/file*  /tmp/mgmt*
/tmp/file1a  /tmp/file2a  /tmp/file2b  /tmp/mgmt-412078160
[root@omv1 ~]# cat /tmp/file*
i am file1a
i am file2a, exported from host a
i am file2b, exported from host b
```
You can see the remote execution artifacts, and that there was clearly data exchange. You can repeat this example with <code>--converged-timeout=5</code> to automatically terminate after five seconds of cluster wide inactivity.

<span style="text-decoration:underline;">Live remote hacking</span>

Since mgmt is event based, and graph structure configurations manifest themselves as event streams, you can actually edit the input configuration on the initiating machine, and as soon as the file is saved, it will instantly remotely propagate and apply the graph differential.

For this particular example, since we export and collect resources through the tunnelled SSH connections, it means editing the exported file, will also cause both hosts to update that file on disk!

You'll see this occurring with this message in the logs:

```
18:00:44 remote.go:973: Remote: Copied over new graph definition: examples/remote2b.yaml</strong>
```
While you might not necessarily want to use this functionality on a production machine, it will definitely make your interactive hacking sessions more useful, in particular because you never need to re-run parts of the graph which have already converged!

<span style="text-decoration:underline;">Auth</span>

In case you're wondering, mgmt can look in your <code>~/.ssh/</code> for keys to use for the auth, or it can prompt you interactively. It can also read a plain text password from the connection string, but this isn't a recommended security practice.

<span style="text-decoration:underline;">Hierarchial remote execution</span>

Even though we recommend running mgmt in a normal clustered mode instead of over SSH, we didn't want to limit the number of hosts that can be configured using remote execution. For this reason it would be architecturally simple to add support for what we've decided to call "hierarchial remote execution".

In this mode, the primary initiator would first connect to one or more secondary nodes, which would then stage a second series of remote execution runs resulting in an order of depth equal to two or more. This fan out approach can be used to distribute the number of outgoing connections across more intermediate machines, or as a method to conserve remote execution bandwidth on the primary link into your datacenter, by having the secondary machine run most of the remote execution runs.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="remote-execution2.png"><img class="aligncenter size-full wp-image-1895" src="remote-execution2.png" alt="remote-execution2" width="100%" height="100%" /></a></td></tr></table></br />

This particular extension hasn't been built, although some of the plumbing has been laid. If you'd like to contribute this feature to the upstream project, please join us in <a href="https://web.libera.chat/?channels=#mgmtconfig">#mgmtconfig on Libera.chat</a> and let us (I'm @<a href="https://twitter.com/purpleidea">purpleidea</a>) know!

<span style="text-decoration:underline;">Docs</span>

There is some generated documentation for the mgmt <code>remote</code> package<a href="https://godoc.org/github.com/purpleidea/mgmt/remote"> available</a>. There is also the beginning of some additional documentation in the <a href="https://github.com/purpleidea/mgmt/blob/master/DOCUMENTATION.md#remote-agent-less-mode">markdown docs</a>. You can help contribute to either of these by sending us a patch!

<span style="text-decoration:underline;">Novel resources</span>

Our event based architecture can enable some previously improbable kinds of resources. In particular, I think it would be quite beautiful if someone built a <em>provisioning</em> resource. The <code>Watch</code> method of the resource API normally serves to notify us of events, but since it is a main loop that blocks in a select call, it could also be used to run a small server that hosts a kickstart file and associated TFTP images. If you like this idea, please help us build it!

<span style="text-decoration:underline;">Conclusion</span>

I hope you enjoyed this article and found this remote execution methodology as novel as we do. In particular I hope that I've demonstrated that configuration software doesn't have to be constrained behind a static orchestration topology.

Happy Hacking,

James

