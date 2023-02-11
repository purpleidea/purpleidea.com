+++
date = "2014-06-06 06:12:19"
title = "Securely managing secrets for FreeIPA with Puppet"
draft = "false"
categories = ["technical"]
tags = ["devops", "fedora", "freeipa", "ipa", "password", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-ipa", "secrets", "vagrant"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/06/06/securely-managing-secrets-for-freeipa-with-puppet/"
+++

Configuration management is an essential part of securing your infrastructure because it can make sure that it is set up correctly. It is essential that configuration management only enhance security, and not weaken it. Unfortunately, the status-quo of secret management in puppet is pretty poor.

In the worst (and most common) case, plain text passwords are found in manifests. If the module author tried harder, sometimes these password strings are pre-hashed (and sometimes salted) and fed directly into the consumer. (This isn't always possible without modifying the software you're managing.)

On better days, these strings are kept separate from the code in unencrypted yaml files, and if the admin is smart enough to store their configurations in <a href="https://en.wikipedia.org/wiki/Git_%28software%29">git</a>, they hopefully separated out the secrets into a separate repository. Of course none of these solutions are very convincing to someone who puts security at the forefront.

This article describes how I use puppet to <em>correctly</em> and <em>securely</em> setup <a href="http://www.freeipa.org/">FreeIPA</a>.

<span style="text-decoration:underline;">Background</span>:

FreeIPA is an excellent piece of software that combines <a href="http://directory.fedoraproject.org/">LDAP</a> and <a href="http://web.mit.edu/kerberos/">Kerberos</a> with an elegant web ui and command line interface. It can also glue in additional features like <a href="https://en.wikipedia.org/wiki/Network_Time_Protocol">NTP</a>. It is essential for any infrastructure that wants single sign on, and unified identity management and security. It is a key piece of infrastructure since you can use it as a cornerstone, and build out your infrastructures from that centrepiece. (I hope to make the <a href="https://github.com/purpleidea/puppet-ipa">puppet-ipa</a> module <a href="http://jordancards.com/blog/why-did-michael-jordan-choose-the-number-23/">at least half as good as</a> what the authors have done with FreeIPA core.)

<span style="text-decoration:underline;">Mechanism</span>:

Passing a secret into the FreeIPA server for installation is simply not possible without it touching puppet. The way I work around this limitation is by generating the <em>dm_password</em> on the FreeIPA server at install time! This typically looks like:
```
/usr/sbin/ipa-server-install --hostname='ipa.example.com' --domain='example.com' --realm='EXAMPLE.COM' --ds-password=`/usr/bin/pwgen 16 1 | /usr/bin/tee >( /usr/bin/gpg --homedir '/var/lib/puppet/tmp/ipa/gpg/' --encrypt --trust-model always --recipient '24090D66' > '/var/lib/puppet/tmp/ipa/gpg/dm_password.gpg' ) | /bin/cat | /bin/cat` --admin-password=`/usr/bin/pwgen 16 1 | /usr/bin/tee >( /usr/bin/gpg --homedir '/var/lib/puppet/tmp/ipa/gpg/' --encrypt --trust-model always --recipient '24090D66' > '/var/lib/puppet/tmp/ipa/gpg/admin_password.gpg' ) | /bin/cat | /bin/cat` --idstart=16777216 --no-ntp --selfsign --unattended
```
This command is approximately what puppet generates. The interesting part is:
```
--ds-password=`/usr/bin/pwgen 16 1 | /usr/bin/tee >( /usr/bin/gpg --homedir '/var/lib/puppet/tmp/ipa/gpg/' --encrypt --trust-model always --recipient '24090D66' > '/var/lib/puppet/tmp/ipa/gpg/dm_password.gpg' ) | /bin/cat | /bin/cat`
```
If this is hard to follow, here is the synopsis:
<ol>
	<li>The <code>pwgen</code> command is used generate a password.</li>
	<li>The password is used for installation.</li>
	<li>The password is encrypted with the users GPG key and saved to a file for retrieval.</li>
	<li>The encrypted password is (optionally) sent out via email to the admin.</li>
</ol>
Note that the email portion wasn't shown since it makes the command longer.

<span style="text-decoration:underline;">Where did my GPG key come from</span>?

Any respectable FreeIPA admin should already have their own GPG key. If they don't, they probably shouldn't be managing a security appliance. You can either pass the public key to <code>gpg_publickey</code> or specify a keyserver with <code>gpg_keyserver</code>. In either case you must supply a valid recipient (-r) string to <code>gpg_recipient</code>. In my case, I use my keyid of <a href="http://keys.gnupg.net/pks/lookup?op=get&search=0xA0E8F3C024090D66"><code>24090D66</code></a>, which can be used to find my key on the public keyservers. In either case, puppet knows how to import it and use it correctly. A security audit is welcome!

You'll be pleased to know that I deliberately included the options to use your own keyserver, or to specify your public key manually if you don't want it stored on any key servers.

<span style="text-decoration:underline;">But, I want a different password</span>!

It's recommended that you use the secure password that has been generated for you. There are a few options if you don't like this approach:
<ul>
	<li>The puppet module allows you to specify the password as a string. This isn't recommended, but it is useful for testing and compatibility with legacy puppet environments that don't care about security.</li>
	<li>You can use the secure password initially to authenticate with your FreeIPA server, and then change the password to the one you desire. Doing this is outside the scope of this article, and you should consult the <a href="http://www.freeipa.org/page/Documentation">FreeIPA documentation</a>.</li>
	<li>You can use puppet to regenerate a new password for you. This hasn't been implemented yet, but will be coming eventually.</li>
	<li>You can use the interactive password helper. This takes the place of the <code>pwgen</code> command. This will be implemented if there is enough demand. During installation, the admin will be able to connect to a secure console to specify the password.</li>
</ul>
Other suggestions will be considered.

<span style="text-decoration:underline;">What about the admin password</span>?

The <code>admin_password</code> is generated following the same process that was used for the <code>dm_password</code>. The chance that the two passwords match is probably about:
```
1/((((26*2)+10)^16)^2) = ~<span id="cwos" class="cwcot">4.4</span>e-58
```
In other words, very unlikely.

<span style="text-decoration:underline;">Testing this easily</span>:

Testing this out is quite straightforward. This process has been integrated with vagrant for easy testing. Start by setting up vagrant if you haven't already:
<p style="padding-left:30px;"><a href="/blog/2014/05/13/vagrant-on-fedora-with-libvirt-reprise/">Vagrant on Fedora with libvirt (reprise)</a></p>
Once you are comfortable with vagrant, follow these steps for using Puppet-IPA:
```
git clone --recursive https://github.com/purpleidea/puppet-ipa
cd vagrant/
vagrant status
# edit the puppet-ipa.yaml file to add your keyid in the recipient field
# if you do not add a keyid, then a password of 'password' will be used
# this default is only used in the vagrant development environment
vagrant up puppet
vagrant up ipa
```
You should now have a working FreeIPA server. Login as root with:
```
vscreen root@ipa
```
yay!

Hope you enjoyed this.

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
