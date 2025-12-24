---
title: Star Sailors
tags:
  - project
  - star-sailors
  - web-app
---

# 🚀 Star Sailors Project

**Type:** Web Application  
**Tech Stack:** React, Next.js, Supabase  
**Current Focus:** Post v2.0 maintenance and v3.0 planning  

## Overview

Star Sailors is a citizen science platform that gamifies real astronomical data classification. Users deploy virtual telescopes, satellites, and rovers to discover and classify celestial objects and phenomena.

## 📋 Current Segment: v2.1 Bug Fixes & Patches

> **Focus:** Stabilize v2.0 release with critical fixes and small improvements

### 🐛 Critical Bug Fixes

```dataview
TASK
FROM "content/_Tasks/Projects" 
WHERE contains(text, "📖 Critical Bug Fixes") 
  AND (contains(text, "star-sailors") OR file.path = this.file.path)
  AND !completed
SORT priority DESC, text ASC
```

### 🎨 UI/UX Improvements

```dataview
TASK
FROM "content/_Tasks/Projects" 
WHERE contains(text, "📖 UI/UX Improvements") 
  AND (contains(text, "star-sailors") OR file.path = this.file.path)
  AND !completed
SORT priority DESC, text ASC
```

### ⚡ Performance Optimizations

```dataview
TASK
FROM "content/_Tasks/Projects" 
WHERE contains(text, "📖 Performance Optimizations") 
  AND (contains(text, "star-sailors") OR file.path = this.file.path)
  AND !completed
SORT priority DESC, text ASC
```

### 📝 Direct Tasks (Current Segment)

```dataview
TASK  
FROM "content/_Tasks/Projects"
WHERE contains(text, "📋 v2.1 Bug Fixes & Patches") 
  AND (contains(text, "star-sailors") OR file.path = this.file.path)
  AND !contains(text, "📖")
  AND !completed
SORT priority DESC, text ASC
```

---

## 🔮 Future Segment: v3.0 Major Features

> **Planned:** Major feature additions and architectural improvements

<details>
<summary>Show v3.0 Tasks</summary>

### 🖥️ New User Interface

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE contains(text, "📖 New User Interface") 
  AND contains(text, "star-sailors") 
  AND !completed
SORT priority DESC, text ASC
```

### 🚀 Advanced Features

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE contains(text, "📖 Advanced Features") 
  AND contains(text, "star-sailors") 
  AND !completed
SORT priority DESC, text ASC
```

</details>

## Project Structure

- **[Backend](Backend/)** - Server-side code and APIs
- **[Boards](Boards/)** - Project management and development boards  
- **[Classifications](Classifications/)** - Data classification and taxonomy
- **[Components](Components/)** - UI components and layouts
- **[Ideas](Ideas/)** - Project ideas and brainstorming
- **[Missions](Missions/)** - Game missions and user tasks
- **[Research](Research/)** - Research documentation and findings
- **[Sprints](Sprints/)** - Sprint planning and execution
- **[Viewports](Viewports/)** - UI viewport components and layouts
- **[Features](Features/)** - Major feature implementations
- **[Backend](Backend/)** - API, database, server logic
- **[Viewports](Viewports/)** - Main viewport sections
- **[Classifications](Classifications/)** - Classification types and logic
- **[Missions](Missions/)** - Mission definitions and progression
- **[Research](Research/)** - Research tree and upgrades
- **[Media](Media/)** - Screenshots, diagrams, notes

## Current Sprint

See active sprint in [Sprints folder](../../_Sprints/Active/)

## Related Projects

- [[Projects/Bumble/index|Bumble]] - Companion minigame
- [[Projects/Roving/index|Roving]] - Mobile exploration game

## External Links

- [GitHub Repository](https://github.com/Signal-K/client)
- [Live Site](https://starsailors.app)
- [Discord](https://discord.gg/your-discord)

---

*Last updated: 2025-11-07*
