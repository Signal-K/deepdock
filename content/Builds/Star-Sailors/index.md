---
name: Star Sailors
type: project-index
status: active
tags: [star-sailors, web, react, citizen-science]
---

# Star Sailors

> Citizen science space game — players classify real astronomical data through engaging missions.

## Quick Links
| Area | Link |
|------|------|
| Mechanics | [[Mechanics/Star-Sailors/]] |
| Components | [[Components/Star-Sailors/]] |
| Ideas | [[Ideas/Star-Sailors/]] |
| Builds | [[Builds/Star-Sailors/]] |
| Design | [[Design/Star-Sailors/]] |
| Journal | [[Journal/Star-Sailors/]] |
| Meetings | [[Meetings/Star-Sailors/]] |
| Physical | [[Physical/Star-Sailors/]] |

## Active Work
```dataview
TABLE status, priority
FROM "Builds/Star-Sailors/Tasks"
WHERE status != "done" AND status != "archived"
SORT priority DESC
```

## Recent Mechanics
```dataview
TABLE status, created
FROM "Mechanics/Star-Sailors"
SORT created DESC
LIMIT 5
```

## Active Plans
```dataview
LIST
FROM "Builds/Star-Sailors/Plans"
WHERE status = "active"
```

## Roadmap
```dataview
TABLE phase, target, status
FROM "Builds/Star-Sailors/Roadmaps"
SORT target ASC
```
