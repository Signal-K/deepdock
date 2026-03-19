---
title: Godot Mars - Weather System
tags:
  - godot-mars
  - weather
  - mechanics
  - design-decision
date: 2025-12-11
source: "[[../../Physical-Notes/11 December 2025]]"
icon: lucide//clipboard-list
---

# Weather System

> [!info] Design Decision
> Weather varies by biome and location. Each biome has unique atmospheric conditions and environmental effects.

## CO2 Cloud System

### Formation Areas
**CO2 clouds form primarily in:**
- Higher latitude areas
- Canyons

**Gameplay Impact:**
- These are player spawning areas
- Atmospheric effects in these regions
- Visibility challenges
- Environmental storytelling

## Biome-Specific Weather

### Weather Variations by Biome
Each biome has different weather characteristics:

**Highland Centers:**
- More extreme weather
- Dust storms more common
- Temperature variations

**Northern Lowlands:**
- Calmer weather patterns
- Less atmospheric turbulence
- Different visibility conditions

**Polar Regions:**
- CO2 ice sublimation effects
- Extreme cold
- Unique atmospheric phenomena

**Canyons:**
- CO2 cloud formation
- Wind effects from canyon walls
- Localized weather systems

**Plains:**
- Standard weather patterns
- Dust devils
- Open-area wind effects

## UV Radiation System

**UV levels vary by biome:**
- Different protection requirements
- Visual effects per biome
- Gameplay impact on exposure

## Environmental Effects

- Weather affects visibility
- Different atmospheric colors/tints per biome
- Dynamic weather transitions
- Storm systems

---

**Related:**
- [[Biome-System|Biome System]]
- [[Terrain-Regions|Terrain Regions]]
- [[../../_Tasks/Projects/Godot-Mars/Terrain-System|Implementation Tasks]]

## Navigation
- [[Projects/_Index|Categories Index]]
- [[Projects/Specs/index|Specs Index]]
- [[Projects/Projects/Star-Sailors/Specs/Star-Sailors-Ecosystem/Godot-Mars-Archive/index.md|Specs - Star-Sailors-Ecosystem/Godot-Mars-Archive Index]]
