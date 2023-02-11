+++
date = "2017-03-01 16:11:59"
title = "Metaparameters in mgmt"
draft = "false"
categories = ["technical"]
tags = ["P/V", "autoedge", "autoedges", "autogrouping", "burst", "counting semaphore", "dag", "delay", "devops", "directed acyclic graph", "fedora", "gluster", "limit", "metaparameters", "mgmt", "mgmtconfig", "noop", "planetfedora", "planetpuppet", "poll", "proofs", "puppet", "retry", "semaphore", "token bucket"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2017/03/01/metaparameters-in-mgmt/"
+++

In <a href="https://github.com/purpleidea/mgmt/">mgmt</a> we have <em>meta parameters</em>. They are similar in concept to what you might be familiar with from other tools, except that they are more clearly defined (in a single struct) and vastly more powerful.

In mgmt, a meta parameter is a parameter which is codified entirely in the engine, and which can be used by any resource. In contrast with <a href="https://docs.puppet.com/puppet/4.6/metaparameter.html#require">Puppet, require/before are considered meta parameters</a>, whereas in mgmt, the equivalent is a graph edge, which is not a meta parameter. [1]

<span style="text-decoration:underline;">Kinds</span>

As of this writing we have seven different kinds of meta parameters:

<ul>
    <li><a href="/blog/2016/03/14/automatic-edges-in-mgmt/">AutoEdge</a></li>
    <li><a href="/blog/2016/03/30/automatic-grouping-in-mgmt/">AutoGroup</a></li>
    <li>Noop</li>
    <li>Retry & Delay</li>
    <li>Poll</li>
    <li>Limit & Burst</li>
    <li>Sema</li>
</ul>

The astute reader will note that there are actually nine different meta parameters listed, but I have grouped them into seven categories since some of them are very tightly interconnected. The first two, <a href="/blog/2016/03/14/automatic-edges-in-mgmt/">AutoEdge</a> and <a href="/blog/2016/03/30/automatic-grouping-in-mgmt/">AutoGroup</a> have been covered in separate articles already, so they won't be discussed here. To learn about the others, please read on...

<strong><a href="https://github.com/purpleidea/mgmt/blob/master/docs/documentation.md#noop-1"><span style="text-decoration:underline;">Noop</span></a></strong>

Noop stands for no-operation. If it is set to <code>true</code>, we tell the CheckApply portion of the resource to not make any changes. It is up to the individual resource implementation to respect this facility, which is the case for all correctly written resources. You can learn more about this by reading <a href="https://github.com/purpleidea/mgmt/blob/master/docs/resource-guide.md#checkapply">the CheckApply section in the resource guide</a>.

If you'd like to set the noop state on all resources at runtime, there is a cli flag which you can use to do so. It is unsurprisingly named <code>--noop</code>, and overrides all the resources in the graph. <a href="https://docs.puppet.com/puppet/4.6/metaparameter.html#noop">This is in stark contrast with Puppet which will allow an individual resource definition to override the user's choice!</a>

```
james@computer:/tmp$ cat noop.pp
file { '/tmp/puppet.noop':
    content => "nope, nope, nope!\n",
    noop => false,    # set at the resource level
}
james@computer:/tmp$ time puppet apply noop.pp
Notice: Compiled catalog for computer in environment production in 0.29 seconds
Notice: /Stage[main]/Main/File[/tmp/puppet.noop]/ensure: defined content as '{md5}d8bda32dd3fbf435e5a812b0ba3e9a95'
Notice: Applied catalog in 0.03 seconds

real    0m15.862s
user    0m7.423s
sys    0m1.260s
james@computer:/tmp$ file puppet.noop    # verify it worked
puppet.noop: ASCII text
james@computer:/tmp$ rm -f puppet.noop    # reset
james@computer:/tmp$ time puppet apply --noop noop.pp    # safe right?
Notice: Compiled catalog for computer in environment production in 0.30 seconds
Notice: /Stage[main]/Main/File[/tmp/puppet.noop]/ensure: defined content as '{md5}d8bda32dd3fbf435e5a812b0ba3e9a95'
Notice: Class[Main]: Would have triggered 'refresh' from 1 events
Notice: Stage[main]: Would have triggered 'refresh' from 1 events
Notice: Applied catalog in 0.02 seconds

real    0m15.808s
user    0m7.356s
sys    0m1.325s
james@computer:/tmp$ cat puppet.noop
nope, nope, nope!
james@computer:/tmp$
```
If you look closely, Puppet just trolled you by performing an operation when you thought it would be noop! I think the behaviour is incorrect, but if this isn't supposed to be a bug, then I'd sure like to know why!

It's worth mentioning that there is also a <a href="https://github.com/purpleidea/mgmt/blob/master/resources/noop.go#L18"><code>noop</code> resource in mgmt</a> which is similarly named because it does absolutely nothing.

<strong><a href="https://github.com/purpleidea/mgmt/blob/master/docs/documentation.md#retry"><span style="text-decoration:underline;">Retry &amp; Delay</span></a></strong>

In mgmt we can run continuously, which means that it's often more useful to do something interesting when there is a resource failure, rather than simply shutting down completely. As a result, if there is an error during the CheckApply phase of the resource execution, the operation can be retried (<em>retry</em>) a number of times, and there can be a <em>delay</em> between each retry.

The <em>delay</em> value is an integer representing the number of milliseconds to wait between retries, and it defaults to zero. The <em>retry</em> value is an integer representing the maximum number of allowed retries, and it defaults to zero. A negative value will permit an infinite number of retries. If the number of retries is exhausted, then the temporary resource failure will be converted into a permanent failure. Resources which depend on a failed resource will be blocked until there is a successful execution. When there is a successful <em>CheckApply</em>, the resource retry counter is reset.

In general it is best to leave these values at their defaults unless you are expecting spurious failures, this way if you do get a failure, it won't be masked by the retry mechanism.

It's worth mentioning that the <em>Watch</em> loop can fail as well, and that the <em>retry</em> and <em>delay</em> meta parameters apply to this as well! While these could have had their own set of meta parameters, I felt it would have unnecessarily cluttered up the interface, and I couldn't think of a reason where it would be helpful to have different values. They do have their own separate retry counter and delay timer of course! If someone has a valid use case, then I'm happy to separate these.

If someone would like to implement a pluggable back-off algorithm (eg: <a href="https://en.wikipedia.org/wiki/Exponential_backoff">exponential back-off</a>) to be used here instead of a simple delay, then I think it would be a welcome addition!

<strong><a href="https://github.com/purpleidea/mgmt/blob/master/docs/documentation.md#poll"><span style="text-decoration:underline;">Poll</span></a></strong>

Despite mgmt being event based, there are situations where you'd really like to poll instead of using the <em>Watch</em> method. For these cases, I reluctantly implemented a <em>poll</em> meta parameter. It does exactly what you'd expect, generating events every <code>poll</code> seconds. It defaults to zero which means that it is disabled, and <em>Watch</em> is used instead.

Despite my earlier knock of it, it is actually quite useful, in that some operations might require or prefer polling, and having it as a meta parameter means that those resources won't need to duplicate the polling code.

This might be very powerful for an <a href="https://aws.amazon.com/"><strong><em>aws</em></strong></a> resource that can set up hosted <em><a href="https://en.wikipedia.org/wiki/Amazon_Elastic_Compute_Cloud">Amazon ec2</a></em> resources. When combined with the <em>retry</em> and <em>delay</em> meta parameters, it will even survive <a href="https://status.aws.amazon.com/">outages</a>!

One particularly interesting aspect is that ever since the converged graph detection was improved, we can still converge a graph and shutdown with the <code>converged-timeout</code> functionality while using polling! <a href="https://github.com/purpleidea/mgmt/blob/master/docs/documentation.md#poll">This is described in more detail in the documentation.</a>

<strong><a href="https://github.com/purpleidea/mgmt/blob/master/docs/documentation.md#limit"><span style="text-decoration:underline;">Limit &amp; Burst</span></a></strong>

In mgmt, the events generated by the <em>Watch</em> main loop of a resource do not need to be 1-1 matched with the <em>CheckApply</em> remediation step. This is very powerful because it allows mgmt to collate multiple events into a single <em>CheckApply</em> step which is helpful for when the duration of the <em>CheckApply</em> step is longer than the interval between <em>Watch</em> events that are being generated often.

In addition, you might not want to constantly <em>Check</em> or <em>Apply</em> (converge) the state of your resource as often as it goes out of state. For this situation, that step can be rate limited with the <em>limit</em> and <em>burst</em> meta parameters.

The <em>limit</em> and <em>burst</em> meta parameters implement something known as a <strong><a href="https://en.wikipedia.org/wiki/Token_bucket">token bucket</a></strong>. This models a bucket which is filled with tokens and which is drained slowly. It has a particular rate limit (which sets a maximum rate) and a burst count which sets a maximum bolus which can be absorbed.

This doesn't cause us to permanently miss events (and stay un-converged) because when the bucket overfills, instead of dropping events, we actually cache the last one for playback once the bucket falls within the execution rate threshold. Remember, we expect to be converged in the steady state, not at every <a href="https://en.wikipedia.org/wiki/(%CE%B5,_%CE%B4)-definition_of_limit">infinitesimal delta <em>t</em></a> in between.

The <em>limit</em> and <em>burst</em> metaparams default to allowing an infinite rate, with zero burst. As it turns out, if you have a non-infinite rate, the burst must be non-zero or you will cause a <em>Validate</em> error. Similarly, a non-zero burst, with an infinite rate is effectively the same as the default. A good rule of thumb is to remember to either set both values or neither. <a href="https://vimeo.com/13497928">This is all because of the mathematical implications of token buckets which I won't explain in this article.</a>

<strong><a href="https://github.com/purpleidea/mgmt/blob/master/docs/documentation.md#sema">Sema</a></strong>

Sema is short for semaphore. In mgmt we have implemented <a href="https://en.wikipedia.org/wiki/Semaphore_(programming)">P/V style counting semaphores</a>. This is a mechanism for reducing parallelism in situations where there are not explicit dependencies between resources. This might be useful for when the number of operations might outnumber the number of CPUs on your machine and you want to avoid starving your other processes. Alternatively, there might be a particular operation that you want to add a mutex (<a href="https://en.wikipedia.org/wiki/Lock_(computer_science)">mutual exclusion</a>) around, which can be represented with a semaphore of size (1) one. Lastly, it was a particularly fun meta parameter to write, and I had been itching to do so for some time.

To use this meta parameter, simply give a list of semaphore ids to the resource you want to lock. These can be any string, and are shared globally throughout the graph. By default, they have a size of one. To specify a semaphore with a different size, append a colon (<strong>:</strong>) followed by an integer at the end of the semaphore id.

Valid ids might include: "<code>some_id:42</code>", "<code>hello:13</code>", and "<code>lockname</code>". Remember, the size parameter is the number of simultaneous resources which can run their <em>CheckApply</em> methods at the same time. It does not prevent multiple <em>Watch</em> methods from returning events simultaneously.

If you would like to force a semaphore globally on all resources, you can pass in the <code>--sema</code> argument with a size integer. This will get appended to the existing semaphores. For example, to simulate Puppet's traditional non-parallel execution, you could specify <code>--sema 1</code>.

Oh, no! Does this mean I can deadlock my graphs? Interestingly enough, this is actually completely safe! The reason is that because all the semaphores exist in the mgmt <a href="https://en.wikipedia.org/wiki/Directed_acyclic_graph">directed acyclic graph</a>, and because that DAG represents dependencies that are always respected, there will always be a way to make progress, which eventually unblocks any waiting resources! The trick to doing this is ensuring that each resource always acquires the list of semaphores in alphabetical order. (Actually the order doesn't matter as long as it's consistent across the graph, and alphabetical is as good as any!) Unfortunately, I don't have a formal proof of this, but I was able to convince myself on the <a href="https://en.wikipedia.org/wiki/Back-of-the-envelope_calculation">back of an envelope</a> that it is true! <a href="/contact/">Please contact me if you can prove me right or wrong!</a> The one exception is that a counting semaphore of size zero would never let anyone acquire it, so by definition it would permanently block, and as a result is not <em>currently</em> permitted.

The last important point to mention is about the interplay between <a href="/blog/2016/03/30/automatic-grouping-in-mgmt/">automatic grouping</a> and semaphores. When more than one resource is grouped, they are considered to be part of the same resource. As a result, the resulting list of semaphores is the sum of the individual semaphores, de-duplicated. This ensures that individual locking guarantees aren't broken when multiple resources are combined.

<span style="text-decoration:underline;">Future</span>

If you have ideas for future meta parameters, please let me know! We'd love to hear about your ideas on our <a href="https://github.com/purpleidea/mgmt/#community">mailing list or on IRC</a>. If you're shy, you can <a href="/contact/">contact me privately</a> as well.

Happy Hacking,

James

[1] This is a bit of an apples vs. flame-throwers comparison because I'm comparing the mgmt <em>engine</em> meta parameters with the puppet <em>language</em> meta parameters, but I think it's worth mentioning because there's a clear separation between the two in mgmt, where as the separation is much more blurry in the puppet scenario. It's also true that the mgmt language might grow a concept of language-level meta parameters which has a partial set that only maps partially to engine meta parameters, but this is a discussion for another day!

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
