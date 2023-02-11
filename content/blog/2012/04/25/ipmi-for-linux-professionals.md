+++
date = "2012-04-25 01:22:22"
title = "IPMI for linux professionals"
draft = "false"
categories = ["technical"]
tags = ["cobbler", "devops", "ipmi", "ipmitool", "kvm"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/04/25/ipmi-for-linux-professionals/"
+++

The nostalgia of serial console servers, kvm's and switched PDU's is hopefully no longer visible in your server room. If not, you must definitely start playing catch up. Please forgive my ignorance, but these things might still be common for big windows shops, however if that's the case, you've got an entirely different set of problems ;)

IPMI is an IP based protocol that allows you to talk directly to a little computer, usually built in to your server. It lets you remotely manage power (on, off, reboot, cycle...) get a serial console, collect sensor readings like temperatures, and do other magical things too if you care to figure them out.

The web talks a lot about all this. I'll give you the short "need to know" list to get you going.
<ol>
	<li>It probably makes sense to have the IPMI device of your DHCP server (or whatever network dependencies you have) set statically, so that this works if DHCP is down. I've actually never heard of anyone who had this problem, but it seems logical enough that I figured I'd mention it.</li>
	<li>Set an IPMI password and put the device on a separate layer two network behind your router and firewall. Most servers bond the IPMI device to your "eth0" by default (at layer2), or let you split it off to a separate physical interface if so desired. Do the split and plug it into your management network. Remind me to talk about my dual router topology one day.</li>
	<li>When you use cobbler to kickstart your machines, you'll need this in your kopts:
console=ttyS1,115200
Don't bother wasting your time configuring that manually when anaconda takes care of this for you :)</li>
	<li>Almost all server hardware uses the second serial device (ttyS1) as the one that is linked to the IPMI hardware. In some insane default BIOS'es you might have to enable this.</li>
	<li>Once installed, the kopt will usually know to have added the correct magic to grub, and also to whatever spawn's your serial tty. Feel free to grep to see what your $OS did.</li>
	<li>ipmitool -I lanplus -H &lt;ip address of ipmi device&gt; -U ADMIN sol activate
if ever this gets stuck, run a 'deactivate' first.</li>
	<li>Learn the ~. disconnect sequence. If you're connected over ssh to your ipmi client (which I always am since it's my router) you'll need to "~~" to skip "through" the ssh <a title="how to use ssh escape characters" href="/blog/2012/04/25/how-to-use-ssh-escape-characters/">escape character</a>, and then period ".", exactly how ssh disconnects. Similarly the same logic applies if you're insane and run screen -&gt; ssh -&gt; screen.</li>
	<li>You might need to do a "reset+clear" if the bios throws crap down the wire at you. I haven't found a way to avoid this. It's generally not a big problem for me, because this only happens if I'm watching the bios at boot, which only really happens if I'm bored on first install.</li>
</ol>
Happy Hacking!

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
