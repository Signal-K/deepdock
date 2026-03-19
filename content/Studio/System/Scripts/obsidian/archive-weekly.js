/**
 * Weekly Archive Script
 * 
 * Archives all documents from the previous week (Sunday-Saturday)
 * into a structured folder: _Archive/YYYY/Week-MM-DD/
 */

async function archiveWeekly(tp) {
    const app = this.app || tp.app;
    const moment = window.moment;
    
    // Get previous week's dates (Sunday to Saturday)
    const today = moment();
    const lastSunday = today.clone().subtract(1, 'week').startOf('week');
    const lastSaturday = lastSunday.clone().endOf('week');
    
    const weekLabel = `${lastSunday.format('MMM DD')} - ${lastSaturday.format('MMM DD, YYYY')}`;
    
    // Confirm with user
    const confirmed = await tp.system.prompt(
        `Archive all documents from last week (${weekLabel})?\n\nType 'yes' to confirm:`,
        "no"
    );
    
    if (confirmed.toLowerCase() !== 'yes') {
        new Notice('❌ Archive cancelled');
        return;
    }
    
    new Notice(`📦 Archiving files from ${weekLabel}...`);
    
    // Create archive folder structure
    const year = lastSunday.format('YYYY');
    const weekFolder = `Week-${lastSunday.format('MM-DD')}`;
    const archivePath = `content/_Archive/${year}/${weekFolder}`;
    
    // Ensure archive folder exists
    try {
        await app.vault.createFolder(archivePath);
    } catch (error) {
        // Folder might already exist, that's okay
        if (!error.message.includes('already exists')) {
            console.error('Error creating archive folder:', error);
        }
    }
    
    // Get all markdown files
    const allFiles = app.vault.getMarkdownFiles();
    const filesToArchive = [];
    
    // Filter files modified during previous week
    for (const file of allFiles) {
        // Skip files already in _Archive
        if (file.path.startsWith('content/_Archive')) {
            continue;
        }
        
        // Skip system files
        if (file.path.startsWith('content/_System')) {
            continue;
        }
        
        const fileMoment = moment(file.stat.mtime);
        
        // Check if file was modified during previous week
        if (fileMoment.isBetween(lastSunday, lastSaturday, null, '[]')) {
            filesToArchive.push(file);
        }
    }
    
    if (filesToArchive.length === 0) {
        new Notice('⚠️ No files found from last week to archive');
        return;
    }
    
    // Archive files
    let successCount = 0;
    let errorCount = 0;
    const archivedFiles = [];
    
    for (const file of filesToArchive) {
        try {
            // Get relative path from content/
            const relativePath = file.path.replace('content/', '');
            
            // Determine subfolder structure
            let targetFolder = archivePath;
            
            // Preserve some folder structure
            if (file.path.startsWith('content/_Daily/')) {
                targetFolder = `${archivePath}/Daily`;
            } else if (file.path.startsWith('content/_Tasks/')) {
                targetFolder = `${archivePath}/Tasks`;
            } else if (file.path.startsWith('content/_Sprints/')) {
                targetFolder = `${archivePath}/Sprints`;
            } else if (file.path.startsWith('content/_Inbox/')) {
                targetFolder = `${archivePath}/Inbox`;
            } else if (file.path.startsWith('content/Boards/')) {
                targetFolder = `${archivePath}/Boards`;
            } else {
                targetFolder = `${archivePath}/Other`;
            }
            
            // Create subfolder if needed
            try {
                await app.vault.createFolder(targetFolder);
            } catch (error) {
                // Folder might exist, that's fine
            }
            
            // Generate target path
            const targetPath = `${targetFolder}/${file.name}`;
            
            // Check if file already exists at target
            const existingFile = app.vault.getAbstractFileByPath(targetPath);
            if (existingFile) {
                // Add timestamp to avoid collision
                const timestamp = moment().format('HHmmss');
                const newName = file.basename + `-${timestamp}.md`;
                const uniquePath = `${targetFolder}/${newName}`;
                await app.fileManager.renameFile(file, uniquePath);
            } else {
                await app.fileManager.renameFile(file, targetPath);
            }
            
            successCount++;
            archivedFiles.push({
                original: file.path,
                archived: targetPath
            });
            
        } catch (error) {
            console.error(`Error archiving ${file.path}:`, error);
            errorCount++;
        }
    }
    
    // Create archive summary
    const summaryDate = moment().format('YYYY-MM-DD');
    const summaryPath = `${archivePath}/Archive-Summary.md`;
    
    const summaryContent = `---
title: Archive Summary
date: ${summaryDate}
archived_week: ${lastSunday.format('YYYY-MM-DD')} to ${lastSaturday.format('YYYY-MM-DD')}
tags:
  - archive
  - weekly-archive
icon: lucide//archive
---

# 📦 Archive Summary - ${weekLabel}

**Archived on:** ${moment().format('YYYY-MM-DD HH:mm')}  
**Files archived:** ${successCount}  
**Errors:** ${errorCount}

---

## 📁 Archived Files

${archivedFiles.map(f => `- [[${f.archived.replace('content/', '')}|${f.archived.split('/').pop()}]]\n  *Originally: ${f.original}*`).join('\n\n')}

---

## 📊 Archive Statistics

- **Total files:** ${successCount}
- **Daily notes:** ${archivedFiles.filter(f => f.archived.includes('/Daily/')).length}
- **Tasks:** ${archivedFiles.filter(f => f.archived.includes('/Tasks/')).length}
- **Sprints:** ${archivedFiles.filter(f => f.archived.includes('/Sprints/')).length}
- **Boards:** ${archivedFiles.filter(f => f.archived.includes('/Boards/')).length}
- **Other:** ${archivedFiles.filter(f => f.archived.includes('/Other/')).length}

---

## 🔍 Quick Navigation

- [[_Archive/${year}|${year} Archive]]
- [[_Daily/Dashboard|Return to Dashboard]]

---

*Archived by Weekly Archive Script*
`;

    try {
        await app.vault.create(summaryPath, summaryContent);
    } catch (error) {
        console.error('Error creating summary:', error);
    }
    
    // Show completion message
    new Notice(`✅ Archived ${successCount} files from last week!`);
    
    // Open summary
    const summaryFile = app.vault.getAbstractFileByPath(summaryPath);
    if (summaryFile) {
        await app.workspace.getLeaf().openFile(summaryFile);
    }
    
    console.log(`Archive complete: ${successCount} files archived, ${errorCount} errors`);
}

module.exports = archiveWeekly;
