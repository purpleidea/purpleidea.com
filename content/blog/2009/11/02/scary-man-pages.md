+++
date = "2009-11-02 23:21:57"
title = "scary man pages"
draft = "false"
categories = ["technical"]
tags = ["dangerous", "hdparm", "linux", "manpages"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/11/02/scary-man-pages/"
+++

while doing a little reading and research,  i ended up reading a bit of the hdparm man page. never in my life have i read such a scary man page. i guess it <em>is</em> appropriate for halloween, but it came 2 days late in my case. as a result of my being so impressed with the sheer amount of warnings in the manual, i have decided to compile them here.
<pre>
<i>--dco-restore</i>
Reset all drive settings, features, and accessible capacities back to factory defaults and full capabilities. This command will fail if DCO is frozen/locked, or if a -Np maximum size restriction has also been set. This is <strong>EXTREMELY DANGEROUS</strong> and will very likely cause massive loss of data. <strong>DO NOT USE THIS COMMAND.</strong>
</pre>
<pre>
<i>--drq-hsm-error</i>
<strong>VERY DANGEROUS, DON'T EVEN THINK ABOUT USING IT.</strong> This flag causes hdparm to issue an IDENTIFY command to the kernel, but incorrectly marked as a "non-data" command. This results in the drive being left with its DataReQust(DRQ) line "stuck" high. This confuses the kernel drivers, and may crash the system immediately with massive data loss. The option exists to help in testing and fortifying the kernel against similar real-world drive malfunctions. <strong>VERY DANGEROUS, DO NOT USE!!</strong>
</pre>
<pre>
<i>--fwdownload</i>
When used, this should be the only flag given. It requires a file path immediately after the flag, indicating where the new drive firmware should be read from. The contents of this file will be sent to the drive using the (S)ATA DOWNLOAD MICROCODE command, using either transfer protocol 7 (entire file at once), or, if the drive supports it, transfer protocol 3 (segmented download). This command is <strong>EXTREMELY DANGEROUS</strong> and <strong>HAS NEVER BEEN PROVEN TO WORK</strong> and will probably destroy both the drive and all data on it. <strong>DO NOT USE THIS COMMAND</strong>.
</pre>
<pre>
<i>-m</i>
Get/set sector count for multiple sector I/O on the drive. A setting of 0 disables this feature. Multiple sector mode (aka IDE Block Mode), is a feature of most modern IDE hard drives, permitting the transfer of multiple sectors per I/O interrupt, rather than the usual one sector per interrupt. When this feature is enabled, it typically reduces operating system overhead for disk I/O by 30-50%. On many systems, it also provides increased data throughput of anywhere from 5% to 50%. Some drives, however (most notably the WD Caviar series), seem to run slower with multiple mode enabled. Your mileage may vary. Most drives support the minimum settings of 2, 4, 8, or 16 (sectors). Larger settings may also be possible, depending on the drive. A setting of 16 or 32 seems optimal on many systems. Western Digital recommends lower settings of 4 to 8 on many of their drives, due tiny (32kB) drive buffers and non-optimized buffering algorithms. The -i flag can be used to find the maximum setting supported by an installed drive (look for MaxMultSect in the output). Some drives claim to support multiple mode, but lose data at some settings. Under rare circumstances, such failures can result in <strong>massive filesystem corruption</strong>.
</pre>
<pre>
<i>-R</i>
Register an IDE interface <strong>(DANGEROUS)</strong>. See the -U option for more information.
</pre>
<pre>
<i>-u</i>
Get/set interrupt-unmask flag for the drive. A setting of 1 permits the driver to unmask other interrupts during processing of a disk interrupt, which greatly improves Linux´s responsiveness and eliminates "serial port overrun" errors. Use this feature with caution: some drive/controller combinations do not tolerate the increased I/O latencies possible when this feature is enabled, resulting in <strong>massive filesystem corruption</strong>. In particular, CMD-640B and RZ1000 (E)IDE interfaces can be unreliable (due to a hardware flaw) when this option is used with kernel versions earlier than 2.0.13. Disabling the IDE prefetch feature of these interfaces (usually a BIOS/CMOS setting) provides a safe fix for the problem for use with earlier kernels.
</pre>
<pre>
<i>-U</i>
Un-register an IDE interface <strong>(DANGEROUS)</strong>. The companion for the -R option. Intended for use with hardware made specifically for hot-swapping (very rare!). Use with knowledge and extreme caution as this can easily hang or damage your system. The hdparm source distribution includes a ´contrib´ directory with some user-donated scripts for hot-swapping on the UltraBay of a ThinkPad 600E. <strong>Use at your own risk.</strong>
</pre>
<pre>
<i>-w</i>
Perform a device reset <strong>(DANGEROUS)</strong>. <strong>Do NOT use this option.</strong> It exists for unlikely situations where a reboot might otherwise be required to get a confused drive back into a useable state.
</pre>
<pre>
<i>-x</i>
Tristate device for hotswap <strong>(DANGEROUS)</strong>.
</pre>
<pre>
<i>--security-unlock PWD</i>
<i>--security-set-pass PWD</i>
<i>--security-disable PWD</i>
<i>--security-erase PWD</i>
<i>--security-erase-enhanced PWD</i>
<i>--user-master USER</i>
<i>--security-mode MODE</i>
[...]
<strong>THIS FEATURE IS EXPERIMENTAL AND NOT WELL TESTED. USE AT YOUR OWN RISK.</strong>
</pre>

i think it is now safe to say that:
```
# rm -rf /
```
has now officially been replaced with the much more dangerous:
```
# hdparm -mRuUwx --dco-restore --drq-hsm-error --fwdownload --security-unlock PWD --security-set-pass PWD --security-disable PWD --security-erase PWD --security-erase-enhanced PWD --user-master USER --security-mode MODE [device]
```
have fun kiddies!

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
