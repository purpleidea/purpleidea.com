+++
date = "2013-02-20 00:43:35"
title = "Automatic hiera lookups in puppet 3.x"
draft = "false"
categories = ["technical"]
tags = ["hiera", "puppet3", "automatic lookup", "devops", "puppet", "yaml"]
author = "jamesjustjames"
+++

Dear readers,

I've started the slow migration of code from puppet 2.6 all the way to 3.x+. There were a few things I wasn't clear on, so hopefully this will help to discuss these and make your migration easier!

I used hiera in 2.6, and I actually like it a lot so far. I was concerned that automatic lookups would pull in values that I wasn't expecting. This is not the case or a worry. Let's dive in and let the code speak:
```
# create a class in a module or site.pp for testing...
class foo(
        $a = 'apple',
        $b = 'banana'
) {
        notify { 'foo':
                message => "a is: ${a}, b is: ${b}",
        }
}
```
and
```
# define it using :: as a prefix because we want to search in the
# top level, module namespace. optional if we only have one foo.
class { '::foo':
}
```
and
```
# /etc/puppet/hiera.yaml
:backends:
        - yaml

:hierarchy:
        - globals
        - whatever
        - youlike

:yaml:
        :datadir: /etc/puppet/hieradata/
```
and
```
# /etc/puppet/hieradata/whatever.yaml (because of - whatever above)
---
foo::a: 'somevalue' # this many colons is actually valid syntax
dude: 'sweet'
```
will produce:
```
[...]
Notice: a is somevalue, b is: banana
Notice: Finished catalog run in 3.14159265359 seconds
```
This is the automatic lookup. You probably have zero risk of collision with earlier data in your hiera yaml files, because these lookups use keys that match the <em>classname</em>::<em>paramname</em> pattern. If you had used <strong>::</strong> (double colons) in your keys before, then you're insane, and you should check for any collisions! The downside to this is that my <em>whatever.yaml</em> looks awkward with all those colons, but I got over that very quickly.

The full lookup order is first:
```
# directly specified values first (of course)
class { '::foo':
        a => 'this value is used first if set.',
}
```
and then:
```
# values matching an appropriate yaml key:
---
foo::a: 'this value is used next if found.'
```
and finally:
```
class foo(
        $a = 'this parameter default value is used last.'
        $b = 'b is still for banana...'
) {
        # do stuff...
}
```
all as detailed in: <a href="http://projects.puppetlabs.com/issues/11608">http://projects.puppetlabs.com/issues/11608</a>. Finding this link and setting me down the path to knowledge was all thanks to eric0 in #puppet. Thanks Eric!

Make sure to reload your puppetmaster after you make any changes to <em>/etc/puppet/hiera.yaml</em>, and as always:

Happy hacking,

James

