---
title: Tasks by Project
cssclass: dashboard
---

# Tasks by Project

> [!info] Project-Based View
> All tasks organized by which project they belong to.

## Project Overview

```dataview
TABLE WITHOUT ID
	Project,
	Incomplete,
	Complete,
	Total
FROM "_Sprints"
FLATTEN file.tasks as task
WHERE task
FLATTEN 
	choice(
		contains(task.text, "#star-sailors") OR contains(task.text, "#SS") OR contains(task.text, "#telescope"), 
		"Star Sailors",
		choice(
			contains(task.text, "#bumble") OR contains(task.text, "#BUMBLE"),
			"Bumble",
			choice(
				contains(task.text, "#roving"),
				"Roving",
				choice(
					contains(task.text, "#station"),
					"Station-198",
					"Other"
				)
			)
		)
	) as Project
GROUP BY Project
FLATTEN length(filter(rows.task, (t) => !t.completed)) as Incomplete
FLATTEN length(filter(rows.task, (t) => t.completed)) as Complete
FLATTEN length(rows.task) as Total
SORT Project ASC
```

## Star Sailors

### Current Sprint

```dataview
TASK
FROM "_Sprints/Active"
WHERE !completed
AND (
	contains(text, "#star-sailors") OR 
	contains(text, "#SS") OR 
	contains(text, "#telescope") OR 
	contains(text, "#satellite") OR 
	contains(text, "#rover") OR
	contains(text, "#classification") OR
	contains(text, "#TELESCOPE") OR
	contains(text, "#SATELLITE") OR
	contains(text, "#ROVER")
)
```

### All Sprints

```dataview
TASK
FROM "_Sprints"
WHERE !completed
AND (
	contains(text, "#star-sailors") OR 
	contains(text, "#SS") OR 
	contains(text, "#telescope") OR 
	contains(text, "#satellite") OR 
	contains(text, "#rover") OR
	contains(text, "#classification")
)
LIMIT 50
```

## Bumble

### Current Sprint

```dataview
TASK
FROM "_Sprints/Active"
WHERE !completed
AND (
	contains(text, "#bumble") OR 
	contains(text, "#BUMBLE") OR 
	contains(text, "#bee") OR
	contains(text, "#SOIL")
)
```

### All Sprints

```dataview
TASK
FROM "_Sprints"
WHERE !completed
AND (
	contains(text, "#bumble") OR 
	contains(text, "#BUMBLE") OR 
	contains(text, "#bee")
)
LIMIT 50
```

## Roving

```dataview
TASK
FROM "_Sprints"
WHERE !completed
AND contains(text, "#roving")
```

## Station-198

### Current Sprint

```dataview
TASK
FROM "_Sprints/Active"
WHERE !completed
AND contains(text, "#station")
```

### All Sprints

```dataview
TASK
FROM "_Sprints"
WHERE !completed
AND contains(text, "#station")
LIMIT 50
```

## Shared/Infrastructure

```dataview
TASK
FROM "_Sprints"
WHERE !completed
AND (
	contains(text, "#backend") OR
	contains(text, "#infrastructure") OR
	contains(text, "#database") OR
	contains(text, "#api")
)
AND !contains(text, "#star-sailors")
AND !contains(text, "#bumble")
AND !contains(text, "#station")
LIMIT 50
```

---

## Related

- [[Current-Sprint|Current Sprint Tasks]]
- [[All-Tasks|All Tasks]]
- [[../Projects/Star-Sailors/index|Star Sailors Project]]
- [[../Projects/Bumble/index|Bumble Project]]
- [[../Projects/Station-198/index|Station-198 Project]]
