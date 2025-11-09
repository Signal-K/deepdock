# Obsidian Vault Workflow Guide

## Welcome to Your Reorganized Vault!

This vault is now organized to support a **dump-and-organize workflow** where you can freely write in sprint files and then organize content later.

---

## 📁 Folder Structure

### `_Inbox/` - Quick Capture
- Drop quick notes here
- Don't worry about organization
- Review and organize weekly

### `_Sprints/` - Sprint Documentation
- **`Active/`** - Current sprint files
- **`Archive/`** - Completed sprints (organized by year)
- **`_Templates/`** - Sprint template files

### `_Tasks/` - Task Views
- **`Current-Sprint.md`** - Tasks from active sprint
- **`All-Tasks.md`** - All incomplete tasks
- **`By-Project.md`** - Tasks grouped by project

### `Projects/` - Main Project Content
- **`Star-Sailors/`** - Web app project
- **`Bumble/`** - React Native farming game
- **`Roving/`** - React Native exploration game
- **`Station-198/`** - Swift iOS app
- **`Shared/`** - Cross-project resources

### `Meta/` - Non-Project Content
- **`Meetings/`** - Meeting notes
- **`Ideas/`** - Brainstorming and ideation
- **`Research/`** - General research
- **`Games/`** - Game design ideas

### `_System/` - System Files (Hidden)
- **`Scripts/`** - Automation scripts
- **`Templates/`** - Note templates

---

## 🔄 Your New Workflow

### 1. Daily Sprint Work

**Open your current sprint file:** `_Sprints/Active/SSG-XXX.md`

**Write freely:**
- Add notes, ideas, observations
- Paste images directly (they auto-save)
- Create tasks with checkboxes: `- [ ] Task name #TAG #TICKET-ID`
- Reference other notes with `[[Note Name]]`
- Don't worry about organization yet!

**Task format:**
```markdown
- [ ] Implement telescope viewport #star-sailors #telescope #TELESCOPE-5
- [ ] Fix bee sprite rendering #bumble #ui #BEE-3
- [ ] Update database schema #station-198 #backend #DB-1
```

### 2. Organize Your Sprint (Weekly or As Needed)

#### Option A: Using Dataview (Recommended)

If you have the Dataview plugin installed:

1. Open `_Tasks/Current-Sprint.md` to see all your tasks automatically
2. Tasks are grouped by project
3. Live updates as you check them off

#### Option B: Using the Python Script

Run the organization script:

```bash
cd content/_System/Scripts
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md
```

This will:
- Extract all tasks
- Identify images
- Suggest file organization
- Generate task summary
- Optionally move images to project folders

### 3. Manage Images

**When you paste images in sprint files:**
- They save to the default Media folder
- Note the image name in the `![[image.png]]` syntax

**To organize images:**
- Run the organize script (it will suggest moves)
- Or manually move to appropriate project Media folder:
  - `Projects/Star-Sailors/Media/Screenshots/`
  - `Projects/Star-Sailors/Media/Physical-Notes/`
  - `Projects/Star-Sailors/Media/Diagrams/`
  - `Projects/Bumble/Media/Screenshots/`
  - `Projects/Bumble/Media/Concept-Art/`
  - etc.

**Image naming convention:**
```
[Project]-[Type]-[Date]-[Description].[ext]

Examples:
SS-Screenshot-20251107-telescope.png
Bumble-Concept-20251107-bee-sprite.jpg
SS-Physical-20251107-ui-sketch.jpg
```

### 4. Create Component/Feature Notes

When you mention a component or feature frequently in a sprint:

1. Create a new note in the appropriate project folder:
   - `Projects/Star-Sailors/Components/ComponentName.md`
   - `Projects/Bumble/Features/FeatureName.md`

2. Add a backlink to the sprint:
```markdown
---
related-sprint: [[SSG-XXX]]
---

# Component Name

[Content extracted from sprint]
```

