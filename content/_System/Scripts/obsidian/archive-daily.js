// Archive Daily Notes - Move content from persistent dashboard to dated archive
// Usage: Call via button at end of day

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    
    // Get the persistent daily dashboard
    const dashboardPath = 'content/_Daily/Dashboard.md';
    const dashboardFile = app.vault.getAbstractFileByPath(dashboardPath);
    
    if (!dashboardFile) {
        new Notice("❌ Dashboard.md not found");
        return;
    }
    
    // Read dashboard content
    const content = await app.vault.read(dashboardFile);
    const lines = content.split('\n');
    
    // Extract sections with content
    const sections = {
        thoughts: [],
        meetings: [],
        ideas: [],
        tasks: []
    };
    
    let currentSection = null;
    let inContent = false;
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        
        // Detect section headers - stop at level 2 headers only
        if (line.startsWith('## ') && !line.includes('Today\'s Notes Dump')) {
            // Hit a new main section, stop collecting
            inContent = false;
            currentSection = null;
        }
        
        // Detect our content sections
        if (line.includes('### Quick Thoughts')) {
            currentSection = 'thoughts';
            inContent = true;
            continue;
        } else if (line.includes('### Meetings & Conversations')) {
            currentSection = 'meetings';
            inContent = true;
            continue;
        } else if (line.includes('### Ideas & Brainstorming')) {
            currentSection = 'ideas';
            inContent = true;
            continue;
        } else if (line.includes('### Tasks to Route')) {
            currentSection = 'tasks';
            inContent = true;
            continue;
        } else if (line.startsWith('---') && inContent) {
            // Separator after content sections, stop collecting
            inContent = false;
            currentSection = null;
        }
        
        // Collect ALL content in the section
        if (inContent && currentSection) {
            const trimmed = line.trim();
            // Skip only the instruction lines that start with >
            if (!trimmed.startsWith('>')) {
                sections[currentSection].push(line);
            }
        }
    }
    
    // Check if there's any content to archive
    const hasContent = Object.values(sections).some(arr => arr.length > 0);
    
    if (!hasContent) {
        new Notice("📭 No content to archive");
        return;
    }
    
    // Ask if archiving today or yesterday
    const archiveToday = await tp.system.prompt("Archive to today's date? (yes/no):");
    
    let archiveDate;
    if (archiveToday?.toLowerCase() === 'yes') {
        archiveDate = tp.date.now("YYYY-MM-DD");
    } else {
        archiveDate = tp.date.now("YYYY-MM-DD", -1); // Yesterday
    }
    
    const archivePath = `content/_Daily/${archiveDate}.md`;
    
    // Build archive content
    let archiveContent = `---
title: Daily Notes
date: ${archiveDate}
tags:
  - daily
  - archive
icon: lucide//calendar-days
---

# 📅 Daily Notes - ${archiveDate}

`;

    // Add sections that have content
    if (sections.thoughts.length > 0) {
        archiveContent += `## 💭 Quick Thoughts\n\n${sections.thoughts.join('\n')}\n\n`;
    }
    
    if (sections.meetings.length > 0) {
        archiveContent += `## 🗣️ Meetings & Conversations\n\n${sections.meetings.join('\n')}\n\n`;
    }
    
    if (sections.ideas.length > 0) {
        archiveContent += `## 💡 Ideas & Brainstorming\n\n${sections.ideas.join('\n')}\n\n`;
    }
    
    if (sections.tasks.length > 0) {
        archiveContent += `## ✅ Tasks\n\n${sections.tasks.join('\n')}\n\n`;
    }
    
    archiveContent += `---\n\n*Archived from Daily Dashboard on ${archiveDate}*`;
    
    // Create or update archive file
    let archiveFile = app.vault.getAbstractFileByPath(archivePath);
    
    if (archiveFile) {
        // File exists, confirm overwrite
        const confirm = await tp.system.prompt(`Archive file for ${archiveDate} already exists. Append? (yes/no):`);
        if (confirm?.toLowerCase() === 'yes') {
            const existing = await app.vault.read(archiveFile);
            await app.vault.modify(archiveFile, existing + '\n\n---\n\n' + archiveContent);
        } else {
            new Notice("❌ Archive cancelled");
            return;
        }
    } else {
        // Create new archive file
        await app.vault.create(archivePath, archiveContent);
        archiveFile = app.vault.getAbstractFileByPath(archivePath);
    }
    
    // Overwrite dashboard with template content
    const templatePath = 'content/_Daily/Dashboard-Template.md';
    const templateFile = app.vault.getAbstractFileByPath(templatePath);
    
    if (!templateFile) {
        new Notice("❌ Dashboard-Template.md not found");
        return;
    }
    
    const templateContent = await app.vault.read(templateFile);
    
    try {
        await app.vault.modify(dashboardFile, templateContent);
        new Notice(`✅ Archived to ${archiveDate}.md and dashboard reset`);
    } catch (error) {
        new Notice(`❌ Failed to reset dashboard: ${error.message}`);
        return;
    }
    
    // Open the archive file then navigate back to dashboard
    const archiveLeaf = app.workspace.getLeaf(false);
    await archiveLeaf.openFile(archiveFile);
    
    // Wait a moment then open dashboard to show it's been cleared
    setTimeout(async () => {
        const dashboardLeaf = app.workspace.getLeaf(false);
        const refreshedDashboard = app.vault.getAbstractFileByPath(dashboardPath);
        if (refreshedDashboard) {
            await dashboardLeaf.openFile(refreshedDashboard);
        }
    }, 500);
}
