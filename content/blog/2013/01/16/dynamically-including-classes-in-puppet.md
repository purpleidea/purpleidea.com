+++
date = "2013-01-16 07:29:14"
title = "Dynamically including classes in puppet"
draft = "false"
categories = ["technical"]
tags = ["dynamic include", "hiera", "puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/01/16/dynamically-including-classes-in-puppet/"
+++

As you might already know, I like pushing the boundaries of what puppet is able to do. Today, I realized that I needed to <em>include</em> a class by variable name. A simple way to do this is possible with:
```
$foo = 'world'
class { "hello::${foo}::params":
}
```
I then realized that you could also do this with the standard include keyword:
```
$foo = 'world'
include "hello::${foo}::params"
```
If you're really insane enough to need to have your include depend on a variable, then this should suit your needs. The advantage of the second form is that if that statement appears more than once, you won't cause a "duplicate definition" error.

Recently, I've been playing around with <a href="https://github.com/puppetlabs/hiera">hiera</a>. For completeness, I will mention one more form. It turns out that the hiera puppet functions offer a <em>hiera_include</em> function. As with all the hiera functions, the second argument lets you specify a default:
```
$foo = 'world'
hiera_include('...', "hello::${foo}::params")
```
which finishes off the trilogy. Hope this was useful, now start getting creative and

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
