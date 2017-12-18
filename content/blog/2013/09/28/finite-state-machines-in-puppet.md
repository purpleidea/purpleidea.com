+++
date = "2013-09-28 06:09:08"
title = "Finite state machines in puppet"
draft = "false"
categories = ["technical"]
tags = ["awesome", "devops", "finite state machine", "fsm", "gluster", "hack", "phase transitions", "planetfedora", "puppet", "puppet hacks", "puppet-fsm", "puppet-gluster", "thermodynamics"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/09/28/finite-state-machines-in-puppet/"
+++

In my attempt to <a title="setting timed events in puppet" href="/blog/2012/11/14/setting-timed-events-in-puppet/">push puppet to its limits</a>, (for <a title="recursion in puppet (for no particular reason)" href="/blog/2012/11/20/recursion-in-puppet-for-no-particular-reason/">no particular reason</a>), to <a title="Collecting duplicate resources in puppet" href="/blog/2013/06/04/collecting-duplicate-resources-in-puppet/">develop more powerful puppet modules</a>, to<a title="How to avoid cluster race conditions or: How to implement a distributed lock manager in puppet" href="/blog/2012/08/23/how-to-avoid-cluster-race-conditions-or-how-to-implement-a-distributed-lock-manager-in-puppet/"> build in a distributed lock manager</a>, and to <a title="Dynamically including classes in puppet" href="/blog/2013/01/16/dynamically-including-classes-in-puppet/">be more dynamic</a>, I'm now attempting to build a <a href="https://en.wikipedia.org/wiki/Finite-state_machine">Finite State Machine</a> (FSM) in puppet.

<span style="text-decoration:underline;">Is this a real finite state machine, and why would you do this</span>?

Computer science professionals might not approve of the purity level, but they will hopefully appreciate the hack value. I've done this to illustrate a <em>state transition</em> technique that will be necessary in a module that I am writing.

<span style="text-decoration:underline;">Can we have an example</span>?

Sure! I've decided to model <a href="https://en.wikipedia.org/wiki/Phase_transition">thermodynamic phase transitions</a>. Here's what we're building:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="phase_change_-_en-svg.png"><img class="alignnone size-full wp-image-515" alt="Phase_change_-_en.svg" src="phase_change_-_en-svg.png" width="100%" height="100%" /></a></td></tr></table></br />

<span style="text-decoration:underline;">How does it work</span>?

Start off with a given <em>define</em> that accepts an argument. It could have one argument, or many, and be of whichever type you like, such as an integer, or even a more complicated list type. To keep the example simple, let's work with a single argument named <em>$input</em>.
{{< highlight ruby >}}
define fsm::transition(
        $input = ''
) {
        # TODO: add amazing code here...
}
{{< /highlight >}}

The FSM runs as follows: On first execution, the <em>$input</em> value is saved to a local file by means of a puppet <em>exec</em> type. A corresponding fact exists to read from that file and create a unique variable for the <em>fsm::transition</em> type. Let's call that variable <em>$last.</em> <strong>This is the special part!</strong>
{{< highlight ruby >}}
# ruby fact to pull in the data from the state file
found = {}
Dir.glob(transition_dir+'*').each do |d|
    n = File.basename(d)    # should be the fsm::transition name
    if n.length > 0 and regexp.match(n)
        f = d.gsub(/\/$/, '')+'/state'    # full file path
        if File.exists?(f)
            # TODO: future versions should unpickle (but with yaml)
            v = File.open(f, 'r').read.strip    # read into str
            if v.length > 0 and regexp.match(v)
                found[n] = v
            end
        end
    end
end

found.keys.each do |x|
    Facter.add('fsm_transition_'+x) do
        #confine :operatingsystem => %w{CentOS, RedHat, Fedora}
        setcode {
            found[x]
        }
    end
end
{{< /highlight >}}

On subsequent runs, the process gets more interesting: The <em>$input</em> value and the <em>$last</em> value are used to decide what to run. They can be different because the user might have changed the <em>$input</em> value. Logic trees then decide what actions you'd like to perform. This lets us compare the previous state to the new desired state, and as a result, be more intelligent about which actions need to run for a successful state transition. <strong>This is the FSM part.</strong>
{{< highlight ruby >}}
# logic tree modeling phase transitions
# https://en.wikipedia.org/wiki/Phase_transition
$transition = "${valid_last}" ? {
        'solid' => "${valid_input}" ? {
               'solid' => true,
               'liquid' => 'melting',
               'gas' => 'sublimation',
               'plasma' => false,
               default => '',
        },
        'liquid' => "${valid_input}" ? {
               'solid' => 'freezing',
               'liquid' => true,
               'gas' => 'vaporization',
               'plasma' => false,
               default => '',
        },
        'gas' => "${valid_input}" ? {
               'solid' => 'deposition',
               'liquid' => 'condensation',
               'gas' => true,
               'plasma' => 'ionization',
               default => '',
        },
        'plasma' => "${valid_input}" ? {
               'solid' => false,
               'liquid' => false,
               'gas' => 'recombination',
               'plasma' => true,
               default => '',
        },
        default => '',
}
{{< /highlight >}}

Once the state transition actions have completed successfully, the exec must store the <em>$input</em> value in the local file for future use as the unique <em>$last</em> fact for the next puppet run. If there are errors during state transition execution, you may choose to not store the updated value (to cause a re-run) and/or to add an error condition fact that the subsequent puppet run will have to read in and handle accordingly. <strong>This is the important part.</strong>
{{< highlight ruby >}}
$f = "${vardir}/transition/${name}/state"
$diff = "/usr/bin/test '${valid_input}' != '${valid_last}'"

# TODO: future versions should pickle (but with yaml)
exec { "/bin/echo '${valid_input}' > '${f}'":
        logoutput => on_failure,
        onlyif => "/usr/bin/test ! -e '${f}' || ${diff}",
        require => File["${vardir}/"],
        alias => "fsm-transition-${name}",
}
{{< /highlight >}}
<span style="text-decoration:underline;">Can we take this further</span>?

It might be beneficial to remember the path we took through our graph. To do this, on each transition we append the new state to a file on our local puppet client. The corresponding fact, is similar to the <em>$last</em> fact, except it maintains a list of values instead of just one. There is a max length variable that can be used to avoid storing unlimited old states.

<span style="text-decoration:underline;">Does this have a practical use</span>?

Yes, absolutely! I realized that something like this could be useful for <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a>. Stay tuned for more patches.

Hopefully you enjoyed this. By following the above guidelines, you should now have some extra tricks for building state transitions into your puppet modules. Let me know if you found this hack awesome and unique.

<a href="https://github.com/purpleidea/puppet-fsm">I've posted the full example module here.</a>

Happy Hacking,

James

