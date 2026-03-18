---
tags:
  - Specs
  - Questions
  - Client
  - V3
  - Hub
  - dashboard
sticker: lucide//stretch-horizontal
---
 1. Pixel Starships shows your crew physically walking around inside the ship at all times — the hub is always "alive." Should the Star Sailors hub have a living ambient character — e.g. a small astronaut figure idle-animating in the station, visible between actions? Or is the hub purely informational (cards/panels, no character presence)?
Well, your rovers would sort of be non-living characters but they'd still have personalities, and I'd like to think that the structures could have personalities too.
Later on (bridging into the #experiment1 territory, where I'm creating a (for now) minimal experiment about mining - see below for more context) we'll have construction on other planets, with characters (astronauts, maybe aliens in the far-future...once we have a SETI citizen science project integrated into the gameplay) included there.

Context:
Experiments are self-contained, rapidly built game prototypes — standalone
   Godot projects wrapped in a lightweight web shell — designed to test     
  specific gameplay loops, mechanics, and UX ideas with real players before
  committing to full implementation. Planet Hunters Experiment 1 is the     
  first such experiment: a browser-based resource management game where
  players launch missions to real astronomical targets (asteroids and TESS  
  exoplanet candidates), mine minerals, level up their base, and gradually  
  encounter citizen science mechanics like light-curve scanning and target
  classification. In the short term, it operates entirely independently of
  the main Star Sailors native app, serving as a fast-feedback vehicle to
  validate economy balance, mission flow, tutorial pacing, and player
  engagement with the citizen science layer. In the long term, successful
  mechanics and design decisions proven out here — mineral economies,
  contractor systems, rocket progression, discovery consensus — are intended
   to be ported into the main game, and eventually the two share backend
  infrastructure (Supabase) so that player discoveries, classifications, and
   cross-pollination of asteroid/planet data flow across the whole Star
  Sailors ecosystem.

  2. Take on Mars makes you feel inside an enclosed space station — muffled ambient, warm light, claustrophobic in a good way. Should the hub feel like you're inside a station looking out (enclosed, cosy, you're the operator), or like you're looking at the station from space (overview, cold, strategic)?
You're the operator. Later on (three sprints from now), multiple views. It would be good if we could generate images for this down the line.

  3. Crashlands makes its world feel alive through persistent background activity — things move, grow, react even when you're not directly interacting. What  background animation, if any, should the hub have when the user is idle? Examples: slow star-field parallax, a planet rotating in the distance, a satellite passing overhead, radio waves pulsing from a deployed telescope. Or none?                                                                                 
This is more of what I wanted to be discussing...
So - a parallax, with different colours for different objects, labels for your classified anomalies, that would be cool.
Seeing ships - especially satellites and vehicles from other people - passing over, with the option to pause and see what's happening.
If someone's satellite was deployed since you were last online, it should show up...

Later on, we'll see things growing on the surfaces of entities, maybe solar flares & other events. This would then become a pathway to some interaction down the line.

  ---
  The Sector Radar / Map
                        
  5. The Sector Radar is confirmed navigational. Three possible interpretations: (a) a station schematic — bird's-eye floorplan of your station with rooms you can tap, (b) a space radar sweep — concentric rings showing your deployed structures orbiting a planet, (c) a star map — a zone of space where your deployed structures appear as located objects. Which mental model feels right for Star Sailors?
I think a zone of space, we don't have space stations for now (reminder: when we start V4.0...so a few months away at least). There will be possibly hundreds of planets per user so concentric rings for everything in a user's inventory/history wouldn't be good. But being able to zoom in on the map would be good, so that would be like a secondary view when the user is looking at a specific location.

  6. Should deployed structures animate on the map — satellites shown orbiting, the rover shown crawling across terrain, the telescope pointing — or are they static positioned icons?
Everything should experience at least subtle animations, these would later be manually controllable if the user wanted to interact in this way.

  7. When the Sector Radar is empty (no deployments), the spec says don't show it. What replaces it in that space? A "deploy your first structure" CTA? A locked/dim version of the radar? Blank space?
I think there needs to be an easy way to launch into the day's activities when the user logs in - maybe there's entities like stars, or the tools/structures themselves that the user sees and can click on...the earlier in the game the user is, the more we'll need to help them along, sort of like a multiple choice "what do you want to do today"?

There should also be an "add" button so the user can select projects that they want to have a go at that they didn't select during the onboarding.

  ---                                                       
  Status Communication & Urgency                                                                                 
  9. Tiny Space Program uses floating numbers ticking upward for passive resource generation. Stardust in Star Sailors is earned per action (classification), not passively. But should there still be a live "pending stardust" indicator — e.g. showing that you have unread discoveries or uncollected rewards — or  is stardust just a static balance?                
