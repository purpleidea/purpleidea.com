+++
date = "2017-10-17 21:22:05"
title = "Copyleft is Dead. Long live Copyleft!"
draft = "false"
categories = ["non-technical"]
tags = ["legal", "mgmt", "planetfedora", "copyleft", "helpwanted", "fedora", "planetpuppet", "mgmtconfig", "planetfreeipa", "puppet", "devops", "gnome", "openstack", "gluster", "gpl", "freeipa", "501c6", "red hat"]
author = "jamesjustjames"
+++

As you may have noticed, we recently re-licensed <a href="https://github.com/purpleidea/mgmt/">mgmt</a> from the <a href="https://www.gnu.org/licenses/why-affero-gpl.html">AGPL</a> (<em>Affero</em> General Public License) to the regular <a href="https://www.gnu.org/licenses/quick-guide-gplv3.html">GPL</a>. This is a post explaining the decision and which hopefully includes some insights at the intersection of technology and legal issues.

<span style="text-decoration:underline;">Disclaimer</span>:

I am not a lawyer, and these are not necessarily the opinions of my employer. I think I'm knowledgeable in this area, but I'm happy to be corrected in the comments. I'm friends with a number of lawyers, and they like to include disclaimer sections, so I'll include this so that I blend in better.

<span style="text-decoration:underline;">Background</span>:

It's well understood in infrastructure coding that the control of, and trust in the software is paramount. It can be risky basing your business off of a product if the vendor has the ultimate ability to change the behaviour, discontinue the software, make it prohibitively expensive, or in the extreme case, use it as a <a href="https://en.wikipedia.org/wiki/Backdoor_(computing)">backdoor</a> for <a href="https://en.wikipedia.org/wiki/Industrial_espionage">corporate espionage</a>.

While many businesses have realized this, it's unfortunate that many individuals have not. The difference might be protecting corporate secrets vs. <a href="https://en.wikipedia.org/wiki/Canadian_Charter_of_Rights_and_Freedoms">individual freedoms</a>, but that's a discussion for another time. I use <a href="https://getfedora.org/">Fedora</a> and <a href="https://www.gnome.org/">GNOME</a>, and don't have any <a href="https://stallman.org/apple.html">Apple</a> products, but you might value the <a href="https://en.wikiquote.org/wiki/Benjamin_Franklin#Quotes">temporary convenience</a> more. I also support your personal choice to use the software you want. (Not sarcasm.)

This is one reason why <a href="https://redhat.com/">Red Hat</a> has done so well. If they ever mistreated their customers, they'd be able to <a href="https://en.wikipedia.org/wiki/Fork_(software_development)">fork</a> and grow new communities. The lack of an asymmetrical power dynamic keeps customers feeling safe and happy!

<span style="text-decoration:underline;">Section 13</span>:

The main difference between the AGPL and the GPL is the "Remote Network Interaction" section. Here's a simplified explanation:

Both licenses require that if you modify the code, you give back your contributions. "<a href="https://en.wikipedia.org/wiki/Copyleft">Copyleft</a>" is <a href="https://en.wikipedia.org/wiki/Copyright">Copyright law</a> that legally requires this <a href="https://en.wikipedia.org/wiki/Share-alike">share-alike</a> provision. These licenses never require this when using the software privately, whether as an individual or within a company. The thing that "activates" the licenses is distribution. If you <a href="https://www.gnu.org/philosophy/selling.html">sell</a> or give someone a modified copy of the program, then you must also include the source code.

The AGPL extends the GPL in that it also activates the license if that software runs on a application providers computer which is common with hosted <a href="https://www.gnu.org/philosophy/who-does-that-server-really-serve.en.html">software-as-a-service</a>. In other words, if you were an external user of a web calendaring solution containing AGPL software, then that provider would have to offer up the code to the application, whereas the GPL would not require this, and <a href="https://www.gnu.org/licenses/gpl-faq.html#InternalDistribution">neither license would require distribution of code if the application was only available to employees of that company</a> nor would it require distribution of the software used to deploy the calendaring software.

<span style="text-decoration:underline;">Network Effects and Configuration Management</span>:

If you're familiar with the infrastructure automation space, you're probably already aware of three interesting facts:

<ol>
    <li>Hosted configuration management as a service probably isn't plausible</li>
    <li><a href="https://www.gnu.org/licenses/gpl-faq.html#AGPLv3InteractingRemotely">The infrastructure automation your product uses isn't the product</a></li>
    <li><a href="https://www.gnu.org/licenses/gpl-faq.en.html#CanIUseGPLToolsForNF">Copyleft does not apply to the code or declarations that describe your configuration</a></li>
</ol>

As a result of this, it's unlikely that the Section 13 requirement of the AGPL would actually ever apply to anyone using mgmt!

