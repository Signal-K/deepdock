---
title: Physical Notes - December 11, 2025
date: 2025-12-11
tags:
  - physical-notes
  - godot-mars
  - terrain
  - biomes
  - mechanics
  - design-decision
  - weather
  - craters
projects:
  - Godot-Mars
icon: lucide//workflow
---

# December 11, 2025 - Godot Mars Terrain & Biomes

**Project Documentation Created:**
- [[../_Tasks/Projects/Godot-Mars/Terrain-Regions|Terrain Regions]]
- [[../_Tasks/Projects/Godot-Mars/Biome-System|Biome System]]
- [[../_Tasks/Projects/Godot-Mars/Weather-System|Weather System]]
- [[../_Tasks/Projects/Godot-Mars/Crater-Mechanics|Crater Mechanics]]
- [[../_Tasks/Projects/Godot-Mars/Spider-Mechanic|Spider Mechanic]]

**Tasks:** [[../_Tasks/Projects/Godot-Mars/Terrain-System|Terrain System Implementation]]

![[2025-12-11-01.png]]

## Page 1 - Terrain Types, Biomes & Layers

**Date noted:** 11.12.25

### Terrain Regions
Current build first pass referring to logs list:
- Craters
- Hills
- Ground level
This is similar related to Terrain

### Biome/Layer System
The major biomes/layers will consist of soil/regolith, crust, mantle.

**Different regions have different materials:**
- Highland centers: Southern hemisphere, surface + exposed bedrock
- → Boulders, fragmented rocks
- → Ancient lake beds, segments at the bottom of highland craters
- → Clays and in bedrock at the rim
- → Sulfates, carbonates

**Northern lowland centers:** Northern hemisphere, younger, smoother flatter material → Dirt & sand plains → more soil

**Polar ice caps:** (at the poles) → soil, thick layers of ice + dust mixed together, joins games for materials

**Canyons:** → Exposed cliff faces, ore & raw minerals can be found

**Plains/Lowlands:** → Soil + fine dust cover → Undergrowth water ice at the subsurface (just for spawning) user does care [for] large scale snowfalls collector

**CO2 clouds form primarily in the higher latitude areas & canyons, where the players will be spawning**

Spiders from grosmith on the Southern hemisphere

![[2025-12-11-02.png]]

## Page 2 - Crater Terrain Sketches & Mechanics

**Date noted:** 11.12.25, Continued →

### Sketches
Two terrain view sketches showing:
1. **Crater terrain** - ice at bottom, crater form view with boulders, elevated rim (labels: "Crater," "Ice at bottom")
2. **Plains/flat terrain** - surface to default plains with track/path, zoomed-out isometric view

### Mechanics Notes
→ Surface & default plains
→ Craters, spiders, etc will have dedicated + terrain + form configurations for each arena

(Cont over)

**Different biomes will have different weather, uvs, etc**

## Routed Notes
- [[content/Categories/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Godot-Mars-Archive/Captured-Notes/11 December 2025.md|Routed: Godot-Mars-Archive Docs Capture]]
