+++
date = "2015-08-11 13:25:58"
title = "Making an empty RPM"
draft = "false"
categories = ["technical"]
tags = ["copr", "cpio", "devops", "fedora", "fpm", "freeipa", "gluster", "kickstart", "makefile", "planetdevops", "planetfedora", "planetfreeipa", "planetipa", "planetpuppet", "puppet", "rpm", "rpmbuild", "spec", "srpm", "vagrant"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/08/11/making-an-empty-rpm/"
+++

I am definitely not an RPM expert, in fact, I'm afraid of it, but with recent tools such as <a href="https://copr.fedoraproject.org/coprs/purpleidea/oh-my-vagrant/">COPR</a>, and <a href="/blog/2014/01/20/building-base-images-for-vagrant-with-a-makefile/">my glorious Makefile</a>, some aspects of it have become palatable. This post will be about a recent journey I had building the most useless RPM ever.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="cat-typing.gif"><img class="size-full wp-image-1128" src="cat-typing.gif" alt="A video of what my work building this RPM looked like." width="100%" height="100%" /></a></td></tr><tr><td> A video of my journey building this RPM.</td></tr></table></br />

Because of reasons, I wanted to satisfy an RPM dependency for a package that I wanted to install without rebuilding that RPM. As a result, I wanted to build as small an RPM as possible. This took me down a much longer path than I thought it would.

<span style="text-decoration:underline;">Step 1: The empty spec file</span>

I thought this would be easy. It turns out it was not. Here's what happened...
```
james@computer:/tmp/rpmbuild$ cat vagrant-libvirt.spec
%global project_version 0.0.24

Name:       vagrant-libvirt
Version:    0.0.24
Release:    noop
Summary:    A fake vagrant-libvirt RPM
License:    AGPLv3+
BuildArch:  noarch

Requires:   vagrant >= 1.6.5

%description
A fake vagrant-libvirt RPM

%prep
%setup -c -q -T -D -a 0

%build

%install

%files

%changelog
james@computer:/tmp/rpmbuild$ rpmbuild -bs vagrant-libvirt.spec 
error: No "Source:" tag in the spec file
```
Amazingly, <code>rpmbuild</code> fails to build without specifying a Source0 directive. Gah... As an aside, yes the License field was also required, or it won't build either! So let's create a dummy RPM to use as the source!

<span style="text-decoration:underline;">Step 2: The empty tarball</span>
```
james@computer:/tmp/rpmbuild$ tar -cjf vagrant-libvirt-noop.tar.bz2
tar: Cowardly refusing to create an empty archive
Try 'tar --help' or 'tar --usage' for more information.
```
Apparently <code>tar</code> doesn't want to cooperate either! Maybe these utilities have some sort of ingrained existential fear of nothingness? I can work around this though.

<span style="text-decoration:underline;">Step 3: The empty file</span>
```
james@computer:/tmp/rpmbuild$ echo hello > README
james@computer:/tmp/rpmbuild$ tar -cjf vagrant-libvirt-noop.tar.bz2 README
james@computer:/tmp/rpmbuild$ echo $?
0
james@computer:/tmp/rpmbuild$ cat vagrant-libvirt.spec
%global project_version 0.0.24

Name:       vagrant-libvirt
Version:    0.0.24
Release:    noop
Summary:    A fake vagrant-libvirt RPM
License:    AGPLv3+
Source0:    vagrant-libvirt-noop.tar.bz2
BuildArch:  noarch

Requires:   vagrant >= 1.6.5

%description
A fake vagrant-libvirt RPM

%prep
%setup -c -q -T -D -a 0

%build

%install

%files

%changelog
```
Okay great! Now to build the RPM...

<span style="text-decoration:underline;">Step 4: The empty RPM</span>
```
james@computer:/tmp/rpmbuild$ mkdir SOURCES
james@computer:/tmp/rpmbuild$ mv vagrant-libvirt-noop.tar.bz2 SOURCES/
james@computer:/tmp/rpmbuild$ rpmbuild --define "_topdir $(pwd)/" -bs vagrant-libvirt.spec
Wrote: /tmp/rpmbuild/SRPMS/vagrant-libvirt-0.0.24-noop.src.rpm
james@computer:/tmp/rpmbuild$ rpmbuild --define "_topdir $(pwd)/" -bb vagrant-libvirt.spec
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.dUivHv
+ umask 022
+ cd /tmp/rpmbuild//BUILD
+ cd /tmp/rpmbuild/BUILD
+ /usr/bin/mkdir -p vagrant-libvirt-0.0.24
+ cd vagrant-libvirt-0.0.24
+ /usr/bin/bzip2 -dc /tmp/rpmbuild/SOURCES/vagrant-libvirt-noop.tar.bz2
+ /usr/bin/tar -xf -
+ STATUS=0
+ '[' 0 -ne 0 ']'
+ /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.kLSHn2
+ umask 022
+ cd /tmp/rpmbuild//BUILD
+ cd vagrant-libvirt-0.0.24
+ exit 0
Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.xTiM4y
+ umask 022
+ cd /tmp/rpmbuild//BUILD
+ '[' /tmp/rpmbuild/BUILDROOT/vagrant-libvirt-0.0.24-noop.x86_64 '!=' / ']'
+ rm -rf /tmp/rpmbuild/BUILDROOT/vagrant-libvirt-0.0.24-noop.x86_64
++ dirname /tmp/rpmbuild/BUILDROOT/vagrant-libvirt-0.0.24-noop.x86_64
+ mkdir -p /tmp/rpmbuild/BUILDROOT
+ mkdir /tmp/rpmbuild/BUILDROOT/vagrant-libvirt-0.0.24-noop.x86_64
+ cd vagrant-libvirt-0.0.24
+ /usr/lib/rpm/find-debuginfo.sh --strict-build-id -m --run-dwz --dwz-low-mem-die-limit 10000000 --dwz-max-die-limit 110000000 /tmp/rpmbuild//BUILD/vagrant-libvirt-0.0.24
/usr/lib/rpm/sepdebugcrcfix: Updated 0 CRC32s, 0 CRC32s did match.
+ /usr/lib/rpm/check-rpaths /usr/lib/rpm/check-buildroot
+ /usr/lib/rpm/brp-compress
+ /usr/lib/rpm/brp-strip-static-archive /usr/bin/strip
+ /usr/lib/rpm/brp-python-bytecompile /usr/bin/python 1
+ /usr/lib/rpm/brp-python-hardlink
+ /usr/lib/rpm/redhat/brp-java-repack-jars
Processing files: vagrant-libvirt-0.0.24-noop.noarch
Checking for unpackaged file(s): /usr/lib/rpm/check-files /tmp/rpmbuild/BUILDROOT/vagrant-libvirt-0.0.24-noop.x86_64
Wrote: /tmp/rpmbuild/RPMS/noarch/vagrant-libvirt-0.0.24-noop.noarch.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.0lR0a6
+ umask 022
+ cd /tmp/rpmbuild//BUILD
+ cd vagrant-libvirt-0.0.24
+ /usr/bin/rm -rf /tmp/rpmbuild/BUILDROOT/vagrant-libvirt-0.0.24-noop.x86_64
+ exit 0
james@computer:/tmp/rpmbuild$
```
This worked too! It has some interesting output though...
```
james@computer:/tmp/rpmbuild$ rpm -qlp RPMS/noarch/vagrant-libvirt-0.0.24-noop.noarch.rpm
(contains no files)
james@computer:/tmp/rpmbuild$ ls -lAh RPMS/noarch/vagrant-libvirt-0.0.24-noop.noarch.rpm
-rw-rw-r--. 1 james 5.5K Aug 11 11:53 RPMS/noarch/vagrant-libvirt-0.0.24-noop.noarch.rpm
james@computer:/tmp/rpmbuild$
```
As you can see this has created an empty RPM, but which is about 5k in size. While this worked, builds submitted in COPR don't generate any output. I suppose this is a bug in COPR, but in the meantime, I still wanted something working. I added some nonsense to the spec file to continue.

<span style="text-decoration:underline;">Step 5: The final product</span>
```
james@computer:/tmp/rpmbuild$ cat vagrant-libvirt.spec 
%global project_version 0.0.24

Name:       vagrant-libvirt
Version:    0.0.24
Release:    noop
Summary:    A fake vagrant-libvirt RPM
License:    AGPLv3+
Source0:    vagrant-libvirt-noop.tar.bz2
BuildArch:  noarch

Requires:   vagrant >= 1.6.5

%description
A fake vagrant-libvirt RPM

%prep
%setup -c -q -T -D -a 0

%build

%install
rm -rf %{buildroot}
# _datadir is typically /usr/share/
install -d -m 0755 %{buildroot}/%{_datadir}/vagrant-libvirt/
echo "This is a phony vagrant-libvirt package." > %{buildroot}/%{_datadir}/vagrant-libvirt/README

%files
%{_datadir}/vagrant-libvirt/README

%changelog
```
After running the usual build commands, and sticking an SRPM up <a href="https://copr.fedoraproject.org/coprs/purpleidea/vagrant-libvirt/">in COPR, this builds</a> and installs as expected! Phew! There might a manual way to do this with cpio, but I wanted to use the official tools, and avoid hacking the spec.

Perhaps there is a simpler way to workaround all of this, but until I find it, I hope you've enjoyed my story,

Happy Hacking!

James

<strong>UPDATE:</strong> Reader <a href="https://twitter.com/beddari/status/631174766171410432">Jan pointed out</a>, that you could use <a href="https://github.com/jordansissel/fpm/">fpm</a> to accomplish the same thing with a one-liner. The modified one-liner is:
```
fpm -s empty -t rpm -d 'vagrant >= 1.6.5' -n vagrant-libvirt -v 0.0.24 --iteration noop
```
This is a much shorter and more elegant solution, with the one exception that fpm doesn't currently produce SRPMS, which are needed so that a trusted build service like COPR distributes them to the users.

Here's the full output and comparison and anyways:
```
james@computer:/tmp/ftest$ fpm -s empty -t rpm -d 'vagrant >= 1.6.5' -n vagrant-libvirt -v 0.0.24 --iteration noop
no value for epoch is set, defaulting to nil {:level=>:warn}
no value for epoch is set, defaulting to nil {:level=>:warn}
Created package {:path=>"vagrant-libvirt-0.0.24-noop.x86_64.rpm"}
james@computer:/tmp/ftest$ sha1sum vagrant-libvirt-0.0.24-noop.x86_64.rpm 61b1c200d2efa87d790a2243ccbc4c4ebb7ef64d  vagrant-libvirt-0.0.24-noop.x86_64.rpm
james@computer:/tmp/ftest$ sha1sum ~/code/oh-my-vagrant/extras/.rpmbuild/RPMS/noarch/vagrant-libvirt-0.0.24-noop.noarch.rpm 
5f2abb15264de6c1c7f09039945cd7bbd3a96404  /home/james/code/oh-my-vagrant/extras/.rpmbuild/RPMS/noarch/vagrant-libvirt-0.0.24-noop.noarch.rpm
```
While the two sha1sums aren't identical (probably due to timestamps or some other variant) the two RPM's should be functionally identical.

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
