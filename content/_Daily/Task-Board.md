---
title: Task Board
tags:
  - dashboard
  - tasks
  - kanban
icon: lucide//kanban-square
cssclasses:
  - kanban-board-page
---

<style>
.task-board-controls {
  margin: 20px 0;
  padding: 15px;
  background: var(--background-secondary);
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.task-board-controls label {
  font-weight: 600;
}

.task-board-controls select {
  padding: 8px 12px;
  border-radius: 6px;
  border: 1px solid var(--background-modifier-border);
  background: var(--background-primary);
  color: var(--text-normal);
  font-size: 14px;
  cursor: pointer;
}

.kanban-board {
  display: grid !important;
  grid-template-columns: repeat(3, 1fr) !important;
  gap: 20px !important;
  margin: 20px 0 !important;
  padding: 10px !important;
  overflow-x: auto !important;
}

@media (max-width: 1200px) {
  .kanban-board {
    grid-template-columns: repeat(2, 1fr) !important;
  }
}

@media (max-width: 768px) {
  .kanban-board {
    grid-template-columns: 1fr !important;
  }
}

.kanban-column {
  background: var(--background-secondary);
  border-radius: 12px;
  padding: 15px;
  min-height: 400px;
}

.column-header {
  font-size: 16px;
  font-weight: 700;
  margin: 0 0 15px 0;
  padding: 10px;
  border-radius: 8px;
  text-align: center;
  position: sticky;
  top: 0;
  z-index: 10;
}

.column-header.high-priority {
  background: rgba(239, 68, 68, 0.1);
  color: #EF4444;
}

.column-header.medium-priority {
  background: rgba(251, 191, 36, 0.1);
  color: #FBBF24;
}

.column-header.low-priority {
  background: rgba(59, 130, 246, 0.1);
  color: #3B82F6;
}

.task-count {
  font-size: 14px;
  opacity: 0.7;
  font-weight: 500;
}

.task-container {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.task-card {
  background: var(--background-primary);
  border-radius: 8px;
  padding: 12px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.task-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.task-card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  padding-left: 8px;
  font-size: 12px;
  font-weight: 600;
  text-transform: capitalize;
  opacity: 0.8;
}

.task-project-icon {
  font-size: 14px;
}

.task-card-body {
  padding: 8px 0;
}

.task-checkbox {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  cursor: pointer;
}

.task-checkbox input[type="checkbox"] {
  margin-top: 4px;
  cursor: pointer;
  width: 18px;
  height: 18px;
}

.task-text {
  flex: 1;
  line-height: 1.5;
  font-size: 14px;
}

.task-card[data-completed="true"] .task-text {
  text-decoration: line-through;
  opacity: 0.6;
}

.task-card-footer {
  margin-top: 10px;
  padding-top: 8px;
  border-top: 1px solid var(--background-modifier-border);
  font-size: 11px;
  color: var(--text-muted);
}

.task-source {
  display: inline-block;
  padding: 2px 6px;
  background: var(--background-secondary);
  border-radius: 4px;
}

.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: var(--text-muted);
  font-style: italic;
}
</style>

# 🎯 Task Board

<div class="task-board-controls">
  <label for="project-filter">Filter by Project:</label>
  <select id="project-filter">
    <option value="all">All Projects</option>
    <option value="bumble">🐝 Bumble</option>
    <option value="star-sailors">⭐ Star Sailors</option>
    <option value="roving">🏃 Roving</option>
    <option value="station-198">🏠 Station 198</option>
  </select>
</div>

<div class="kanban-board" id="kanban-board">
  <div class="kanban-column">
    <h3 class="column-header high-priority">⏫ High Priority <span class="task-count" id="high-count">(0)</span></h3>
    <div id="high-priority-tasks" class="task-container"></div>
  </div>
  
  <div class="kanban-column">
    <h3 class="column-header medium-priority">🔼 Medium Priority <span class="task-count" id="medium-count">(0)</span></h3>
    <div id="medium-priority-tasks" class="task-container"></div>
  </div>
  
  <div class="kanban-column">
    <h3 class="column-header low-priority">🔽 Low Priority <span class="task-count" id="low-count">(0)</span></h3>
    <div id="low-priority-tasks" class="task-container"></div>
  </div>
</div>

```dataviewjs
const projectColors = {
  'bumble': '#FFB800',
  'star-sailors': '#4A90E2',
  'roving': '#50C878',
  'station-198': '#9B59B6'
};

const projectIcons = {
  'bumble': '🐝',
  'star-sailors': '⭐',
  'roving': '🏃',
  'station-198': '🏠'
};

function detectProject(text) {
  const textLower = text.toLowerCase();
  if (textLower.includes('bumble') || textLower.includes('#bumble')) return 'bumble';
  if (textLower.includes('star-sailors') || textLower.includes('#star-sailors') || textLower.includes('star sailors')) return 'star-sailors';
  if (textLower.includes('roving') || textLower.includes('#roving')) return 'roving';
  if (textLower.includes('station') || textLower.includes('#station-198')) return 'station-198';
  return 'general';
}

function detectPriority(text) {
  if (text.includes('⏫') || text.includes('#high-priority') || text.includes('#p1')) return 'high';
  if (text.includes('🔼') || text.includes('#p2') || text.includes('#p3')) return 'medium';
  if (text.includes('🔽') || text.includes('#p4') || text.includes('#p5')) return 'low';
  return 'medium';
}

function createTaskCard(task, filePath) {
  const project = detectProject(task.text);
  const priority = detectPriority(task.text);
  const color = projectColors[project] || '#999999';
  const icon = projectIcons[project] || '📋';
  
  const fileName = filePath.split('/').pop().replace('.md', '');
  
  return `
    <div class="task-card" data-project="${project}" data-priority="${priority}" data-completed="${task.completed}">
      <div class="task-card-header" style="border-left: 4px solid ${color}">
        <span class="task-project-icon">${icon}</span>
        <span class="task-project">${project}</span>
      </div>
      <div class="task-card-body">
        <label class="task-checkbox">
          <input type="checkbox" ${task.completed ? 'checked' : ''} disabled>
          <span class="task-text">${task.text}</span>
        </label>
      </div>
      <div class="task-card-footer">
        <span class="task-source">📄 ${fileName}</span>
      </div>
    </div>
  `;
}

// Get all tasks from content folder
const tasks = [];
for (let page of dv.pages('"content"')) {
  if (page.file.tasks) {
    for (let task of page.file.tasks) {
      tasks.push({
        text: task.text,
        completed: task.completed,
        path: page.file.path,
        project: detectProject(task.text),
        priority: detectPriority(task.text)
      });
    }
  }
}

// Store tasks globally for filtering (only incomplete tasks)
window.allTasks = tasks.filter(t => !t.completed);

// Function to render tasks
function renderTasks(tasksToRender) {
  const highPriorityTasks = tasksToRender.filter(t => t.priority === 'high');
  const mediumPriorityTasks = tasksToRender.filter(t => t.priority === 'medium');
  const lowPriorityTasks = tasksToRender.filter(t => t.priority === 'low');

  const highContainer = document.getElementById('high-priority-tasks');
  const mediumContainer = document.getElementById('medium-priority-tasks');
  const lowContainer = document.getElementById('low-priority-tasks');

  if (highContainer) {
    highContainer.innerHTML = highPriorityTasks.map(t => createTaskCard(t, t.path)).join('') || '<div class="empty-state">No tasks</div>';
  }
  if (mediumContainer) {
    mediumContainer.innerHTML = mediumPriorityTasks.map(t => createTaskCard(t, t.path)).join('') || '<div class="empty-state">No tasks</div>';
  }
  if (lowContainer) {
    lowContainer.innerHTML = lowPriorityTasks.map(t => createTaskCard(t, t.path)).join('') || '<div class="empty-state">No tasks</div>';
  }
  
  // Update counts
  document.getElementById('high-count').textContent = `(${highPriorityTasks.length})`;
  document.getElementById('medium-count').textContent = `(${mediumPriorityTasks.length})`;
  document.getElementById('low-count').textContent = `(${lowPriorityTasks.length})`;
}

// Initial render
renderTasks(tasks);

// Add filter event listener
const filterSelect = document.getElementById('project-filter');
if (filterSelect) {
  filterSelect.addEventListener('change', function() {
    const filter = this.value;
    if (filter === 'all') {
      renderTasks(window.allTasks);
    } else {
      const filtered = window.allTasks.filter(t => t.project === filter);
      renderTasks(filtered);
    }
  });
}
```

<style>
.task-board-controls {
  margin: 20px 0;
  padding: 15px;
  background: var(--background-secondary);
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.task-board-controls label {
  font-weight: 600;
}

.task-board-controls select {
  padding: 8px 12px;
  border-radius: 6px;
  border: 1px solid var(--background-modifier-border);
  background: var(--background-primary);
  color: var(--text-normal);
  font-size: 14px;
  cursor: pointer;
}

.kanban-board {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin: 20px 0;
  padding: 10px;
  overflow-x: auto;
}

@media (max-width: 1200px) {
  .kanban-board {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .kanban-board {
    grid-template-columns: 1fr;
  }
}

.kanban-column {
  background: var(--background-secondary);
  border-radius: 12px;
  padding: 15px;
  min-height: 400px;
}

.column-header {
  font-size: 16px;
  font-weight: 700;
  margin: 0 0 15px 0;
  padding: 10px;
  border-radius: 8px;
  text-align: center;
  position: sticky;
  top: 0;
  z-index: 10;
}

.column-header.high-priority {
  background: rgba(239, 68, 68, 0.1);
  color: #EF4444;
}

.column-header.medium-priority {
  background: rgba(251, 191, 36, 0.1);
  color: #FBBF24;
}

.column-header.low-priority {
  background: rgba(59, 130, 246, 0.1);
  color: #3B82F6;
}

.task-count {
  font-size: 14px;
  opacity: 0.7;
  font-weight: 500;
}

.task-container {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.task-card {
  background: var(--background-primary);
  border-radius: 8px;
  padding: 12px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
  cursor: pointer;
}

.task-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.task-card-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  padding-left: 8px;
  font-size: 12px;
  font-weight: 600;
  text-transform: capitalize;
  opacity: 0.8;
}

.task-project-icon {
  font-size: 14px;
}

.task-card-body {
  padding: 8px 0;
}

.task-checkbox {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  cursor: pointer;
}

.task-checkbox input[type="checkbox"] {
  margin-top: 4px;
  cursor: pointer;
  width: 18px;
  height: 18px;
}

.task-text {
  flex: 1;
  line-height: 1.5;
  font-size: 14px;
}

.task-card[data-completed="true"] .task-text {
  text-decoration: line-through;
  opacity: 0.6;
}

.task-card-footer {
  margin-top: 10px;
  padding-top: 8px;
  border-top: 1px solid var(--background-modifier-border);
  font-size: 11px;
  color: var(--text-muted);
}

.task-source {
  display: inline-block;
  padding: 2px 6px;
  background: var(--background-secondary);
  border-radius: 4px;
}

.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: var(--text-muted);
  font-style: italic;
}
</style>
