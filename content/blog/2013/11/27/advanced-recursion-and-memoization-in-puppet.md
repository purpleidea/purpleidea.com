+++
date = "2013-11-27 00:03:15"
title = "Advanced recursion and memoization in Puppet"
draft = "false"
categories = ["technical"]
tags = ["devops", "fibonacci", "gluster", "memoization", "planetfedora", "planetpuppet", "puppet", "recursion"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/11/27/advanced-recursion-and-memoization-in-puppet/"
+++

As a follow-up to my original article on <a title="recursion in puppet (for no particular reason)" href="/blog/2012/11/20/recursion-in-puppet-for-no-particular-reason/">recursion in Puppet</a>, and in my attempt to <a title="Pushing Puppet at Puppet Camp DC, LISA 2013" href="/blog/2013/11/05/pushing-puppet-at-puppet-camp-dc-lisa-2013/">Push Puppet (to its limit)</a>, I'll now attempt some more advanced recursion techniques in Puppet.

In my original <a href="https://github.com/purpleidea/puppet-pushing/blob/master/standalone/recursion.pp">recursion example</a>, the type does recurse, but the <em>callee</em> cannot return any value to the <em>caller</em> because it is a type, and not strictly a function. This limitation immediately limits the usefulness of this technique, but I'll try to press on! Let's try to write a <a href="https://en.wikipedia.org/wiki/Fibonacci_number">Fibonacci series</a> function in native Puppet.

For those who aren't familiar, the <a href="https://en.wikipedia.org/wiki/Fibonacci_number">Fibonacci series</a> function is a canonical computer science <a href="https://en.wikipedia.org/wiki/Recursion">recursion</a> example. It is very easy to write as pseudo-code or to implement in python:

{{< highlight python >}}

def F(n):
	if n == 0: return 0
	elif n == 1: return 1
	else: return F(n-1)+F(n-2)
{{< /highlight >}}
<a href="https://github.com/purpleidea/puppet-pushing/blob/master/standalone/fibonacci.py">You can download this function here.</a> Let's run that script to get a table of the first few values in the Fibonacci series:
```
$ ./fibonacci.py
F(0) == 0
F(1) == 1
F(2) == 1
F(3) == 2
F(4) == 3
F(5) == 5
F(6) == 8
F(7) == 13
F(8) == 21
F(9) == 34
F(10) == 55
F(11) == 89
F(12) == 144
F(13) == 233
...
```
Now, I'll introduce my Puppet implementation:

{{< highlight ruby >}}

#!/usr/bin/puppet apply
class fibdir {
	# memoization directory
	file { '/tmp/fibonacci/':
		ensure => directory,
	}
}

define fibonacci(
	$n,
	$intermediate = false # used for pretty printing
) {
	include fibdir

	$vardir = '/tmp'
	$fibdir = "${vardir}/fibonacci"

	if "${n}" == '0' {
		# 0
		exec { "${name}: F(0)":
			command => "/bin/echo 0 > ${fibdir}/0",
			creates => "${fibdir}/0",
			require => File["${fibdir}/"],
		}

	} elsif "${n}" == '1' {
		# 1
		exec { "${name}: F(1)":
			command => "/bin/echo 1 > ${fibdir}/1",
			creates => "${fibdir}/1",
			require => File["${fibdir}/"],
		}

	} else {

		$minus1 = inline_template('<%= n.to_i - 1 %>')
		fibonacci { "${name}: F(${n}-1)":
			n => $minus1,
			intermediate => true,
		}

		$minus2 = inline_template('<%= n.to_i - 2 %>')
		fibonacci { "${name}: F(${n}-2)":
			n => $minus2,
			intermediate => true,
		}

		# who can figure out what the problem with this is ?
		$fn1 = inline_template('<%= f1=fibdir+"/"+minus1; (File.exist?(f1) ? File.open(f1, "r").read.to_i : -1) %>')
		$fn2 = inline_template('<%= f2=fibdir+"/"+minus2; (File.exist?(f2) ? File.open(f2, "r").read.to_i : -1) %>')

		if (("${fn1}" == '-1') or ("${fn2}" == '-1')) {
			$fn = '-1'
		} else {
			$fn = inline_template('<%= fn1.to_i+fn2.to_i %>')
		}

		if "${fn}" != '-1' { # did the lookup work ?
			# store fibonacci number in 'table' (memoization)
			exec { "${name}: F(${n})":
				command => "/bin/echo ${fn} > ${fibdir}/${n}",
				creates => "${fibdir}/${n}",
				require => [
					File["${fibdir}/"],
					Fibonacci["${name}: F(${n}-1)"],
					Fibonacci["${name}: F(${n}-2)"],
				],
			}

			if ! $intermediate {
				# display...
				notify { "F(${n})":
					message => "F(${n}) == ${fn}",
					require => Exec["${name}: F(${n})"],
				}
			}
		}
	}
}

# kick it off...
fibonacci { 'start':
	n => 8,
}
{{< /highlight >}}
<a href="https://github.com/purpleidea/puppet-pushing/blob/master/standalone/fibonacci.pp">It is available for download.</a> Try to read through the code yourself first. As you'll see, if called with <em>n == 0</em>, or <em>n == 1</em>, the function creates a file with this value and exits. This is the secret to how the function (the type) passes values around. It first stores them in files, and then loads them in through templates.

Each time this runs, Puppet will complete the next step in the execution. To make this successive execution automatic, I've <a href="https://github.com/purpleidea/puppet-pushing/blob/master/standalone/fibonacci.sh">written a small bash wrapper</a> to do this, but you can run it manually too. If you do use my wrapper, use it with the <a href="https://github.com/purpleidea/puppet-pushing/blob/master/standalone/fibonacci.pp">fibonacci.pp file provided in git</a>.

The <em>computer scientist</em> might notice that as a side effect, we are actually <a href="https://en.wikipedia.org/wiki/Memoization"><em>memoizing</em></a>. This means that if we run this type again with a larger input value, the previously completed intermediate step values are used as a starting point for the subsequent computations. Cool!

The <em>Puppet wizard</em> might notice that I cheated slightly. Take a minute to try to see where...

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="muppets-clock.png"><img class="size-full wp-image-618" alt="[IMAGE OF TIME PASSING]" src="muppets-clock.png" width="100%" height="100%" /></a></td></tr><tr><td>(IMAGE OF TIME PASSING)</td></tr></table></br />

Have you figured it out? The problem with the current implementation is that it will only work when run locally as a standalone Puppet program. The reason, is that <em>exec</em> types run on the client, and the <em>templates</em> run on the server. This type requires that both of those elements run on the same machine so that the save/load memoization can work correctly. Since this code runs on the same machine, this isn't a problem! This split execution model is one of the features that can confuse new Puppet users.

To adapt our function (technically a type) to work in any environment, we need to do some more hacking! We can continue to use our <em>exec</em> type for saving, but a <em>fact</em> needs to be used to <a href="https://github.com/purpleidea/puppet-pushing/blob/master/lib/facter/fibonacci.rb">load in the necessary values</a>:

{{< highlight ruby >}}

require 'facter'

fibdir = '/tmp/fibonacci/'
valid_fibdir = fibdir.gsub(/\/$/, '')+'/' # ensure trailing slash

results = {} # create list of values

if File.directory?(valid_fibdir)
	Dir.glob(valid_fibdir+'*').each do |f|
		b = File.basename(f)
		i = b.to_i # invalid returns 0
		if b == '0' or i != 0
			v = File.open(f, 'r').read.strip.to_i # read into int
			results[i] = v
		end
	end
end

results.keys.each do |x|
	Facter.add('pushing_fibonacci_'+x.to_s) do
		setcode {
			results[x]
		}
	end
end
{{< /highlight >}}
The templates from the first version of this type need to be replaced with <a href="https://github.com/purpleidea/puppet-pushing/blob/master/manifests/fibonacci.pp">fact variable lookups</a>:

{{< highlight ruby >}}

# these are 'fact' lookups
$fn1 = getvar("pushing_fibonacci_${minus1}")
$fn2 = getvar("pushing_fibonacci_${minus2}&quot;)
{{< /highlight >}}
You can use git to download all of this code as a <a href="https://github.com/purpleidea/puppet-pushing">module</a>.

I hope you enjoyed this. Please let me know! <a href="#comments">Comment below</a>, or <a href="/contact/">send me a message</a>.

Happy hacking,

James

P.S.: While I think this is fun, I wrote this hack to demonstrate some techniques, and to set the stage for future hacks, future techniques, and future Puppet examples. If you're using this as a good way to actually compute values in the Fibonacci series, you're insane!

P.P.S.: The word is actually <a href="https://en.wikipedia.org/wiki/Memoization"><em>memoization</em></a>, <strong>not</strong> <em>memorization</em>, despite the similarities between the two words, and the two concepts.

P.P.P.S: <a href="http://www.gluster.org/blog/">Gluster</a> users get extra points if they can figure out how this will lead to a feature for <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a>. It's a bit tricky to see if you're not following my <a href="https://github.com/purpleidea/">git commits</a>.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
