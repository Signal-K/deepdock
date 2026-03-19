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
action obsidian://open?vault=quartz&file=Projects/_Index
class inline
```

---


## 🗓️ Today's Focus Tasks (2025-12-29)

```dataviewjs
const today = "2025-12-29";
let tasks = [];
for (let page of dv.pages('"content/Categories"')) {
  if (page.file && page.file.tasks) {
    for (let t of page.file.tasks) {
      if (t.text.includes(`#${today}`)) {
        tasks.push(t);
      }
    }
  }
}
if (tasks.length === 0) {
  dv.paragraph('No tasks tagged for today.');
} else {
  dv.taskList(tasks, false);
}
```

## 🧩 In-Progress Story Tasks

```dataviewjs
// Stories in progress with no tasks
const withTasks = new Set(pages.map(p => p.file.path));
const noTaskStories = allStories.filter(p => !withTasks.has(p.file.path));

dv.header(3, "📝 In-Progress Stories (No Tasks)");
if (noTaskStories.length === 0) {
  dv.paragraph("No in-progress stories without tasks.");
} else {
  dv.header(4, "Stories in progress (no tasks defined):");
  noTaskStories.forEach(p => dv.paragraph(p.file.link));
}
```

## 📅 Recent

```note-gallery
path: Operations/Daily/Active
query: 'path:Operations/Daily/Active/'
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

### Quick Thoughts




### Meetings & Conversations




### Ideas & Brainstorming




---

## Routed Notes
- [[Projects/Projects/Star-Sailors/Ideas/Star-Sailors-Ecosystem/Bumble/Daily-Insights/Dashboard.md|Routed: Bumble Ideas]]
- [[Projects/Docs/General-Operations/Daily-Notes/Dashboard.md|Routed: General-Operations Docs]]
