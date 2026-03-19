---
type: spec
project: Bumble
status: in-progress
tags: [bumble, mechanics, hives]
created: 2026-03-19
extracted-from: daily notes Nov–Jan
---

# Hive Management

## Hive Structure

- Each hive contains bees that generate nectar and trigger pollination
- Hive interior should look like a **real hive** — story: "Update hive page to look like inside of real hives"
- Nectar accumulates passively; overflow mechanic needed once capacity is reached

## Nectar Overflow

- Currently no cap behaviour — nectar just accumulates
- Design decision (from 2025-11-23): need a **nectar overflow** mechanic
  - Options: auto-sell excess, decay, or reward bonus for timely harvesting

## Hive Expansion

- Players can expand number of hives, but pollination rate decreases past 2 hives (see [[Pollination-Mechanics]])
- Expansion gated behind story: [[Allow users to expand plots & hives]]

## Water & Food

- Hives require water and food inputs (from 2025-11-15 archive)
- Water: hourly replenish; click to collect or auto-collect via upgrade
- Food: purchase or craft from crops

## Population

- Hive population grows as bees are earned through harvests
- Population = resource pool for pollination events

## Open Questions

- [ ] What is the max hive count?
- [ ] Overflow mechanic — which option (decay / auto-sell / bonus)?
- [ ] Should hive "mood" be a visible stat?

## Related

- [[Pollination-Mechanics]]
- [[Crop-System]]
- [[Update hive page to look like inside of real hives]]
