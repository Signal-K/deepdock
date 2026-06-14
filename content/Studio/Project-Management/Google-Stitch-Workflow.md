---
type: design-workflow
status: active
created: 2026-04-20
tags:
  - google-stitch
  - design
  - star-sailors
  - sketches
  - agents
---

# Google Stitch Workflow

## Principle

Use Stitch for bounded flow and screen exploration, not as a wholesale replacement for the UI already built across the projects.

Most Star Sailors projects already have working UI and partial visual language. Stitch should help clarify the next screen or flow before implementation, not reset the existing apps to a generated design system.

## Best Use Cases

Use Stitch for:

- New flows that are still ambiguous.
- Paper sketch to high-fidelity screen exploration.
- Mobile-first variants of one existing screen.
- Empty/loading/error states.
- Tester-facing onboarding flows.
- Distribution/landing/tester instruction pages.
- Comparing 2-3 layout directions before asking an agent to implement one.

Avoid Stitch for:

- Redesigning a whole project at once.
- Replacing established game UI without a migration reason.
- Generating code to paste directly over project components.
- Inventing new visual language that ignores the current implementation.

## Input Packet For Stitch

For each Stitch session, prepare:

1. Project name.
2. Existing screen screenshot if available.
3. Paper sketch photo if available.
4. The exact user goal.
5. The target device.
6. Current design constraints.
7. What must stay recognizable.
8. What can change.
9. Two or three success criteria.

Template:

```md
Design a mobile-first screen for [project].

Existing context:
- [one sentence about the project]
- This screen comes after [previous action]
- The player needs to [goal]

Keep:
- [existing visual element / navigation / terminology]

Change:
- [layout issue / unclear hierarchy / missing state]

Constraints:
- Mobile portrait first.
- No marketing hero.
- Must fit game UI, not SaaS admin UI.
- Avoid generic cards unless they are repeated items.

Output:
- One high-fidelity screen.
- Loading, empty, and error states if relevant.
- A short DESIGN.md-style handoff with spacing, colors, components, and interaction notes.
```

## How Stitch Fits Into The Workflow

1. Draw rough flow on paper.
2. Photograph sketch and add it to the vault under `media/project-intake/<project-slug>/`.
3. Create or update the project/flow note in Obsidian.
4. Generate 1-3 Stitch variants.
5. Pick one direction manually.
6. Save screenshots/export/code notes back to Obsidian.
7. Create a scoped Knowns task for implementation.
8. Give the agent the selected design, current code paths, acceptance criteria, and verification command.

## Agent Handoff Rule

Do not give an agent a broad Stitch export and ask it to "make the app match this."

Instead, create a task like:

```md
Implement the selected Coral identify-phase mobile layout from Stitch variant B.

Scope:
- Only project/scenes/ui/identify_phase.gd and related style constants.
- Preserve current identify submission behavior.
- Do not change level progression or subject loading.

Acceptance:
- No non-tutorial skip path.
- Species chips fit on iPhone portrait.
- Confirm action remains visible above safe area.
- Existing identify tests/tour still pass.
```

## Per-Project Stitch Targets

Star Sailors Web Client:
- First-session route map.
- Logged-in hub structure view.
- Mobile PWA safe-area states.

Saily:
- Daily mission briefing.
- Result/progress screen.
- PWA install prompt.

Experiment 1:
- First mission button guide.
- Debrief/next mission CTA.
- Mobile mining HUD.

Coral:
- Player-facing PWA shell.
- Tank MVP hub.
- Results panel for 6-8 species.
- Water HUD.

Bumble:
- First garden loop.
- Order fulfillment flow.
- Hive/nectar screen.

## Source Notes

Google describes Stitch as an AI-native software design canvas for creating and iterating high-fidelity UI from natural language, with images/text/code as inputs and export paths for developer tools. Treat it as a design accelerator and critique surface, not the system of record.

