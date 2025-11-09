# Migration Checklist

Use this checklist to complete your vault reorganization.

## 📋 Phase 1: Understanding & Setup

- [ ] Read `README_REORGANIZATION.md` (start here!)
- [ ] Read `WORKFLOW_GUIDE.md` (understand the workflow)
- [ ] Review `STRUCTURE_VISUALIZATION.md` (see the structure)
- [ ] Install Obsidian Dataview plugin (recommended)
  - Open Obsidian
  - Settings → Community Plugins → Browse
  - Search for "Dataview" → Install → Enable

## 📋 Phase 2: Test the New System

- [ ] Open `_Sprints/Active/SSG-290.md` (sample sprint)
- [ ] Try adding a task: `- [ ] Test task #star-sailors #test #TEST-1`
- [ ] Run the organize script:
  ```bash
  cd content/_System/Scripts
  python3 organize_sprint.py ../../_Sprints/Active/SSG-290.md
  ```
- [ ] View generated tasks in `_Tasks/Current-Sprint.md`
- [ ] Check if Dataview queries work (if plugin installed)

## 📋 Phase 3: Migrate Your Content

### Option A: Gradual Migration (Recommended)
- [ ] Continue using current sprint in new location (`_Sprints/Active/`)
- [ ] Move component notes as you reference them
- [ ] Organize images using the script
- [ ] Create new sprints from template going forward

### Option B: Full Migration
- [ ] Run migration dry run:
  ```bash
  cd content/_System/Scripts
  python3 migrate_content.py
  ```
- [ ] Review `MIGRATION_REPORT.md`
- [ ] If satisfied, run actual migration:
  ```bash
  python3 migrate_content.py --auto
  ```
- [ ] Check migrated files
- [ ] Update any broken links

## 📋 Phase 4: Organize Images

- [ ] Run organize script on current sprint
- [ ] Review image move suggestions
- [ ] Move images to project-specific folders
- [ ] Update image references in sprint files (or use new locations)
- [ ] Optional: Rename images with new naming convention
  - Format: `[Project]-[Type]-[Date]-[Description].[ext]`
  - Example: `SS-Screenshot-20251107-telescope.png`

## 📋 Phase 5: Configure Quartz Publishing

- [ ] Review `QUARTZ_CONFIG.md`
- [ ] Check `.quartzignore` file (already created)
- [ ] Optional: Update `quartz.config.ts` with ignore patterns
- [ ] Test Quartz build:
  ```bash
  npx quartz build
  ```
- [ ] Test local preview:
  ```bash
  npx quartz serve
  ```
  - Visit http://localhost:8080
- [ ] Verify private folders are excluded
- [ ] Verify public projects are included

## 📋 Phase 6: Set Up Your Workflow

- [ ] Create new sprint from template:
  ```bash
  cd content/_System/Scripts
  ./quick-start.sh
  # Choose option 1
  ```
- [ ] Start using dump-and-organize workflow:
  - Open new sprint file
  - Write notes, add tasks, paste images
  - Don't worry about organization yet
- [ ] Set weekly reminder to run organize script
- [ ] Set monthly reminder to archive completed sprints

## 📋 Phase 7: Clean Up Old Structure (After Testing)

⚠️ **Only do this after you're confident the new structure works!**

- [ ] Verify all important content is migrated
- [ ] Run "Detect all broken links" in Obsidian
- [ ] Fix any broken links
- [ ] Create backup of entire vault
- [ ] Archive old folders:
  ```bash
  cd content
  mkdir _Old-Structure-Archive
  mv Sprints _Old-Structure-Archive/
  mv Components _Old-Structure-Archive/
  mv Backend _Old-Structure-Archive/
  mv Viewports _Old-Structure-Archive/
  mv Classifications _Old-Structure-Archive/
  mv Media _Old-Structure-Archive/
  # ... etc
  ```
- [ ] Test everything still works
- [ ] After 1-2 weeks, if all good, delete `_Old-Structure-Archive/`

## 📋 Phase 8: Optimization & Automation

- [ ] Set up quick-start script as command:
  ```bash
  # Add to your .zshrc or .bashrc:
  alias vault-organize="cd ~/Navigation/quartz/content/_System/Scripts && ./quick-start.sh"
  ```
- [ ] Create keyboard shortcut in Obsidian for sprint organization
- [ ] Optional: Set up cron job for weekly task summary
- [ ] Optional: Integrate AI for content classification
  - Install Ollama or LM Studio
  - Modify organize_sprint.py to use local LLM
  - Auto-tag and categorize content

## 📋 Phase 9: Advanced Features (Optional)

- [ ] Set up Obsidian Templater for sprint templates
- [ ] Create dashboard note with embedded task views
- [ ] Set up Obsidian Calendar plugin for daily notes
- [ ] Configure Git sync for automatic backups
- [ ] Set up CI/CD for Quartz deployment
- [ ] Create weekly review template
- [ ] Set up OCR for scanned physical notes
  - Install Tesseract OCR
  - Create script to process scanned notes
  - Auto-extract text and organize

## 📋 Phase 10: Documentation

- [ ] Document any custom modifications you make
- [ ] Create project-specific templates
- [ ] Document your personal workflow variations
- [ ] Share what works/doesn't work in sprint retrospectives

---

## Quick Commands Reference

### Create New Sprint
```bash
cd content/_System/Scripts
./quick-start.sh
# Choose option 1
```

### Organize Current Sprint
```bash
cd content/_System/Scripts
./quick-start.sh
# Choose option 2
```

### View Tasks
```bash
cd content/_System/Scripts
./quick-start.sh
# Choose option 3
```

### Migrate Content
```bash
cd content/_System/Scripts
python3 migrate_content.py  # Dry run
python3 migrate_content.py --auto  # Actual migration
```

### Test Quartz
```bash
cd ~/Navigation/quartz
npx quartz build
npx quartz serve
```

---

## Troubleshooting

### Scripts not working?
```bash
chmod +x content/_System/Scripts/*.sh
chmod +x content/_System/Scripts/*.py
```

### Python not found?
```bash
# Install Python 3 if needed
brew install python3  # macOS
```

### Dataview not showing tasks?
- Check plugin is installed and enabled
- Verify task format: `- [ ] Task #TAG`
- Check file is in `_Sprints/` folder

### Images not loading?
- Run organize_sprint.py
- Check image paths
- Verify images exist in Media or project folders

---

## Support

If you encounter issues:
1. Check WORKFLOW_GUIDE.md for examples
2. Review REORGANIZATION_PLAN.md for rationale
3. Check script output for error messages
4. Create issue note in `_Inbox/` and organize later 😊

---

**Progress Tracker**

Total items: 50+
Completed: ___
Remaining: ___

**Target completion date:** _____________

**Notes:**





---

*Created: 2025-11-07*
*Good luck with your reorganization!*
