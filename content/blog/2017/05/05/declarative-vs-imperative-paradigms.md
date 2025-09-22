+++
date = "2017-05-05 17:35:17"
title = "Declarative vs. Imperative paradigms"
draft = "false"
categories = ["technical"]
tags = ["ACK", "CAP theorem", "CAS", "TCP", "declarative", "devops", "fedora", "idempotent", "imperative", "linear", "linearalizable", "mgmtconfig", "planetdevops", "planetfedora", "planetpuppet", "puppet", "remote control", "state"]
author = "purpleidea"
original_url = "https://ttboj.wordpress.com/2017/05/05/declarative-vs-imperative-paradigms/"
+++

Recently, while operating two different remote-controlled appliances, I realized that it was high time for a discussion about declarative and imperative paradigms. Let's start by looking at the two remotes:

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="declarative-imperative.png"><img class="alignnone size-full wp-image-2110" src="declarative-imperative.png" alt="declarative-imperative" width="100%" height="100%" /></a></td></tr><tr><td>Two different "remotes". The one on the left operates a television, and the one on the right controls a central heating and cooling system.</td></tr></table></br />

At first glance you will notice that one of these remotes is dark, and the other is light. You might also notice that my photography skills are terrible. Neither of these facts is very important to the discussion at hand. Is there anything interesting that you can infer?

Here's a hint: to both reduce costs, preserve battery life, and to keep the design simple, the manufacturers of these two devices only included infrared transmitters on the two devices. That is to say, there is no infrared receiver built into the remote control units, those are only found on the appliances.

The difference is that the dark coloured television remote control sends commands imperatively, whilst the light coloured climate control system sends them declaratively. What does this mean?

<span style="text-decoration:underline;">Imperative</span>:

When you press the "increase volume" button on the dark-coloured remote, it sends the equivalent of a literal "increase the volume" command to the television. It has no idea what the previous volume was, or even if the television is powered on.

It is fine to operate this way because the human will discern that an action occurred by an on-screen pop up which informs them about the new volume. If the remote wasn't properly aimed at the television, then the lack of a feedback loop will probably convince you to repeat the command.

