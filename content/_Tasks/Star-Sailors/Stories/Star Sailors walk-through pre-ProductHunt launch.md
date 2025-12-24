---
aliases:
  - "Star Sailors walk-through: pre-ProductHunt launch"
tags:
  - Demo
  - product-hunt
story: Star Sailors walk-through pre-ProductHunt launch
type: story
segment: v2.1 Bug Fixes & Patches
sticker: lucide//calendar-days
---
Basically a list of things to do or fix that I've found while going through the current V2 version of Star Sailors: web.

* [x] Remove posthog console logs 📅 2025-12-18 🆔 efmz96  (and other meaningless console crap) ✅ 2025-12-18
This isn't really anything too pressing, but it will make debugging process a lot easier without a console filled with this shit

There was an urgent skeleton rendering issue that I've finally caught for new users. Thank fuck I actually did the walkthrough.

Probably the only other thing to do is to make some clarifications on the realistic vs fantasy elements of the game, and then look at the mobile view/UI.

There are some videos I'm going to watch just to prepare for the launch....mainly focused around -
1. All the content, writing, etc
Actually, I think that's the primary thing to focus on. Lol. *that*'s straightforward :P

It also seems that Posthog isn't working. So need to look into that.
As well as the specific other features/areas Posthog can help with.


## Video schema for Dev
The first thing to do is to run through the different projects from the start (locally).
I do remember that during the demo with Matt yesterday it wasn't clear where the Research/tech tree page could be accessed.
Going to start this demo now before my 10 o'clock meeting.

![[Pasted image 20251219124730.png]]



* [x] Log out should redirect user to `/` index route 🆔 1nnion ✅ 2025-12-19
* [x] "Username" text should be replaced with `Guest Account` in #ActivityHeader 🆔 yere03 ✅ 2025-12-19
* [x] Fix scaling issues on `/activity/deploy` #Deploy 🆔 b7hka8 ✅ 2025-12-19
^^ Happy with this? ![[Pasted image 20251219134554.png || 200]]

* [x] Add research button back 🆔 zejpzu ✅ 2025-12-20
* [x] Single row for tabs in `/game` route on mobile 🆔 mki8hw ✅ 2025-12-20

+telescope stuff

So pretty simple OOO for Dev:
1. Sign up using a guest account
2. Open the telescope
3. Select a sector
4. Deploy it
5. Go home, open telescope segment
6. Click on anomaly of your choice


* [ ]  Figure out why Posthog analytics aren't working in prod 🆔 809v6f 