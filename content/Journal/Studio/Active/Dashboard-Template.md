---
title: Daily Dashboard
date: {{date:YYYY-MM-DD}}
tags:
  - dashboard
  - daily
  - contextual
active_projects:
{{ACTIVE_PROJECT_IDS}}
project_tags:
{{ACTIVE_PROJECT_TAGS}}
icon: lucide//layout-dashboard
---

# Context Dashboard - {{date:YYYY-MM-DD}}

> Use `🔄 Setup Context` each morning to pick projects and rebuild this page for today.

## Quick Actions

```button
name 🔄 Setup Context
type append template
action Reset-Dashboard
templater true
class inline
```

```button
name ➕ Add Task
type append template
action Create-Task
templater true
class inline
```

```button
name 🏷️ AutoTag + Route
type append template
action Organize-Daily
templater true
class inline
```

```button
name 🗄️ Smart Archive
type append template
action Archive-Daily
templater true
class inline
```

```button
name 📚 Categories
type link
action obsidian://open?vault=content&file=Projects/index
class inline
```

```button
name 🧭 Flow Guide
type link
action obsidian://open?vault=content&file=Operations/System/Documentation/DASHBOARD_FLOW_PROPOSALS
class inline
```

---

## Active Project Base Views

```dataviewjs
const map = {
  "star-sailors-web": {
    label: "Star Sailors Web (2.1-3.0)",
    taskRoot: "Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web",
    docsRoot: "Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Star-Sailors-Web",
  },
  "experiment1": {
    label: "Experiment1",
    taskRoot: "Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Experiment1",
    docsRoot: "Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Experiment1",
  },
  "bumble": {
    label: "Bumble",
    taskRoot: "Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Bumble",
    docsRoot: "Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Bumble",
  },
  "click-a-coral": {
    label: "Click-A-Coral",
    taskRoot: "Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Click-A-Coral",
    docsRoot: "Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Click-A-Coral",
  },
  "godot-mars-archive": {
    label: "Godot-Mars-Archive",
    taskRoot: "Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Godot-Mars-Archive",
    docsRoot: "Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Godot-Mars-Archive",
  },
  "weathr": {
    label: "Weathr",
    taskRoot: "Projects/Projects/Other-Projects/Tasks/Weathr",
    docsRoot: "Projects/Projects/Other-Projects/Docs/Weathr",
  },
  "map-app": {
    label: "Map App",
    taskRoot: "Projects/Tasks/Map-App",
    docsRoot: "Projects/Projects/Other-Projects/Docs/Map-App",
  },
  "prehog": {
    label: "Prehog",
    taskRoot: "Projects/Tasks/Prehog",
    docsRoot: "Projects/Projects/Other-Projects/Docs/Prehog",
  },
};

const active = Array.isArray(dv.current().active_projects) ? dv.current().active_projects : [];
if (!active.length) {
  dv.paragraph("No active projects configured. Click `🔄 Setup Context`.");
} else {
  for (const id of active) {
    const p = map[id];
    if (!p) continue;

    dv.header(3, p.label);

    const tasks = [];
    for (const pg of dv.pages(`"${p.taskRoot}"`)) {
      if (!pg.file?.tasks) continue;
      for (const t of pg.file.tasks) {
        if (!t.completed) tasks.push(t);
      }
    }

    if (tasks.length) {
      const statusRank = (task) => {
        const status = String(task.status ?? "").toLowerCase();
        if (status === "todo") return 0;
        if (status === "in-progress" || status === "in progress") return 1;
        return 2;
      };
      tasks.sort((a, b) => {
        const rankDiff = statusRank(a) - statusRank(b);
        if (rankDiff !== 0) return rankDiff;
        return String(a.text ?? "").localeCompare(String(b.text ?? ""));
      });

      dv.paragraph("Open tasks:");
      dv.taskList(tasks.slice(0, 12), false);
    } else {
      dv.paragraph("No open tasks found in base views.");
    }

    dv.table(
      ["Recent Pages", "Modified"],
      dv.pages(`"${p.docsRoot}"`)
        .sort(x => x.file.mtime, 'desc')
        .limit(5)
        .map(x => [x.file.link, x.file.mtime])
    );
  }
}
```

---

## Global Notes

### Meetings & Messages


### Cross-Project Decisions


### Global Ideas


---

{{PROJECT_SECTIONS}}
