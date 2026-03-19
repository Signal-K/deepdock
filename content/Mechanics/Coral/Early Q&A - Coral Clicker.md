---
tags:
  - Specs
  - Coral
  - Click-A-Coral
  - ClickACoral
  - CoralSpecies
  - Questions
sticker: lucide//locate-fixed
---
**Core Loop / First Release**

1. What does a single "click" represent in the world — are players clicking to classify coral health, to "feed" the reef, or something else narratively? And does the click action have a direct in-game animation tied to it?
The clicks would be identifying the makeup of the reefs, then breeding and placing the fish in the environment.

    
2. Is the first release purely a clicker (idle/active), or does it need a classification mechanic built in from day one — i.e. does the Zooniverse subject image the player sees need to yield a real classification result?
I don't want it to be completely idle, just a nice relaxed puzzle game with some very minimal and relaxed citizen science & sandbox mechanics


3. What is the win/loss condition (if any) for a level — is it a score threshold, a time limit, surviving long enough, or is it open-ended progression?
The user has to use the starting "materials" they get at the start of the level to replicate the coral they find in the original image.

    
4. How does the player move between levels — do they unlock them sequentially, or is there a hub/map they navigate, and does a level "end" or is it left persistently?
Sequentially, we'll start with 10 levels. Longer-term, a map would be cool.

    
5. What currencies exist? (Coral Points, a second resource like nutrients, etc.) Are they level-local or shared across the whole game?
Let's say nutrients & coins, nutrients exist only in levels, coins exist across the entire game.

    
6. Does the player have an inventory or collection — e.g. species cards they unlock — or is progression purely numeric (score, multipliers)?
Coins only for now

    
7. What is the first "upgrade" a player can buy, and what category does it fall into (auto-clicker, multiplier, new mechanic)?
In levels, they can use coins to buy more fish eggs
    

**Subsequent Releases / Mechanics Depth**

8. Is there an "idle" component — does the reef grow/score while the player is away — or is it strictly active play?
It's a puzzle game with levels - no idle mechanics for now. There would be a sandbox level where the user can "grow"/earn coins while away but this would be a longer-term and more minimal goal.
    
9. Are the Zooniverse subjects shown as background art only, or does the player interact with specific regions of the image (e.g. tap a coral cluster)?
The user identifies the makeup of the image and then replicates it as part of the level. The level number determines how many resources the user starts with.
    
10. What role does species data play mechanically — do rarer species yield bigger bonuses, and who determines rarity (Zooniverse metadata, manual curation)?
The less turns taken to replicate, the more coins
    
11. Is there a degradation/threat mechanic — bleaching events, pollution — that the player must counter, or is the tone purely positive/additive?
Certain fish will kill certain coral species over turns, and vice-versa. Certain fish will aide certain coral and vice-versa. So users can experiment with one coral to get the required fish, and then kill off that coral later if it wasn't part of the original reef image.

12. Should multiplayer or social features (leaderboards, co-op reef building) appear in the first few releases, or are they out of scope for now?
Longer-term scope


**Content / Narrative**

13. Is there an overarching story or narrator — e.g. a scientist character guiding the player — or is the game purely mechanical with ambient reef theming?
Mechanical & ambient
    
14. How much real scientific content surfaces to the player? (species names, depth data, bleaching stats) — tooltip flavour, full info panels, or none?
Species names only for now

15. Are the 10 levels meant to represent 10 distinct real reef sites/depths, or are they difficulty tiers with the same reef re-skinned?
Just random, arbitrary number

16. What is the intended session length — a casual 2-minute mobile pick-up or a 20-minute desktop session — and does that differ between releases?
10 minutes, maybe 3 minutes per level?

**Monetisation / Platform**

17. Is the game free-to-play with optional purchases, donation-driven, or entirely free with no monetisation?
100% FOSS for now
    
18. Primary target platform for release one: mobile (iOS/Android via Expo/React Native), web browser, or Godot desktop/mobile export?
Mobile PWA from Godot running in RN/Next
    
