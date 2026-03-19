---
tags:
  - Questions
  - Client
sticker: lucide//fingerprint
---
 ---                                                                                                                                                        
  Landing Page — Guest Experience                                                                                                                            
1. The spec says the hero emotion is "curiosity — pull users in, don't explain." What's the actual headline strategy — does the H1 name the game, describe the activity, or pose a question?
So remember, the main client - this game - is the entry point, we don't want to highlight (too much) the other games. Different projects in the client will occasionally come up with pointers towards the other experiments/games - these should also trigger a posthog action so we know who's moving to what.

We need to explain how the game works, the point of the game, and what the user does.

  2. The structure preview strip shows 3 cards (Telescope / Rover / Satellite). What order are they in, and does that order imply a recommended entry point for new users?
It's up to what projects the user decides they want to do/play.

  3. Does the "About strip" ("Play games. Do real science.") need to exist at all, or does the hero already carry that message and the strip is redundant?
I think that having the strip is good.

  4. How does a guest user understand what they're signing up for before hitting the CTA? Is there a teaser of actual gameplay visible before auth?
There's no teaser...figure this out on your end

  5. Is there a secondary path for users who want to browse without signing up, or is every action funneled toward Sign Up?
There's nothing to do for people apart from playing the game...so...yeah....


  ---
  Landing Page — Logged-In Experience

  7. The "Your Missions" view replaces the hero for returning users. What does it show if the user has deployed 0 structures — is it still a dashboard, or does it fall back to the hero?
Dashboard

  8. "Resume your mission" — is the resume button one-tap directly into a classification, or does it take you to the game hub?
Dashboard & hub should be the same thing
It should probably take the user to the view showing the entities that are available to be investigated

  9. Do personalised stats ("your discoveries") show on the landing page, or only on /game? What's the distinction between landing and hub for logged-in users?
The landing shouldn't be visible for the players...because the players are playing the game...

  10. Is the logged-in landing page a permanent home, or do users eventually bypass it entirely in favour of going straight to /game?
If they're playing the game, then they shouldn't be able to view the landing page

  ---
  Navigation & Wayfinding

  12. The V3 editorial landing has a minimal nav (wordmark + 2 links). What are those 2 links — is it "Explore / Sign In" for guests, and does it change for logged-in users?\
Maybe an option to see a full guide, the full portfolio of games in the ecosystem, that should be fine.

  13. Does the game hub have any navigation path back to the landing page, or is /apt only for acquisition?
Only for acquisition

  14. The bottom nav in /game has 5 items (Telescope / Rover / Satellite / Inventory / Solar). Is "base" (the control station dashboard) accessible from the nav, or is it only reachable by backing out of a viewport?
I'm open

  15. Is there a global profile/account access point, and where does it live — top right in the header, behind a hamburger, or elsewhere?
Header
  ---
  Information Architecture — Game Hub
  16. The control station currently shows: sector radar, mission brief, station schematic, auxiliary systems, mission log, agency network. What's the intended reading order — what should the user's eye hit first?
No idea - as long as there isn't any vertical scrolling required to fit things in on the main hub/dashboard. 

  17. The mission brief card is the primary action driver. Should it always be visible above the fold on mobile, or can the planet hero / sector radar push it below?
Always needs to be visible

  18. Is the Sector Radar a navigational element (tap to go to that structure) or purely informational?
Navigational - there should be some sort of map interface

  19. What does the game hub look like 6 months in — when a user has all 4 structures deployed and hundreds of classifications? Does the layout need to adapt for power users?
Yes.

  20. Where does the user's progress/level/stardust live in the layout? Is it in the header, on a profile page, or surfaced contextually?
Profile menu (dropdown)

  ---
  Onboarding & First Session

  21. When a brand new user completes sign-up, where do they land — /game, /apt logged-in view, or a dedicated onboarding route?
Dedicated onboarding

  22. The "Deploy Telescope" first CTA boots from the mission brief card. Is there any guided overlay or is it a cold drop into the deploy flow?
It should only be the first if the user chose to do a project that uses the telescope. There should be a guided overlay - search for it and improve it.

  23. How many steps stand between "I just signed up" and "I made my first science contribution"? Is that number tracked as a target?
No.

  24. Does the layout need to show different state for "user with 0 classifications" vs "user with 1–5 classifications" vs "power user" — three distinct UI modes?
Eventually (3 sprints from now - 1 sprint = 2 weeks).


  ---
  Structures & Projects

  26. Each structure hosts multiple projects (Telescope → Planet Hunters, Active Asteroids, etc.). Does the user choose a project before or after deploying the structure — and where does that choice happen in the layout?
Yes - do a search for it....

  27. The structure cards on the landing show "session length indicator" (5 min / 30 min / 90 min). Are these accurate time estimates, and are they a key differentiator in how users choose which structure to deploy?
