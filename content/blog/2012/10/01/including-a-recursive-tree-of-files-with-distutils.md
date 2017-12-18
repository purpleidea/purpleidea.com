+++
date = "2012-10-01 06:17:58"
title = "including a recursive tree of files with distutils"
draft = "false"
categories = ["technical"]
tags = ["data_files", "devops", "distutils", "installation directory", "python", "python programmers"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2012/10/01/including-a-recursive-tree-of-files-with-distutils/"
+++

It turns out it is non trivial (afaict) to include a tree of files (a directory) in a python distutils data_files argument. Here's how I managed to do it, while also allowing the programmer to include manual entries:
{{< highlight python >}}
NAME = 'project_name'
distutils.core.setup(
# ...
    data_files=[
        ('share/%s' % NAME, ['README']),
        ('share/%s' % NAME, ['files/somefile']),
        ('share/%s/templates' % NAME, [
            'files/templates/template1.tmpl',
            'files/templates/template2.tmpl',
        ]),
    ] + [('share/%s/%s' % (NAME, x[0]), map(lambda y: x[0]+'/'+y, x[2])) for x in os.walk('the_directory/')],
# ...
)
{{< /highlight >}}

Since data_files is a list, I've just appended our specially generated list to the end. You can do this as many times as you wish. The list is a comprehension which builds each tuple as it walks through the requested directory. I've chosen a root installation directory of <em>${prefix}/share/project_name/the_directory/</em> but you can change this code to match your own specifications.

Strangely, I couldn't find this solution when searching the Internets, so I had to write it myself. Perhaps my google-fu is weak, and maybe this post needs to get some linkage to help out the rest of us python programmers.

Happy hacking,
James

