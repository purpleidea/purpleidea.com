+++
date = "2014-08-27 05:52:47"
title = "Rough data density calculations"
draft = "false"
categories = ["technical"]
tags = ["back-of-the-envelope-calculations", "devops", "gluster", "math", "planetdevops", "planetfedora", "planetpuppet", "puppet", "puppet-gluster"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/08/27/rough-data-density-calculations/"
+++

<a href="https://hardware.slashdot.org/story/14/08/26/2325203/seagate-ships-first-8-terabyte-hard-drive">Seagate has just publicly announced 8TB HDD's in a 3.5" form factor.</a> I decided to do some <em>rough</em> calculations to understand the density a bit better...

Note: I have decided to ignore the distinction between <a href="https://en.wikipedia.org/wiki/Terabyte">Terabytes (TB)</a> and <a href="https://en.wikipedia.org/wiki/Tebibyte">Tebibytes (TiB)</a>, since I always work in base 2, but I hate the -bi naming conventions. Seagate is most likely announcing an 8<em>TB</em> HDD, which is actually smaller than a true 8TiB drive. If you don't know the difference it's worth learning.

<span style="text-decoration:underline;">Rack Unit Density</span>:

Supermicro sells a <a href="http://www.supermicro.com/products/chassis/4U/847/SC847DE26-R2K02JBOD.cfm">high density, double-sided 4U server</a>, which can hold 90 x 3.5" drives. This means you can easily store:

90 * 8TB = 720TB in 4U,

or:

720TB/4U = 180TB per U.

To store a petabyte of data, since:

1PB = 1024TB,

we need:

1024TB/180TB/U = 5.68 U.

Rounding up we realize that we can easily store one petabyte of <em>raw</em> data in 6U.

Since an average rack is usually 42U (tall racks can be 48U) that means we can store between seven and eight PB per rack:

42U/rack / 6U/PB = 7PB/rack

48U/rack / 6U/PB = 8PB/rack

If you can provide the power and cooling, you can quickly see that small data centers can easily get into <a href="https://en.wikipedia.org/wiki/Exabyte">exabyte</a> scale if needed. One raw exabyte would only require:

1EB = 1024PB

1024PB/7PB/rack = 146 racks =~ 150 racks.

<span style="text-decoration:underline;">Raid and Redundancy</span>:

Since you'll most likely have lots of failures, I would recommend having some number of RAID sets per server, and perhaps a distributed file system like GlusterFS to replicate the data across different servers. Suppose you broke each 90 drive server into five separate RAID 6 bricks for GlusterFS:

90/5 = 18 drives per brick.

In RAID 6, you loose two drives to parity, so that means:

18 drives - 2 drives = 16 drives per brick of usable storage.

16 drives * 5 bricks * 8 TB = 640 TB after RAID 6 in 4U.

640TB/4U = 160TB/U

1024TB/160TB/U = 6.4TB/U =~ 7PB/rack.

Since I rounded <em>a lot</em>, the result is similar. With a replica count of 2 in a standard GlusterFS configuration, you average a total of about 3-4PB of usable storage per rack. Need a petabyte scale filesystem? One rack should do it!

<span style="text-decoration:underline;">Other considerations</span>:
<ul>
	<li>Remember that you need to take into account space for power, cooling and networking.</li>
	<li>Keep in mind that <a href="https://en.wikipedia.org/wiki/Shingled_magnetic_recording">SMR</a> might be used to increase density even further (unless it's not already being used on these drives).</li>
	<li>Remember that these calculations were done to understand the order of magnitude, and not to get a precise measurement on the size of a planned cluster.</li>
	<li>Petabyte scale is starting to feel small...</li>
</ul>
<span style="text-decoration:underline;">Conclusions</span>:

Storage is getting very inexpensive. After the above analysis, I feel safe in concluding that:
<ol>
	<li><a href="https://github.com/purpleidea/puppet-gluster">Puppet-Gluster</a> could easily automate a petabyte scale filesystem.</li>
	<li>I have an embarrassingly small amount of personal storage.</li>
</ol>
Hope this was fun,

Happy hacking,

James

<span style="text-decoration:underline;">Disclaimer</span>: I have not tried the 8TB Seagate HDD's, or the Supermicro 90 x 3.5" servers, but if you are building a petabyte scale cluster with GlusterFS/Puppet-Gluster, I'd like to hear about it!

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
