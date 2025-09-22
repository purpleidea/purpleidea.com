+++
date = "2012-11-14 01:31:43"
title = "setting timed events in puppet"
draft = "false"
categories = ["technical"]
tags = ["agpl", "agplv3+", "devops", "idempotent", "puppet", "run once", "timers"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/11/14/setting-timed-events-in-puppet/"
+++

I've tried to push puppet to its limits, and so far I've succeeded. When you hit <a href="http://projects.puppetlabs.com/issues/1565">the kind of bug that forces you to hack around it</a>, you know you are close. In any case, this isn't about that embarrassing bug, it's about how to set delayed actions in puppet.

Enter puppet-runonce, a module that I've just finished writing. It starts off with the realization that you can exec an action which also writes to a file. If it sees this file, then it knows that it has already completed, and shouldn't run itself again. The relevant parts are here:
{{< highlight ruby >}}
define runonce::exec(
    $command = '/bin/true',
    $notify = undef,
    $repeat_on_failure = true
) {
    include runonce::exec::base

    $date = "/bin/date >> /var/lib/puppet/tmp/runonce/exec/${name}"
    $valid_command = $repeat_on_failure ? {
        false => "${date} && ${command}",
        default => "${command} && ${date}",
    }

    exec { "runonce-exec-${name}":
        command => "${valid_command}",
        creates => "/var/lib/puppet/tmp/runonce/exec/${name}",    # run once
        notify => $notify,
        # TODO: add any other parameters here that users wants such as cwd and environment...
        require => File['/var/lib/puppet/tmp/runonce/exec/'],
    }
}
{{< /highlight >}}

This depends on having an isolated namespace per module. I need this in many of my modules, and I have chosen: "<em>/var/lib/puppet/tmp/$modulename</em>". I've added the extra feature that this object can repeatedly run until the <em>$command</em> succeeds or it can run once, and ignore the exit status.

Building a timer is slightly trickier, but follows from the first concept. First create a runonce object which when used, creates a file with a timestamp of "now". Next, create a new exec object which periodically checks the time, and once we're past a certain delta, exec the desired command. That looks something like this:
{{< highlight ruby >}}
# when this is first run by puppet, a "timestamp" matching the system clock is
# saved. every time puppet runs (usually every 30 minutes) it compares the
# timestamp to the current time, and if this difference exceeds that of the
# set delta, then the requested command is executed.
define runonce::timer(
    $command = '/bin/true',
    $delta = 3600,                # seconds to wait...
    $notify = undef,
    $repeat_on_failure = true
) {
    include runonce::timer::base

    # start the timer...
    exec { "/bin/date > /var/lib/puppet/tmp/runonce/start/${name}":
        creates => "/var/lib/puppet/tmp/runonce/start/${name}",    # run once
        notify => Exec["runonce-timer-${name}"],
        require => File['/var/lib/puppet/tmp/runonce/start/'],
        alias => "runonce-start-${name}",
    }

    $date = "/bin/date >> /var/lib/puppet/tmp/runonce/timer/${name}"
    $valid_command = $repeat_on_failure ? {
        false => "${date} && ${command}",
        default => "${command} && ${date}",
    }

    # end the timer and run command (or vice-versa)
    exec { "runonce-timer-${name}":
        command => "${valid_command}",
        creates => "/var/lib/puppet/tmp/runonce/timer/${name}",    # run once
        # NOTE: run if the difference between the current date and the
        # saved date (both converted to sec) is greater than the delta
        onlyif => "/usr/bin/test -e /var/lib/puppet/tmp/runonce/start/${name} && /usr/bin/test \$(( `/bin/date +%s` - `/usr/bin/head -n 1 /var/lib/puppet/tmp/runonce/start/${name} | /bin/date --file=- +%s` )) -gt ${delta}",
        notify => $notify,
        require => [
            File['/var/lib/puppet/tmp/runonce/timer/'],
            Exec["runonce-start-${name}"],
        ],
        # TODO: add any other parameters here that users wants such as cwd and environment...
    }
}
{{< /highlight >}}

The real "magic" is in the power of bash, and its individual elegant pieces. The `<em>date</em>` command makes it easy to import a previous stored value with <em>--file</em>, and a bit of conversion glue and mathematics gives us:
{{< highlight bash >}}
/usr/bin/test -e ${startdatefile} && /usr/bin/test $(( `/bin/date +%s` - `/usr/bin/head -n 1 ${startdatefile} | /bin/date --file=- +%s` )) -gt ${deltaseconds}
{{< /highlight >}}
It's a big mouthful to digest on one line, however it's probably write only code anyways, and isn't really that complicated anyhow. One downside is that this is only evaluated every time puppet runs, so in other words it has the approximate granularity of 30 minutes. If you're using this for anything precise, then you're insane!

Speaking of sanity, why would anyone want such a thing? My use case is simple: I'm writing a <em>fancy</em> puppet-drbd module, to help me auto-deploy clusters. I always have to manually turn up the initial sync rate to get my cluster happy, but this should be reverted for normal use. The solution is to set an initial sync rate with <em>runonce::exec</em>, and revert it 24 hours later with <em>runonce::timer</em>!

Both this module and my drbd module will be released in the near future. All of this code is <a href="http://www.gnu.org/licenses/agpl-3.0.html">AGPLv3+</a> so please share and enjoy with those freedoms.

Happy hacking,
James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
