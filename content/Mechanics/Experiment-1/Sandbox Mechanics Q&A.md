---
tags:
  - Sandbox
  - Questions
  - experiment1
sticker: lucide//brain-circuit
---
 ---
  Rocket & Ship Architecture

  Q1 — Room layout: prescriptive vs. expressive (Pixel Starships / FTL
  comparison):
  
  In Pixel Starships and FTL, the placement of rooms on a ship matters — adjacency bonuses, power routing, crew positions. Right now Planet Hunters rockets have a fixed load-out with no spatial element. When room upgrades unlock at L5, do we want rooms to feel like slots you fill (simple, mobile-friendly), or should there be some spatial logic where where a room sits on the ship affects something — e.g. a Mining Bay adjacent to a Cargo Bay gives a cargo bonus? How opinionated do we want the room builder to be?

I think that it would be nice to have slots that users can fill with rooms, and then be able to further customise rooms, in the long-term.
Users can just use pre-built rocket templates, but after the tutorial they'll at least have to choose the orientation whenever they upgrade a rocket that isn't from the StarterRocket family (which are all prebuilt, "unibody - mining laser, drones, storage & engine/reactor is all they have). E.g. when users upgrade, they'll have to select where they want to put a new room (if they get a new room available when they upgrade...e.g. maybe they can have two mining lasers at L4 of a new ship).
I would like there to be as much customisation available for the user but to keep it simple, and we'll also say that in the early game (say until ~L8, or whenever you identify would be a better point), it's relatively simple. 
Longer-term, I'd like to have customisation of rooms and components as well - ideally it's as granular as Minecraft. Literally everything can be built, rebuilt, customised, etc. But we need to identify a roadmap for these sorts of things as well.



  Q2 — How many rockets is "too many to think about" at once? Tiny Space Program lets you gradually queue more and more rockets, and the complexity snowballs. Planet Hunters says multiple rockets can be active simultaneously, each needing an active mining session. What's the intended max number of rockets a mid-game player should be managing in parallel — is 2 the sweet spot, or do we want players eventually running 4-5 like a small fleet? And does managing multiple change the feel of any given mining session (more pressure, more reward)?

We'll say that they can take one mission at a time, they can cancel a mission but that also auto-scraps the rocket.
At L8 they can have two missions.
If they're launching rockets without a specific mission (from a contractor) attached, they're just limited to the size of their ports, capacity of the launchpad, etc.
We could maybe have things like licenses e.g. users can't have too many satellites or rockets in orbit around Earth depending on their permit.

  ---
## Economy & Market
  Q3 — When does price timing become interesting, and what do you do until
  L5?   Offworld Trading Company's core tension is watching prices move and timing your sales. Planet Hunters gates the Marketplace until L5. Before L5, players sell minerals without seeing the market price — they're essentially flying blind. Is that intentional friction, or do we want some "price preview" mechanic at earlier levels (e.g. a contractor quote, or a rumor system like Stardew's shipping bin)? What's the mental model a L2-L4 player should have about why they're getting the payout they got?

Well for the first 4 missions the user does, the payout is purely based on what a contractor is willing to pay for the minerals they're asking for - there should be a constant, pre-defined value for this for the early game, and for the types of minerals being requested (we also need to make the quantities realistic based on current real world behaviour). 
Whenever a user does a mission for a contractor, they WILL get an idea of how much the contractor is going to give them as a reward - this is always a given. Sometimes there may be a speed bonus or whatever.
Otherwise, they will be flying blind until they unlock the market stats.

  Q4 — Construction discount as a secondary mineral sink: is it compelling enough? The 15% discount for using your own minerals toward construction is elegant but quiet. In Crashlands, crafting things yourself feels like a meaningful act because you're physically placing items in the world. In Planet Hunters, that connection between "I mined this silicon" and "now it's part of my relay station" could feel great or could feel invisible. How explicit/celebrated should this pipeline be — is it just a financial incentive, or is there  narrative/visual moment where the player sees their minerals become infrastructure?

Well it's so that users have the option to not have to go full into crafting and placing down blocks. Remember, I also don't know when we'll get to a full-on sandbox approach, with voxels and blocks and everything. The construction/mining mechanics will still be relatively simple in the early game and the early versions of the game in general. 

The priority has to be getting things able to be placed and interacted with. The *how* doesn't matter in the early versions of the game, which is one of the reasons why they can just sell the minerals and get a structure (essentially a conversion) without having to refine, craft, etc.

The cheapest way to get something is to do all the refining and crafting yourself.


  Q5 — Contractor pay at 20% premium vs. open market at 80%: is the delta    legible? In Offworld Trading Company, the reason to fill a specific resource order  vs. sell to the market is immediately legible — you see competing prices.  In Planet Hunters, a player post-M4 needs to understand that contractors pay 120% of market while open market pays 80% — a 50% swing. If a player  doesn't know this, they might ignore contractors entirely after the tutorial. How do we surface this comparison in the UI so the player always knows they're making a deliberate trade-off when they choose to free-sell vs. fulfil a contract?

I'm open to how we explain this to the user - free reign there.
It would be good if users could understand what contractors are working on - remember, each contractor has a different specialty.

  ---
## Contractor System
  Q6 — What does "30-minute contractor cooldown" feel like in a 10-20 min session game? In Stardew Valley, when an NPC is done with you for the day, you move on naturally. In Planet Hunters, a 30-min cooldown on a contractor after 2 consecutive missions could wall a player mid-session. If a player has only 3 contractors at L1 and burns through 2 of them back-to-back (possible in a focused session), they could hit a dead end with nowhere to go. Should the cooldown be framed as "the contractor needs time to process your delivery" with a countdown visible? Or do we let the player always have at least 1 cooldown-free contractor at any level?

I'm open there - maybe adding a calendar/day/date system would be cool. As long as the explanations don't clog up the UI, I'm a happy camper.

  Q7 — Reputation as a gate vs. a multiplier: which pattern do we want? In No Man's Sky, faction reputation gates what you can buy. In Stardew Valley, NPC relationships unlock new dialogue, items, and cutscenes. Currently, Planet Hunters affinity is purely additive (higher affinity = more payout, more missions). Should affinity ever gate something — e.g. a high-affinity contractor unlocks a unique mission type that the player can't get anywhere else? Or do we keep it as a pure multiplier so there's no FOMO pressure?

I think adding special missions and rewards in the future for very high bonuses would be good.
Also, side note - right now this game is just called "Experiment 1", not "Planet Hunters". Do a complete fix for this in the codebase/documentation.

  Q8 — How do contractors communicate their project narrative to make       
  missions feel purposeful? In Crashlands, every quest-giver has a personality and the tasks flow from a story. Planet Hunters' contractors are currently functional (deliver X  of mineral Y), but the design doc mentions they have distinct visual themes and projects. How much narrative scaffolding should a contractor have — do we want to know what they're building and see it progress over missions? E.g. Contractor Zhong is assembling a deep-space relay and every mission delivery adds a visible component to a build log?

Let's create a big template of different projects, missions, stations, narratives etc and then break them up into reusable components (to keep the codebase small), then the user starts to learn more about each contractor and what their goals & aims are. Locations should be included in these templates, but we have to keep in mind that every day there could be new locations added - so we can't have hardcoded values in the templates for the location variable.

  ---
## Mining Minigame & Target System
  Q9 — The "depleted but not empty" laser-level system: does the player  intuitively understand it? In Astroneer, you can always dig deeper and find new materials. In Planet Hunters, a target marked "depleted" can be revisited with a higher laser   level. But a player who doesn't know this might treat it as a dead target and never return. How do we signal that depleted targets have future value — is there a visual indicator ("3 material tiers locked behind L3 laser"), and is the first time a player successfully re-mines a depleted target a moment we design around?

No idea - visual indicator when the quantity of a mineral is exhausted for that rocket would be good.


  Q10 — Minigame repetition vs. variety: how many runs before it feels      
  samey? Dredge's fishing minigame is the design inspiration, and Dredge solves repetition through when you fish (night adds anxiety) and what you catch   (variety). Planet Hunters' sidescroll mining currently scales with target level but is mechanically similar each run. By what session count do you   expect a player to want more mechanical variety — and what's the lever? Is it: different zone shapes per mineral type (silicon vs. iron have different stable zone patterns), or special events (jackpot zones), or something else like a second mode entirely for planets vs. asteroids?

Different zone shapes, maybe different ranges for the lasers, adding some puzzle features, maybe solar flares or other events disrupt something...I'm open to suggestions.

  Q11 — Should planets feel fundamentally different to mine than asteroids, 
  and if so, how? Take on Mars differentiates surface operations (rovers, drilling) from     orbital activities. Planet Hunters has planets at 120–340 AU with 5–20×    the capacity of asteroids — they're implied to be bigger and longer missions. But is the mining minigame experience different? In games like  Deep Rock Galactic, terrain type changes how you approach extraction
  completely. Should mining a planet be a distinct ritual (longer, different zone pattern, more minerals but harder to extract), not just a longer asteroid?

Yeah, I think different quantities and types of minerals would be good.

## Tutorial & Onboarding

  Q12 — At what moment in the tutorial should the player first feel the
  contractor relationship, not just be told about it?
  In Crashlands, every mechanic is introduced through a quest that makes you
   need it right now — you don't learn crafting abstractly, you need a
  specific item to proceed. Planet Hunters M1-M3 are scripted. M4 introduces
   free ops. But when does the player first need to choose between
  contractors — when does that choice feel real? If post-M4 there's always
  an obvious best contractor, the system is invisible. What's the first
  moment of genuine contractor tension you want a player to face?

From the start - that's when the contractors become available, even though the rest of the tutorial is scripted.

  Q13 — How do you introduce the room upgrade system (L5) without it feeling
   like a sudden wall?
  FTL shows you locked upgrade slots from the very first ship — you see
  what's possible before it's available. Planet Hunters plans to show locked
   rocket slots in the hangar. But room upgrades at L5 are a big unlock.
  Should earlier levels have "preview" states — e.g. the room management
  screen exists from L1 but rooms are greyed out with "Upgrade at L5" labels
   and costs visible? Or is it better to surface the room upgrade screen for
   the first time at L5 as a reward reveal?

See earlier answers for a more in-depth answer to this, but I think it would be a big reward and improvement.

  Q14 — What should Mission 4 teach specifically, and does it need to be
  semi-scripted?
  M1-M3 are fully scripted tutorials. M4 is the first "free ops" mission.
  But free ops could be overwhelming — suddenly the player picks the
  contractor, picks the target, evaluates cargo capacity, checks mission
  requirements, and launches. In games like No Man's Sky, the first "free"
  moment after the tutorial actually still has a soft hand (the game
  suggests your next destination). Should M4 have a "suggested path" — e.g.
  the first contractor offers a very easy mission to a close asteroid with a
   visible reward comparison, effectively teaching the evaluation flow in a
  low-stakes way?

M3/M4 teach the scanning & annotating, but yeah I think making it feel "close" still helps.

  Q15 — When should construction appear in the tutorial/onboarding arc, and
  what should the first build be?
  Crashlands has you building your first base structure within the first 15
  minutes. Take on Mars makes base construction the point from day one. In
  Planet Hunters, construction is mid-game and deferred. But if a player
  never builds anything by L4, the late-game construction system might feel
  like a surprise pivot. Should there be a "build your first relay beacon"
  milestone mission in the M4-L3 range — something small and achievable — to
   plant the seed? What's the simplest possible first construction that
  teaches the pipeline without being a tutorial chapter?

L5 is when structures can start being built, L4 when existing structures on Earth can be upgraded.

  ---
  Progression & Retention

  Q16 — What is the "just one more run" hook after M4, and does it currently
   exist?
  Dredge keeps you going because you always have one more fish to catch
  before dark. Stardew's hook is the persistent calendar — tomorrow the shop
   restocks. Planet Hunters is a minimal sandbox with no win condition.
  Post-M4, what is the pull that brings a player back the next day? Is it: a
   contractor's cooldown ending (notification), a discovered target you
  haven't visited yet, a mineral price window you want to catch? Which of
  these is strong enough to be the primary retention hook, and which should
  we build first?

I think more things to build, new anomalies each day (there could maybe be a limit there), and the prospect of other players visiting your bases or giving feedback/continuations to your discoveries. 

  Q17 — Is there a "star map moment" — a screen where the player can see
  everything they own and have discovered?
  In Astroneer, the planet map showing your bases and discovered terrain is
  deeply satisfying. In No Man's Sky, your discoveries log becomes a
  personal history. Planet Hunters has a star map planned but currently
  deferred. At what point in the progression (level or mission count) should
   a player first see a proper star map of their discovered targets, visited
   asteroids, placed relay stations? This is about identity — when does the
  player start thinking "this is MY sector" rather than "these are
  missions"?

The starmap should be visible from after the first mission in the tutorial. 

  Q18 — How do scanner range and relay stations create a sense of geographic
   expansion?
  Tiny Space Program's progression is literally getting further from Earth
  over time — each rocket tier extends your reach, and that expanding
  frontier is the main progression metaphor. Planet Hunters has scanner
  range increase at L8 and relay stations extending range further. What
  should the emotional experience of first extending your scanner range be —
   is it a quiet unlock, or is it a moment with a visual reveal (the scan
  radius on the star map visibly grows)? And how many relay stations does a
  player need before deep-space mining feels like an expedition vs. a chore?

No idea - free reign here.

  ---
## Economy & Construction Depth

  Q19 — Should refineries be an early-accessible teaser or a late-game power
   move?
  In Take on Mars, refineries are part of the base-building toolkit from
  relatively early. In Planet Hunters, refineries can be built "anywhere"
  per the spec. Currently the raw → refined pipeline is undefined in terms
  of timing. Given that raw minerals sell at 80% and refined presumably much
   more — if a player could build a simple refinery on Earth very early (say
   L3), does that break the economy by skipping the contractor incentive? Or
   does the mineral effort required to build a refinery naturally pace it
  into the mid-game regardless?

Let's say L6 for the refineries, L7 for off-world. With increasing capacities and performance at each level increase.

  Q20 — What's the right granularity for mineral types — are 10 types
  enough, and when does the player need to care about which mineral
  specifically?
  Offworld Trading Company has ~12 resource types with very specific
  strategic roles. Crashlands has dozens of materials but most early ones
  are replaceable. Planet Hunters' economy doc references silicates, iron,
  etc. but the depth of the mineral taxonomy isn't fully defined. When does
  a player first need to care about which specific mineral they're hauling —
   is it at the first contractor mission (they ask for X), or earlier
  (mission 2 already specifies a mineral)? And what's the minimum number of
  meaningfully distinct minerals needed before the contractor system feels
  like it has strategic depth rather than just "fetch quest"?

I think in the early game we'll keep it simple, I want to have a full "periodic table" type dictionary down the line (3 sprints from now - reminder).