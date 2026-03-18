---
sticker: lucide//chevron-down
tags:
  - Questions
  - Specs
  - experiment1
---
Q1 — The rocket economy after a scrap: how do players replenish?
  You said cancelling a mission auto-scraps the rocket, and rockets are
  single-use. That means every mission consumes a rocket. Where do new
  rockets come from — is there a "rocket store" on the Earth base screen, is
   it just a buy button, or is it a more involved purchase flow? And does
  the player start with a stockpile of SR1s, or do they have to buy each one
   individually before each mission?

Yes, the user builds or purchases a rocket. Every time.

  Q2 — The calendar/date system for contractor cooldowns: real-world time or
   in-game time?
  You said a calendar/day system sounds cool. Big design fork here: if the
  calendar advances based on real-world time (a day = a day), then a 30-min
  cooldown is just a 30-min wait, and the calendar is cosmetic. If the
  calendar advances per mission (each launch = a new in-game day), then the
  calendar is mechanical — it determines how many missions you can run per
  "week," which contractors reset, etc. Which direction do you want to
  explore?

Well different missions would take different times in-game, so I think based on real-world time, but obviously sped up.

  Q3 — What does the star map show after Mission 1, and when does it feel
  "alive"?
  The star map is visible after M1. At that point, the player has visited
  one asteroid. Does the map start showing: (a) only visited targets, (b)
  all known targets in the catalog regardless of visits, or (c) a
  gradually-revealed portion of the catalog? The difference is significant —
   option (a) starts almost empty and grows with the player, which is more
  personal; options (b)/(c) start populated but less "mine." Which feel do
  you want from day one?

It should reveal different sectors, keeping in mind that asteroids will appear in the Earth solar system, and other planets will appear in different systems. We'll need to generate solar icons...for this.

  Q4 — Other players at your bases: what can they actually do, and do you
  get notified?
  You said "other players visiting your bases" is a retention hook. What's
  the mechanic in practice? Do they just see your base as a visual when they
   visit the same asteroid? Can they use your refinery, dock at your relay
  station, or leave a message? And critically — do you get any signal that
  someone visited? A notification that says "Zhong visited your relay at
  TIC-3924110 and paid 12M F docking fee" is a very different loop than just
   passive co-existence.

So it's being able to have a user be notified that their classification was backed up or challenged by another user (e.g. I said an anomaly target wasn't real, and therefore couldn't visit it...and then someone else disagreed). Being able to see the consensus.

3 sprints from now (ADD REMINDER), we'll be able to customise and extend multiplayer further.

  Q5 — Contractor mission generation: authored templates vs. procedural vs.
  AI?
  You said templates should be reusable, with location always as a variable.
   But who/what generates the actual mission instances? Three options: (a)
  missions are pre-authored per contractor but filled in from a template
  (human-written), (b) missions are algorithmically generated from template
  components at runtime, or (c) AI generates mission text from template
  structure. The answer shapes how many missions a contractor can
  realistically offer before repeating. Which direction are you imagining?
Combination of b) and c). I just don't want the codebase to get too large. You know the rought format based on my answers - so set something up.


  Q6 — The first structure at L5: guided tutorial moment or open sandbox?
  L5 is when the player first builds something. Should this be: (a) a guided
   moment where the game specifically prompts "build your first relay
  beacon" with reduced cost and a walkthrough, or (b) fully open — the build
   UI just unlocks and the player explores it? Given that building is
  currently described as a "sell minerals → get structure" conversion, does
  the first build need to be especially legible, or is the low-friction
  conversion model enough?
So there would be new missions coming up to build certain structures, if a mission (type) from a contractor introduces a new mechanic/step (refining, construction, placing, etc), then there's a tutorial the first time that mission type is attempted.

  Q7 — Off-world refinery (L7) operation before 2-mission unlock (L8):
  blocking or passive?
  If a player builds a refinery on an asteroid at L7 but can't run 2
  missions until L8, they'd have to travel to the asteroid (using their one
  mission slot) just to pick up refined goods, then return to sell them —
  meaning the refinery competes with contractor missions for the single
  slot. Is this the intended design (refineries become truly useful at L8
  when you can dedicate a slot), or should off-world refineries operate
  passively and auto-produce without requiring an active mission slot?

Yes, it's intended.

  Q8 — "Experiment 1" as a name: temporary experiment label or actual brand?
  Is "Star Sailors: Experiment 1" the intended public-facing branding for
  this build — i.e. the game is literally called that to users — or is it a
  dev/testing label while "Planet Hunters" or another name is the eventual
  product name? Knowing this affects whether the docs and codebase should
  fully migrate naming or keep "Planet Hunters" as the canonical internal
  name with "Experiment 1" as the current build label.

It's Experiment 1 for the early versions. Planet Hunters is the name of one of the citizen science projects in the game and therefore should never have been used as a title, not even a working title...I don't know where you got that from.

  Q9 — Non-starter rocket acquisition: where and when does the player first
  see one?
  You mentioned non-starter rockets require room slot selection. When does a
   player first see a non-starter rocket — is it available in the store from
   L1 (just locked/expensive), or does it only appear once a specific level
  or mission is reached? And is there a visual in the hangar from early on
  showing "this is what you're working toward" (the locked non-starter
  slots), or is it a complete surprise reveal?
