// Archive Daily Notes - Move content from persistent dashboard to dated archive
// Usage: Call via button at end of day

module.exports = async function(tp, appContext) {
    const app = appContext || this.app || tp.app;

    // Prompt user for comma-separated day numbers to KEEP (e.g., "29,30,31").
    const input = await tp.system.prompt("Enter comma-separated day numbers to KEEP (e.g. 29,30,31). Leave empty to archive all:", "");
    if (input === null) {
        new Notice('❌ Archive cancelled');
        return;
    }

    const keepDays = input
        .split(',')
        .map(s => s.trim())
        .filter(Boolean)
        .map(s => (s.length === 1 ? `0${s}` : s)) // normalize single digit to 0X
        .map(s => s.padStart(2, '0'));

    // Get all markdown files in content/_Daily
    const allFiles = app.vault.getMarkdownFiles();
    const dailyFiles = allFiles.filter(f => f.path.startsWith('content/_Daily/'));

    // Use regex to match YYYY-MM-DD.md
    const dailyRe = /content\/_Daily\/(\d{4})-(\d{2})-(\d{2})\.md$/;

    let toArchive = [];

    for (const file of dailyFiles) {
        const m = file.path.match(dailyRe);
        if (!m) continue;
        const [_, year, month, day] = m;
        // Skip Dashboard, templates, and archive folder
        const basename = file.name;
        if (basename === 'Dashboard.md' || basename === 'Dashboard-Template.md') continue;
        if (file.path.includes('/Archive/')) continue;

        if (keepDays.length > 0 && keepDays.includes(day)) {
            // keep this file
            continue;
        }

        toArchive.push({file, year, month, day});
    }

    if (toArchive.length === 0) {
        new Notice('⚠️ No files to archive (all matched keep days).');
        return;
    }

    // If any items are in the current month, ask for an explicit second confirmation
    const now = new Date();
    const currYear = String(now.getFullYear());
    const currMonth = String(now.getMonth() + 1).padStart(2, '0');
    const hasCurrentMonth = toArchive.some(i => i.year === currYear && i.month === currMonth);
    if (hasCurrentMonth) {
        const confirmCurrent = await tp.system.prompt(`Archive files from current month (${currYear}-${currMonth})? Type 'y' to proceed:`, "n");
        if (confirmCurrent?.toLowerCase() !== 'y') {
            // Exclude current-month files from archiving this run
            toArchive = toArchive.filter(i => !(i.year === currYear && i.month === currMonth));
            if (toArchive.length === 0) {
                new Notice('⚠️ No files to archive after excluding current month.');
                return;
            }
        }
    }

    // Move files into month-based folders under content/_Daily/Archive/YYYY-MM/
    let success = 0;
    let errors = 0;
    const archived = [];

    for (const item of toArchive) {
        const {file, year, month} = item;
        const targetFolder = `content/_Daily/Archive/${year}-${month}`;

        try {
            // Ensure folder exists
            try { await app.vault.createFolder(targetFolder); } catch (e) { /* ignore exists */ }

            const targetPath = `${targetFolder}/${file.name}`;

            // If target exists, add timestamp to avoid collision
            const existing = app.vault.getAbstractFileByPath(targetPath);
            if (existing) {
                const ts = String(Date.now());
                const uniquePath = `${targetFolder}/${file.basename}-${ts}.md`;
                await app.fileManager.renameFile(file, uniquePath);
                archived.push({from: file.path, to: uniquePath});
            } else {
                await app.fileManager.renameFile(file, targetPath);
                archived.push({from: file.path, to: targetPath});
            }

            success++;
        } catch (err) {
            console.error(`Error archiving ${file.path}:`, err);
            errors++;
        }
    }

    // Create a simple summary note in the Archive root
    const summaryFolder = 'content/_Daily/Archive';
    try { await app.vault.createFolder(summaryFolder); } catch (e) {}
    const summaryPath = `${summaryFolder}/Archive-Summary-${tp.date.now('YYYY-MM-DD')}.md`;
    const summaryContent = `---\ntitle: Daily Archive Summary\ndate: ${tp.date.now('YYYY-MM-DD')}\n---\n\n# Archive Summary\n\n**Archived:** ${success} files\n**Errors:** ${errors}\n\n## Files\n\n${archived.map(a => `- ${a.from} → ${a.to}`).join('\n')}`;
    try { await app.vault.create(summaryPath, summaryContent); } catch (e) { /* ignore if exists */ }

    new Notice(`✅ Archived ${success} files. ${errors} errors.`);

    const summaryFile = app.vault.getAbstractFileByPath(summaryPath);
    if (summaryFile) {
        await app.workspace.getLeaf(false).openFile(summaryFile);
    }
}