I have no idea - I never did that.

  28. Should a structure that's "deployed but has no active signals" look visually different from one that's "deployed with pending classifications"? How distinct does that need to be?
Yes - figure this out.

  29. The Solar structure is treated differently (join a mission vs deploy your own). Does it need a different visual treatment in the structure cards?
Yes.

  ---
  Content Hierarchy & Copy

  31. The terminology table in the spec simplifies "Anomalies → Discoveries / Signals". Has a final call been made on which word is used where — e.g., "signals" in HUD contexts and "discoveries" in achievement contexts?
Signals should be for when the structure/tool is finding something
Anomalies are things that need to be investigated

  32. The "Click-A-Coral" teaser is science-adjacent but not astronomy. Does its placement on the landing suggest the game is broader than space, and does that need to be managed in the copy?
If the user wants to do #ClickACoral , they see a fishtank in their hub, clicking on it opens a message explaining that the Coral game is in a different frontend and not integrated into the main game.... `coral.starsailors.space`

  33. Is there a tagline that lives below the wordmark consistently, or is the brand just "Star Sailors" with no sub-line?
Just the game name.

  ---
  Motion & Delight

  35. The spec says "no full-page transitions." Does this also rule out route transitions (e.g., fade between /apt and /game), or just within-page section transitions?
I just don't want to have any visible reloading - if we can utilise NextJS to do faster component loads that would be great. 

  36. The moduleReveal animation (fade up on mount) is the main entrance for cards/sections. Should every section reveal independently (staggered), or reveal together as a group?
Staggered

  37. Are there any sound design plans, or is this purely visual?
yes - three sprints from now (reminder)

  ---
  Social & Community

  38. The Agency Network card shows referral code + invite link. Is referral a core growth mechanic in 3.0, or is it more of a secondary feature tucked away?
