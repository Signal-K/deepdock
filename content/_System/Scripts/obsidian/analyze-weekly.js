/**
 * Weekly Analysis Script with Local AI (Ollama)
 * 
 * Analyzes all notes from the current week to:
 * 1. Find ideas that don't have matching tasks
 * 2. List incomplete tasks
 * 
 * Uses Ollama (local AI) for analysis
 * Install Ollama: https://ollama.ai
 * Run: ollama pull llama3.2 (or another model)
 */

async function analyzeWeekly(tp) {
    const app = this.app || tp.app;
    const moment = window.moment;
    
    // Get current week's start (Sunday) and end (Saturday)
    const today = moment();
    const startOfWeek = today.clone().startOf('week'); // Sunday
    const endOfWeek = today.clone().endOf('week'); // Saturday
    
    console.log(`Analyzing week: ${startOfWeek.format('YYYY-MM-DD')} to ${endOfWeek.format('YYYY-MM-DD')}`);
    
    // Collect all files from this week
    const weekFiles = [];
    const allFiles = app.vault.getMarkdownFiles();
    
    for (const file of allFiles) {
        const fileMoment = moment(file.stat.mtime);
        if (fileMoment.isBetween(startOfWeek, endOfWeek, null, '[]')) {
            weekFiles.push(file);
        }
    }
    
    if (weekFiles.length === 0) {
        new Notice('⚠️ No files found for this week');
        return;
    }
    
    new Notice(`📊 Analyzing ${weekFiles.length} files from this week...`);
    
    // Read content from all week files
    let weekContent = '';
    const fileContents = {};
    
    for (const file of weekFiles) {
        const content = await app.vault.read(file);
        fileContents[file.path] = content;
        weekContent += `\n\n=== File: ${file.path} ===\n${content}`;
    }
    
    // Collect all tasks from the entire vault
    const allTasks = [];
    for (const file of allFiles) {
        const content = await app.vault.read(file);
        const taskRegex = /^[\s]*[-*]\s+\[([ xX])\]\s+(.+)$/gm;
        let match;
        
        while ((match = taskRegex.exec(content)) !== null) {
            allTasks.push({
                completed: match[1].toLowerCase() === 'x',
                text: match[2].trim(),
                file: file.path
            });
        }
    }
    
    console.log(`Found ${allTasks.length} total tasks in vault`);
    
    // Extract ideas and action items from week content
    const ideas = [];
    const actionPhrases = [
        'need to', 'should', 'must', 'have to', 'want to',
        'will', 'plan to', 'going to', 'TODO', 'FIXME',
        'build', 'create', 'make', 'implement', 'add',
        'fix', 'update', 'change', 'improve', 'refactor'
    ];
    
    for (const [filePath, content] of Object.entries(fileContents)) {
        const lines = content.split('\n');
        
        for (let i = 0; i < lines.length; i++) {
            const line = lines[i].trim();
            
            // Skip task lines, headers, and empty lines
            if (!line || line.startsWith('#') || line.match(/^[-*]\s+\[/)) {
                continue;
            }
            
            // Check if line contains action phrases
            const lowerLine = line.toLowerCase();
            const hasActionPhrase = actionPhrases.some(phrase => lowerLine.includes(phrase));
            
            if (hasActionPhrase) {
                ideas.push({
                    text: line,
                    file: filePath,
                    lineNumber: i + 1
                });
            }
        }
    }
    
    console.log(`Found ${ideas.length} potential ideas/action items`);
    
    // Prepare data for AI analysis
    const incompleteTasksList = allTasks
        .filter(t => !t.completed)
        .map(t => t.text)
        .join('\n');
    
    const ideasList = ideas
        .map(i => `- ${i.text} (${i.file})`)
        .join('\n');
    
    // Call Ollama API
    new Notice('🤖 Calling local AI (Ollama) for analysis...');
    
    const analysisPrompt = `You are analyzing a weekly notes review for a project management system.

INCOMPLETE TASKS (${allTasks.filter(t => !t.completed).length} total):
${incompleteTasksList}

POTENTIAL IDEAS/ACTION ITEMS FROM THIS WEEK (${ideas.length} total):
${ideasList}

Please analyze and provide:

1. **Ideas Without Tasks**: Identify ideas/action items that don't have a corresponding task. Look for statements that imply work needs to be done but don't match any existing task.

2. **Task Status**: Categorize the incomplete tasks by project or theme.

3. **Recommendations**: Suggest which ideas should become tasks.

Format your response in clear sections with bullet points. Be concise but specific.`;

    let aiResponse;
    let usingAI = false;
    
    try {
        // First check if Ollama is running
        const healthCheck = await fetch('http://localhost:11434/api/tags', {
            method: 'GET',
        });
        
        if (!healthCheck.ok) {
            throw new Error('Ollama not running');
        }
        
        new Notice('🤖 AI analysis in progress...');
        
        const response = await fetch('http://localhost:11434/api/generate', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                model: 'llama3.2', // Change to your preferred model
                prompt: analysisPrompt,
                stream: false,
                options: {
                    temperature: 0.7,
                    num_predict: 2000
                }
            })
        });
        
        if (!response.ok) {
            throw new Error(`Ollama API error: ${response.status}`);
        }
        
        const data = await response.json();
        aiResponse = data.response;
        usingAI = true;
        new Notice('✅ AI analysis complete!');
        
    } catch (error) {
        console.error('Ollama error:', error);
        new Notice('⚠️ Ollama not available - using basic analysis');
        
        // Fallback to simple analysis if AI unavailable
        aiResponse = `⚠️ **Ollama not available. Using basic analysis.**\n\n` +
            `**To enable AI analysis:**\n` +
            `1. Install Ollama from https://ollama.ai (or run ./content/_System/Scripts/setup-ollama.sh)\n` +
            `2. Pull model: \`ollama pull llama3.2\`\n` +
            `3. Verify it's running: \`ollama list\`\n` +
            `4. See full setup guide: [[_System/Documentation/Ollama-Setup]]\n\n` +
            `---\n\n` +
            `## Ideas Without Tasks (${ideas.length} found)\n\n` +
            ideas.slice(0, 30).map(i => `- ${i.text}\n  *Source: ${i.file} (line ${i.lineNumber})*`).join('\n\n') +
            `\n\n${ideas.length > 30 ? `\n*... and ${ideas.length - 30} more ideas*\n` : ''}` +
            `\n## Incomplete Tasks (${allTasks.filter(t => !t.completed).length} total)\n\n` +
            allTasks.filter(t => !t.completed).slice(0, 50).map(t => `- [ ] ${t.text}\n  *File: ${t.file}*`).join('\n') +
            `\n\n${allTasks.filter(t => !t.completed).length > 50 ? `\n*... and ${allTasks.filter(t => !t.completed).length - 50} more tasks*\n` : ''}`;
    }
    
    // Create analysis report
    const reportDate = moment().format('YYYY-MM-DD');
    const reportPath = `content/_Daily/Weekly-Analysis-${reportDate}.md`;
    
    const reportContent = `---
title: Weekly Analysis
date: ${reportDate}
week: ${startOfWeek.format('YYYY-MM-DD')} to ${endOfWeek.format('YYYY-MM-DD')}
tags:
  - analysis
  - weekly-review
  ${usingAI ? '- ai-generated' : '- basic-analysis'}
icon: lucide//brain
---

# 🧠 Weekly Analysis - ${startOfWeek.format('MMM DD')} to ${endOfWeek.format('MMM DD, YYYY')}

**Generated:** ${moment().format('YYYY-MM-DD HH:mm')}  
**Analysis Type:** ${usingAI ? '🤖 AI-Powered (Ollama)' : '📊 Basic Analysis'}  
**Files Analyzed:** ${weekFiles.length}  
**Total Tasks Found:** ${allTasks.length} (${allTasks.filter(t => !t.completed).length} incomplete)  
**Ideas/Action Items:** ${ideas.length}

---

## 🤖 AI Analysis

${aiResponse}

---

## 📋 Raw Data

### Files Analyzed This Week

${weekFiles.map(f => `- [[${f.path.replace('content/', '')}|${f.basename}]]`).join('\n')}

### All Incomplete Tasks (${allTasks.filter(t => !t.completed).length})

${allTasks.filter(t => !t.completed).map(t => `- [ ] ${t.text}\n  *File: ${t.file}*`).join('\n')}

### Ideas & Action Phrases (${ideas.length})

${ideas.map(i => `- ${i.text}\n  *Source: [[${i.file.replace('content/', '')}]] (line ${i.lineNumber})*`).join('\n\n')}

---

## 🎯 Next Steps

- [ ] Review ideas without tasks and create new tasks
- [ ] Follow up on incomplete tasks
- [ ] Update project priorities based on this analysis

---

*Generated by Weekly Analysis Script*
*Powered by Ollama (Local AI)*
`;

    // Write report
    try {
        await app.vault.create(reportPath, reportContent);
        new Notice(`✅ Weekly analysis complete! Opening report...`);
        
        // Open the report
        const reportFile = app.vault.getAbstractFileByPath(reportPath);
        if (reportFile) {
            await app.workspace.getLeaf().openFile(reportFile);
        }
        
    } catch (error) {
        console.error('Error creating report:', error);
        new Notice(`❌ Error creating report: ${error.message}`);
    }
}

module.exports = analyzeWeekly;
