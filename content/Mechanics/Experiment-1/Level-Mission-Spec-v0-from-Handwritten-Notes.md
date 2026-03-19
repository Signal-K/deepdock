---
title: "PlanetHunters Experiment1 - Level & Mission Spec (v0)"
---

# PlanetHunters Experiment1 - Level & Mission Spec (v0)

Source notes:
- `2026-01-15` handwritten pages (`IMG_1367`, `IMG_1368`, `IMG_1369`)
- `2026-01-19` handwritten pages (`14C66796...`, `E39CCEDE...`, `FE121C9E...`, `ACDDB786...`)

This is a cleaned, implementation-ready draft based on the handwritten planning notes.

## Core design constraints
- Tutorial-first onboarding before open play.
- Mobile-first UX; web is the first validation target before full mobile rollout.
- Shared gameplay core across platforms, with UI/control adaptation by platform.
- Keep early biome/content variety intentionally small; prioritize playable flow.
- Use fallback generation when ideal landing/target placement is unavailable.
- Use `Exposure Points` as the main progression currency.

## Level 1 - Guided Launch (Tutorial Layer)

### Goal
Teach the base loop end-to-end with strong guidance and minimal failure states.

### Player experience
- Player enters a structured tutorial route.
- UI explicitly introduces key structures/layers before free interaction.
- Player performs one complete mission cycle with prompts.

### Mission structure
1. Briefing: explain objective and target.
2. Setup: choose basic tools/ship loadout (limited options).
3. Execution: guided interaction sequence (movement/trajectory/target action).
4. Return/debrief: reward and recap.

### Constraints
- Single route only.
- Fixed/simple terrain profile.
- Minimal branching.
- Guaranteed valid target/landing.

### Rewards
- Award `Exposure Points`.
- Unlock Level 2.

## Level 2 - Structured Exploration

### Goal
Move from strict tutorial to semi-open mission play with clearer player agency.

### Player experience
- User can explore a small set of layout/structure variants.
- Guidance is reduced but still present via hints and checklist objectives.
- Introduce drag-and-drop style interactions where relevant.

### Mission structure
1. Select from limited mission variants.
2. Navigate/position using taught controls.
3. Complete objective in one of multiple valid approaches.
4. Debrief with performance and progression feedback.

### Constraints
- Limited mode set (notes suggest initial multi-mode step here).
- Low biome diversity.
- Fallback terrain/placement generation if target placement fails.

### Rewards
- Higher `Exposure Points` payout than Level 1.
- Unlock Level 3 systems and higher-yield content.

## Level 3 - Open Operations

### Goal
Enable open-ended mission runs with progression optimization and repeatability.

### Player experience
- Player chooses mission mode/route with fewer hard constraints.
- System surfaces richer data/graph context in UI.
- Player optimizes runs for better exposure yield.

### Mission structure
1. Choose route/mode and target profile.
2. Execute mission with optional advanced interactions.
3. Handle dynamic outcomes (including fallback generation cases).
4. Debrief with expanded stat breakdown.

### Constraints
- Keep content breadth controlled at first; depth over breadth.
- Preserve platform parity in core outcomes.

### Rewards
- Exposure-based unlock chain for higher-yield gameplay outcomes.
- Access to advanced tools/parts/systems (as content is implemented).

## Cross-level system rules
- No dead-end mission starts: always provide a playable fallback scenario.
- Tutorials should be mobile-compatible from day one.
- Web implementation is the first proving ground for mechanics and UI assumptions.
- Mission feedback must clearly show:
  - objective completion
  - exposure gained
  - next unlock progress

## Implementation staging (pragmatic order)
1. Implement Level 1 fully, including debrief + exposure award.
2. Add Level 2 variant selection and drag-and-drop interactions.
3. Add fallback generation path for invalid landing/target conditions.
4. Expand to Level 3 mode/route selection and advanced debrief stats.
5. Validate on web, then adapt/ship mobile UX.

## Open questions from source notes
- Exact definition of the initial "mode" split in Level 2/3.
- Final drag-and-drop interaction scope (which screens/actions).
- Exact formula for Exposure Points and unlock thresholds.
- Minimum viable set of graph/data overlays for first release.
