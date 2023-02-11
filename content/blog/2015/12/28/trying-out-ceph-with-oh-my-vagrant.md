+++
date = "2015-12-28 14:59:23"
title = "Trying out Ceph with Oh-My-Vagrant"
draft = "false"
categories = ["technical"]
tags = ["bash", "ceph", "ceph-deploy", "devops", "fedora", "fedora 23", "hack", "oh-my-vagrant", "planetdevops", "planetfedora", "planetpuppet", "rbd", "vagrant"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2015/12/28/trying-out-ceph-with-oh-my-vagrant/"
+++

<a href="https://www.berrange.com/posts/2015/12/21/ceph-single-node-deployment-on-fedora-23/">Daniel P. Berrangé wrote about trying out a single node ceph cluster.</a> I decided to take his article and turn it into an Oh-My-Vagrant <code>omv.yaml</code> file. It took me about two minutes to do so, and two hours to debug a problem caused by something I had broken on my laptop.

If you'd like to replicate his article in less than 5 minutes, pull down the <a href="https://github.com/purpleidea/oh-my-vagrant/blob/master/examples/ceph-deploy.yaml">omv.yaml</a> file that I've just published and run <code>omv up</code>. Here's the full terminal output of my session:
```
james@computer:~/code/oh-my-vagrant/examples$ git pull
Already up-to-date.
james@computer:~/code/oh-my-vagrant/examples$ cdtmpmkdir 
james@computer:/tmp/tmp.DhD$ cp $OLDPWD/ceph-deploy.yaml omv.yaml
james@computer:/tmp/tmp.DhD$ time omv up
Bringing machine 'omv1' up with 'libvirt' provider...
==> omv1: Creating image (snapshot of base box volume).
==> omv1: Creating domain with the following settings...
==> omv1:  -- Name:              omv_omv1
==> omv1:  -- Domain type:       kvm
==> omv1:  -- Cpus:              1
==> omv1:  -- Memory:            512M
==> omv1:  -- Base box:          fedora-23
==> omv1:  -- Storage pool:      default
==> omv1:  -- Image:             /var/lib/libvirt/images/omv_omv1.img
==> omv1:  -- Volume Cache:      default
==> omv1:  -- Kernel:            
==> omv1:  -- Initrd:            
==> omv1:  -- Graphics Type:     spice
==> omv1:  -- Graphics Port:     5900
==> omv1:  -- Graphics IP:       127.0.0.1
==> omv1:  -- Graphics Password: Not defined
==> omv1:  -- Video Type:        qxl
==> omv1:  -- Video VRAM:        9216
==> omv1:  -- Keymap:            en-us
==> omv1:  -- Command line : 
==> omv1: Creating shared folders metadata...
==> omv1: Starting domain.
==> omv1: Waiting for domain to get an IP address...
==> omv1: Waiting for SSH to become available...
==> omv1: Setting hostname...
==> omv1: Configuring and enabling network interfaces...
==> omv1: Rsyncing folder: /tmp/tmp.DhD/ => /vagrant
==> omv1: Updating /etc/hosts file on active guest machines...
==> omv1: Running provisioner: shell...
    omv1: Running: inline script
==> omv1: Changing password for user root.
==> omv1: passwd: all authentication tokens updated successfully.
==> omv1: Running provisioner: shell...
    omv1: Running: inline script
==> omv1: TARGET SOURCE    FSTYPE OPTIONS
==> omv1: /      /dev/vda3 xfs    rw,relatime,seclabel,attr2,inode64,noquota
==> omv1: TARGET                                SOURCE     FSTYPE     OPTIONS
==> omv1: /                                     /dev/vda3  xfs        rw,relatime,seclabel,attr2,inode64,noquota
==> omv1: ├─/sys                                sysfs      sysfs      rw,nosuid,nodev,noexec,relatime,seclabel
==> omv1: │ ├─/sys/kernel/security              securityfs securityfs rw,nosuid,nodev,noexec,relatime
==> omv1: │ ├─/sys/fs/cgroup                    tmpfs      tmpfs      ro,nosuid,nodev,noexec,seclabel,mode=755
==> omv1: │ │ ├─/sys/fs/cgroup/systemd          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
==> omv1: │ │ ├─/sys/fs/cgroup/devices          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,devices
==> omv1: │ │ ├─/sys/fs/cgroup/cpu,cpuacct      cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,cpu,cpuacct
==> omv1: │ │ ├─/sys/fs/cgroup/memory           cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,memory
==> omv1: │ │ ├─/sys/fs/cgroup/perf_event       cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,perf_event
==> omv1: │ │ ├─/sys/fs/cgroup/blkio            cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,blkio
==> omv1: │ │ ├─/sys/fs/cgroup/hugetlb          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,hugetlb
==> omv1: │ │ ├─/sys/fs/cgroup/freezer          cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,freezer
==> omv1: │ │ ├─/sys/fs/cgroup/net_cls,net_prio cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,net_cls,net_prio
==> omv1: │ │ └─/sys/fs/cgroup/cpuset           cgroup     cgroup     rw,nosuid,nodev,noexec,relatime,cpuset
==> omv1: │ ├─/sys/fs/pstore                    pstore     pstore     rw,nosuid,nodev,noexec,relatime,seclabel
==> omv1: │ ├─/sys/fs/selinux                   selinuxfs  selinuxfs  rw,relatime
==> omv1: │ ├─/sys/kernel/debug                 debugfs    debugfs    rw,relatime,seclabel
==> omv1: │ └─/sys/kernel/config                configfs   configfs   rw,relatime
==> omv1: ├─/proc                               proc       proc       rw,nosuid,nodev,noexec,relatime
==> omv1: │ ├─/proc/sys/fs/binfmt_misc          systemd-1  autofs     rw,relatime,fd=27,pgrp=1,timeout=0,minproto=5,maxproto=5,direct
==> omv1: │ └─/proc/fs/nfsd                     nfsd       nfsd       rw,relatime
==> omv1: ├─/dev                                devtmpfs   devtmpfs   rw,nosuid,seclabel,size=242328k,nr_inodes=60582,mode=755
==> omv1: │ ├─/dev/shm                          tmpfs      tmpfs      rw,nosuid,nodev,seclabel
==> omv1: │ ├─/dev/pts                          devpts     devpts     rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000
==> omv1: │ ├─/dev/hugepages                    hugetlbfs  hugetlbfs  rw,relatime,seclabel
==> omv1: │ └─/dev/mqueue                       mqueue     mqueue     rw,relatime,seclabel
==> omv1: ├─/run                                tmpfs      tmpfs      rw,nosuid,nodev,seclabel,mode=755
==> omv1: │ └─/run/user/1000                    tmpfs      tmpfs      rw,nosuid,nodev,relatime,seclabel,size=50112k,mode=700,uid=1000,gid=1000
==> omv1: ├─/tmp                                tmpfs      tmpfs      rw,seclabel
==> omv1: ├─/boot                               /dev/vda1  ext4       rw,relatime,seclabel,data=ordered
==> omv1: └─/var/lib/nfs/rpc_pipefs             sunrpc     rpc_pipefs rw,relatime
==> omv1: meta-data=/dev/vda3              isize=512    agcount=4, agsize=321792 blks
==> omv1:          =                       sectsz=512   attr=2, projid32bit=1
==> omv1:          =                       crc=1        finobt=1
==> omv1: data     =                       bsize=4096   blocks=1287168, imaxpct=25
==> omv1:          =                       sunit=0      swidth=0 blks
==> omv1: naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
==> omv1: log      =internal               bsize=4096   blocks=2560, version=2
==> omv1:          =                       sectsz=512   sunit=0 blks, lazy-count=1
==> omv1: realtime =none                   extsz=4096   blocks=0, rtextents=0
==> omv1: data blocks changed from 1287168 to 10199744
==> omv1: Running provisioner: shell...
    omv1: Running: inline script
==> omv1: this is ceph-deploy on fedora-23
==> omv1: Last metadata expiration check performed 0:00:12 ago on Mon Dec 28 14:34:32 2015.
==> omv1: Dependencies resolved.
==> omv1: ================================================================================
==> omv1:  Package               Arch          Version                Repository     Size
==> omv1: ================================================================================
==> omv1: Installing:
==> omv1:  ceph-deploy           noarch        1.5.25-2.fc23          fedora        160 k
==> omv1:  python-execnet        noarch        1.3.0-3.fc23           fedora        275 k
==> omv1:  python-remoto         noarch        0.0.25-2.fc23          fedora         26 k
==> omv1: 
==> omv1: Transaction Summary
==> omv1: ================================================================================
==> omv1: Install  3 Packages
==> omv1: Total download size: 461 k
==> omv1: Installed size: 1.5 M
==> omv1: Downloading Packages:
==> omv1: --------------------------------------------------------------------------------
==> omv1: Total                                           214 kB/s | 461 kB     00:02     
==> omv1: Running transaction check
==> omv1: Transaction check succeeded.
==> omv1: Running transaction test
==> omv1: Transaction test succeeded.
==> omv1: Running transaction
==> omv1:   Installing  : python-execnet-1.3.0-3.fc23.noarch                          1/3
==> omv1:  
==> omv1:   Installing  : python-remoto-0.0.25-2.fc23.noarch                          2/3
==> omv1:  
==> omv1:   Installing  : ceph-deploy-1.5.25-2.fc23.noarch                            3/3
==> omv1:  
==> omv1:   Verifying   : ceph-deploy-1.5.25-2.fc23.noarch                            1/3
==> omv1:  
==> omv1:   Verifying   : python-remoto-0.0.25-2.fc23.noarch                          2/3
==> omv1:  
==> omv1:   Verifying   : python-execnet-1.3.0-3.fc23.noarch                          3/3
==> omv1:  
==> omv1: 
==> omv1: Installed:
==> omv1:   ceph-deploy.noarch 1.5.25-2.fc23       python-execnet.noarch 1.3.0-3.fc23    
==> omv1:   python-remoto.noarch 0.0.25-2.fc23    
==> omv1: Complete!
==> omv1: [ceph_deploy.conf][DEBUG ] found configuration file at: /root/.cephdeploy.conf
==> omv1: [ceph_deploy.cli][INFO  ] Invoked (1.5.25): /bin/ceph-deploy new omv1.example.com
==> omv1: [ceph_deploy.new][DEBUG ] Creating new cluster named ceph
==> omv1: [ceph_deploy.new][INFO  ] making sure passwordless SSH succeeds
==> omv1: [omv1.example.com][DEBUG ] connected to host: omv1.example.com 
==> omv1: [omv1.example.com][DEBUG ] detect platform information from remote host
==> omv1: [omv1.example.com][DEBUG ] detect machine type
==> omv1: [omv1.example.com][DEBUG ] find the location of an executable
==> omv1: [omv1.example.com][INFO  ] Running command: /usr/sbin/ip link show
==> omv1: [omv1.example.com][INFO  ] Running command: /usr/sbin/ip addr show
==> omv1: [omv1.example.com][DEBUG ] IP addresses found: ['192.168.123.100', '172.17.0.1', '192.168.121.48']
==> omv1: [ceph_deploy.new][DEBUG ] Resolving host omv1.example.com
==> omv1: [ceph_deploy.new][DEBUG ] Monitor omv1 at 192.168.123.100
==> omv1: [ceph_deploy.new][DEBUG ] Monitor initial members are ['omv1']
==> omv1: [ceph_deploy.new][DEBUG ] Monitor addrs are ['192.168.123.100']
==> omv1: [ceph_deploy.new][DEBUG ] Creating a random mon key...
==> omv1: [ceph_deploy.new][DEBUG ] Writing monitor keyring to ceph.mon.keyring...
==> omv1: [ceph_deploy.new][DEBUG ] Writing initial config to ceph.conf...
==> omv1: [ceph_deploy.conf][DEBUG ] found configuration file at: /root/.cephdeploy.conf
==> omv1: [ceph_deploy.cli][INFO  ] Invoked (1.5.25): /bin/ceph-deploy install --no-adjust-repos omv1.example.com
==> omv1: [ceph_deploy.install][DEBUG ] Installing stable version hammer on cluster ceph hosts omv1.example.com
==> omv1: [ceph_deploy.install][DEBUG ] Detecting platform for host omv1.example.com ...
==> omv1: [omv1.example.com][DEBUG ] connected to host: omv1.example.com 
==> omv1: [omv1.example.com][DEBUG ] detect platform information from remote host
==> omv1: [omv1.example.com][DEBUG ] detect machine type
==> omv1: [ceph_deploy.install][INFO  ] Distro info: Fedora 23 Twenty Three
==> omv1: [omv1.example.com][INFO  ] installing ceph on omv1.example.com
==> omv1: [omv1.example.com][INFO  ] Running command: yum -y -q install ceph ceph-radosgw
==> omv1: [omv1.example.com][WARNING] Yum command has been deprecated, redirecting to '/usr/bin/dnf -y -q install ceph ceph-radosgw'.
==> omv1: [omv1.example.com][WARNING] See 'man dnf' and 'man yum2dnf' for more information.
==> omv1: [omv1.example.com][WARNING] To transfer transaction metadata from yum to DNF, run:
==> omv1: [omv1.example.com][WARNING] 'dnf install python-dnf-plugins-extras-migrate && dnf-2 migrate'
==> omv1: [omv1.example.com][WARNING] 
==> omv1: [omv1.example.com][INFO  ] Running command: ceph --version
==> omv1: [omv1.example.com][DEBUG ] ceph version 0.94.5 (9764da52395923e0b32908d83a9f7304401fee43)
==> omv1: [ceph_deploy.conf][DEBUG ] found configuration file at: /root/.cephdeploy.conf
==> omv1: [ceph_deploy.cli][INFO  ] Invoked (1.5.25): /bin/ceph-deploy mon create-initial
==> omv1: [ceph_deploy.mon][DEBUG ] Deploying mon, cluster ceph hosts omv1
==> omv1: [ceph_deploy.mon][DEBUG ] detecting platform for host omv1 ...
==> omv1: [omv1][DEBUG ] connected to host: omv1 
==> omv1: [omv1][DEBUG ] detect platform information from remote host
==> omv1: [omv1][DEBUG ] detect machine type
==> omv1: [ceph_deploy.mon][INFO  ] distro info: Fedora 23 Twenty Three
==> omv1: [omv1][DEBUG ] determining if provided host has same hostname in remote
==> omv1: [omv1][DEBUG ] get remote short hostname
==> omv1: [omv1][DEBUG ] deploying mon to omv1
==> omv1: [omv1][DEBUG ] get remote short hostname
==> omv1: [omv1][DEBUG ] remote hostname: omv1
==> omv1: [omv1][DEBUG ] write cluster configuration to /etc/ceph/{cluster}.conf
==> omv1: [omv1][DEBUG ] create the mon path if it does not exist
==> omv1: [omv1][DEBUG ] checking for done path: /var/lib/ceph/mon/ceph-omv1/done
==> omv1: [omv1][DEBUG ] done path does not exist: /var/lib/ceph/mon/ceph-omv1/done
==> omv1: [omv1][INFO  ] creating keyring file: /var/lib/ceph/tmp/ceph-omv1.mon.keyring
==> omv1: [omv1][DEBUG ] create the monitor keyring file
==> omv1: [omv1][INFO  ] Running command: ceph-mon --cluster ceph --mkfs -i omv1 --keyring /var/lib/ceph/tmp/ceph-omv1.mon.keyring
==> omv1: [omv1][DEBUG ] ceph-mon: mon.noname-a 192.168.123.100:6789/0 is local, renaming to mon.omv1
==> omv1: [omv1][DEBUG ] ceph-mon: set fsid to 94276740-7431-49ab-80da-a37325d2d020
==> omv1: [omv1][DEBUG ] ceph-mon: created monfs at /var/lib/ceph/mon/ceph-omv1 for mon.omv1
==> omv1: [omv1][INFO  ] unlinking keyring file /var/lib/ceph/tmp/ceph-omv1.mon.keyring
==> omv1: [omv1][DEBUG ] create a done file to avoid re-doing the mon deployment
==> omv1: [omv1][DEBUG ] create the init path if it does not exist
==> omv1: [omv1][DEBUG ] locating the `service` executable...
==> omv1: [omv1][INFO  ] Running command: /usr/sbin/service ceph -c /etc/ceph/ceph.conf start mon.omv1
==> omv1: [omv1][DEBUG ] === mon.omv1 === 
==> omv1: [omv1][DEBUG ] Starting Ceph mon.omv1 on omv1...
==> omv1: [omv1][WARNING] Running as unit run-3493.service.
==> omv1: [omv1][DEBUG ] Starting ceph-create-keys on omv1...
==> omv1: [omv1][INFO  ] Running command: ceph --cluster=ceph --admin-daemon /var/run/ceph/ceph-mon.omv1.asok mon_status
==> omv1: [omv1][DEBUG ] ********************************************************************************
==> omv1: [omv1][DEBUG ] status for monitor: mon.omv1
==> omv1: [omv1][DEBUG ] {
==> omv1: [omv1][DEBUG ]   "election_epoch": 2, 
==> omv1: [omv1][DEBUG ]   "extra_probe_peers": [], 
==> omv1: [omv1][DEBUG ]   "monmap": {
==> omv1: [omv1][DEBUG ]     "created": "0.000000", 
==> omv1: [omv1][DEBUG ]     "epoch": 1, 
==> omv1: [omv1][DEBUG ]     "fsid": "94276740-7431-49ab-80da-a37325d2d020", 
==> omv1: [omv1][DEBUG ]     "modified": "0.000000", 
==> omv1: [omv1][DEBUG ]     "mons": [
==> omv1: [omv1][DEBUG ]       {
==> omv1: [omv1][DEBUG ]         "addr": "192.168.123.100:6789/0", 
==> omv1: [omv1][DEBUG ]         "name": "omv1", 
==> omv1: [omv1][DEBUG ]         "rank": 0
==> omv1: [omv1][DEBUG ]       }
==> omv1: [omv1][DEBUG ]     ]
==> omv1: [omv1][DEBUG ]   }, 
==> omv1: [omv1][DEBUG ]   "name": "omv1", 
==> omv1: [omv1][DEBUG ]   "outside_quorum": [], 
==> omv1: [omv1][DEBUG ]   "quorum": [
==> omv1: [omv1][DEBUG ]     0
==> omv1: [omv1][DEBUG ]   ], 
==> omv1: [omv1][DEBUG ]   "rank": 0, 
==> omv1: [omv1][DEBUG ]   "state": "leader", 
==> omv1: [omv1][DEBUG ]   "sync_provider": []
==> omv1: [omv1][DEBUG ] }
==> omv1: [omv1][DEBUG ] ********************************************************************************
==> omv1: [omv1][INFO  ] monitor: mon.omv1 is running
==> omv1: [omv1][INFO  ] Running command: ceph --cluster=ceph --admin-daemon /var/run/ceph/ceph-mon.omv1.asok mon_status
==> omv1: [ceph_deploy.mon][INFO  ] processing monitor mon.omv1
==> omv1: [omv1][DEBUG ] connected to host: omv1 
==> omv1: [omv1][INFO  ] Running command: ceph --cluster=ceph --admin-daemon /var/run/ceph/ceph-mon.omv1.asok mon_status
==> omv1: [ceph_deploy.mon][INFO  ] mon.omv1 monitor has reached quorum!
==> omv1: [ceph_deploy.mon][INFO  ] all initial monitors are running and have formed quorum
==> omv1: [ceph_deploy.mon][INFO  ] Running gatherkeys...
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Checking omv1 for /etc/ceph/ceph.client.admin.keyring
==> omv1: [omv1][DEBUG ] connected to host: omv1 
==> omv1: [omv1][DEBUG ] detect platform information from remote host
==> omv1: [omv1][DEBUG ] detect machine type
==> omv1: [omv1][DEBUG ] fetch remote file
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Got ceph.client.admin.keyring key from omv1.
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Have ceph.mon.keyring
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Checking omv1 for /var/lib/ceph/bootstrap-osd/ceph.keyring
==> omv1: [omv1][DEBUG ] connected to host: omv1 
==> omv1: [omv1][DEBUG ] detect platform information from remote host
==> omv1: [omv1][DEBUG ] detect machine type
==> omv1: [omv1][DEBUG ] fetch remote file
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Got ceph.bootstrap-osd.keyring key from omv1.
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Checking omv1 for /var/lib/ceph/bootstrap-mds/ceph.keyring
==> omv1: [omv1][DEBUG ] connected to host: omv1 
==> omv1: [omv1][DEBUG ] detect platform information from remote host
==> omv1: [omv1][DEBUG ] detect machine type
==> omv1: [omv1][DEBUG ] fetch remote file
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Got ceph.bootstrap-mds.keyring key from omv1.
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Checking omv1 for /var/lib/ceph/bootstrap-rgw/ceph.keyring
==> omv1: [omv1][DEBUG ] connected to host: omv1 
==> omv1: [omv1][DEBUG ] detect platform information from remote host
==> omv1: [omv1][DEBUG ] detect machine type
==> omv1: [omv1][DEBUG ] fetch remote file
==> omv1: [ceph_deploy.gatherkeys][DEBUG ] Got ceph.bootstrap-rgw.keyring key from omv1.
==> omv1: [ceph_deploy.conf][DEBUG ] found configuration file at: /root/.cephdeploy.conf
==> omv1: [ceph_deploy.cli][INFO  ] Invoked (1.5.25): /bin/ceph-deploy osd prepare omv1.example.com:/srv/ceph/osd
==> omv1: [ceph_deploy.osd][DEBUG ] Preparing cluster ceph disks omv1.example.com:/srv/ceph/osd:
==> omv1: [omv1.example.com][DEBUG ] connected to host: omv1.example.com 
==> omv1: [omv1.example.com][DEBUG ] detect platform information from remote host
==> omv1: [omv1.example.com][DEBUG ] detect machine type
==> omv1: [ceph_deploy.osd][INFO  ] Distro info: Fedora 23 Twenty Three
==> omv1: [ceph_deploy.osd][DEBUG ] Deploying osd to omv1.example.com
==> omv1: [omv1.example.com][DEBUG ] write cluster configuration to /etc/ceph/{cluster}.conf
==> omv1: [omv1.example.com][INFO  ] Running command: udevadm trigger --subsystem-match=block --action=add
==> omv1: [ceph_deploy.osd][DEBUG ] Preparing host omv1.example.com disk /srv/ceph/osd journal None activate False
==> omv1: [omv1.example.com][INFO  ] Running command: ceph-disk -v prepare --fs-type xfs --cluster ceph -- /srv/ceph/osd
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-osd --cluster=ceph --show-config-value=fsid
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_mkfs_options_xfs
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_fs_mkfs_options_xfs
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_mount_options_xfs
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_fs_mount_options_xfs
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-osd --cluster=ceph --show-config-value=osd_journal_size
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_cryptsetup_parameters
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_dmcrypt_key_size
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-conf --cluster=ceph --name=osd. --lookup osd_dmcrypt_type
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Preparing osd data dir /srv/ceph/osd
==> omv1: [omv1.example.com][INFO  ] checking OSD status...
==> omv1: [omv1.example.com][INFO  ] Running command: ceph --cluster=ceph osd stat --format=json
==> omv1: [ceph_deploy.osd][DEBUG ] Host omv1.example.com is now ready for osd use.
==> omv1: [ceph_deploy.conf][DEBUG ] found configuration file at: /root/.cephdeploy.conf
==> omv1: [ceph_deploy.cli][INFO  ] Invoked (1.5.25): /bin/ceph-deploy osd activate omv1.example.com:/srv/ceph/osd
==> omv1: [ceph_deploy.osd][DEBUG ] Activating cluster ceph disks omv1.example.com:/srv/ceph/osd:
==> omv1: [omv1.example.com][DEBUG ] connected to host: omv1.example.com 
==> omv1: [omv1.example.com][DEBUG ] detect platform information from remote host
==> omv1: [omv1.example.com][DEBUG ] detect machine type
==> omv1: [ceph_deploy.osd][INFO  ] Distro info: Fedora 23 Twenty Three
==> omv1: [ceph_deploy.osd][DEBUG ] activating host omv1.example.com disk /srv/ceph/osd
==> omv1: [ceph_deploy.osd][DEBUG ] will use init type: sysvinit
==> omv1: [omv1.example.com][INFO  ] Running command: ceph-disk -v activate --mark-init sysvinit --mount /srv/ceph/osd
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Cluster uuid is 94276740-7431-49ab-80da-a37325d2d020
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-osd --cluster=ceph --show-config-value=fsid
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Cluster name is ceph
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:OSD uuid is 43a20af4-7a45-4f70-a0dd-baf906d58026
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Allocating OSD id...
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph --cluster ceph --name client.bootstrap-osd --keyring /var/lib/ceph/bootstrap-osd/ceph.keyring osd create --concise 43a20af4-7a45-4f70-a0dd-baf906d58026
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:OSD id is 0
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Initializing OSD...
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph --cluster ceph --name client.bootstrap-osd --keyring /var/lib/ceph/bootstrap-osd/ceph.keyring mon getmap -o /srv/ceph/osd/activate.monmap
==> omv1: [omv1.example.com][WARNING] got monmap epoch 1
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph-osd --cluster ceph --mkfs --mkkey -i 0 --monmap /srv/ceph/osd/activate.monmap --osd-data /srv/ceph/osd --osd-journal /srv/ceph/osd/journal --osd-uuid 43a20af4-7a45-4f70-a0dd-baf906d58026 --keyring /srv/ceph/osd/keyring
==> omv1: [omv1.example.com][WARNING] 2015-12-28 14:36:47.525213 7f66f9f0c880 -1 journal FileJournal::_open: disabling aio for non-block journal.  Use journal_force_aio to force use of aio anyway
==> omv1: [omv1.example.com][WARNING] 2015-12-28 14:36:49.412257 7f66f9f0c880 -1 journal FileJournal::_open: disabling aio for non-block journal.  Use journal_force_aio to force use of aio anyway
==> omv1: [omv1.example.com][WARNING] 2015-12-28 14:36:49.413018 7f66f9f0c880 -1 filestore(/srv/ceph/osd) could not find 23c2fcde/osd_superblock/0//-1 in index: (2) No such file or directory
==> omv1: [omv1.example.com][WARNING] 2015-12-28 14:36:49.813515 7f66f9f0c880 -1 created object store /srv/ceph/osd journal /srv/ceph/osd/journal for osd.0 fsid 94276740-7431-49ab-80da-a37325d2d020
==> omv1: [omv1.example.com][WARNING] 2015-12-28 14:36:49.813566 7f66f9f0c880 -1 auth: error reading file: /srv/ceph/osd/keyring: can't open /srv/ceph/osd/keyring: (2) No such file or directory
==> omv1: [omv1.example.com][WARNING] 2015-12-28 14:36:49.813683 7f66f9f0c880 -1 created new key in keyring /srv/ceph/osd/keyring
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Marking with init system sysvinit
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Authorizing OSD key...
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/bin/ceph --cluster ceph --name client.bootstrap-osd --keyring /var/lib/ceph/bootstrap-osd/ceph.keyring auth add osd.0 -i /srv/ceph/osd/keyring osd allow * mon allow profile osd
==> omv1: [omv1.example.com][WARNING] added key for osd.0
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:ceph osd.0 data dir is ready at /srv/ceph/osd
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Creating symlink /var/lib/ceph/osd/ceph-0 -> /srv/ceph/osd
==> omv1: [omv1.example.com][WARNING] DEBUG:ceph-disk:Starting ceph osd.0...
==> omv1: [omv1.example.com][WARNING] INFO:ceph-disk:Running command: /usr/sbin/service ceph --cluster ceph start osd.0
==> omv1: [omv1.example.com][DEBUG ] === osd.0 === 
==> omv1: [omv1.example.com][WARNING] create-or-move updating item name 'osd.0' weight 0.04 at location {host=omv1,root=default} to crush map
==> omv1: [omv1.example.com][DEBUG ] Starting Ceph osd.0 on omv1...
==> omv1: [omv1.example.com][WARNING] Running as unit run-4116.service.
==> omv1: [omv1.example.com][INFO  ] checking OSD status...
==> omv1: [omv1.example.com][INFO  ] Running command: ceph --cluster=ceph osd stat --format=json
==> omv1: [omv1.example.com][INFO  ] Running command: systemctl enable ceph
==> omv1: [omv1.example.com][WARNING] ceph.service is not a native service, redirecting to systemd-sysv-install
==> omv1: [omv1.example.com][WARNING] Executing /usr/lib/systemd/systemd-sysv-install enable ceph
==> omv1:     cluster 94276740-7431-49ab-80da-a37325d2d020
==> omv1:      health HEALTH_WARN
==> omv1:             64 pgs stuck inactive
==> omv1:             64 pgs stuck unclean
==> omv1:      monmap e1: 1 mons at {omv1=192.168.123.100:6789/0}
==> omv1:             election epoch 2, quorum 0 omv1
==> omv1:      osdmap e5: 1 osds: 1 up, 1 in
==> omv1:       pgmap v6: 64 pgs, 1 pools, 0 bytes data, 0 objects
==> omv1:             0 kB used, 0 kB / 0 kB avail
==> omv1:                   64 creating
==> omv1: you can now use ceph with the rbd command

real    4m14.815s
user    0m2.239s
sys    0m0.288s
james@computer:/tmp/tmp.DhD$ vscreen root@omv1
[root@omv1 ~]# ceph status
    cluster 94276740-7431-49ab-80da-a37325d2d020
     health HEALTH_OK
     monmap e1: 1 mons at {omv1=192.168.123.100:6789/0}
            election epoch 2, quorum 0 omv1
     osdmap e5: 1 osds: 1 up, 1 in
      pgmap v9: 64 pgs, 1 pools, 0 bytes data, 0 objects
            6642 MB used, 33190 MB / 39832 MB avail
                  64 active+clean
[root@omv1 ~]#
```
You'll notice that the <code>ceph status</code> command initially returned a warning when run with OMV, but you'll notice that if I logged in to the machine and ran it a second time, everything is now happy. I imagine this is because it takes a moment to converge on a healthy state.

<a href="https://twitter.com/purpleidea/status/681562552019456000">I've also just released a new Fedora-23 vagrant box</a>, which is what this example uses. Naturally if you haven't already downloaded the box, this example will take a bit longer to run the first time. The download will cost you about 865M and will happen automatically if you're missing the box.

Happy hacking!

James

PS: If you're curious what that <code>cdtmpmkdir</code> is, it's here:
```
$ type cdtmpmkdir 
cdtmpmkdir is a function
cdtmpmkdir () 
{ 
    cd `mktemp --tmpdir -d tmp.XXX`
}
```

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
