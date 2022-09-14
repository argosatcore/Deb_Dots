---
title: Debian History Roundtable Discussion
date: June, 2004.
---

> Recovered from: https://gabriellacoleman.org/debian-history-roundtable-discussion/

History Roundtable Discussion @ Debconf4, June 2004, Porto Alegre, Brazil.

Context: This was my second Debian developer conference and since there were a number of Debian developers attending, as well who had also been long time contributors, including Ian Murdock (its founder), I decided to organize an informal history roundtable. I had never recorded in a group setting and did not quite have the right microphone so I missed some parts of the interview. But I was able to capture some great reflections and insights from participants.

Key of People

Ian = Ian Murdock
bdale = Bdale Garbee
Ean = Ean Schuessler
Jonas = Jonas Smedegaard
Colin = Colin Watson
Jim = Jim
DD= Debian developer. It is what I used if I was not sure who was talking or if someone had wanted to remain anonymous.

[The beginning of the discussion was a little hard to understand until I had mentioned I could not hear some people well. Then participants started to speak up and it got a little easier to follow. Because it was a group discussion in an open space with a substandard microphone, there were some people like Joey Hess and Jim G that I could barely understand because of their low low voice or they were too far away. There are a few small sections/words/phrases I could not understand and indicated these with a question mark.]

******

bdale: Before HP, ftp.debian.org was under someones desk in some University in Michigan.

bdale: Gosh, 94 somewhere around there. When I first joined the project, the projects’ main system resource was a machine under someones desk in a university, I think it was in Michigan.

Ian M: Ya, I think you are right.

Ean S: Who was that?

bdale: I think I have that in my email somewhere, but I don’t remember otherwise.

Ean: All I can remember it was some guy who did not know how to spell very well.

bdale: Yea he was university system admin type… He was enthusiastic but on the verge of getting himself in trouble because every time we did anything interesting the University T1 connection, which was like their entire connection to the rest of the world, would see an increase in traffic and people would come by and ask what the hell??!

And Bruce (Perens) was really worried with what was going to happen. And so since I was managing a group of system admin in the old test, he asked me at some point if there was somewhere I could grab a mirror copy of ftp.debian.org and shut the machine down in the university.

And we started thinking about it and what I ended up suggesting was that I thought it made a lot of sense if we had a machine somewhere that we built the distribution on so it was not the ftp.debian.org machine. And I could actually host such a machine, we had a machine running backups and sys admins on call in the middle of the night and all of this kind of stuff as long as it did not consume huge amounts of network bandwidth.

And so this was the beginning of the whole idea of master machine that we put the archive on with a mirror network […].

Ean: Who was the dude’s whose wife got sick because that was when I took over.

bdale: That was after. So there was a period of time where I was hosting master.debian.org on a machine in HP in Colorado Springs and there were mirrors in various places. I think it was somewhere in there when ftp.debian.org moved to Georgia Tech

DD: Yup

bdale: Someone had a lot of pipe and said, we will host it. And then two things happened. One was that HP had changed the internal network accounting scheme so instead of all you could eat.. they switched to a project-based… And simultaneously we were about to go through an internal business audit and I realized that this was something I did not want to have to explain to anybody. And so Simon…

Ean: Yeah, he was one of the first guys who was doing CD’s

bdale: Right. So he said, they had this idea, that they make some money selling you know, what we would think of today as unstable snapshot cd’s, sort of the work in progress. And he, and what was his name? Michale Nueffer (sp?) those two guys were the at the ?? (I connective thing??) and Simon said, no problem, he could host it and we were actually discussing Fedexing the actual machine. It was castoff HP Vector 486 33 Tower system that I had put a couple big-ass 5 and a Œin scuzzy discs in and I think it had 300 megs for system disc and 1.3 gig for the archive

Ian: Before we go to far in this thread let’s rewind a bit.

So, I think the best way to start out would be to describe how I found Linux and what the world was like. This was a time, of course, when nobody knew what Linux was. Well people knew what free software was in computer science, in university circles. But the average person outside of that had no idea. In fact, the idea of free software was something that had to be explained multiple times because in fact it did not make sense to most people [Biella comment: I recall having to do this between 1998-2000 constantly. People COULD NOT compute why anyone would collaborate and give away all the crown software jewels without the protection of IP]

