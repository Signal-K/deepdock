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

## 🧩 In-Progress Story Tasks

```dataviewjs
// Get all in-progress stories
const allStories = dv.pages('"content/_Tasks"').where(p => {
  const fm = p.file.frontmatter || {};
  const type = fm.type ?? "";
  const status = fm.status ?? [];
  const isInProgress = Array.isArray(status) ? status.includes("in-progress") : (status === "in-progress");
  return type === "story" && isInProgress;
});
// Stories with tasks
const pages = allStories.filter(p => Array.isArray(p.file.tasks) && p.file.tasks.length > 0);

dv.header(3, "🧩 In-Progress Story Tasks");
if (pages.length === 0) {
  dv.paragraph("No in-progress story tasks.");
} else {
  pages.forEach(p => {
    const tasks = p.file.tasks.filter(t => !t.checked);
    if (tasks.length > 0) {
      dv.header(4, p.file.link);
      dv.taskList(tasks, false);
    }
  });
}

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