This <em><strong>is not</strong></em> <a href="https://en.wikipedia.org/wiki/Idempotence">idempotent</a>, and there is always the chance that an erroneous extra command could be sent. (Perhaps the television had a <a href="https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)">GC</a> pause and didn't display a notification till some seconds after you had retried the command.) It is not particularly safe, but since we're changing channels and not launching missiles, it's not a significant problem.

<span style="text-decoration:underline;">Declarative</span>:

When you press the "increase temperature" button on the light-coloured remote, it actually sends the entire state as shown on the display including the equivalent of "22<sup>o</sup>C please". It is able to remember what it believes to be the previous state by storing this on-board, and it even displays it on the built-in LCD screen.

It is useful to operate in this manner, because the designers decided that it was preferable to view a display which was positioned in your hand, rather than on a fan unit which might be mounted in an awkward area and which could exacerbate neck strain to view.

In this case to provide feedback that the command was actually received, each key press will trigger a "beep" noise from the wall unit, and a brief flash of its power LED. This <strong><em>is</em></strong> idempotent, although the designers didn't provide a button to "resend state".

<span style="text-decoration:underline;">Advantages and disadvantages</span>:

Clearly, it is quite straightforward to imperatively send an action command. This is the common paradigm which we're usually most comfortable with, and layered beneath a declarative design there usually <em>are</em> some imperative operations. This often works best for low latency operations where feedback is guaranteed.

Anyone who has operated a recent television might remember that they require a few seconds to "start-up". In my impatience when trying to turn on a television, I've pressed the "power button" a second time only to see the television turn itself back off. This is because that button only knows to send a "change power state" command which must be both sent and received in odd quanta to change the (binary) power state.

In the declarative world we always request the desired result, and allow the machine to figure out the mechanism and if an action even needs to be performed at all. (It's worth mentioning that I could always send a subset of the desired state if sending the full "struct" would be too onerous!) I can however trick the light-coloured remote into displaying an incorrect visual by pressing buttons when it is out of transmitting range of the wall unit. The good news is that this is only due to a lack of bi-directional communication, and isn't a failure of the declarative paradigm.

<span style="text-decoration:underline;">Bi-directional communication</span>:

In practice after either an imperative or declarative command is sent, we can usually expect to receive a response, whether it be a <code>200 OK</code>, or an error message. We're talking about software and systems engineering now, and while <a href="https://en.wikipedia.org/wiki/Transmission_Control_Protocol">TCP</a> makes everyone's lives easier, it's not immune from failure. If the successful <a href="https://en.wikipedia.org/wiki/Acknowledgement_(data_networks)">ACK</a> message to an imperative command never got delivered (maybe the server crashed after having sent it) and the client repeats the request, you've got a possible problem on your hands!

With the declarative message, it's safe to retry your command ad-nauseum until you're satisfied you were heard.

<span style="text-decoration:underline;">Multiple senders</span>:

With a declarative approach it might seem that if two near-simultaneous users send differing commands, the "winner" would overwrite the other users command! It might also seem that this isn't a problem in imperative systems. It turns out that both these assumptions are wrong.

In the imperative system two independent senders might both decide that the volume wasn't loud enough. If they were to both send a command, they might now have increased it twice as much as desired and are in a similar situation but with the problem that their ears now hurt.

In the declarative system it is easy to avoid overwriting another users request with a simple <a href="https://en.wikipedia.org/wiki/Compare-and-swap">CAS</a> system (basically <a href="https://en.wikipedia.org/wiki/Test-and-set">test and set</a>). For any state change command, the user first looks up the current state and gets a unique integer (possibly incremental) that represents the returned state. When the new state is sent, it should include the integer from the previous state, and should know to only process the state change if it currently matches this value. In this manner with simultaneous requests, as long as the endpoint <a href="https://en.wikipedia.org/wiki/Raft_(computer_science)">linearizes</a> the requests, only one will succeed, while the others will know that their cached view of the world needs to be refreshed. This might annoy them, but it is the safer mechanism.

<span style="text-decoration:underline;">Multiple endpoints</span>:

If multiple endpoints form a <a href="https://en.wikipedia.org/wiki/CAP_theorem">consistent</a> cluster where all members can serve client requests using a declarative tasking system, the client can send the request to one system, and retrieve the status from someone else. This is particularly useful if the operation might take some time, and there is a chance that the initial endpoint was replaced during this interval.

<table style="text-align:center; width:80%; margin:0 auto;"><tr><td><a href="declarative-imperative-diagram.png"><img class="alignnone size-full wp-image-2331" src="declarative-imperative-diagram.png" alt="declarative-imperative-diagram" width="100%" height="100%" /></a></td></tr><tr><td>Hand drawn diagram of the scenario. As you can see the user is happy because they are using a declarative paradigm, and are more resistant to failures.</td></tr></table></br />

While this could be replicated to some degree with imperative systems, it's much more complicated to keep track of whether an operation occurred or not as it's easier for each cluster member to be able to determine whether the current state matches what's expected.

<span style="text-decoration:underline;">Conclusion</span>:

This wasn't an exhaustive discussion about the topic, but I couldn't help writing about it since the two paradigms present some interesting engineering questions. As systems become more complex, will the adoption of new methodologies be widespread and expedient, or niche and sluggish?

Some of my declarative work involves my <a href="https://github.com/purpleidea/mgmt/">next generation configuration management</a> project! <a href="https://github.com/purpleidea/mgmt/#community">Get involved today!</a>

Happy Hacking,

James

{{< m9rx-hire-james >}}
{{< mastodon-follow-purpleidea >}}
{{< twitter-follow-purpleidea >}}
{{< github-support-purpleidea >}}
{{< patreon-support-purpleidea >}}
