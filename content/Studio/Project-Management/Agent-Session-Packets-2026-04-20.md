---
type: agent-session-packets
status: active
created: 2026-04-20
tags:
  - agents
  - codex
  - claude
  - gemini
  - star-sailors
  - mvp
---

# Agent Session Packets - 2026-04-20

Use these as copy-paste starting packets for Codex, Claude, or Gemini. Keep sessions bounded. One packet should usually be one agent session.

## Star Sailors Web Client - MVP Route Map

```md
Project: Star Sailors Web Client
Task: ssw001 - Define and lock Star Sailors 3.0 MVP route map
Repo: /Users/scroobz/Navigation/client
Source docs:
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md
- /Users/scroobz/Navigation/quartz/content/Mechanics/Star-Sailors/Early Q&A - Client Redesign.md
- /Users/scroobz/Navigation/client/.knowns/reports/ecosystem-v0-release-readiness-2026-03-06.md
Goal: Produce the locked first-session route from landing page to first science contribution.
Scope: Audit routes/screens, identify blockers, write route map/tester script.
Out of scope: Full redesign implementation, broad refactors, non-MVP project integrations.
Files likely involved: app routes, .knowns/docs or reports, existing landing/game docs.
Verification: Document exists and names exact screens/actions/blockers.
Handoff: Update task ssw001 notes and link the output doc.
```

## Saily - Current v0 Readiness

```md
Project: Saily / The Daily Sail
Task: sly001 - Refresh Saily v0 readiness on current code
Repo: /Users/scroobz/Navigation/saily
Source docs:
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md
- /Users/scroobz/Navigation/saily/.knowns/docs/runbooks/saily-v0-launch-and-rollback-checklist.md
- /Users/scroobz/Navigation/saily/.knowns/docs/specs/saily-product-spec.md
Goal: Confirm whether current Saily can be handed to a first tester this week.
Scope: Run readiness checks, update blocker list, refresh launch/rollback/tester dates.
Out of scope: New puzzle types, story arc expansion, leaderboard/referral work.
Files likely involved: scripts/release, app daily mission route, .knowns runbook.
Verification: Readiness command result recorded; current tester script is accurate.
Handoff: Update task sly001 notes and the launch/rollback runbook.
```

## Planet Hunters Experiment 1 - First Mission Clarity

```md
Project: Planet Hunters Experiment 1
Task: phx002 - Close first-session flow clarity blockers
Repo: /Users/scroobz/Navigation/Native/planet-hunters-experiment-1
Source docs:
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md
- /Users/scroobz/Navigation/Native/planet-hunters-experiment-1/.knowns/docs/dev/remaining-open-tickets-context-and-entry-points.md
- /Users/scroobz/Navigation/Native/planet-hunters-experiment-1/.knowns/docs/specs/level-2-3-mode-split-and-exposure-formula-specification.md
Goal: Make the first mission understandable and non-dead-ending for a tester.
Scope: Installed PWA layout/prompt, first mission payout, next mission CTA, button guide.
Out of scope: Mission 5, construction, full room art, advanced economy.
Files likely involved: react-shell.js, scene/Scripts/Utils/ResourceYield.gd, scene/Scripts/Earth/MissionDebrief.gd, scene/Scripts/UI/SidescrollMining.gd.
Verification: Tester can launch, mine, debrief, understand payout, and find next mission.
Handoff: Update task phx002 notes with files changed and exact test run.
```

## Coral - Product Shell

```md
Project: Click-A-Coral
Task: cor001 - Replace debug web host with player-facing Coral PWA shell
Repo: /Users/scroobz/Navigation/Coral
Source docs:
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md
- /Users/scroobz/Navigation/Coral/.knowns/docs/mvp-audit-2026-04-11.md
- /Users/scroobz/Navigation/Coral/.knowns/INDEX.md
Goal: Make the browser entry point usable by a player/tester, not just a developer.
Scope: Hide debug controls/logs, provide game launch/restart, preserve dev access if needed behind a clear gate.
Out of scope: Full visual redesign, all Tank work, all audio work.
Files likely involved: web/app/page.tsx, PWA metadata/manifest, existing bridge shell files.
Verification: Clean browser session lands on a player-facing Coral entry and can start the MVP path.
Handoff: Update task cor001 notes and include screenshots if possible.
```

## Bumble - MVP Reconstruction

```md
Project: Bumble / Bee Garden
Task: bum001 - Reconstruct Bumble MVP from notes and current repo state
Repo: /Users/scroobz/Navigation/bee-garden
Source docs:
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md
- /Users/scroobz/Navigation/quartz/content/Mechanics/Bumble/Crop-System.md
- /Users/scroobz/Navigation/quartz/content/Mechanics/Bumble/Hive-Management.md
- /Users/scroobz/Navigation/quartz/content/Mechanics/Bumble/Pollination-Mechanics.md
- /Users/scroobz/Navigation/quartz/content/Mechanics/Bumble/Order-Fulfillment-System.md
Goal: Turn scattered Bumble notes and current repo state into a shippable first-week MVP spec.
Scope: Audit launch command, current screens, persistence, garden loop, order loop, and distribution target.
Out of scope: Full crop list, seasons, deep decoration, all bee variants.
Files likely involved: app/screens/components, package scripts, .knowns/docs or a new repo-local MVP doc.
Verification: MVP spec names first session, first content set, launch command, and first tester script.
Handoff: Update task bum001 notes and link the new spec.
```

## Project Management - PocketBase Backbone

```md
Project: Star Sailors Project Management
Task: pm0003 - Design Go PocketBase remote project-management backbone
Repo: /Users/scroobz/Navigation/quartz
Source docs:
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md
- /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/New-Citizen-Science-Project-Intake.md
Goal: Decide the smallest remote database/API that makes Obsidian, Knowns, Things, and agents work together.
Scope: Schema, hosting options, auth model, agent permissions, sync direction, migration plan.
Out of scope: Building the PocketBase app before scope is accepted.
Files likely involved: new project-management architecture note, maybe future utilities.
Verification: Decision doc is concrete enough to estimate and implement in one follow-up session.
Handoff: Update task pm0003 notes and link the decision doc.
```

