+++
date = "2013-06-04 23:39:08"
title = "Collecting duplicate resources in puppet"
draft = "false"
categories = ["technical"]
tags = ["allow duplicates", "collector", "devops", "duplicate definition", "exported resources", "hack", "planetpuppet", "puppet", "technology"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/06/04/collecting-duplicate-resources-in-puppet/"
+++

I could probably write a long design article explaining why <em>identical</em> duplicate resources should be allowed [1] in puppet. If puppet is going to survive in the long-term, they will have to build in this feature. In the short-term, I will have to hack around deficiency. As luck would have it, <a href="https://twitter.com/bodepd">Mr. Bode</a> has already written part one of the hack: <a href="https://github.com/puppetlabs/puppetlabs-stdlib#ensure_resource">ensure_resource</a>.

<strong>Why?</strong>

Suppose you have a given infrastructure with <em>N</em> vaguely identical nodes. <em>N</em> could equal <strong>2</strong> for a <em>dual primary</em> or <em>active-passive</em> cluster, or <em>N</em> could be greater than <strong>2</strong> for a more elaborate N-ary cluster. It is sufficient to say, that each of those <em>N</em> nodes might export an identical puppet resource which one (or many) clients might need to collect, to operate correctly. It's important that each node export this, so that there is no single point of failure if one or more of the cluster nodes goes missing.

<strong>How?</strong>

As I mentioned, <em>ensure_resources</em> is a good enough hack to start. Here's how you take an existing resource, and make it duplicate friendly. Take for example, the bulk of my <em>dhcp::subnet</em> resource:

{{< highlight ruby >}}
define dhcp::subnet(
      $subnet,
      # [...]
      $range = [],
      $allow_duplicates = false
) {
      if $allow_duplicates { # a non empty string is also a true
            # allow the user to specify a specific split string to use...
            $c = type($allow_duplicates) ? {
                  'string' => "${allow_duplicates}",
                  default => '#',
            }
            if "${c}" == '' {
                  fail('Split character(s) cannot be empty!')
            }

            # split into $realname-$uid where $realname can contain split chars
            $realname = inline_template("<%= name.rindex('${c}').nil?? name : name.slice(0, name.rindex('${c}')) %>")
            $uid = inline_template("<%= name.rindex('${c}').nil?? '' : name.slice(name.rindex('${c}')+'${c}'.length, name.length-name.rindex('${c}')-'${c}'.length) %>")

            $params = { # this must use all the args as listed above...
                  'subnet' => $subnet,
                  # [...]
                  'range' => $range,
                  # NOTE: don't include the allow_duplicates flag...
            }

            ensure_resource('dhcp::subnet', "${realname}", $params)
      } else { # body of the actual resource...

            # BUG: lol: https://projects.puppetlabs.com/issues/15813
            $valid_range = type($range) ? {
                  'array' => $range,
                  default => [$range],
            }

            # the templating part of the module... 
            frag { "/etc/dhcp/subnets.d/${name}.subnet.frag":
                  content => template('dhcp/subnet.frag.erb'),
            }
      }
}
{{< /highlight >}}

As you can see, I added an <em>$allow_duplicates</em> parameter to my resource. If it is set to true, then when the resource is defined, it parses out a trailing <em><strong>#</strong>comment</em> from the <em>$namevar</em>. This can guarantee uniqueness for the <em>$name</em> (if they happen to be on the same node) but more importantly, it can guarantee uniqueness on a collector, where you will otherwise be unable to workaround the <em>$name</em> collision.

This is how you use this on one of the exporting nodes:

{{< highlight ruby >}}
@@dhcp::subnet { "dmz#${hostname}":
    subnet => ...,
      range => [...],
      allow_duplicates => '#',
}
{{< /highlight >}}

and on the collector:
{{< highlight ruby >}}
Dhcp::Subnet <<| tag == 'dhcp' and title != "${dhcp_zone}" |>&gt; {
}
{{< /highlight >}}

There are a few things to notice:
<ol>
	<li>The <em>$allow_duplicates</em> argument can be set to <em>true</em> (a boolean), or to any string. If you pick a string, then that will be used to "split" out the end comment. It's smart enough to split with a reverse index search so that your name can contain the #'s if need be. By default it looks for a single <strong>#</strong>, but you could replace this with '<em>XXX123HACK</em>' if that was the only unique string match you can manage. Make sure not to use the string value of '<em>true</em>'.</li>
	<li>On my collector I like to filter by <em>title</em>. This is the <em>$namevar</em>. Sadly, this doesn't support any fancier matching like <em>in_array</em> or <em>startswith</em>. I consider this a puppet deficiency. Hopefully someone will fix this to allow general puppet code here.</li>
	<li>Adding this to each resource is kind of annoying. It's obviously a hack, but it's the right thing to do for the time being <em>IMHO</em>.</li>
</ol>
Hope you had fun with this.

Happy hacking,

James

PS: [1] One side note, in the general case for custom resources, I actually think that by default duplicate parameters should be required, but that a resource could provide an optional function such as <em>is_matched</em> which would take as input the two parameter hash trees, and decide if they're "functionally equivalent". This would let an individual resource decide if it matters that you specified <em>thing=&gt;yes</em> in one and <em>thing=&gt;true</em> in the other. Functionally it matters that duplicate resources don't have conflicting effects. I'm sure this would be particularly bug prone, and probably cause thrashing in some cases, which is why, by default the parameters should all match. <em>&lt;/babble&gt;</em>

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
