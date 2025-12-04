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
FROM "content/_Tasks/Projects"
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
FROM "content/_Tasks/Projects"
WHERE file.name = "star-sailors"
AND !completed
```

### All Tasks

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "star-sailors"
AND !completed
LIMIT 50
```

## Bumble

### Current Sprint

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "bumble"
AND !completed
```

### All Tasks

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "bumble"
AND !completed
LIMIT 50
```

## Roving

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "roving"
AND !completed
```

## Station-198

### Current Sprint

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "station-198"
AND !completed
```

### All Tasks

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "station-198"
AND !completed
LIMIT 50
```

## Shared/Infrastructure

```dataview
TASK
FROM "content/_Tasks/Projects"
WHERE file.name = "general"
AND !completed
LIMIT 50
```

---

## Related

- [[Current-Sprint|Current Sprint Tasks]]
- [[All-Tasks|All Tasks]]
- [[../Projects/Star-Sailors/index|Star Sailors Project]]
- [[../Projects/Bumble/index|Bumble Project]]
- [[../Projects/Station-198/index|Station-198 Project]]
