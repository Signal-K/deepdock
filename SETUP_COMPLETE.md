# ✅ Setup Complete - Quick Start Guide

## 🎉 Everything is Ready!

All sprint files have been moved and the vault command is installed. Here's what happened:

### ✅ Sprint Files Organized

**Active Sprints** (in `_Sprints/Active/`):
- SSG-294.md
- SSG-295.md
- SSG-290.md (sample)

**Archived Sprints** (in `_Sprints/Archive/2025/`):
- SSG-281.md + SSG-281 Kanban.md
- SSG-286.md through SSG-293.md

**Archived Sprints** (in `_Sprints/Archive/2024/`):
- SSG-218 Kanban.md

### ✅ Virtual Environment Created

Location: `/Users/scroobz/Navigation/quartz/.venv/`
- Python 3 virtual environment
- All dependencies installed
- Auto-activated for all vault commands

### ✅ Vault Command Installed

Location: `~/.local/bin/vault`
- Symlinked to scripts folder
- Works from anywhere
- Auto-manages virtual environment

## 🚀 How to Use (One Command!)

### Add to PATH (One Time)

Add this line to your `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then:
```bash
source ~/.zshrc
```

### Or Use Full Path
```bash
/Users/scroobz/.local/bin/vault <command>
```

## 📝 Common Commands

### Organize Current Sprint
```bash
vault organize
```
This automatically:
1. Finds the most recent active sprint
2. Activates virtual environment
3. Extracts all tasks
4. Identifies images
5. Generates task summary
6. Deactivates virtual environment

### Organize Specific Sprint
```bash
vault organize 294
# or
vault organize SSG-294
```

### Create New Sprint
```bash
vault new-sprint 296
```
Creates `SSG-296.md` from template with:
- Current date filled in
- Sprint number updated
- Ready to use

### View Tasks
```bash
vault tasks
```
Shows `_Tasks/Current-Sprint.md` in your terminal.

### Interactive Menu
```bash
vault menu
```
Shows the quick-start menu with all options.

### Get Help
```bash
vault help
```

## 🎯 Your Workflow Now

### Daily
```bash
# 1. Open Obsidian, work on sprint file
# 2. Add notes, tasks, paste images
# 3. End of day:
vault organize
```

### Weekly
```bash
# Organize both active sprints
vault organize 294
vault organize 295

# Check progress
vault tasks
```

### New Sprint
```bash
# Create new sprint
vault new-sprint 296

# Archive completed sprint (manual)
mv content/_Sprints/Active/SSG-294.md content/_Sprints/Archive/2025/
```

## 📁 File Structure (Updated)

```
content/
├── _Sprints/
│   ├── Active/
│   │   ├── SSG-290.md (sample)
│   │   ├── SSG-294.md ✅
│   │   └── SSG-295.md ✅
│   ├── Archive/
│   │   ├── 2024/
│   │   │   └── SSG-218 Kanban.md
│   │   └── 2025/
│   │       ├── SSG-281.md
│   │       ├── SSG-281 Kanban.md
│   │       ├── SSG-286.md
│   │       ├── SSG-287.md
│   │       ├── SSG-288.md
│   │       ├── SSG-289.md
│   │       ├── SSG-290.md
│   │       ├── SSG-291.md
│   │       ├── SSG-292.md
│   │       └── SSG-293.md
│   └── _Templates/
│       └── sprint-template.md
│
├── _System/
│   └── Scripts/
│       ├── vault ⭐ Main command
│       ├── install-vault-command.sh
│       ├── setup-venv.sh
│       ├── organize_sprint.py
│       ├── migrate_content.py
│       └── quick-start.sh
│
└── _Tasks/
    ├── Current-Sprint.md (auto-generated)
    ├── All-Tasks.md
    └── By-Project.md
```

## 🔥 Quick Reference

| What | Command |
|------|---------|
| Organize current sprint | `vault organize` |
| Organize specific sprint | `vault organize 294` |
| Create new sprint | `vault new-sprint 296` |
| View tasks | `vault tasks` |
| Interactive menu | `vault menu` |
| Setup environment | `vault setup` |
| Migrate content | `vault migrate` |
| Help | `vault help` |

## 📖 Documentation

- **This file** - Quick start
- **VAULT_COMMAND.md** - Complete vault command reference
- **WORKFLOW_GUIDE.md** - Detailed workflow documentation
- **DOCUMENTATION_INDEX.md** - All documentation index

## ⚡ Try It Now!

```bash
# Add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Test it
vault organize

# Or use full path
/Users/scroobz/.local/bin/vault organize
```

## 🎊 What You Can Do Now

### Everything in One Command!

**Before:**
```bash
cd content/_System/Scripts
source ../../.venv/bin/activate
python3 organize_sprint.py ../../_Sprints/Active/SSG-294.md
deactivate
```

**Now:**
```bash
vault organize 294
```

**That's it!** ✨

### Features

- ✅ Auto-activates virtual environment
- ✅ Finds sprint files automatically
- ✅ Organizes tasks and images
- ✅ Generates task summaries
- ✅ No manual path management
- ✅ Works from any directory
- ✅ Clean and simple

## 🆘 Troubleshooting

### "vault: command not found"

**Option 1: Add to PATH**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Option 2: Use full path**
```bash
/Users/scroobz/.local/bin/vault organize
```

**Option 3: Create alias**
```bash
echo 'alias vault="/Users/scroobz/.local/bin/vault"' >> ~/.zshrc
source ~/.zshrc
```

### Virtual environment issues

```bash
# Recreate venv
rm -rf /Users/scroobz/Navigation/quartz/.venv
vault setup
```

### Script errors

```bash
# Run directly to see errors
cd content/_System/Scripts
python3 organize_sprint.py ../../_Sprints/Active/SSG-294.md
```

## 🎯 Next Steps

1. **Add to PATH** (if not done)
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

2. **Test organize command**
   ```bash
   vault organize 294
   ```

3. **Check generated tasks**
   ```bash
   vault tasks
   ```

4. **Start using for real**
   - Work in sprint files
   - Run `vault organize` when ready
   - Enjoy automated organization!

---

## Summary

✅ **13 sprint files moved** to proper locations
✅ **Virtual environment created** and configured  
✅ **Vault command installed** and ready
✅ **One command** to do everything

**You're all set!** 🚀

Start with:
```bash
vault organize
```

---

*Created: 2025-11-08*
*Setup completed successfully*
