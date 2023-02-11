+++
date = "2014-03-24 18:37:23"
title = "Introducing Puppet Exec['again']"
draft = "false"
categories = ["technical"]
tags = ["devops", "exec", "Exec['again']", "execvpe", "finite state machine", "gluster", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "python", "spawn"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/03/24/introducing-puppet-execagain/"
+++

Puppet is missing a number of much-needed features. That's the bad news. The good news is that I've been able to write some of these as modules that don't need to change the Puppet core! This is an article about one of these features.

<strong><span style="text-decoration:underline;">Posit</span>:</strong> It's not possible to apply all of your Puppet manifests in a single run.

I believe that this holds true for the current implementation of Puppet. Most manifests can, do and <em>should</em> apply completely in a single run. If your Puppet run takes more than one run to converge, then chances are that you're doing something wrong.

(For the sake of this article, convergence means that everything has been applied cleanly, and that a subsequent Puppet run wouldn't have any work to do.)

There are some advanced corner cases, where this is not possible. In these situations, you will either have to wait for the next Puppet run (by default it will run every 30 minutes) or keep running Puppet manually until your configuration has converged. Neither of these situations are acceptable because:
<ul>
	<li>Waiting 30 minutes while your machines are idle is (<a href="https://xkcd.com/303/">mostly</a>) a waste of time.</li>
	<li>Doing manual work to set up your automation kind of <a href="https://www.andertoons.com/technology/cartoon/6125/i-dunno-kind-of-defeats-purpose-doesnt-it">defeats the purpose</a>.</li>
</ul>
<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="https://xkcd.com/303/"><img src="http://imgs.xkcd.com/comics/compiling.png" alt="'Are you stealing those LCDs?' 'Yeah, but I'm doing it while my code compiles.'" width="100%" height="100%" /></a></td></tr><tr><td> Waiting 30 minutes while your machines are idle is (mostly) a waste of time. Okay, maybe it's not entirely a waste of time :)</td></tr></table></br />

So what's the solution?

<strong><span style="text-decoration:underline;">Introducing</span>:</strong> Puppet <em>Exec['again']</em> !

<em>Exec['again']</em> is a feature which I've added to my <a href="https://github.com/purpleidea/puppet-common">Puppet-Common</a> module.

<strong><span style="text-decoration:underline;">What does it do?</span></strong>

Each Puppet run, your code can decide if it thinks there is <em>more</em> work to do, or if the host is not in a <em>converged</em> state. If so, it will tell <em>Exec['again']</em>.

<strong><span style="text-decoration:underline;">What does Exec['again'] do?</span></strong>

<em>Exec['again']</em> will fork a process off from the running puppet process. It will wait until that parent process has finished, and then it will spawn (technically: <a href="http://docs.python.org/3/library/os#os.execvpe"><em>execvpe</em></a>) a new puppet process to run puppet again. The module is smart enough to inspect the parent puppet process, and it knows how to run the child puppet. Once the new child puppet process is running, you won't see any leftover process id from the parent Exec['again'] tool.

<strong><span style="text-decoration:underline;">How do I tell it to run?</span></strong>

It's quite simple, all you have to do is import my puppet module, and then notify the magic <em>Exec['again']</em> type that my class defines. <span style="text-decoration:underline;">Example</span>:
```
include common::again

$some_str = 'ttboj is awesome'
# you can notify from any type that can generate a notification!
# typically, using exec is the most common, but is not required!
file { '/tmp/foo':
    content => "${some_str}\n",
    notify => Exec['again'], # notify puppet!
}
```
<strong><span style="text-decoration:underline;">How do I decide if I need to run again?</span></strong>

This depends on your module, and isn't always a trivial thing to figure out. In one case, I had to build a <a href="/blog/2013/09/28/finite-state-machines-in-puppet/">finite state machine in puppet</a> to help decide whether this was necessary or not. In some cases, <a href="https://github.com/purpleidea/puppet-gluster/blob/master/manifests/brick.pp#L397">the solution might be simpler</a>. In all cases, this is an advanced technique, so you'll probably already have a good idea about how to figure this out if you need this type of technique.

<strong><span style="text-decoration:underline;">Can I introduce a minimum delay before the next run happens?</span></strong>

Yes, absolutely. This is particularly useful if you are building a distributed system, and you want to give other hosts a chance to export resources before each successive run. <span style="text-decoration:underline;">Example</span>:
```
include common::again

# when notified, this will run puppet again, delta sec after it ends!
common::again::delta { 'some-name':
    delta => 120, # 2 minutes (pick your own value)
}

# to run the above Exec['again'] you can use:
exec { '/bin/true':
    onlyif => '/bin/false', # TODO: some condition
    notify => Common::Again::Delta['some-name'],
}
```
<strong><span style="text-decoration:underline;">Can you show me a real-world example of this module?</span></strong>

Have a look at the <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> module. This module was one of the reasons that I wrote the <em>Exec['again']</em> functionality.

<strong><span style="text-decoration:underline;">Are there any caveats?</span></strong>

Maybe! It's possible to cause a <em>fast</em> "infinite loop", where Puppet gets run unnecessarily. This could effectively DDOS your <em>puppetmaster</em> if left unchecked, so please use with caution! Keep in mind that puppet typically runs in an infinite loop already, except with a 30 minute interval.

<strong><span style="text-decoration:underline;">Help, it won't stop!</span></strong>

Either your code has become sentient, and has decided it wants to <a href="https://github.com/purpleidea/puppet-ipa">enable kerberos</a> or you've got a bug in your Puppet manifests. If you fix the bug, things should eventually go back to normal. To kill the process that's re-spawning puppet, look for it in your process tree. <span style="text-decoration:underline;">Example</span>:
```
[root@server ~]# ps auxww | grep again[.py]
root 4079 0.0 0.7 132700 3768 ? S 18:26 0:00 /usr/bin/python /var/lib/puppet/tmp/common/again/again.py --delta 120
[root@server ~]# killall again.py
[root@server ~]# echo $?
0
[root@server ~]# ps auxww | grep again[.py]
[root@server ~]# killall again.py
again.py: no process killed
[root@server ~]#
```
<strong><span style="text-decoration:underline;">Does this work with puppet running as a service or with <em>puppet agent --test</em>?</span></strong>

Yes.

<strong><span style="text-decoration:underline;">How was the spawn/exec logic implemented?</span></strong>

The spawn/exec logic was implemented as a <a href="https://github.com/purpleidea/puppet-common/blob/master/templates/again/again.py.erb">standalone python program</a> that gets copied to your local system, and does all the heavy lifting. Please have a look and let me know if you can find any bugs!

<strong><span style="text-decoration:underline;">Conclusion</span></strong>

I hope you enjoyed this addition to your toolbox. Please remember to use it with care. If you have a legitimate use for it, please <a title="contact" href="/contact/">let me know</a> so that I can better understand your use case!

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
