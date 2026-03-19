---
name: Bumble
type: project-index
status: active
tags: [bumble, bee, farming, game, godot]
---

# Bumble

> Bee-keeping and farming game — players manage hives, crops, and pollination within the Star Sailors ecosystem.

## Quick Links
| Area | Link |
|------|------|
| Mechanics | [[Mechanics/Bumble/]] |
| Components | [[Components/Bumble/]] |
| Ideas | [[Ideas/Bumble/]] |
| Builds | [[Builds/Bumble/]] |
| Design | [[Design/Bumble/]] |
| Journal | [[Journal/Bumble/]] |
| Meetings | [[Meetings/Bumble/]] |
| Physical | [[Physical/Bumble/]] |

## Active Work
```dataview
TABLE status, priority
FROM "Builds/Bumble/Tasks"
WHERE status != "done" AND status != "archived"
SORT priority DESC
```

## Recent Mechanics
```dataview
TABLE status, created
FROM "Mechanics/Bumble"
SORT created DESC
LIMIT 5
```

## Active Plans
```dataview
LIST
FROM "Builds/Bumble/Plans"
WHERE status = "active"
```

## Roadmap
```dataview
TABLE phase, target, status
FROM "Builds/Bumble/Roadmaps"
SORT target ASC
```
