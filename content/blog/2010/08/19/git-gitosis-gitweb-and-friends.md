+++
date = "2010-08-19 11:03:46"
title = "git, gitosis, gitweb and friends..."
draft = "false"
categories = ["technical"]
tags = ["devops", "etckeeper", "gitolite", "sliced bread", "git", "gitosis", "gitweb", "ssh"]
author = "jamesjustjames"
+++

In case it wasn't already obvious, I am a huge fan of <a href="http://git-scm.com/">git</a>, and often prefer it over <a href="http://en.wikipedia.org/wiki/Sliced_bread">sliced bread</a>. Recently to help a small team of programmers collaborate, I decided to setup a private git server for them to use. By no claim of mine is the following tutorial unique, however I am writing this to aid those who had trouble following <a href="http://scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way">other</a><a href="http://eagain.net/gitweb/?p=gitosis.git;a=blob;f=README.rst"> online</a> <a href="http://hokietux.net/blog/?p=58">tutorials</a>.

<span style="text-decoration:underline;">Goal</span>:
Setup a central git server for private or public source sharing, without having to give everyone a separate shell account.

<span style="text-decoration:underline;">Step 1</span>:
Install git, <a href="http://eagain.net/gitweb/?p=gitosis.git">gitosis</a>, and <a href="http://git.kernel.org/?p=git/git.git;a=tree;f=gitweb;">gitweb</a> by the method of your choosing. Most distributions probably have packages for all of these.

<span style="text-decoration:underline;">Step 2</span>:
Create a user account named "git", "gitosis", or something sensible if it hasn't already been done by some packagers install script. The shell command to do this yourself looks something like:

<code> sudo adduser --system 
--shell /bin/sh 
--gecos 'git version control' 
--group 
--disabled-password 
--home /srv/gitosis 
gitosis
```
In my particular case, I edited the <code>/etc/passwd</code> file to change the automatically added account, however running <code>sudo dpkg-reconfigure gitosis</code> is probably an easier way to do this.

<span style="text-decoration:underline;">Step 3</span>:
Authentication is done by public ssh key, and gitosis takes care of the magic relationships between a users key and the read/write access per repository. As such, gitosis needs initialization, and it needs the public key of the administrator. If you aren't familiar with ssh public key authentication, go learn about this <a href="http://www.google.com/search?q=ssh+public+key+authentication">now</a>.

To initialize gitosis most tutorials alledge that you should run something like:

<code>sudo -H -u gitosis gitosis-init &lt; SSH_KEY.pub</code>

In my case, this didn't work (likely due to environment variable problems, but try it first anyways) so I cut to the chase and ran:

<code>sudo su - gitosis
gitosis-init &lt; /tmp/SSH_KEY.pub</code>

which worked perfectly right away. Note that you have to copy your public key to a publicly readable location like <code>/tmp/</code> first.

<span style="text-decoration:underline;">Step 4</span>:
Now it's time to change the gitosis configuration file to your liking. Instead of editing the file directly on the server, the model employed is quite clever: git-clone a special repository, edit what's necessary and commit, then push the changes back up. Once this is done, git runs a special commit-hook that generates special files needed for correct operation. The code:

<code>git clone gitosis@SERVER:gitosis-admin.git</code>

<span style="text-decoration:underline;">Step 5</span>:
To add a new repository, and its users, into the machine, the obvious bits are done by making changes in the recently cloned git directory. Once a user has access, setup the new remote, and push.

<code>git remote add origin gitosis@SERVER:the_repository_name.git
git push origin master:refs/heads/master</code>
<div>Subsequent pushes don't need the master:refs/heads/master part, and everything else should function as normal.</div>
<span style="text-decoration:underline;">Gitweb</span>:
I still don't have a happy gitweb+gitosis installation. I'm using apache as a webserver, and I wanted to leave the main <code>/etc/gitweb.conf</code> as unchanged as possible. The gitweb package that I installed, comes with an: <code>/etc/apache2/conf.d/gitweb</code> and all I added was:

<code>SetEnv GITWEB_CONFIG /srv/gitosis/.gitweb.conf</code>
<div>between the &lt;directory&gt; braces. I used the template gitweb configuration file as provided by gitosis.</div>
<span style="text-decoration:underline;">Gitosis</span>:
The last small change that I needed for perfection is to store the gitweb configuration in the gitosis-admin.git directory. To do this, I added a symlink to <code>/srv/gitosis/repositories/gitosis-admin.git/gitweb.conf</code> from the above gitweb config location. The problem is that the file isn't in the git repo. This would require patching gitosis to recognize it as a special file, and since the author doesn't respond to patch offers, and since the gitweb config is usually completely static, I didn't bother taking this any further.

<span style="text-decoration:underline;">Gitolite</span>:
It seems there is a well maintained and more fine grained alternative to gitosis called <a href="http://github.com/sitaramc/gitolite">gitolite</a>. The author was very friendly and responsive, and it seems his software provides finer grained control than gitosis. If I hadn't already setup gitosis, I would have surely investiaged this first.

<span style="text-decoration:underline;">Etckeeper</span>:
If you haven't yet used this tool, then go have a <a href="http://joey.kitenet.net/code/etckeeper/">look</a>. It can be quite useful, and I only have one addition to propose. It should keep a configurable mapping (as an etckeeper config file) with commands to run based on what gets updated. For example, if I update <code>/etc/apache2/httpd.conf</code>, then run <code>/etc/init.d/apache2 reload</code>.

Happy hacking!

