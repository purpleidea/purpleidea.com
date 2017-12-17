+++
date = "2012-11-07 18:30:31"
title = "preventing duplicate parameter values in puppet types"
draft = "false"
categories = ["technical"]
tags = ["devops", "keepalived", "puppet", "vrrp"]
author = "jamesjustjames"
+++

I am writing a <a href="http://www.keepalived.org/">keepalived</a> module for puppet. It will naturally be called: "puppet-keepalived", and I will be releasing the code in the near future! In any case, if you're familiar with <a href="http://en.wikipedia.org/wiki/Virtual_Router_Redundancy_Protocol">VRRP</a>, you'll know that each managed link (eg: resource or <a href="http://en.wikipedia.org/wiki/Virtual_IP_address">VIP</a>) has a common <em>routerid</em> and <em>password</em> which are shared among all members in the group. It is important that these parameters are unique across the type definitions on a single node.

Here is an example of two different instance definitions in puppet:
```
keepalived::vrrp { 'VI_NET':
    state => ...,
    routerid => 42, # must be unique
    password => 'somelongpassword...',
}

keepalived::vrrp { 'VI_DMZ':
    state => ...,
    routerid => 43, # must be unique
    password => 'somedifferentlongpassword...',
}
```
Here puppet guarantees that the <em>$name</em> variable is unique. Let's extend this magic with a trick to make sure that <em>routerid</em> and <em>password</em> are too. Here is an excerpt from the relevant puppet definition:
```
define keepalived::vrrp(
    $state,
    ...
    $routerid,
    $password
) {
    ...
    file { "/etc/keepalived/${instance}.vrrp":
        content => template('keepalived/keepalived.vrrp.erb'),
        ...
        ensure => present,
        # NOTE: add unnecessary alias names so that if one of those
        # variables appears more than once, an error will be raised.
        alias => ["password-${password}", "routerid-${routerid}"],
    }
    ...
}
```
As you can see, multiple alias names are specified with an array, and since this file definition is used for each <em>keepalived::vrrp</em> instance, you'll most assuredly cause a "duplicate alias" issue if there is a duplicate <em>routerid</em> or <em>password</em> used!

This trick will also probably work across define types too. To ensure a common key, just create an object like:
```
file { '/root/the_unique_key':
    alias => ["token1-${token1}", "token2-${token2}", "token3-${token3}"],
}
```
The token prefix will guarantee that you don't accidentally cause a collision between dissimilar parameter values, unless that's what you want. I've used a file in this scenario, but you can use whatever object you like. Because of this reason, it would make sense to create a noop() type if you're really serious about this. Maybe puppet labs can add a built-in type upstream.

This is the type of thing that's important to do if you want to write puppet code that acts less like a templating hack and more like a library :)

Happy hacking!

James

