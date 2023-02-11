+++
date = "2009-11-05 11:29:16"
title = "IPVS + shorewall"
draft = "false"
categories = ["technical"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2009/11/05/ipvs-shorewall/"
+++

<a href="http://www.linuxvirtualserver.org/">lvs</a> load balancing always felt like an elusive task. here i will document how to get it working with the excellent <a href="http://www.shorewall.net/">shorewall</a> firewall, as an extension to their <a href="http://www.shorewall.net/two-interface.htm">two interface</a> common use case. this was all necessary for a group of grad students that needed to test out and develop some distributed algorithms. it turns out that once you get going, all this is quite easy and fun!

the various components and files used for this setup include:
<ul>
	<li><span style="background-color:#ffffff;">a dhcp server: /etc/dhcp3/dhcpd.conf</span></li>
	<li><span style="background-color:#ffffff;">shorewall: /etc/shorewall/*</span></li>
	<li><span style="background-color:#ffffff;">hosts file: /etc/hosts</span></li>
	<li><span style="background-color:#ffffff;">networking: /etc/network/interfaces</span></li>
	<li><span style="background-color:#ffffff;">ipvs/ipvsadm</span></li>
</ul>
let's get going. first setup the head node. for networking, you'll need a public ip and a private one. in my case /etc/network/interfaces looks like this:
```
# The loopback network interface
auto lo
iface lo inet loopback
```

```
# The primary network interface (public)
auto eth1
iface eth1 inet static
address 123.321.52.210
netmask 255.255.255.0
network 123.321.52.0
broadcast 123.321.52.255
gateway 123.321.52.253
# dns-* options are implemented by the resolvconf package, if installed
dns-nameservers 123.321.52.1 123.321.52.3
dns-search something.example.com

# The private lan
auto eth0
iface eth0 inet static
address 192.168.1.254
netmask 255.255.255.0
```

you'll notice that in the two interface default shorewall config, my eth0 is their eth1 and vice-versa. also, i've replaced my hostname and ip block with something invented. sorry! anyways, the tail of dhcpd.conf looks like this:
```
option subnet-mask 255.255.255.0;
option broadcast-address 192.168.1.255;
option routers 192.168.1.254;

subnet 192.168.1.0 netmask 255.255.255.0 {
        #range 192.168.1.10 192.168.1.100;
        host node1 {
                hardware ethernet 00:12:34:56:78:91;
                fixed-address 192.168.1.101;
        }

        host node2 {
                hardware ethernet 00:12:34:56:78:92;
                fixed-address 192.168.1.102;
        }
}
```
next to make it easier for myself to reference the nodes i'll setup /etc/hosts:
```
123.321.52.210  node.something.example.com       node
192.168.1.101   node1
192.168.1.102   node2
```
shorewall comes next. use the default two-interface setup, and add the following entries in /etc/shorewall/rules:
```
ACCEPT          net             $FW                     tcp     8000
ACCEPT          $FW             loc                     tcp     8000
```
i've decided i want to distribute port 8000. to make it easier for ipvs to figure out which packets should get load balanced, we can mark them with /etc/shorewall/tcrules:
```
1       0.0.0.0/0       132.206.52.210  tcp     8000
```
which marks them with integer: "1". lastly for ipvs, edit /etc/sysctl.conf, and add:
```
net.ipv4.ip_forward = 1
```
let the kernel know with:
```
sysctl -p
```
and then tell ipvs what is going on with:
```
ipvsadm -A -f 1 -s rr
ipvsadm -a -f 1 -r node1:8000 -m
ipvsadm -a -f 1 -r node2:8000 -m
```
the various flags are well documented in the ipvsadm man page and are self explanatory here. you can test this all out by running something at the two nodes, i used:
```
python -m SimpleHTTPServer
```
which serves the current directory with a text file named "NODE1" and "NODE2" respective to the node, and i tested that the requests alternate by pointing my browser to the head node at port 8000.

i hope this meets everyones needs for documentation and knowledge; i couldn't have done this without great ipvs <a href="http://www.ultramonkey.org/papers/lvs_tutorial/">reference</a> or the amazing <a href="http://shorewall.net/">shorewall</a>.

{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
