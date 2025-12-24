# Star Sailors Tasks

Project: [[index|Star Sailors]]

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
- [ ] 🔥 Rhys: Review V2 release - ensure everything works, is clear, and responsive
- [ ] 🔥 Write out top 3 most interesting features
- [ ] 🔥 Determine complete value offer (learning about space + citizen science + 1 more)
- [ ] Make badge/announcement at top more prominent (change to pale yellow)
- [ ] Make start buttons more prominent
- [ ] Add subtle background design to hero section (dots, grid, or semi-transparent image)
- [ ] Adjust hero section content to guide eyes to start button
- [ ] Plan and create launch video (consider asking Dev for help)
- [ ] Schedule meeting with Rhys and Kriswanto about PH launch

### UX Improvements
- [ ] Investigate why users reaching Linked_Anomalies aren't converting to permanent
- [ ] Determine if anon user feature is harming growth
- [ ] Evaluate if graduation process is working or confusing
- [ ] Consider separate playable version link to differentiate visitors vs players

### Performance & Analytics
- [ ] Investigate Vercel insights for speed/first load time improvements
- [ ] Complete Posthog analytics integration
- [ ] Resolve performance issue shown in screenshot
- [ ] Set up conversion funnel tracking

### Content Strategy
- [ ] Decide on writing topics (discuss with Fred)
- [ ] Set up Substack for writing
- [ ] Configure cross-posting to Farcaster & Twitter
- [ ] Add comments to Quartz site (consider utteranc.es)

### Classification & Ecosystem Integration
- [ ] 🔥 Define value proposition for classification ecosystem approach
- [ ] Design data flow architecture from Star Sailors to other projects
- [ ] Implement standalone vs. integrated experience options
- [ ] Create unified user experience across multiple projects
- [ ] Build cross-project mission integration system

**Related Documentation:**
- [[Product-Hunt-Launch]]
- [[User-Experience]]
- [[Analytics]]
- [[Classification-Integration]]