Referral & user growth is the primary goal for this version

  39. The activity feed is behind a slide-in sheet on /game. Is there a vision for making community activity (other sailors' discoveries) more prominent in the main layout?
No idea

  40. Is there a leaderboard or crew concept visible anywhere in the 3.0 layout, or is the game primarily solo?
Leaderboard

  ---
  Empty States & Error States
  42. What does the landing page look like when PostHog fails to load — does LandingAnalytics silently fail, and is there any visible degradation?
Well posthog should never fail.

  43. The "Active Sailors" count is the primary social proof. What does it show while loading (Suspense), and what if the count is 0 or very low — is there a minimum display value?
We don't need social proof.

  44. If all 4 structures are on "standby" (never deployed), the sector radar is empty. Is an empty radar a valid first-time state, or should the radar not appear until at least one structure is deployed?
Shouldn't appear.

  ---
  Broader Product

  46. The spec says the web client structures are the "deep version" of standalone experiments. Is there a visible bridge in the UI — e.g., a banner on the standalone experiment saying "play the full version" — or does that connection only exist on the landing page?
The web client is the full version

  47. Is there a version of the game that doesn't require an account at all — a true guest play mode — or is auth always required to make a science contribution?
Guest accounts are not coming back.


## Part 2
 1. Pixel Starships shows your crew physically walking around inside the ship at all times — the hub is always "alive." Should the Star Sailors hub have a living ambient character — e.g. a small astronaut figure idle-animating in the station, visible between actions? Or is the hub purely informational (cards/panels, no character presence)?                                                                                
  2. Take on Mars makes you feel inside an enclosed space station — muffled ambient, warm light, claustrophobic in a good way. Should the hub feel like      
  you're inside a station looking out (enclosed, cosy, you're the operator), or like you're looking at the station from space (overview, cold, strategic)?

  3. Crashlands makes its world feel alive through persistent background activity — things move, grow, react even when you're not directly interacting. What background animation, if any, should the hub have when the user is idle? Examples: slow star-field parallax, a planet rotating in the distance, a satellite passing overhead, radio waves pulsing from a deployed telescope. Or none?                                                                                 
  ---
  The Sector Radar / Map
                        
  4. The Sector Radar is confirmed navigational. Three possible interpretations: (a) a station schematic — bird's-eye floorplan of your station with rooms
  you can tap, (b) a space radar sweep — concentric rings showing your deployed structures orbiting a planet, (c) a star map — a zone of space where your    
  deployed structures appear as located objects. Which mental model feels right for Star Sailors?
                                                                                                                                                             
  5. Should deployed structures animate on the map — satellites shown orbiting, the rover shown crawling across terrain, the telescope pointing — or are they
   static positioned icons?
                                                                                                                                                             
  6. When the Sector Radar is empty (no deployments), the spec says don't show it. What replaces it in that space? A "deploy your first structure" CTA? A    
  locked/dim version of the radar? Blank space?
                                                                                                                                                             
  ---                                                       
  Status Communication & Urgency
                                                                                                                                                             
  7. Tiny Space Program uses floating numbers ticking upward for passive resource generation. Stardust in Star Sailors is earned per action (classification),
   not passively. But should there still be a live "pending stardust" indicator — e.g. showing that you have unread discoveries or uncollected rewards — or  
  is stardust just a static balance?                        
                                                                                                                                                             
  8. When a deployed structure has pending anomalies (signals awaiting classification), how urgent should the visual treatment be? Options: (a) pulsing      
  border + badge count (urgent), (b) soft ambient glow that breathes slowly (present but not aggressive), (c) a notification-style dot (subtle). How much do
  you want the game to push the user toward action vs. let them choose their pace?                                                                           
                                                            
  9. Should incoming signals be represented as an animation — e.g. a data wave arriving at the station, a scan line sweeping across the structure card — or  
  is a static "X signals awaiting" badge enough?
                                                                                                                                                             
  ---                                                       
  Colour & Visual Language
                          
  10. The palette is teal / amber / sky. Should each structure type own one of these colours as its accent — Telescope = teal, Rover = amber, Satellite = sky
   — so that colour alone communicates which structure something belongs to across the entire UI? Or does everything share the full palette?                 
   
  11. Crashlands uses bold black outlines around everything to keep it readable on any background. For structure cards and icons, do you want: (a) bold      
  outlines (more game-y, retro, Pixel Starships energy), (b) glass morphism / blur panels (more sci-fi HUD, premium feel), or (c) flat minimal (clean,
  modern, less game-y)?                                                                                                                                      
                                                            
  12. For a structure in Standby (deployed but no active signals) — should it look like it's powered down (greyscale, dim, cold), or still "on" but waiting  
  (full colour, just a different label)? The distinction matters because "powered down" implies the user needs to do something, while "waiting" implies the
  game is doing something.                                                                                                                                   
                                                            
  ---
  Typography & Data Display
                           
  13. Numbers on the hub (stardust balance, signal count, discovery count) — when they change, do they animate (count up with a ticker, like an odometer
  rolling over) or snap instantly? Tiny Space Program and most idle games use counting animations because they feel rewarding. Is that right for the tone of 
  Star Sailors?
                                                                                                                                                             
  14. Take on Mars constantly shows environmental data — temperature, radiation, pressure — in a persistent HUD strip. Should Star Sailors have a persistent 
  data strip in the hub (always-visible: stardust, active signals, total discoveries), or is that noise that clutters the minimal design? Where's the line?
                                                                                                                                                             
  ---                                                                                                                                                        
  Portrait Mode Layout
                                                                                                                                                             
  15. On a phone (390×844px), the hub must fit: mission brief + structure cards + sector radar + (possibly) leaderboard — no scroll. Pixel Starships scrolls
  horizontally for ship management. Should any section of the Star Sailors hub allow horizontal scrolling (e.g. a horizontal strip of structure cards), while
   keeping vertical fixed? Or must everything be vertically stacked and fit?
                                                                                                                                                             
  16. Should the bottom nav bar (Telescope / Rover / Satellite / Inventory / Solar) be the only navigation into structure viewports — or should tapping a    
  structure card in the hub also navigate there directly, making the nav bar redundant for that path?
                                                                                                                                                             
  ---                                                       
  Onboarding Visual Experience
                                                                                                                                                             
  17. The dedicated /onboarding route needs a visual design. Two directions: (a) empty station that builds itself — user sees a bare station schematic that
  populates as they make choices (pick telescope → telescope appears on the map), which makes their choices feel spatial and consequential. (b) guided       
  overlay on a pre-built environment — user sees the full hub already rendered, with a spotlight and tutorial pointing them through it. Which communicates
  "you're building something" better?                                                                                                                        
                                                            
  18. Take on Mars and similar games use an arrival sequence to establish place — you land on Mars, you get out of the ship, the world loads around you.     
  Should Star Sailors have any kind of intro animation for first-time users (e.g. a brief sequence of the station powering up, signals arriving), or should
  it skip straight to project selection?                                                                                                                     
                                                            
  ---                                                                                                                                                        
  Structure-Specific Design
                                                                                                                                                             
  19. Solar is "join a mission" — it's a shared community structure, not personal. On the Sector Radar map, should Solar appear differently from personal
  structures — e.g., always present (not requiring deployment), shown as a larger or shared icon with other sailors' avatars around it, or in a different    
  zone of the map? How do you visually communicate "this is a community thing, not yours alone"?
                                                                                                                                                             
  20. Crashlands makes zooming into different areas feel continuous — the world is one persistent space. When a user taps into a structure viewport          
  (telescope classification screen), should it feel like zooming into the hub (the viewport is part of the same world), or like leaving the hub and entering
  a different environment with its own distinct visual identity? Is the hub the "home" you always return to, or just one screen among many?           