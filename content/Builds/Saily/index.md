---
name: Saily / The Daily Sail
type: project-index
status: active
tags: [saily, daily-sail, daily-game]
---

# Saily / The Daily Sail

> A daily game with a sailing theme — short, repeatable engagement loop with a new challenge each day.

## Quick Links
| Area | Link |
|------|------|
| Mechanics | [[Mechanics/Saily/]] |
| Components | [[Components/Saily/]] |
| Ideas | [[Ideas/Saily/]] |
| Builds | [[Builds/Saily/]] |
| Design | [[Design/Saily/]] |
| Journal | [[Journal/Saily/]] |
| Meetings | [[Meetings/Saily/]] |
| Physical | [[Physical/Saily/]] |

## Active Work
```dataview
TABLE status, priority
FROM "Builds/Saily/Tasks"
WHERE status != "done" AND status != "archived"
SORT priority DESC
```

## Recent Mechanics
```dataview
TABLE status, created
FROM "Mechanics/Saily"
SORT created DESC
LIMIT 5
```

## Active Plans
```dataview
LIST
FROM "Builds/Saily/Plans"
WHERE status = "active"
```

## Roadmap
```dataview
TABLE phase, target, status
FROM "Builds/Saily/Roadmaps"
SORT target ASC
```
