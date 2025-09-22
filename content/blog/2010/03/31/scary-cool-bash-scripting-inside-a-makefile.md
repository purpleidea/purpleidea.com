+++
date = "2010-03-31 10:05:21"
title = "scary cool bash scripting inside a Makefile"
draft = "false"
categories = ["technical"]
tags = ["babble", "bash", "bash-tutor", "dangerous", "make", "makefile", "programming"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2010/03/31/scary-cool-bash-scripting-inside-a-makefile/"
+++

<a href="http://www.gnu.org/software/make/manual/make.html">Makefiles</a> are both scary and wonderful. When both these adjectives are involved, it often makes for interesting hacking. This is likely the reason I use <a href="http://www.gnu.org/software/bash/">bash</a>.

In any case, I digress, back to real work. I use Makefiles as a general purpose tool to launch any of a number of shell scripts which I use to maintain my code, and instead of actually having external shell scripts, I just build any necessary bash right into the Makefile.

One benefit of all this is that when you type "Make &lt;target&gt;", the &lt;target&gt; can actually autocomplete which makes your shell experience that much more friendly.

In any case, let me show you the code<span style="background-color:#ffffff;"> in question. Please note the double <strong>$$</strong> for shell execution and for variable referencing. The calls to <a href="http://rsync.samba.org/">rsync</a> and <a href="http://www.gnu.org/software/coreutils/">sort</a> make me pleased.</span>
{{< highlight bash >}}
rsync -avz --include=*$(EXT) --exclude='*' --delete dist/ $(WWW)
# empty the file
echo -n '' &gt; $(METADATA)
cd $(WWW); 
for i in *$(EXT); do 
b=$$(basename $$i $(EXT)); 
V=$$(echo -n $$(basename "`echo -n "$$b" | rev`" 
"`echo -n "$(NAME)-" | rev`") | rev); 
echo $(NAME) $$V $$i &gt;&gt; $(METADATA); 
done; 
sort -V -k 2 -o $(METADATA) $(METADATA)		# sort by version key
{{< /highlight >}}

The full Makefile can be found inside of the <a href="http://www.cs.mcgill.ca/~james/code/">bash-tutor</a> tarball.

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
