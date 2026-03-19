---
title: Main Dashboard
cssclass: tui-dashboard
cssclasses:
  - tui-dashboard
  - table-wrap
  - table-wide
  - table-center
icon: lucide//layout-dashboard
tags:
  - dashboard
  - daily
---

<div class="tui-bar">
  <span class="tui-dot dot-red"></span>
  <span class="tui-dot dot-amber"></span>
  <span class="tui-dot dot-green"></span>
</div>

<pre class="tui-logo">  ____  ____   _____ ___ ____ ___    _    _   _
 / __ )/ __ \ / ___// _ \_  //   |  / |  / | / /
/ __  / / / / \__ \/ // // / / /| | /  | /  |/ /
/ /_/ / /_/ / ___/ / // // /_/ ___ |/ /| |/ /|  /
\____/\____/ /____/____/___/_/  |_/_/ |_/_/ |_/</pre>

## Commands

| Action | Key |
| --- | --- |
| 🔄 Setup Context | `Shift-Command-D` |
| ➕ Add Task | `Shift-Command-T` |
| 🏷️ AutoTag + Route | `Shift-Command-R` |
| 📂 Open Today's File | `Command-O` |

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
name 📂 Open Today's File
type link
action obsidian://open?vault=quartz&file=Journal/Studio/Active/{{date:YYYY-MM-DD}}
class inline
```

> [!tui]- Tasks Queue
> ```dataview
> TASK
> FROM "content"
> WHERE !completed
> SORT choice(lower(default(status, "")) = "todo", 0, choice(regexmatch("^in[ -]?progress$", lower(default(status, ""))), 1, 2)) ASC
> SORT choice(due, due, file.mtime) ASC
> LIMIT 12
> ```

> [!tui]- Calendar
> ```dataviewjs
> const today = window.moment();
> const start = today.clone().startOf("month").startOf("week");
> const end = today.clone().endOf("month").endOf("week");
> let days = [];
> for (let d = start.clone(); d.isSameOrBefore(end, "day"); d.add(1, "day")) days.push(d.clone());
>
> const labels = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
> let html = `<table><thead><tr>${labels.map(x => `<th>${x}</th>`).join("")}</tr></thead><tbody>`;
> for (let i = 0; i < days.length; i += 7) {
>   html += "<tr>";
>   for (const d of days.slice(i, i + 7)) {
>     const isToday = d.isSame(today, "day");
>     const outside = !d.isSame(today, "month");
>     const style = [
>       outside ? "opacity:.35;" : "",
>       isToday ? "color:#8a5cf6;font-weight:700;text-decoration:underline;" : ""
>     ].join("");
>     html += `<td style="text-align:center;${style}">${d.format("D")}</td>`;
>   }
>   html += "</tr>";
> }
> html += "</tbody></table>";
> dv.el("div", html);
> ```

> [!tui]- Recent Files
> ```dataview
> TABLE WITHOUT ID
>   link(file.link, file.path) as "file",
>   file.mtime as "updated"
> FROM "content"
> WHERE file.name != this.file.name
> SORT file.mtime DESC
> LIMIT 8
> ```

<div class="tui-footer">[ one vault. one terminal. zero friction. ]</div>
