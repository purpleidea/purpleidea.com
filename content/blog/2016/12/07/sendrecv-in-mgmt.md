+++
date = "2016-12-07 07:00:20"
title = "Send/Recv in mgmt"
draft = "false"
categories = ["technical"]
tags = ["devops", "fedora", "mgmt", "mgmtconfig", "notifications", "notify", "password", "planetdevops", "planetfedora", "planetpuppet", "puppet", "refresh", "send/recv"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/12/07/sendrecv-in-mgmt/"
+++

I previously published "<a href="/blog/2016/11/30/a-revisionist-history-of-configuration-management/">A revisionist history of configuration management</a>". I meant for that to be the intro to this article, but it ended up being long enough that it deserved a separate post. I <em>will</em> explain Send/Recv in this article, but first a few clarifications to the aforementioned article.

<span style="text-decoration:underline;">Clarifications</span>

I mentioned that my "revisionist history" was inaccurate, but I failed to mention that it was also not exhaustive! Many things were left out either because they were proprietary, niche, not well-known, of obscure design or simply for brevity. My apologies if you were involved with Bcfg2, Bosh, Heat, Military specifications, SaltStack, SmartFrog, or something else entirely. I'd love it if someone else wrote an "exhaustive history", but I don't think that's possible.

It's also worth re-iterating that without the large variety of software and designs which came before me, I wouldn't have learned or have been able to build anything of value. <a href="https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants">Thank you giants!</a>  By discussing the problems and designs of other tools, then it makes it easier to contrast with and explaining what I'm doing in <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">mgmt</a>.

<span style="text-decoration:underline;">Notifications</span>

If you're not familiar with the <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">directed acyclic graph model for configuration management, you should start by reviewing that material first</a>. It models a system of resources (workers) as the vertices in that DAG, and the edges as the dependencies. We're going to add some additional mechanics to this model.

There is a concept in mgmt called notifications. Any time the state of a resource is successfully changed by the engine, a notification is emitted. These notifications are emitted along any graph edge (dependency) that has been asked to relay them. Edges with the <code>Notify</code> property will do so. These are usually called <code>refresh</code> notifications.

Any time a resource receives a refresh notification, it can apply a special action which is resource specific. The <code>svc</code> resource reloads the service, the <code>password</code> resource generates a new password, the <code>timer</code> resource resets the timer, and the <code>noop</code> resource prints a notification message. In general, refresh notifications should be avoided if possible, but there are a number of legitimate use cases.

In mgmt notifications are designed to be crash-proof, that is to say, undelivered notifications are re-queued when the engine restarts. While we don't expect mgmt to crash, this is also useful when a graph is stopped by the user before it has completed.

You'll see these notifications in action momentarily.

<span style="text-decoration:underline;">Send/Recv</span>

I mentioned in the <a href="/blog/2016/11/30/a-revisionist-history-of-configuration-management/">revisionist history</a> that I felt that Chef opted for <em>raw code</em> as a solution to the lack of power in Puppet. Having resources in mgmt which are <a href="/blog/2016/01/18/next-generation-configuration-mgmt/">event-driven</a> is one example of increasing their power. Send/Recv is another mechanism to make the resource primitive more powerful.

Simply put: Send/Recv is a mechanism where resources can transfer data along graph edges.

<span style="text-decoration:underline;">The status quo</span>

Consider the following pattern (expressed as Puppet code):

```
# create a directory
file { '/var/foo/':
    ensure => directory,
}
# download a file into that directory
exec { 'wget http://example.com/data -O - > /var/foo/data':
    creates => '/var/foo/data',
    require => File['/var/foo/'],
}
# set some property of the file
file { '/var/foo/data':
    mode => 0644,
    require => File['/var/foo/data'],
}
```
First a disclaimer. Puppet now actually supports an <a href="https://docs.puppet.com/puppet/latest/type.html#file-attribute-source">http url as a source</a>. Nevertheless, this was a common pattern for many years and that solution only improves a narrow use case. Here are some of the past and current problems:

<ul>
    <li>File can't take output from an exec (or other) resource</li>
    <li>File can't pull from an unsupported protocol (sftp, tftp, imap, etc...)</li>
    <li>File can get created with zero-length data</li>
    <li>Exec won't update if http endpoint changes the data</li>
    <li>Requires knowledge of bash and shell glue</li>
    <li>Potentially error-prone if a typo is made</li>
</ul>

There's also a layering violation if you believe that network code (http downloading) shouldn't be in a file resource. I think it adds unnecessary complexity to the file resource.

<span style="text-decoration:underline;">The solution</span>

What the file resource actually needs, is to be able to accept (<em>Recv</em>) data of the same type as any of its input arguments. We also need resources which can produce (<em>Send</em>) data that is useful to consumers. This occurs along a graph (dependency) edge, since the sending resource would need to produce it before the receiver could act!

This also opens up a range of possibilities for new resource kinds that are clever about sending or receiving data. an <em>http</em> resource could contain all the necessary network code, and replace our use of the <code>exec { 'wget ...': }</code> pattern.

<span style="text-decoration:underline;">Diagram</span>

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="linkage.png"><img class="size-full wp-image-1964" src="linkage.png" alt="in this graph, a password resource generates a random string and stores it in a file" width="100%" height="100%" /></a></td></tr><tr><td> in this graph, a password resource generates a random string and stores it in a file; more clever linkages are planned</td></tr></table></br />

<span style="text-decoration:underline;">Example</span>

As a proof of concept for the idea, I implemented a <code>Password</code> resource. This is a prototype resource that generates a random string of characters. To use the output, it has to be linked via Send/Recv to something that can accept a string. The file resource is one such possibility. Here's an excerpt of some example output <a href="https://github.com/purpleidea/mgmt/blob/597ed6eaa0b5b3a3da8681b79ab5b0d39d9ed450/examples/lib/libmgmt3.go#L53">from a simple graph</a>:

```
03:06:13 password.go:295: Password[password1]: Generating new password...
03:06:13 password.go:312: Password[password1]: Writing password token...
03:06:13 sendrecv.go:184: SendRecv: Password[password1].Password -> File[file1].Content
03:06:13 file.go:651: contentCheckApply: Invalidating sha256sum of `Content`
03:06:13 file.go:579: File[file1]: contentCheckApply(true)
03:06:13 noop.go:115: Noop[noop1]: Received a notification!
```
What you can see is that initially, a random password is generated. Next Send/Recv transfers the generated <code>Password</code> to the file's <code>Content</code>. The <code>file</code> resource invalidates the cached <code>Content</code> checksum (a performance feature of the file resource), and then stores that value in the file. (This would normally be a security problem, but this is for example purposes!) Lastly, the file sends out a refresh notification to a <code>Noop</code> resource for demonstration purposes. It responds by printing a log message to that effect.

<span style="text-decoration:underline;">Libmgmt</span>

Ultimately, mgmt will have a <a href="https://en.wikipedia.org/wiki/Domain-specific_language">DSL</a> to express the different graphs of configuration. In the meantime, you can use <a href="https://github.com/ffrank/puppet-mgmtgraph">Puppet code</a>, or a raw <a href="https://github.com/purpleidea/mgmt/tree/master/examples">YAML file</a>. The latter is primarily meant for testing purposes until we have the language built.

Lastly, you can also embed mgmt and use it like a library! This lets you write raw golang code to build your resource graphs. I decided to write the above example that way! <a href="https://github.com/purpleidea/mgmt/blob/597ed6eaa0b5b3a3da8681b79ab5b0d39d9ed450/examples/lib/libmgmt3.go">Have a look at the code! </a>This can be used to embed mgmt into your existing software! <a href="https://github.com/purpleidea/mgmt/tree/master/examples/lib">There are a few more examples available here.</a>

<span style="text-decoration:underline;">Resource internals</span>

When a resource receives new values via Send/Recv, it's likely that the resource will have work to do. As a result, the engine will automatically mark the resource state as <code>dirty</code> and then poke it from the sending node. When the receiver resource runs, it can lookup the list of keys that have been sent. This is useful if it wants to perform a cache invalidation for example. In the resource, the code is quite simple:

```
<span class="pl-k">if</span> <span class="pl-smi">val</span>, <span class="pl-smi">exists</span> <span class="pl-k">:=</span> obj.<span class="pl-smi">Recv</span>[<span class="pl-s"><span class="pl-pds">"</span>Content<span class="pl-pds">"</span></span>]; exists && val.<span class="pl-smi">Changed</span> {
    // the "Content" input has changed
}
```
<a href="https://github.com/purpleidea/mgmt/blob/597ed6eaa0b5b3a3da8681b79ab5b0d39d9ed450/resources/file.go#L643">Here is a good example of that mechanism in action.</a>

<span style="text-decoration:underline;">Future work</span>

This is only powerful if there are interesting resources to link together. Please contribute some ideas, and help build these resources! I've got a number of ideas already, but I'd love to hear yours first so that I don't influence or stifle your creativity. Leave me a message in the comments below!

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
