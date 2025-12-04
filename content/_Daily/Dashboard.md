---
title: Daily Dashboard
date: {{date:YYYY-MM-DD}}
tags:
  - dashboard
  - daily
icon: lucide//layout-dashboard
---

# 🎯 Daily Dashboard - {{date:YYYY-MM-DD}}

## 🚀 Quick Actions

```button
name ➕ Create
type prepend template
action Create-Task
templater true
class inline
```
```button
name 📋 Organize
type prepend template
action Organize-Daily
templater true
class inline
```
```button
name 🆕 Sprint
type prepend template
action New-Sprint
templater true
class inline
```
```button
name 🧠 Analyze
type prepend template
action Weekly-Analysis
templater true
class inline
```
```button
name 📦 Archive Wk
type prepend template
action Archive-Week
templater true
class inline
```
```button
name 📅 Archive
type prepend template
action Archive-Daily
templater true
class inline
```


```button
name 🔄 Reset
type prepend template
action Reset-Dashboard
templater true
class inline
```
```button
name 📊 Projects
type link
action obsidian://open?vault=quartz&file=_Tasks/By-Project
class inline
```

---

## 📅 Recent Dashboards (Last 7 Days)

```note-gallery
path: content/_Daily
query: 'path:content/_Daily/'
recursive: false
limit: 7
sort: desc
sortBy: mtime
fontSize: 8pt
showTitle: true
breakpoints:
  default: 4
  1500: 3
  1000: 2
  700: 1
```

---

## �📥 Today's Notes Dump

> **Tip:** Just dump everything here. Click "Organize Daily Notes" button to auto-organize.

### Quick Thoughts
A nice UI:
![[Pasted image 20251130135854.png]]



### Meetings & Conversations




### Ideas & Brainstorming

![[IMG_0810.jpeg]]


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
