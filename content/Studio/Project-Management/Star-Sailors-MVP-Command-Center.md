---
type: project-management
status: active
created: 2026-04-20
week: 2026-04-20
tags:
  - star-sailors
  - mvp
  - knowns
  - obsidian
  - agents
---

# Star Sailors MVP Command Center

This is the cross-project source of truth for the current MVP push. It is designed to be readable by you, Codex, Claude, Gemini, Obsidian, and Knowns without needing hidden context from old ticket piles.

## Operating Rule

For this week, every task must answer one of these questions:

1. Does this make a project playable enough for an external tester?
2. Does this make distribution, feedback capture, or rollback clearer?
3. Does this reduce friction in planning or agent handoff across projects?
4. Does this make it easier to add a new citizen-science project later?

Everything else is backlog or reference.

## Current MVP Definitions

### Star Sailors Web Client

Role: the central ecosystem entry point and main account/hub experience.

MVP this week:
- A first-time user can land on the site, understand that the web client is the main game, sign in or start the right path, choose a citizen-science direction, and complete one science contribution.
- The logged-in game hub shows the user's active structures/entities rather than a generic marketing view.
- Mobile-first layout is usable on real phone viewports, with PWA/safe-area issues resolved enough for tester use.
- PostHog/Sentry or equivalent feedback signals are attached to the critical path.
- Ecosystem links to Saily, Coral, Bumble, and Experiment 1 are clear but do not distract from launching the web client.

Not MVP:
- Full 3.0 visual polish across every structure.
- Every project integration.
- Advanced research upgrades, deep stats, and long-term social loops.

### Saily / The Daily Sail

Role: the short-session daily citizen-science puzzle.

MVP this week:
- One daily mission path works end to end: briefing, puzzle, submission, result, progress update.
- Reset behavior follows Melbourne midnight.
- PWA install/offline shell works well enough to hand to testers.
- Non-MVP pages are hidden or clearly non-blocking.
- A first external tester script and rollback checklist are current for the present build.

Not MVP:
- All story arcs complete.
- Every puzzle type equally polished.
- Full leaderboard, archive, referral, and discussion depth.

### Planet Hunters Experiment 1 / Mining Experiment

Role: a standalone browser-playable Godot experiment validating the mining, mission, rocket, and contractor loop before deeper ecosystem integration.

MVP this week:
- M1-M4 authored onboarding plus Free Operations is the current scope lock.
- A tester can complete the first mission, understand payout, see the next mission CTA, and use basic button help.
- Mining has a working mobile/portrait layout and target-specific terrain/mineral generation.
- PWA shell and install prompts do not block play.
- Distribution build and test script are ready for external feedback.

Not MVP:
- Authored Mission 5 content.
- Deep construction, settlements, multiplayer, advanced room builder, or all generated room art.

### Click-A-Coral / Coral

Role: a mobile-first Godot PWA where a real reef-identification phase configures a reef breeding/restoration puzzle.

MVP this week:
- Player-facing web/PWA shell replaces the current debug host.
- Tutorial, mandatory identify phase, reef puzzle, result/win flow, and 10-level progression path are stable.
- Real subject IDs are wired for levels.
- Tank stays in MVP as a lightweight retention hub: stored bonus species, decorative interaction, passive production.
- Offline/reconnect classification and pending reward behavior are verified.
- Results panel, water HUD, Tank, audio, and QA tour are good enough for external testing.

Not MVP:
- Field-guide copy depth.
- Advanced traits, manual breeding customization, deep Tank stressors, full world map v2.

### Bumble / Bee Garden

Role: a garden/farming/pollination game that can become a nature citizen-science bridge.

MVP this week:
- Reconstruct a current MVP spec from the notes and current repo state.
- One garden loop works: plant crop, grow/harvest, trigger hive/nectar update, pollination reward, inventory update.
- One order-fulfillment path works: NPC/request, required item check, fulfillment, reward, next action.
- The mobile/native/PWA distribution target is chosen for the first tester build.
- A minimal content set exists: first crop, first hive, first bee/pollination reward, first order.

Not MVP:
- Full crop list, seasons, all bee variants, deep decoration, full citizen-science integration.

### Original Native Star Sailors

