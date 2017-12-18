+++
date = "2013-05-14 01:41:23"
title = "Overriding attributes of collected exported resources"
draft = "false"
categories = ["technical"]
tags = ["collect", "devops", "exported resources", "killer feature", "linux", "planetpuppet", "puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/05/14/overriding-attributes-of-collected-exported-resources/"
+++

This post is about a particularly elegant (and crucial) feature in <a href="https://en.wikipedia.org/wiki/Puppet_%28software%29">puppet</a> <a href="http://docs.puppetlabs.com/guides/exported_resources.html">exported resources</a>: <span style="text-decoration:underline;">attribute overriding</span>. If you're not already familiar with exported resources, you should start there, as they are <em>the</em> killer feature that makes configuration management with puppet awesome. (I haven't found any explicit docs about this feature either, so feel free to comment if you know where they're hidden.)

<strong><span style="text-decoration:underline;">Setup</span>:</strong> I've got a virtual machine which exports a resource to <em>N</em> different nodes. I'd like to define the resource with just one exported (<em>@@</em>) definition on my virtual machine.

<strong><span style="text-decoration:underline;">Problem</span>:</strong> One (or more) of the attributes needs to be changed based on which node it gets collected on. To make things more complicated, I'm using the same class definition on each of those <em>N</em> nodes to collect the resource. I don't want to have to write <em>N</em> separate node definitions:
```
@@some::resource { 'the_name':
    foo => 'bar',
    #abc => 'different_on_each_node',
    tag => 'magic',
}
```
<strong><span style="text-decoration:underline;">Solution</span>:</strong> It turns out that for exported (or virtual) resources, you can specify attributes that get set upon collection. Naturally they can depend on a variable such as <em>$name</em>, which is unique to where they get collected:
```
Some::Resource <<| tag == 'magic' |>> {
    abc => "node-${name}",    # override!
}
```
<strong><span style="text-decoration:underline;">Bonus</span>:</strong> You can obviously use other variables throughout including in the collection (<em>tag == 'magic'</em>) area, on both the source and the destination. Instead of a simple equality like I've used, you can actually specify a more complex expression, including other variables such as <em>title</em> (the $name).

Hope this takes your puppet coding to another level,

Happy hacking,

James

