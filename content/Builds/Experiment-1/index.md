---
name: Experiment 1 / Planet Hunters
type: project-index
status: active
tags: [experiment-1, planet-hunters, godot, multiplayer]
---

# Experiment 1 / Planet Hunters

> Multiplayer Godot game exploring planet-hunting classification mechanics — players crew a ship and complete science missions together.

## Quick Links
| Area | Link |
|------|------|
| Mechanics | [[Mechanics/Experiment-1/]] |
| Components | [[Components/Experiment-1/]] |
| Ideas | [[Ideas/Experiment-1/]] |
| Builds | [[Builds/Experiment-1/]] |
| Design | [[Design/Experiment-1/]] |
| Journal | [[Journal/Experiment-1/]] |
| Meetings | [[Meetings/Experiment-1/]] |
| Physical | [[Physical/Experiment-1/]] |

## Active Work
```dataview
TABLE status, priority
FROM "Builds/Experiment-1/Tasks"
WHERE status != "done" AND status != "archived"
SORT priority DESC
```

## Recent Mechanics
```dataview
TABLE status, created
FROM "Mechanics/Experiment-1"
SORT created DESC
LIMIT 5
```

## Active Plans
```dataview
LIST
FROM "Builds/Experiment-1/Plans"
WHERE status = "active"
```

## Roadmap
```dataview
TABLE phase, target, status
FROM "Builds/Experiment-1/Roadmaps"
SORT target ASC
```
