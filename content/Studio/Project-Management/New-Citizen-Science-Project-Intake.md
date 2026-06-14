---
type: intake-system
status: active
created: 2026-04-20
tags:
  - citizen-science
  - project-intake
  - pocketbase
  - agents
  - obsidian
---

# New Citizen Science Project Intake

Purpose: make it easy to create a new Star Sailors game/project without forcing an agent to rediscover the whole ecosystem.

## Intake Workflow

1. Create a new note from `content/Studio/System/Templates/New-Citizen-Science-Project.md`.
2. Attach sketches, screenshots, source-data examples, or links directly in the note.
3. Fill the MVP slice before writing implementation tickets.
4. Decide where the project lives:
   - Star Sailors Web Client integration.
   - Standalone daily game.
   - Standalone Godot/PWA experiment.
   - Native/mobile shell.
   - Reference-only/backlog.
5. Generate no more than five first-week Knowns tasks:
   - Project definition.
   - Data/source ingestion.
   - Playable loop.
   - Distribution/test path.
   - Agent handoff/verification.

## Required Fields

- Project name.
- Citizen-science source.
- Scientific action the player performs.
- Game fantasy.
- First player session.
- Data input.
- Data output.
- MVP loop.
- Distribution target.
- Testing plan.
- What is explicitly not MVP.

## Go + PocketBase Shape

If this becomes a remote system, the intake note maps to these PocketBase collections:

| Collection | Purpose |
| --- | --- |
| `projects` | One row per game/project/version |
| `project_versions` | MVP, v0.1, v0.2, archive/reference |
| `science_sources` | APIs, datasets, Zooniverse projects, partner data |
| `mvp_scopes` | Must ship, defer, assumptions, risks |
| `tasks` | Knowns-compatible task records |
| `agent_sessions` | Session packets and handoff logs |
| `assets` | Sketches, screenshots, diagrams, prompt outputs |
| `test_cohorts` | External tester batches and feedback links |
| `builds` | URLs, commit refs, validation results |

Agent tokens should be scoped so agents can create tasks, sessions, notes, and build records, but not delete projects or secrets.

## Things Integration

Things should not be the source of truth. Use it as the personal daily execution list:

- Morning: mirror 3-5 personal tasks from Knowns/Plane/Vikunja into Things.
- During the day: check off Things items.
- End of day: update the shared work ledger and Obsidian with actual status and notes.

This avoids Things becoming another backlog.

## Sketch Uploads

Sketches should land in the vault first, then be referenced from project intake and agent packets.

Recommended location:
- `media/project-intake/<project-slug>/`

Recommended note field:
- `Sketches:`
  - `![[media/project-intake/project-slug/sketch-001.jpg]]`
  - Short caption.
  - What decision the sketch resolves.
