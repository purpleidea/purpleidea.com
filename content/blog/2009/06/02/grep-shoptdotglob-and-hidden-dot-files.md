+++
date = "2009-06-02 11:56:08"
title = "grep, shopt:dotglob and (hidden) dot files"
draft = "false"
categories = ["technical"]
author = "jamesjustjames"
+++

i thought grep was broken, but it's not. see below:
```
james@dazzle:~$ echo $0
bash
james@dazzle:~$ echo 'hello world' &gt; .hello
james@dazzle:~$ grep 'hello world' *
james@dazzle:~$ grep 'hello world' .*
.hello:hello world
james@dazzle:~$ shopt | grep dotglob
dotglob            off
james@dazzle:~$ shopt -s dotglob
james@dazzle:~$ shopt | grep dotglob
dotglob            on
james@dazzle:~$ grep 'hello world' *
.hello:hello world
james@dazzle:~$ shopt -u dotglob
james@dazzle:~$ shopt | grep dotglob
dotglob            off
james@dazzle:~$ rm .hello
james@dazzle:~$
```
the problem as it turns out is that the glob character `*' (the asterisk) doesn't expand to include dot files unless you have the shopt variable set. so you can either use to workaround shown above or set it. personally i'll keep mine off.

