# 📚 Documentation Index

Welcome to your reorganized Quartz vault! This index helps you navigate all the documentation.

## 🎯 Start Here

**New to this reorganization?** Read in this order:

1. **[README_REORGANIZATION.md](README_REORGANIZATION.md)** ⭐
   - Complete overview of what's been done
   - Next steps to get started
   - Quick reference guide
   - **Start here if you're seeing this for the first time!**

2. **[WORKFLOW_GUIDE.md](WORKFLOW_GUIDE.md)** 📖
   - Complete guide to using the new system
   - Daily, weekly, and sprint workflows
   - Tag conventions and best practices
   - Examples and troubleshooting

3. **[MIGRATION_CHECKLIST.md](MIGRATION_CHECKLIST.md)** ✅
   - Step-by-step migration guide
   - Phase-by-phase checklist
   - Commands reference
   - Progress tracking

## 📊 Understanding the System

### Architecture & Planning
- **[REORGANIZATION_PLAN.md](REORGANIZATION_PLAN.md)** - Why this structure was chosen
- **[STRUCTURE_VISUALIZATION.md](STRUCTURE_VISUALIZATION.md)** - Visual diagrams and flows
- **[STATISTICS.md](STATISTICS.md)** - What was created, metrics, before/after

### Summary & Quick Reference
- **[MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md)** - Executive summary of everything
- **[README.md](README.md)** - Updated root README with quick start

## ⚙️ Configuration & Setup

### Quartz Publishing
- **[QUARTZ_CONFIG.md](QUARTZ_CONFIG.md)** - How to configure Quartz
- **[.quartzignore](.quartzignore)** - Publishing ignore rules

### Folder Documentation
- **[content/_Inbox/README.md](content/_Inbox/README.md)** - How to use Inbox
- **[content/_Tasks/README.md](content/_Tasks/README.md)** - Task management system

## 🛠️ Tools & Automation

### Scripts
Located in `content/_System/Scripts/`:

1. **organize_sprint.py** (350+ lines)
   - Extracts tasks from sprint files
   - Identifies and categorizes images
   - Suggests file organization
   - Generates task summary files
   - **Usage:** `python3 organize_sprint.py <sprint-file>`

2. **migrate_content.py** (280+ lines)
   - Migrates old content to new structure
   - Analyzes project context
   - Generates migration report
   - **Usage:** `python3 migrate_content.py [--auto]`

3. **quick-start.sh** (150+ lines)
   - Interactive menu for common tasks
   - Create new sprints
   - Organize current sprint
   - View tasks
   - **Usage:** `./quick-start.sh`

### Templates
Located in `content/_Sprints/_Templates/`:

- **sprint-template.md** - Template for new sprint files

## 📁 Folder Structure

### Private Folders (Excluded from Quartz)
- `content/_Inbox/` - Quick capture zone
- `content/_Sprints/Active/` - Current sprint files
- `content/_Sprints/Archive/` - Completed sprints
- `content/_Tasks/` - Auto-generated task views
- `content/_System/` - Scripts and templates

### Public Folders (Published to Quartz)
- `content/Projects/Star-Sailors/` - Web app project
- `content/Projects/Bumble/` - React Native game
- `content/Projects/Roving/` - Exploration game
- `content/Projects/Station-198/` - iOS app
- `content/Meta/` - Non-project content

## 🎓 Learning Path

### Beginner (Day 1)
1. Read README_REORGANIZATION.md
2. Understand the folder structure
3. Test organize_sprint.py on sample sprint
4. Create a new sprint from template

### Intermediate (Week 1)
1. Complete WORKFLOW_GUIDE.md
2. Run migration dry run
3. Organize existing images
4. Set up Dataview plugin
5. Test task views

### Advanced (Month 1)
1. Complete full migration
2. Optimize workflow
3. Set up automation
4. Configure Quartz publishing
5. Create custom templates

## 📋 Quick Reference

### Common Commands
```bash
# Create new sprint
cd content/_System/Scripts
./quick-start.sh  # Choose option 1

# Organize sprint
python3 organize_sprint.py ../../_Sprints/Active/SSG-XXX.md

# Migrate content
python3 migrate_content.py  # Dry run
python3 migrate_content.py --auto  # Execute

# Test Quartz
npx quartz build
npx quartz serve  # http://localhost:8080
```

### File Locations
| Content | Location |
|---------|----------|
| Current sprint | `_Sprints/Active/SSG-XXX.md` |
| Task views | `_Tasks/Current-Sprint.md` |
| Project docs | `Projects/[Project]/` |
| Scripts | `_System/Scripts/` |
| Templates | `_System/Templates/` |

### Tag Conventions
| Tag Type | Format | Examples |
|----------|--------|----------|
| Projects | `#project-name` | `#star-sailors`, `#bumble` |
| Components | `#component` | `#telescope`, `#bee` |
| Tickets | `#COMP-NUM` | `#TELESCOPE-5`, `#BUG-1` |

