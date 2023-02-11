+++
date = "2009-10-07 10:24:53"
title = "the python subprocess module"
draft = "false"
categories = ["technical"]
tags = ["programming", "python", "subprocess", "subprocess.popen"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/10/07/the-python-subprocess-module/"
+++

i'm sure that i won't be able to tell you anything revolutionary which can't be found out by reading the <a href="http://docs.python.org/library/subprocess.html">manual</a>, but i thought i would clarify it, and by showing you a specific example which i needed.

<em>subprocess.Popen</em> accepts a bunch or args, one of which is the <strong>shell</strong> argument, which is False by default. If you specify <em>shell=True</em> then the first argument of popen should be a <strong>string</strong> which is what gets parsed by the shell and then eventually run. (nothing revolutionary)

the magic happens if you use shell=False (the default), in which case the first argument then accepts an <strong>array</strong> of arguments to pass. this array exactly transforms to become the sys.argv of the subprocess that you've opened with popen. magic!

this means you could pass an argument like: "hello how are you" and it will get received as one element in sys.argv, versus being split up into 4 arguments: "hello", "how", "are", "you". it's still possible to try to do some shell quoting magic, and achieve the same result, but it's <strong>much</strong> harder that way.

```
>>> _ = subprocess.Popen(['python', '-c', 'print "dude, this is sweet"'])
>>> dude, this is sweet
```
vs.

```
>>> _ = subprocess.Popen("python -c 'print "dude, this isnt so sweet"'", shell=True)
>>> dude, this isnt so sweet
```
and i'm not 100% sure how i would even add an ascii apostrophe for the <em>isn't</em>.

the second thing i should mention is that you have to remember that each argument actually needs to be split up; for example:

```
>>> _ = subprocess.Popen(['ls', '-F', '--human-readable', '-G'])
[ ls output ]
```
yes it's true that you can combine flags into one argument, but that's magic happening inside the program.

all this wouldn't be powerful if we couldn't pipe programs together. here is a simple example:

```
>>> p1 = subprocess.Popen(['dmesg'], stdout=subprocess.PIPE)
>>> p2 = subprocess.Popen(['grep', '-i', 'sda'], stdin=p1.stdout)
[ dmesg output that matches sda ]
```
i think it's pretty self explanatory. now let's say we wanted to add one more stage to the pipeline, but have it be something that usually gets executed with os.system:

```
p1 = subprocess.Popen(['dmesg'], stdout=subprocess.PIPE)
p2 = subprocess.Popen(['grep', '-i', 'sda'], stdin=p1.stdout)
p3 = subprocess.Popen(['less'], stdin=p2.stdout)
sts = os.waitpid(p3.pid, 0)
print 'all done'
```
this above example should all be pasted into a file and run; the call to waitpid is important, because it stops the interpreter from continuing on before <em>less</em> has finished executing.

hope this took the learning curve and guessing out of using the new subprocess module, (even though it actually has existed for a while...)

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