DD: When was this 93, 94?

Ian: This was like 92. It was almost a kinda of like a hippie dream thing.

DD: A Berkeley Dream

[laughter]

Ian: This wild eyed, long-haired, thick bearded guy at MIT went on a personal crusade to free the software world… The way I found Linux, well like virtually of us back then, I was at university studying computer science and I was looking for a way to just find a solution to a very practical problem: I was [living] in the northern part of the United States and it was cold and I did not want to have to walk to the computer lab to do my assignments.

So I got it in my head that I was going to put UNIX on my PC and I did not have the money to buy and somehow I found Linux.

Ean: Which Linux did you install first?

Ian: SLS. Before SLS, typically what we had to do when you installed Linux is that you had to download all the bits. You had to download the kernel, the library, the compilers. You had to build your system pretty much from scratch. And this guy, Peter McDonald who was one of the early kernel hackers, decided he would put together what he called a distribution and this was really the first distribution.

Greg P: When did MCC come out?

Ian: It was about the same time. And there were a couple of other distributions out the same time, like MCC

DD: Yggdrasil

Ian: Actually Yggdrasil was really interesting because it was a CD though at the time it was not terribly practical because no one had CD drives. It was interesting because you got so much stuff and bandwidth was so hard to find.

The way you got Linux in those days was you go out to the store and buy about a box of about 40 floppy discs and then you go to the university and you laboriously download all of the stuff and put them discs and walk back your apartment and of course as far as floppy discs go you discover, half of them are not any good so you need to go back again.

