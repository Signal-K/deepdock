---
title: All Tasks
cssclass: dashboard
sticker: emoji//1f3ab
icon: lucide//list-checks
---

# All Tasks

> [!info] Master Task View
> Shows all tasks from all projects, segments, and sprints.

## Summary Stats

> [!summary] Quick Stats
> ```dataviewjs
> const pages = dv.pages("").where(p => p.file.tasks && p.file.tasks.length);
> const tasks = [];
> pages.forEach(p => p.file.tasks.forEach(t => tasks.push({ task: t, path: p.file.path, type: (p.type ?? "") })));
>
> const isIncomplete = (x) => !x.task.checked && !x.task.completed && x.task.completion == null && !/DONE|CANCELLED/.test((x.task.status ?? ""));
> const isComplete = (x) => x.task.checked || x.task.completed || x.task.completion != null || /DONE|CANCELLED/.test((x.task.status ?? ""));
>
> const star = tasks.filter(x => x.path.includes("content/_Tasks/Projects/Star-Sailors/Star-Sailors"));
> const stories = tasks.filter(x => x.type === "story");
> const other = tasks.filter(x => !x.path.includes("content/_Tasks/Projects/Star-Sailors/Star-Sailors") && x.type !== "story");
>
> const stats = (group) => [group.length, group.filter(isIncomplete).length, group.filter(isComplete).length];
>
> // Inject scoped styles using provided theme (light/dark)
> const style = `
> .qs-table { width: 100%; border-collapse: collapse; }
> .qs-table thead th { padding: 10px; text-align: left; letter-spacing: 0.02em; background: var(--qs-primary) !important; color: var(--qs-header-fg) !important; border: 1px solid var(--qs-border) !important; }
> .qs-table tbody td { padding: 10px; background: var(--qs-body-bg) !important; color: var(--qs-body-fg) !important; border: 1px solid var(--qs-border) !important; }
> .qs-table tbody tr:nth-child(even) td { background: var(--qs-zebra-bg) !important; }
> .qs-table tbody tr:hover td { background: var(--qs-hover-bg) !important; }
> .qs-group { font-weight: 600; }
> .qs-card { border-radius: 10px; border: 1px solid var(--qs-border); overflow: hidden; background: var(--qs-card-bg); color: var(--qs-card-fg); }
> `;
> const styleEl = document.createElement('style');
> styleEl.textContent = style;
> dv.container.appendChild(styleEl);
>
> // Build card and table with theme colors
> const card = document.createElement('div');
> card.className = 'qs-card';
>
> // Resolve palette using prefers-color-scheme and provided theme
> const isDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
> const palette = isDark ? {
>   background: '#2E2E2E',
>   text: '#D9D9D9',
>   card: '#383838',
>   cardForeground: '#E0E0E0',
>   primary: '#7DD3FC',
>   primaryForeground: '#FAFAFA',
>   secondary: '#474747',
>   muted: '#404040',
>   border: '#474747'
> } : {
>   background: '#FCFCFC',
>   text: '#4D4D4D',
>   card: '#FFFFFF',
>   cardForeground: '#404040',
>   primary: '#7DD3FC',
>   primaryForeground: '#FFFFFF',
>   secondary: '#F2F2F5',
>   muted: '#F8F8F8',
>   border: '#F2F2F2'
> };
>
> // Set scoped CSS variables on the card
> card.style.setProperty('--qs-primary', palette.primary);
> card.style.setProperty('--qs-header-fg', palette.primaryForeground);
> card.style.setProperty('--qs-body-bg', palette.background);
> card.style.setProperty('--qs-body-fg', palette.text);
> card.style.setProperty('--qs-zebra-bg', palette.secondary);
> card.style.setProperty('--qs-hover-bg', palette.muted);
> card.style.setProperty('--qs-border', palette.border);
> card.style.setProperty('--qs-card-bg', palette.card);
> card.style.setProperty('--qs-card-fg', palette.cardForeground);
>
> const table = document.createElement('table');
> table.className = 'qs-table';
>
> const thead = document.createElement('thead');
> const trh = document.createElement('tr');
> ["Group", "Total", "Incomplete", "Complete"].forEach(h => { const th = document.createElement('th'); th.textContent = h; trh.appendChild(th); });
> thead.appendChild(trh);
> table.appendChild(thead);
>
> const tbody = document.createElement('tbody');
> const makeRow = (label, group) => {
>   const [total, inc, comp] = stats(group);
>   const tr = document.createElement('tr');
>   [label, total, inc, comp].forEach((val, i) => { const td = document.createElement('td'); td.textContent = String(val); if (i === 0) td.className = 'qs-group'; tr.appendChild(td); });
>   return tr;
> };
> tbody.appendChild(makeRow('Star-Sailors', star));
> tbody.appendChild(makeRow('Stories', stories));
> tbody.appendChild(makeRow('Other', other));
> table.appendChild(tbody);
>
> card.appendChild(table);
> dv.container.appendChild(card);
> ```

```dataview
TABLE WITHOUT ID
	length(rows) as "Total",
	length(filter(rows, (r) => !(r.task.checked) and !(r.task.completed) and (r.task.completion = null) and !regexmatch("DONE|CANCELLED", default(r.task.status, "")))) as "Incomplete",
	length(filter(rows, (r) => (r.task.checked) or (r.task.completed) or (r.task.completion != null) or regexmatch("DONE|CANCELLED", default(r.task.status, "")))) as "Complete"
FROM ""
WHERE file.tasks
FLATTEN file.tasks as task
GROUP BY true
```

## Incomplete Tasks

### Incomplete — Star-Sailors
```dataview
TASK
FROM "content/_Tasks/Projects/Star-Sailors/Star-Sailors/V2.1-and-Ph/Post-PH launch wrapup.md"
WHERE !checked AND !completed AND completion = null AND !regexmatch("DONE|CANCELLED", default(status, ""))
SORT file.name DESC
```

### Incomplete — Stories
```dataview
TASK
FROM ""
WHERE !checked AND !completed AND completion = null AND !regexmatch("DONE|CANCELLED", default(status, "")) AND default(type, "") = "story"
SORT file.name DESC
```

### Incomplete — Other
```dataview
TASK
FROM ""
WHERE !checked AND !completed AND completion = null AND !regexmatch("DONE|CANCELLED", default(status, "")) AND !contains(file.path, "content/_Tasks/Projects/Star-Sailors/Star-Sailors") AND default(type, "") != "story"
SORT file.name DESC
```

## Completed Tasks

### Complete — Star-Sailors
```dataview
TASK
FROM "content/_Tasks/Projects/Star-Sailors/Star-Sailors"
WHERE checked OR completed OR completion != null OR regexmatch("DONE|CANCELLED", default(status, ""))
SORT completion DESC
```

### Complete — Stories
```dataview
TASK
FROM ""
WHERE (checked OR completed OR completion != null OR regexmatch("DONE|CANCELLED", default(status, ""))) AND default(type, "") = "story"
SORT completion DESC
```

### Complete — Other
```dataview
TASK
FROM ""
WHERE (checked OR completed OR completion != null OR regexmatch("DONE|CANCELLED", default(status, ""))) AND !contains(file.path, "content/_Tasks/Projects/Star-Sailors/Star-Sailors") AND default(type, "") != "story"
SORT completion DESC
```

---

*All tasks from across the entire vault*

## Navigation
- [[content/Categories/_Index|Categories Index]]
- [[content/Categories/Tasks/index|Tasks Index]]
- [[content/Categories/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web/index.md|Tasks - Star-Sailors-Ecosystem/Star-Sailors-Web Index]]
