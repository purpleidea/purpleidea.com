+++
date = "2016-04-25 13:46:53"
title = "One hour hacks: Remote LUKS over SSH"
draft = "false"
categories = ["technical"]
tags = ["GNU", "LUKS", "bash", "devops", "fedora", "gluster", "hack", "hacks", "linux", "mount", "one hour hack", "planetdevops", "planetfedora", "planetpuppet", "ssh"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2016/04/25/one-hour-hacks-remote-luks-over-ssh/"
+++

I have a <a href="https://gnu.org/">GNU/Linux</a> server which I mount a few <a href="https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup">LUKS</a> encrypted drives on. I only ever interact with the server over SSH, and I never want to keep the LUKS credentials on the remote server. I don't have anything especially sensitive on the drives, but I think it's a good security practice to <a href="http://www.theguardian.com/commentisfree/2013/jul/15/crux-nsa-collect-it-all">encrypt it all</a>, if only to add noise into the system and for solidarity with <a href="https://en.wikipedia.org/wiki/Whistleblower">those</a> who harbour much more sensitive data.

This means that every time the server reboots or whenever I want to mount the drives, I have to log in and go through the series of luksOpen and mount commands before I can access the data. This turned out to be a bit laborious, so I wrote a quick script to automate it! I also made sure that it was <a href="https://en.wikipedia.org/wiki/Idempotence">idempotent</a>.

I decided to share it because I couldn't find anything similar, and I was annoyed that I had to write this in the first place. Hopefully it saves you some anguish. It also contains a clever little bash hack that I am proud to have in my script.

<a href="https://gist.github.com/purpleidea/7a145a4f58114efcc0d642fea3757e8a">Here's the script.</a> You'll need to fill in the map of mount folder names to drive UUID's, and you'll want to set your server hostname and FQDN to match your environment of course. It will prompt you for your root password to mount, and the LUKS password when needed.

Example of mounting:

```
james@computer:~$ rluks.sh 
Running on: myserver...
[sudo] password for james: 
Mount/Unmount [m/u] ? m
Mounting...
music: mkdir ✓
LUKS Password: 
music: luksOpen ✓
music: mount ✓
files: mkdir ✓
files: luksOpen ✓
files: mount ✓
photos: mkdir ✓
photos: luksOpen ✓
photos: mount ✓
Done!
Connection to server.example.com closed.
```
Example of unmounting:

```
james@computer:~$ rluks.sh 
Running on: myserver...
[sudo] password for james: 
Sorry, try again.
[sudo] password for james: 
Mount/Unmount [m/u] ? u
Unmounting...
music: umount ✓
music: luksClose ✓
music: rmdir ✓
files: umount ✓
files: luksClose ✓
files: rmdir ✓
photos: umount ✓
photos: luksClose ✓
photos: rmdir ✓
Done!
Connection to server.example.com closed.
james@computer:~$
```
It's worth mentioning that there are many improvements that could be made to this script. If you've got patches, send them my way. After all, this is only a: one hour hack.

Happy hacking,

James

PS: One day this sort of thing might be possible in <a href="https://github.com/purpleidea/mgmt/">mgmt</a>. <a href="/contact/">Let me know</a> if you want to help work on it!

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