19. Are real Zooniverse classifications from this game ever fed back into the actual Click-a-Coral project database, or is the science integration one-way (art/data in, no classifications out)?
Short-term, no. Long-term, yes
    
20. What does "done" look like for the very first public release — a playable demo with levels 1–3, a full 10-level experience, or something else?
10 levels.

---

# Second step - integrations & v0.2++
 1. Ecosystem Integration (Star Sailors)
   * Shared Assets/State: Will players use the same account or "profile"
     across Star Sailors and Coral? For example, if they earn coins in
     Coral, can they spend them on ship upgrades in Star Sailors, or is the
     integration purely narrative (e.g., "Star Sailors" dropping supplies to
     the reef)?
So the key thing to remember is that Star Sailors is both the name of the main web game (https://starsailors.space) and the name of the ecosystem.
The goal now is to create a bunch of minigames, like this Coral game, to try out new citizen science projects or mechanics, and then bring them into the main game (which will eventually be like a full sandbox citizen science multiplayer world). Each minigame must be playable on its own, e.g. some users may only want to do space-based citizen science projects or even just a single project; some users may want to do them all!
So right now there won't be much integration, other than coral discoveries that are made in the web game being shown in the stats/content for this minigame and vice-versa.
Later on, currencies & inventories will be able to be shared and eventually the "worlds" or content users build will all exist in a shared narrative and world.


   * Cross-Pollination: Do "Rare Species" discovered in Coral appear as
     collectibles or data logs in the other games? Understanding how data
     flows between these apps will help me design the AppController and
     Supabase schema more effectively.
So basically, like above, we will just have simple integrations for now. Annotations & classifications users make in the coral game need to be added to Supabase, apart from that, we don't need much interaction with the main game world for now. As long as the actions of the user are saved to their account, and their progress, that's fine for now.



  2. Gameplay & Simulation Depth
   * The "Breeding" Mechanic: Currently, it’s a button press. Should this
     involve a mini-game (e.g., matching genes/colors) or is the strategy
     entirely in the "Parent Selection"?
I'm open - let's brainstorm on this.

   * Visual Representation of Growth: Do you want the coral to grow
     "pixel-by-pixel" or in distinct stages (Seed -> Sprout -> Branch ->
     Bloom)? This affects how I build the sprite template engine.
Maybe a mixture?

   * The "Sandbox" Level: You mentioned a long-term goal of a sandbox where
     users earn coins while away. Should this be a "Level 0" that acts as
     the main hub, or a separate mode?
It would be a hub level, where users have like a tank that has a persistent population and it produces rewards and bonus items for use in levels; it's basically the only idle feature for this game right now.



  3. Citizen Science Loop (The "Real Impact")
   * Consensus & Validation: For the "Long-term: Yes" feedback to
     Zooniverse, how do we handle "bad" classifications from players? (e.g.,
     requiring 3 players to agree before sending the result).
Yeah, I think that's a good thing.

   * Educational Content: Do you want "Did You Know?" pop-ups or species
     fact-sheets when a player successfully replicates a reef? This adds a
     "Discovery" layer to the collection.
Not right now. Add it to a knowns doc for 3 weeks from now and create a trigger for all agents (Claude, Codex, Gemini) to be listening for these docs that have future tags so that when we're "Ready" for that concept, we'll revisit it.


  4. Technical & Platform Specifics
   * PWA vs. Native Features: Since this is a Godot PWA inside React Native,
     are there specific native features you want to leverage (e.g., Haptic
     feedback on a successful breed, Push Notifications for a "Reef Event",
     or Camera access for "AR Reef" later)?
All of these would be good long-term, but maybe just push notifications for now.

   * Offline Play: Should the 10 levels be playable offline, with syncing to
     Supabase happening only when a connection is restored?
Yes


  5. Progression & Difficulty
   * Level Scoping: Are the 10 levels purely additive (more species to
     track), or should they introduce new "Stressor" mechanics (e.g., Level
     5 introduces "Pollution" which requires a specific fish to clean)?
Stressors are good, basically we just need to make the levels harder to complete

   * Failure States: In a "relaxed" game, how punishing should the turn limit be? Should "Failure" just mean fewer coins, or a hard "Restart"?
Restart the level


# UI - part 1
  1. Screen target — Is this primarily desktop (1280×720+), mobile portrait,
  mobile landscape, or all three? The current layout assumes landscape.
All 3


  2. Primary action — What's the single most important thing a player should do
  on the main game screen? (Breed fish? Press Turn? Watch the reef?)
Selecting the level/sandbox level that they want to play

  3. Top bar purpose — The TopFlowBar currently shows breeding controls,
  environment sliders, and a turn-flow diagram. Should breeding be promoted to
  its own screen, or does it stay inline?
Breeding would occur every ~30-45 seconds depending on the species
It shouldn't be an action, but users should see that a breeding event occurred, which deposits eggs (new sprites req) and then those eventually hatch...adding to the population

  4. Side panel — The SideNavigator holds level navigation, fish action rows
  (Feed/Net), and control buttons. Does this panel feel cluttered? Would you
  rather tabs, a drawer, or something else?
The whole thing feels cluttered. But things shouldn't be hidden. Reduce the complexity - in fact, we should be starting it from scratch. Identify what I've recently discussed with the [new] game flow, and figure it out from there.

  5. Fish action rows — Each species has a Feed (+) and Net (−) button in a
  scrollable list. Is this the right interaction model, or should fish
  management feel more like card selection / drag-and-drop?
Card selection

  6. Coral growth display — Currently 3 coral clusters sit on the sand. Should
  there be more (reflecting all level corals), or should growth be shown as a
  single meter/bar instead?
It should reflect the corals that the user identified in the source image and their related species.

  7. Environment controls — Salinity and Temperature are adjusted with +/−
  buttons and shown as a progress bar. Would a visual dial, slider, or even a
  "habitat zone" diagram be clearer?
I'm open, but we just need to make sure that these options are limited so users can't just fine tune the environment without cost.

  8. Turn flow diagram — The 4-step guide (Breed → Feed/Net → End Turn → Coral
  Growth) sits in the top bar. Should it be persistent, or shown only as a
  tooltip/tutorial overlay?
Persistent is cool

  9. Resource bar — The bottom shows Shells, Stars, Crystals, Coins. Are all 4
  used actively, or can some be consolidated? What does each one actually buy?
Stars & Crystals should be hidden for now - let's come back to that down the line.

  10. Level progression — Currently there's a level grid (home screen) and
  prev/next buttons in the side panel. Should the level map be more prominent,
  like a world map? Or is a linear chapter feel better?
World map is good

  11. Objective visibility — The current level objective (e.g. "grow Madracis
  Sp. to population 8 in 6 turns") is in a label in the side panel. Should it be
   front-and-center, like a quest card, or is tucked-away fine?
F&C

  12. Turn counter — Turns remaining is in the bottom bar. Should there be a
  more dramatic "ticking clock" feel as turns run out?
No.

  13. Feedback on End Turn — After pressing End Turn, coral growth happens. Is
  there enough visual feedback? Would a "results panel" per turn be satisfying,
  or is continuous animation enough?
Results panel/section would be good.

  14. Identify phase — The citizen-science coral ID mini-game interrupts level
  start. Should it be optional/skippable by default, or a hard prerequisite?
NO! You're missing the whole point. THAT IS HOW WE KNOW WHAT THE LEVEL WILL CONSIST OF!!!!

  15. Breed preview dialog — Breeding shows a popup with offspring predictions.
  Is this the right UX, or would inline prediction (no popup) feel smoother?
Inline.

  16. Visual style direction — The current palette is deep ocean blue. Is that
  the direction you want, or are you aiming for something brighter/more
  cartoonish/more scientific?
Little more bright white & sci-fi, but this is a good start

  17. Sprite display size — At 128px sprites scaled to ~56–80px, the creatures
  are quite small. Should they be larger and more central to the experience, or
  is the current small-icon style intentional?
Maybe larger - let's do 248*248?

  18. Mobile touch targets — The Feed/Net buttons and Breed button are small. If
   mobile is a target, do you want larger tappable areas as priority, or is that
   a later concern?
Yes, we need it to be mobile-first

  19. Sound/feedback hooks — Are there any planned audio events (bubbles, coral
  pop, fish splash) that should influence the layout/button placement?
Sound effects are cool - let's do that sprint starting Sunday 22 Mar

  20. One thing to kill — If you had to remove one entire feature/panel from the
   current UI to make the rest feel more focused, what would it be?
It just feels too cluttered, overall.



### Q&A 16/03/26
 World Map (ui04worldmap)                                                  
         
  1. Are the 10 reef sites geographically themed (e.g. Caribbean, Great     
  Barrier Reef, Red Sea) or purely abstract/fantasy locations?              
Let's say based on where those species are (do research and take note in `knowns`)

  2. When a player replays a completed level, does the Zooniverse thumbnail 
  on the map update to their most recent run or stay as their first?        
It should show a gallery view.

  3. Is The Tank a permanent hub button overlaid on the map, or is it one of
   the 10 sites (e.g. always at position 0)?
Pos 0. Always.

  4. How does the player unlock new levels — strictly linear (complete level
   N to unlock N+1), or are there branching paths?

Linear

  Identify Phase (ui02identifyphase)

  5. Is there a minimum number of species the player must tag, or can they
  confirm with just one selection?
Just one is fine.

  6. Does the "I'm not sure" option apply to individual species chips (skip
  a specific one) or to the whole phase?
Whole phase.

  7. What happens to the level difficulty/starting materials if the player's
   identification is completely wrong vs. partially right?
Well, we don't know immediately - longer-term, once other users classify the same images, we'll have to have a github action that triggers regularly identifying the average and then giving users an accuracy score...

So plan this architecture out.

  8. Can the player zoom/pan on the Zooniverse image before making selections, or is it fit-to-screen only?
Zoom will be great!

  9. Does the identify phase show species chips for every possible species in the game, or only plausible species for that reef site?
It should show all options.

  Fish Cards (ui03fishcards)

  11. What's the maximum number of species that can exist in one level — and
   if there are more species than visible cards, how does the player scroll
  or paginate?
There's no limit.

  12. When a card is selected and expanded, do the Feed and Net actions
  appear as buttons within the card, or as overlay icons on the reef
  viewport?
Overlay icons

  13. What does "Net" do exactly — remove fish from the reef entirely, move
  them to The Tank, or something else?
From the reef entirely. But there needs to be some sort of limit/restrictor on its use, like with everything.

  14. If a species hits population 0, does its card disappear or remain as a
   greyed-out "extinct" card with a revive option?
Extinct. No revive. 

  Auto-Breeding (gp01autobreed)

  15. When an egg appears in the viewport, can the player tap it to interact (e.g. speed up hatching, select which zone it lands in) or is it fully passive?
They tap it to hatch and then drag it to the zone.

  16. What visual/audio signal warns the player that a breeding event is about to happen vs. just showing the egg appearing?
Maybe a little flashing or other animation...

  17. If the population cap for a species is reached, do new eggs still appear and just fail, or does breeding halt entirely for that species?
Eggs still hatch, but then the fish population won't have enough food and some of them will start to die.

  19. Is the 30–45 second breeding timer paused during the turn results
  panel, the shop, or the identify phase transitions?
No.

  Turn Results Panel (gp02turnresults)

  20. Is "End Turn" a button the player presses, or does the turn end
  automatically (e.g. when nutrients hit zero)?
When `nutrients` hit `0` or when the user chooses to end the turn manually. 

  21. Does the turn results panel block all input, or can the player dismiss
   it early by tapping anywhere?
Blocks all input

  22. If a win/fail condition triggers, does the results panel show first and then transition, or does the win/fail screen come up immediately?
The results panel should still show up first

  Resource System (gp03resources)

  24. When the player adjusts an environment dial (salinity/temp) mid-puzzle, does the cost come from the current turn's nutrients or a separate pool?
A separate pool. In the real world salinity wouldn't affect the population of nutrients. Think of the real world

  25. Is there a visual indicator on the reef viewport that shows current water conditions (e.g. a thermometer/salinity gauge) at all times, or only when in the adjustment UI?
There should be a visual indicator

  26. The BottomResourceBar shows Nutrients + Coins — does it also show the current turn number and turn limit, or is that a separate HUD element?
Figure out how to show everything without making things too complicated

  Level Content & Difficulty (gp04levels)

  28. What is the "kill a coral" mechanic in Levels 6+ — does the player deliberately remove a coral to make space/resources, or is it a threat they must prevent?
So, certain fish will increase or decrease the population of different coral species, and vice-versa. Same with weather/climate conditions. Create a knowns doc with all the mappings and follow from this always.

  29. For Level 1 specifically, what species are present and what is the win
   condition (target reef makeup)?
Come up with a simple setup for a tutorial mission (mission 0), mission 1 will always be based on the user's interpretation to one of the images.

  30. Do stressors (kill/aid interactions) need to be explained to the player via a tooltip o tutorial popup the first time they encounter them?
Yes, tutorial mission
  
  31. Is there a narrative/story framing for each level (e.g. "This reef was  damaged by a storm…") or are levels purely mechanical?
There would be narratives for the "sandbox" level later (remind us to come back to this in 3 sprints time from now), not for the individual levels.

  32. When levels are replayed, does the same Zooniverse image always appear, or does it pull a different image from the same species pool?
Different image, there is no species pool. It's just one single population. But when viewing the user's history for each level it would show all images they've seen.

  Sprites & Visuals (sp01sprites248)

  34. For species that appear both in the fish card strip (72px display) and the reef viewport (90px display), is the same 248px source sprite used and just scaled, or are there separate art passes?
Create a new art pass for this.

  35. Are there any species that have directional variants (left/right facing) or is mirroring handled at the engine level?
It depends on which way they're facing, just create different animations using the godot animator - not using gd scripting.

  Sound & SFX (sp02sfx)

  37. Is there a persistent ambient background track (looping), or does ambient sound switch based on the current phase (identify, puzzle, level end)?
Ambient sound would switch, there will be a backing track later.

  38. Does the game have a music track separate from ambient SFX, or is the "relaxed underwater feel" achieved purely through ambient sound design?
There will be a backing track later.

  39. Are sound settings (mute, volume) exposed in-level or only from a main
   menu/settings screen?
Main settings screen.

  The Tank (sandbox hub)

  40. How frequently does The Tank generate resources passively — is it real-world time (e.g. every 4 hours) or session-based (every time the player opens the app)?
Real time.

  41. Can the player place and remove fish/coral in The Tank freely, or are there placement rules (zones, costs) like in puzzle levels?
There still will be costs but they'll be more relaxed. The main difference is it's a never ending and (eventually) unlimited sized level so the user can do whatever they want, but they still have restrictions based on resources.

  42. Are fish and coral the player breeds/earns in The Tank the same pool used in puzzle levels, or are they separate inventories?
The rewards the users get for completing a level can be used to complete other levels or in the sandbox level. Fish/lifeforms stay in their level or sandbox.


  Offline & Sync (inf01offline)

  44. If a player completes a level while offline and their classification goes into the pending queue, do they still get coins/rewards immediately, or are rewards held until sync?
Held until sync

  45. Is there a visible indicator in the UI when the player is in offline mode (e.g. a small icon), or does the game behave identically?
Identical behaviour

  Onboarding & Polish

  46. Is there a tutorial for Level 1 that walks the player through identify → turns → end turn → level complete, or does the game expect players to figure it out?
Tutorial for l0 - see above

  47. When the player first opens the app with no save data, do they land on the world map immediately, or is there an intro sequence (cutscene, brand screen, etc.)?
World map immediately


# Sketches
**Two things to sketch out:**

**A. The Level End / Transition screen** — what does the player see when a level completes? (score summary, species unlocked, a real reef photo from that site, a "real impact" stat like "you helped classify 12 corals"?) Rough wireframe or bullet list of elements would help.

**B. The upgrade shop layout** — how is it presented during play: a sidebar, a pause-screen panel, a floating button? And roughly what are the first 4–5 upgrades in release one? A sketch or ordered list with approximate costs would let me wire it up directly.