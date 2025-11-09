# Vault Structure Visualization

## Overall Architecture

```
📁 quartz/
│
├── 📄 README_REORGANIZATION.md      ← START HERE!
├── 📄 WORKFLOW_GUIDE.md             ← How to use the system
├── 📄 REORGANIZATION_PLAN.md        ← Why this structure
├── 📄 QUARTZ_CONFIG.md              ← Quartz setup
├── 📄 .quartzignore                 ← What not to publish
│
├── 📁 content/                      ← Your Obsidian vault
│   │
│   ├── 🔒 _Inbox/                  ← Quick capture (private)
│   │   └── README.md
│   │
│   ├── 🔒 _Sprints/                ← Sprint files (private)
│   │   ├── Active/
│   │   │   └── SSG-290.md          ← Current sprint
│   │   ├── Archive/
│   │   │   ├── 2024/
│   │   │   └── 2025/
│   │   └── _Templates/
│   │       └── sprint-template.md
│   │
│   ├── 🔒 _Tasks/                  ← Task views (private)
│   │   ├── README.md
│   │   ├── Current-Sprint.md       ← Auto-generated tasks
│   │   ├── All-Tasks.md
│   │   └── By-Project.md
│   │
│   ├── 🌍 Projects/                ← Public projects
│   │   │
│   │   ├── Star-Sailors/           ← Main web app
│   │   │   ├── index.md
│   │   │   ├── Components/
│   │   │   ├── Features/
│   │   │   ├── Backend/
│   │   │   ├── Viewports/
│   │   │   ├── Classifications/
│   │   │   ├── Missions/
│   │   │   ├── Research/
│   │   │   └── Media/
│   │   │       ├── Screenshots/
│   │   │       ├── Diagrams/
│   │   │       └── Physical-Notes/
│   │   │
│   │   ├── Bumble/                 ← React Native game
│   │   │   ├── index.md
│   │   │   ├── Components/
│   │   │   │   └── Bee-minigame.md
│   │   │   ├── Features/
│   │   │   ├── Mechanics/
│   │   │   └── Media/
│   │   │       ├── Screenshots/
│   │   │       ├── Concept-Art/
│   │   │       └── Physical-Notes/
│   │   │
│   │   ├── Roving/                 ← Exploration game
│   │   │   ├── index.md
│   │   │   └── Media/
│   │   │
│   │   ├── Station-198/            ← iOS app
│   │   │   ├── index.md
│   │   │   ├── Database-Structure.md
│   │   │   ├── Pages/
│   │   │   ├── Subscriptions/
│   │   │   └── Media/
│   │   │
│   │   └── Shared/                 ← Cross-project
│   │       ├── Components/
│   │       ├── Backend/
│   │       ├── Infrastructure/
│   │       └── Media/
│   │
│   ├── 🌍 Meta/                    ← Non-project content
│   │   ├── Meetings/
│   │   ├── Ideas/
│   │   ├── Research/
│   │   └── Games/
│   │       └── Roguelike-ideation.md
│   │
│   └── 🔒 _System/                 ← System files (private)
│       ├── Scripts/
│       │   ├── organize_sprint.py
│       │   ├── migrate_content.py
│       │   └── quick-start.sh
│       └── Templates/
│
└── 📁 (old structure - to be archived)
    ├── Sprints/                     ← Old sprint files
    ├── Components/                  ← Old component notes
    ├── Backend/                     ← Old backend notes
    ├── Media/                       ← Old media files
    └── ...
```

## Legend

- 🔒 **Private** - Folders prefixed with `_` are excluded from Quartz
- 🌍 **Public** - Regular folders are published to Quartz
- 📄 **Documentation** - Setup and workflow guides
- 📁 **Folder** - Directory

## Data Flow

