---
title: Weekly Features Setup Complete
icon: lucide//check-circle
tags:
  - setup
  - documentation
created: 2025-11-22
---

# ✅ Weekly Analysis & Archive Features

Two powerful new features have been added to your dashboard system:

## 🧠 Weekly Analysis (AI-Powered)

### What It Does
Analyzes all notes from the current week to:
- Identify ideas/action items that don't have matching tasks
- List all incomplete tasks
- Provide AI-powered recommendations
- Generate a comprehensive weekly report

### Location
**Button:** Dashboard → "🧠 Analyze Week (AI)" (orange button)

**Script:** `/content/_System/Scripts/obsidian/analyze-weekly.js`

**Template:** `/content/_System/Templates/Weekly-Analysis.md`

**Output:** Creates `/Operations/Daily/Weekly-Analysis-YYYY-MM-DD.md` with:
- AI analysis of ideas vs tasks
- Task categorization by project
- Recommendations for new tasks
- List of all files analyzed
- Raw data for manual review

### How It Works
1. Scans all files modified during current week (Sunday-Saturday)
2. Extracts action phrases like "need to", "should", "must build", etc.
3. Compares against all tasks in vault
4. Sends data to **Ollama (local AI)** for analysis
5. Generates detailed report

### Requirements
- **Ollama** installed and running locally
- Default model: `llama3.2` (can be changed)
- See setup guide: [[_System/Documentation/Ollama-Setup]]

### Fallback
If Ollama is not available, provides basic analysis without AI.

---

## 📦 Weekly Archive

### What It Does
Archives all documents from the **previous week** (Sunday-Saturday) into organized folders:
- Creates folder structure: `_Archive/YYYY/Week-MM-DD/`
- Preserves subfolder organization (Daily, Tasks, Sprints, etc.)
- Generates archive summary
- Moves files (doesn't copy)

### Location
**Button:** Dashboard-Template → "📦 Archive Last Week" (teal button)

**Script:** `/content/_System/Scripts/obsidian/archive-weekly.js`

**Template:** `/content/_System/Templates/Archive-Week.md`

**Output:** 
- Moves files to `/content/_Archive/YYYY/Week-MM-DD/`
- Creates `Archive-Summary.md` with statistics

### How It Works
1. Identifies previous week's date range
2. Finds all files modified during that period
3. Excludes system files and already-archived files
4. Confirms with user before proceeding
5. Moves files to archive with preserved folder structure
6. Generates summary report

### Folder Structure
```
_Archive/
  2025/
    Week-11-16/
      Daily/
      Tasks/
      Sprints/
      Boards/
      Other/
      Archive-Summary.md
```

---

## 🎯 Quick Start

### Weekly Analysis
1. **Install Ollama** (one-time setup):
   ```bash
   # Visit https://ollama.ai and download
   # Then run:
   ollama pull llama3.2
   ```

2. **Run Analysis:**
   - Open Dashboard
   - Click "🧠 Analyze Week (AI)"
   - Review generated report

### Weekly Archive
1. **Archive Last Week:**
   - Open Dashboard-Template (or any page with the button)
   - Click "📦 Archive Last Week"
   - Confirm when prompted
   - Review archive summary

---

## 📋 Button Reference

### Dashboard.md Buttons
- ➕ **Create Task** - Create new task with unique ID
- 📋 **Organize Daily Notes** - Route tasks to projects
- 🆕 **New Sprint** - Create new sprint
- **🧠 Analyze Week (AI)** - ⭐ NEW: AI-powered weekly analysis
- 📅 **Archive Daily** - Archive today's dashboard
- 🔄 **Reset Dashboard** - Reset dashboard from template
- 📊 **View All Projects** - Navigate to project view

### Dashboard-Template.md Buttons
(Same as above, plus:)
- **📦 Archive Last Week** - ⭐ NEW: Archive previous week's files

---

## 🔧 Customization

### Change AI Model
Edit `/content/_System/Scripts/obsidian/analyze-weekly.js`:
```javascript
model: 'llama3.2',  // Change to: llama3.2:3b, codellama, etc.
```

### Adjust Analysis Scope
Modify action phrases in `analyze-weekly.js`:
```javascript
const actionPhrases = [
    'need to', 'should', 'must', 'have to',
    // Add your own phrases...
];
```

### Change Archive Exclusions
Edit `archive-weekly.js` to skip additional folders:
```javascript
if (file.path.startsWith('content/_YourFolder')) {
    continue;
}
```

---

## 📊 What Gets Analyzed?

### Weekly Analysis Includes:
- Files modified during current week
- All content sections (ideas, notes, meetings)
- Task checkboxes throughout vault
- Action-oriented language patterns

### Weekly Analysis Excludes:
- Nothing (all markdown content is analyzed)

### Weekly Archive Includes:
- Files modified during previous week
- All content types

### Weekly Archive Excludes:
- `_System/` folder (scripts, templates)
- `_Archive/` folder (already archived)

---

## 🐛 Troubleshooting

### "Ollama not available"
- Install Ollama: https://ollama.ai
- Pull a model: `ollama pull llama3.2`
- Ensure Ollama is running: `ollama list`
- See full guide: [[_System/Documentation/Ollama-Setup]]

### "No files found from last week"
- This is normal if you didn't work much last week
- Check date range in notification
- Archive runs Sunday-Saturday of previous week

### Analysis takes too long
- Use smaller model: `ollama pull llama3.2:1b`
- Reduce `num_predict` in script (lower = faster)

### Files not archiving
- Check if files were actually modified last week
- System files are intentionally excluded
- Check console for errors (Cmd+Option+I)

---

## 📚 Related Documentation

- [[_System/Documentation/Ollama-Setup|Ollama Setup Guide]]
- [[_Daily/Dashboard|Main Dashboard]]
- [[_Daily/Dashboard-Template|Dashboard Template]]

---

## 🎉 Benefits

### Weekly Analysis
- ✅ Never forget an idea
- ✅ Identify gaps between planning and doing
- ✅ Get AI-powered task recommendations
- ✅ Complete privacy (local AI)
- ✅ Track weekly progress patterns

### Weekly Archive
- ✅ Keep vault organized
- ✅ Preserve history
- ✅ Reduce clutter in active folders
- ✅ Easy to reference old work
- ✅ Automatic organization

---

*Both features integrate seamlessly with existing dashboard workflows*
