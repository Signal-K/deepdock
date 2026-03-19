# Knowns to Production Sync

This sync keeps production tasks aligned with your Knowns boards.

## Files

- Sync script: `.obsidian/scripts/sync-knowns-prod.cjs`
- Config: `knowns-prod-sync.config.json`
- Wrapper: `utilities/sync-knowns-prod.sh`
- Workflow: `.github/workflows/sync-knowns-prod.yml`

## What It Does

For each configured project:

1. Ensures the production project exists (creates or updates name by key).
2. Creates missing tasks from Knowns.
3. Updates existing tagged tasks when title/status/priority changes.
4. Deletes previously synced tasks that were removed from Knowns.

Synced task titles are tagged as:

`[knowns:PROJECT_KEY:TASK_ID] Original title`

This tag is used to detect updates/deletes safely.

## Configuration

Edit `knowns-prod-sync.config.json`:

- `apiBaseUrl`: production API base URL
- `projects[]`:
  - `key`: stable project key in prod
  - `name`: display name in prod
  - `tasksDir`: local `.knowns/tasks` directory
  - or `gitRepo` + `gitRef` + `tasksPath` to pull from GitHub
  - `deleteMissing`: whether missing knowns tasks should be removed from prod

## Run Manually

Dry-run:

```bash
npm run knowns:sync:prod:dry
```

Apply changes:

```bash
npm run knowns:sync:prod
```

Single project:

```bash
node .obsidian/scripts/sync-knowns-prod.cjs --apply --project PLANET_HUNTERS_EXPERIMENT_1
```

## Local Scheduling (macOS/Linux cron)

Run every 30 minutes:

```bash
(crontab -l 2>/dev/null; echo "*/30 * * * * /Users/scroobz/Navigation/quartz/utilities/sync-knowns-prod.sh >> /tmp/knowns-prod-sync.log 2>&1") | crontab -
```

## GitHub Actions Scheduling

Workflow file: `.github/workflows/sync-knowns-prod.yml`

Set these before enabling scheduled sync:

- Repo variable: `KNOWNS_SYNC_API_BASE_URL` (optional override)
- Repo secret: `KNOWNS_SYNC_GITHUB_TOKEN` (required for private `gitRepo` sources)

Then use scheduled runs or `workflow_dispatch`.
