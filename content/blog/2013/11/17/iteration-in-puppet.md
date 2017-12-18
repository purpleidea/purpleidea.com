+++
date = "2013-11-17 04:25:01"
title = "Iteration in Puppet"
draft = "false"
categories = ["technical"]
tags = ["DSL", "create_resources", "declarative programming", "devops", "domain-specific language", "erb", "for loop", "future parser", "gluster", "imperative programming", "iteration", "module design", "planetdevops", "planetfedora", "planetpuppet", "puppet", "recursion", "templates", "turing completeness", "while loop", "yaml"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/11/17/iteration-in-puppet/"
+++

People often ask how to do <a href="https://en.wikipedia.org/wiki/Iteration">iteration</a> in <a href="https://en.wikipedia.org/wiki/Puppet_%28software%29">Puppet</a>. Most Puppet users have a background in <a href="https://en.wikipedia.org/wiki/Imperative_programming">imperative programming</a>, and are already very familiar with <a href="https://en.wikipedia.org/wiki/For_loop"><em>for</em></a> loops. Puppet is sometimes confusing at first, because it is actually (or technically, contains) a <a href="https://en.wikipedia.org/wiki/Declarative_programming">declarative</a>, <a href="https://en.wikipedia.org/wiki/Domain-specific_language">domain-specific language</a>. In general, DSL's aren't always <a href="https://en.wikipedia.org/wiki/Turing_completeness">Turing complete</a>, nor do they need to support <a href="https://en.wikipedia.org/wiki/While_loop">loops</a>, but this doesn't mean you can't iterate.

<a href="http://docs.puppetlabs.com/puppet/3/reference/lang_experimental_3_2.html"> Until recently</a>, Puppet didn't have an explicit looping construct, and it is quite possible to build <a title="puppet-gluster" href="https://github.com/purpleidea/puppet-gluster/">complex</a> <a href="https://github.com/purpleidea/puppet-ipa">modules</a> without using this new construct. There are even some who believe that the language shouldn't even contain this feature. I'll abstain from that debate for now, but instead, I would like to show you some iteration techniques that you can use to get your desired result.

<span style="text-decoration:underline;">Recursion</span>

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="puppets-all-the-way-down.jpg"><img class="size-full wp-image-591 aligncenter" alt="puppets-all-the-way-down" src="puppets-all-the-way-down.jpg" width="100%" height="100%" /></a></td></tr></table></br />

Many people forget that recursion is a form of iteration. Even more don't realize that you can do <a title="recursion in puppet (for no particular reason)" href="/blog/2012/11/20/recursion-in-puppet-for-no-particular-reason/">recursion in Puppet</a>:

{{< highlight ruby >}}
#!/usr/bin/puppet apply

define recursion(
    $count
) {
    # do something here...
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
If you really want to <a title="Pushing Puppet at Puppet Camp DC, LISA 2013" href="/blog/2013/11/05/pushing-puppet-at-puppet-camp-dc-lisa-2013/">Push Puppet</a>, even more <a href="https://github.com/purpleidea/puppet-pushing/blob/master/standalone/fibonacci.pp">advanced</a> <a href="https://github.com/purpleidea/puppet-pushing/blob/master/manifests/fibonacci.pp">recursion</a> is possible. In general, I haven't found this technique very useful for module design, but it's worth mentioning as a form of iteration. If you do find a legitimate use of this technique, <a title="contact" href="/contact/">please let me know</a>!

<span style="text-decoration:underline;">Type iteration</span>

We're used to seeing simple type declarations such as:
{{< highlight ruby >}}
user { 'james':
    ensure => present,
    comment => 'james is awesome!',
}
{{< /highlight >}}
In fact, the <em>namevar</em> can actually accept a list:
{{< highlight ruby >}}
$users = ['kermit', 'beaker', 'statler', 'waldorf', 'tom']
user { $users:
    ensure => present,
    comment => 'who gave these muppets user accounts?',
}
{{< /highlight >}}
<a href="https://www.youtube.com/watch?v=TxwI61FrK_w&NR=1&html5=1">(tom)</a><br />

Which will cause Puppet to effectively iterate across the elements in <em>$users</em>. This is the most important type of iteration in Puppet. Please get familiar with it.

This technique can be used with any <em>type</em>. It can even be used to express a many-to-one dependency relationship:
{{< highlight ruby >}}
# where $bricks is a list of gluster::brick names
Gluster::Brick[$bricks] -> Gluster::Volume[$name]    # volume requires bricks
{{< /highlight >}}
Suppose you'd like to use type iteration, but you'd also like to know the index of each element. This can be useful to avoid duplicate sub-types, or to provide a unique index:
{{< highlight ruby >}}
define some_module::process_array(
    $foo,
    $array    # pass in the original $name
) {
    #notice(inline_template('NAME: <%= name.inspect %>'))

    # do something here...

    # build a unique name...
    $length = inline_template('<%= array.length %>')
    $ulength = inline_template('<%= array.uniq.length %>')
    if ( "${length}" != '0' ) and ( "${length}" != "${ulength}" ) {
        fail('Array must not have duplicates.')
    }
    # if array had duplicates, this wouldn't be a unique index
    $index = inline_template('<%= array.index(name) %>')

    # iterate, knowing your index
    some::type { "${foo}:${index}":
        foo => 'hello',
        index => "${index}",
    }
}

# a list
$some_array = ['a', 'b', 'c']    # must not have duplicates

# using the type requires that you pass in $some_array twice!
some_module::process_array { $some_array:    # array
    foo => 'bar',
    array => $some_array,    # same array as above
}
{{< /highlight >}}
While this example might seem contrived, it is actually a modified excerpt from a module that I wrote.

<span style="text-decoration:underline;">create_resources</span>

This is a similar technique for when you want to specify different arguments for each type:
{{< highlight ruby >}}
$defaults = {
    ensure => present,
    comment => 'a muppet',
}
$data = {
    'kermit' => {
        comment => 'the frog',
    },
    'beaker' => {
        comment => 'keep him away from your glassware',
    },
    'fozzie' => {
        home => '/home/fozzie',
    },
    'tom' => {
        comment => 'the swedish chef',
    }
}
create_resources('user', $data, $defaults)
{{< /highlight >}}
This creates each <em>user</em> resource with its own arguments. If an argument isn't given in the $<em>data</em>, it is taken from the <em>$defaults</em> hash. A similar example, and the official documentation is found <a href="http://docs.puppetlabs.com/references/latest/function.html#createresources">here</a>.

<span style="text-decoration:underline;">Template iteration</span>

You might want to iterate to perform a simple computation, or to modify an array in some way. For static value computations, you can often use a template. Remember that the template will get executed at compile time on the Puppet Master, so code accordingly. Here are a few contrived examples:
{{< highlight ruby >}}
# filter out all the integers less than zero
$array_in = [-4,3,-8,-2,1,4,-2,1,5,-1,-7,9,-3,2,6,-8,5,3,5,-6,8,9,7,-5,9,3,-3]
$array_out = split(inline_template('<%= array_in.delete_if {|x| x < 0 }.join(",") %>'), ',')
notice($array_out)
{{< /highlight >}}
We can also use the ruby <em>map</em>:
{{< highlight ruby >}}
# build out a greeting string
$names = ['animal', 'gonzo', 'rowlf']
# NOTE: you can also use a regular multi-line template for readability
$message = inline_template('<% if names == [] %>Hello... Anyone there?<% else %><%= names.map {|x| "Hello "+x.capitalize}.join(", ") %>.<% end %>')
notice($message)
{{< /highlight >}}
Use your imagination! Remember that you can also write a <a href="http://docs.puppetlabs.com/guides/custom_functions.html">custom function</a> if necessary, but first check that there isn't already a <a href="http://docs.puppetlabs.com/references/latest/function.html">built-in function</a>, or a <a href="https://github.com/puppetlabs/puppetlabs-stdlib#functions">stdlib function</a> that suits your needs.

<span style="text-decoration:underline;">Advanced template iteration</span>

When you really need to get fancy, it's often time to call in a custom function. Custom functions require that you split them off into separate files, and away from the module logic, instead of keeping the functions inline and accessible as lambdas. The downside to using these "inline_template" lambdas instead, is that they can quickly turn into parlous one-liners.
{{< highlight ruby >}}
# transform the $data hash
$data = {
    'waldorf' => {
        'heckles' => 'absolutely',
        'comment' => 'a critic',
    },
    'statler' => {
        'heckles' => 'all the time',
        'comment' => 'another critic!',
    },
}
# rename and filter on the 'heckles' key
$yaml = inline_template('<%= data.inject({}) {|h, (x,y)| h[x] = {"applauds" => y.fetch("heckles", "yes")}; h}.to_yaml %>')
$output = parseyaml($yaml) # parseyaml is in the puppetlabs-stdlib
notice($output)
{{< /highlight >}}
As with simple template iteration, the key problem is transferring the data in and out of the template. In the simple case, arrays can be joined and split as long as there is a reserved character that won't be used in the data. For the advanced template iteration, we rely on the <a href="https://en.wikipedia.org/wiki/YAML">YAML</a> transformation functions.

<span style="text-decoration:underline;">Some reminders</span>

If you properly understand the functionality that your module is trying to model/manage, you can usually break it up into separate classes and defined types, such that re-use via type iteration can fulfill your needs. Usually you'll end up with a more properly designed module.

Test using the same version of Ruby that will run your module. Newer versions of Ruby have some incompatible changes, and new features, with respect to older versions of Ruby.

Remember that templates and functions run on the Puppet Master, but facts and types run on the client (agent).

The Puppet language is mostly <a href="https://en.wikipedia.org/wiki/Declarative_programming">declarative</a>. Because this might be an unfamiliar paradigm, try not to look for all the imperative features that you're used to. Having a programming background can help, because there's certainly programming mixed in, whether you're writing custom functions, or <a href="https://en.wikipedia.org/wiki/ERuby"><em>erb</em></a> templates.

<span style="text-decoration:underline;">Future parser</span>

For completeness, I should mention that the future parser now supports native iteration. If you need it, it probably means that you're writing a fairly advanced module, and you're comfortable <a href="http://docs.puppetlabs.com/puppet/3/reference/lang_experimental_3_2.html">manual diving</a>. If you have a legitimate use case that isn't possible with the existing constructs, and isn't <em>only</em> a readability improvement, please <a title="contact" href="/contact/">let me know</a>.

<span style="text-decoration:underline;">Conclusion</span>

I hope you enjoyed this article. The next time someone asks you how to iterate in Puppet, feel free to link them this way.

Happy hacking,

James

