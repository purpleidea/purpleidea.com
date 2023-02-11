+++
date = "2015-07-23 20:32:27"
title = "Git archive with submodules and tar magic"
draft = "false"
categories = ["technical"]
tags = ["bash", "copr", "fedora", "git", "git submodules", "git-archive", "gluster", "make", "makefile", "oh-my-vagrant", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster", "rpm", "tar", "tar --concatenate", "xkcd"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/07/23/git-archive-with-submodules-and-tar-magic/"
+++

<a href="https://git-scm.com/book/en/v2/Git-Tools-Submodules">Git submodules</a> are actually a very beautiful thing. You might prefer the word powerful or elegant, but that's not the point. The downside is that they are sometimes misused, so as always, use with care. I've used them in projects like <a href="https://github.com/purpleidea/puppet-gluster">puppet-gluster</a>, <a href="https://github.com/purpleidea/oh-my-vagrant">oh-my-vagrant</a>, and others. If you're not familiar with them, do a bit of reading and come back later, I'll wait.

I recently did some work <a href="/blog/2015/07/08/oh-my-vagrant-mainstream-mode-and-copr-rpms/">packaging Oh-My-Vagrant as RPM's</a>. My primary goal was to make sure the entire process was automatic, as I have no patience for manually building RPM's. Any good packager knows that the pre-requisite for building a SRPM is a source tarball, and I wanted to build those automatically too.

Simply running a <code>tar -cf</code> on my source directory wouldn't work, because I only want to include files that are stored in git. Thankfully, git comes with a tool called <code>git archive</code>, which does exactly that! No scary tar commands required:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="https://xkcd.com/1168/" target="_blank"><img class="" src="https://imgs.xkcd.com/comics/tar.png" alt="" width="100%" height="100%" /></a></td></tr><tr><td> Nobody likes tar</td></tr></table></br />

Here's how you might run it:
```
$ git archive --prefix=some-project/ -o output.tar.bz2 HEAD
```
Let's decompose:

The <code>--prefix</code> argument prepends a string prefix onto every file in the archive. Therefore, if you'd like the root directory to be named <code>some-project</code>, then you prepend that string with a trailing slash, and you'll have everything nested inside a directory!

The <code>-o</code> flag predictably picks the output file and format. Using <code>.tar.bz2</code> is quite common.

Lastly, the <code>HEAD</code> portion at the end specifies which git tree to pull the files from. I usually specify a git tag here, but you can specify a commit id if you prefer.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="idontalwaystarball.png"><img class="wp-image-1105 size-full" src="idontalwaystarball.png" alt="Obligatory, "make this article more interesting" meme image." width="100%" height="100%" /></a></td></tr><tr><td> Obligatory, "make this article more interesting" meme image.</td></tr></table></br />

This is all well and good, but unfortunately, when I open my newly created archive, it is notably missing my git submodules! It would probably make sense for there to be an upstream option so that a <code>--recursive</code> flag would do this magic for you, but unfortunately it doesn't exist yet.

There are a few scripts floating around that can do this, but I wanted something small, and without any real dependencies, that I can embed in my project <code>Makefile</code>, so that it's all self-contained.

Here's what that looks like:

{{< highlight bash >}}

sometarget:
    @echo Running git archive...
    # use HEAD if tag doesn't exist yet, so that development is easier...
    git archive --prefix=oh-my-vagrant-$(VERSION)/ -o $(SOURCE) $(VERSION) 2> /dev/null || (echo 'Warning: $(VERSION) does not exist.' && git archive --prefix=oh-my-vagrant-$(VERSION)/ -o $(SOURCE) HEAD)
    # TODO: if git archive had a --submodules flag this would easier!
    @echo Running git archive submodules...
    # i thought i would need --ignore-zeros, but it doesn't seem necessary!
    p=`pwd` && (echo .; git submodule foreach) | while read entering path; do \
        temp="$${path%\'}"; \
        temp="$${temp#\'}"; \
        path=$$temp; \
        [ "$$path" = "" ] && continue; \
        (cd $$path && git archive --prefix=oh-my-vagrant-$(VERSION)/$$path/ HEAD > $$p/rpmbuild/tmp.tar && tar --concatenate --file=$$p/$(SOURCE) $$p/rpmbuild/tmp.tar && rm $$p/rpmbuild/tmp.tar); \
    done
{{< /highlight >}}
This is a bit tricky to read, so I'll try to break it down. Remember, double dollar signs are used in <code>Make</code> syntax for embedded bash code since a single dollar sign is a special <code>Make</code> identifier. The <code>$(VERSION)</code> variable corresponds to the version of the project I'm building, which matches a git tag that I've previously created. <code>$(SOURCE)</code> corresponds to an output file name, ending in the <code>.tar.bz2</code> suffix.
```
    p=`pwd` && (echo .; git submodule foreach) | while read entering path; do \
```
In this first line, we store the current working directory for use later, and then loop through the output of the <code>git submodule foreach</code> command. That output normally looks something like this:
```
james@computer:~/code/oh-my-vagrant$ git submodule foreach 
Entering 'vagrant/gems/xdg'
Entering 'vagrant/kubernetes/templates/default'
Entering 'vagrant/p4h'
Entering 'vagrant/puppet/modules/module-data'
Entering 'vagrant/puppet/modules/puppet'
Entering 'vagrant/puppet/modules/stdlib'
Entering 'vagrant/puppet/modules/yum'
```
As you can see, this shows that the above <code>read</code> command, eats up the <em>Entering</em> string, and pulls the quoted path into the second <em>path</em> variable. The next part of the code:
```
        temp="$${path%\'}"; \
        temp="$${temp#\'}"; \
        path=$$temp; \
        [ "$$path" = "" ] && continue; \
```
uses bash idioms to remove the two single quotes that wrap our string, and then skip over any empty versions of the path variable in our loop. Lastly, for each submodule found, we first switch into that directory:
```
        (cd $$path &&
```
Run a normal <code>git archive</code> command and create a plain uncompressed tar archive in a temporary directory:
```
git archive --prefix=oh-my-vagrant-$(VERSION)/$$path/ HEAD > $$p/rpmbuild/tmp.tar &&
```
Then use the magic of tar to overlay this new tar file, on top of the source file that we're now building up with each iteration of this loop, and then remove the temporary file.
```
tar --concatenate --file=$$p/$(SOURCE) $$p/rpmbuild/tmp.tar && rm $$p/rpmbuild/tmp.tar); \
```
Finally, we end the loop:
```
    done
```
Boom, magic! Short, concise, and without any dependencies but <code>bash</code> and <code>git</code>.

Nobody should have to figure that out by themselves, and I wish it was built in to git, but until then, here's how it's done! Many thanks to <code>#git</code> on IRC for pointing me in the right direction.

<a href="https://github.com/purpleidea/oh-my-vagrant/commit/8ee3fdab7451bb30b56e42c4586e4304b5805faf#diff-b67911656ef5d18c4ae36cb6741b7965R89" target="_blank">This is the commit</a> where I landed this patch for oh-my-vagrant, if you're curious to see this in the wild. Now that this is done, I can definitely say that it was worth the time:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="https://xkcd.com/1205/" target="_blank"><img src="https://imgs.xkcd.com/comics/is_it_worth_the_time.png" alt="" width="100%" height="100%" /></a></td></tr><tr><td> Is it worth the time? In this case, it was.</td></tr></table></br />

With this feature merged, along with my <a href="/blog/2015/07/08/oh-my-vagrant-mainstream-mode-and-copr-rpms/" target="_blank">automatic COPR</a> builds, a simple '<code>make rpm</code>', causes all of this automation to happen, and delivers a fresh build from git in a few minutes.

I hope you enjoyed this technique, and I hope you have some coding skills to get this feature upstream in git.

Happy Hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
