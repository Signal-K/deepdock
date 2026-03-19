---
name: Coral / Click-A-Coral
type: project-index
status: active
tags: [coral, click-a-coral, classification, game]
---

# Coral / Click-A-Coral

> Coral reef classification mini-game — tap to identify coral species in real satellite imagery.

## Quick Links
| Area | Link |
|------|------|
| Mechanics | [[Mechanics/Coral/]] |
| Components | [[Components/Coral/]] |
| Ideas | [[Ideas/Coral/]] |
| Builds | [[Builds/Coral/]] |
| Design | [[Design/Coral/]] |
| Journal | [[Journal/Coral/]] |
| Meetings | [[Meetings/Coral/]] |
| Physical | [[Physical/Coral/]] |

## Active Work
```dataview
TABLE status, priority
FROM "Builds/Coral/Tasks"
WHERE status != "done" AND status != "archived"
SORT priority DESC
```

## Recent Mechanics
```dataview
TABLE status, created
FROM "Mechanics/Coral"
SORT created DESC
LIMIT 5
```

## Active Plans
```dataview
LIST
FROM "Builds/Coral/Plans"
WHERE status = "active"
```

## Roadmap
```dataview
TABLE phase, target, status
FROM "Builds/Coral/Roadmaps"
SORT target ASC
```
