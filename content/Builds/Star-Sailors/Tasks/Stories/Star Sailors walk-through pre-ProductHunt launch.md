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
icon: lucide//list-checks
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


[[Post-PH launch wrapup]]

### 🚩 Actionable Tasks (Generated 2025-12-28)

- [ ] 🆔 ss-walkthrough-01 #StarSailors #Demo #ProductHunt #Launch #BugFixes #ContentReview  
  **Review and clarify realistic vs fantasy elements in the game for demo clarity.**  
  Start: 2025-12-28  
  Due: 2026-01-05
- [ ] 🆔 ss-walkthrough-02 #StarSailors #Demo #ProductHunt #Launch #Content  
  **Prepare and organize all content and writing for the Product Hunt launch.**  
  Start: 2025-12-28  
  Due: 2026-01-07
- [ ] 🆔 ss-walkthrough-03 #StarSailors #Demo #ProductHunt #Launch #BugFixes  
  **Investigate and fix Posthog analytics issues before launch.**  
  Start: 2025-12-28  
  Due: 2026-01-10
- [ ] 🆔 ss-walkthrough-04 #StarSailors #Demo #ProductHunt #Launch #UX  
  **Review and improve mobile view/UI for the walkthrough.**  
  Start: 2025-12-28  
  Due: 2026-01-12
- [ ] 🆔 ss-walkthrough-05 #StarSailors #Demo #ProductHunt #Launch #Checklist  
  **Create and follow a launch checklist for the demo, including user feedback review.**  
  Start: 2025-12-28  
  Due: 2026-01-15

### 🕒 10-Minute Granular Tasks (2025-12-28)

- [ ] 🆔 ss-walkthrough-01a #StarSailors #Demo #Content  
  **List all realistic and fantasy elements in the game.**  
  Start: 2025-12-28  
  Due: 2026-01-05
- [ ] 🆔 ss-walkthrough-01b #StarSailors #Demo #Content  
  **Write 1-sentence clarification for each element.**  
  Start: 2025-12-28  
  Due: 2026-01-05
- [ ] 🆔 ss-walkthrough-02a #StarSailors #Demo #Content  
  **List all content and writing needed for launch.**  
  Start: 2025-12-28  
  Due: 2026-01-07
- [ ] 🆔 ss-walkthrough-02b #StarSailors #Demo #Content  
  **Draft 1 piece of launch content.**  
  Start: 2025-12-28  
  Due: 2026-01-07
- [ ] 🆔 ss-walkthrough-03a #StarSailors #Demo #BugFixes  
  **List all analytics issues in Posthog.**  
  Start: 2025-12-28  
  Due: 2026-01-10
- [ ] 🆔 ss-walkthrough-03b #StarSailors #Demo #BugFixes  
  **Write test case for analytics fix.**  
  Start: 2025-12-28  
  Due: 2026-01-10
- [ ] 🆔 ss-walkthrough-04a #StarSailors #Demo #UX  
  **List mobile UI issues for walkthrough.**  
  Start: 2025-12-28  
  Due: 2026-01-12
- [ ] 🆔 ss-walkthrough-04b #StarSailors #Demo #UX  
  **Sketch improved mobile UI for walkthrough.**  
  Start: 2025-12-28  
  Due: 2026-01-12
- [ ] 🆔 ss-walkthrough-05a #StarSailors #Demo #Checklist  
  **Draft launch checklist for demo.**  
  Start: 2025-12-28  
  Due: 2026-01-15
- [ ] 🆔 ss-walkthrough-05b #StarSailors #Demo #Checklist  
  **Review user feedback and add to checklist.**  
  Start: 2025-12-28  
  Due: 2026-01-15

## Navigation
- [[Projects/_Index|Categories Index]]
- [[Projects/Tasks/index|Tasks Index]]
- [[Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web/Stories/index.md|Tasks - Star-Sailors-Ecosystem/Star-Sailors-Web/Stories Index]]
