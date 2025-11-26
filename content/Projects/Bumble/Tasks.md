---
sticker: lucide//building-2
---
# Bumble Tasks

Project: [[index|Bumble]]

## 🔥 High Priority

> Tasks marked as urgent or high priority

```dataview
TASK
WHERE file = this.file
  AND !completed
  AND (contains(text, "🔥") OR contains(text, "⚡"))
SORT text ASC
```

## 📋 Active Tasks

> All incomplete tasks for this project

```dataview
TASK
WHERE file = this.file
  AND !completed
SORT text ASC
```

## ✅ Recently Completed

> Last 10 completed tasks

```dataview
TASK
WHERE file = this.file
  AND completed
SORT completion DESC
LIMIT 10
```

---

## Tasks

*(Tasks will be added here by vault organize-daily)*
