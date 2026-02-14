---
icon: lucide//workflow
---

# 📱 Mobile Dashboard Setup Guide

## Required Plugins

Install these plugins in Obsidian (Settings → Community Plugins):

### 1. **Buttons** (Essential)
- **ID:** `obsidian-buttons`
- **Purpose:** Interactive buttons on dashboard
- **Actions:** Create tasks, organize notes, new sprints

### 2. **Templater** (Essential)  
- **ID:** `templater-obsidian`
- **Purpose:** Run JavaScript scripts
- **Config:**
  - Template folder: `_Daily`
  - Script folder: `.obsidian/scripts`
  - Enable "Trigger Templater on new file creation"

### 3. **Dataview** (Essential)
- **ID:** `dataview`
- **Purpose:** Show high-priority tasks dynamically
- **Config:** Enable JavaScript queries

### 4. **Tasks** (Optional but Recommended)
- **ID:** `obsidian-tasks-plugin`
- **Purpose:** Advanced task management
- **Features:** Due dates, recurrence, filters

### 5. **QuickAdd** (Optional)
- **ID:** `quickadd`
- **Purpose:** Faster task creation
- **Setup:** Pre-configure task templates

## Installation Steps

### Desktop Setup

1. **Open Obsidian** on your Mac
2. **Settings** → **Community Plugins** → **Browse**
3. **Search and Install:**
   - Buttons
   - Templater
   - Dataview
   - Tasks (optional)
4. **Enable all plugins**

### Templater Configuration

1. **Settings** → **Templater**
2. **Template folder location:** `_Daily`
3. **Script files folder location:** `.obsidian/scripts`
4. **✓ Enable** "Trigger Templater on new file creation"
5. **Startup Templates:**
   - Add `_Daily/Dashboard-Template.md` to auto-create daily notes

### Mobile Sync (iOS/Android)

#### Option 1: Obsidian Sync (Paid, Recommended)
1. **Desktop:** Settings → Sync → Enable
2. **Mobile:** Install Obsidian app → Sign in → Sync vault
3. **Wait** for plugins to sync (~5 min)
4. **Mobile:** Enable community plugins in settings

#### Option 2: iCloud (Free, iOS only)
1. **Desktop:** Move vault to `~/Library/Mobile Documents/iCloud~md~obsidian/`
2. **Mobile:** Install Obsidian → Open vault from iCloud
3. **Mobile:** Manually enable each plugin (Settings → Community Plugins)

#### Option 3: Git (Free, Advanced)
1. Install **Obsidian Git** plugin
2. Connect to GitHub repository
3. Auto-pull on mobile app open
4. Plugins sync via git

## Dashboard Usage (Mobile)

### Daily Workflow

1. **Morning:**
   - Open Obsidian
   - Dashboard auto-opens (or tap "Today" in sidebar)
   - Review **High Priority Tasks** (top 5)
   - Check **Today's Tasks**

2. **During Day:**
   - Tap **➕ Create Task** button → Quick dialog
   - Or write in "Quick Task Inbox" section
   - Dump notes in "Today's Notes Dump"

3. **End of Day:**
   - Tap **📋 Organize Daily Notes** button
   - Tasks auto-route to project files
   - Notes stay in daily file for reference

### Button Actions

| Button | Action | What It Does |
|--------|--------|-------------|
| ➕ Create Task | Opens dialog | Choose project, priority, add task |
| 📋 Organize | Runs script | Routes tasks to projects |
| 🆕 New Sprint | Opens dialog | Creates sprint file with template |
| 📊 Projects | Opens view | See all project tasks |

### Creating Tasks (Two Ways)

#### Method 1: Button (Faster on Mobile)
1. Tap **➕ Create Task** button
2. Enter task description
3. Select project (Star Sailors, Bumble, etc.)
4. Select priority (High, Medium, Low)
5. Done! Task added to project file

#### Method 2: Inline (More Control)
```markdown
- [ ] Fix telescope viewport bug ⏫
- [ ] Design bee pollination mechanic 🔼
- [ ] Research roving gameplay 🔽
```
Then tap **📋 Organize** to route them.

### Priority Markers

Use these in task text for automatic priority detection:

