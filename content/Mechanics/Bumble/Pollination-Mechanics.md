---
type: spec
project: Bumble
status: implemented
tags: [bumble, mechanics, pollination, bees]
created: 2026-03-19
extracted-from: daily notes Nov–Jan
---

# Pollination Mechanics

Extracted and consolidated from daily notes spanning 2025-11-09 through 2026-01-16.

## Core Rule

- **1 pollination event per hive per day**
- Pollination rate decreases after a player has 2 hives (diminishing returns to encourage progression, not grinding)
- Bees are triggered from the hive **after a harvest** event, not before

## Timing

- "Who's visiting" (visitor/bee preview) is only shown **pre-harvest** — not after bees have already been triggered
- 10 full harvests = 1 bee (relatively high barrier, intentional)
- Down the line: replace simple count with a weighted "pollination score" factor

## XP & Rewards

- Pollination events grant **XP**
- Successful pollination gives a **2x yield bonus** on the next harvest
- Separate `beexp` currency tracks bee mastery (distinct from general XP)

## Open Questions (from Jan daily notes)

- [ ] What timing feedback do testers actually notice? (timing of crop growth)
- [ ] Is the 10-harvest-per-bee barrier still right after first playtest round?
- [ ] Should pollination score become visible to the player?

## Related

- [[Hive-Management]]
- [[Crop-System]]
- [[Allow users to expand plots & hives]]
- [[Pollination to occur at regular intervals]]