Ean: I came at it from a different angle because I dropped out of college… I mostly put myself through school doing [prepress and I would program for a long time so I could, so these graphic artists would try to get postgres to do something and they were screwed and I would, get error back and they were like “what?” and I would be like “ahhhh.”

So I had been doing a lot of development for interactive TV, like the Phillips CDI standard. But I had this terrible cross complier through Microware (?) and I was running OS2 at the time and like every 4th time you run … you get a fault. And I was down at the computer swap meet and I found this box that said “Completely free operating system, all source code included..” and I was like “What!?” and for 7 dollars. So I came back and installed it on my 486 for the hell of it and I saw that it has a DOS emulator and I ran those cracked tools under it and unlike OS2 when it would segfault under OS2, it would take OS2 down.. ….. And I was like “woah, this is my new development platform.”

Ian: Yeah, I remember those advertisements too. I had found Linux on the Internet and I was playing with SLS and one of the first things that really struck me… Well the first thing that really struck me was, this was, of course, when you were a university student, particularly an undergraduate student, you did not have a whole lot of access to computers.

bdale: Some of us did….

Ian: Some of you did but not officially sanctioned, I suspect.

bdale: In my case it was. I had unlimited access to every machine in Carnegie Mellon.. [Biella Comment: Indeed, proof that bdale is really a Unix demi-god]

Ian: Well for us mere mortals… If we were lucky we could log into a computer through a 2400 baud modem from home and so having UNIX at my own computer at home where I could log in as root and do anything I wanted was initially very interesting to me.. The novelty starts to wear off and it just becomes software, another OS system.

What really grabbed me off the bat was the community. That was what really grabbed me and you have to understand at the time, it was a completely foreign notion that I somehow I had stumbled upon this group of people that were interested in the same things that I was interested in who had basically, for no particular reason built this thing, this operating system and it had actually worked and I could do my work on it and I had not paid a dime for it, they did not ask anything of me when I download it or used it.

And whenever you are in a situation like that when people have given so much to you, one of the first instincts is like: “what can I do for you, what can I give back?”

At the time, given the state of Linux world where you had either had to have a lot expertise to know how to download everything and compile it and put it together or you had to but it on a cd, there were sometimes less then reputable dealers. As it turned out some of these advertisements proclaimed full Windows compatibility. This was a full three months after the Wine project started.

So what I wanted to was first of all to create a distribution that worked well because SLS did not work particularly well. It was done by one guy and there were always bugs and stuff. So the thing was a mess because it was one guy from one perspective, one view of the world.

I was an emacs user so the first thing that I did was fire up emacs and it dumped core because he happened not to be a emacs user…

From my perspective there were things wrong with SLS was because there was just one guy.. And the obvious way was to fix it was to do it as a community. Get more than one person involved. And the inspiration for that was the Linux Kernel. And for some reason the Linux kernel development model seemed to work. You had one guy Linus coordinating things and random people would come and go and send in patches and test things and it seemed to work and I figured, what the hell let’s give it a try and perhaps we can apply the same idea to this distribution and of course there were some technical hurdles to overcome.

Biella: Where did you announce the project?

Ian: I announced it on USENET in August of 93.

bdale: What group did you announce it on?

Ian: comp.os.linux

bdale: Back when it was still usable. It used to be fun in like 85 and 86 when you could read every message and every group and everyday.

Biella: How long did you lead the project for initially?

Ian: Three years from 93-96 and the initial challenge was mostly logistical. It is one thing to decide you are going to build this thing in a distributed fashion and with typical software development there was some prior art to look at in terms of how you do it. Even in the software companies of the day they had development teams and people working on different features. But when it comes to building a distribution… Well it is not something you write from scratch but it is something that you assemble from many different external sources. And if you are going to be doing it not as one person, how do you coordinate activities? And if you want it to happen from the community so it is not all only from my perspective but it is also from a number of people’s perspectives and that number of people can grow and grow, what kind of technical infrastructure do you have to have in place to support that?

And that is where the package system came in: Dpackage, it was mostly a solution to how do you break the system up in pieces and how do you allow for the pieces to be maintained by different people and how do you ensure that, when someone, namely someone who is installing the OS puts all the pieces together, it does not look like a bunch of pieces. It has to look like a cohesive whole.

So we spent a lot time thinking about packages and how they relate to each other. And we figured out that some packages would depend on each other and other times they would conflict with each other and over time this grew into a more sophisticated inter-relationship.

bdale: I forget which release it was but there was a big milestone. Was it 1.01? There was a release at which all of sudden, everything was packaged and each package had an explicit maintainer. For me that was a major transition point, because prior to that it was…

Ian: Just me… Ya, that was 93R6, which was in 95…

Jonas: When you say, we, how many people were in the core?

Ian: So..

bdale: A couple dozen.

Ian: So I announced the idea in August of 93 and we pretty quickly had a couple of dozen people sign up to a mailing list and people said, “yah, I felt the same way about SLS and I thought about doing a distribution but I don’t know enough about this or I don’t have enough time for that so, it sounds like this distributed development thing is a good idea so lets work together!”

And when did you [bdale] join?

bdale: It was like late 94 and by that time it seemed like there were two or three dozen people sort of active then. We did not have the same mechanism then, there was nothing like a key ring that you could point to and say, these are the developers.

Ian: To become a Debian developer you sent email to me. That was the New Maintainer Process.

bdale: I knew Bruce [Perens] from the amateur radio world. In fact Bruce had been using software that I wrote for amateur radio. So when I got interested in Debian, it took me about 24 hours before there was something that was missing that I wanted add. And I asked Bruce what I was supposed to do and he sent this message to Ian with a copy to me saying, “Ian by the way here is his guy named bdale, you probably don’t know him but he has done all of this stuff.” And I got this email that said “great, glad to have you..”

Somewhere in my email history I have those two messages and I wave them around once in a while when we get a little worked up about the New Maintainer Process….

[laughter]

Yea it was a little different back then. We did not sign package uploads. It was not quite an honest ftp. Do you remember what the login name for the mirrors was back then? It was one of my inside jokes. The login was Alice and the password was looking glassbecause it was the other side of the mirror.

Ian: It was a pretty loose ship. But it was low enough profile that it did not matter.

bdale: I know I have the distribution discs that I used to install the original master on 0.93r2 or somewhere in there. And you know it was funny because when Bruce poked me about that it was one of those, “oh yea, we have some stuff we are about to throw out…”

Ian: We were mostly an email list discussion group just for the first 6 months, discussing: “how do we do this? What does the package model look like, what kind of tools do we need to have to build it?” I was still basically doing all of the work myself. Simply because we did not have the infrastructure in place to support any kind of distributed development.

We did our first release in January of 94, which was 91 [?] and I think that was the point, we figured we had to get something released because email discussion at least back then did not hold anyone’s attention for terribly long. There had to be some substance to it. The initial focus was on getting something to work and that, I was doing all of that.

And then we had the discussion once we have something working, how is that we split it up and how do we actually make this distributed development work.

bdale: When I came along which would have been the later half of 94, very clearly there were three people in the middle of things. It was you, Ian Jackson who was working working both on the BTS and DPKG and Bruce [Perens] was basically working on the installer and busybox..

Ian: And he did the mailing lists.

bdale: Right, the mailing lists.

Ian: It was running off his workstation and every once in a while he would have to reboot it and he would say, “the lists are going to be down, they are replacing my UPS or something.”

It was not until late 94 when we had a working package system. We started to realize that just having packages was not enough. We had to have policies. Here is the mechanism, what is the policy? If you want a something, if you want a service to start at boottime, what do you do? And that point we had a bunch of really horrible things, like, you know, we had post installation scripts and so people were editing /etcrc and you could imagine what happens after a while.

But so we figured, this is not going to work, let’s do System V init. So one evening I log into a Solaris machine and I looked at the documentation and copied it.

[laughter]

Well copied it in a sense.. And those sorts of things, we learned by painful experience. What did not scale when you went from one person to n people. And I would say by the end of 94 and early 95, we had most of the stuff that still exists today was in place.

bdale: I think the master stuff happened in January of 95 or February. That was about the time we started to think about how to design project infrastructure beyond just things like the package system.

Ian: I think since [then] there has been a ton of refinements to the original stuff but I think it has been mostly that… It is not that we did not have the right ideas in the beginning, it is just to scale the thing, from 1, to 5, 50, to 500 people…

This was very much uncharted territory. No one had ever done anything like this before so we made the best guess we could and invariably there were some wrongs one. I remember there were a variety of crisis points throughout the history of Debian at which time the conventional wisdom was that Debian had grown to its limits. And of course everyone was always wrong.

I remember clearly 200 maintainers, Debian was stuck at 200 maintainer for several years because the infrastructure was strained to its limits.

bdale: I did not have many data points back then because I did not start giving talks about Debian till later. I thought a couple of times about what it would take to actually go back and get better data points because what I have are [??]. I went sort of backwards. In fact, Wiggy and I worked on this together once.. We tried to extract a number or two of data points, like number of packages. We looked at some of the early releases and looked at the Cds and counted how many packages there were and stuck those in some data package points.

In the Debian history documents over the years we have successfully captured a few data points about how many people were participating in the project. etc..

Ean: It is kinda worth noting that in some ways, that Linux as infrastructure even in 1993 was incredibly sophisticated. It made Windows looks stupid, I mean positively primitive…

bdale: It was kind weird for me because I was coming from the UNIX side. I was a Berkeley VAX guy since the early 80s. And I knew [Andy] Tanenbaum and I had been playing with Linux more or less from the beginning and that was a kind of fun toy for me to play at my machine at home but it never occurred to me that I would do anything serious with it.

And as I mentioned at the satellite talk, the excitement for me was being able to get the source tree for Berkeley Unix legally at my house for one of my machines. That was the environment that I had cut my teeth on. It was only when it turned out when I wanted to work on a project with a bunch of people who could not afford to spend 1000 bucks, which seems like a lot of money now but at the time it was 250,000 dollars to get a commercial source license.

My point is that I came at it from a slightly different direction. I noticed Linux and I thought it was kinda cute. I think at around the time kernel 0.12 or something like that, I downloaded a floppy or two and booted it and I thought: "That is kinda cool, but it is not as useful as Minix, and, you know, I got this Berkeley machine sitting here that is way more fun." It was not until there was some external project motivation that I came to Linux, and by that time, late 94, 95, it was good. I looked at it and I said "this is good enough that I can ?? (coughing)" That was a major wow factor. In fact, I had more device driver support for the hardware that I cared about than BSD had.

Ian: It is kind of interesting to bring BSD into this because at the time, when I discovered Linux, I also very quickly discovered 386 BSD and I got involved..

Jim: [Bill] Jolitz…

Ian: Yeah the Jolitz.. And then there was also GNU/Hurd and people at that point still believed that it would eventually get done.

[laughter]

So I was puzzling through this: "Should I stick with 386 BSD, do I switch to Linux, do I wait for the Hurd?" At that point, people had not been waiting for the Hurd for very long. Even Linus said, reflecting back on it that if the Hurd would have been ready, Linux would never happened.

One of the interesting things to me, is why are we here talking about Linux and not BSD.

Jim G: The culture

Ian: Exactly, it is the culture.

Jim: It is culturally different

bdale: Jim and I had a really fascinating lunch with [??]

Jim: They had a fundamental misunderstanding of Linux

bdale: This was at lunch last year at USENIX in San Antonio. They really, *really*, don’t understand how it is that Linux works…

Biella: So wait, be more specific. [Biella comment: I was interested in studying FreeBSD as well, but decided it was too elite, so the comments below were just such nice confirmation of what I had loosely diagnosed.]

Jim: The phenomenon that they did not understand is that Linus acts as a conservative gate keeper and that lots of people are simultaneously making lots of different experiments, if you will, and Linus picks and chooses to a large extent.

bdale: You have to understand if you were not around and you were not trying to interact with Berkeley UNIX in the heyday of the VAX this may be hard to grasp and fathom but it was a lot like the free software community today in some ways and it was a very much a cathedral development model in other ways. Lots of people had the source code to Berkeley UNIX in different universities. I had a really good friend at the University of Pittsburgh who wrote some hunks of code that made it back in there and I had some hunks of code that made it into Berkeley UNIX.

But there was this process by which you wrote some code and submitted in the “I am not worthy, but I hope this will be of use to you supplication mode” to the guys in Berkeley and if they kinda looked it at it and thought, “oh this is cool then it would make it in” and if they said, “interesting idea, but there is a better way to do that they might write a different entirely implementation of it.”

Jim: In that era the Internet sort of existed

bdale: The Arapanet

Jim: Well it had just become the quote Internet. And we had almost no tools. It was effectively impossible for people to work out of a common source pool.

bdale: CVS did not exist. There was nothing like it.

bdale: This was before patch. I remember the first time that I saw patch, I nearly fell out of my chair.

Jim: DIFF existed sort of. So Berkeley UNIX would come out every couple of years and in the meanwhile, different institutions would be going in different directions, until some somebody put it back together again by Berkeley. So there was a group of people that knew each other well enough that would sort knew what was going on at lets say MIT and CMU.

bdale: We traded tapes.

Ian: The thing about 386BSD and GNU that same mentality was carried forward.

Jim: The technology fostered a culture.. Linux started up later and formed a different culture because the technology enabled that culture.

Ian: And I think it is no accident that a lot of the early Linux guys were in their you know, their early 20s. They were not people who remembered working on BSD on the VAX. There was something like [??]. It was a community that learned from the previous community but it was an entirely different one.

Ean: But surely was Linux was exposed to VAX?

Ian: No, well maybe as a user.

Ian: So looking at the choice between 386BSD and Linux, on the one hand 386BSD at the time was much more advanced because it had been building on top of some technology that had been in use for 10 years. But there was no community around it all. The main thing that turned me off was Jolitz, right? I mean here was this guy and the system did not move at all unless he said so. And there was this window of time when I first ran into this stuff. I don’t think that anyone had heard from him for like six months.
And then you look over at Linux and you see that it may not [at the time] be as technically beautiful but it is active.

bdale: For me it was all about device drivers. I mean Berkeley and the VAX rocked. Berkeley had been ported to all sorts of mediums and big machines that worked ok but. In the era you had support for the ??1542, scuzzy controller. And you had to have a click tape drive. I actually went out and bought a tape drive.

Jim: Yeah I did that too.

bdale: I bought an archive viper… so that I could even install..?? My first BSDi machine was like a 16 mhz 386 sx with like 4 megs of RAM or something and everyone thought I was like privileged. When I got my hands on an early laptop that was 386 based or something. Things like the mouse interface there was no driver for the BSDi. The first PCMCIA slot controller, there was no driver.

So my point is that for me: the first time I really tried Debian, which was in 94, it was amazing to me how many things worked. There were a lot of people out there trying to make things work.

Ean: You see, I remember when I was first started using Debian the thing that sold me, it was definitely after the package infrastructure but it was still pretty early. But things were working enough, that I was running Slackware and I had done like two backup my home directory and reinstalled Slackware from scratch and copies my home directory back onto it. And then I heard from Usenet, “Woah, Debian is the thing, it actually works. You can upgrade it in place and it was like “AHHHHHHHHHHHHHHHHHHHHHH.”

[laughter]

It was like: “holy fuck, you can upgrade in place!”

When did that work?

Joey Hess: [He answered something but he has such a deep voice I could not understand].

Ian: The upgrade in place worked almost immediately and you know what is funny? It was an accident.

[laughter].

The package system was not designed to manage software. It was designed to facilitate collaboration. And it just so happened that if your system is in this big blob and you build your package system right and you know you have these interdependencies that are explicitly expressed, well then you can say I want to upgrade this part of the system, which means I have to upgrade this part of the system and pretty soon we came to the realization you only have to install this once.

bdale: There was this one time I did a reinstall because I was having some knarly problems and it turned out to be a hardware problem. I had a machine that was installed at 0.939r6 and it is running Sarge now.

DD: Have you updated the kernel?

[laughter]

bdale: It has been rebooted…

[laughter]

bdale: I mean if you looked at it today you would not believe me but there is a direct lineage.

Ean: Dude, I am going to OWN that system.

bdale: Go for it 🙂

Biella: So I have a question about the transition between Ian M to Ian J and I guess what was it like and what was it like to hand over the reigns?

bdale: Actually it went from Ian Murdock to Bruce.

Biella: Ohh

Ian: So, this is something that I had been doing for three years and I was satisfied that…

bdale: Well you were off to grad school.

Ian: Yea andI was in school and basically at that point we had a thriving community. We had infrastructure, we had lots of users. And my final test as to whether or not Debian succeeded was: “could the founder step away from the project and could the project keep going because that is the only point at which you know that the project has basically taken a life of its own?”

bdale: That is something that basically has never happened with the kernel.

Ian: I think the kernel could go on, but there would be a long period of upheaval in the process.

Ean: Didn’t Alan Cox retire, even partially?

Ian: Yeah but he seems to have been replaced by a couple of other people. I think if you have any large group of motivated people there are going to find some way to keep going if the group wants to keep going. I think what is unique about Debian is that we set it up explicitly so that there would not be a single person at the center of everything.

Every project has to have a leader. You have to have someone who can speak for the project. A leader need to take care of all the sorts of stuff that any organization has whether it is a nonprofit, a company or a community project but you know, you don’t want to be tied too closely to that single person because what if that person is hit by a bus or something? Or what if the person decides to move to other things?

So it was only after that I stepped away and watched Debian for awhile that I knew that we had truly succeeded. It is not only that Debian kept going but it technically did far better under successive leaders than it ever did under me.

bdale: Ian decided to step away we more or less went to Bruce. It was frankly obvious to everybody that Bruce was going to take over. He was working on the installer, he was coordinating a lot of things and Ian Jackson was around and very active still and it was pretty clear that Bruce would not have to do it alone, there were plenty of us around who could do things. He seemed like the obvious person to replace.

Ian: At that point there was not a concept of the project leader or anything like that. In fact if I remember correctly, we called ourselves the triumvirate: Ian, Bruce, and I. And when I left, it was only one member of the triumvirate stepping away and the person who stepped in was bdale. I remember saying bdale was the third leg of the triumvirate.

bdale: You see at that point I was still running chunks of infrastructure. In fact, my management at HP was amused when they heard this story because they had no idea HP had been providing bandwidth

From a project leader stand point, after Bruce had been with us for a couple of years, I am not sure what the timing was. There was an idea that we should maybe be electing a project leader. And the way we got to Ian was that in the first election Bruce and Ian were going to run against each other and we were going to have an election to decide who would be the leader.

And Bruce basically dumped core before the election and walked away sort of saying that: “Ian winsbefore we actually ever had a vote.” So Ian Jackson was the last project who was not elected.

And in fact from my perspective if you look at the content of the Debian Constitution there are a whole bunch of things about our constitution that were a sort of a knee jerk reaction to what happened in the preceding year or two. And the fact that no one really wanted to go through the experiences we had when Bruce was a leader.

Biella: What year was the Social Contract created and can you also be more specific about what you mean by the knee-jerk reaction? And also were there any models that people looked to for the creation of the Constitution or the Social Contract?

bdale: Ian Jackson drafted the Constitution and to the best of my recollection, there was some fiddling around with some details. But I don’t think that very much got changed.

The Social Contact… So should we hear the Social Contact according to Ean story?

Ean: I am not telling the Social Contact story….

bdale: The Social Contact and the DFSG resulted from about a month’s mailing list discussion. We have that email history. Bruce acted as sort of the editor. He would write straw man chunks of texts and put them out and we would all scream about it. And actually back in those days we did not scream as much. These were very civilized conversations. It is one of the things I miss.

Joey Hess: This was all on Debian-private

bdale: Yeah this was on private.

Colin: Some of the discussions about hosting the old?? master were fairly heated. I think there was still screaming, just fewer people screaming.

bdale: You know that is true. A flame war was like a message or two a day. This whole phenomenon of waking up in the morning and realizing that there are 17,000 new messages is just beyond comprehension.

So the Social Contract and the DFSG were very much a group activity. And one of the few things that I really get annoyed with Bruce about is the fact that he does not correct people very much when they assume he wrote them. That is my polite way of poking at that.

That was very much a group activity and I think we were pretty proud of it at the end. And one of the things that happened almost instantly when the Social Contract and the DFSG went live and were published was that the Sunsite (??) which at thetime was at UNC which was one of the big repositories of upstream packages. It was one of those places that if you did not have a server you could hand them tarball and they would put it out where people could get to it. They almost instantly responded to our publishing the Social Contract by adopting the Debian Free Software Guidelines as their criteria for what they would accept at the Sun Site.

When that happened, I don’t know what everybody else thought but I was like “ahh man we got it right.” Here was someone who was completely outside the whole creation process that was responsible for a high profile resource in the community that said, wonderful, we got it, works for me.

And very quickly this became the litmus test. This is that sort of practical reality meets the creation, the foundation of documents thing.

The SC and the DFSG were actually thought about really hard and were a reaction to examples that we had seen and a reaction to twisted licenses and everything from Beerware licenses to..

Biella: Beerware?

bdale: You can use this software but if we ever meet you have to buy me a beer. And then there were the postcard licenses.

Ean: [Recounts a conversation he had with Bob Young of Red Hat, unfortunately I could not understand the first part of it but was able to ask about it later] I was at USENIX and I was talking to the Red Hat guys and I was like: “you guys are a for profit company for Linux.” And they were like yea and I was like that is cool And I was like so, that sounds good, it sounds much better than Microsoft. My only worry is that if you get to too big enough of a level that you might get wise ideas and change your mind about what you are doing.. And they were like: “we won’t do that.” And I was like “why don’t you put it in writing? right guarantee that you would distribute just GPL software. And Bob Young was like “That would be the kiss of death.”And I was like “woaaahh.”And I was like “wait a minute Young just said that the GPL is kiss the death.”

I was at the time entertaining the idea of switching to Red Hat because I thought maybe it would be more organized.. And then I was like [facial expression revealed no way].

bdale: So the creation of the social contract and the DFSG, that was one of the points where the group had grown enough that it was important to articulate what the group’s fundamental values were because in order to build a community you have to have some way of articulating and connecting some shared values.

When did you [Ian] write the Debian manifesto?

Ian: In early 1994

bdale: So that was an attractor. And for me, when I read that I was “ok, yup, bingo.” This is exactly what some of us think some of the problems are and I want to help. It acted like a geek magnet. It was the attractor that caused people to come here and say: “yes I want to participate in it.”

Colin: Even now it is a strong document.

bdale: The section about Linux is [?] and that does not mean you can’t make money from it is something that I think about from time to time when we are talking about Linux as process not a product and so forth. And it is interesting that has not really gone away.

So the Manifesto acted as a initial attractor and when the group got big enough it was important to make sure that they understood what the expectations were and the Social Contact and the keysigning process and the NM process, we sort of require that you have said that you have read this and you agree and abide by it. And there are of course people who have been around longer than those documents and most of them would not have stayed if they did not agree with it.

It acts like a first order filter on who joins the project. And then Constitution came along after that. And that was a recognition that project had gotten big enough that there might problems that we might want to resolve that we could not just resolve by ..

And so when I talk about this progression, I talk about the Manifesto as an attractor, the Social Contract as a first order filter to try to make sure that people don’t join a project without understanding what they are signing up for.

And then the Constitution then provides a little bit of organizational structure. It principally defines the processes we are going to use for making decisions that individuals can’t make by themselves. The GR process, the project leader election process.

