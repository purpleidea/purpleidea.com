+++
date = "2013-01-17 03:03:36"
title = "SElinux causes pain when using puppet 2.x with hiera"
draft = "false"
categories = ["technical"]
tags = ["audit.log", "hiera", "pain", "puppet", "puppetmasterd", "selinux"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/01/17/selinux-causes-pain-when-using-puppet-2-x-with-hiera/"
+++

So hiera wasn't working when used through my puppetmaster. It worked perfectly when I was running my scripts manually with: <em>puppet apply site.pp</em> but the moment I switched over to regular <em>puppetmasterd</em> usage, everything went dead.

I realized a while back, that I could always expect some hiera failures from time to time. Whether this is hiera's fault or not is irrelevant, the relevant part is that I quickly added:
```
$test = hiera('test', '')    # expects: 'Hiera is working!'
if "${test}" == '' {
    fail('The hiera function is not working as expected!')
}
```
to my <em>site.pp</em> and now I don't risk breaking/changing a node because some data is missing. Naturally you'll need to add a little message in your <em>globals.yaml</em> or similar. If you're really cautious, you could change the above to an inequality and have your code "expect" a magic message.

To continue with the story, <em>blkperl</em> from #puppet recommended that I try running puppetmasterd manually to watch for any messages it might print. To my surprise, things started working! This just shows you how helpful it is to have a second set of eyes to help you on your way. So why did this work ?

To make a long story short, after following a few dead ends, it hit me, and so I looked in <em>/var/log/audit/audit.log</em>:
```
type=AVC msg=audit(1358404083.789:55416): avc:  denied  { getattr } for  pid=13830 comm="puppetmasterd" path="/etc/puppet/hiera.yaml" dev=dm-0 ino=18613624 scontext=unconfined_u:system_r:puppetmaster_t:s0 tcontext=unconfined_u:object_r:admin_home_t:s0 tclass=file
```
to find that <a title="Clustering virtual machines with rgmanager and clusvcadm" href="/blog/2013/01/03/clustering-virtual-machines-with-rgmanager-and-clusvcadm/">selinux was once again</a> causing me pain. When I had started <em>puppetmasterd</em> manually, I was root, which allowed me to bypass selinux rules. Sadly, I like selinux, but since I'm not nearly clever enough to want to learn how to fix this the right way, it just got disabled on another one of my machines.

Running:
```
restorecon -v /etc/puppet/hiera.yaml
```
fixed the bad selinux context I had on that file.

Hope this saves you some time and,

Happy hacking,

James