```
┌─────────────────────────────────────────────────────────┐
│                    Your Workflow                        │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  1. DUMP: Write everything in sprint file              │
│     _Sprints/Active/SSG-XXX.md                         │
│     - Notes, ideas, observations                        │
│     - Tasks: - [ ] Task #tags #TICKET-ID              │
│     - Images: ![[image.png]]                           │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│  2. ORGANIZE: Run organize_sprint.py                   │
│     $ python3 organize_sprint.py SSG-XXX.md            │
│     - Extracts tasks                                    │
│     - Identifies images                                 │
│     - Suggests organization                             │
└─────────────────────────────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
┌──────────────────────┐   ┌──────────────────────┐
│  3a. TASKS:          │   │  3b. IMAGES:         │
│  Auto-generated      │   │  Moved to            │
│  task views          │   │  project folders     │
│  _Tasks/             │   │  Projects/*/Media/   │
│  Current-Sprint.md   │   │  - Screenshots/      │
│  All-Tasks.md        │   │  - Physical-Notes/   │
│  By-Project.md       │   │  - Diagrams/         │
└──────────────────────┘   └──────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│  4. REVIEW: View your organized content                │
│     - Check task progress in _Tasks/                   │
│     - Reference component notes in Projects/           │
│     - Sprint file remains complete historical record   │
└─────────────────────────────────────────────────────────┘
                │
                ▼
┌─────────────────────────────────────────────────────────┐
│  5. PUBLISH: Build Quartz site                         │
│     $ npx quartz build                                  │
│     - Projects/ published                               │
│     - Meta/ published                                   │
│     - _Sprints/, _Tasks/, _Inbox/ excluded             │
└─────────────────────────────────────────────────────────┘
```

## Task Tag Flow

```
Sprint File: - [ ] Fix telescope bug #star-sailors #telescope #TELESCOPE-5
                           │
                           ▼
            ┌──────────────┴──────────────┐
            │    organize_sprint.py       │
            │    Analyzes tags:           │
            │    - Project: star-sailors  │
            │    - Component: telescope   │
            │    - Ticket: TELESCOPE-5    │
            └──────────────┬──────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Current-     │  │ All-Tasks    │  │ By-Project   │
│ Sprint.md    │  │ .md          │  │ .md          │
│              │  │              │  │              │
│ Shows in     │  │ Shows in     │  │ Shows in     │
│ "Star        │  │ "Telescope"  │  │ "Star        │
│ Sailors"     │  │ section      │  │ Sailors"     │
│ section      │  │              │  │ project      │
└──────────────┘  └──────────────┘  └──────────────┘
```

## Image Organization Flow

```
Paste image in sprint ──→ Saves to content/Media/image.png
                                      │
                                      ▼
                          organize_sprint.py analyzes
                                      │
                    ┌─────────────────┼─────────────────┐
                    ▼                 ▼                 ▼
            IMG_*.jpg          Pasted image*      Diagram*
            (Physical          (Screenshot)       (Diagram)
             note)                  │                 │
                 │                  │                 │
                 ▼                  ▼                 ▼
    Projects/.../Media/   Projects/.../Media/  Projects/.../Media/
    Physical-Notes/       Screenshots/         Diagrams/
```

## Publishing Strategy

```
                    Obsidian Vault
                          │
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
   🔒 Private        🌍 Public          🌍 Public
   Folders           Projects/          Meta/
   (_Inbox,          (All project       (Public
   _Sprints,         documentation)     ideas,
   _Tasks,                              research)
   _System)               │                 │
        │                 │                 │
        │                 ▼                 ▼
        │         ┌───────────────────────────┐
        │         │    Quartz Build           │
        │         │    (Static Site)          │
        └────X────│    - Excludes _* folders  │
    Not published│    - Publishes Projects/   │
                 │    - Publishes Meta/       │
                 └───────────────────────────┘
                              │
                              ▼
                     Published Website
                     (Your digital garden)
```

---

## Quick Reference: Where Things Go

| Content Type | Location | Public/Private |
|-------------|----------|----------------|
| Sprint notes | `_Sprints/Active/` | 🔒 Private |
| Completed sprints | `_Sprints/Archive/YYYY/` | 🔒 Private |
| Quick notes | `_Inbox/` | 🔒 Private |
| Tasks | `_Tasks/` | 🔒 Private |
| Star Sailors components | `Projects/Star-Sailors/Components/` | 🌍 Public |
| Bumble features | `Projects/Bumble/Features/` | 🌍 Public |
| Screenshots | `Projects/*/Media/Screenshots/` | 🌍 Public |
| Physical notes | `Projects/*/Media/Physical-Notes/` | 🌍 Public |
| Meeting notes | `Meta/Meetings/` | 🌍 Public |
| Game ideas | `Meta/Games/` | 🌍 Public |
| Scripts | `_System/Scripts/` | 🔒 Private |

---

*For detailed information, see WORKFLOW_GUIDE.md*
