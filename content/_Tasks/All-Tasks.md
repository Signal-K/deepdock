---
title: All Tasks
cssclass: dashboard
---

# All Tasks

> [!info] Master Task View
> Shows all tasks from all projects, segments, and sprints.

## Summary Stats

```dataview
TABLE WITHOUT ID
	length(file.tasks) as "Total",
	length(filter(file.tasks, (t) => !t.completed)) as "Incomplete",
	length(filter(file.tasks, (t) => t.completed)) as "Complete"
FROM ""
WHERE file.tasks
FLATTEN file.tasks as task
GROUP BY true
```

## Incomplete Tasks

```dataview
TASK
FROM ""
WHERE !completed
SORT file.name DESC
```

## Completed Tasks

```dataview
TASK
FROM ""
WHERE completed
SORT completion DESC
```

---

*All tasks from across the entire vault*
