---
icon: lucide//workflow
---

# Dashboard Flow Proposals (Context-First)

## Goal

Remove daily dashboard redundancy and make capture -> classify -> route -> archive happen with minimal friction.

## Baseline Rules

- Dashboard asks active projects at start of day.
- Dashboard renders only sections for selected projects.
- Every captured task/note/idea is tagged with project + date.
- End-of-day routing moves content from daily note into category-first project folders.
- Daily notes archive automatically based on age and completion state.

## Flow A (Recommended): Single Daily Control Center

### Start of day

1. Run `🔄 Setup Context`.
2. Select active projects for today.
3. Script creates `Operations/Daily/Active/YYYY-MM-DD.md` with only:
- project sections
- project-scoped links
- project-scoped base views

### During day

1. Capture tasks with `➕ Add Task` (priority + project).
2. Add notes/decisions/ideas under each project section.
3. Use global sections only for cross-project context.

### End of day

1. Run `🏷️ AutoTag + Route`.
2. Script:
- auto-tags tasks
- routes tasks -> `Projects/Tasks/...`
- routes notes/decisions -> `Projects/Docs/...`
- routes ideas -> `Projects/Ideas/...`
- appends backlinks under `## Routed Notes`
3. Run `🗄️ Smart Archive`.
4. Script archives to:
- `Operations/Daily/Archive/YYYY-MM/` (default)
- `Operations/Daily/Long-Term/YYYY/` (>=30 days old + no open tasks)

## Flow B: Split Active + Logbook

Use this when active project count exceeds 3.

### Structure

- Keep `Active/YYYY-MM-DD.md` small and action-focused.
- Create parallel `Logbook/YYYY-MM-DD.md` for long-form notes.
- End-of-day organizer routes both files into project categories.

### Tradeoff

- Better focus while working.
- Adds one extra file per day.

## Flow C: Sprint-Driven Dashboard

Use this when delivery cadence is strict (weekly or biweekly).

### Structure

- Daily dashboard includes sprint context block:
- sprint name
- sprint goals
- carry-over blockers
- Base views prioritize:
- open sprint tasks
- overdue items
- decisions made this sprint

### Tradeoff

- Strong execution visibility.
- More template logic and metadata upkeep.

## Workspace Scopes (Aligned to Current Focus)

### Focus now

- Experiment1
- Star Sailors Web (2.1-3.0 + native/mobile)

### Next up

- Bumble
- Click-A-Coral

### Archived/legacy

- Godot-Mars-Archive
- Star Sailors Web 2.0 (pre-December 2025)

## Auto-Tagging and Routing Standards

- Required tags on routed items:
- `#project-tag`
- `#YYYY-MM-DD`
- Optional:
- `#decision`
- `#idea`
- `#blocker`
- Route priority:
1. Explicit project section wins.
2. If missing project section, try project keyword infer.
3. If unresolved, send to `content/Operations/Inbox/Unsorted-Tasks.md`.

## Backlink Requirements

- Every routed note must include:
- source daily note link
- source date
- project index links
- Daily note keeps reverse links under `## Routed Notes`.

## UI/Layout Direction

- Keep action buttons at top.
- Keep project sections in consistent order:
1. Tasks
2. Notes
3. Decisions
4. Ideas
5. Base Links
- Color coding:
- action buttons: green/blue
- project headers: warm accent
- archive/risk sections: amber/red

## Redundancy Reduction Rules

- Remove repeated sections that don’t contain project-specific context.
- Keep only one global section for truly cross-project notes.
- Never duplicate a note in daily + category locations after routing; keep link references only.

## Rollout Plan

1. Keep Flow A as default for 2 weeks.
2. Track friction points:
- uncategorized captures
- missed routing
- duplicate notes
3. If daily note grows too long, switch to Flow B.
4. If sprint visibility is weak, add Flow C sprint block.
