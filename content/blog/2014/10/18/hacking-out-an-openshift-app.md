+++
date = "2014-10-18 16:43:00"
title = "Hacking out an Openshift app"
draft = "false"
categories = ["technical"]
tags = ["bootstrap", "devops", "fedora", "git", "gluster", "openshift", "pdf", "pdfdoc", "planetdevops", "planetfedora", "planetpuppet", "puppet-gluster", "python"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/10/18/hacking-out-an-openshift-app/"
+++

<a href="https://github.com/purpleidea/puppet-gluster/commit/a4bf5cad81ca66212f4c8e52edb2e816b8895690">I had an itch to scratch</a>, and I wanted to get a bit more familiar with <a href="https://www.openshift.com/">Openshift</a>. I had used it in the past, but it was time to have another go. The <a href="https://pdfdoc-purpleidea.rhcloud.com/">app</a> and the <a href="https://github.com/purpleidea/pdfdoc/">code</a> are now available. Feel free to check out:
<h2 style="text-align:center;"><a href="https://pdfdoc-purpleidea.rhcloud.com/">https://pdfdoc-purpleidea.rhcloud.com/</a></h2>
This is a simple app that takes the URL of a markdown file on GitHub, and outputs a <a href="https://github.com/jgm/pandoc/"><em>pandoc</em></a> converted PDF. I wanted to use <em>pandoc</em> specifically, because it produces PDF's that were beautifully created with <a href="https://en.wikipedia.org/wiki/Latex">LaTeX</a>. To embed a link in your upstream documentation that points to a PDF, just append the file's URL to this app's url, under a <em>/pdf/</em> path. For example:

<a href="https://pdfdoc-purpleidea.rhcloud.com/pdf/https://github.com/purpleidea/puppet-gluster/blob/master/DOCUMENTATION.md">https://pdfdoc-purpleidea.rhcloud.com/pdf/<em>https://github.com/purpleidea/puppet-gluster/blob/master/DOCUMENTATION.md</em></a>

will send you to a PDF of the <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a> documentation. This will make it easier to accept <a href="https://github.com/purpleidea/puppet-gluster/commit/f2c2c85c0a17f1694e6a4c6e53aca75357180bc3">questions as FAQ patches</a>, without needing to have the git embedded binary PDF be constantly updated.

If you want to hear more about what I did, read on...

<span style="text-decoration:underline;">The setup</span>:

Start by getting a free Openshift account. You'll also want to <a href="https://developers.openshift.com/en/getting-started-client-tools.html#fedora">install the client tools</a>. Nothing is worse than having to interact with your app via a web interface. Hackers use terminals. Lucky, the Openshift team knows this, and they've created a great command line tool called <code>rhc</code> to make it all possible.

I started by following their instructions:
```
$ sudo yum install rubygem-rhc
$ sudo gem update rhc
```
Unfortunately, this left with a problem:
```
$ rhc
/usr/share/rubygems/rubygems/dependency.rb:298:in `to_specs': Could not find 'rhc' (>= 0) among 37 total gem(s) (Gem::LoadError)
    from /usr/share/rubygems/rubygems/dependency.rb:309:in `to_spec'
    from /usr/share/rubygems/rubygems/core_ext/kernel_gem.rb:47:in `gem'
    from /usr/local/bin/rhc:22:in `'
```
I solved this by running:
```
$ gem install rhc
```
Which makes my user <code>rhc</code> to take precedence over the system one. Then run:
```
$ rhc setup
```
and the rhc client will take you through some setup steps such as uploading your public ssh key to the Openshift infrastructure. The beauty of this tool is that it will work with the Red Hat hosted infrastructure, or you can use it with your own infrastructure if you want to host your own Openshift servers. This alone means you'll never get locked in to a third-party providers terms or pricing.

<span style="text-decoration:underline;">Create a new app</span>:

To get a fresh <em>python 3.3</em> app going, you can run:
```
$ rhc create-app <em><appname></em> python-3.3
```
From this point on, it's fairly straight forward, and you can now hack your way through the app in python. To push a new version of your app into production, it's just a git commit away:
```
$ git add -p && git commit -m 'Awesome new commit...' && git push && rhc tail
```
<span style="text-decoration:underline;">Creating a new app from existing code</span>:

If you want to push a new app from an existing code base, it's as easy as:
```
$ rhc create-app awesomesauce python-3.3 --from-code https://github.com/purpleidea/pdfdoc
Application Options
-------------------
Domain:      purpleidea
Cartridges:  python-3.3
Source Code: https://github.com/purpleidea/pdfdoc
Gear Size:   default
Scaling:     no

Creating application 'awesomesauce' ... done


Waiting for your DNS name to be available ... done

Cloning into 'awesomesauce'...
The authenticity of host 'awesomesauce-purpleidea.rhcloud.com (203.0.113.13)' can't be established.
RSA key fingerprint is 00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'awesomesauce-purpleidea.rhcloud.com,203.0.113.13' (RSA) to the list of known hosts.

Your application 'awesomesauce' is now available.

  URL:        http://awesomesauce-purpleidea.rhcloud.com/
  SSH to:     00112233445566778899aabb@awesomesauce-purpleidea.rhcloud.com
  Git remote: ssh://00112233445566778899aabb@awesomesauce-purpleidea.rhcloud.com/~/git/awesomesauce.git/
  Cloned to:  /home/james/code/awesomesauce

Run 'rhc show-app awesomesauce' for more details about your app.
```
In my case, my app also needs some binaries installed. I haven't yet automated this process, but I think it can be done be creating a custom cartridge. Help to do this would be appreciated!

<span style="text-decoration:underline;">Updating your app</span>:

In the case of an app that I already deployed with this method, updating it from the upstream source is quite easy. You just pull down and relevant commits, and then push them up to your app's git repo:
```
$ git pull upstream master 
From https://github.com/purpleidea/pdfdoc
 * branch            master     -> FETCH_HEAD
Updating 5ac5577..bdf9601
Fast-forward
 wsgi.py | 2 --
 1 file changed, 2 deletions(-)
$ git push origin master 
Counting objects: 7, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 312 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
remote: Stopping Python 3.3 cartridge
remote: Waiting for stop to finish
remote: Waiting for stop to finish
remote: Building git ref 'master', commit bdf9601
remote: Activating virtenv
remote: Checking for pip dependency listed in requirements.txt file..
remote: You must give at least one requirement to install (see "pip help install")
remote: Running setup.py script..
remote: running develop
remote: running egg_info
remote: creating pdfdoc.egg-info
remote: writing pdfdoc.egg-info/PKG-INFO
remote: writing dependency_links to pdfdoc.egg-info/dependency_links.txt
remote: writing top-level names to pdfdoc.egg-info/top_level.txt
remote: writing manifest file 'pdfdoc.egg-info/SOURCES.txt'
remote: reading manifest file 'pdfdoc.egg-info/SOURCES.txt'
remote: writing manifest file 'pdfdoc.egg-info/SOURCES.txt'
remote: running build_ext
remote: Creating /var/lib/openshift/00112233445566778899aabb/app-root/runtime/dependencies/python/virtenv/venv/lib/python3.3/site-packages/pdfdoc.egg-link (link to .)
remote: pdfdoc 0.0.1 is already the active version in easy-install.pth
remote: 
remote: Installed /var/lib/openshift/00112233445566778899aabb/app-root/runtime/repo
remote: Processing dependencies for pdfdoc==0.0.1
remote: Finished processing dependencies for pdfdoc==0.0.1
remote: Preparing build for deployment
remote: Deployment id is 9c2ee03c
remote: Activating deployment
remote: Starting Python 3.3 cartridge (Apache+mod_wsgi)
remote: Application directory "/" selected as DocumentRoot
remote: Application "wsgi.py" selected as default WSGI entry point
remote: -------------------------
remote: Git Post-Receive Result: success
remote: Activation status: success
remote: Deployment completed with status: success
To ssh://00112233445566778899aabb@awesomesauce-purpleidea.rhcloud.com/~/git/awesomesauce.git/
   5ac5577..bdf9601  master -> master
$
```
<span style="text-decoration:underline;">Final thoughts</span>:

I hope this helped you getting going with Openshift. Feel free to send me patches!

Happy hacking!

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
