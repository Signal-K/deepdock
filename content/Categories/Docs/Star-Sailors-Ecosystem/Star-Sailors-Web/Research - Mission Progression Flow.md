---
sticker: lucide//thermometer-snowflake
tags:
  - Research
icon: lucide//file-text
---

# User Stories
From #SSG-281 [[SSG-281]]
> _As a player, I want to see my discoveries progress from detection to detailed study so I understand the value of my work._
- **Tasks**
    - Map out project-specific “next steps” (Planet Hunters, DMP, Cloudspotting, Jovian Vortex) in Obsidian
        - Example: **Planet Hunters** → Deploy telescope → Classify → Study radius/mass → Atmosphere scan (satellite)
        - Example: **DMP** → Detect asteroid → Identify active features → Archive entry
    - Add placeholder “Next Step” indicators in classification view
    - Prepare UI slots for future “post-classification tasks”


Context -
1. Skills component that shows progress for each mission and mission category/group


# Mission Groups
For now, I think we can group missions by the #Viewport they're part of. So:

Telescope viewport:
1. #PLanetHunters 
2. #DailyMinorPlanet

Satellite viewport:
1. #CloudspottingOnMars
2. #CloudspottingOnMarsShapes - coming soon
3. #JovianVortexHunter - coming soon

Rover viewport:
1. #AI4Mars - in-progress
2. #PlanetFour - coming soon
3. #APPEEARS - ??
4. others...

Solar health viewport:
1. #Sunspots 

Ticket: #SSF-2  

So, a simple research tree would show the number of classifications they've made across each viewport, divided by the name of the mission. That's a good first step.

Then, we need to define the mission steps that follow the classification (e.g. #Consensus , #Commenting, #Surveyor ). That's something I think I'm going to leave to the [[30 August 2025]] meeting to discuss and properly plan out. This means the "Next Step" button in the above user story will have to be postponed.

In short, let's just say that we show the overall progress the user has made, and set it up so that the sections can be easily malleable - if we decided a different mission/organisation convention in the future.


> Example: **Planet Hunters** → Deploy telescope → Classify → Study radius/mass → Atmosphere scan (satellite)
This does bring up a point around scanning/structure animations when anomaly unlocking occurs, as well as the best order of mission steps. E.g. if #CloudspottingOnMars occurs after a planet is discovered in #PLanetHunters , maybe we should highlight this?
At a minimum, showing the mission completions in the above research section would probably be a good idea.


## Displaying "unlockables"
Some projects, like #ActiveAsteroids , are a very clear follow-up.
Some projects will unlock things like extra satellites, more deployments, etc.
Something to discuss on [[30 August 2025]]


# All missions/data should be able to be "inspected" i.e. follow-up. Sandbox mode. 
## Stardust Usage and Progression Systems

All missions should have a reward with Stardust. Stardust is the core currency awarded for classification and inspection actions. It will eventually be required to unlock or fund research tasks — for example, unlocking spectroscopy data, upgrading satellites, or expanding automaton abilities.

There may be a second resource (e.g. "minerals") required to *build* the resulting tech after research is completed, creating a layered resource economy.

Post-classification scenes should visually reinforce Stardust gains. These should be accompanied by animations, popups, or feedback components.

We also intend to reward Stardust for community actions like voting and consensus validation.

[[Extra data - sandbox]]


# Planetary classification with real data
[[SSG-287]]
Planet types (Terrestrial, Gaseous, Ice) are now classified using real astronomical data from the parent star — including temperature and radius, pulled from TIC or KOI sources. These values are handled via both a Python data ingestion script and a TypeScript frontend classification flow.

The formula matches scientific approximations and enhances the believability of the player's discovery.

Research entries may later allow players to unlock new classification capabilities (e.g. habitability, atmosphere).

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Docs/index|Docs Index]]
- [[content/Categories/Docs/Star-Sailors-Ecosystem/Star-Sailors-Web/index.md|Docs - Star-Sailors-Ecosystem/Star-Sailors-Web Index]]