A number of high profile organizations outright forbid the use of the AGPL. <a href="https://opensource.google.com/docs/using/agpl-policy/">Google</a> and <a href="https://governance.openstack.org/tc/reference/licensing.html">Openstack</a> are two notable examples. There are others. Many claim this is because the cost of legal compliance is high. One argument I heard is that it's because they live in fear that their entire proprietary software development business would be turned on its head if some sufficiently important library was AGPL. Despite weak enforcement, and with <a href="http://gpl-violations.org/">many companies flouting the GPL</a>, <a href="https://en.wikipedia.org/wiki/Linux">Linux</a> and the software industry have not shown signs of waning. <a href="https://en.wikipedia.org/wiki/Linksys_WRT54G_series#WRT54GL">Compliance has even helped their bottom line</a>.

Nevertheless, as a result of misunderstanding, fear and doubt, using the AGPL still cuts off a portion of your potential contributors. <a href="https://opensource.com/article/17/8/patrick-mchardy-and-copyright-profiteering">Possible overzealous enforcing</a> has also probably caused some to fear the GPL.

<span style="text-decoration:underline;">Foundations and Permissive Licensing</span>:

Why use copyleft at all? Copyleft is an inexpensive way of keeping the various contributors honest. It provides an organization constitution so that community members that invest in the project all get a fair, representative stake.

In the corporate world, there is a lot of governance in the form of "foundations". The most well-known ones exist in the United States and are usually classified as <a href="https://en.wikipedia.org/wiki/501(c)_organization#501.28c.29.286.29">501(c)(6)</a> under US Federal tax law. They aren't allowed to generate a profit, but they exist to fulfill the desires of their <a href="https://en.wiktionary.org/wiki/dues#English">dues</a>-paying membership. You've probably heard of the <a href="https://en.wikipedia.org/wiki/Linux_Foundation">Linux Foundation</a>, the <a href="https://dotnetfoundation.org/about">.NET foundation</a>, the <a href="https://www.openstack.org/legal/bylaws-of-the-openstack-foundation/">OpenStack Foundation</a>, and the recent Linux Foundation child, the <a href="https://www.cncf.io/">CNCF</a>. With the major exception being Linux, they primarily fund permissively licensed projects since that's what their members demand, and the foundation probably also helps convince some percentage of their membership into voluntarily contributing back code.

Running an organization like this is possible, but it certainly adds a layer of overhead that I don't think is necessary for mgmt at this point.

It's also interesting to note that of the <a href="https://octoverse.github.com/">top corporate contributions</a> to open source, virtually all of the licensing is permissive, usually under the Apache v2 license. I'm not against using or contributing to permissively licensed projects, but I do think there's a danger if most of our software becomes a <a href="https://en.wikipedia.org/wiki/Monoculturalism">monoculture</a> of non-copyleft, and I wanted to take a stand against that trend.

<span style="text-decoration:underline;">Innovation</span>:

I started mgmt to show that there was still innovation to be done in the automation space, and I think I've <a href="https://roidelapluie.be/blog/2017/02/09/mgmt/">achieved that</a>. I still have more to prove, but I think I'm on the right path. I also wanted to innovate in licensing by showing that the AGPL isn't actually  harmful. I'm sad to say that I've lost that battle, and that maybe it was too hard to innovate in too many different places simultaneously.

Red Hat has been my main source of funding for this work up until now, and I'm grateful for that, but I'm sad to say that they've officially set my time quota to zero. Without their support, I just don't have the energy to innovate in both areas. I'm sad to say it, but I'm more interested in the technical advancements than I am in the <a href="https://www.gnu.org/philosophy/free-sw.html">licensing progress</a> it might have brought to our software ecosystem.

<span style="text-decoration:underline;">Conclusion / TL;DR</span>:

If you, your organization, or someone you know would like to help fund my <a href="https://github.com/purpleidea/mgmt/">mgmt</a> work either via a development grant, contract or offer of employment, or if you'd like to be a contributor to the project, please let me know! Without your support, <a href="https://github.com/purpleidea/mgmt/">mgmt</a> <strong><em>will</em></strong> die.

Happy Hacking,

James

<em>You can <a href="https://twitter.com/intent/follow?screen_name=purpleidea">follow James on Twitter</a> for more frequent updates and other random noise.</em>

<strong>EDIT:</strong> I mentioned in my article that: "<em>Hosted configuration management as a service probably isn’t plausible</em>". Turns out I was wrong. The splendiferous <a href="https://twitter.com/nathenharvey">Nathen Harvey</a> was kind enough to point out that <a href="https://www.chef.io/pricing/#hostedchef">Chef offers a hosted solution</a>! It's free for five hosts as well!

I was probably thinking more about how I would be using mgmt, and not about the greater ecosystem. If you'd like to build or use a hosted mgmt solution, please let me know!

