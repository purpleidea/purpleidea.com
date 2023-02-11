+++
date = "2014-09-30 01:05:07"
title = "Fixing dropbox “conflicted copy” problems"
draft = "false"
categories = ["technical"]
tags = ["bash", "diff", "dropbox", "fedora", "find", "git", "gnome", "hack", "hacks", "nautilus", "planetdevops", "planetfedora", "script"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2014/09/30/fixing-dropbox-conflicted-copy-problems/"
+++

<a href="https://www.gnu.org/philosophy/who-does-that-server-really-serve.html">I usually avoid proprietary cloud services because of freedom, privacy and vendor lock-in concerns.</a> In addition, there are some excellent <em>libre</em> (and hosted) services such as <a href="https://wordpress.com/">WordPress</a>, <a href="https://www.wikipedia.org/">Wikipedia</a> and <a href="https://www.openshift.com/">OpenShift</a> which don't have the above problems. Thirdly, there are every day <a href="https://www.gnu.org/philosophy/free-sw.html">Free Software</a> tools such as <a href="https://fedoraproject.org/">Fedora GNU/Linux</a>, <a href="https://www.libreoffice.org/">Libreoffice</a>, and <a href="http://git-annex.branchable.com/assistant/">git-annex-assistant</a> which make <em>my</em> computing much more powerful. Finally, there are some hosted services that I use that don't lock me in because I use them as push-only mirrors, and I only interact with them using Free Software tools. The two examples are <a href="https://github.com/purpleidea/">GitHub</a> and <a href="https://db.tt/svmqLvX7">Dropbox</a>.

Today, Dropbox bit me. Here's how I saved my data.

Dropbox integrates with <a href="https://www.gnome.org/">GNOME</a>'s <a href="https://wiki.gnome.org/Apps/Nautilus">nautilus</a> to sync your data to their proprietary cloud hosting. I periodically run the dropbox client to sync any changes to my public files up to their servers. Today, the client decided that some of my newer files were older than the stored server-side versions, and promptly over-wrote my newer versions.

Thankfully I have real backups, and, to be fair, Dropbox actually renamed my newer files instead of blatantly clobbering them. My filesystem now looks like this:
```
$ tree files/
files/
|-- bar
|-- baz
|   |-- file1
|   |-- file1\ (james's\ conflicted\ copy\ 2014-09-29)
|   |-- file2\ (james's\ conflicted\ copy\ 2014-09-29).sh
|   `-- file2.sh
`-- foo
    `-- magic.sh
```
You'll note that my previously clean file system now has the "conflicted copy" versions everywhere. These are the good versions, whereas in the example above <code>file1</code> and <code>file2.sh</code> are the older unwanted versions.

I spent some time with <code>find</code> and <code>diff</code> convincing myself that this was true, and eventually I wrote a script. The script looks through the current working directory for "conflicted copy" matches, saves the unwanted versions (just in case) and then clobbers them with the good "conflicted" version.

Please look through, edit, and understand this script before running it. It might not be what you want, and it was designed to only work for me. It is <a href="https://gist.github.com/purpleidea/0ed86f735807759d455c">available as a gist</a>, and below in the body of this article.

{{< highlight bash >}}
$ cat fix-dropbox.sh 
#!/bin/bash

# XXX: use at your own risk - do not run without understanding this first!
exit 1

# safety directory
BACKUP='/tmp/fix-dropbox/'

# TODO: detect or pick manually...
NAME=`hostname`
#NAME='myhostname'
DATE='2014-09-29'

mkdir -p "$BACKUP"
find . -path "*(*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]*" -print0 | while read -d $'' -r file; do
    printf 'Found: %s\n' "$file"

    # TODO: detect or pick manually...
    #NAME='XXX'
    #DATE='2014-09-29'

    STRING=" (${NAME}'s conflicted copy ${DATE})"
    #echo $STRING
    RESULT=`echo "$file" | sed "s/$STRING//"`
    #echo $RESULT

    SAVE="$BACKUP"`dirname "$RESULT"`
    #echo $SAVE
    mkdir -p "$SAVE"
    cp "$RESULT" "$SAVE"
    mv "$file" "$RESULT"

done
{{< /highlight >}}

You can thank <a href="https://www.gnu.org/software/bash/">bash</a> for saving your data. <a href="https://weev.livejournal.com/409835.html?nojs=1">Stop bashing it and read this article instead.</a>
(NOTE: I've been informed that the author of the previous link is apparently not a very nice person, to say the least. I didn't know anything about the person when I linked to it, and I'm only agreeing with this particular article and nothing else.)

Happy hacking,

James

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
