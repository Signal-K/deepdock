// Sync tasks from Knowns project into Obsidian
// Shows unsynced tasks and lets you select which ones to import and where

const fs = require('fs');
const path = require('path');

// Paths
const KNOWNS_TASKS_DIR = '/Users/scroobz/Navigation/Native/planet-hunters-experiment-1/.knowns/tasks';
const VAULT_PATH = '/Users/scroobz/Navigation/quartz/content';

/**
 * Parse a task file and extract metadata + content
 */
function parseTaskFile(filePath) {
    const content = fs.readFileSync(filePath, 'utf-8');
    const lines = content.split('\n');
    
    if (!lines[0].includes('---')) return null;
    
    let endFrontmatter = -1;
    for (let i = 1; i < lines.length; i++) {
        if (lines[i].includes('---')) {
            endFrontmatter = i;
            break;
        }
    }
    
    if (endFrontmatter === -1) return null;
    
    const frontmatterText = lines.slice(1, endFrontmatter).join('\n');
    const bodyText = lines.slice(endFrontmatter + 1).join('\n');
    
    const frontmatter = {
        id: '',
        title: '',
        status: '',
        priority: '',
        labels: [],
        createdAt: '',
        updatedAt: '',
        timeSpent: 0
    };
    
    const yamlLines = frontmatterText.split('\n');
    for (let i = 0; i < yamlLines.length; i++) {
        const line = yamlLines[i];
        if (line.startsWith('id:')) {
            frontmatter.id = line.replace('id:', '').trim().replace(/'/g, '').replace(/"/g, '');
        } else if (line.startsWith('title:')) {
            frontmatter.title = line.replace('title:', '').trim().replace(/'/g, '').replace(/"/g, '');
        } else if (line.startsWith('status:')) {
            frontmatter.status = line.replace('status:', '').trim();
        } else if (line.startsWith('priority:')) {
            frontmatter.priority = line.replace('priority:', '').trim();
        } else if (line.startsWith('createdAt:')) {
            frontmatter.createdAt = line.replace('createdAt:', '').trim().replace(/'/g, '').replace(/"/g, '');
        } else if (line.startsWith('updatedAt:')) {
            frontmatter.updatedAt = line.replace('updatedAt:', '').trim().replace(/'/g, '').replace(/"/g, '');
        } else if (line.startsWith('timeSpent:')) {
            frontmatter.timeSpent = parseInt(line.replace('timeSpent:', '').trim()) || 0;
        } else if (line.startsWith('labels:')) {
            let labelIdx = i + 1;
            while (labelIdx < yamlLines.length && yamlLines[labelIdx].startsWith('  - ')) {
                frontmatter.labels.push(yamlLines[labelIdx].replace('  - ', '').trim());
                labelIdx++;
            }
        }
    }
    
    return {
        filename: path.basename(filePath),
        frontmatter,
        body: bodyText.trim()
    };
}

/**
 * Read all tasks from knowns project
 */
function getAllKnownsTasks() {
    if (!fs.existsSync(KNOWNS_TASKS_DIR)) {
        return [];
    }
    
    const files = fs.readdirSync(KNOWNS_TASKS_DIR);
    const tasks = [];
    
    for (const file of files) {
        if (!file.endsWith('.md')) continue;
        
        const filePath = path.join(KNOWNS_TASKS_DIR, file);
        const task = parseTaskFile(filePath);
        if (task) {
            tasks.push(task);
        }
    }
    
    return tasks;
}

/**
 * Check if a task ID is mentioned anywhere in the vault
 */
function isTaskMentionedInVault(taskId) {
    function searchDirectory(dir) {
        try {
            const files = fs.readdirSync(dir);
            
            for (const file of files) {
                const filePath = path.join(dir, file);
                
                if (file.startsWith('.')) continue;
                
                const stat = fs.statSync(filePath);
                
                if (stat.isDirectory()) {
                    if (searchDirectory(filePath)) return true;
                } else if (file.endsWith('.md')) {
                    try {
                        const content = fs.readFileSync(filePath, 'utf-8');
                        if (content.includes(taskId)) {
                            return true;
                        }
                    } catch (e) {
                        // Skip
                    }
                }
            }
        } catch (e) {
            // Skip
        }
        
        return false;
    }
    
    return searchDirectory(VAULT_PATH);
}

/**
 * Get unsynced tasks
 */
function getUnsyncedTasks() {
    const allTasks = getAllKnownsTasks();
    return allTasks.filter(task => !isTaskMentionedInVault(task.frontmatter.id));
}

/**
 * Format a task for Obsidian insertion
 */
function formatTaskForObsidian(task) {
    const fm = task.frontmatter;
    
    let labelsYaml = '';
    if (fm.labels && fm.labels.length > 0) {
        labelsYaml = '\nlabels:\n' + fm.labels.map(l => `  - ${l}`).join('\n');
    }
    
    const frontmatter = `---
id: ${fm.id}
title: ${fm.title}
status: ${fm.status}
priority: ${fm.priority}${labelsYaml}
createdAt: '${fm.createdAt}'
updatedAt: '${fm.updatedAt}'
timeSpent: ${fm.timeSpent}
---`;
    
    return `${frontmatter}\n\n# ${fm.title}\n\n${task.body}`;
}

/**
 * Format a task as an Obsidian task list item
 */
function formatTaskAsObsidianItem(task) {
    const fm = task.frontmatter;
    const statusEmoji = fm.status === 'done' ? '✅' : 
                       fm.status === 'in-progress' ? '⏳' : '📋';
    const priorityEmoji = fm.priority === 'high' ? '🔴' : 
                         fm.priority === 'medium' ? '🟡' : '🟢';
    
    // Format: - [ ] [id] [emoji] Title - status
    const checked = fm.status === 'done' ? 'x' : ' ';
    return `- [${checked}] [${fm.id}] ${priorityEmoji} ${fm.title} (${fm.status})`;
}

module.exports = async function(tp, appContext) {
    const app = appContext || tp.app;
    
    try {
        // Get unsynced tasks
        const unsyncedTasks = getUnsyncedTasks();
        
        if (unsyncedTasks.length === 0) {
            await tp.system.prompt('✅ No unsynced tasks! All knowns tasks are already mentioned in the vault.');
            return;
        }
        
        // Get all markdown files
        const markdownFiles = app.vault.getMarkdownFiles();
        
        if (markdownFiles.length === 0) {
            await tp.system.prompt('❌ No markdown files found in vault.');
            return;
        }
        
        // Create display list and file mapping
        const fileDisplays = markdownFiles.map(f => f.path);
        
        // Use suggester - returns the selected file path
        const selectedPath = await tp.system.suggester(
            fileDisplays,
            fileDisplays
        );
        
        if (!selectedPath) {
            await tp.system.prompt('❌ No file selected');
            return;
        }
        
        // Find the selected file
        const targetFile = markdownFiles.find(f => f.path === selectedPath);
        
        if (!targetFile) {
            await tp.system.prompt('❌ File not found');
            return;
        }
        
        // Read existing file content
        let fileContent = await app.vault.read(targetFile);
        
        // Format all tasks as Obsidian task list items
        const taskItems = unsyncedTasks.map(task => formatTaskAsObsidianItem(task)).join('\n');
        
        // Add tasks to file (append with section header)
        const newContent = fileContent + '\n\n## Synced from Knowns\n\n' + taskItems;
        
        await app.vault.modify(targetFile, newContent);
        
        await tp.system.prompt(`✅ Added ${unsyncedTasks.length} task(s) to ${targetFile.name}`);
    } catch (error) {
        console.error('Error:', error);
        await tp.system.prompt(`❌ Error: ${error.message}`);
    }
};


