# Knowns Dashboard

Go browser frontend for the local `.knowns/tasks/*.md` files across the Star Sailors repos.

## Run

From the Quartz repo:

```bash
docker compose up -d dashboard-api
```

Then open:

```text
http://localhost:3737
```

## What It Does

- Reads project paths from `~/.vim/quartz-projects.json`.
- Shows only projects with `parent: "Star Sailors"`.
- Lists active Knowns Markdown tasks across those projects.
- Prioritizes the current MVP reset task IDs in the Today / This Week / AI / Me buckets.
- Opens a task as a browser task page, with frontmatter exposed as editable properties.
- Saves the edited properties and Markdown body back to the local task file.
- Can mark a task `in-progress` or `done`.

## Why Local/Docker First

The editor writes directly to local Markdown files. A hosted Vercel frontend cannot safely edit files on this machine unless a separate sync bridge exists.

If this becomes hosted later, use one of these patterns:

- Local sync agent: local Go service watches files and talks to a hosted frontend/API.
- Git-backed workflow: hosted frontend edits a branch/PR instead of the local working tree.
- PocketBase bridge: local agent syncs Knowns files to a hosted PocketBase instance and writes changes back locally.

Do not make Vercel the direct source of truth for local Knowns files.