3. Keep the original content in the sprint file (it's your historical record)

### 5. Track Tasks Across Sprints

**View current sprint tasks:**
- Open `_Tasks/Current-Sprint.md`

**View all tasks:**
- Open `_Tasks/All-Tasks.md`

**View by project:**
- Open `_Tasks/By-Project.md`

**Check specific component:**
- Search for `#component-name` in any task view

---

## 🏷️ Tagging Conventions

### Project Tags
- `#star-sailors` or `#SS` - Star Sailors web app
- `#bumble` or `#BUMBLE` - Bumble minigame
- `#roving` - Roving minigame
- `#station-198` - Station-198 iOS app

### Component Tags
- `#telescope`, `#satellite`, `#rover` - Star Sailors tools
- `#classification` - Classification system
- `#backend`, `#frontend`, `#ui` - Tech areas
- `#bee`, `#crop`, `#soil` - Bumble features

### Ticket IDs
Format: `#COMPONENT-NUMBER`

Examples:
- `#TELESCOPE-5` - Telescope component, ticket 5
- `#DEPLOY-15` - Deployment system, ticket 15
- `#BUG-1` - Bug fix, ticket 1
- `#SOIL-2` - Soil system, ticket 2

### Other Tags
- `#bug` - Bug fixes
- `#research` - Research tasks
- `#tutorial` - Tutorial content
- `#media` - Media/art tasks

---

## 🎯 Sprint Workflow Best Practices

### Start of Sprint

1. Copy sprint template:
```bash
cp content/_Sprints/_Templates/sprint-template.md content/_Sprints/Active/SSG-XXX.md
```

2. Fill in sprint metadata (dates, epic, goals)

3. Start working and dumping everything into the file

### During Sprint

- **Write freely** - Don't self-edit or organize
- **Check off tasks** as you complete them
- **Paste images** directly from screenshots
- **Link to components** when relevant: `[[ComponentName]]`
- **Add daily log entries** for context

### End of Sprint

1. **Review tasks** - Check off final completions
2. **Run organizer** - Move images, extract key notes
3. **Retrospective** - Fill in "what went well" section
4. **Archive** - Move to `_Sprints/Archive/YYYY/`
5. **Create new sprint** from template

---

## 🔧 Tools & Automation

### Obsidian Plugins Recommended

1. **Dataview** - For auto-generating task views
2. **Templater** - For sprint templates
3. **Make.md** - For Spaces organization
4. **Calendar** - For daily notes
5. **Kanban** - Optional, for visual boards

### Python Scripts

**Organize Sprint:**
```bash
python3 content/_System/Scripts/organize_sprint.py content/_Sprints/Active/SSG-XXX.md
```

### Quartz Publishing

Files in `_Inbox/`, `_Sprints/`, `_Tasks/`, and `_System/` are prefixed with underscore, making them easy to exclude from public Quartz site if desired.

To publish only Projects and Meta:
- Configure Quartz to exclude `_*` folders
- Or use `.quartzignore` file

---

## 🌟 Tips for Success

### Keep Sprint Files Complete
- Sprint files are your **historical record**
- Don't delete content when extracting to component notes
- Add backlinks instead: `See also: [[ComponentName]]`

### Use Consistent Tags
- Stick to the tagging conventions
- This makes task views work automatically
- Easy to search and filter

### Regular Reviews
- Review `_Inbox/` weekly
- Archive completed sprints monthly
- Organize images when running organizer script

### Don't Over-Organize
- Let content live in sprint files initially
- Only create separate component notes when needed
- Trust the search and backlinks

### Leverage Dataview
- Task views update automatically
- No manual kanban board management
- Filter by any tag combination

---

## 🆘 Troubleshooting

### "My tasks aren't showing up in task views"
- Check your task format: `- [ ] Task #TAG`
- Ensure you're using correct project tags
- Dataview plugin must be installed and enabled

### "Images not loading"
- Check image reference format: `![[image.png]]`
- Verify image exists in Media folder or project folder
- Use organizer script to find and move images

### "Links are broken"
- Use Obsidian's "Detect all broken links" feature
- When moving files, update links manually
- Consider using Obsidian's automatic link update on move

### "Too many files in inbox"
- Set weekly reminder to organize inbox
- Quick process: tag and move to appropriate project
- Don't aim for perfection, just categorization

---

## 📚 Examples

### Example Sprint File Structure
```markdown
---
tags: [SSG-294, Sprints, star-sailors]
---

# Sprint SSG-294

## Epic 1: Telescope Improvements

### Story 1: Variable Stars

- [ ] Add variable star telescope option #star-sailors #telescope #VARIABLE-1
- [ ] Create variable star tutorial #star-sailors #tutorial #VARIABLE-2

Notes:
Users will calibrate telescope for target size.
Using Gaia project lightcurves.

![[SS-Screenshot-20251107-telescope.png]]

### Daily Log

#### 2025-11-07
Implemented basic variable star detection.
Need to improve UI responsiveness.

![[SS-Physical-20251107-ui-sketch.jpg]]
```

### Example Component Note
```markdown
---
project: star-sailors
type: component
related-sprint: [[SSG-294]]
---

# Telescope Viewport Component

Main viewport for telescope missions.

## Features
- Project selection
- Anomaly display
- Classification interface

## Related Sprints
- [[SSG-290]] - Initial implementation
- [[SSG-294]] - Variable stars addition

## Tasks
See [[../../_Tasks/Current-Sprint|Current Sprint Tasks]]
```

---

## 🚀 Getting Started Checklist

- [ ] Read this guide
- [ ] Install Dataview plugin (optional but recommended)
- [ ] Create your first sprint from template
- [ ] Try the dump-and-organize workflow
- [ ] Run the organize script once
- [ ] Review task views
- [ ] Archive your first completed sprint

---

**Questions or issues?** Document them in `_Inbox/` and organize later! 😊

*Last updated: 2025-11-07*
