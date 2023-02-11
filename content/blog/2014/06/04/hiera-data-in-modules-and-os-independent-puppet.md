+++
date = "2014-06-04 03:47:23"
title = "Hiera data in modules and OS independent puppet"
draft = "false"
categories = ["technical"]
tags = ["data-in-modules", "devops", "fedora", "gluster", "hiera", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "yaml"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/06/04/hiera-data-in-modules-and-os-independent-puppet/"
+++

Earlier this year, <a href="https://github.com/ripienaar">R.I.Pienaar</a> released his brilliant <a href="https://github.com/ripienaar/puppet-module-data/">data in modules hack</a>, a few months ago, I got the chance to start <a href="https://github.com/purpleidea/puppet-gluster/commit/32fdb618625f011b7d7387428520441a91321e0e">implementing it in Puppet-Gluster</a>, and today I have found the time to blog about it.

<span style="text-decoration:underline;">What is it</span>?

R.I.'s hack lets you store <a href="https://github.com/puppetlabs/hiera">hiera</a> data inside a puppet module. This can have many uses including letting you throw out the nested mess that is commonly <code>params.pp</code>, and replace it with something file based that is elegant and hierarchical. For my use case, I'm using it to build OS independent puppet modules, without storing this data as code. The secondary win is that porting your module to a new GNU/Linux distribution or version could be as simple as adding a <a href="https://en.wikipedia.org/wiki/YAML">YAML</a> file.

<span style="text-decoration:underline;">How does it work</span>?

<em>(For the specifics on the hack in general, please read <a href="http://www.devco.net/archives/2013/12/08/better-puppet-modules-using-hiera-data.php">R.I. Pienaar's blog post</a>. After you're comfortable with that, please continue...)</em>

In the <code>hiera.yaml</code> <code>data/</code> hierarchy, I define an <a href="https://github.com/purpleidea/puppet-gluster/blob/master/data/hiera.yaml">OS / version structure</a> that should probably cover all use cases. It looks like this:

```
---
:hierarchy:
- params/%{::osfamily}/%{::operatingsystem}/%{::operatingsystemrelease}
- params/%{::osfamily}/%{::operatingsystem}
- params/%{::osfamily}
- common
```
At the bottom, you can specify common data, which can be overridden by <a href="http://futurist.se/gldt/wp-content/uploads/12.10/gldt1210.svg">OS family</a> specific data (think <a href="http://upload.wikimedia.org/wikipedia/commons/9/97/RedHatFamilyTree1210.svg">RedHat "like"</a> vs. <a href="https://upload.wikimedia.org/wikipedia/commons/6/69/DebianFamilyTree1210.svg">Debian "like"</a>), which can be overridden with operating system specific data (think CentOS vs. Fedora), which can finally be overridden with operating system version specific data (think RHEL6 vs. RHEL7).

Grouping the commonalities near the bottom of the tree, avoids duplication, and makes it possible to support new OS versions with fewer changes. It would be especially cool if someone could write a script to refactor commonalities downwards, and to refactor new uniqueness upwards.

<a href="https://github.com/purpleidea/puppet-gluster/blob/master/data/tree/RedHat/Fedora.yaml#L1">This is an except of the Fedora specific YAML file</a>:
```
gluster::params::package_glusterfs_server: 'glusterfs-server'
gluster::params::program_mkfs_xfs: '/usr/sbin/mkfs.xfs'
gluster::params::program_mkfs_ext4: '/usr/sbin/mkfs.ext4'
gluster::params::program_findmnt: '/usr/bin/findmnt'
gluster::params::service_glusterd: 'glusterd'
gluster::params::misc_gluster_reload: '/usr/bin/systemctl reload glusterd'
```
Since we use full paths in Puppet-Gluster, and since they are uniquely different in Fedora (no more: <code>/bin</code>) it's nice to specify them all here. The added advantage is that you can easily drop in different versions of these utilities if you want to test a patched release without having to edit your system utilities. In addition, you'll see that the OS specific RPM package name and service names are in here too. On a Debian system, they are usually different.

<span style="text-decoration:underline;">Dependencies</span>:

This depends on Puppet >= 3.x and having the <em>puppet-module-data</em> module included. <a href="https://github.com/purpleidea/puppet-gluster/blob/32fdb618625f011b7d7387428520441a91321e0e/.gitmodules#L22">I do so for integration with vagrant like so.</a>

<span style="text-decoration:underline;">Should I still use <code>params.pp</code></span>?

I think that this answer is yes. I use a <code>params.pp</code> file with a <a href="https://github.com/purpleidea/puppet-gluster/blob/master/manifests/params.pp#L18">single class</a> specifying all the defaults:
{{< highlight ruby >}}
class gluster::params(
	# packages...
	$package_glusterfs_server = 'glusterfs-server',

	$program_mkfs_xfs = '/sbin/mkfs.xfs',
	$program_mkfs_ext4 = '/sbin/mkfs.ext4',

	# services...
	$service_glusterd = 'glusterd',

	# misc...
	$misc_gluster_reload = '/sbin/service glusterd reload',

	# comment...
	$comment = ''
) {
	if "${comment}" == '' {
		warning('Unable to load yaml data/ directory!')
	}

	# ...

}
{{< /highlight >}}

In my <code>data/common.yaml</code> I include a bogus comment canary so that I can trigger a warning if the <em>data in modules</em> module isn't working. This shouldn't be a <em>fail</em> as long as you want to allow backwards compatibility, otherwise it should be! The defaults I use correspond to the primary OS I hack and use this module with, which in this case is <em>CentOS 6.x</em>.

To use this data in your module, <em>include</em> the <code>params.pp</code> file, and start using it. Example:
{{< highlight ruby >}}
include gluster::params
package { "${::gluster::params::package_glusterfs_server}":
	ensure => present,
}
{{< /highlight >}}
Unfortunately the readability isn't nearly as nice as it is without this, however it's an essential evil, due to the puppet language limitations.

<span style="text-decoration:underline;">Common patterns</span>:

There are a few common code patterns, which you might need for this technique. The first few, I've already mentioned above. These are the <em>tree layout in hiera.yaml</em>, the <em>comment canary</em>, and the <em>params.pp defaults</em>. There's one more that you might find helpful...

<span style="text-decoration:underline;">The split package pattern</span>:

Certain packages are split into multiple pieces on some operating systems, and grouped together on others. This means there isn't always a one-to-one mapping between the data and the package type. For simple cases you can use a hiera array:
{{< highlight ruby >}}
# this hiera value could be an array of strings...
package { $::some_module::params::package::some_package_list:
	ensure => present,
	alias => 'some_package',
}
service { 'foo':
	require => Package['some_package'],
}
{{< /highlight >}}
For this to work you must always define at least one element in the array. For more complex cases you might need to test for the secondary package in the split:

{{< highlight ruby >}}
if "${::some_module::params::package::some_package}" != '' {
	package { "${::some_module::params::package::some_package}":
		ensure => present,
		alias => 'some_package', # or use the $name and skip this
	}
}

service { 'foo':
	require => "${::some_module::params::package::some_package}" ? {
		'' => undef,
		default => Package['some_package'],
	},
}
{{< /highlight >}}
This pattern is used in Puppet-Gluster in more than one place. It turns out that it's also useful when optional python packages get pulled into the system python. (<a href="https://github.com/purpleidea/puppet-gluster/commit/cae38f0e5e90134d997ea28b926c47ac6e7f8d6b">example</a>)

Hopefully you found this useful. Please help increase the multi-os aspect of <a href="https://github.com/purpleidea/puppet-gluster/">Puppet-Gluster</a> by submitting patches to the YAML files, and by testing it on your favourite GNU/Linux distro!

Happy hacking!

James

<strong>EDIT</strong>: I've updated the article to use the new recommended directory naming convention of 'params' instead of 'tree'. <a href="https://github.com/purpleidea/puppet-gluster/commit/b9709099a6402b19b403200221b1537e23e38dd1">Example</a>.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