Role: reference and historical native app, not an active this-week MVP unless a specific distribution or code-reuse question appears.

This week:
- Treat it as archive/reference.
- Do not let it compete with web client, Saily, Experiment 1, Coral, or Bumble unless a concrete task is created.

## This Week's Workstreams

### 1. Planning Backbone

Outcome: one task system that agents can read without redoing discovery.

Tasks:
- Keep this command center current.
- Use the new citizen-science project intake template for any new idea.
- Build a Go + PocketBase plan for remote task/project/asset/session access.
- Define the Things, Obsidian, Knowns, and agent handoff loop.

### 2. MVP Closure

Outcome: each project has a small number of current tasks tied to tester-visible value.

Tasks:
- Web Client: first-session path, mobile/PWA, feedback capture.
- Saily: v0 readiness, one daily path, PWA tester pass.
- Experiment 1: first mission clarity, mining/mobile, distribution build.
- Coral: product shell, subject wiring, mandatory identify, Tank/results/HUD, QA tour.
- Bumble: reconstruct MVP, garden loop, order loop, distribution target.

### 3. Distribution And Testing

Outcome: each project can be handed to a tester with a script.

Required for every project:
- Current URL/build target.
- "What to try first" script.
- Known rollback or disable path.
- Feedback capture path: PostHog, Sentry, screenshot note, or Obsidian issue note.
- One acceptance command/check that Codex can run locally.

## Agent Session Contract

Every agent session should start with:

1. Project.
2. MVP slice.
3. Task ID.
4. Repo path.
5. Source docs.
6. Exact deliverable.
7. Verification command.
8. What must not be touched.
9. Handoff note destination.

Use this packet shape:

```md
Project:
Task:
Repo:
Source docs:
Goal:
Scope:
Out of scope:
Files likely involved:
Verification:
Handoff:
```

Ready-to-copy packets for this week live in [[Agent-Session-Packets-2026-04-20]].

## Tooling Direction

### Short Term

- Obsidian is the planning brain.
- Knowns is the shared work ledger for everything being done, including coding tasks agents execute.
- Things is the personal daily execution surface only: what I am doing today and what I personally need to remember.
- Agents receive short session packets from Obsidian/Knows, not vague backlog dumps.
- Sketches live in the vault as attachments and are referenced from project briefs.
- Separate tester/distribution links are preferred per game, not one combined ecosystem link.

### Database Direction

Use Go + PocketBase if a database becomes necessary. Fly.io or Railway are the preferred hosting candidates. The minimum useful version should expose:
- Projects.
- MVP definitions.
- Tasks.
- Agent sessions.
- Sketch/assets.
- Build/test records.
- Distribution/test cohorts.
- Links back to Obsidian files and Knowns IDs.

PocketBase should be hosted somewhere reachable from your machines and agents. Auth should support personal admin access plus agent-scoped tokens with limited permissions.

### Task Tool Direction

Do not run another destructive/reset-style Knowns operation without an explicit review step. The current reset means: old task files are archived, active boards are small, and work can be reintroduced deliberately.

Knowns remains the intended shared task ledger. The important properties are:

- It installs per codebase like a node package.
- Tasks are local Markdown files.
- Agents can read and edit tasks directly.
- The task state can live beside the project code.
- Obsidian can reference or mirror the Markdown files.

Do not replace Knowns with Jira/Linear-style tools such as Plane or Huly. The better direction is to harden the Knowns + Obsidian + Things workflow:

- Use Knowns files as the shared work ledger.
- Avoid depending on the browser editor when it is unreliable.
- Prefer scriptable creation/update/archive commands around Markdown files.
- Keep task counts small per project.
- Use Obsidian command center and agent packets for planning/control.
- Mirror only personal daily work into Things.

### Design Tool Direction

Paper sketches remain useful. Google Stitch should be used as a bounded design accelerator for specific flows/screens, then the selected direction gets captured in Obsidian and converted into scoped Knowns tasks. See [[Google-Stitch-Workflow]].

## Current Open Questions

- Whether production Knowns should be synced after reviewing the file-based reset.
- Which small scripts are needed to make Knowns reliable without relying on the browser editor.
- Which two implementation projects get active focus first this week.
