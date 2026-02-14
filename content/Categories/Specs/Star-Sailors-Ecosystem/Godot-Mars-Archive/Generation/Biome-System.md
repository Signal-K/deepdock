---
title: Godot Mars - Biome & Layer System
tags:
  - godot-mars
  - biomes
  - terrain
  - design-decision
date: 2025-12-11
source: "[[../../Physical-Notes/11 December 2025]]"
icon: lucide//clipboard-list
---

# Biome & Layer System

> [!info] Design Decision
> The major biomes/layers will consist of soil/regolith, crust, and mantle. Different regions have different material compositions.

## Three-Layer System

### 1. Soil/Regolith Layer
- Surface material
- Varies by region (see [[Terrain-Regions]])
- Interactive layer for gameplay

### 2. Crust Layer
- Bedrock and underlying rock formations
- Exposed in certain areas (highlands, canyon walls)
- Contains mineral deposits

### 3. Mantle Layer
- Deep underground layer
- Not directly accessible in current build
- Future expansion possibility

## Regional Material Variations

Each terrain region has unique material properties:

| Region | Primary Materials | Special Features |
|--------|------------------|------------------|
| Highlands | Bedrock, boulders, clays | Exposed rock, craters |
| Lowlands | Soil, sand, dust | Smooth terrain |
| Polar | Ice, dust, soil | Mixed layers |
| Canyons | Exposed crust, ore | Cliff faces |
| Plains | Dust, soil, subsurface ice | Underground water ice |

## Biome-Specific Properties

### Weather Variations
- Different biomes have different weather patterns
- CO2 cloud formation in specific areas
- UV radiation levels vary by biome

### Visual Differences
- Each biome has distinct visual appearance
- Color palette changes by region
- Atmospheric effects vary

### Gameplay Differences
- Resource availability
- Movement speed/difficulty
- Environmental hazards
- Building constraints

---

**Related:**
- [[Terrain-Regions|Terrain Regions]]
- [[Weather-System|Weather System]]
- [[Crater-Mechanics|Crater Mechanics]]

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Specs/index|Specs Index]]
- [[content/Categories/Specs/Star-Sailors-Ecosystem/Godot-Mars-Archive/Generation/index.md|Specs - Star-Sailors-Ecosystem/Godot-Mars-Archive/Generation Index]]
