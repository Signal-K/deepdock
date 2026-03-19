---
tags:
  - Questions
  - Specs
  - Experiment
  - experiment1
  - PlanetHunters-Experiment1
  - Experiments
sticker: lucide//vibrate-off
---
**Gameplay**
1. What does the progression arc look like beyond Mission 3? Does each mission introduce new mechanics, or is it the same core loop with different targets?
Answer: Users will be able to visit planets or asteroids, or really anything else. Longer-term, users may want to build settlements, conduct expeditions and research off-Earth, etc. In the short-term, users/players will basically just be doing simple mining and building (it can't feel too repetitive, though, so simply having contractors request resources and fulfilling them will get old fast. So, we need to work on something like contractors may not have the money to give you another mission for another few "days" (in-game), so the player may have to go to someone else to get work. Or the contractor may ask the user to find a certain type of target, or build simple infra there.).

There's also the citizen science integrations, for now this is limited to just finding asteroids, "active" asteroids, and planets by annotating over graphs - but this would be extended long-term.

    
2. When a player runs out of rockets or has nothing to do, what's the intended experience — cooldown timer, earn-more mechanic, or should there always be infinite content?
Answer: So they don't ever really run out of rockets; they just have to buy more. See point 1 for more info on content.

The first 3 missions are tutorial missions, and mostly scripted. These have to be completed by the user. Later missions are all optional, some missions may only be offered by one contractor, some missions may turn out to not be profitable, some may require researching new rocket parts (including reusable rockets, longer-term).
    
3. Is the scanner station meant to be the central activity of a session, or is it one of several equally-weighted things a player might do?
Answer: It's only really used in the early game if the user wants to find new targets, if they just want to visit already "known" targets (e.g. Kepler-22b vs TIC 2665475..., one is confirmed to be a real planet and one is a candidate provided from the TESS/lightkurve dataset...), they won't need to use the scanner. 
The scanner will autonomously find discoveries from other users, offering users a "fast-tracked" method to confirm that someone's discovery is true/false (e.g. if user b is looking at a candidate user `a` rejected, and disagrees, user `a` could then revisit it, and they both get points). This is a longer-term mechanic.

On those longer-term mechanics, spec sheets should be created in Knowns but I don't want tickets created yet, just so we don't clog things up.
    
4. How do you want difficulty to scale? Does classifying TESS targets get harder, do new catalogues introduce new challenge types, or does it stay accessible?
Well there's no way to know if a TESS candidate is "difficult" until the user plays it, so this isn't possible.

---

**Long-term citizen science**

5. Do you want real disposition outcomes to flow back to players — e.g. "TIC 123456 was later confirmed as a planet, you helped!"? If so, how/when?
Answer: See point 3.
    
6. Is the classification data being reviewed by actual astronomers, or is the citizen science primarily for player engagement and the data is a side effect?
Answer: Long-term, yes, we'll be transmitting it to interested parties

7. Should there be a collective community progress indicator — e.g. "Planet Hunters have classified 12,000 TESS targets together"?
Answer: Long-term, yes. Immediate - no
    
8. What happens to a player's science contributions if they stop playing? Is there any concept of a persistent legacy or record of what they found?
It stays in Supabase...

---

**Construction & multiplayer**

9. What exactly is the construction mechanic — what are players building, where, and at what scale (personal base, shared station, something else)?
Answer: Settlements, mining stations, "relay stations" (i.e. outposts to refuel, "repeat" transmissions (like Redstone repeaters)), etc. See Tiny Space Program for a good guide.
Longer-term, we'd have more Sandbox mechanics, so it would ideally be something a little bit like Crashlands from the UX, perspective and mechanics. I'd like users to have some freedom over the materials and shapes they build. We'd need simple crafting & refineries/furnace mechanics setup.
    
10. Is multiplayer real-time, async, or more like a guild/alliance structure where you cooperate over days/weeks?
Answer: It's sort of async - point 3 sort of describes it. Users find things, and can share them or request feedback/help/investigation. No strict real-time multiplayer or visiting friends in-game - yet.

11. Does construction require resources earned from missions/mining, or is it a separate system with its own inputs?
Users can go and mine stuff, if they don't do it as part of a mission they'd see a market demand for different minerals, or they can use what they mine for building.

12. Can players grief or compete destructively, or is it purely cooperative?
Cooperative

---

**Star Sailors ecosystem**

13. How does this game relate to the existing Star Sailors — shared accounts, shared universe, shared economy, or largely separate?
Shared accounts, XP from this game would be added to their XP for the Star Sailors minigames relating to discovering physical astronomical anomalies.
    
14. Is there a canonical story or lore connecting the games, and does progression in one affect the other?
See Point 13. It's basically a little minigame.
    
15. Are Francs/XP shared across the ecosystem, or siloed per game?
See point 13. Francs are not shared.

16. Is there a planned player identity layer (profiles, cross-game achievements) or does each game stand alone for now?
Same db. See point 13.

---

**Finishing v1**

17. What platforms must work at launch — web only, mobile PWA, desktop, or all three?
Web, mobile PWA

18. What's the minimum feature set that makes this feel "shippable" to you — a story ending, a feature checklist, a certain number of missions?
I think that's for you to decide
    
19. Are there any legal or data-privacy considerations for publishing player-generated science classifications (IRB, GDPR, etc.)?
No

20. Who is the target player for v1 — existing Star Sailors users, general casual gamers, or people already interested in citizen science / astronomy?
A combination



## Longer-form: construction Q&A
> Working with Gemini


  10 Long-Form Questions (Narrative, Mining & Mechanics)

   1. The Mining Loop: In Tiny Space Program, mining is about sending ships to asteroids and waiting. In our Godot scene, is the user's presence required to mine (Active), or can they start a mining operation in Godot and then close the app (Passive)?
Answer: There's a mining minigame - side-scrolling. You should already know this because you've gone through the codebase...

   2. Pixel Starships Room Mechanics: If a player adds a "Mining Laser Room" vs. a "Cargo Bay Room," how does that affect the stats? Is it a direct multiplier on the payout_francs in the mission_logs, or does it unlock more "slots" for rarer materials?
Right now, there's not much control over rooms (let's revisit in two weeks). Rockets will all have the same rooms. Mining laser upgrades will just allow more of a target to be mined, as well as tougher materials. This isn't really relevant for the first 3 missions. Cargo bay extensions allow for larger orders to be fulfilled. E.g. after mission 3, if a contractor offers a mission for `x` of mineral `y`, but the user only has the first level of cargo bay room for their rocket, which has a capacity `< x`, they can't fulfill it. They will be informed of the reason why they can't take that mission (yet). 

   3. The "Shared World" Asteroids: When a player discovers an asteroid in this minigame, does it become a "Shared Mining Node" for everyone in the Star Sailors ecosystem, or is it a private instance for that player?
