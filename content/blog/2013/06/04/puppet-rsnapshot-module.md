+++
date = "2013-06-04 02:29:35"
title = "puppet rsnapshot module"
draft = "false"
categories = ["technical"]
tags = ["rsnapshot", "devops", "puppet", "puppet module", "planetpuppet"]
author = "jamesjustjames"
+++

Today I am releasing a puppet module for <a href="http://www.rsnapshot.org/">rsnapshot</a>. The nice feature of this module, is that it lets you configure multiple different instances of rsnapshot, so that they could all run in parallel. Rsnapshot doesn't support this directly, so this puppet module does the heavy lifting of separating out and managing each instance.
```
<a href="https://github.com/purpleidea/puppet-rsnapshot">https://github.com/purpleidea/puppet-rsnapshot</a>
```
The <em>examples/</em> directory should give you a hint on how to use it. For everything else, have a look at the code, or feel free to leave me a comment. I hope you find it useful!

Happy hacking,

James

&nbsp;

