// Quick Task Creator - Create task and route to project
// Usage: Call via button or command

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    
    // Prompt for task details
    const taskText = await tp.system.prompt("Task description:");
    if (!taskText) return;
    
    const project = await tp.system.suggester(
        ['⭐ Star Sailors', '🐝 Bumble', '🏃 Roving', '🏠 Station 198', '📋 General'],
        ['star-sailors', 'bumble', 'roving', 'station-198', 'general']
    );
    if (!project) return;
    
    const priority = await tp.system.suggester(
        ['⏫ High', '🔼 Medium', '🔽 Low'],
        ['high', 'medium', 'low']
    );
    if (!priority) return;
    
    // Generate unique ID
    function generateId() {
        const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
        let id = '';
        for (let i = 0; i < 6; i++) {
            id += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return id;
    }
    
    const taskId = generateId();
    
    // Create task with appropriate tags and ID
    const priorityEmoji = priority === 'high' ? '⏫' : priority === 'medium' ? '🔼' : '🔽';
    const fullTask = `- [ ] ${taskText} ${priorityEmoji} 🆔 ${taskId}`;
    
    // Add to project file
    const projectPath = `content/_Tasks/Projects/${project}.md`;
    let file = app.vault.getAbstractFileByPath(projectPath);
    
    if (!file) {
        // Create project file
        const projectName = project.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
        const content = `# ${projectName} Tasks

## High Priority

## Medium Priority

## Low Priority
`;
        await app.vault.create(projectPath, content);
        file = app.vault.getAbstractFileByPath(projectPath);
    }
    
    // Read and update content
    let content = await app.vault.read(file);
    const sectionHeader = `## ${priority.charAt(0).toUpperCase() + priority.slice(1)} Priority`;
    
    if (content.includes(sectionHeader)) {
        content = content.replace(
            sectionHeader,
            `${sectionHeader}\n${fullTask}`
        );
    } else {
        content += `\n${fullTask}`;
    }
    
    await app.vault.modify(file, content);
    
    new Notice(`✅ Task added to ${project} (ID: ${taskId})`);
}
