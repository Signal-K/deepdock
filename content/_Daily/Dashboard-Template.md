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
action obsidian://open?vault=quartz&file=_Tasks/By-Project
class inline
```

---


## 🗓️ Today's Focus Tasks

```dataviewjs
const today = dv.date("today").toFormat("yyyy-MM-dd");
let tasks = [];
let debug = [];
for (let page of dv.pages('"content/_Tasks"')) {
  if (page.file && page.file.tasks) {
    for (let t of page.file.tasks) {
      if (t.text.includes(`#${today}`)) {
        tasks.push(t);
        debug.push(`${page.file.name}: ${t.text}`);
      }
    }
  }
}
if (tasks.length === 0) {
  dv.paragraph('No tasks tagged for today.');
} else {
  dv.taskList(tasks, false);
}
// Debug output:
if (debug.length > 0) {
  dv.header(4, 'Debug: Tasks found for today');
  debug.forEach(d => dv.paragraph(d));
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

### Quick Thoughts




### Meetings & Conversations




### Ideas & Brainstorming




---

