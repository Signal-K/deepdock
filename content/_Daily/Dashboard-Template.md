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
type append template
action Create-Task
templater true
class inline
```
```button
name 📋 Organize
type append template
action Organize-Daily
templater true
class inline
```
```button
name 🆕 Sprint
type append template
action New-Sprint
templater true
class inline
```
```button
name 🧠 Analyze
type append template
action Weekly-Analysis
templater true
class inline
```
```button
name 📦 Archive Wk
type append template
action Archive-Week
templater true
class inline
```
```button
name 📅 Archive
type append template
action Archive-Daily
templater true
class inline
```

```button
name 🔄 Reset
type append template
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
limit: 4
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




### Meetings & Conversations




### Ideas & Brainstorming




---

## ⚡ High Priority Tasks (Top 5)

> Click a task to open its file. Tasks auto-update from all projects.

```dataview
TASK
FROM ""
WHERE !completed 
  AND (contains(text, "⏫") OR contains(text, "#p1") OR contains(text, "#high-priority") OR contains(text, "🔥"))
  AND file.frontmatter.isNext = true
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

