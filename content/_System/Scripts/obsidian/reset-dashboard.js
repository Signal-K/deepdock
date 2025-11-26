// Reset Dashboard - Archive current dashboard and create fresh one
// Usage: Call via button on Dashboard-Template.md

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    
    const dashboardPath = 'content/_Daily/Dashboard.md';
    const templatePath = 'content/_Daily/Dashboard-Template.md';
    
    // Check if dashboard exists
    const dashboardFile = app.vault.getAbstractFileByPath(dashboardPath);
    
    if (dashboardFile) {
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
                inContent = false;
                currentSection = null;
            }
            
            // Collect ALL content in the section
            if (inContent && currentSection) {
                const trimmed = line.trim();
                if (!trimmed.startsWith('>')) {
                    sections[currentSection].push(line);
                }
            }
        }
        
        // Check if there's any content to archive
        const hasContent = Object.values(sections).some(arr => arr.length > 0);
        
        if (hasContent) {
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
                const confirm = await tp.system.prompt(`Archive file for ${archiveDate} already exists. Append? (yes/no):`);
                if (confirm?.toLowerCase() === 'yes') {
                    const existing = await app.vault.read(archiveFile);
                    await app.vault.modify(archiveFile, existing + '\n\n---\n\n' + archiveContent);
                } else {
                    new Notice("❌ Archive cancelled");
                    return;
                }
            } else {
                await app.vault.create(archivePath, archiveContent);
            }
            
            new Notice(`📦 Content archived to ${archiveDate}.md`);
        }
        
        // Delete existing dashboard
        try {
            await app.vault.delete(dashboardFile);
        } catch (error) {
            new Notice(`❌ Error deleting dashboard: ${error.message}`);
            return;
        }
    }
    
    // Get template file
    const templateFile = app.vault.getAbstractFileByPath(templatePath);
    if (!templateFile) {
        new Notice("❌ Dashboard-Template.md not found");
        return;
    }
    
    // Read template content
    const templateContent = await app.vault.read(templateFile);
    
    // Create new dashboard from template
    try {
        const newDashboard = await app.vault.create(dashboardPath, templateContent);
        new Notice("✅ Dashboard reset successfully");
        
        // Open the new dashboard
        const leaf = app.workspace.getLeaf(false);
        await leaf.openFile(newDashboard);
    } catch (error) {
        new Notice(`❌ Error creating dashboard: ${error.message}`);
    }
}
