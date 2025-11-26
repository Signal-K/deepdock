// New Sprint Creator
// Creates a new sprint file with template

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    
    // Prompt for sprint number
    const sprintNum = await tp.system.prompt("Sprint number (e.g., 296):");
    if (!sprintNum) return;
    
    const sprintId = `SSG-${sprintNum}`;
    const sprintPath = `content/_Sprints/Active/${sprintId}.md`;
    
    // Check if already exists
    const existing = app.vault.getAbstractFileByPath(sprintPath);
    if (existing) {
        new Notice("Sprint already exists!");
        const leaf = app.workspace.getLeaf(false);
        await leaf.openFile(existing);
        return;
    }
    
    // Create sprint content
    const today = tp.date.now("YYYY-MM-DD");
    const content = `---
tags:
  - ${sprintId}
  - Sprint
  - Active
created: ${today}
---

# ${sprintId}

**Sprint:** ${sprintId}  
**Start Date:** ${today}  
**Status:** 🟢 Active

## 🎯 Sprint Goals

1. 
2. 
3. 

## 📋 Epic: [Epic Name]

**Goal:** 

### Story 1: [Story Name]

**Tasks:**
- [ ] 

### Story 2: [Story Name]

**Tasks:**
- [ ] 

## 📝 Daily Notes

### ${today}


## ✅ Completed

---

## 🖼️ Media

<!-- Add images here -->

---

*Sprint created: ${today}*
`;
    
    // Create file
    const file = await app.vault.create(sprintPath, content);
    
    new Notice(`✅ Created ${sprintId}`);
    
    // Open new sprint
    const leaf = app.workspace.getLeaf(false);
    await leaf.openFile(file);
}
