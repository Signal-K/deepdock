# Quartz v4 - Reorganized Vault

> "[One] who works with the door open gets all kinds of interruptions, but [they] also occasionally gets clues as to what the world is and what might be important." — Richard Hamming

This Quartz vault has been comprehensively reorganized for multi-project management with a dump-and-organize workflow.

## 🚀 Quick Start

**New here?** → Read **[MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md)** for complete overview!

### Essential Documents
1. **[README_REORGANIZATION.md](README_REORGANIZATION.md)** - What's been done, how to use it
2. **[WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md)** - Complete workflow documentation
3. **[MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md)** - Step-by-step migration guide
4. **[STRUCTURE_VISUALIZATION.md](STRUCTURE_VISUALIZATION.md)** - Visual diagrams

### Quick Commands
```bash
# Create new sprint
cd content/_System/Scripts && ./quick-start.sh

# Organize current sprint
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md

# Test Quartz build
npx quartz build && npx quartz serve
```

## 📁 New Structure

```
content/
├── _Inbox/          # Quick capture (private)
├── _Sprints/        # Sprint files (private)
├── _Tasks/          # Task views (private)
├── _System/         # Scripts (private)
├── Projects/        # Project docs (public)
│   ├── Star-Sailors/
│   ├── Bumble/
│   ├── Roving/
│   └── Station-198/
└── Meta/            # Non-project content (public)
```

Folders prefixed with `_` are private (excluded from Quartz publishing).

## 🎯 Projects

- **Star Sailors** - Main web application (citizen science platform)
- **Bumble** - React Native farming/pollinator game
- **Roving** - React Native exploration game
- **Station-198** - Swift iOS application

## 🔗 Original Quartz Documentation

🔗 Read the documentation and get started: https://quartz.jzhao.xyz/

[Join the Discord Community](https://discord.gg/cRFFHYye7t)

## Sponsors

<p align="center">
  <a href="https://github.com/sponsors/jackyzha0">
    <img src="https://cdn.jsdelivr.net/gh/jackyzha0/jackyzha0/sponsorkit/sponsors.svg" />
  </a>
</p>
