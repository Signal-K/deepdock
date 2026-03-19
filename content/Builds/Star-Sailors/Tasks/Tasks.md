---
icon: lucide//list-checks
---

# Star Sailors Tasks

Project: [[Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web/index|Star Sailors]]

## 🔥 High Priority

> Tasks marked as urgent or high priority

```dataview
TASK
WHERE file = this.file
  AND !completed
  AND (contains(text, "🔥") OR contains(text, "⚡"))
SORT text ASC
```

## 📋 Active Tasks

> All incomplete tasks for this project

```dataview
TASK
WHERE file = this.file
  AND !completed
SORT text ASC
```

## ✅ Recently Completed

> Last 10 completed tasks

```dataview
TASK
WHERE file = this.file
  AND completed
SORT completion DESC
LIMIT 10
```

---

## Tasks

### Product Hunt Launch
- [x] 🔥 Rhys: Review V2 release - ensure everything works, is clear, and responsive
- [x] 🔥 Write out top 3 most interesting features
- [x] 🔥 Determine complete value offer (learning about space + citizen science + 1 more)
- [x] Make badge/announcement at top more prominent (change to pale yellow)
- [x] Make start buttons more prominent
- [x] Add subtle background design to hero section (dots, grid, or semi-transparent image)
- [x] Adjust hero section content to guide eyes to start button
- [x] Plan and create launch video (consider asking Dev for help)
- [x] Schedule meeting with Rhys and Kriswanto about PH launch

### UX Improvements
- [x] Consider separate playable version link to differentiate visitors vs players

### Performance & Analytics
- [x] Investigate Vercel insights for speed/first load time improvements
- [x] Complete Posthog analytics integration
- [x] Resolve performance issue shown in screenshot
- [x] Set up conversion funnel tracking

### Content Strategy
[[Post-PH launch wrapup]]

### Classification & Ecosystem Integration

**Related Documentation:**
- [[Product-Hunt-Launch]]
- [[User-Experience]]
- [[Analytics]]
- [[Classification-Integration]]
[[Post-PH launch wrapup]]

## Navigation
- [[Projects/_Index|Categories Index]]
- [[Projects/Tasks/index|Tasks Index]]
- [[Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web/index.md|Tasks - Star-Sailors-Ecosystem/Star-Sailors-Web Index]]
