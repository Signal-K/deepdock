---
type: plan
project: Star-Sailors
status: active
tags: [star-sailors, ecosystem, architecture, strategy]
created: 2026-03-19
extracted-from: Operations/Daily/Archive/2025-12/2025-12-14.md
---

# Ecosystem Architecture

Consolidated from the extensive Dec 14 daily note — the most detailed architecture session to date.

## Game Structure

| Project | Platform | Role |
|---------|----------|------|
| Star-Sailors Web | Next.js | Hub / classification engine |
| Bumble | React Native + Godot | Farming / bee minigame |
| Click-A-Coral | Godot-RN | Coral classification minigame |
| Experiment1 | Godot multiplayer | Planet Hunters co-op |
| Godot-Mars (archived) | Godot | Terrain generation prototype |

## Website Structure (scroobl.es)

- **Star Sailors ecosystem projects** — citizen science games
- **Decentralized tech projects** — separate product line
- Sub-pages: individual game landing pages, blog/Substack integration

## App Distribution Strategy

Decision from Dec 14:
- **Option A**: Multiple games in one app (Expo shell, deeplinks between games)
- **Option B**: Separate apps with deeplinks
- Current lean: single Expo app with Godot embedded via Godot-RN template

## Godot-RN Template Components

The shared template between all Godot games:
1. Supabase integration (auth, DB write-back)
2. Login / user state
3. Godot embedded in RN view
4. Write-back from game → Supabase
5. View discoveries (classifications contributed)

## Next Mechanics Backlog

- **Construction** (Crashlandings / SV-clone direction)
- **Fishing** (potential Bumble add-on or standalone)
- **AreWeAlone** — standalone citizen science game
- **Roving Rover** — resource collection, refinement, satellite dust/spider/cloud harvesting

## Terrain Generation Idea

- Generate terrain via **pixel art templates** derived from real classification data
- Player classifications → drive what the world looks like
- Links citizen science contribution directly to gameplay environment

## Segment Structure (circa Dec 14)

| Project | Segments |
|---------|----------|
| Star-Sailors | V2 (archived), Product-Hunt-Launch, V2-Patch |
| Bumble | Demo, Release |
| Godot-Mars | Setup, Integration, Missions |

## Related

- [[Godot-RN-Template-Architecture]] (Experiment1/Plans)
- [[Product-Hunt-Launch-Prep]] (Star-Sailors/Plans)
- [[Analytics-Strategy]] (Star-Sailors/Plans)
