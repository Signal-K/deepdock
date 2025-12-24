---
type: segment-base
project: Star-Sailors
segment: v2.1 Bug Fixes & Patches
isNext: true
status: in-progress
banner: media/Pasted image 20251117074314.png
---

# v2.1 Bug Fixes & Patches

## Stories in this Segment

```dataview
TABLE WITHOUT ID
  link(file.link, story) as "Story",
  priority as "Priority",
  status as "Status"
FROM "_Tasks/Star-Sailors/Stories"
WHERE segment = "v2.1 Bug Fixes & Patches"
SORT priority DESC, status ASC
```

## All Tasks in Segment

```dataview
TASK
FROM "_Tasks/Star-Sailors/Stories"
WHERE segment = "v2.1 Bug Fixes & Patches"
SORT !completed, priority DESC
```

## Segment Overview
Focus on improving user experience through navigation enhancements and performance optimizations for the v2.1 release.

## Progress Summary
- **Stories:** 2 active stories
- **Key Focus:** User navigation and application responsiveness
- **Status:** In active development


**⏫ High Priority**
- [x] New logo - for Product Hunt launch ⏫ 🆔 435tdb ➕ 2025-12-17 🛫 2025-12-17 📅 2025-12-17 📋 v2.1 Bug Fixes & Patches