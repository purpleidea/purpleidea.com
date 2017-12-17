+++
date = "2013-08-25 04:31:49"
title = "Finding YAML errors in puppet"
draft = "false"
categories = ["technical"]
tags = ["yaml", "hiera", "planetpuppet", "tabs", "devops", "puppet"]
author = "jamesjustjames"
+++

I love tabs, they're so much easier to work with, but YAML doesn't like them. I'm constantly adding them in accidentally, and puppet's error message is a bit cryptic:
```
Error: Could not retrieve catalog from remote server: Error 400 on SERVER: malformed format string - %S at /etc/puppet/manifests/foo.pp:18 on node bar.example.com
```
This happens during a puppet run, which in my case loads up YAML files. The tricky part was that the error wasn't at all related to the <em>foo.pp</em> file, it just happened to be the first time hiera was run. So where's the real error?
```
$ cd /etc/puppet/hieradata/; for i in `find . -name '*.yaml'`; do echo $i; ruby -e "require 'yaml'; YAML.parse(File.open('$i'))"; done
```
Run this one liner on your puppetmaster, and hiera should quickly point out which files have errors, and exactly which lines (and columns) they're on.

Happy hacking,

James

&nbsp;

