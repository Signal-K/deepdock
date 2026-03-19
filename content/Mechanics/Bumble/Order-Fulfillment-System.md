---
type: spec
project: Bumble
status: in-progress
tags: [bumble, mechanics, orders, fulfillment]
created: 2026-03-19
extracted-from: daily notes Jan
---

# Order Fulfillment System

## Concept

Characters (NPCs) appear and request specific items — player fulfills the request from their inventory. Orders are the primary **economic output loop**: grow crops → produce honey → fulfill orders → earn currency/XP.

Source: 2026-01-01 daily note, with additions from 2025-11-23 ("orders as a puzzle game").

## Order Flow

1. Character appears with a request (specific honey type, crop, or crafted item)
2. Player checks inventory for the required items
3. Player fulfills order — gets reward (currency, XP, rare item)
4. Character leaves; cooldown before next order from that character

## Order as Puzzle

From 2025-11-23 daily: "orders as puzzle game" — the intention is that fulfilling orders isn't just stock-checking, it involves planning which crops to grow in what sequence to satisfy upcoming orders efficiently.

## Ordering UI

- Story: [[Update ordering & shop process and add more information]]
- Story: [[Update page flow to add vertical & side scrolling]] — ordering flow needs to support vertical scroll for character list

## Feedback Loop

After fulfilling orders, player should see:
1. What worked (character reaction)
2. What was low stock (prompt to plan next crop cycle)

## Open Questions

- [ ] How many simultaneous orders can be active?
- [ ] Do orders expire if not fulfilled?
- [ ] What rewards are tied to order fulfillment vs. free harvesting?

## Related

- [[Crop-System]]
- [[Hive-Management]]
- [[Update ordering & shop process and add more information]]
