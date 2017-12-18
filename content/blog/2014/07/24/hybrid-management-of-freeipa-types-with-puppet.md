+++
date = "2014-07-24 00:41:08"
title = "Hybrid management of FreeIPA types with Puppet"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "difference engine", "fedora", "freeipa", "function decorator", "hiera", "hybrid management", "idm", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "puppet-ipa", "puppet-ipa+vagrant", "python", "ruby", "vagrant"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/07/24/hybrid-management-of-freeipa-types-with-puppet/"
+++

<em>(Note: this hybrid management technique is being demonstrated in the <a href="https://github.com/purpleidea/puppet-ipa">puppet-ipa</a> module for <a href="https://www.freeipa.org/">FreeIPA</a>, but the idea could be used for other modules and scenarios too. See below for some use cases...)</em>

The error message that puppet hackers are probably most familiar is:
```
Error: Duplicate declaration: Thing[/foo/bar] is already declared in file /tmp/baz.pp:2; 
cannot redeclare at /tmp/baz.pp:4 on node computer.example.com
```
Typically this means that there is either a bug in your code, or someone has defined something more than once. As annoying as this might be, a compile error happens for a reason: puppet detected a problem, and it is giving you a chance to fix it, without first running code that could otherwise leave your machine in an undefined state.

<span style="text-decoration:underline;">The fundamental problem</span>

The fundamental problem is that two or more contradictory declarative definitions might not be able to be properly resolved. For example, assume the following code:
```
package { 'awesome':
    ensure => present,
}

package { 'awesome':
    ensure => absent,
}
```
Since the above are contradictory, they can't be reconciled, and a compiler error occurs. If they were identical, or if they would produce the same effect, then it wouldn't be an issue, however this is not directly allowed due to a flaw in the design of puppet core. (There is an <a href="https://github.com/puppetlabs/puppetlabs-stdlib#ensure_resource">ensure_resource</a> workaround, to be used very cautiously!)

<span style="text-decoration:underline;">FreeIPA types</span>

The <em><a href="https://github.com/purpleidea/puppet-ipa">puppet-ipa</a></em> module exposes a bunch of different types that map to FreeIPA objects. The most common are <a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/server/user.pp#L18">users</a>, <a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/server/host.pp#L18">hosts</a>, and <a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/server/service.pp#L18">services</a>. If you run a dedicated puppet shop, then puppet can be your interface to manage FreeIPA, and life will go on as usual. The caveat is that FreeIPA provides a stunning <em>web-ui</em>, and a powerful <em>cli</em>, and it would be a shame to ignore both of these.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="freeipa-screenshot-users-jjj.png"><img class="size-large wp-image-855" src="freeipa-screenshot-users-jjj.png" alt="The FreeIPA webui is gorgeous. It even gets better in the new 4.0 release." width="100%" height="100%" /></a></td></tr><tr><td> The FreeIPA webui is gorgeous. It even gets better in the new 4.0 release.</td></tr></table></br />

<span style="text-decoration:underline;">Hybrid management</span>

As the title divulges, my <em>puppet-ipa</em> module actually allows hybrid management of the FreeIPA types. This means that puppet can be used in conjunction with the <em>web-ui</em> and the <em>cli</em> to create/modify/delete FreeIPA types. This took a lot of extra thought and engineering to make possible, but I think it was worth the work. This feature is optional, but if you do want to use it, you'll need to let puppet know of your intentions. Here's how...

<span style="text-decoration:underline;">Type excludes</span>

In order to tell puppet to leave certain types alone, the main <code>ipa::server</code> class has <em><a href="https://github.com/purpleidea/puppet-ipa/blob/master/manifests/server.pp#L59">type_excludes</a></em>. Here is an excerpt from that code:
```
# special
# NOTE: host_excludes is matched with bash regexp matching in: [[ =~ ]]
# if the string regexp passed contains quotes, string matching is done:
# $string='"hostname.example.com"' vs: $regexp='hostname.example.com' !
# obviously, each pattern in the array is tried, and any match will do.
# invalid expressions might cause breakage! use this at your own risk!!
# remember that you are matching against the fqdn's, which have dots...
# a value of true, will automatically add the * character to match all.
$host_excludes = [],       # never purge these host excludes...
$service_excludes = [],    # never purge these service excludes...
$user_excludes = [],       # never purge these user excludes...
```
Each of these excludes lets you specify a pattern (or an array of patterns) which will be matched against each defined type, and which, if matched, will ensure that your type is not removed if the puppet definition for it is undefined.

Currently these <em>type_excludes</em> support pattern matching in <a href="https://en.wikipedia.org/wiki/Bash_(software)"><em>bash</em></a> regexp syntax. If there is a strong demand for regexp matching in either <a href="https://en.wikipedia.org/wiki/Python_%28programming_language%29"><em>python</em></a> or <a href="https://en.wikipedia.org/wiki/Ruby_%28programming_language%29"><em>ruby</em></a> syntax, then I will add it. In addition, other types of exclusions could be added. If you'd like to exclude based on some types value, creation time, or some other property, these could be investigated. The important thing is to understand your use case, so that I know what is both useful and necessary.

Here is an example of some <em>host_excludes</em>:
```
class { '::ipa::server':
    host_excludes => [
        "'foo-42.example.com'",                  # exact string match
        '"foo-bar.example.com"',                 # exact string match
        "^[a-z0-9-]*\\-foo\\.example\\.com$",    # *-foo.example.com or:
        "^[[:alpha:]]{1}[[:alnum:]-]*\\-foo\\.example\\.com$",
        "^foo\\-[0-9]{1,}\\.example\\.com"       # foo-<\d>.example.com
    ],
}
```
<a href="https://github.com/purpleidea/puppet-ipa/blob/master/examples/host-excludes.pp">This example</a> and others are listed in the <a href="https://github.com/purpleidea/puppet-ipa/tree/master/examples">examples/</a> folder.

