// Reset Dashboard - Create a new dashboard file with today's date
// Usage: Call via button on Dashboard-Template.md

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;
    
    const templatePath = 'content/_Daily/Dashboard-Template.md';

    // Get template file and content
    const templateFile = app.vault.getAbstractFileByPath(templatePath);
    if (!templateFile) {
        new Notice("❌ Dashboard-Template.md not found");
        return;
    }
    const templateContent = await app.vault.read(templateFile);

    // Create today's dated file
    const todayDate = tp.date.now("YYYY-MM-DD");
    const todayPath = `content/_Daily/${todayDate}.md`;
    const existingToday = app.vault.getAbstractFileByPath(todayPath);
    
    if (existingToday) {
        new Notice(`ℹ️ Today's daily already exists: ${todayPath}`);
        const leaf = app.workspace.getLeaf(false);
        await leaf.openFile(existingToday);
        return;
    }

    try {
        // Process template variables
        let processedContent = templateContent
            .replace(/\{\{date:YYYY-MM-DD\}\}/g, todayDate)
            .replace(/\{\{date:YYYY-MM-DD\}\}/g, todayDate);
        
        const created = await app.vault.create(todayPath, processedContent);
        new Notice(`✅ Created today's daily: ${todayPath}`);
        const leaf = app.workspace.getLeaf(false);
        await leaf.openFile(created);
    } catch (err) {
        new Notice(`❌ Error creating today's daily: ${err.message}`);
    }
}


