---
tags:
  - Rooms
  - Upgrades
  - leveling
  - LevelDesign
  - Spaceships
  - Rockets
  - experiment1
  - PlanetHunters-Experiment1
sticker: lucide//flask-conical
---

![[IMG_1830.jpeg]]![[IMG_1831.jpeg]]![[IMG_1832.jpeg]]

---

## Knowns Tickets

| ID | Title |
|----|-------|
| `hj2q5t` | Room levels and rocket upgrade progression |
| `k4p7nc` | Item component and resource storage system |
| `r8mxvw` | Ship transit animation and travel UX |
| `p9x3kw` | Rocket launch atmospheric ascent animation |

---

## Diagram Notes

### Page 119 — IMG_1832 (storyboard frames, bottom-right)

Four storyboard boxes sketch the **launch-to-orbit animation sequence**:

1. **Frame 1 — On launchpad / ground level**: Rocket sitting on pad, landscape fills the view. Sky is light blue. The rocket body is partially obscured by the launch structure. Dark shading on the left of the frame represents the launchpad structure / foreground terrain.

2. **Frame 2 — Low altitude, ascending**: Rocket tilts/rotates into its upright ascent posture. The landscape below starts to recede. The top of the frame begins to darken — deep blue creeping in above.

3. **Frame 3 — Upper atmosphere**: Rocket silhouette is elongated and vertical. The ground is now a faint line at the bottom of the frame. The sky is near-black. Horizon begins to curve faintly.

4. **Frame 4 — Orbit / space**: A circle represents the planet seen from above/at distance. Full dark space surrounds it. The rocket is small against the backdrop, now in orbit orientation.

The frames define the core visual logic: **sky colour, ground scale, and rocket posture all change continuously as altitude increases**. The transition should feel gradual and earned — not a hard cut. The user should feel themselves "leaving" the planet.

---

## Notes by Page

### Page 119 — IMG_1832

**25.02.26 (left column):**
> Orbital → the demo is a rooms mockup — there needs to be "stories of rooms."
> Art can be about finding. Lose more journeys.

**28.02.26 (centre/right — transit UX):**
> P65 → style: Ship Building. This morning it got me thinking about the subject of travel:
> - Shop button accessible during transit
> - Actual transition animations — shaking point, chain-style motion, higher arc (not just points)
> - Actual transition shape keyframes
> - Ship data dashboard visible during transit
> - Rocket begins to rotate as it moves along the route
> - Fully: rocket progresses along a bar, sides of the ship visible
> - "The last transition — arguably fine now"

→ See ticket `r8mxvw`

---

### Page 120 — IMG_1831

**28.02.26 — Components, items, storage:**
> Anyway, flight components of the game (items, consumables) — BUT a lot are consumable/long-term items like Resources. Consider the store/shop:
>
> Items → Consumable → Recharge
>       → Component → Consumable
>
> Components:
> - Mining
> - Storage
> - Armor / Hull / Plating
> - Parachute → (consumable?)
>
> First: consider Backbone / Backpack
>
> Pressing E (only required) → shows STORAGE panel with ratios
>
> At orbit: loader calculates fuel needed to reach target AND return. User cannot top up mid-flight. Fill the "early jar."
>
> Resources: wheel treads, mining disc/low [more later]
> Weapons: Reactor / Pulsar pool, Cannon
>
> Early game: highlighted planets drive resource-gathering loop.
> Tags: fuel supply in/out → staged fuel demand.
>
> New tools: [TBD]

→ See ticket `k4p7nc`

---

### Page 121 — IMG_1830

**28.02.26 — Room levels and upgrades:**
> Room levels are different to P65 because rockets are consumable — each level upgrade counts as a room upgrade.
> e.g. Level 1 → starter shop
>
> Early game: rooms/components are individually upgradeable — used to identify upgrade capacity.
> Later: rooms and parts become more fully upgradeable. Branches → rockets.
>
> Arc annotation (key rule):
> Users must upgrade halls to "fit" higher upgrades.
> This determines the overall level of the rocket.

→ See ticket `hj2q5t`
