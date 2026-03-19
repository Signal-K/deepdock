---
icon: lucide//workflow
---

# Vault Documentation

Complete guide to the reorganized Quartz vault structure, workflows, and automation.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Folder Structure](#folder-structure)
3. [Daily Workflow](#daily-workflow)
4. [Sprint Management](#sprint-management)
5. [Task Management](#task-management)
6. [Project Organization](#project-organization)
7. [Quartz Publishing](#quartz-publishing)
8. [Automation Scripts](#automation-scripts)

---

## Quick Start

### New here? Start with these steps:

1. **Capture ideas** → Drop notes in `content/_Inbox/`
2. **Work on sprints** → Edit `content/_Sprints/Active/[sprint-name].md`
3. **Check tasks** → View `content/_Tasks/Current-Sprint.md`
4. **Organize weekly** → Run organize script on sprint files
5. **Publish** → Run `npx quartz build` to publish public content

### Essential Commands

```bash
# Create new sprint
cd content/_System/Scripts && ./quick-start.sh

# Organize sprint content
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md

# Build and serve Quartz
npx quartz build && npx quartz serve
```

---

## Folder Structure

```
content/
├── _Inbox/              # Quick capture (private)
├── _Sprints/            # Sprint documentation (private)
│   ├── Active/          # Current sprints
│   └── Archive/         # Completed sprints
├── _Tasks/              # Task management (private)
│   ├── Projects/        # Project-specific tasks and docs
│   ├── Current-Sprint.md
│   └── All-Tasks.md
├── _System/             # Scripts and templates (private)
├── Physical-Notes/      # Scanned physical notes (public)
├── Backend/             # Backend documentation (public)
├── Components/          # Reusable components (public)
├── Ideas/               # Brainstorming (public)
├── Meetings/            # Meeting notes (public)
└── Research/            # Research notes (public)
```

**Privacy Rule:** Folders prefixed with `_` are private and excluded from Quartz publishing.

---

## Daily Workflow

### 1. Morning - Check Current Work

```bash
# Open current sprint
open content/_Sprints/Active/[current-sprint].md

# Check today's tasks
open content/_Tasks/Current-Sprint.md
```

### 2. During Day - Capture Everything

- **Quick notes** → `_Inbox/` (organize later)
- **Sprint work** → Write directly in sprint files
- **Physical notes** → Take photos, paste in `Physical-Notes/`

### 3. End of Day - Light Organization

- Check off completed tasks
- Add new tasks discovered during work
- Quick review of inbox

### 4. Weekly Review

```bash
# Run organization script
cd content/_System/Scripts
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md

# Review and clear inbox
# Archive completed sprint if done
```

---

## Sprint Management

### Sprint File Structure

Each sprint file (`_Sprints/Active/SSG-XXX.md`) contains:

```markdown
---
sprint: SSG-XXX
status: active
start: YYYY-MM-DD
end: YYYY-MM-DD
---

# Sprint SSG-XXX

## Goals
- Main objective 1
- Main objective 2

## Tasks
- [ ] Task 1 #project-name
- [ ] Task 2 #project-name

## Components
### ComponentName
Description and notes about component...

## Research
### Topic
Research notes...
```

### Sprint Lifecycle

1. **Create sprint** → Use template or quick-start script
2. **Work daily** → Write freely in sprint file
3. **Organize weekly** → Run `organize_sprint.py`
4. **Complete sprint** → Move to `_Sprints/Archive/YYYY/`

---

## Task Management

### Task Views

- **`Current-Sprint.md`** - Tasks from active sprint only
- **`All-Tasks.md`** - All incomplete tasks across vault
- **`By-Project.md`** - Tasks grouped by project

### Task Syntax

```markdown
- [ ] Task description #project-name #tag
```

**Project tags:**
- `#star-sailors` - Web app
- `#bumble` - React Native farming game
- `#godot-mars` - Godot game
- `#station-198` - iOS app
- `#roving` - Exploration game

### Organizing Tasks

Tasks automatically organize into project directories when you run `organize_sprint.py`:

```bash
cd content/_System/Scripts
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md
```

This extracts:
- Components → `Projects/Projects/[project]/Components/`
- Features → `Projects/Projects/[project]/Features/`
- Research → `Projects/Projects/[project]/Research/`
- Tasks → Project task files

---

## Project Organization

### Project Structure

Each project in `Projects/Projects/` follows this structure:

```
_Tasks/Projects/ProjectName/
├── Components/         # Component documentation
├── Features/          # Feature specifications
├── Mechanics/         # Game mechanics (for games)
├── Research/          # Technical research
├── Media/            # Screenshots, diagrams, etc.
│   ├── Screenshots/
│   ├── Physical-Notes/
│   └── Diagrams/
├── index.md          # Project overview
└── Tasks.md          # Project task list
```

### Current Projects

- **Godot-Mars** - Mars exploration game
- **Star-Sailors** - Web citizen science platform
- **Bumble** - React Native pollinator farming game
- **Station-198** - iOS subscription app
- **Roving** - Exploration game
- **Shared** - Cross-project resources

---

## Physical Notes System

### Workflow

1. **Take photos** of physical notes
2. **Create daily note** → `Physical-Notes/YYYY-MM-DD.md`
3. **Paste images** into Physical-Notes directory
4. **Images auto-renamed** to `YYYY-MM-DD-01.png`, etc.
5. **Transcribe key points** in the markdown file
6. **Extract decisions** → Create project documentation
7. **Extract tasks** → Add to project task files

### Note Structure

```markdown
---
title: Physical Notes - Date
date: YYYY-MM-DD
tags:
  - physical-notes
  - project-name
  - design-decision
projects:
  - ProjectName
---

# Date - Topic

![[YYYY-MM-DD-01.png]]

## Key Takeaways
- Decision 1
- Design element 2

## Generated Tasks
- [ ] Task from notes

**Related:** [[../_Tasks/Projects/ProjectName/document]]
```

---

## Quartz Publishing

### What Gets Published

**Public (published):**
- Everything not starting with `_`
- Physical-Notes/
- Components/
- Research/
- Ideas/
- Meetings/

**Private (hidden):**
- _Inbox/
- _Sprints/
- _Tasks/
- _System/

### Build Commands

```bash
# Build static site
npx quartz build

# Serve locally
npx quartz serve

# Build and serve
npx quartz build && npx quartz serve
```

### Configuration

Quartz ignores private folders via `.quartzignore`:

```
content/_Inbox
content/_Sprints
content/_Tasks
content/_System
```

---

## Automation Scripts

### Location

All scripts in `content/_System/Scripts/`

### Available Scripts

#### 1. `quick-start.sh`
Creates new sprint file from template.

```bash
cd content/_System/Scripts
./quick-start.sh
# Follow prompts for sprint name and dates
```

#### 2. `organize_sprint.py`
Extracts and organizes content from sprint files.

```bash
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md
```

**What it does:**
- Extracts components to project folders
- Organizes features by project
- Moves research notes
- Updates task lists
- Creates proper file structure

#### 3. `create-task-shortcut.sh`
Creates shortcuts for task management.

```bash
./create-task-shortcut.sh
```

### Script Tags

Scripts recognize these tags for organization:

- `#star-sailors`, `#bumble`, `#roving`, `#station-198`, `#godot-mars`
- `#component`, `#feature`, `#research`
- `#backend`, `#frontend`, `#database`

---

## Tag System

### Project Tags
- `#star-sailors` - Main web app
- `#bumble` - Farming game
- `#godot-mars` - Mars game
- `#station-198` - iOS app
- `#roving` - Exploration game

### Content Type Tags
- `#component` - Reusable component
- `#feature` - Feature specification
- `#research` - Research notes
- `#design-decision` - Design choice documentation
- `#physical-notes` - Scanned physical notes

### Status Tags
- `#task` - Actionable task
- `#wip` - Work in progress
- `#blocked` - Blocked task
- `#done` - Completed

### Domain Tags
- `#backend`, `#frontend`, `#database`
- `#api`, `#ui`, `#testing`
- `#mechanics`, `#narrative`, `#art`

---

## Best Practices

### 1. Dump First, Organize Later
- Write freely in sprint files during work
- Don't worry about perfect organization during flow state
- Use weekly organization script to clean up

### 2. Use Tags Consistently
- Tag tasks with project names
- Tag content with type tags
- Makes automation work better

### 3. Link Everything
- Link tasks to components
- Link components to research
- Link physical notes to project docs
- Creates knowledge graph

### 4. Weekly Reviews
- Review inbox and organize
- Run organize script on sprint files
- Archive completed sprints
- Update task lists

### 5. Physical Notes
- Take photos regularly
- Transcribe same day while fresh
- Extract decisions immediately
- Link to affected project areas

---

## Troubleshooting

### "Script won't run"
```bash
# Make executable
chmod +x content/_System/Scripts/*.sh

# Check Python
python3 --version
```

### "Links broken after organization"
- Organization script updates internal links
- Check relative paths in markdown
- Use `[[filename]]` not `[[path/to/filename]]` when possible

### "Quartz not building"
```bash
# Clean build
rm -rf .quartz-cache
npx quartz build

# Check for syntax errors in markdown
```

### "Tasks not showing in views"
- Check task syntax: `- [ ] Task #project`
- Ensure proper spacing after checkbox
- Verify project tag is recognized

---

## Quick Reference

### Daily Commands
```bash
# Open current sprint
open content/_Sprints/Active/[sprint].md

# Check tasks
open content/_Tasks/Current-Sprint.md

# Build Quartz
npx quartz build && npx quartz serve
```

### Weekly Commands
```bash
# Organize sprint
cd content/_System/Scripts
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md

# Archive completed sprint
mv content/_Sprints/Active/SSG-XXX.md content/_Sprints/Archive/2025/
```

### File Locations
- Sprint files: `content/_Sprints/Active/`
- Task views: `content/_Tasks/`
- Project docs: `content/_Tasks/Projects/`
- Physical notes: `content/Physical-Notes/`
- Scripts: `content/_System/Scripts/`

---

## Summary

This vault is designed for:
- **Fast capture** during work sessions
- **Flexible organization** when you have time
- **Multi-project management** with clear separation
- **Public/private control** for Quartz publishing
- **Automation** to reduce manual organization

The key principle: **Write freely, organize later, automate everything possible.**

## Routed Notes
- [[Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Star-Sailors-Web/Captured-Notes/VAULT_DOCUMENTATION.md|Routed: Star-Sailors-Web Docs Capture]]
- [[Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Star-Sailors-Web/Captured-Tasks/VAULT_DOCUMENTATION.md|Routed: Star-Sailors-Web Tasks Capture]]
- [[Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Bumble/Captured-Notes/VAULT_DOCUMENTATION.md|Routed: Bumble Docs Capture]]
- [[Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Bumble/Captured-Tasks/VAULT_DOCUMENTATION.md|Routed: Bumble Tasks Capture]]
- [[Projects/Projects/Star-Sailors/Docs/Star-Sailors-Ecosystem/Godot-Mars-Archive/Captured-Notes/VAULT_DOCUMENTATION.md|Routed: Godot-Mars-Archive Docs Capture]]
- [[Projects/Projects/Star-Sailors/Tasks/Star-Sailors-Ecosystem/Godot-Mars-Archive/Captured-Tasks/VAULT_DOCUMENTATION.md|Routed: Godot-Mars-Archive Tasks Capture]]
