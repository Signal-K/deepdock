---
icon: lucide//sparkles
title: AI Route — Apple Shortcut Setup
tags:
  - setup
  - apple-intelligence
  - workflow
---

# AI Route — Apple Shortcut Setup

The **🍎 AI Route** button on the Dashboard opens an Apple Shortcut called **"Navigate Daily Note"**. You need to create this once in the Shortcuts app.

## What it does

1. Reads the content of today's daily note from the vault
2. Sends it to Apple Intelligence with a classification prompt
3. Appends the classified content (tasks, ideas, notes) to the right project files in the vault

## Shortcut Steps

In **Shortcuts.app**, create a new shortcut named exactly: `Navigate Daily Note`

### Steps:

1. **Get File** → `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/quartz/content/Journal/Studio/Active/[today's date].md`
   - Use a **Format Date** action first to get `YYYY-MM-DD`, then concatenate to build the path

2. **Get Text from Input** (get the file contents as text)

3. **Summarize** *(Apple Intelligence action)* → with prompt:
   ```
   Read this daily note and identify:
   - Tasks (lines starting with - [ ])
   - Which Star Sailors project each item belongs to (Star Sailors, Experiment 1, Bumble, Coral, Saily, or Other)
   - Ideas vs tasks vs notes

   Output a JSON object like:
   {"project": "Experiment-1", "type": "task", "content": "..."}
   for each item found.
   ```

4. **Run Script Over SSH** or **Run Shell Script** (if on Mac) to call a routing script, OR

   **Simpler alternative:** Use **Append to File** to write the classified output to:
   `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/quartz/content/Studio/Inbox/AI-Inbox.md`

5. The `organize-daily.js` script (triggered by **🏷️ AutoTag + Route**) can then read from the AI-Inbox and route accordingly.

## Simpler Version (Dock Widget)

If you just want a quick capture → AI classify flow without Obsidian being open:

1. Create a Shortcut that shows a **text input** prompt
2. Sends the text to **Apple Intelligence** for classification
3. Appends the result to `content/Studio/Inbox/AI-Inbox.md`
4. Add this Shortcut to your Dock via **right-click → Keep in Dock** in Launchpad

## Current Routing (without AI)

The existing **🏷️ AutoTag + Route** button uses keyword matching and routes to:
- Tasks → `content/Builds/<Project>/Tasks/YYYY-MM-DD.md`
- Notes → `content/Journal/<Project>/YYYY-MM-DD.md`
- Ideas → `content/Ideas/<Project>/YYYY-MM-DD.md`

The Apple Intelligence version would do the same routing but with semantic understanding rather than keyword matching.
