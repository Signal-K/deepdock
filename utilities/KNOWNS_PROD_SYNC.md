# Knowns -> Production Sync

This sync keeps production projects/tasks aligned with `.knowns/tasks` boards.

## Config

Edit `knowns-prod-sync.config.json`.

Each project supports:

- `name`: Production project display name
- `key`: Production project key
- `tasksDir`: Local path to `.knowns/tasks`
- `deleteMissing`: If `true`, prod tasks tagged from Knowns but no longer present are deleted

Example:

```json
{
  "apiBaseUrl": "https://tui-hj07ggwpf-signal-k.vercel.app",
  "projects": [
    {
      "name": "Planet Hunters Experiment 1",
      "key": "PH_EXPERIMENT_1",
      "tasksDir": "/Users/scroobz/Navigation/Native/planet-hunters-experiment-1/.knowns/tasks",
      "deleteMissing": true
    }
  ]
}
```

You can also source from GitHub instead of a local `tasksDir`:

```json
{
  "name": "My Repo",
  "key": "MY_REPO",
  "gitRepo": "org/repo",
  "gitRef": "main",
  "tasksPath": ".knowns/tasks"
}
```

For private repos, set `GITHUB_TOKEN`.

If your Vercel deployment is protected, also set:

- `VERCEL_PROTECTION_BYPASS` (deployment protection bypass token)

## Commands

- Dry-run: `npm run knowns:sync:prod:dry`
- Apply: `npm run knowns:sync:prod`
- Single project: `npm run knowns:sync:prod -- --project PH_EXPERIMENT_1`
- Direct Supabase dry-run: `npm run knowns:sync:supabase:dry`
- Direct Supabase apply: `npm run knowns:sync:supabase`

## Sync behavior

- Ensures projects exist in production (`/api/projects`)
- Creates tasks not in prod
- Updates tasks when title/status/priority changed
- Deletes previously synced Knowns tasks that were removed locally (unless `--no-delete` or `deleteMissing: false`)

Knowns tasks are tagged in prod titles as:

`[knowns:PROJECT_KEY:TASK_ID] Original title`
