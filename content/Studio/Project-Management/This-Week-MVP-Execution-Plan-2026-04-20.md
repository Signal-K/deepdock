---
type: weekly-plan
status: active
created: 2026-04-20
week_start: 2026-04-20
week_end: 2026-04-26
timezone: Australia/Melbourne
tags:
  - star-sailors
  - weekly-plan
  - mvp
  - distribution
  - testing
---

# This Week MVP Execution Plan - 2026-04-20

This plan replaces the old active Knowns task pile for the week of 2026-04-20 to 2026-04-26.

## Priority Order

1. Build the planning backbone so every project can be worked on without rediscovery.
2. Close one tester-visible MVP path per project.
3. Prepare distribution and feedback capture.
4. Defer any feature that does not help this week's tester release.

## Monday: Reset And Triage

- Confirm the new Knowns queue after the archive/reseed.
- Read this command center before starting any project task.
- For each project, run the fastest health check available and record the result in that project's release task.
- Choose the first two projects to actively push this week.

Recommended first two:
- Star Sailors Web Client, because it is the central ecosystem entry.
- Coral or Saily, depending on which is closest to tester distribution.

## Tuesday-Wednesday: MVP Closure

Focus on one project at a time.

Web Client:
- Lock the first-session path.
- Fix mobile/PWA blockers on the golden path.
- Confirm analytics/feedback capture.

Saily:
- Refresh the v0 checklist against current code.
- Verify today's mission path.
- Update tester script and rollback dates.

Experiment 1:
- Close first-session clarity blockers.
- Verify mining mobile/portrait and proc-gen uniqueness.
- Prepare browser build/test script.

Coral:
- Replace debug shell.
- Finish subject IDs.
- Enforce mandatory identify.
- Verify offline queue and reward sync.

Bumble:
- Reconstruct MVP from notes and repo.
- Ship one garden loop and one order loop.
- Choose distribution target.

## Thursday: Distribution Pack

For each project touched this week, produce:
- Build URL or local launch instructions.
- Tester script.
- Feedback capture path.
- Rollback/disable path.
- Known blockers and what testers should ignore.

## Friday-Sunday: External Testing And Capture

- Send the smallest viable invite set.
- Watch analytics/errors.
- Convert only blocking feedback into Knowns tasks.
- Keep nice-to-have feedback in Obsidian notes, not active task boards.

## Active Project Limits

Do not actively work more than two implementation projects in the same day unless the extra work is just a smoke test or admin task.

Keep each project to five or fewer active Knowns tickets. If a new ticket is needed, archive or close one first.

## Done Criteria For The Week

- Current Knowns queues only contain this week's MVP/distribution/testing work.
- Each project has a concise MVP definition.
- At least one project has a fresh tester build and script.
- The new project intake template exists and can be used without asking an agent to infer the whole ecosystem.
- There is a concrete decision path for Go + PocketBase, Things, Obsidian, and agent integration.

