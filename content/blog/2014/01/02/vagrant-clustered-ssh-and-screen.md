+++
date = "2014-01-02 00:40:49"
title = "Vagrant clustered SSH and &#039;screen&#039;"
draft = "false"
categories = ["technical"]
tags = ["screen", "ssh", "fedora", "cssh", "devops", "planetdevops", "planetfedora", "vagrant", "vsftp", "clustered ssh", "planetpuppet", "puppet", "sftp", "gluster", "vcssh", "vscreen", "bash"]
author = "jamesjustjames"
+++

Some fun updates for vagrant hackers... I wanted to use the venerable clustered SSH (<code>cssh</code>) and <code>screen</code> with vagrant. I decided to expand on my <a href="https://gist.github.com/purpleidea/8071962#file-bashrc_vagrant-sh-L17"><code>vsftp</code></a> script. First read:
<blockquote>
<p style="text-align:center;"><strong><a title="Vagrant on Fedora with libvirt" href="https://ttboj.wordpress.com/2013/12/09/vagrant-on-fedora-with-libvirt/">Vagrant on Fedora with libvirt</a></strong></p>
</blockquote>
and
<blockquote>
<p style="text-align:center;"><strong><a title="Vagrant vsftp and other tricks" href="https://ttboj.wordpress.com/2013/12/21/vagrant-vsftp-and-other-tricks/">Vagrant vsftp and other tricks</a></strong></p>
</blockquote>
to get up to speed on the background information.

<strong><span style="text-decoration:underline;">Vagrant screen</span>:</strong>

First, a simple <code>screen</code> hack... I often use my <code>vssh</code> alias to quickly ssh into a machine, but I don't want to have to waste time with <code>sudo</code>-ing to <em>root</em> and then running <code>screen</code> each time. Enter <code>vscreen</code>:

```bash
# vagrant screen
function vscreen {
	[ "$1" = '' ] || [ "$2" != '' ] && echo "Usage: vscreen <vm-name> - vagrant screen" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	f="$d/$1.config"
	h="$1"
	# hostname extraction from user@host pattern
	p=`expr index "$1" '@'`
	if [ $p -gt 0 ]; then
		let "l = ${#h} - $p"
		h=${h:$p:$l}
	fi

	# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
	if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
		mkdir -p "$d"
		# we cache the lookup because this command is slow...
		vagrant ssh-config "$h" > "$f" || rm "$f"
	fi
	[ -e "$f" ] && ssh -t -F "$f" "$1" 'screen -xRR'
}
```
I usually run it this way:
```
$ vscreen root@machine
```
which logs in as <em>root</em>, to <em>machine</em> and gets me (back) into <code>screen</code>. This is almost identical to the <em>vsftp</em> script <a title="Vagrant vsftp and other tricks" href="http://ttboj.wordpress.com/2013/12/21/vagrant-vsftp-and-other-tricks/">which I explained in an earlier blog post</a>.

<strong><span style="text-decoration:underline;">Vagrant cssh</span>:</strong>

First you'll need to install <code>cssh</code>. On my Fedora machine it's as easy as:
```
# yum install -y clusterssh
```
I've been hacking a lot on <a title="puppet-gluster" href="http://ttboj.wordpress.com/code/puppet-gluster/">Puppet-Gluster</a> lately, and occasionally multi-machine hacking demands multi-machine key punching. Enter <code>vcssh</code>:

