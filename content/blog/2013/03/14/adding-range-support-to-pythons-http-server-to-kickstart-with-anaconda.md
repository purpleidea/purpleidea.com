+++
date = "2013-03-14 00:34:19"
title = "adding range support to python's http server to kickstart with anaconda"
draft = "false"
categories = ["technical"]
tags = ["anaconda", "centos/rhel", "devops", "http-range", "httpd", "kickstart", "puppet", "python", "range"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/03/14/adding-range-support-to-pythons-http-server-to-kickstart-with-anaconda/"
+++

I've been working on automatic installs using <a href="https://fedoraproject.org/wiki/Anaconda/Kickstart">kickstart</a> and puppet. I'm using a modified <em>python httpserver</em> because it's lightweight, and easy to integrate into my existing python code base. The server was churning away perfectly until anaconda started downloading the full rpm's for installation. What was going wrong?
<pre>
Traceback (most recent call last):
[...]
error: [Errno 32] Broken pipe
BorkedError: See <a href="/blog/">TTBOJ</a> for explanation and discussion
</pre>
As it turns out, anaconda first downloads the headers, and then later requests the full rpm with an <a href="https://en.wikipedia.org/wiki/Byte_serving">http range request</a>. This second range request which begins at byte 1384, causes the "simple" httpserver to bork, because it doesn't support this more elaborate feature.

After a bit of searching, I found <a href="https://github.com/smgoller/rangehttpserver">rangehttpserver</a> and was very grateful that I wouldn't have to write this feature myself. This work by <em>smgoller</em> was based on the similar <a href="http://xyne.archlinux.ca/projects/python2-xynehttpserver/">httpserver</a> by <em>xyne</em>. Both of these people have been very responsive and kind in giving me special permission to the relevant portions of their code that I needed under the GPLv2/3+. Thanks to these two and their contribution to <a href="http://www.gnu.org/philosophy/free-sw.html">Free Software</a> this let's us all <a href="https://en.wikipedia.org/wiki/Standing_on_the_shoulders_of_giants">see further</a>, instead of having to reinvent previously solved problems.

This <a href="https://gist.githubusercontent.com/purpleidea/7255c478e5f350a4f0a6690078d02619/raw/da8058a632566d46316f530a6eac2fd7431efd96/httpdaemon.py">derivative work</a> is only one part of a larger software release that I have coming shortly, but I wanted to put this out here early to thank these guys and to make you all aware of the range issue and solution.

Thank you again and,
Happy Hacking,

James

