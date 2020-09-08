---
title: "Les Garderies K.I.D.S. Infrastructure"
image: "les-garderies-kids.png"
ordering: "c"
draft: false
---

*Les Garderies K.I.D.S.* is a chain of daycares in the Montreal region. I completed a
number of projects for this group. Below you can find a select list of projects,
some associated photos, and [testimonials](#testimonials).

### Video Viewing Screens

{{< blog-image src="viewscreen1.png" caption="One of the video viewing screens." scale="100%" >}}

Daycare staff needed access to live video streams of different areas of the
daycares so that they can keep watch of everything going on. For this I
installed a number of PoE cameras alonside custom video viewing screens which
were placed around the daycares.

{{< blog-image src="viewscreen2.png" caption="Seeing how its put together." scale="100%" >}}

Each viewing screen system was built from a PoE enabled Rasperry Pi computer,
and some custom software. They each display a `3x3` grid of live camera feeds.
The system is programmed to automatically turn on at the start of opening hours
and turn off at the end of each day.

{{< blog-image src="viewscreen3.png" caption="A variant mounted on plywood to hide pre-existing wall damage." scale="100%" >}}

### Card Access System

{{< blog-image src="cardaccess1.png" caption="Two installed RFID card access / doorbell systems with a display screen undergoing a video test." scale="100%" >}}

A series of different card access (RFID) keypad/doorbells were installed. These
limit access to only those who are allowed entry, and only during opening hours.

{{< blog-image src="cardaccess2.png" caption="Wiring for electromagnetic strike and networking that is hidden in the ceiling." scale="100%" >}}

All of the wiring was done neatly and kept accessible but hidden in case future
maintenance or repairs need to be done. The power for the electromagnetic door
strikes are centralized so that only a single power supply is needed, and that
the doors continue to work if there is a power failure.

{{< blog-image src="cardaccess3.png" caption="Centralized power for all of the electromagnetic door strikes in the building which runs off of a UPS." scale="100%" >}}

Installation of the readers is fairly straight-forward if you're good at
manipulating small wires and have the skills to fish cables in difficult
locations.

{{< blog-image src="cardaccess4.png" caption="Installation of a card access reader." scale="100%" >}}
{{< blog-image src="cardaccess5.png" caption="Close-up of the card access wiring." scale="100%" >}}
{{< blog-image src="cardaccess6.png" caption="Card access reader is almost installed." scale="100%" >}}
{{< blog-image src="cardaccess7.png" caption="Installed and working keypad and door strike, and can be used as card access (RFID) and as an audio doorbell." scale="100%" >}}

The coordinator computer has access to a single database that she modifies to
select which parents and staff have access, to which doors, and on which
schedules. When the database is modified, a custom script written in `golang`
talks to the API of each card access keypad to declaratively program the user
access tables. The keypads themselves are provisioned automatically with
[mgmt](/projects/mgmt-config/).

### Core Networking and Routing

Their newest location has a modern, entirely IP system. The location was wired
with 72 drops. These were used to wire IP telephones, IP cameras, video viewing
stations, electronic information display screens, computers, printers, card
access door entry and doorbell systems and building-wide and outdoor wireless
networking. A patch panel system was chosen to enable the customer to make fast,
easy changes to their network as the need arises.

{{< blog-image src="rack1.png" caption="Facing the main rack." scale="100%" >}}

The system begins with a Linux-powered software router and firewall. This system
also provides dhcp, runs scheduled tasks (powering on/off of certain devices
after hours) and hosts an [IRCdns](https://github.com/purpleidea/ircdns/) server
for remote access.

{{< blog-image src="rack2.png" caption="The router/firewall/etc is a Linux machine running CentOS and can be seen at the top right." scale="100%" >}}

Power for the electromagnetic door-latches is centralized and UPS-powered, as is
all of the networking infrastructure. Since the phones and cameras are also PoE
powered, all of this infrastructure keeps working in the event of a power
outage. All outside devices have proper grounding and surge protection. The
telephone system and door-access system is a SIP phone system powered by a local
Asterisk server. It provides voicemail, paging, door DTMF opening, and many
other features. The individual phones and door-access keypads are provisioned
automatically with [mgmt](/projects/mgmt-config/).

{{< blog-image src="rack3.png" caption="Cabling was done as elegantly as possible, but drops were not actually combed, as the customer wanted to save on installation costs." scale="100%" >}}

### Satellite networks

There are a few smaller networks at different locations. Each has a small rack
and Linux powered router/firewall.

{{< blog-image src="gkp1.png" caption="New patch panel in progress." scale="100%" >}}
{{< blog-image src="gkp2.png" caption="The installation here is very compact, uses a vertical rack and is close to the ceiling because space is at a premium in this location." scale="100%" >}}
{{< blog-image src="gkf1.png" caption="Networking gear for computers, printers, wireless, cameras and viewscreens." scale="100%" >}}
{{< blog-image src="gkf2.png" caption="A close-up of the nicely labelled rack." scale="100%" >}}

### Testimonials

{{< blockquote text="James was instrumental to bringing our operations into the 21st  century, with our own private server, video monitoring, and telephony. His wiring was impeccable, with virtually no damage or visible modifications to our facilities. Most importantly, we were never told what we cannot do, rather given options for how to achieve our goals." author="Mitchell Vatch, Executive Vice President, Les Garderies K.I.D.S." >}}

{{< blockquote text="James is very knowledgeable at what he does, he is efficient and gets the work done quickly. James is nice to work with and has a positive attitude. He installed our phone system, computers, cameras, card access system and electronic information display screens. He provided the step-by step instructions to ensure that we were able to learn the new system with ease. We are extremely pleased with his work and would highly recommend him." author="Stephanie Parker, Coordinator of K.I.D.S. Premiere Location" >}}


