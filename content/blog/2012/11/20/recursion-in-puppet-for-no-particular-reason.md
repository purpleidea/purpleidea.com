+++
date = "2012-11-20 06:25:51"
title = "recursion in puppet (for no particular reason)"
draft = "false"
categories = ["technical"]
tags = ["devops", "hacks", "puppet", "recursion"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/11/20/recursion-in-puppet-for-no-particular-reason/"
+++

I'm working on some <em>fancy</em> puppet "code", and I realized recursion could be very useful. I decided to try out a little hack to see if I could get it to work. I'll jump right into the code:
{{< highlight ruby >}}
#!/usr/bin/puppet

define recursion(
    $count
) {
    notify { "count-${count}":
    }
    $minus1 = inline_template('<%= count.to_i - 1 %>')
    if "${minus1}" == '0' {
        notify { 'done counting!':
        }
    } else {
        # recurse
        recursion { "count-${minus1}":
            count => $minus1,
        }
    }
}

# kick it off...
recursion { 'start':
    count => 4,
}
{{< /highlight >}}

In theory, this should now work because of local variable scopes. Let's see if we'll blow up the puppet stack or not...
```
[james@computer tmp]$ ./rec.pp 
warning: Implicit invocation of 'puppet apply' by passing files (or flags) directly
to 'puppet' is deprecated, and will be removed in the 2.8 series.  Please
invoke 'puppet apply' directly in the future.

notice: count-4
notice: /Stage[main]//Recursion[start]/Notify[count-4]/message: defined 'message' as 'count-4'
notice: count-2
notice: /Stage[main]//Recursion[start]/Recursion[count-3]/Recursion[count-2]/Notify[count-2]/message: defined 'message' as 'count-2'
notice: count-3
notice: /Stage[main]//Recursion[start]/Recursion[count-3]/Notify[count-3]/message: defined 'message' as 'count-3'
notice: count-1
notice: /Stage[main]//Recursion[start]/Recursion[count-3]/Recursion[count-2]/Recursion[count-1]/Notify[count-1]/message: defined 'message' as 'count-1'
notice: done counting!
notice: /Stage[main]//Recursion[start]/Recursion[count-3]/Recursion[count-2]/Recursion[count-1]/Notify[done counting!]/message: defined 'message' as 'done counting!'
notice: Finished catalog run in 0.16 seconds
[james@computer tmp]$
```
...and amazingly this seems to work! Hopefully this will be useful for some upcoming trickery I have planned, and if not, it was a fun hack.

I decided to see if it could handle larger values, and for my simple tests, it seemed to do okay:
```
notice: /Stage[main]//Recursion[start]/Recursion[count-99]/Recursion[count-98]/Recursion[count-97]/Recursion[count-96]/Recursion[count-95]/Recursion[count-94]/Recursion[count-93]/Recursion[count-92]/Recursion[count-91]/Recursion[count-90]/Recursion[count-89]/Recursion[count-88]/Recursion[count-87]/Recursion[count-86]/Recursion[count-85]/Recursion[count-84]/Recursion[count-83]/Recursion[count-82]/Recursion[count-81]/Recursion[count-80]/Recursion[count-79]/Recursion[count-78]/Recursion[count-77]/Recursion[count-76]/Recursion[count-75]/Recursion[count-74]/Recursion[count-73]/Recursion[count-72]/Recursion[count-71]/Recursion[count-70]/Recursion[count-69]/Recursion[count-68]/Recursion[count-67]/Recursion[count-66]/Recursion[count-65]/Recursion[count-64]/Recursion[count-63]/Recursion[count-62]/Recursion[count-61]/Recursion[count-60]/Recursion[count-59]/Recursion[count-58]/Recursion[count-57]/Recursion[count-56]/Recursion[count-55]/Recursion[count-54]/Recursion[count-53]/Recursion[count-52]/Recursion[count-51]/Recursion[count-50]/Recursion[count-49]/Recursion[count-48]/Recursion[count-47]/Recursion[count-46]/Recursion[count-45]/Recursion[count-44]/Recursion[count-43]/Recursion[count-42]/Recursion[count-41]/Recursion[count-40]/Recursion[count-39]/Recursion[count-38]/Recursion[count-37]/Recursion[count-36]/Recursion[count-35]/Recursion[count-34]/Recursion[count-33]/Recursion[count-32]/Recursion[count-31]/Recursion[count-30]/Recursion[count-29]/Recursion[count-28]/Recursion[count-27]/Recursion[count-26]/Recursion[count-25]/Recursion[count-24]/Recursion[count-23]/Recursion[count-22]/Recursion[count-21]/Recursion[count-20]/Recursion[count-19]/Recursion[count-18]/Recursion[count-17]/Recursion[count-16]/Recursion[count-15]/Recursion[count-14]/Recursion[count-13]/Recursion[count-12]/Recursion[count-11]/Recursion[count-10]/Recursion[count-9]/Recursion[count-8]/Recursion[count-7]/Recursion[count-6]/Recursion[count-5]/Recursion[count-4]/Recursion[count-3]/Recursion[count-2]/Recursion[count-1]/Notify[done counting!]/message: defined 'message' as 'done counting!'
notice: Finished catalog run in 1.16 seconds
```
Running this with a <em>count</em> value of <em>1000</em> took <em>132.19 sec</em> according to puppet, but much longer for the process to actually clean up and finish. This made my fan speed up, but at least it didn't segfault.

Hopefully I'll have something more useful to show you next time, but until then, keep on imagining and,

Happy hacking!

James

<strong>EDIT</strong>: <a title="Advanced recursion and memoization in Puppet" href="/blog/2013/11/27/advanced-recursion-and-memoization-in-puppet/">A follow up is now available.</a>

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
