# Obsidian Vault Reorganization Plan

## Executive Summary

This document outlines the comprehensive reorganization of your Obsidian vault to support a dump-and-organize workflow for multiple projects while maintaining Quartz compatibility.

## Current Issues Identified

1. **Media scattered everywhere** - Images in root Media folder with no project organization
2. **Mixed project content** - Components, Backend, etc. folders contain notes from multiple projects without clear segmentation
3. **Kanban limitations** - Can't maintain sprint-based task tracking without breaking references
4. **No automated organization** - Everything dumped into sprint files with manual organization required

## Projects Identified

1. **Star Sailors (Web)** - Main web application
2. **Bumble** - React Native farming/pollinator minigame
3. **Roving** - React Native exploration minigame (mentioned but limited content)
4. **Station-198** - Swift/RN standalone application
5. **General/Meta** - Documentation, meetings, research not tied to specific projects

## Proposed New Structure

```
content/
├── _Inbox/                          # Dump zone for quick notes
│   └── README.md                    # Instructions for inbox
│
├── _Sprints/                        # All sprint files (current + archive)
│   ├── Active/
│   │   └── SSG-XXX.md              # Current sprint
│   ├── Archive/
│   │   ├── 2024/
│   │   └── 2025/
│   └── _Templates/
│       └── sprint-template.md
│
├── _Tasks/                          # Task tracking system
│   ├── Current-Sprint.md           # Auto-generated from active sprint
│   ├── All-Tasks.md                # Master task view
│   └── By-Project.md               # Tasks grouped by project
│
├── Projects/
│   ├── Star-Sailors/
│   │   ├── index.md
│   │   ├── Components/
│   │   ├── Features/
│   │   ├── Backend/
│   │   ├── Viewports/
│   │   ├── Classifications/
│   │   ├── Missions/
│   │   ├── Research/
│   │   └── Media/
│   │       ├── Screenshots/
│   │       ├── Diagrams/
│   │       └── Physical-Notes/
│   │
│   ├── Bumble/
│   │   ├── index.md
│   │   ├── Components/
│   │   ├── Features/
│   │   ├── Mechanics/
│   │   └── Media/
│   │       ├── Screenshots/
│   │       ├── Concept-Art/
│   │       └── Physical-Notes/
│   │
│   ├── Roving/
│   │   ├── index.md
│   │   └── Media/
│   │
│   ├── Station-198/
│   │   ├── index.md
│   │   ├── Database-Structure.md
│   │   ├── Pages/
│   │   ├── Subscriptions/
│   │   └── Media/
│   │
│   └── Shared/                     # Cross-project resources
│       ├── Components/
│       ├── Backend/
│       ├── Infrastructure/
│       └── Media/
│
├── Meta/                           # Non-project content
│   ├── Meetings/
│   ├── Ideas/
│   ├── Research/
│   └── Games/                      # Game design ideas
│
└── _System/                        # System files (hidden from Quartz)
    ├── Scripts/
    ├── Templates/
    └── Configuration/
```

## New Workflow

### Daily Workflow

1. **Dump Everything into Sprint File** - Write freely in `_Sprints/Active/SSG-XXX.md`
   - Add tasks with standard markdown checkboxes: `- [ ] Task name #TAG`
   - Paste images directly (they auto-save to attachment folder)
   - Reference components, features, etc. with `[[Component Name]]`
   - Add physical notes as photos

2. **Press Organization Button** (Script/Command)
   - Extracts all tasks and updates `_Tasks/Current-Sprint.md`
   - Identifies image references and prompts for organization
   - Suggests which notes should be broken out into component/feature files
   - Creates backlinks to sprint in all extracted content

3. **Review & Confirm**
   - Approve suggested file movements
   - Images moved to appropriate project Media folders
   - Component notes created/updated with sprint references
   - Tasks appear in task views automatically

## Task Management System

### Task Format
```markdown
- [ ] Task description #PROJECT #COMPONENT #TICKET-ID
```

### Current Sprint View (`_Tasks/Current-Sprint.md`)
Auto-generated file showing:
- All tasks from current sprint file
- Grouped by project
- Shows completion status
- Links back to sprint file and related notes

### Master Task View (`_Tasks/All-Tasks.md`)
- All incomplete tasks across all sprints
- Filterable by project/component
- Shows which sprint each task belongs to

### Project Task View (`_Tasks/By-Project.md`)
- Tasks grouped by project
- Shows sprint context
- Links to related components

## Media Organization

### Image Naming Convention
```
[Project]-[Type]-[Date]-[Description].[ext]

Examples:
SS-Screenshot-20251107-telescope-viewport.png
Bumble-Concept-20251107-bee-sprite.jpg
SS-Physical-20251107-ui-sketch.jpg
```

### Media Folder Structure
Each project gets:
- `Screenshots/` - App screenshots
- `Diagrams/` - Technical diagrams, flowcharts
- `Concept-Art/` - Design mockups, sketches
- `Physical-Notes/` - Scanned handwritten notes
- `Reference/` - External reference images

## Migration Steps

1. **Phase 1: Setup Structure** (Create all folders and system files)
2. **Phase 2: Organize Images** (Move all images to project-specific folders)
3. **Phase 3: Migrate Content** (Move existing notes to new structure)
4. **Phase 4: Create Task System** (Build task aggregation pages)
5. **Phase 5: Create Scripts** (Automate organization process)
6. **Phase 6: Update Links** (Fix all broken references)

## Automation Opportunities

### Python/Node Script: `organize-sprint.py/js`
```
- Parse current sprint file
- Extract all tasks with tags
- Identify image references
- Suggest component note creation
- Generate task summary files
- Update backlinks
```

### Obsidian Dataview Queries
For task pages to show live data from sprint files

### Potential AI Integration
- Ollama/LM Studio for local processing
- Classify content type (component, feature, bug, idea)
- Suggest file organization
- OCR for physical notes
- Auto-tagging

## Benefits

1. **Single Source of Truth** - Sprint files remain complete historical records
2. **No Broken Links** - Files don't move, new files created with backlinks
3. **Clear Project Separation** - Easy to see what belongs to what
4. **Flexible Kanban** - Tasks stay in sprint files, views generate dynamically
5. **Media Organization** - Images organized by project and type
6. **Quartz Compatible** - Public content in `/Projects`, private in `/_` folders
7. **Scalable** - Easy to add new projects or reorganize without breaking things

## Next Steps

1. Create folder structure
2. Build task extraction script
3. Create template files
4. Begin image migration
5. Test workflow with one sprint
6. Full migration
7. Document new workflow

---

*Generated: 2025-11-07*