So...anything found is shared. In THIS godot game, anything discovered will be able to be mined. In the main web game, available at `starsailors.space`, there won't be any crossover - for now - because this integration is not a priority. Longer-term, asteroid/planet discoveries made in all parts of the ecosystem will translate to all other parts.

   4. Character Roles: Since we're adding PSS elements, can a character be assigned to a specific room (e.g., "Engineer" in the "Engine Room" reduces fuel cost)? How do we visualize these characters in Godot?
Yes, this would be possible - but characters aren't being developed yet.

   5. Construction vs. Fleet: Are we building Ships (moving objects) or Outposts (static mining stations)? Can a ship "dock" with an outpost to offload cargo?
Ships are built on Earth, long term they could be built elsewhere - come back to this in 4 weeks. Docking - 4 weeks, again.

   6. The TESS-Mining Link: If a lightcurve scan reveals a "Planet," does that node yield higher-value materials (e.g., Rare Isotopes) than a standard "Asteroid" node?
Planets have a capacity of 5-20x of largest asteroids, depending on the size. Remember, users can visit targets without having to do a citizen science scan/classification - because planets and asteroids will already exist (either from a predefined list, or because other players have discovered them). Users get an xp boost and affinity boost if they do discover something, though. 
So if they are completing a mission from a contractor (later, users can build their own missions - but this is a long way away) like "find me `x` of `y` mineral", they can go to a target already, or they can search for a new one.

   7. Economic Sinks: Besides buying more rockets, what can a player spend 10 billion Francs on? (e.g., "Interstellar Gateways," "Space Station Modules," or "Science Funding" that buffs the whole community?)
For now, just rockets and upgrades. Construction would be for settlements, setting up mining bases, refineries, etc...but this is a few weeks away.

   8. The Narrative "Incidental": As a player mines, should they encounter "Logs" or "Artifacts" that reveal the story of the Star Sailors? (e.g., "Found a message from a lost explorer at Sector 7").
Set something minimal up where they can find "non-organic" artefacts or objects of interest (for now), I do want to explore a wider narrative and eventually alien/ET stuff later, but this is a few sprints away at least.

   9. Exploration Hazards: Does the ship take "Damage" (Wear/Tear) during mining? If so, does the "Pixel Starships" repair mechanic happen in real-time in Godot, or is it a menu action in React Native?