I think pending could be good.

  10. When a deployed structure has pending anomalies (signals awaiting classification), how urgent should the visual treatment be? Options: (a) pulsing border + badge count (urgent), (b) soft ambient glow that breathes slowly (present but not aggressive), (c) a notification-style dot (subtle). How much do you want the game to push the user toward action vs. let them choose their pace?             
I think just an ambient glow is sufficient

  11. Should incoming signals be represented as an animation — e.g. a data wave arriving at the station, a scan line sweeping across the structure card — or is a static "X signals awaiting" badge enough?
Animations! Please! Make it feel more alive
 
  ---                                                       
  Colour & Visual Language
  11. The palette is teal / amber / sky. Should each structure type own one of these colours as its accent — Telescope = teal, Rover = amber, Satellite = sky — so that colour alone communicates which structure something belongs to across the entire UI? Or does everything share the full palette?                 
Yeah, I think splitting it up would be really cool

  12. Crashlands uses bold black outlines around everything to keep it readable on any background. For structure cards and icons, do you want: (a) bold        outlines (more game-y, retro, Pixel Starships energy), (b) glass morphism / blur panels (more sci-fi HUD, premium feel), or (c) flat minimal (clean, modern, less game-y)?                                  
Glass-morphism please

  13. For a structure in Standby (deployed but no active signals) — should it look like it's powered down (greyscale, dim, cold), or still "on" but waiting (full colour, just a different label)? The distinction matters because "powered down" implies the user needs to do something, while "waiting" implies the game is doing something.                                           
Powered down.
  ---
  Typography & Data Display
                           
  14. Numbers on the hub (stardust balance, signal count, discovery count) — when they change, do they animate (count up with a ticker, like an odometer rolling over) or snap instantly? Tiny Space Program and most idle games use counting animations because they feel rewarding. Is that right for the tone of   Star Sailors?
Yes, they should count up

  15. Take on Mars constantly shows environmental data — temperature, radiation, pressure — in a persistent HUD strip. Should Star Sailors have a persistent data strip in the hub (always-visible: stardust, active signals, total discoveries), or is that noise that clutters the minimal design? Where's the line?
I think it should show a basic strip, showing signals vs detected anomalies (`linked_anomalies` table) and any other metrics relating to user actions.
  ---                                                                                                                                                        
  Portrait Mode Layout                                                                                 
  16. On a phone (390×844px), the hub must fit: mission brief + structure cards + sector radar + (possibly) leaderboard — no scroll. Pixel Starships scrolls horizontally for ship management. Should any section of the Star Sailors hub allow horizontal scrolling (e.g. a horizontal strip of structure cards), while keeping vertical fixed? Or must everything be vertically stacked and fit?
As long as vertical stacked, and there isn't an over-abundance of horizontal scrolling, I'm really happy.

  17. Should the bottom nav bar (Telescope / Rover / Satellite / Inventory / Solar) be the only navigation into structure viewports — or should tapping a structure card in the hub also navigate there directly, making the nav bar redundant for that path?
Yes, tapping into the cards would be preferred
  ---                                                       
  Onboarding Visual Experience
  18. The dedicated /onboarding route needs a visual design. Two directions: (a) empty station that builds itself — user sees a bare station schematic that populates as they make choices (pick telescope → telescope appears on the map), which makes their choices feel spatial and consequential. (b) guided overlay on a pre-built environment — user sees the full hub already rendered, with a spotlight and tutorial pointing them through it. Which communicates "you're building something" better?                                                                   
Option a

  19. Take on Mars and similar games use an arrival sequence to establish place — you land on Mars, you get out of the ship, the world loads around you. Should Star Sailors have any kind of intro animation for first-time users (e.g. a brief sequence of the station powering up, signals arriving), or should it skip straight to project selection?                                         
Yeah let's have a brief sequence
  ---                                                                                                                                                        
  Structure-Specific Design

  20. Solar is "join a mission" — it's a shared community structure, not personal. On the Sector Radar map, should Solar appear differently from personal structures — e.g., always present (not requiring deployment), shown as a larger or shared icon with other sailors' avatars around it, or in a different zone of the map? How do you visually communicate "this is a community thing, not yours alone"?
Different glow around the card, but it's still part of the same area I guess.

  21. Crashlands makes zooming into different areas feel continuous — the world is one persistent space. When a user taps into a structure viewport (telescope classification screen), should it feel like zooming into the hub (the viewport is part of the same world), or like leaving the hub and entering a different environment with its own distinct visual identity? Is the hub the "home" you always return to, or just one screen among many?  
I think let's take from CL here.