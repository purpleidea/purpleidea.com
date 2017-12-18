+++
date = "2013-06-04 02:46:27"
title = "puppet matlab module"
draft = "false"
categories = ["technical"]
tags = ["devops", "matlab", "octave", "planetpuppet", "puppet", "puppet module"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2013/06/04/puppet-matlab-module/"
+++

I don't like repetitive work, and installing matlab counts doubly as so. Once I figured out the correct steps, I automated it with a puppet module. The downside is that the install takes a while because puppet needs to copy the <em>iso</em> locally. This is okay because I can be busy doing something else while this is happening.

Using the module is quite easy:
```
matlab::install { 'R2011a':
    iso => 'puppet://files/matlab/MATHWORKS_R2011A.iso',
    licensekey => '#####-#####-#####-#####',    # provide your own here
    licensefile => 'puppet:///files/matlab/license.lic',    # get your own!
    licenseagree => true,    # setting this to true 'acknowledges' their (C)
    prefix => '/usr/local',
}
```
You might notice that this supports installing multiple releases on the same machine. You will have to provide your own license key and license file.

This isn't routinely tested, so if the latest matlab installer changes and this breaks, please let me know. Personally, I'd recommend you use <a href="https://www.gnu.org/software/octave/">octave</a> instead, but if you really need matlab, hopefully this will make your sysadmin happier.

Enjoy a copy of the code:

<a href="https://github.com/purpleidea/puppet-matlab">https://github.com/purpleidea/puppet-matlab</a>

Happy hacking,

James

PS: matlab also supports installs that use a licensing server. This module doesn't support these at the moment, but you're welcome to send me a patch. What a waste of hardware!

