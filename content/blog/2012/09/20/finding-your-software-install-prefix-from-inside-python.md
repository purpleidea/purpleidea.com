+++
date = "2012-09-20 04:12:00"
title = "finding your software install $prefix from inside python"
draft = "false"
categories = ["technical"]
tags = ["agpl3", "devops", "distutils", "prefix", "python"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/09/20/finding-your-software-install-prefix-from-inside-python/"
+++

Good python software developers tend to use <a href="http://docs.python.org/library/distutils.html">distutils</a> and include a setup.py with their code. The problem I often encounter is finding out which prefix your software has been installed in from within the python code. This might be necessary if you want to interact with some data that you've installed into: $prefix/share/projectname/ Here are the various steps:

<strong>1) <span style="text-decoration:underline;">Distutils</span>:</strong>
{{< highlight python >}}
NAME='someproject'
distutils.core.setup(
    name=NAME,
    version='0.1',
    author='James Shubin',
    author_email='secret@purpleidea.com',
    url='https://purpleidea.com/',
    description='This is an example project',
    # http://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        'Environment :: Console',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: GNU Affero General Public License v3',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Python',
        'Topic :: Utilities',
    ],
    packages=[NAME],
    package_dir={NAME: 'src'},
    data_files=[
        ('share/%s' % NAME, ['README']),
        ('share/%s' % NAME, ['images/something.png']),
    ],
    scripts=['somebin'],
)
{{< /highlight >}}

<strong>2) <span style="text-decoration:underline;">Install</span>:</strong>
```
python setup.py install --prefix=~/testprefix/
```
<em>Note: If you don't specify a prefix, then this will get installed into your system prefix.</em>

<strong>3) <span style="text-decoration:underline;">Run</span>:</strong>
```
cd ~/testprefix/ # the prefix you chose above
PYTHONPATH=lib/python2.7/site-packages/ ./bin/somebin
```
<em>Note: If you didn't specify a prefix above, then you don't need to set the PYTHONPATH variable, and also, the executable will already be in your default $PATH</em>

<strong>4) <span style="text-decoration:underline;">Prefix</span>:</strong>

I have written a small python module which I include in all of my python software. It will returns the projects installed prefix when run. I usually use it like so:
```
print 'something.png is located at: %s' % os.path.join(prefix.prefix(), 'share', NAME, 'images', 'something.png')
```
<strong>5) <span style="text-decoration:underline;">Code</span>:</strong>

Here is the code for <em>prefix.py</em>. I put this file under my <em>projectname/src/</em> directory.

{{< highlight python >}}
#!/usr/bin/python
# -*- coding: utf-8 -*-
"""Find the prefix of the current installation, and other useful variables.

Finding the prefix that your program has been installed in can be non-trivial.
This simplifies the process by allowing you to import <packagename>.prefix and
get instant access to the path prefix by calling the function named: prefix().
If you'd like to join this prefix onto a given path, pass it as the first arg.

Example: if [ `./prefix.py` ]; then echo yes; else echo no; fi
Example: x=`./prefix.py`; echo 'prefix: '$x
"""
# Copyright (C) 2010-2012  James Shubin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

__all__ = ('prefix', 'name')
#DEBUG = False

import os
import sys

def prefix(join=None):
    """Returns the prefix that this code was installed into."""
    # constants for this execution
    path = os.path.abspath(__file__)
    #if DEBUG: print 'path: %s' % path
    name = os.path.basename(os.path.dirname(path))
    #if DEBUG: print 'name: %s' % name
    this = os.path.basename(path)
    #if DEBUG: print 'this: %s' % this

    # rule set
    rules = [
        # to match: /usr/lib/python2.5/site-packages/project/prefix.py
        # or: /usr/local/lib/python2.6/dist-packages/project/prefix.py
        lambda x: x == 'lib',
        lambda x: x == ('python%s' % sys.version[:3]),
        lambda x: x in ['site-packages', 'dist-packages'],
        lambda x: x == name,    # 'project'
        lambda x: x == this,    # 'prefix.py'
    ]

    # matching engine
    while len(rules) > 0:
        (path, token) = os.path.split(path)
        #if DEBUG: print 'path: %s, token: %s' % (path, token)
        rule = rules.pop()
        if not rule(token):
            #if DEBUG: print 'rule failed'
            return False

    # usually returns: /usr/ or /usr/local/ (but without slash postfix)
    if join is None:
        return path
    else:
        return os.path.join(path, join)    # add on join if it exists!

def name(pop=[], suffix=None):
    """Returns the name of this particular project. If pop is a list
    containing more than one element, name() will remove those items
    from the path tail before deciding on the project name. If there
    is an element which does not exist in the path tail, then raise.
    If a suffix is specified, then it is removed if found at end."""
    path = os.path.dirname(os.path.abspath(__file__))
    if isinstance(pop, str): pop = [pop]    # force single strings to list
    while len(pop) > 0:
        (path, tail) = os.path.split(path)
        if pop.pop() != tail:
            #if DEBUG: print 'tail: %s' % tail
            raise ValueError('Element doesnʼt match path tail.')

    path = os.path.basename(path)
    if suffix is not None and path.endswith(suffix):
        path = path[0:-len(suffix)]
    return path

if __name__ == '__main__':
    join = None
    if len(sys.argv) > 1:
        join = ' '.join(sys.argv[1:])
    result = prefix(join)
    if result:
        print result
    else:
        sys.exit(1)
{{< /highlight >}}
Why this sort of thing isn't built into python boggles my mind, so if for some reason you have a better solution, please let me know. Also, don't be fooled by the red herring that is: sys.prefix

Happy hacking,
James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