```bash

# vagrant cssh
function vcssh {
	[ "$1" = '' ] && echo "Usage: vcssh [options] [user@]<vm1>[ [user@]vm2[ [user@]vmN...]] - vagrant cssh" 1>&2 && return 1
	wd=`pwd`		# save wd, then find the Vagrant project
	while [ "`pwd`" != '/' ] && [ ! -e "`pwd`/Vagrantfile" ] && [ ! -d "`pwd`/.vagrant/" ]; do
		#echo "pwd is `pwd`"
		cd ..
	done
	pwd=`pwd`
	cd $wd
	if [ ! -e "$pwd/Vagrantfile" ] || [ ! -d "$pwd/.vagrant/" ]; then
		echo 'Vagrant project not found!' 1>&2 && return 2
	fi

	d="$pwd/.ssh"
	cssh="$d/cssh"
	cmd=''
	cat='cat '
	screen=''
	options=''

	multi='f'
	special=''
	for i in "$@"; do	# loop through the list of hosts and arguments!
		#echo $i

		if [ "$special" = 'debug' ]; then	# optional arg value...
			special=''
			if [ "$1" -ge 0 -o "$1" -le 4 ]; then
				cmd="$cmd $i"
				continue
			fi
		fi

		if [ "$multi" = 'y' ]; then	# get the value of the argument
			multi='n'
			cmd="$cmd '$i'"
			continue
		fi

		if [ "${i:0:1}" = '-' ]; then	# does argument start with: - ?

			# build a --screen option
			if [ "$i" = '--screen' ]; then
				screen=' -o RequestTTY=yes'
				cmd="$cmd --action 'screen -xRR'"
				continue
			fi

			if [ "$i" = '--debug' ]; then
				special='debug'
				cmd="$cmd $i"
				continue
			fi

			if [ "$i" = '--options' ]; then
				options=" $i"
				continue
			fi

			# NOTE: commented-out options are probably not useful...
			# match for key => value argument pairs
			if [ "$i" = '--action' -o "$i" = '-a' ] || \
			[ "$i" = '--autoclose' -o "$i" = '-A' ] || \
			#[ "$i" = '--cluster-file' -o "$i" = '-c' ] || \
			#[ "$i" = '--config-file' -o "$i" = '-C' ] || \
			#[ "$i" = '--evaluate' -o "$i" = '-e' ] || \
			[ "$i" = '--font' -o "$i" = '-f' ] || \
			#[ "$i" = '--master' -o "$i" = '-M' ] || \
			#[ "$i" = '--port' -o "$i" = '-p' ] || \
			#[ "$i" = '--tag-file' -o "$i" = '-c' ] || \
			[ "$i" = '--term-args' -o "$i" = '-t' ] || \
			[ "$i" = '--title' -o "$i" = '-T' ] || \
			[ "$i" = '--username' -o "$i" = '-l' ] ; then
				multi='y'	# loop around to get second part
				cmd="$cmd $i"
				continue
			else			# match single argument flags...
				cmd="$cmd $i"
				continue
			fi
		fi

		f="$d/$i.config"
		h="$i"
		# hostname extraction from user@host pattern
		p=`expr index "$i" '@'`
		if [ $p -gt 0 ]; then
			let "l = ${#h} - $p"
			h=${h:$p:$l}
		fi

		# if mtime of $f is > than 5 minutes (5 * 60 seconds), re-generate...
		if [ `date -d "now - $(stat -c '%Y' "$f" 2> /dev/null) seconds" +%s` -gt 300 ]; then
			mkdir -p "$d"
			# we cache the lookup because this command is slow...
			vagrant ssh-config "$h" > "$f" || rm "$f"
		fi

		if [ -e "$f" ]; then
			cmd="$cmd $i"
			cat="$cat $f"	# append config file to list
		fi
	done

	cat="$cat > $cssh"
	#echo $cat
	eval "$cat"			# generate combined config file

	#echo $cmd && return 1
	#[ -e "$cssh" ] && cssh --options "-F ${cssh}$options" $cmd
	# running: bash -c glues together --action 'foo --bar' type commands...
	[ -e "$cssh" ] && bash -c "cssh --options '-F ${cssh}${screen}$options' $cmd"
}
```
This can be called like this:
```
$ vcssh annex{1..4} -l root
```
or like this:
```
$ vcssh root@hostname foo user@bar james@machine --action 'pwd'
```
which, as you can see, passes <code>cssh</code> arguments through! Can you see any other special surprises in the code? Well, you can run <code>vcssh</code> like this too:
```
$ vcssh root@foo james@bar --screen
```
which will perform exactly as <code>vscreen</code> did above, but in <code>cssh</code>!

You'll see that the <code>vagrant ssh-config</code> lookups are cached, so this will be speedy when it's running hot, but expect a few seconds delay when you first run it. If you want a longer cache timeout, it's easy to change yourself in the function.

<a href="https://gist.github.com/purpleidea/8071962">I've uploaded the code here, so that you don't have to copy+paste it from my blog!</a>

Happy hacking,

James

