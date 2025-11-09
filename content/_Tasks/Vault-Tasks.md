# Vault Organization Tasks

Tasks related to Obsidian vault setup, organization, and automation

## 🔥 High Priority

```dataview
TASK
WHERE file = this.file
  AND !completed
  AND (contains(text, "🔥") OR contains(text, "⚡"))
SORT text ASC
```

## 📋 Active Tasks

```dataview
TASK
WHERE file = this.file
  AND !completed
SORT text ASC
```

## ✅ Recently Completed

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