## 🔍 Finding Information

### By Topic
- **Workflow** → WORKFLOW_GUIDE.md
- **Architecture** → REORGANIZATION_PLAN.md
- **Migration** → MIGRATION_CHECKLIST.md
- **Quartz** → QUARTZ_CONFIG.md
- **Statistics** → STATISTICS.md
- **Diagrams** → STRUCTURE_VISUALIZATION.md

### By Task
- **Creating sprints** → WORKFLOW_GUIDE.md § Sprint Workflow
- **Organizing content** → WORKFLOW_GUIDE.md § Organize Your Sprint
- **Managing tasks** → content/_Tasks/README.md
- **Publishing** → QUARTZ_CONFIG.md
- **Scripting** → Comments in script files

### By Phase
- **Setup** → README_REORGANIZATION.md
- **Testing** → MIGRATION_CHECKLIST.md § Phase 2
- **Migration** → MIGRATION_CHECKLIST.md § Phase 3
- **Optimization** → MIGRATION_CHECKLIST.md § Phase 8

## 🆘 Troubleshooting

### Documentation
- **General issues** → WORKFLOW_GUIDE.md § Troubleshooting
- **Migration issues** → MIGRATION_CHECKLIST.md § Troubleshooting
- **Script errors** → Check script output, read script comments

### Common Issues
| Problem | Solution |
|---------|----------|
| Scripts not working | Run `chmod +x content/_System/Scripts/*.{py,sh}` |
| Tasks not showing | Install Dataview plugin, check task format |
| Images not loading | Run organize_sprint.py |
| Quartz not building | Check .quartzignore, fix broken links |

## 📈 Progress Tracking

Use MIGRATION_CHECKLIST.md to track your progress through:
- [ ] Phase 1: Understanding & Setup
- [ ] Phase 2: Test the New System
- [ ] Phase 3: Migrate Your Content
- [ ] Phase 4: Organize Images
- [ ] Phase 5: Configure Quartz Publishing
- [ ] Phase 6: Set Up Your Workflow
- [ ] Phase 7: Clean Up Old Structure
- [ ] Phase 8: Optimization & Automation
- [ ] Phase 9: Advanced Features
- [ ] Phase 10: Documentation

## 🎯 Goals & Success Metrics

Your reorganization is successful when:
- ✅ You can write freely without organizing
- ✅ Finding files takes < 10 seconds
- ✅ Tasks auto-appear in views
- ✅ Images organized by project
- ✅ Quartz publishes what you want
- ✅ More time creating, less organizing

## 🔗 External Resources

### Obsidian
- [Obsidian.md](https://obsidian.md/)
- [Community Forum](https://forum.obsidian.md/)
- [Plugin Documentation](https://help.obsidian.md/)

### Quartz
- [Quartz Documentation](https://quartz.jzhao.xyz/)
- [GitHub Repository](https://github.com/jackyzha0/quartz)
- [Discord Community](https://discord.gg/cRFFHYye7t)

### Dataview
- [Dataview Documentation](https://blacksmithgu.github.io/obsidian-dataview/)
- [Query Reference](https://blacksmithgu.github.io/obsidian-dataview/queries/structure/)

## 📞 Getting Help

1. **Check documentation** - Start with this index
2. **Read troubleshooting** - WORKFLOW_GUIDE.md
3. **Review examples** - Sample files in Projects/
4. **Check scripts** - Comments explain functionality
5. **Create issue note** - Drop in `_Inbox/` for later

## 🎉 You're Ready!

Everything you need is here:
- 📚 10 documentation files
- 🤖 3 automation scripts
- 📁 35+ organized folders
- ✅ Complete checklists
- 🎯 Clear next steps

**Start your journey:**
1. Read README_REORGANIZATION.md (5 min)
2. Review WORKFLOW_GUIDE.md (15 min)
3. Test organize_sprint.py (5 min)
4. Create your first organized sprint!

---

## Document Change Log

| File | Purpose | Last Updated |
|------|---------|--------------|
| DOCUMENTATION_INDEX.md | This file - navigation | 2025-11-07 |
| README_REORGANIZATION.md | Main overview | 2025-11-07 |
| WORKFLOW_GUIDE.md | Workflow documentation | 2025-11-07 |
| REORGANIZATION_PLAN.md | Architecture plan | 2025-11-07 |
| MIGRATION_CHECKLIST.md | Migration steps | 2025-11-07 |
| MIGRATION_SUMMARY.md | Executive summary | 2025-11-07 |
| STRUCTURE_VISUALIZATION.md | Visual diagrams | 2025-11-07 |
| QUARTZ_CONFIG.md | Quartz setup | 2025-11-07 |
| STATISTICS.md | Metrics & stats | 2025-11-07 |
| README.md | Root README | 2025-11-07 |

---

*This index helps you navigate the reorganization documentation.*
*Bookmark this page for quick reference!*
*Created: 2025-11-07*
