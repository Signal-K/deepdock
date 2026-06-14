---
type: tooling-options
status: active
created: 2026-04-20
tags:
  - project-management
  - knowns
  - obsidian
  - things
  - agents
---

# Project Management Tooling Options

## Decision

Keep Knowns. Do not replace it with Jira/Linear-style tools.

The valuable part of Knowns is that it behaves like project-local infrastructure:

- Installable into each codebase.
- Markdown-backed.
- Local-first.
- Git-readable.
- Agent-readable.
- Simple enough to archive/reset by moving files.

The issue to solve is not "find a bigger project-management platform." The issue is "make Knowns reliable and scriptable enough that the browser editor is optional."

## Tool Roles

- Obsidian: long-form thinking, sketches, project briefs, MVP definitions, agent session packets.
- Knowns: shared work ledger for everything being worked on, including agent coding tasks.
- Things: personal daily cockpit only.
- Agents: receive scoped packets and update Knowns and handoff notes.

The tooling should prevent vague prompts like "make the UI better" from becoming unbounded agent work. Every coding task needs scope, source docs, acceptance criteria, verification, and handoff.

## Keep Knowns, Harden The Workflow

Use Knowns as the shared work ledger and avoid relying heavily on the browser editor.

Pros:
- Already installed across the repos.
- File-backed tasks are easy for agents to read and edit.
- Works well with git and Obsidian references.
- The reset/archive model already gives each project a clean workspace.
- It does not become a Jira/Linear-style product-management system.

Cons:
- Browser editor reliability is a recurring friction point.
- Weak mobile/daily planning experience compared with Things.
- No mature built-in AI/project intelligence beyond what agents do by reading files.

## Hardening Plan

Useful improvements:

- A CLI script to list active tasks across all Star Sailors repos.
- A CLI script to create a task from the standard packet shape.
- A CLI script to archive or defer a task with a required reason.
- A daily export from Knowns to Things-friendly text.
- An Obsidian dashboard that reads the project task files directly.
- A validation command that warns when a task lacks source docs, acceptance criteria, or verification.
- A "do not create broad agent task" check for titles like "make better", "polish everything", or "fix inconsistencies" without scoped surfaces.

## Daily Flow

Morning:
- Pick 3-5 personal tasks from Knowns into Things.
- Pick at most two implementation projects for active work.

During work:
- Human work goes in Things and Knowns.
- Agent work goes in Knowns and a session packet/handoff note.
- Obsidian captures decisions, sketches, and long-form reasoning.

End of day:
- Update Knowns statuses.
- Write one short daily note: shipped, blocked, next.
- Carry only truly active personal tasks forward in Things.

## Not Pursuing

Do not pursue Plane, Huly, Jira, Linear, or similar project-management suites for this workflow right now. They solve a different problem and would add too much product-management surface area.

Vikunja/AppFlowy/Leantime may still be useful references for specific features, but they are not replacement candidates for the current Star Sailors work ledger.
