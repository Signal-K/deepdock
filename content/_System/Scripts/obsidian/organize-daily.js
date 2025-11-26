// Organize Daily Notes - Extract tasks and route to projects
// Usage: Place in .obsidian/scripts/ and call via Templater or Buttons

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    const currentFile = app.workspace.getActiveFile();
    
    if (!currentFile) {
        new Notice("No active file");
        return;
    }
    
    // Read current content
    const content = await app.vault.read(currentFile);
    const lines = content.split('\n');
    
    // Parse tasks
    const tasks = [];
    const taskPattern = /^[\-\*\+]\s*\[([ xX])\]\s*(.+)$/;
    
    for (let i = 0; i < lines.length; i++) {
        const match = lines[i].trim().match(taskPattern);
        if (match) {
            const completed = match[1].toLowerCase() === 'x';
            const text = match[2];
            
            // Extract project tags
            const project = detectProject(text);
            
            tasks.push({
                line: i,
                completed,
                text,
                project,
                priority: extractPriority(text)
            });
        }
    }
    
    if (tasks.length === 0) {
        new Notice("No tasks found");
        return;
    }
    
    // Route tasks to project files
    let moved = 0;
    for (const task of tasks) {
        if (task.project !== 'unknown' && !task.completed) {
            await addTaskToProject(app, task);
            moved++;
        }
    }
    
    new Notice(`✅ Organized ${moved} tasks to projects`);
}

function detectProject(text) {
    const textLower = text.toLowerCase();
    
    if (textLower.includes('star-sailors') || textLower.includes('#ss') || 
        textLower.includes('telescope') || textLower.includes('satellite')) {
        return 'star-sailors';
    }
    if (textLower.includes('bumble') || textLower.includes('#bumble') || 
        textLower.includes('bee') || textLower.includes('pollinator')) {
        return 'bumble';
    }
    if (textLower.includes('roving') || textLower.includes('#roving')) {
        return 'roving';
    }
    if (textLower.includes('station') || textLower.includes('#station')) {
        return 'station-198';
    }
    
    return 'unknown';
}

function extractPriority(text) {
    // Check for ⏫ (high), 🔼 (medium), 🔽 (low) or #high-priority
    if (text.includes('⏫') || text.includes('#high-priority')) return 'high';
    if (text.includes('🔼')) return 'medium';
    if (text.includes('🔽')) return 'low';
    
    // Check for explicit priority: #p1, #p2, etc
    const priorityMatch = text.match(/#p([1-5])/);
    if (priorityMatch) {
        const p = parseInt(priorityMatch[1]);
        if (p === 1) return 'high';
        if (p <= 3) return 'medium';
        return 'low';
    }
    
    return 'medium';
}

async function addTaskToProject(app, task) {
    const projectPath = `content/_Tasks/Projects/${task.project}.md`;
    const file = app.vault.getAbstractFileByPath(projectPath);
    
    if (!file) {
        // Create project task file
        const content = `# ${task.project.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ')} Tasks

## High Priority

## Medium Priority

## Low Priority
`;
        await app.vault.create(projectPath, content);
    }
    
    // Read project file
    const projectFile = app.vault.getAbstractFileByPath(projectPath);
    let content = await app.vault.read(projectFile);
    
    // Add task under appropriate priority section
    const sectionHeader = `## ${task.priority.charAt(0).toUpperCase() + task.priority.slice(1)} Priority`;
    const taskLine = `- [ ] ${task.text}`;
    
    if (content.includes(sectionHeader)) {
        // Add after section header
        content = content.replace(
            sectionHeader,
            `${sectionHeader}\n${taskLine}`
        );
    } else {
        // Append at end
        content += `\n${taskLine}`;
    }
    
    await app.vault.modify(projectFile, content);
}