There's a limited usage of the laser and they have fuel limits (limits how long they can be mining and orbiting the target for). Long-term, adding obstacles and maybe simple enemies would be considered.


   10. The Release Today Goal: What is the "Victory Condition" for a user's first 10 minutes? Is it: "Successfully launch, mine one asteroid, and sell the cargo"?
Completing the first 3 missions.


  10 Short-Form Questions
   11. Is "Fuel" a resource we need to track today?
Not yet, fuel is just used per-rocket for now. Later on, we'll have fuel refineries and other things so users can refuel, but right now rockets aren't refuelable or reusable
Also on this - there would be buildings like refineries, but really long-term (maybe in the full game only, maybe in this "experiment"), users would be able to build refineries out of whatever they want as long as they have the minimum parts for function. E.g. so rather than just placing down a "refinery" "block"/building, they can play around a bit more.

   2. Should the Godot scene zoom out to a "System Map" for navigation?
During navigation, this could be good.

   3. Are characters recruited via Francs, or found during exploration?
Not sure yet. Add all stuff regarding characters to a knowns spec sheet that will automatically be re-visited/triggered in two weeks - characters aren't relevant for now.

   4. Does "XP" unlock new room types for construction?
Yes, but, like with characters, this isn't relevant for now.

   5. Is there a "Global Leaderboard" for most materials mined?
No, but there would be a leaderboard later for missions.

   6. Should "Anomalies" (mining nodes) disappear once they are depleted?
Well, users can upgrade their ships and lasers to extract more (go "deeper"), and they can also build on targets. Additionally, we don't want literally everything from a target to disappear...i.e. be mined. We can say that it's listed as "depleted" so you can't mine on it (unless you have a rocket with a laser that is powerful enough to get the next "level" of material), but it can still be visited...

   7. Can a player have multiple rockets mining simultaneously?
Yes, they can be taking part in multiple missions or journeys, but obviously they're only able to mine one target at a time because the mining is not a passive mechanic, it's a minigame.

   8. Do we want "Permadeath" for ships if they run out of oxygen/power?
Not yet

   9. Is the "Construction" UI a grid-based builder in Godot?
Haven't figured this out yet. Need to revisit this next week.

   10. Do you have a preferred "Art Style" for the rooms (e.g., 8-bit, 16-bit, or low-poly 3D)?
Combination of Crashlands and Pixel Starships I'd say. 




IDEAS:
  Mechanics Sketch Requests


   1. The "Mining Laser" Sketch: How does it look when the ship is active? Is there a beam connecting the ship to the asteroid, with numbers popping up?
   2. Construction/Room Placement: Describe the flow of placing a "Medical Bay" in a ship. Is it a "Drag and Drop" from a sidebar?
   3. Discovery Reveal: When a "Planet Candidate" is confirmed, what's the big visual payoff? (A cinematic camera sweep of the new planet?)

  ---

  Weekly Sprint Goals (AI-Powered)


  Sprint 1: The Mining Foundation (Release Today)
   * Goal: A playable "Launch -> Mine -> Sell" loop connected to Supabase.
   * Tasks: Replace local JSON with Supabase player_profiles and player_rockets sync; Implement the Godot mining interaction; Create the "Sell" UI in React
     Native.
   * AI Strategy: I'll focus on the data bridge; you focus on the Godot visual feedback.


  Sprint 2: The "Pixel Starships" Expansion
   * Goal: Ship interior management and characters.
   * Tasks: Build the "Room Builder" UI; Add character roles and stat-buffs; Sync rooms_json to the cloud.

  Sprint 3: The Shared Universe
   * Goal: Community goals and shared mining nodes.
   * Tasks: Implement "Global Anomalies"; Add a community progress bar for discovering new sectors.


  Sprint 4: The Construction Hub
   * Goal: Building Outposts and Research Labs.
   * Tasks: Static station construction; "Research" items that bridge to the main Star Sailors webapp.


  How would you like to handle the "Launch" mechanic? Should it be a physical Godot transition from Earth/Station to the Asteroid, or a "Fast Travel" menu?


### Bigger Q&A
1. When a player enters Free Ops (post-M4), what does the base screen look
   like vs the tutorial era — same hub, reskinned, or meaningfully different layout?
Same hub, eventually more structures become usable and structures (like the launchpad) can be upgraded, creating visual differences down the line.

  2. For the two Free Ops routes (contract / survey) — is the player picking a route at the start of each run, or does it describe different ongoing modes they're always in simultaneously?
