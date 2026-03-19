// Quick Task Creator - Create task and route to segment
// Usage: Call via button or command

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    
    // Prompt for task details
    const taskText = await tp.system.prompt("Task description:");
    if (!taskText) return;
    
    const project = await tp.system.suggester(
        ['⭐ Star Sailors', '🐝 Bumble', '🎮 Godot Mars', '🏃 Roving', '🏠 Station 198', '📋 General'],
        ['star-sailors', 'bumble', 'godot-mars', 'roving', 'station-198', 'general']
    );
    if (!project) return;
    
    // Get segments for the project
    const projectFolder = project === 'general' ? 'content/_Tasks/General' : `content/_Tasks/${project.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join('-')}`;
    let segmentFiles = app.vault.getMarkdownFiles().filter(f => 
        f.path.startsWith(projectFolder + '/') && 
        f.path.includes('Segment-')
    );
    
    let segment;
    
    if (segmentFiles.length === 0) {
        // No segments found - offer to create one
        const createNew = await tp.system.suggester(
            ['📝 Create New Segment', '❌ Cancel'],
            [true, false]
        );
        
        if (!createNew) return;
        
        // Prompt for segment name
        const segmentName = await tp.system.prompt("Enter segment name:");
        if (!segmentName) return;
        
        const status = await tp.system.suggester(
            ['📋 In Progress', '📅 Planned', '✅ Completed'],
            ['in-progress', 'planned', 'completed']
        );
        if (!status) return;
        
        // Create the segment file
        const projectName = project.split('-').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join('-');
        const segmentFileName = `Segment-${segmentName.replace(/\s+/g, '-')}`;
        const segmentPath = `${projectFolder}/${segmentFileName}.md`;
        
        const segmentContent = `---
type: segment
project: ${projectName}
segment: ${segmentName}
isNext: true
status: ${status}
---

# ${segmentName}

## 📋 Tasks

**⏫ High Priority**

**🔼 Medium Priority**

**🔽 Low Priority**

---

**Segment Notes:**
`;
        
        await app.vault.create(segmentPath, segmentContent);
        new Notice(`✅ Created segment: ${segmentName}`);
        
        // Get the newly created file
        segment = app.vault.getAbstractFileByPath(segmentPath);
    } else {
        // Read segment metadata
        const segments = await Promise.all(segmentFiles.map(async f => {
            const cache = app.metadataCache.getFileCache(f);
            const segmentName = cache?.frontmatter?.segment || f.basename;
            const isNext = cache?.frontmatter?.isNext || false;
            return { file: f, name: segmentName, isNext };
        }));
        
        // Sort: isNext first, then alphabetically
        segments.sort((a, b) => {
            if (a.isNext && !b.isNext) return -1;
            if (!a.isNext && b.isNext) return 1;
            return a.name.localeCompare(b.name);
        });
        
        segment = await tp.system.suggester(
            segments.map(s => `${s.isNext ? '▶️ ' : ''}${s.name}${s.isNext ? ' (current)' : ''}`),
            segments.map(s => s.file)
        );
    }
    if (!segment) return;
    
    // Get segment metadata for task
    const cache = app.metadataCache.getFileCache(segment);
    const segmentName = cache?.frontmatter?.segment || segment.basename;
    
    const priority = await tp.system.suggester(
        ['⏫ High', '🔼 Medium', '🔽 Low'],
        ['high', 'medium', 'low']
    );
    if (!priority) return;
    
    // Prompt for due date
    const dueDateInput = await tp.system.prompt("Due date (t=today, to=tomorrow, or press Enter for none):");
    
    let dueDate = '';
    let startDate = '';
    const today = tp.date.now("YYYY-MM-DD");
    
    if (dueDateInput) {
        const input = dueDateInput.toLowerCase().trim();
        if (input === 't') {
            dueDate = ` 📅 ${today}`;
            startDate = ` 🛫 ${today}`;
        } else if (input === 'to') {
            const tomorrow = tp.date.now("YYYY-MM-DD", 1);
            dueDate = ` 📅 ${tomorrow}`;
            startDate = ` 🛫 ${today}`;
        }
    }
    
    const createdDate = ` ➕ ${today}`;
    
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
    
    // Create task with appropriate tags and metadata
    const priorityEmoji = priority === 'high' ? '⏫' : priority === 'medium' ? '🔼' : '🔽';
    const fullTask = `- [ ] ${taskText} ${priorityEmoji} 🆔 ${taskId}${createdDate}${startDate}${dueDate} 📋 ${segmentName}`;
    
    // Read segment file content
    let content = await app.vault.read(segment);
    
    // Try to find a priority section to add to
    const priorityMarker = priority === 'high' ? '⏫ High Priority' : 
                          priority === 'medium' ? '🔼 Medium Priority' : 
                          '🔽 Low Priority';
    
    // Look for existing priority section
    const priorityRegex = new RegExp(`\\*\\*${priorityMarker}\\*\\*`, 'i');
    
    if (priorityRegex.test(content)) {
        // Add after the priority marker
        content = content.replace(
            priorityRegex,
            `**${priorityMarker}**\n${fullTask}`
        );
    } else {
        // Add at the end of file
        content += `\n\n**${priorityMarker}**\n${fullTask}`;
    }
    
    await app.vault.modify(segment, content);
    
    // Show success message
    let successMsg = `✅ Task added to ${segmentName} (ID: ${taskId})`;
    
    new Notice(successMsg);
    
    // Open segment file
    const leaf = app.workspace.getLeaf(false);
    await leaf.openFile(segment);
}
