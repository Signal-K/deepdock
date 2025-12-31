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
for (let page of dv.pages('"content/_Tasks"')) {
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
There are some notes from [[2025-12-29]] that I need to review.

Currently for #Bumble I've decided to use the Wheat assets/sprites for everything. I still need to determine the list of crops we're going to start with.
Seasonal crops or skins for crops...could be an idea.
Won't do anything on the tutorial for Bumble until we get some testers - see [[Tutorial interface - check with other testers for feedback]]
I think I'm also going to need to get feedback on the timing - [[Finalise timing for crops & growth]]. Until I get someone else on this, I don't think I'm going to be able to come up with an objectively good user experience here. Worst case scenario, I can brainstorm "with" gpt.

So I think I've got today's tasks for #Bumble all organised. 
I might create a new branch for the repo now...

Still not going to do anything on #Star-Sailors-web, not even any research. Ideally meet with Fred and Rhys, discuss results of #ProductHunt launch, then determine newsletter vs mass email...etc. 

Like I said in [[2025-12-29]], I'm not going to do anything on #Coral project for now, but probably this weekend I'll need to organise the stories for it.

Crashlandings will probably be what I focus on when I get back to the office, that should be fun.

[and that's today's preview done, I think]. 

### Meetings & Conversations




### Ideas & Brainstorming




---