Basically, unless the contractor requests a specific location, the user picks the target that they think is going to give them the best chance of completing the mission.
They don't really have to pick the route, by default (and for the forseeable future) there would be autopilot. Flag this for the future.

  3. What's the failure state for a survey run where the candidate isn't confirmed — does th player return home with flat XP only, or do they still collect any minerals from the transit/approach?
Again, I've answered this - if they pick a candidate, annotate it and think it isn't real, they get some XP and have to pick a different target/candidate

  4. Soft cooldown on the scanner — what does "soft" mean exactly? Cooldown timer visible to the player, degraded results, or just a narrative nudge?
I don't think I ever described anything relating to a soft cooldown

  5. Does the scanner ever pull from a finite pool of unconfirmed candidates per player, or is there an effectively unlimited queue of TESS anomalies to work through?
As long as it can pull from a TESS db, unlimited.

  ---
  Contractor System

  7. Contractors are selected per-run — does the player see all available contractors before committing, or is the offer randomized / rotated each time?
Contractors eventually run out of missions `m8v4phj` to give to the user, so the user either needs to do other missions, do their own thing or wait...as users progress through the game, they unlock more contractors. And therefore more missions.
  8. Contractor cooldowns (task m8v4pj) — after a contractor finishes a job, how long are they unavailable, and is this communicated as story flavor ("off on another mission") or as a raw timer?
It would just say that the contractor doesn't have any missions for you at this point. 30 minute cooldown after doing 2 missions in a row for the same contractor/client.
  9. What does contractor reputation mean in practice — does it unlock better offers from that contractor, change their dialogue, or affect payout ratios?
Increased payout (affinity bonus), more missions.

  10. Is there a mechanic for contractors to fail, underperform, or surprise the player positively? Or are contractor effects deterministic given your inputs?
Contractors are giving missions. You're the one that fails/underperforms

  11. Long-term, can players lose access to a contractor permanently, or is
  the relationship always recoverable?
As long as a contractor has missions, they're available


  ---
  Construction & Settlements

  12. For the construction system, is the build site always Earth Base, or
  can players establish structures on visited asteroids/planets?
Eventually they can build anywhere

  13. What's the minimum viable construction feature — is it just a "spend minerals → unlock passive bonus" system, or does it involve actual spatial/layout placement like Crashlands?

Ideally we would have things where users place blocks and structures to refine minerals, so they can refine them on the planet/asteroid, increasing their value. This mechanic/concept would also allow them to do refuelling on the target, allowing them to visit a target, mine, then refuel and go further out

  14. What do relay stations/outposts actually do for the player — reduce travel time, extend scanner range, unlock new target bands, or something else?
Scanner range would be something that can be increased at Level 8 (make sure to mark this specifically), measured in LY.
It would reduce travel time as well, if rockets can be built and launched from places other than Earth.
It would also mean that users can build things there and conduct research there - eventually we'll introduce populations that you send somewhere (like rovers or astronauts) that can't remain in a hostile environment for long periods of time.

  15. Can settlements be lost or damaged (by in-game events, neglect, etc.), or are they permanent once built?
Will never go below 20% durability but yes, both concepts would cause damage.

  16. Is the crafting/refinery loop a prerequisite for construction, or can raw mined minerals go straight into buildings?
