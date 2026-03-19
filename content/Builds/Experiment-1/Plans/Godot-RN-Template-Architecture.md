---
type: plan
project: Experiment1
status: active
tags: [experiment1, godot, react-native, architecture, template]
created: 2026-03-19
extracted-from: Operations/Daily/Archive/2025-12/2025-12-14.md
---

# Godot-RN Template Architecture

The shared template underpinning Experiment1, Click-A-Coral, and future Godot-based games.

## Template Components

| Component | Purpose |
|-----------|---------|
| Supabase auth | Login, session, user state |
| Supabase client | DB read/write from RN layer |
| Godot-in-RN embed | React Native view that renders Godot scene |
| Write-back bridge | Game events → Supabase records |
| Discovery view | Show user's classifications/contributions |

## Project Setup Notes (from General set up - Godot Experiment 1)

- Docker environment for consistent Godot + Supabase dev
- Supabase: separate environments per build type (dev/staging/prod) — from 2026-01-19 daily
- Godot 4.5 used (migrated from 4.0, confirmed stable Nov 12)

## Multiplayer Architecture (Experiment1-specific)

From "Simple multiplayer concepts.md":
- Players crew a shared ship
- Each player has a role (mission station)
- Classification tasks assigned per role

## Common Mechanics Across All Experiments

Key decision from 2026-01-12 daily:
> "The key thing: common mechanics across all experiments"

- Shared user identity (Supabase UUID)
- Shared progression/XP system
- `day_date` field: ecosystem-wide timestamp convention for daily classification events

## Docker Setup

- Docker prune required periodically (72GB → 7GB, Nov 12 incident)
- Godot RN Docker + Supabase as combined dev environment
- Reference: [[General set up - Godot Experiment 1]]

## Related

- [[Ecosystem-Architecture]] (Star-Sailors/Plans)
- [[Experiment1/Specs/Level-Mission-Spec-v0-from-Handwritten-Notes]]
- [[Experiment1/Ideas/Simple multiplayer concepts]]
