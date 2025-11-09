---
title: {{PROJECT}} Dashboard
project: {{PROJECT}}
tags:
  - dashboard
  - {{PROJECT_TAG}}
---

# 🎯 {{PROJECT}} Dashboard

> Minimal, powerful project overview

## ⚡ Top 5 Priority Tasks

```dataview
TASK
FROM "content/Projects/{{PROJECT}}"
WHERE !completed
  AND (contains(text, "🔥") OR contains(text, "⚡") OR contains(text, "high"))
SORT text ASC
LIMIT 5
```

## 📊 Project Stats

```dataview
TABLE WITHOUT ID
  length(file.tasks) as "Total",
  length(filter(file.tasks, (t) => !completed)) as "Active",
  length(filter(file.tasks, (t) => completed)) as "Done"
FROM "content/Projects/{{PROJECT}}"
WHERE file.tasks
```

## 📝 Recent Activity

```dataview
TABLE WITHOUT ID
  file.link as "File",
  file.mtime as "Modified"
FROM "content/Projects/{{PROJECT}}"
SORT file.mtime DESC
LIMIT 5
```

## 🔗 Quick Links

- [[Tasks|{{PROJECT}} Tasks]]
- [[index|{{PROJECT}} Overview]]
- [[../../_Daily/Dashboard-Template|Daily Dashboard]]

---

*Lightweight dashboard - focused on what matters*
