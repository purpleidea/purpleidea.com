+++
date = "2012-07-24 15:56:40"
title = "a puppet module for gluster"
draft = "false"
categories = ["technical"]
tags = ["devops", "gluster", "puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/07/24/a-puppet-module-for-gluster/"
+++

I am an avid <a href="http://cobbler.github.com/about.html">cobbler</a>+<a href="http://puppetlabs.com/puppet/what-is-puppet/">puppet</a> user. This allows me to rely on my cobbler server and puppet manifests to describe how servers/workstations are setup. I only backup my configs and data, and I regenerate failed machines PRN.

I'll be publishing my larger cobbler+puppet infrastructure in the future once it's been cleaned up a bit, but for now I figured I'd post my work-in-progress "puppet-gluster" module, since it seems there's a real interest.

<span style="text-decoration:underline;">Warning</span>: there are some serious issues with this module! I've used this as an easy way to build out many servers with cobbler+puppet automatically. It's not necessarily the best long-term solution, and it certainly can't handle certain scenarios yet, but it is a stepping stone if someone would like to think about writing such a module this way.

It's now available here: <a href="https://github.com/purpleidea/puppet-gluster/">https://github.com/purpleidea/puppet-gluster/</a> <strike>Once I finish cleaning up a bit of cruft, I'll post my git tree somewhere sane.</strike>(<strong>EDIT:</strong> Now available in git!) All of this code is <a href="http://www.gnu.org/licenses/agpl-3.0.html">AGPL3+</a> so share and enjoy!

What's next? My goal is to find the interested parties and provoke a bit of discussion as to whether this is useful and where to go next. It makes sense to me, that the gluster experts chirp in and add gluster specific optimization's into this module, so that it's used as a sort of de-facto documentation on how to set up gluster properly.

I believe that <a href="http://projects.puppetlabs.com/users/811">Dan Bode</a> and other gluster developers are already interested in the "puppet module" project, and that work is underway. I spoke to him briefly about collaborating. He is most likely a more experienced puppet user than I, and so I look forward to the community getting a useful puppet-gluster module from somewhere. Maybe even native gluster <a href="http://docs.puppetlabs.com/references/stable/type.html">types</a>?

Happy hacking,
James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
