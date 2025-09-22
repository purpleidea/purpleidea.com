+++
date = "2014-01-29 19:43:44"
title = "Show the exit status in your $PS1"
draft = "false"
categories = ["technical"]
tags = ["bash", "devops", "exit code", "exit status", "git", "gluster", "planetdevops", "planetfedora", "planetpuppet", "ps1", "puppet"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/01/29/show-the-exit-status-in-your-ps1/"
+++

As an update <a href="/blog/2013/10/10/show-current-git-branch-in-ps1-when-branch-is-not-master/">to my earlier article</a>, a friend gave me an idea of how to make my <code>$PS1</code> even better... First, the relevant part of my <code>~/.bashrc</code>:

{{< highlight bash >}}
ps1_prompt() {
	local ps1_exit=$?

	if [ $ps1_exit -eq 0 ]; then
		#ps1_status=`echo -e "\[&#092;&#048;33[32m\]"'\$'"\[&#092;&#048;33[0m\]"`
		ps1_status='\$'
	else
		ps1_status=`echo -e "\[&#092;&#048;33[1;31m\]"'\$'"\[&#092;&#048;33[0m\]"`

	fi

	ps1_git=''
	if [ "$(__git_ps1 %s)" != '' -a "$(__git_ps1 %s)" != 'master' ]; then
		ps1_git=" (\[&#092;&#048;33[32m\]"$(__git_ps1 "%s")"\[&#092;&#048;33[0m\])"
	fi

	PS1="${debian_chroot:+($debian_chroot)}\u@\h:\[&#092;&#048;33[01;34m\]\w\[&#092;&#048;33[00m\]${ps1_git}${ps1_status} "
}

# preserve earlier PROMPT_COMMAND entries...
PROMPT_COMMAND="ps1_prompt;$PROMPT_COMMAND"
{{< /highlight >}}
If you haven't figured it out, the magic is that the trailing <strong>$</strong> prompt gets coloured in <strong><span style="color:#ff0000;">red</span></strong> when the previous command exited with a non-zero value. Example:
<pre>
james@computer:<span style="color:#3366ff;">~</span>$ cdmkdir /tmp/ttboj # yes, i built cdmkdir
james@computer:<span style="color:#3366ff;">/tmp/ttboj</span>$ false
james@computer:<span style="color:#3366ff;">/tmp/ttboj</span><span style="color:#ff0000;">$</span> echo ttboj
ttboj
james@computer:<span style="color:#3366ff;">/tmp/ttboj</span>$ ^C
james@computer:<span style="color:#3366ff;">/tmp/ttboj</span><span style="color:#ff0000;">$</span> true
james@computer:<span style="color:#3366ff;">/tmp/ttboj</span>$ cd ~/code/puppet/puppet-gluster/
james@computer:<span style="color:#3366ff;">~/code/puppet/puppet-gluster</span>$ # hack, hack, hack...
</pre>
You can still:
<pre>
<span style="color:#ff0000;">$</span> echo $?
42
</pre>
if you want more specifics about what the exact return code was, and of course you can edit the above <code>~/.bashrc</code> snippet to match your needs.

Hopefully this will help you be more productive, I know it's helping me!

Happy hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
