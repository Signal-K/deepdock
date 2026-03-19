---
type: plan
project: Star-Sailors
status: in-progress
tags: [star-sailors, analytics, posthog, metrics]
created: 2026-03-19
extracted-from: daily notes Dec–Jan
---

# Analytics Strategy

## Current State

- PostHog installed on Star-Sailors Web
- Basic events tracked during V2 / Product Hunt launch period

## V2.1 Expansion Plan

From 2025-12-15 daily: expand PostHog for the V2.1-Bug-Fixes segment.

Priority events to add:
- Classification completion rate (how many users finish a full classification)
- Session length by page/viewport
- Drop-off points in the tutorial flow
- Anonymous → registered user conversion funnel

## Ecosystem-Wide Experience Tracking (idea from Dec 15)

- Track user activity across all minigames (Bumble, Coral, Experiment1) with a shared user ID
- Unified "contribution score" per user visible in the Star-Sailors hub
- Source: 2025-12-15 daily note — "experience tracking across ecosystem"

## Post-Product Hunt Findings (Jan 2026)

From 2026-01-03 meeting with Rhys:
- **No signups since 25 Dec** — visits declining even below pre-PH baseline
- Newsletter as re-engagement channel
- Key question: what messaging gets the most responses?

Metrics targets (from PH Prep doc):
- 30 upvotes, 5 comments, 30 traffic visits, 5 signups

## Mobile App Consideration

From 2025-12-15: Expo-based mobile app could help user acquisition (app stores easier to discover than web). Deferred until web is stable.

## Survey Integration

From 2026-01-16: survey widget triggered after tutorial completion — collect qualitative feedback at the moment of highest engagement.

## Open Questions

- [ ] What's the right PostHog plan tier for current traffic?
- [ ] Should Bumble/Coral share the same PostHog project or separate?
- [ ] Retention email cadence after signup?
