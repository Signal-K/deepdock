---
icon: lucide//workflow
---

# 📱 Dashboard Quick Reference

## Your Daily Workflow

### Morning (1 minute)
1. Open Obsidian
2. Daily dashboard opens automatically
3. Check **⏫ High Priority** section (top 5 tasks)
4. Review **✅ Today's Tasks**

### During the Day (anytime)
**Option 1: Quick Task Button**
- Tap **➕ Create Task**
- Choose project → priority → done

**Option 2: Type & Organize**
- Type tasks in "Quick Task Inbox"
- Tap **📋 Organize** when ready

### Capturing Notes
- Dump everything in "Today's Notes Dump"
- No need to organize while working
- Stay in flow, organize later

### End of Day (30 seconds)
- Tap **📋 Organize Daily Notes**
- Tasks → routed to projects
- Notes → stay in today's file
- Tomorrow → fresh dashboard

## Button Guide

| Button | Does What |
|--------|-----------|
| **➕ Create Task** | Dialog → Quick task creation |
| **📋 Organize** | Route tasks to projects |
| **🆕 New Sprint** | Create sprint file |
| **📊 Projects** | View all project tasks |

## Task Syntax

### Priority
```markdown
- [ ] High priority task ⏫
- [ ] Medium priority task 🔼  
- [ ] Low priority task 🔽
```

### Auto-Routing (by keyword)
```markdown
- [ ] Fix telescope (routes to Star Sailors)
- [ ] Design bee mechanic (routes to Bumble)
- [ ] Add roving feature (routes to Roving)
- [ ] Update station UI (routes to Station 198)
```

## Required Plugins

✅ **Buttons** - Interactive buttons  
✅ **Templater** - Run scripts  
✅ **Dataview** - Show tasks

*Install: Settings → Community Plugins → Browse*

## Mobile Tips

### iOS
- Widget: Add to home screen
- Shortcuts: Long-press app icon
- Keyboard: `Cmd+P` for commands (iPad)

### Android
- Long-press app icon for shortcuts
- Widgets available in launcher

## High Priority Detection

Tasks show in "High Priority" section if they contain:
- `⏫` emoji
- `#p1` tag
- `#high-priority` tag
- `🔥` emoji

## Example Daily Flow

```markdown
## 📥 Today's Notes Dump

Had idea for moon phases affecting bee behavior
Telescope viewport needs pagination fix
Meeting with design team - want more color

## ➕ Quick Task Inbox

- [ ] Implement moon phase system for Bumble ⏫
- [ ] Fix telescope viewport pagination 🔼
- [ ] Research color palette options 🔽
```

*Tap **📋 Organize** →*

**Result:**
- Moon task → `content/Categories/Projects/bumble.md` (High Priority)
- Telescope → `content/Categories/Projects/star-sailors.md` (Medium)
- Colors → Unknown (stays in daily file)

## File Locations

| What | Where |
|------|-------|
| Today's dashboard | `_Daily/2025-11-09.md` |
| All project tasks | `content/Categories/Projects/*.md` |
| Active sprints | `_Sprints/Active/*.md` |
| Scripts | `.obsidian/scripts/*.js` |

## Troubleshooting

**Buttons not working?**
→ Enable "Buttons" plugin

**Scripts not running?**
→ Templater settings → Script folder: `.obsidian/scripts`

**No high-priority tasks showing?**
→ Enable Dataview plugin → Enable JS queries

## Commands

You can also use command palette (`Cmd+P`):

- "Templater: Run Script - create-task"
- "Templater: Run Script - organize-daily"  
- "Templater: Run Script - new-sprint"

## Desktop Alternative

If on desktop, you can still use terminal:
```bash
vault organize-daily     # Same as button
vault new-sprint 296     # Create sprint
```

---

**That's it!** 

Just tap buttons, dump notes, stay organized. 🎯

*Keep this file bookmarked for quick reference*
