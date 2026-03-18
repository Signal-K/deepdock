---
aliases:
  - Gap Questions 17/03/26
tags:
  - Coral
  - ClickACoral
  - Click-A-Coral
  - Questions
  - Specs
sticker: lucide//chevron-right-square
---
 1. Starvation mechanic — when fish exceed the population cap and die from  food shortage: is death random across the population, or does it target the most recently placed fish? And what does the player see — a floaty/fade-out animation, a pop number going down, a brief "starvation" label?

The colour of the fish should fade to grey, then an animation should play, with a slow fade at the end. It should target the oldest fish that has been fed the latest.

  2. Net restrictor detail — 2 uses/turn is confirmed. Is there a coin cost on top of that, or purely a use limit? And what happens when uses are exhausted — button greys out, shows a counter (e.g. "Net 0/2"), or something else?            
You have to generate uses for things like salinity changes - you start with 2. Triggering a salinity increase may trigger something else to decrease in magnitude - research positive/negative feedback loops here. Completing steps before par would also add a trigger. Finally, users can carry over a trigger to other levels if they get it as a reward for completing one level.

  3. Results Panel content — after every End Turn, the results panel blocks input until Continue. What does it actually show? Options: (a) just a per-species "+N / −N" delta list, (b) a summary line ("Your reef grew by  3"), (c) a visual diff of before/after, (d) something else?
Per-species (existing population) out of target (for fish & coral), the target is what the user identified at the beginning.
Number of steps remaining.
I think that should be fine.

  4. Stressor tooltip — on Level 4 first encounter: does it pause the turn mid-cycle (before damage is applied), or does it appear after the turn resolves? What does it say — just a warning, or does it also hint at the counter?                                                  
Both. Mid-cycle.


  5. Trait system specifics — for the breeding preview dialog, what traits  actually exist? E.g. is "heat resistant" a trait, and does it let that fish survive warm temperature? Are traits purely beneficial, or can a fish inherit a bad trait?                                     
Fish & coral can have bad and good traits - the "root" species all should have pre-determined traits (do research here), any bred fish that are "new" species would have a mixture plus a chance to get bonus (good & bad) traits on top of what it would likely inherit from its parents. The idea here is that you'd be able to breed two of the same species together or a mixture, which would create a new species (users get to name these and later on would get to choose the faces/colours based on a defined list (two sprints from now: reminder) - mix & match type thing), which would have (possibly) new traits.


  6. Identify phase on replay — when a player replays a completed level, do they go through a fresh identify phase (new Zooniverse image from the subject pool), or do they skip straight to the puzzle with a gallery of past images shown at level end?                           
Again, I've answered this question multiple times - a new Zooniverse anomaly, and then all anomalies that have been performed for a certain level show up on the level selector/map

  7. Fail screen — what does the fail screen show beyond "try again"? Does   it show: turns used, how far off from target you were (e.g. "You reached 6/10 Madracis"), the species you were missing, or just a simple restart  prompt?                                                   
It should tell them why they failed, and an option to restart or go back.
It should show them that they DID earn some XP for the initial classification regardless.

  8. Extinct card — when a species hits population 0 and the card goes grey: can the player still tap it? Does tapping show anything (e.g. "Extinct — cannot revive" message), or is it fully inert?                            
I think it can just show extinct. If an essential fish species (i.e. a species that the user identified in the source image) is extinct, remember, the level ends.

  9. Environment dial widget — the dial has 3 positions (Low/Medium/High, Cold/Moderate/Warm). Mechanically how does a player interact with it: tap a segment/radio button to jump to that position, or tap +/− arrows to step left/right, or drag a slider?                            
+/- buttons are fine

  10. The Tank in v0.1 — is The Tank purely idle and threat-free in v0.1 (just place fish, earn passive coins, collect), or is there any minimal threat/event system (e.g. a periodic "reef stress" event the player has to deal with)?   
2 sprints from now (REMINDER!!) we'll add a mechanic to add some stressors that would occur in-game, and wouldn't penalise the user when they're not in The Tank. 
Right now it is just placing fish, growing coral, seeing what happens, feeding fish, collecting passive rewards.