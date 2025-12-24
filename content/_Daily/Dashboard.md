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
Today is the day that I finally decide how to organise the notes in the dashboard directory.

Controls also need to be designed for mobile #Godot builds.

### Meetings & Conversations




### Ideas & Brainstorming
Current projects:
* Star Sailors (web) - patches
* "" - #product-hunt - almost finished
* Bumble
* "Crashlandings"
* Coral

Segments for everything:
**STAR SAILORS** (Project)
Product Hunt Launch Segment:
1. Wrap-up Product Hunt launch (story)
This would include the following tasks:
* Sending out emails to everyone
* Saving all links related to launch
* Closing tabs, setting up development log page on `scroobl.es` for the emails. Maybe getting a newsletter together (Substack)

When it comes to Substack, I'll probably have to post from my phone for now.

Also, sometimes stories will be part of multiple segments or projects:

**CRASHLANDINGS** (Project)
Initial infrastructure segment (also relates to BUMBLE project):
1. Add Supabase login & data to template
	1. Guest accounts
	2. Seeing your data
2. Godot full-screen
	1. Easy close/main menu swipe
	2. Check controls that work
3. General - finish current tutorial series

**BUMBLE** (Project)
Initial setup segment - goal here is to have a mobile app & web app (installable as a PWA, while we're waiting for app store approval) where users can plant crops
1. Get data (story)
	1. Initially manually getting pollinator images
	2. Simple web scraping script
2. Update page flow to add vertical & side scrolling:
	1. Hide city/town page
	2. Add vertical scrolling
	3. Add expand/expansion page to bottom (final) page for hive/plot areas
3. Update hive pages to look like real hives
	1. Figure out a design template
4. Allow users to expand plots & hives
	1. Expand page shows current level & available perks (e.g. expansions)
	2. If the user has an available perk, they can create a new page - this is saved for the user
	3. User can also increase number of plots per page (each page is referred to as a "Greenhouse" (maybe a better name for that exists...somewhere??))
Then in general I need to look at methods for getting bees to pollinate - what is the consistency?

**CORAL** (Project)
1. New repo built on #godot-rn template
2. Start drawing assets


General:
* [x] Back up/archive bin/bloat data in Obsidian #Obsidian #Archive 🆔 swby1n ✅ 2025-12-24

![[Pasted image 20251223103625.png]]
![[Pasted image 20251223104005.png]]
![[Pasted image 20251223104016.png]]
![[Pasted image 20251223104027.png]]![[Pasted image 20251223104034.png]]




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

