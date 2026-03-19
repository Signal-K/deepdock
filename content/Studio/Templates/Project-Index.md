---
name:
type: project-index
status: active
tags: []
---

# {{name}}

> One-line description of the project

## Quick Links
| Area | Link |
|------|------|
| Mechanics | [[Mechanics/{{name}}/]] |
| Components | [[Components/{{name}}/]] |
| Ideas | [[Ideas/{{name}}/]] |
| Builds | [[Builds/{{name}}/]] |
| Design | [[Design/{{name}}/]] |
| Journal | [[Journal/{{name}}/]] |
| Meetings | [[Meetings/{{name}}/]] |
| Physical | [[Physical/{{name}}/]] |

## Active Work
```dataview
TABLE status, priority
FROM "Builds/{{name}}/Tasks"
WHERE status != "done" AND status != "archived"
SORT priority DESC
```

## Recent Mechanics
```dataview
TABLE status, created
FROM "Mechanics/{{name}}"
SORT created DESC
LIMIT 5
```

## Active Plans
```dataview
LIST
FROM "Builds/{{name}}/Plans"
WHERE status = "active"
```

## Roadmap
```dataview
TABLE phase, target, status
FROM "Builds/{{name}}/Roadmaps"
SORT target ASC
```
