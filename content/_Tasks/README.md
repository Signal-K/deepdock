# Task Management System

This folder contains auto-generated task views that aggregate tasks from sprint files.

## Files

- **Current-Sprint.md** - All tasks from the active sprint
- **All-Tasks.md** - All incomplete tasks across all sprints
- **By-Project.md** - Tasks organized by project

## Task Format

Use this format in sprint files:

```markdown
- [ ] Task description #PROJECT #COMPONENT #TICKET-ID
```

### Tag Conventions

**Projects:**
- `#star-sailors` or `#SS`
- `#bumble`
- `#roving`
- `#station-198`

**Components/Areas:**
- `#telescope`
- `#satellite`
- `#rover`
- `#classification`
- `#backend`
- `#ui`
- etc.

**Ticket IDs:**
- Format: `#COMPONENT-NUMBER`
- Examples: `#TELESCOPE-5`, `#DEPLOY-15`, `#BUG-1`

## How It Works

1. Write tasks in your sprint file
2. Task views automatically update (using Dataview or manual scripts)
3. When task is completed, check it off in sprint file
4. Task disappears from "incomplete" views but remains in sprint history

## Benefits

- Single source of truth (sprint files)
- No broken links when reorganizing
- Easy to see all tasks across sprints
- Tasks maintain context (which sprint they came from)
- Kanban-like views without separate board files

---

*This folder's contents can be published to Quartz if you want to share your roadmap.*