- **High:** `⏫`, `#p1`, `#high-priority`
- **Medium:** `🔼`, `#p2`, `#p3`
- **Low:** `🔽`, `#p4`, `#p5`

### Project Keywords

Tasks are auto-routed by detecting these keywords:

- **Star Sailors:** `star-sailors`, `telescope`, `satellite`, `rover`
- **Bumble:** `bumble`, `bee`, `pollinator`, `crop`
- **Roving:** `roving`
- **Station 198:** `station`, `station-198`

## Troubleshooting

### Buttons Don't Work

**Problem:** Buttons show as code blocks  
**Fix:** 
1. Settings → Community Plugins
2. Enable "Buttons" plugin
3. Restart Obsidian

### Scripts Don't Run

**Problem:** "Script not found" error  
**Fix:**
1. Settings → Templater → Script folder
2. Set to `.obsidian/scripts`
3. Verify files exist:
   - `.obsidian/scripts/organize-daily.js`
   - `.obsidian/scripts/create-task.js`
   - `.obsidian/scripts/new-sprint.js`

### Dataview Queries Blank

**Problem:** High-priority tasks section empty  
**Fix:**
1. Settings → Dataview
2. Enable "Enable JavaScript Queries"
3. Enable "Enable Inline Queries"
4. Restart Obsidian

### Mobile Buttons Different

**Problem:** Buttons look different on mobile  
**This is normal.** Mobile renders buttons as text links, still functional.

## Mobile-Specific Tips

### Tap Targets
Buttons on mobile are optimized for finger taps. Give yourself space between buttons.

### Keyboard Shortcuts
On iPad with keyboard:
- `Cmd+P` → Quick command palette
- Search "Templater: Run Script"

### Widget Support (iOS)
Add Obsidian widget to home screen:
- Shows today's daily note
- Quick access to dashboard

### Android Shortcuts
Long-press Obsidian app icon:
- "New Note" → Creates daily dashboard
- "Search" → Find tasks

## Advanced Setup (Optional)

### Auto-Create Daily Dashboard

1. **Settings** → **Daily Notes** plugin
2. **Template:** `_Daily/Dashboard-Template.md`
3. **New file location:** `_Daily`
4. **Date format:** `YYYY-MM-DD`

Now tapping "Open today's daily note" auto-creates dashboard!

### Sidebar Bookmarks

Add to sidebar for quick access:
- High Priority Tasks → `content/Categories/All-Tasks.md` with Dataview filter
- Active Sprints → `_Sprints/Active/` folder
- Projects → `content/Categories/Projects/` folder

### Task Notifications (Mobile)

Using **Tasks** plugin:
1. Add due dates: `📅 2025-11-10`
2. Enable notifications in plugin settings
3. Get alerts on mobile

## Workflow Example

### Real Usage on iPhone

**Morning (9 AM):**
```
1. Open Obsidian app
2. Tap "Today" bookmark
3. See dashboard with 3 high-priority tasks
4. Review what needs doing today
```

**During Meeting (11 AM):**
```
1. Tap ➕ Create Task
2. Type: "Research lunar phases for moon mechanic"
3. Select: Bumble
4. Select: Medium priority
5. Back to meeting notes
```

**Brainstorming (2 PM):**
```
1. Scroll to "Today's Notes Dump"
2. Dump random ideas:
   "What if bees could paint flowers?"
   "Telescope upgrade paths?"
3. Keep typing, no organization needed
```

**End of Day (6 PM):**
```
1. Scroll to top
2. Tap 📋 Organize Daily Notes
3. See notification: "✅ Organized 5 tasks to projects"
4. Tasks now in project files
5. Notes stay in today's file
```

**Tomorrow:**
New dashboard auto-created, yesterday's preserved!

## Summary

✅ **Plugins needed:** Buttons, Templater, Dataview  
✅ **Mobile compatible:** Works on iOS & Android  
✅ **One-tap actions:** Create, organize, manage  
✅ **Auto-routing:** Tasks go to correct projects  
✅ **Always accessible:** Dashboard in `_Daily/` folder

**Next Steps:**
1. Install plugins
2. Configure Templater
3. Create today's dashboard: `vault new-dashboard`
4. Start using buttons!

---

*Created: 2025-11-09*  
*Works on: Obsidian Mobile (iOS/Android) & Desktop*
