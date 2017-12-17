+++
date = "2013-07-09 06:41:54"
title = "a puppet-ipa user type and a new difference engine"
draft = "false"
categories = ["technical"]
tags = ["ipa", "programming", "devops", "difference engine", "puppet", "examples", "planetfedora", "puppet-ipa", "python", "freeipa", "pgo", "planetpuppet"]
author = "jamesjustjames"
+++

A simple hack to add a <em>user</em> type to my <a href="https://github.com/purpleidea/puppet-ipa">puppet-ipa</a> module turned out to cause quite a stir. I've just pushed these changes out for your testing:
```
3 files changed, 1401 insertions(+), 215 deletions(-)
```
You should now have a highly capable user type, along with <a href="https://github.com/purpleidea/puppet-ipa/blob/master/examples/simple-usage3.pp#L13">some quick examples</a>.

I've also done a rewrite of the <a href="https://github.com/purpleidea/puppet-ipa/blob/master/files/diff.py">difference engine</a>, so that it is cleaner and more robust. It now uses function decorators and individual function comparators to help wrangle the data into easily comparable forms. This should make adding future types easier, and less error prone. If you're not comfortable with ruby, that's okay, because it's written in python!

Have a look at the <a href="https://github.com/purpleidea/puppet-ipa/commit/ba515e13968bf83902735cfb7be33556db6ae4ec">commit message</a>, and please test this code and let me know how it goes.

Happy hacking,

James

PS: This update also adds server configuration globals management which you may find useful. Not all keys are supported, but all the framework and placeholders have been added.

&nbsp;

