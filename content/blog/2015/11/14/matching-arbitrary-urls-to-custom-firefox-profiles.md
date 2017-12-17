+++
date = "2015-11-14 06:50:35"
title = "Matching arbitrary URL&#039;s to custom Firefox profiles"
draft = "false"
categories = ["technical"]
tags = ["firefox", "gnome", "about:config", "evolution", "default applications", "planetdevops", "gluster", "firefox-redirector", "planetfedora", "gtk", "firefox-profiles", "google docs", "planetpuppet", "bash", "fedora", "protocol-handler", "devops"]
author = "jamesjustjames"
+++

We're constantly clicking on all sorts of different URL's throughout the day. These clickable links appear in webpages (including in "<a href="https://www.gnu.org/philosophy/who-does-that-server-really-serve.html">web apps</a>" like gmail) in mail clients like <a href="https://en.wikipedia.org/wiki/Evolution_%28software%29">Evolution</a>, in terminals such as <a href="https://wiki.gnome.org/Apps/Terminal">GNOME-terminal</a>, and any other <a href="https://en.wikipedia.org/wiki/GTK%2B">GTK+</a> app on your GNU/Linux desktop. I wanted to perform custom actions when arbitrary URL's are clicked, including running certain links in separate Firefox profiles. There are a bunch of different steps you have to do to get this working, but it should be easy to follow along. I'm doing all of this on <a href="https://getfedora.org/">Fedora 23</a>, but it should work on other GNU/Linux environments.

<strong><span style="text-decoration:underline;">Firefox profiles</span>:</strong>

<a href="https://en.wikipedia.org/wiki/Firefox">Firefox</a> supports multiple profiles in the same user session so that different users can share a session, or so that a single user can separate tasks into different environments. I'm interested in the latter use case. To add a new profile it's recommended to close firefox completely, but I didn't find this to be necessary. When I do close firefox, I like to surprise it with a:
```
killall -9 firefox
```
which will also cause any unsaved data in your browser to be lost. To create a new profile, now run firefox with -P:
```
firefox -P
```
This will open up a friendly dialog where you can add a new profile. After you've done this, my dialog now looks like:

[caption id="attachment_1150" align="alignnone" width="445"]<a href="https://ttboj.files.wordpress.com/2015/11/firefox-profiles.png"><img class="size-full wp-image-1150" src="https://ttboj.files.wordpress.com/2015/11/firefox-profiles.png" alt="A view of my firefox profiles as shown by running: firefox -P" width="445" height="347" /></a> A view of my firefox profiles as shown by running: firefox -P[/caption]

to test that it is working, run firefox from the command line:
```
$ firefox https://ttboj.wordpress.com/
$ firefox -P ghttps https://github.com/purpleidea/
$ firefox https://twitter.com/#!/purpleidea
$ firefox -P ghttps https://www.gnu.org/philosophy/free-sw.html
```
You should get two separate sessions, where the commands with <code>-P ghttps</code> should be in your new "<em>ghttps</em>" session (or whatever you named it). Internet searches seem to report that some users can't run two sessions at the same time without including the <code>--no-remote</code> option, but I didn't seem to need it. <a href="https://duckduckgo.com/?q=ymmv">YMMV</a>.

<strong><span style="text-decoration:underline;">Firefox launcher</span>:</strong>

When you run firefox, it usually runs <code>/usr/bin/firefox</code>. I want <a href="/post/2013/03/22/running-your-file-manager-from-a-terminal/">a more clever launcher</a>, so I've created a new bash script named <code>~/bin/firefox</code> which is part of my path. The contents of this file are:
```
#!/bin/bash
# run firefox from a terminal, without being attached to it; similar to nohup
# thanks to @purpleidea from https://ttboj.wordpress.com/
# TODO: a better argv parser and more flexible url matching semantics
# NOTE: first close firefox and make a new profile with `firefox -P`, then set:
protocol='ghttps' # name of fake protocol
profile='ghttps' # name of your new firefox profile
prefix='https://example.com/'
argv=("$@")
argc=$(($# - 1))
url=''
if [ $argc -ge 0 ]; then
    url=${argv[$argc]}
    # avoid recursion!
    if [[ "$url" == "$protocol"* ]]; then
        url="https${url:${#protocol}}" # s/ghttps/https/
        argv[$argc]=$url # store it
    fi
fi

#echo $url
#echo "`date` ${argv[*]}" >> /tmp/firefox.log

# use a separate profile for special links
if [ "$url" != "" ] && [[ "$url" == "$prefix"* ]]; then
    # firefox with profile
    { `/usr/bin/firefox -P "$profile" "${argv[@]}" &> /dev/null`; } &
else
    # normal firefox
    { `/usr/bin/firefox "${argv[@]}" &> /dev/null`; } &
fi
```
Make sure the file is executable with <code>chmod u+x ~/bin/firefox</code> and in your $PATH. Now whenever you run the <code>firefox</code> program, it will automatically run firefox with a profile that corresponds to the pattern of URL that you matched. Feel free to improve this script with a more comprehensive pattern to profile correspondence mechanism.

<strong><span style="text-decoration:underline;">Default applications</span>:</strong>

Whenever any URL is clicked within GNOME, there is a central "Default Applications" setting which decides what application to run. My settings dialog for this control now looks like:

[caption id="attachment_1152" align="alignnone" width="660"]<a href="https://ttboj.files.wordpress.com/2015/11/gnome-default-applications.png"><img class="size-large wp-image-1152" src="https://ttboj.files.wordpress.com/2015/11/gnome-default-applications.png?w=660" alt="What the GNOME Settings->Details->Default Applications dialog looks like after I made one small change." width="660" height="462" /></a> What the GNOME Settings->Details->Default Applications dialog looks like after I made the change.[/caption]

I had to change the "Web" handler to be a "MyFirefox" instead of the previous default of "Firefox". Those applications are listed in <code>.desktop</code> files which exist on your system. The system wide firefox desktop file is located at: <code>/usr/share/applications/firefox.desktop</code> and although the path to the executable in this file does not set a directory prefix, it unfortunately does not seem to obey my shell $PATH which includes <code>~/bin/</code>. If you know how to set this so <code>.desktop</code> files include <code>~/bin/</code> in their search, then I'd really appreciate it if you left me a comment!

To work around the $PATH issue, I copied the above file into <code>~/.local/share/applications/firefox.desktop</code> and edited it so that the three <code>Exec=</code> commands include a path prefix of <code>/home/james/bin/</code>. I also renamed the <code>Name=</code> entry so that it was visually obvious that a different <code>.desktop</code> file was in use. This will replace the firefox launcher throughout your desktop and as well in the "Default Applications" menu.

An excerpt of my file showing only the changed sections now looks like:
```
[Desktop Entry]
Name=MyFirefox
Comment=Browse the Web better
Exec=/home/james/bin/firefox %u
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=Open a New Window
Exec=/home/james/bin/firefox %u

[Desktop Action new-private-window]
Name=Open a New Private Window
Exec=/home/james/bin/firefox --private-window %u
```
Changing the name is optional, but it might be instructional for you.

It's important that you not rename the file, because only files which are listed in one of the GNOME mime list files will show up in the "Default Applications" chooser. Once you've created the file, you can check in these settings to ensure it's set as the default.

I forget if you need to close firefox, and logout and then back in to your GNOME session for this to work, so if things aren't working perfectly by now, ensure you've done that once. You can test this by clicking on a link in your terminal and checking to see that it opens the correct firefox.

<strong><span style="text-decoration:underline;">Redirecting internal firefox links</span>:</strong>

Everything should now be working perfectly, until you click on a link <em>within</em> firefox which doesn't redirect to your shell firefox wrapper. We want this to be seamless, so we'll have to hack into the firefox API for that. Thankfully there's a plugin which already does this for us, so we can use it and avoid getting our hands too dirty! It's called "<a href="https://addons.mozilla.org/en-US/firefox/addon/redirector/">Redirector</a>". Install it.

Once installed, there is a settings dialog which can add some pattern matching for us. I set up a basic pattern that corresponds to what I wrote in my <code>~/bin/firefox</code> shell script. Here's a screenshot:

[caption id="attachment_1154" align="alignnone" width="660"]<a href="https://ttboj.files.wordpress.com/2015/11/firefox-redirector.png"><img class="size-large wp-image-1154" src="https://ttboj.files.wordpress.com/2015/11/firefox-redirector.png?w=660" alt="A screenshot from the firefox Redirector plugin." width="660" height="654" /></a> A screenshot from the firefox Redirector plugin.[/caption]

You can conveniently import and export your redirects from the plugin, and so I've included the <a href="https://gist.github.com/purpleidea/385ba877f484d04c6974">corresponding <code>.json</code> equivalent</a> for your convenience.

Does everything look correct? Take a second to have a closer look. You might think that I made a typo in the "Redirect to:" field". There's no such protocol as <em>ghttps</em> you say? That's good news, because its use was intentional.

<strong><span style="text-decoration:underline;">Custom protocol handlers</span>:</strong>

Running an external command in response to certain links is what allows them to open external programs such as mail clients, PDF viewers, and image viewers. While some of these functions have been pulled into the browser, the need is still there and this is what we'll use to trigger our firefox shell script. It's actually important that we make an external system call because otherwise there would no way for a link in the default browser profile to open in browser profile number two. Running any such command is only possible with a custom or unique protocol. You might be used to seeing <code>https://</code> for URL's, but since these are captured by the browser as native links, we need something different. This is what the <code>ghttps://</code> that we mentioned above is for.

To add a custom protocol, you'll need to dive into your browsers internal settings. You can do this by typing <code><a href="config">about:config</a></code> in the URL bar. You'll then need to right-click and add four new settings. These are the settings I added:
```
(string)  network.protocol-handler.app.ghttps; /home/james/bin/firefox
(boolean) network.protocol-handler.expose.ghttps; false
(boolean) network.protocol-handler.external.ghttps; true
(boolean) network.protocol-handler.warn-external.ghttps; true
```
Please note that the leading values (in brackets) are the <em>types</em> that you'll need to use. Omit the semicolons, those separate the key and the corresponding value you should give it. You'll naturally want to use the correct path to your firefox script.

For reasons unknown to me, it's required to set these variables, but the protocol handler still requires that you manually verify this once. To do this, I have provided a sample link to my blog using the fake <em>ghttps</em> protocol:
<p style="text-align:center;"><a href="//ttboj.wordpress.com/">ghttps://ttboj.wordpress.com/</a></p>
When you click on it the first time, you should be prompted with a confirmation dialog that asks you to reconfirm that you're okay running this protocol, and the path to the executable. Browse to the <code>~/bin/firefox</code> and click "Remember my choice for ghttps links". The dialog looked like this:

[caption id="attachment_1159" align="alignnone" width="383"]<a href="https://ttboj.files.wordpress.com/2015/11/firefox-protocol-handler-confirm.png"><img class="size-full wp-image-1159" src="https://ttboj.files.wordpress.com/2015/11/firefox-protocol-handler-confirm.png" alt="You should only need to deal with this dialog once!" width="383" height="421" /></a> You should only need to deal with this dialog once![/caption]

If you're using a different protocol, can you make a simple HTML file and open it up in your browser:
```
<html>
<a href="ghttps://ttboj.wordpress.com/">ghttps://ttboj.wordpress.com/</a>
</html&gt;
```
At this point you may need to restart firefox. Your new protocol handler is now installed! Enjoy automatically handling special URL's.

<strong><span style="text-decoration:underline;">Bugs</span>:</strong>

There is one small usability bug which you might experience. If the link that should pattern match out to the protocol exists with a <code>target=_blank</code> (open in new window attribute) then once you've activated the link, there will be a leftover blank firefox window to close. This is a known issue in firefox which occurs with other handlers as well. If anyone can work on this issue and/or find me a link to the ticket number, I'd appreciate it.

<strong><span style="text-decoration:underline;">Curiosity</span>:</strong>

The curious might wonder what my use-case is. I've been forced to use the most unpleasant online google document system. I've decided that I didn't want to share my regular browser profile with this software, but I wanted URL integration to feel seamless, since people like to send the unique document URL's around by email and chat. The document URL's usually follow a pattern of:
<p style="text-align:center;">https://docs.google.com/a/<strong>example.com</strong>/<em>some-garbage-goes-here...</em></p>
where <code>example.com</code> is the domain your organization uses. By setting the above string as the bash firefox <code>$prefix</code> variable, and with a similar pattern in the redirector plugin, you can ensure that you'll always get documents opening up in browser sessions connected to the correct google account! This is useful if you have multiple google accounts which you wish to automatically segregate to avoid having to constantly switch between them!

<strong><span style="text-decoration:underline;">Future work</span>:</strong>

It would be great to consolidate the patterns as expressed in the Redirector database and the firefox bash script. It would probably make sense to generate a json file that both tools can use. Additional work to extend my bash script would be necessary. Patches welcome!

It would be convenient if there was an easy setup script to automate through the myriad of steps that I took you through to get this all working. If someone can provide a simple bash equivalent, I would love to have it.

<strong><span style="text-decoration:underline;">Conclusion</span>:</strong>

I hope you enjoyed this article and this set of techniques! Hopefully you can appreciate how stringing five different techniques together can produce something useful. A big thank you goes out to <a href="https://github.com/SlashLife">SlashLife</a> from the <a href="https://webchat.freenode.net/?channels=#firefox">#firefox</a> IRC channel. This user pointed me to the <a href="https://addons.mozilla.org/en-US/firefox/addon/redirector/">Redirector</a> plugin which was critical for intercepting arbitrary URL's in firefox.

Happy Hacking,

James

PS: I'd like to apologize for not posting anything in the last three months! I've been busy hacking on something big, which I'll hope to announce soon. Stay tuned and thanks for reading this far!