<span style="text-decoration:underline;">Type modification</span>

Each type in puppet has a <code>$modify</code> parameter. The significance of this is quite simple: if this value is set to <em>false</em>, then puppet will not be able to modify the type. (It will be able to remove the type if it becomes undefined, which is what the <em>type_excludes</em> mentioned above is used for.)

This <code>$modify</code> parameter is particularly useful if you'd like to define your types with puppet, but allow them to be modified afterwards by either the <em>web-ui</em> or the <em>cli</em>. If you change a users phone number, and this parameter is <em>false</em>, then it will not be reverted by puppet. The usefulness of this field is that it allows you to define the type, so that if it is removed manually in the FreeIPA directory, then puppet will notice its absence, and re-create it with the defaults you originally defined.

Here is an example user definition that is using <code>$modify</code>:
```
ipa::server::user { 'arthur@EXAMPLE.COM':
    first => 'Arthur',
    last => 'Guyton',
    jobtitle => 'Physiologist',
    orgunit => 'Research',
    #modify => true, # optional, since true is the default
}
```
By default, in true puppet style, the <code>$modify</code> parameter defaults to <code>true</code>. One thing to keep in mind: if you decide to update the puppet definition, then the type <em>will</em> get updated, which could potentially overwrite any manual change you made.

<span style="text-decoration:underline;">Type watching</span>

Type watching is the strict form of type modification. As with type modification, each type has a <code>$watch</code> parameter. This also defaults to <em>true</em>. When this parameter is <em>true</em>, each puppet run will compare the parameters defined in puppet with what is set on the FreeIPA server. If they are different, then puppet will run a modify command so that harmony is reconciled. This is particularly useful for ensuring that the policy that you've defined for certain types in puppet definitions is respected.

Here's an <a href="https://github.com/purpleidea/puppet-ipa/blob/master/examples/simple-usage.pp#L10">example</a>:
```
ipa::server::host { 'nfs':    # NOTE: adding .${domain} is a good idea....
    domain => 'example.com',
    macaddress => "00:11:22:33:44:55",
    random => true,        # set a one time password randomly
    locality => 'Montreal, Canada',
    location => '<a href="https://en.wikipedia.org/wiki/Room_641A">Room 641A</a>',
    platform => 'Supermicro',
    osstring => 'RHEL 6.6 x86_64',
    comment => 'Simple NFSv4 Server',
    watch => true,    # read and understand the docs well
}
```
If someone were to change one of these parameters, puppet would revert it. This detection happens through an elaborate <a href="https://github.com/purpleidea/puppet-ipa/commit/ba515e13968bf83902735cfb7be33556db6ae4ec">difference engine</a>. This was mentioned briefly in an <a href="/blog/2013/07/09/a-puppet-ipa-user-type-and-a-new-difference-engine/">earlier article</a>, and is probably worth looking at if you're interested in python and function decorators.

Keep in mind that it logically follows that you must be able to <code>$modify</code> to be able to <code>$watch</code>. If you forget and make this mistake, <em>puppet-ipa</em> will report the error. You can however, have different values of <code>$modify</code> and <code>$watch</code> per individual type.

<span style="text-decoration:underline;">Use cases</span>

With this hybrid management feature, a bunch of new use cases are now possible! Here are a few ideas:
<ul>
	<li>Manage users, hosts, and services that your infrastructure requires, with puppet, but manage non-critical types manually.</li>
	<li>Manage FreeIPA servers with puppet, but let HR manage user entries with the <em>web-ui</em>.</li>
	<li>Manage new additions with puppet, but exclude historical entries from management while gradually migrating this data into puppet/hiera as time permits.</li>
	<li>Use the <em>cli</em> without fear that puppet will revert your work.</li>
	<li>Use puppet to ensure that certain types are present, but manage their data manually.</li>
	<li>Exclude your development subdomain or namespace from puppet management.</li>
	<li>Assert policy over a select set of types, but manage everything else by <em>web-ui</em> and <em>cli</em>.</li>
</ul>
<span style="text-decoration:underline;">Testing with Vagrant
</span>

You might want to test this all out. It's all pretty automatic if you've followed along with my <a href="/blog/2014/05/13/vagrant-on-fedora-with-libvirt-reprise/">earlier vagrant work</a> and my <em><a href="/blog/2014/01/08/automatically-deploying-glusterfs-with-puppet-gluster-vagrant/">puppet-gluster</a></em> work. You don't have to use vagrant, but it's all integrated for you in case that saves you time! The short summary is:
```
$ git clone --recursive https://github.com/purpleidea/puppet-ipa
$ cd puppet-ipa/vagrant/
$ vs
$ # edit puppet-ipa.yaml (although it's not necessary)
$ # edit puppet/manifests/site.pp (optionally, to add any types)
$ vup ipa1 # it can take a while to download freeipa rpm's
$ vp ipa1 # let the keepalived vip settle
$ vp ipa1 # once settled, ipa-server-install should run
$ <a href="https://gist.github.com/purpleidea/8071962#file-bashrc_vagrant-sh-L196">vfwd</a> ipa1 80:80 443:443 # if you didn't port forward before...
# echo '127.0.0.1   ipa1.example.com ipa1' >> /etc/hosts
$ firefox https://ipa1.example.com/ # accept self-sign https cert
```
<span style="text-decoration:underline;">Conclusion</span>

Sorry that I didn't write this article sooner. This feature has been baked in for a while now, but I simply forgot to blog about it! Since <em>puppet-ipa</em> is getting quite mature, it might be time for me to create some more formal documentation. Until then,

Happy hacking,

James

