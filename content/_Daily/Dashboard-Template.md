---
title: Daily Dashboard
date: {{date:YYYY-MM-DD}}
tags:
  - dashboard
  - daily
---

# 🎯 Daily Dashboard - {{date:YYYY-MM-DD}}

## � Quick Actions

```button
name ➕ Create Task
type command
action Templater: Run Script - create-task
color blue
```
^button-create-task

```button
name 📋 Organize Daily Notes
type command
action Templater: Run Script - organize-daily
color green
```
^button-organize

```button
name 🆕 New Sprint
type command
action Templater: Run Script - new-sprint
color purple
```
^button-new-sprint

```button
name 📊 View All Projects
type link
action obsidian://open?vault=quartz&file=_Tasks/By-Project
color default
```
^button-projects

---

## �📥 Today's Notes Dump

> **Tip:** Just dump everything here. Click "Organize Daily Notes" button to auto-organize.

### Quick Thoughts




### Meetings & Conversations




### Ideas & Brainstorming




---

## ⚡ High Priority Tasks (Top 5)

> Click a task to open its file. Tasks auto-update from all projects.

```dataview
TASK
WHERE !completed 
  AND (contains(text, "⏫") OR contains(text, "#p1") OR contains(text, "#high-priority") OR contains(text, "🔥"))
SORT file.name ASC
LIMIT 5
```

*No high-priority tasks? You're crushing it! 🎉*

---

## ✅ Today's Tasks

> Tasks due today or marked for today

```dataview
TASK
WHERE !completed
  AND (contains(text, "{{date:YYYY-MM-DD}}") OR contains(tags, "today"))
SORT file.name ASC
```

---

## ➕ Quick Task Inbox

> **Create tasks here**, then click "Organize Daily Notes" button to route them automatically.
> 
> **Priority markers:** 
> - ⏫ High priority (P1)
> - 🔼 Medium priority (P2-P3)  
> - 🔽 Low priority (P4-P5)
> 
> **Project detection** (add these keywords):
> - `star-sailors`, `telescope`, `satellite` → Star Sailors
> - `bumble`, `bee`, `pollinator` → Bumble
> - `roving` → Roving
> - `station`, `station-198` → Station 198

### Tasks to Route

- [ ] 




---

## 📊 Quick Stats

```dataview
TABLE WITHOUT ID
  length(file.tasks) as "Total Tasks",
  length(filter(file.tasks, (t) => !t.completed)) as "Incomplete",
  length(filter(file.tasks, (t) => t.completed)) as "Completed"
FROM "content/_Sprints/Active"
```

---

## 📝 Recent Sprint Activity

```dataview
TABLE WITHOUT ID
  file.link as "Sprint",
  file.mtime as "Last Modified"
FROM "content/_Sprints/Active"
SORT file.mtime DESC
LIMIT 3
```

---

## 🔗 Quick Links

- [[_Tasks/Current-Sprint|Current Sprint Tasks]]
- [[_Tasks/All-Tasks|All Tasks]]
- [[_Tasks/By-Project|Tasks by Project]]
- [[_Sprints/Active/SSG-295|Active Sprint: SSG-295]]
- [[_Inbox/README|Inbox]]

---

*Dashboard buttons powered by [Buttons](https://github.com/shabegom/buttons) and [Templater](https://github.com/SilentVoid13/Templater) plugins*  
*High-priority tasks use: ⏫, #p1, or #high-priority*
