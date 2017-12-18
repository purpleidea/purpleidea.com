+++
date = "2015-06-12 18:06:55"
title = "A super privileged Puppet container"
draft = "false"
categories = ["technical"]
tags = ["atomic", "devops", "dnf", "docker", "facter", "fedora", "oh-my-vagrant", "omv", "planetdevops", "planetfedora", "planetpuppet", "puppet", "spc", "spc-puppet-apply", "vagrant", "vscreen", "yum"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/06/12/a-super-privileged-puppet-container/"
+++

In this new crazy world of <a href="https://en.wikipedia.org/wiki/Docker_%28software%29">containers</a> and immutable hosts, one might still want to run previous generation software such as <a href="https://duckduckgo.com/l/?kh=-1&uddg=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FPuppet_(software)">Puppet</a> on a current generation <a href="https://www.projectatomic.io/">Atomic host</a>. This article will explain how you can do that, and offer some <a href="https://github.com/purpleidea/spc-puppet-apply">proof of concept code</a>.

The atomic host doesn't provide a <a href="https://en.wikipedia.org/wiki/Yellowdog_Updater,_Modified">yum</a> or <a href="https://fedoraproject.org/wiki/Dnf">dnf</a> command, because the software is pre-baked into a read-only <code>/usr/</code> partition. To "<em>install</em>" (to use) additional software, it usually needs to be distributed and run as a container.

The <code>Dockerfile</code> which describes the docker container that we will build, has two important sections:
```
ENV FACTER_fqdn=localhost
ENTRYPOINT ["puppet", "apply"]
```
The <a href="https://docs.docker.com/reference/builder/#entrypoint"><code>ENTRYPOINT</code></a> verb causes docker to run the puppet command that we built into the container, when the container is run with externally provided arguments. The <a href="https://docs.docker.com/reference/builder/#env"><code>ENV</code></a> verb causes some <em>facter</em> errors to be suppressed, since <em>facter</em> isn't running on the host. The <a href="https://github.com/purpleidea/spc-puppet-apply/blob/master/Dockerfile">rest of the file</a> contains boilerplate and other build/run dependencies.

You can build this container yourself manually, or if you are an <a href="https://github.com/purpleidea/oh-my-vagrant">Oh-My-Vagrant</a> user, then you can use the supplied <a href="https://github.com/purpleidea/spc-puppet-apply/blob/master/omv.yaml">omv.yaml</a> file to build the container automatically. A build with Oh-My-Vagrant looks like this:
```
$ time vup omv1
Bringing machine 'omv1' up with 'libvirt' provider...
==> omv1: Creating image (snapshot of base box volume).
==> omv1: Creating domain with the following settings...
==> omv1:  -- Name:              omv_omv1
==> omv1:  -- Domain type:       kvm
==> omv1:  -- Cpus:              1
==> omv1:  -- Memory:            512M
==> omv1:  -- Base box:          centos-7.1-docker
==> omv1:  -- Storage pool:      default
==> omv1:  -- Image:             /var/lib/libvirt/images/omv_omv1.img
==> omv1:  -- Volume Cache:      default
==> omv1:  -- Kernel:            
==> omv1:  -- Initrd:            
==> omv1:  -- Graphics Type:     vnc
==> omv1:  -- Graphics Port:     5900
==> omv1:  -- Graphics IP:       127.0.0.1
==> omv1:  -- Graphics Password: Not defined
==> omv1:  -- Video Type:        cirrus
==> omv1:  -- Video VRAM:        9216
==> omv1:  -- Keymap:            en-us
==> omv1:  -- Command line : 
==> omv1: Starting domain.
==> omv1: Waiting for domain to get an IP address...
==> omv1: Waiting for SSH to become available...
==> omv1: Starting domain.
==> omv1: Waiting for domain to get an IP address...
==> omv1: Waiting for SSH to become available...
==> omv1: Creating shared folders metadata...
==> omv1: Setting hostname...
==> omv1: Rsyncing folder: /home/james/code/oh-my-vagrant/vagrant/ => /vagrant
==> omv1: Configuring and enabling network interfaces...
==> omv1: Updating /etc/hosts file on active guest machines...
==> omv1: Running provisioner: shell...
    omv1: Running: inline script
==> omv1: Running provisioner: shell...
    omv1: Running: inline script
==> omv1: Running provisioner: docker...
    omv1: Configuring Docker to autostart containers...
==> omv1: Running provisioner: docker...
    omv1: Configuring Docker to autostart containers...
==> omv1: Building Docker images...
==> omv1: -- Path: /vagrant/docker/spc-puppet-apply
==> omv1: Sending build context to Docker daemon 122.9 kB
==> omv1: Sending build context to Docker daemon 
==> omv1: Step 0 : FROM centos:7
==> omv1:  ---> 0114405f9ff1
==> omv1: Step 1 : MAINTAINER James Shubin <james@shubin.ca>
==> omv1:  ---> Running in 2dbdc37494e9
==> omv1:  ---> e154b3cfed7f
==> omv1: Removing intermediate container 2dbdc37494e9
==> omv1: Step 2 : RUN echo Hello from purpleidea and aweiteka > README
==> omv1:  ---> Running in 97475154152f
==> omv1:  ---> e4728d71caac
==> omv1: Removing intermediate container 97475154152f
==> omv1: Step 3 : ADD el7-puppet.repo /etc/yum.repos.d/
==> omv1:  ---> c591e0a9a54d
==> omv1: Removing intermediate container 24e55893313c
==> omv1: Step 4 : ADD RPM-GPG-KEY-puppetlabs /etc/pki/rpm-gpg/
==> omv1:  ---> 223549fbf661
==> omv1: Removing intermediate container 2bceb998f1c3
==> omv1: Step 5 : RUN yum install -y puppet
==> omv1:  ---> Running in e44c9cf55dc5
==> omv1: Loaded plugins: fastestmirror
==> omv1: Determining fastest mirrors
==> omv1:  * base: centos.mirror.vexxhost.com
==> omv1:  * extras: mirror.gpmidi.net
==> omv1:  * updates: centos.mirror.vexxhost.com
==> omv1: Resolving Dependencies
==> omv1: --> Running transaction check
==> omv1: ---> Package puppet.noarch 0:3.7.5-1.el7 will be installed
==> omv1: --> Processing Dependency: ruby >= 1.8 for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: facter >= 1:1.7.0 for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: ruby >= 1.8.7 for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: hiera >= 1.0.0 for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: rubygem-json for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: libselinux-utils for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: ruby-augeas for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: ruby(selinux) for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: /usr/bin/ruby for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Processing Dependency: ruby-shadow for package: puppet-3.7.5-1.el7.noarch
==> omv1: --> Running transaction check
==> omv1: ---> Package facter.x86_64 1:2.4.3-1.el7 will be installed
==> omv1: --> Processing Dependency: net-tools for package: 1:facter-2.4.3-1.el7.x86_64
==> omv1: --> Processing Dependency: virt-what for package: 1:facter-2.4.3-1.el7.x86_64
==> omv1: --> Processing Dependency: pciutils for package: 1:facter-2.4.3-1.el7.x86_64
==> omv1: --> Processing Dependency: dmidecode for package: 1:facter-2.4.3-1.el7.x86_64
==> omv1: ---> Package hiera.noarch 0:1.3.4-1.el7 will be installed
==> omv1: ---> Package libselinux-ruby.x86_64 0:2.2.2-6.el7 will be installed
==> omv1: ---> Package libselinux-utils.x86_64 0:2.2.2-6.el7 will be installed
==> omv1: ---> Package ruby.x86_64 0:2.0.0.598-24.el7 will be installed
==> omv1: --> Processing Dependency: ruby-libs(x86-64) = 2.0.0.598-24.el7 for package: ruby-2.0.0.598-24.el7.x86_64
==> omv1: --> Processing Dependency: rubygem(bigdecimal) >= 1.2.0 for package: ruby-2.0.0.598-24.el7.x86_64
==> omv1: --> Processing Dependency: ruby(rubygems) >= 2.0.14 for package: ruby-2.0.0.598-24.el7.x86_64
==> omv1: --> Processing Dependency: libruby.so.2.0()(64bit) for package: ruby-2.0.0.598-24.el7.x86_64
==> omv1: ---> Package ruby-augeas.x86_64 0:0.4.1-3.el7 will be installed
==> omv1: --> Processing Dependency: augeas-libs >= 0.8.0 for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.8.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.1.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.12.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.10.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: --> Processing Dependency: libaugeas.so.0(AUGEAS_0.11.0)(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: --> Processing Dependency: libaugeas.so.0()(64bit) for package: ruby-augeas-0.4.1-3.el7.x86_64
==> omv1: ---> Package ruby-shadow.x86_64 1:2.2.0-2.el7 will be installed
==> omv1: ---> Package rubygem-json.x86_64 0:1.7.7-24.el7 will be installed
==> omv1: --> Running transaction check
==> omv1: ---> Package augeas-libs.x86_64 0:1.1.0-17.el7 will be installed
==> omv1: ---> Package dmidecode.x86_64 1:2.12-5.el7 will be installed
==> omv1: ---> Package net-tools.x86_64 0:2.0-0.17.20131004git.el7 will be installed
==> omv1: ---> Package pciutils.x86_64 0:3.2.1-4.el7 will be installed
==> omv1: --> Processing Dependency: pciutils-libs = 3.2.1-4.el7 for package: pciutils-3.2.1-4.el7.x86_64
==> omv1: --> Processing Dependency: libpci.so.3(LIBPCI_3.2)(64bit) for package: pciutils-3.2.1-4.el7.x86_64
==> omv1: --> Processing Dependency: libpci.so.3(LIBPCI_3.1)(64bit) for package: pciutils-3.2.1-4.el7.x86_64
==> omv1: --> Processing Dependency: libpci.so.3(LIBPCI_3.0)(64bit) for package: pciutils-3.2.1-4.el7.x86_64
==> omv1: --> Processing Dependency: hwdata for package: pciutils-3.2.1-4.el7.x86_64
==> omv1: --> Processing Dependency: libpci.so.3()(64bit) for package: pciutils-3.2.1-4.el7.x86_64
==> omv1: ---> Package ruby-libs.x86_64 0:2.0.0.598-24.el7 will be installed
==> omv1: ---> Package rubygem-bigdecimal.x86_64 0:1.2.0-24.el7 will be installed
==> omv1: ---> Package rubygems.noarch 0:2.0.14-24.el7 will be installed
==> omv1: --> Processing Dependency: rubygem(rdoc) >= 4.0.0 for package: rubygems-2.0.14-24.el7.noarch
==> omv1: --> Processing Dependency: rubygem(psych) >= 2.0.0 for package: rubygems-2.0.14-24.el7.noarch
==> omv1: --> Processing Dependency: rubygem(io-console) >= 0.4.2 for package: rubygems-2.0.14-24.el7.noarch
==> omv1: ---> Package virt-what.x86_64 0:1.13-5.el7 will be installed
==> omv1: --> Running transaction check
==> omv1: ---> Package hwdata.noarch 0:0.252-7.5.el7 will be installed
==> omv1: ---> Package pciutils-libs.x86_64 0:3.2.1-4.el7 will be installed
==> omv1: ---> Package rubygem-io-console.x86_64 0:0.4.2-24.el7 will be installed
==> omv1: ---> Package rubygem-psych.x86_64 0:2.0.0-24.el7 will be installed
==> omv1: --> Processing Dependency: libyaml-0.so.2()(64bit) for package: rubygem-psych-2.0.0-24.el7.x86_64
==> omv1: ---> Package rubygem-rdoc.noarch 0:4.0.0-24.el7 will be installed
==> omv1: --> Processing Dependency: ruby(irb) = 2.0.0.598 for package: rubygem-rdoc-4.0.0-24.el7.noarch
==> omv1: --> Running transaction check
==> omv1: ---> Package libyaml.x86_64 0:0.1.4-11.el7_0 will be installed
==> omv1: ---> Package ruby-irb.noarch 0:2.0.0.598-24.el7 will be installed
==> omv1: --> Finished Dependency Resolution
==> omv1: 
==> omv1: Dependencies Resolved
==> omv1: 
==> omv1: ================================================================================
==> omv1:  Package            Arch   Version                    Repository           Size
==> omv1: ================================================================================
==> omv1: Installing:
==> omv1:  puppet             noarch 3.7.5-1.el7                puppetlabs-products 1.5 M
==> omv1: Installing for dependencies:
==> omv1:  augeas-libs        x86_64 1.1.0-17.el7               base                332 k
==> omv1:  dmidecode          x86_64 1:2.12-5.el7               base                 78 k
==> omv1:  facter             x86_64 1:2.4.3-1.el7              puppetlabs-products  98 k
==> omv1:  hiera              noarch 1.3.4-1.el7                puppetlabs-products  23 k
==> omv1:  hwdata             noarch 0.252-7.5.el7              base                2.0 M
==> omv1:  libselinux-ruby    x86_64 2.2.2-6.el7                base                127 k
==> omv1:  libselinux-utils   x86_64 2.2.2-6.el7                base                135 k
==> omv1:  libyaml            x86_64 0.1.4-11.el7_0             base                 55 k
==> omv1:  net-tools          x86_64 2.0-0.17.20131004git.el7   base                304 k
==> omv1:  pciutils           x86_64 3.2.1-4.el7                base                 90 k
==> omv1:  pciutils-libs      x86_64 3.2.1-4.el7                base                 45 k
==> omv1:  ruby               x86_64 2.0.0.598-24.el7           base                 67 k
==> omv1:  ruby-augeas        x86_64 0.4.1-3.el7                puppetlabs-deps      22 k
==> omv1:  ruby-irb           noarch 2.0.0.598-24.el7           base                 88 k
==> omv1:  ruby-libs          x86_64 2.0.0.598-24.el7           base                2.8 M
==> omv1:  ruby-shadow        x86_64 1:2.2.0-2.el7              puppetlabs-deps      14 k
==> omv1:  rubygem-bigdecimal x86_64 1.2.0-24.el7               base                 79 k
==> omv1:  rubygem-io-console x86_64 0.4.2-24.el7               base                 50 k
==> omv1:  rubygem-json       x86_64 1.7.7-24.el7               base                 75 k
==> omv1:  rubygem-psych      x86_64 2.0.0-24.el7               base                 77 k
==> omv1:  rubygem-rdoc       noarch 4.0.0-24.el7               base                318 k
==> omv1:  rubygems           noarch 2.0.14-24.el7              base                212 k
==> omv1:  virt-what          x86_64 1.13-5.el7                 base                 26 k
==> omv1: 
==> omv1: Transaction Summary
==> omv1: ================================================================================
==> omv1: Install  1 Package (+23 Dependent packages)
==> omv1: 
==> omv1: Total download size: 8.6 M
==> omv1: Installed size: 27 M
==> omv1: Downloading packages:
==> omv1: warning: /var/cache/yum/x86_64/7/puppetlabs-products/packages/hiera-1.3.4-1.el7.noarch.rpm: Header V4 RSA/SHA512 Signature, key ID 4bd6ec30: NOKEY
==> omv1: 
==> omv1: Public key for hiera-1.3.4-1.el7.noarch.rpm is not installed
==> omv1: warning: /var/cache/yum/x86_64/7/base/packages/dmidecode-2.12-5.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
==> omv1: 
==> omv1: Public key for dmidecode-2.12-5.el7.x86_64.rpm is not installed
==> omv1: Public key for ruby-augeas-0.4.1-3.el7.x86_64.rpm is not installed
==> omv1: --------------------------------------------------------------------------------
==> omv1: Total                                              811 kB/s | 8.6 MB  00:10     
==> omv1: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
==> omv1: Importing GPG key 0xF4A80EB5:
==> omv1:  Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
==> omv1:  Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
==> omv1:  Package    : centos-release-7-1.1503.el7.centos.2.8.x86_64 (@CentOS/$releasever)
==> omv1:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
==> omv1: 
==> omv1: Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
==> omv1: Importing GPG key 0x4BD6EC30:
==> omv1:  Userid     : "Puppet Labs Release Key (Puppet Labs Release Key) <info@puppetlabs.com>"
==> omv1:  Fingerprint: 47b3 20eb 4c7c 375a a9da e1a0 1054 b7a2 4bd6 ec30
==> omv1:  From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs
==> omv1: 
==> omv1: Running transaction check
==> omv1: Running transaction test
==> omv1: Transaction test succeeded
==> omv1: Running transaction
==> omv1:   Installing : ruby-libs-2.0.0.598-24.el7.x86_64                           1/24
==> omv1:  
==> omv1:   Installing : 1:dmidecode-2.12-5.el7.x86_64                               2/24
==> omv1:  
==> omv1:   Installing : virt-what-1.13-5.el7.x86_64                                 3/24
==> omv1:  
==> omv1:   Installing : libyaml-0.1.4-11.el7_0.x86_64                               4/24
==> omv1:  
==> omv1:   Installing : rubygem-psych-2.0.0-24.el7.x86_64                           5/24
==> omv1:  
==> omv1:   Installing : rubygem-bigdecimal-1.2.0-24.el7.x86_64                      6/24
==> omv1:  
==> omv1:   Installing : rubygem-io-console-0.4.2-24.el7.x86_64                      7/24
==> omv1:  
==> omv1:   Installing : ruby-irb-2.0.0.598-24.el7.noarch                            8/24
==> omv1:  
==> omv1:   Installing : ruby-2.0.0.598-24.el7.x86_64                                9/24
==> omv1:  
==> omv1:   Installing : rubygems-2.0.14-24.el7.noarch                              10/24
==> omv1:  
==> omv1:   Installing : rubygem-json-1.7.7-24.el7.x86_64                           11/24
==> omv1:  
==> omv1:   Installing : rubygem-rdoc-4.0.0-24.el7.noarch                           12/24
==> omv1:  
==> omv1:   Installing : hiera-1.3.4-1.el7.noarch                                   13/24
==> omv1:  
==> omv1:   Installing : 1:ruby-shadow-2.2.0-2.el7.x86_64                           14/24
==> omv1:  
==> omv1:   Installing : hwdata-0.252-7.5.el7.noarch                                15/24
==> omv1:  
==> omv1:   Installing : libselinux-utils-2.2.2-6.el7.x86_64                        16/24
==> omv1:  
==> omv1:   Installing : pciutils-libs-3.2.1-4.el7.x86_64                           17/24
==> omv1:  
==> omv1:   Installing : pciutils-3.2.1-4.el7.x86_64                                18/24
==> omv1:  
==> omv1:   Installing : augeas-libs-1.1.0-17.el7.x86_64                            19/24
==> omv1:  
==> omv1:   Installing : ruby-augeas-0.4.1-3.el7.x86_64                             20/24
==> omv1:  
==> omv1:   Installing : net-tools-2.0-0.17.20131004git.el7.x86_64                  21/24
==> omv1:  
==> omv1:   Installing : 1:facter-2.4.3-1.el7.x86_64                                22/24
==> omv1:  
==> omv1:   Installing : libselinux-ruby-2.2.2-6.el7.x86_64                         23/24
==> omv1:  
==> omv1:   Installing : puppet-3.7.5-1.el7.noarch                                  24/24
==> omv1:  
==> omv1:   Verifying  : libselinux-ruby-2.2.2-6.el7.x86_64                          1/24
==> omv1:  
==> omv1:   Verifying  : rubygem-json-1.7.7-24.el7.x86_64                            2/24
==> omv1:  
==> omv1:   Verifying  : ruby-irb-2.0.0.598-24.el7.noarch                            3/24
==> omv1:  
==> omv1:   Verifying  : ruby-libs-2.0.0.598-24.el7.x86_64                           4/24
==> omv1:  
==> omv1:   Verifying  : net-tools-2.0-0.17.20131004git.el7.x86_64                   5/24
==> omv1:  
==> omv1:   Verifying  : augeas-libs-1.1.0-17.el7.x86_64                             6/24
==> omv1:  
==> omv1:   Verifying  : pciutils-libs-3.2.1-4.el7.x86_64                            7/24
==> omv1:  
==> omv1:   Verifying  : rubygem-psych-2.0.0-24.el7.x86_64                           8/24
==> omv1:  
==> omv1:   Verifying  : 1:facter-2.4.3-1.el7.x86_64                                 9/24
==> omv1:  
==> omv1:   Verifying  : pciutils-3.2.1-4.el7.x86_64                                10/24
==> omv1:  
==> omv1:   Verifying  : puppet-3.7.5-1.el7.noarch                                  11/24
==> omv1:  
==> omv1:   Verifying  : hiera-1.3.4-1.el7.noarch                                   12/24
==> omv1:  
==> omv1:   Verifying  : rubygem-rdoc-4.0.0-24.el7.noarch                           13/24
==> omv1:  
==> omv1:   Verifying  : virt-what-1.13-5.el7.x86_64                                14/24
==> omv1:  
==> omv1:   Verifying  : rubygems-2.0.14-24.el7.noarch                              15/24
==> omv1:  
==> omv1:   Verifying  : libselinux-utils-2.2.2-6.el7.x86_64                        16/24
==> omv1:  
==> omv1:   Verifying  : 1:ruby-shadow-2.2.0-2.el7.x86_64                           17/24
==> omv1:  
==> omv1:   Verifying  : rubygem-bigdecimal-1.2.0-24.el7.x86_64                     18/24
==> omv1:  
==> omv1:   Verifying  : 1:dmidecode-2.12-5.el7.x86_64                              19/24
==> omv1:  
==> omv1:   Verifying  : hwdata-0.252-7.5.el7.noarch                                20/24
==> omv1:  
==> omv1:   Verifying  : libyaml-0.1.4-11.el7_0.x86_64                              21/24
==> omv1:  
==> omv1:   Verifying  : rubygem-io-console-0.4.2-24.el7.x86_64                     22/24
==> omv1:  
==> omv1:   Verifying  : ruby-augeas-0.4.1-3.el7.x86_64                             23/24
==> omv1:  
==> omv1:   Verifying  : ruby-2.0.0.598-24.el7.x86_64                               24/24
==> omv1:  
==> omv1: 
==> omv1: Installed:
==> omv1:   puppet.noarch 0:3.7.5-1.el7                                                   
==> omv1: 
==> omv1: Dependency Installed:
==> omv1:   augeas-libs.x86_64 0:1.1.0-17.el7                                             
==> omv1:   dmidecode.x86_64 1:2.12-5.el7                                                 
==> omv1:   facter.x86_64 1:2.4.3-1.el7                                                   
==> omv1:   hiera.noarch 0:1.3.4-1.el7                                                    
==> omv1:   hwdata.noarch 0:0.252-7.5.el7                                                 
==> omv1:   libselinux-ruby.x86_64 0:2.2.2-6.el7                                          
==> omv1:   libselinux-utils.x86_64 0:2.2.2-6.el7                                         
==> omv1:   libyaml.x86_64 0:0.1.4-11.el7_0                                               
==> omv1:   net-tools.x86_64 0:2.0-0.17.20131004git.el7                                   
==> omv1:   pciutils.x86_64 0:3.2.1-4.el7                                                 
==> omv1:   pciutils-libs.x86_64 0:3.2.1-4.el7                                            
==> omv1:   ruby.x86_64 0:2.0.0.598-24.el7                                                
==> omv1:   ruby-augeas.x86_64 0:0.4.1-3.el7                                              
==> omv1:   ruby-irb.noarch 0:2.0.0.598-24.el7                                            
==> omv1:   ruby-libs.x86_64 0:2.0.0.598-24.el7                                           
==> omv1:   ruby-shadow.x86_64 1:2.2.0-2.el7                                              
==> omv1:   rubygem-bigdecimal.x86_64 0:1.2.0-24.el7                                      
==> omv1:   rubygem-io-console.x86_64 0:0.4.2-24.el7                                      
==> omv1:   rubygem-json.x86_64 0:1.7.7-24.el7                                            
==> omv1:   rubygem-psych.x86_64 0:2.0.0-24.el7                                           
==> omv1:   rubygem-rdoc.noarch 0:4.0.0-24.el7                                            
==> omv1:   rubygems.noarch 0:2.0.14-24.el7                                               
==> omv1:   virt-what.x86_64 0:1.13-5.el7                                                 
==> omv1: Complete!
==> omv1:  ---> bf169104271a
==> omv1: Removing intermediate container e44c9cf55dc5
==> omv1: Step 6 : RUN yum install -y hostname
==> omv1:  ---> Running in 6e5bd5a59223
==> omv1: Loaded plugins: fastestmirror
==> omv1: Loading mirror speeds from cached hostfile
==> omv1:  * base: centos.mirror.vexxhost.com
==> omv1:  * extras: mirror.gpmidi.net
==> omv1:  * updates: centos.mirror.vexxhost.com
==> omv1: Resolving Dependencies
==> omv1: --> Running transaction check
==> omv1: ---> Package hostname.x86_64 0:3.13-3.el7 will be installed
==> omv1: --> Finished Dependency Resolution
==> omv1: 
==> omv1: Dependencies Resolved
==> omv1: 
==> omv1: ================================================================================
==> omv1:  Package            Arch             Version               Repository      Size
==> omv1: ================================================================================
==> omv1: Installing:
==> omv1:  hostname           x86_64           3.13-3.el7            base            17 k
==> omv1: 
==> omv1: Transaction Summary
==> omv1: ================================================================================
==> omv1: Install  1 Package
==> omv1: 
==> omv1: Total download size: 17 k
==> omv1: Installed size: 19 k
==> omv1: Downloading packages:
==> omv1: Running transaction check
==> omv1: Running transaction test
==> omv1: Transaction test succeeded
==> omv1: Running transaction
==> omv1:   Installing : hostname-3.13-3.el7.x86_64                                   1/1
==> omv1:  
==> omv1:   Verifying  : hostname-3.13-3.el7.x86_64                                   1/1
==> omv1:  
==> omv1: 
==> omv1: Installed:
==> omv1:   hostname.x86_64 0:3.13-3.el7                                                  
==> omv1: 
==> omv1: Complete!
==> omv1:  ---> 2a20361f2d9d
==> omv1: Removing intermediate container 6e5bd5a59223
==> omv1: Step 7 : ADD run.sh /
==> omv1:  ---> 5493e62ac377
==> omv1: Removing intermediate container 84c8b7677f72
==> omv1: Step 8 : ADD test.pp /
==> omv1:  ---> 4f4d0023e612
==> omv1: Removing intermediate container 84cb691304a3
==> omv1: Step 9 : ENV FACTER_fqdn localhost
==> omv1:  ---> Running in 104fe3925dd6
==> omv1:  ---> 864c113d54b5
==> omv1: Removing intermediate container 104fe3925dd6
==> omv1: Step 10 : ENTRYPOINT puppet apply
==> omv1:  ---> Running in f6fe26141b19
==> omv1:  ---> cd19e4344bf1
==> omv1: Removing intermediate container f6fe26141b19
==> omv1: Step 11 : USER root
==> omv1:  ---> Running in 435752b9fb17
==> omv1:  ---> 86193e9815a8
==> omv1: Removing intermediate container 435752b9fb17
==> omv1: Step 12 : LABEL INSTALL docker run --rm -it --privileged -v /etc:/etc -v /var:/var -v /run:/run --net=host IMAGE
==> omv1:  ---> Running in d24f98a56936
==> omv1:  ---> 72f2dfbc4e07
==> omv1: Removing intermediate container d24f98a56936
==> omv1: Successfully built 72f2dfbc4e07

real    2m46.515s
user    0m10.036s
sys    0m1.678s
```
Once you've built the container, you should confirm its existence:
```
$ vscreen root@omv1
# docker images | grep spc
spc-puppet-apply    latest              72f2dfbc4e07        7 minutes ago       314.5 MB
```
The project repository tries to make your life easier, so it comes with a <code>test.pp</code> file that you can run to confirm puppet is working correctly. If you are using a regular host (not Atomic) you can run:
```
# mkdir /var/tmp/spc-puppet-apply/
# cp -a /vagrant/docker/spc-puppet-apply/test.pp /var/tmp/spc-puppet-apply/
```
or if you're using an Atomic host, you can run:
```
# mkdir /var/tmp/spc-puppet-apply/
# cp -a /home/vagrant/sync/docker/spc-puppet-apply/test.pp /var/tmp/spc-puppet-apply/
```
since Oh-My-Vagrant can't put files in <code>/vagrant</code> on an immutable Atomic host.

Finally, run the application with this monster docker command:
```
# docker run --rm -it --privileged -v /etc:/etc -v /var:/var -v /run:/run --net=host spc-puppet-apply /var/tmp/spc-puppet-apply/test.pp
Notice: Compiled catalog for omv1.example.com in environment production in 0.02 seconds
Notice: This is a puppet test!

Notice: /Stage[main]/Main/Notify[hello]/message: defined 'message' as 'This is a puppet test!'
Notice: Finished catalog run in 0.06 seconds
```
Since remembering that monster each time you want to do a simple puppet run is a bit of a monster, the Atomic project provides labels which make it so you can use the <code>atomic run</code> command instead.

<span style="text-decoration:underline;">Future work</span>:

Interested parties are encouraged to test this, find any issues, and become comfortable with the idea of applications running from within containers. If running puppet with a puppet master is desirable, an <code>spc-puppet-agent</code> would be needed.

Happy Hacking,

James

