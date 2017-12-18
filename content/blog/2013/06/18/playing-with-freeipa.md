+++
date = "2013-06-18 12:36:54"
title = "Playing with FreeIPA and puppet"
draft = "false"
categories = ["technical"]
tags = ["devops", "freeipa", "idm", "ipa", "kerberos", "krb5", "ldap", "planetfedora", "planetpuppet", "puppet", "puppet module"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/06/18/playing-with-freeipa/"
+++

So I just rolled a new vm to hack around with <a href="http://www.freeipa.org/">FreeIPA</a>. Here are some things that I've come across so far. I was planning on configuring LDAP, and Kerberos manually, but the included webui looks like a lovely tool to have for the data entry, user administrator type who likes to click on things. Let's explore...

<span style="text-decoration:underline;"><strong>/etc/hosts</strong></span>:

FreeIPA is choosy about how your <em>/etc/hosts</em> is formatted. It requires an entry that has a particular order, that is:
```
192.168.123.7    ipa.example.com    ipa
```
Obviously replace with your own values. This presents itself as:
```
The host name ipa.example.com does not match the primary host name ipa. Please check /etc/hosts or DNS name resolution
```
I had to dive into the source to figure this one out!

<span style="text-decoration:underline;"><strong>webui</strong></span>:

I'm in hack mode, and my laptop (hack station) is not participating in the domain that I'm pretending to manage. In addition, I'm not directly connected to the vm where I'm testing out FreeIPA. As usual, I port forward:
```
$ ssh root@ipa -L 1443:localhost:443
```
but when attempting to try the webui:
```
$ firefox https://localhost:1443/ipa/ui/
```
I get redirected to the official <em>fqdn</em>, and at port 443. After searching around, it turns out there is a: <em>--no-ui-redirect</em> option that you can pass to the <em>ipa-server-install</em> program, but it only comments out one line of the <em>/etc/httpd/conf.d/ipa-rewrite.conf</em> and doesn't let me do exactly what I want. I'm sure someone with pro apache skills could hack this up properly, but I haven't the patience.

As user <em>ab</em> in <strong>#</strong><em>freeipa</em> kindly pointed out:
```
01:21 < ab> primary authentication method of web ui is Kerberos. 
            Your browser, when configured, will need to obtain a kerberos 
            ticket against web ui's server, that's why you're forced to connect 
            to fully qualified hostname
01:22 < ab> otherwise a browser would attempt to obtain ticket to 
            HTTP/localhost@REALM which does not exist
01:22 < ab> and wouldn't be what web server web ui is running on is using
```
which is a good point. For hacking purposes, I'm happy to forgo kerberos logins and type in a password manually, but since my use case is particularly small, I'll just hack around this for now, and maybe a future <em>FreeIPA</em> will get this option. <a href="https://access.redhat.com/site/documentation//en-US/Red_Hat_Enterprise_Linux/6/html/Identity_Management_Guide/using-the-ui.html#ui-and-proxies">At the moment, it's not supported.</a>

A bad hacker <em>could</em> modify their <em>/etc/hosts</em> to include:
```
127.0.0.1    ipa.example.com ipa localhost.localdomain localhost
```
and run <em>ssh</em> as root (<em>very bad</em>!):
```
$ sudo ssh root@ipa -L 443:localhost:443 -L 80:localhost:80
```
to get easily get access locally. But don't do this. It's evil.

<span style="text-decoration:underline;"><strong>inactivity timeouts</strong></span>:

The web ui times out after 20 minutes. To increase this add:
```
session_auth_duration=42 minutes
```
to your <em>/etc/ipa/default.conf</em>, and restart httpd. <a href="https://git.fedorahosted.org/cgit/freeipa.git/tree/ipalib/util.py#n423">You can have a look at the parser for an idea of what kind of values are acceptable.</a>

<span style="text-decoration:underline;"><strong>puppet?</strong></span>:

As you might agree, it's nice to have puppet modules to get you up and running. FreeIPA was easy to install, and my puppet module now makes it automatic. I've written a lot of fancy puppet code to manage your IPA resources. It's not quite finished, and more resource types are on the way, but you can follow along at:

<a href="https://github.com/purpleidea/puppet-ipa">https://github.com/purpleidea/puppet-ipa</a>

Happy hacking,

James