Again, it's when the user unlocks rooms...I've answered this question...level 5.


  Q11 — Where does a player buy rockets, and can they stockpile?
  Right now rockets are single-use and a cancel auto-scraps. But where in   
  the Earth base UI does the player actually purchase a new rocket? Is there
   a "Rocket Store" or "Hangar Shop" screen — separate from the launchpad — 
  where you browse and buy? Can the player pre-buy two or three SR1s in     
  advance before the first one even launches? Understanding the purchase
  flow shapes how the mission cap feels in practice.

Look through the codebase...when they start a new mission...wow. 

  Q12 — What's the bankruptcy escape valve?                                 
  A player who spends all their Francs on a rocket, launches, then fails the
   mining minigame could lose both the rocket and the minerals. If they have
   zero Francs remaining, are they stuck? Is there always a fallback — e.g.
  a "starter mission" at no cost, the ability to sell a structure back, or a
   Francs floor that the game won't let you go below? Or is starting over
  from zero considered a valid game state?
I think a loan system with a very low interest rate.


  Q13 — What does a post-M4 free-ops mission debrief show that the tutorial 
  debrief doesn't?
  The current debrief was designed for the tutorial arc. Once a player is   
  doing free-ops contractor missions, the debrief needs to communicate more:
   affinity change, contractor satisfaction, whether the payout beat what
  the open market would have given, and market prices for what they         
  delivered. Which of these are shown at M4+, and is there a design goal for
   the debrief to feel like a "business review" — did this run make sense
  financially?

Well not all launches the user does will be for a client/contractor. Once a rocket is empty or destroyed (salvaged/scrapped/whatever), the user reviews everything. I don't mind in what way.

  Q14 — Do players have a personal discoveries log, and when does it matter?
  Players get XP boosts for discovering new TESS targets. Is there a screen
  somewhere — maybe on the star map or a profile screen — where a player can
   see "you discovered these 7 objects, your name is attached to them"? When
   does this personal history become a meaningful identity feature? Is it   
  from day one (visible but sparse), or is it only surfaced once the player
  has enough discoveries to make it feel significant?

Yes. From D1.

  Q15 — Contractor panel: job board or one contractor at a time?
  Post-M4, does the contractor selection work like a job board — the player
  sees all available missions from all available contractors simultaneously 
  and picks one — or does it work like visiting NPCs — you tap each
  contractor individually to see their current offer? A job board creates   
  more comparison and strategy; visiting NPCs creates more personality and
  relationship. Which feel do you want, and does the answer change between
  early (3 contractors) vs. late game (10 contractors)?

Job board, later game there would be characters (3 sprints from now - reminder!!)

  Q16 — What keeps the scanner station relevant at L6+?                     
  By L6, a player has visited many targets, has known asteroids catalogued,
  and knows where profitable targets are. The scanner station is described  
  as "optional once known targets exist." What actively pulls a player back
  to it at mid-to-late game — is it: new TESS candidates arriving daily,    
  anomaly alerts for unusual targets, scanner upgrades that reveal target
  richness before visiting, or something else? If nothing pulls them back,
  the scanner station becomes a tutorial-only feature.
New candidates, new candidate types, seeing others' answers/classifications.

  Q17 — Is a free-launch mission (no contractor) different in any           
  non-economic way?
  Beyond the payout difference (80% vs 120%), does a free-launch mission    
  feel different to play? Does it get a different debrief screen, different 
  XP calculation, different discovery bonus eligibility? Or is it identical
  mechanically with just a lower payout? If there's no other difference, is 
  "free-launch" really just "I'm selling to market instead of a contractor"
  — and does that need its own mission type at all?

Well the user can do whatever they want. It can be done if they want to build something on their own, for example.

  Q18 — What should one level-up feel like in terms of session count?       
  In the early game (L1–L3), how many runs should it take to level up — one,
   two, five? At mid-game (L4–L6), does it slow down and if so by how much? 
  The concern is: if early levels happen inside a single session, the
  Marketplace (L5) and room upgrades might arrive before the player has had 
  time to understand the economy they're about to see more of. Is there a
  target cadence — e.g. "L1–L3 within the first 3 sessions, L4–L6 over 2
  weeks"?

Yeah, let's say that the first few missions (until end of the full tutorial get user to l3, then it takes increasing amounts of xp...do some research and figure out a good...figure.)

  Q19 — Does the Earth base screen change visually as the player builds     
  things?
  At L1 the Earth base has three structures (satellite station, control     
  station, launchpad). At L4+ the player can upgrade them, at L5 they can   
  add new ones. Does the Earth base look different — do upgrades appear
  visually on the base screen, like a pixel-art city that grows? Or is the  
  visual static and changes are just reflected in UI panels/stats? This is a
   major art and motivation question — does "build your base" feel like
  watching something grow, or is it a menu-driven stat upgrade?

Yes, it should grow...this is extremely important

  Q20 — What's the minimum viable push notification, and what's the         
  self-hosting plan?
  Self-hosted push notifications are required (no OneSignal). The planned   
  events are: rocket arrival, construction complete, contractor available.  
  What's the MVP — skip push entirely for now and use in-app banners only,
  or implement basic push from day one? And on the self-hosting side, is the
   plan to use the existing Supabase backend + a service worker, or
  something else? The answer determines whether notifications are a
  near-term dev task or safely deferred.

Let's implement a basic push from d1.
I'm open to any option.