Users can sell raw materials for a net value (based on marketplace - this should be an existing concept already in the notes, and marketplace would become visible to user at L5, allowing them to time when they want to sell and buy and mine certain things. Remember, after the tutorial the user can just do mining and discovery themselves, or they can fulfil orders from other people - the contractors), which is usually around 80% of what it will be valued at by a contractor who needs it for a project (which is what happens when users work on orders for contractors, e.g. if 'contractor a' needs x minerals, they'll pay ~20% more for it than the base price, which is not the same as the market price.). 

If they want to build a structure, they can either buy the structure using Francs, and then transport it to the location. Or, they can craft it from raw materials. Or they can buy the structure by selling unsold, unrefined minerals - this gives a 15% discount (based on market price of the minerals) if the minerals would be part of the make-up of the structure.


  ---
  Mineral Inventory & Economy
  18. Once the persistent mineral inventory (v7u2n9) exists, where does the player see it — always visible on the base screen, tucked in a submenu, or only shown when relevant?
No idea, whatever is best

  19. Is there a market/sell mechanic for excess minerals, or do minerals only have value as construction inputs? What sets the sell price — fixed, fluctuating, or tied to supply?
See answer to Q16. But the more you sell excess minerals to "the market", the more the value dips

20. Do different rocket types or contractors affect what minerals can be extracted, or is mineral type purely determined by the target?
Mining laser levels determine how much of the total allotment of each target can be mined. A stronger mining laser/drone will also unlock the hardest/strongest materials.
Room upgrades will allow more storage and for the mining minigame to be played for longer


  21. Is there a mineral capacity limit per mission (rocket cargo) that forces the player to prioritize, or do they always collect everything the target offers?
See answer to Q.20

  22. What happens to minerals if a mission fails (e.g., mining minigame failure) — total loss, partial recovery, or salvage mechanic?
Tutorial - failure message and then restart
Otherwise - salvage and then option to restart with the penalty

  ---
  Procedural Generation (yn7owq)

  24. For terrain uniqueness per target — is the visual difference important to the player (they notice they're somewhere new), or is it purely mechanical (different mineral regions)?
Both

  25. Should landmark features on a procedurally generated asteroid/planet have names the player sees, or are they anonymous gameplay zones?
Simple labels will be fine

  26. Will procedural targets ever have narrative hooks (e.g., an anomaly the player discovers mid-mine), or is proc gen purely resource-layer content?
Not for a while - come back to this in the sprint two weeks from now (REMINDER!!)

  ---
  Star Map

  28. What is the star map's primary UX purpose — trophy shelf (showing what you've found), navigation tool (choosing next destination), or both?
Both
  29. Does the star map update in real time during a transit, or only after
  return/debrief?
Only after debrief
  30. Should the star map visually show real astronomical coordinates (even loosely accurate), or is it a stylized "your discoveries" board?
Maybe a bit of both

  ---
  Citizen Science Depth

  32. Post-M4, how often does a player actually encounter a real classification task (annotating a light curve) vs a flavour-only "science moment"? Is there a target cadence?
It's up to the user how often they want to do full scans. That needs to be made clear to the user
  33. If a player's classification turns out to be part of a genuine discovery confirmation, how does the game communicate that to them — immediate notification, retroactive update, or a community news feed?
Notification

  34. Is there a science score or annotation level that's separate from XP, and does it visibly affect anything in-game beyond the discovery travel bonus?
No.

  35. Can two players classify the same TESS anomaly and see each other's annotations, or is all citizen science work currently siloed per account?
They can see everything and work together on the same objects, there's a consensus factor too.

  ---
  Long-term Retention & Engagement

  37. What's the intended play session length for a Free Ops player — quick 5-minute run, or deeper 20-minute session? Does one "run" fit in one session?
Ideally 10-20 minutes.

  38. Is there a daily / recurring hook planned (daily scan refresh, contractor reset, rotating targets) to bring players back, or is engagement driven purely by mission goals?
I would like there to be daily missions as well as special effects - like the Halloween specials in Dragonvale, for example. Maybe based on scientific events too.

  39. Beyond the 5 starter rockets, what signals to a player that there's more rocket content coming — is there a visible "locked" slot in the hangar, or is it a surprise unlock?
There would be locked parts (boosters, rockets, shuttles, etc) - there would be a new section that shows "individual parts" along with some sort of indication that the user can use these to build their own ship

  40. Wear progression on rockets is permanent per rocket — does this mean a rocket can become visually distinct from another identical model, and is that visible to others in future multiplayer?
Yes, but only if it's reusable or until it finishes its mission (if it isn't reusable)

  ---
  Rocket & Room System

  42. The room/bay system (RoomCatalog.gd) currently exists in code — at what point in progression does the player first interact with room upgrades, and what's the first room unlock they'd experience?
Level 5

  43. If a rocket is retired or scrapped, do its installed rooms go back to inventory or are they destroyed?
Destroyed - that's part of the salvage record

  44. Is the room upgrade flow meant to be a separate screen/UI (like a loadout screen before a mission), or integrated into the launchpad scene?
Separate screen

  ---
  Mobile & PWA Experience

  46. For the PWA install prompt — after a player installs, should their first launch of the installed app feel different (e.g., a short "welcome back" beat), or seamlessly pick up where they left off?
Welcome back - here's what's happened since you last visited (for any AFK events)

  47. Is push/local notification support on the roadmap for notifying players when a mission returns (given real transit times are simulated)?
This would be cool, but I don't want to do Push notifications through someth like OneSignal - it has to be something that doesn't rely on another service. Push notifications for when a rocket reaches its destination, maybe for when construction finishes, when a contractor has a new mission, etc.

  ---
  Meta / Vision

  49. At what point does a player "win" Planet Hunters, or is the design intent an indefinite loop? Is there a narrative endpoint, a prestige reset, or does success look like scientific contribution milestones?
It's a minimal sandbox approach. No winning.