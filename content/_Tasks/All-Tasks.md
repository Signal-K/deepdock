---
title: All Tasks
cssclass: dashboard
---

# All Tasks Across Sprints

> [!info] Master Task View
> Shows all incomplete tasks from all sprints (active and archived).

## Summary Stats

```dataview
TABLE WITHOUT ID
	length(file.tasks) as "Total",
	length(filter(file.tasks, (t) => !t.completed)) as "Incomplete",
	length(filter(file.tasks, (t) => t.completed)) as "Complete"
FROM "_Sprints"
WHERE file.tasks
FLATTEN file.tasks as task
GROUP BY true
```

## Incomplete Tasks by Sprint

```dataview
TABLE WITHOUT ID
	file.link as "Sprint",
	length(filter(file.tasks, (t) => !t.completed)) as "Open Tasks",
	length(filter(file.tasks, (t) => t.completed)) as "Done",
	round((length(filter(file.tasks, (t) => t.completed)) / length(file.tasks)) * 100, 1) + "%" as "Progress"
FROM "_Sprints"
WHERE file.tasks AND length(filter(file.tasks, (t) => !t.completed)) > 0
SORT file.mtime DESC
```

## All Incomplete Tasks

### High Priority (with ticket IDs)

```dataview
TASK
FROM "_Sprints"
WHERE !completed
AND contains(text, "#")
AND (contains(text, "-1") OR contains(text, "-2") OR contains(text, "-3"))
SORT file.name DESC
LIMIT 50
```

### All Other Incomplete

```dataview
TASK
FROM "_Sprints"
WHERE !completed
SORT file.name DESC
LIMIT 100
```

## Tasks by Component

### Telescope

```dataview
TASK
FROM "_Sprints"
WHERE !completed AND contains(text, "#telescope")
SORT file.name DESC
```

### Satellite

```dataview
TASK
FROM "_Sprints"
WHERE !completed AND contains(text, "#satellite")
SORT file.name DESC
```

### Rover

```dataview
TASK
FROM "_Sprints"
WHERE !completed AND contains(text, "#rover")
SORT file.name DESC
```

### Backend

```dataview
TASK
FROM "_Sprints"
WHERE !completed AND contains(text, "#backend")
SORT file.name DESC
```

### UI/Frontend

```dataview
TASK
FROM "_Sprints"
WHERE !completed AND (contains(text, "#ui") OR contains(text, "#frontend") OR contains(text, "#layout"))
SORT file.name DESC
```

### Bugs

```dataview
TASK
FROM "_Sprints"
WHERE !completed AND (contains(text, "#bug") OR contains(text, "#BUG"))
SORT file.name DESC
```

---

*Tasks shown: Most recent 100 incomplete tasks*

*Use filters above to find specific components or ticket types*
