+++
date = "2015-02-09 07:31:58"
title = "Introducing: Silent counter"
draft = "false"
categories = ["technical"]
tags = ["counter", "gluster", "monotonic", "planetdevops", "planetfedora", "planetpuppet", "puppet", "python", "silent counter"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/02/09/introducing-silent-counter/"
+++

You might want to write code that can tell how many iterations have passed since some action occurred. Alternatively, you might want to know if it's the first time a machine has run <a href="https://en.wikipedia.org/wiki/Puppet_%28software%29">Puppet</a>. To do these types of things, you might wish to have a <a href="https://en.wikipedia.org/wiki/Monotonic_function">monotonically</a> increasing counter in your Puppet manifest. Since one did not exist, I set out to build one!

<span style="text-decoration:underline;">The code</span>:

If you just want to try the code, and skip the ramble, you can include <a href="https://github.com/purpleidea/puppet-common/blob/master/manifests/counter.pp#L18">common::counter</a> into your manifest. The entire class is part of my puppet-common module:
```
git clone https://github.com/purpleidea/puppet-common
```
<span style="text-decoration:underline;">Usage</span>:

Usage notes are hardly even necessary. Here is how the code is commonly used:

{{< highlight ruby >}}
include ::common::counter    # that's it!

# NOTE: we only see the notify message. no other exec/change is shown!
notify { 'counter':
        message => "Value is: ${::common_counter_simple}",
}

{{< /highlight >}}
Now use the fact anywhere you need a counter!

<span style="text-decoration:underline;">Increasing a variable</span>:

At the heart of any counter, you'll need to have a value store, a way to read the value, and a way to increment the value. For simplicity, the value store we'll use will be a file on disk. This file is located by default at <code>${vardir}/common/counter/simple</code>. To read the value, we use a puppet fact. The fact has a key name of <code>$::common_counter_simple</code>. To increment the value, a simple python script is used.

<span style="text-decoration:underline;">Noise</span>:

To cause an increment of the value on each puppet run, an <a href="https://docs.puppetlabs.com/references/stable/type.html#exec">exec</a> would have to be used. The downside of this is that this causes noise in your puppet logs, even if nothing else is happening! This noise is unwanted, so we work around this with the following code:

{{< highlight ruby >}}
exec { 'counter':
        # echo an error message and be false, if the incrementing fails
        command => '/bin/echo "common::counter failed" && /bin/false',
        unless => "${vardir}/counter/increment.py '${vardir}/counter/simple'",
        logoutput => on_failure,
}

{{< /highlight >}}
As you can see, we cause the run to happen in the silent "unless" part of the exec, and we don't actually allow any exec to occur unless there is an error running the <em>increment.py</em>!

<span style="text-decoration:underline;">Complex example</span>:

If you want to do something more complicated using this technique, you might want to write something like this:

{{< highlight ruby >}}
$max = 8
exec { "/bin/echo this is run #: ${::common_counter_simple}":
        logoutput => on_failure,
        onlyif => [
                "/usr/bin/test ${::common_counter_simple} -lt ${max}",
                "/usr/bin/test ${::common_counter_simple} -gt 0",
        ],
    #notify => ...,    # do some action
}
{{< /highlight >}}
<span style="text-decoration:underline;">Side effects</span>:

Make sure not to use the counter fact in a <em>$name</em> or somewhere that would cause frequent unwanted catalog changes, as it could cause a lot of changes each run.

<span style="text-decoration:underline;">Module pairings</span>:

You might want to pair this module with my "<a href="/blog/2013/09/28/finite-state-machines-in-puppet/">Finite State Machine</a>" concept, or my <a href="/blog/2014/03/24/introducing-puppet-execagain/">Exec['again']</a> module. If you come up with some cool use cases, please <a href="/contact/">let me know</a>!

<span style="text-decoration:underline;">Future work</span>:

If you'd like to extend this work, two features come to mind:
<ol>
	<li>Individual named counters. If for some reason you want more than one counter, named counters could be built.</li>
	<li>Reset functionality. If you'd like to reset a counter to zero (or to some other value) then there should be a special type you could create which causes this to happen.</li>
</ol>
If you'd like to work on either of these features, please let me know, or send me a patch!

Happy hacking!

James

