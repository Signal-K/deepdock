// Contextual Task Creator
// Adds a task directly into the active project's section in today's daily dashboard.

const PROJECTS = [
  ["Star Sailors Web (2.1-3.0)", "star-sailors-web", "#star-sailors-web"],
  ["Experiment1", "experiment1", "#experiment1"],
  ["Bumble", "bumble", "#bumble"],
  ["Click-A-Coral", "click-a-coral", "#click-a-coral"],
  ["Godot-Mars-Archive", "godot-mars-archive", "#godot-mars"],
  ["Weathr", "weathr", "#weathr"],
  ["Map App", "map-app", "#map-app"],
  ["Prehog", "prehog", "#prehog"],
];

function generateTaskId(existingContent) {
  const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  for (let attempt = 0; attempt < 64; attempt += 1) {
    let id = "";
    for (let i = 0; i < 6; i += 1) {
      id += chars[Math.floor(Math.random() * chars.length)];
    }
    if (!existingContent.includes(`🆔 ${id}`)) {
      return id;
    }
  }
  return `${Date.now().toString(36).slice(-6)}`;
}

module.exports = async function (tp, appContext) {
  const app = appContext || this.app || tp.app;
  const file = app.workspace.getActiveFile();
  if (!file) {
    new Notice("❌ No active file");
    return;
  }

  const taskText = await tp.system.prompt("Task description:");
  if (!taskText) return;

  const content = await app.vault.read(file);
  const activeIds = getActiveProjectIdsFromFrontmatter(content);
  const availableProjects = activeIds.length
    ? PROJECTS.filter((p) => activeIds.includes(p[1]))
    : PROJECTS;

  if (!availableProjects.length) {
    new Notice("⚠️ No active projects found in this dashboard. Run Setup Context.");
    return;
  }

  const projectId = await tp.system.suggester(
    availableProjects.map((p) => p[0]),
    availableProjects.map((p) => p[1])
  );
  if (!projectId) return;

  const project = availableProjects.find((p) => p[1] === projectId);
  const priority = await tp.system.suggester(["⏫ High", "🔼 Medium", "🔽 Low"], ["high", "medium", "low"]);
  if (!priority) return;

  const dateTag = file.basename.match(/^\d{4}-\d{2}-\d{2}$/) ? `#${file.basename}` : "";
  const today = tp.date.now("YYYY-MM-DD");
  const taskId = generateTaskId(content);
  const priorityEmoji = priority === "high" ? "⏫" : priority === "medium" ? "🔼" : "🔽";
  const taskLine = `- [ ] ${taskText} ${priorityEmoji} 🆔 ${taskId} ➕ ${today} ${project[2]} ${dateTag}`
    .replace(/\s+/g, " ")
    .trim();

  let nextContent = content;
  const sectionHeader = `## Project: ${project[0]}`;
  const tasksHeader = "### Tasks";

  if (!nextContent.includes(sectionHeader)) {
    const addSection = [
      "",
      sectionHeader,
      "",
      `Tags: ${project[2]} ${dateTag}`.trim(),
      "",
      tasksHeader,
      taskLine,
      "",
      "### Notes",
      "",
      "### Decisions",
      "",
      "### Ideas",
      "",
    ].join("\n");
    nextContent = `${nextContent.trim()}\n${addSection}\n`;
  } else {
    const idx = nextContent.indexOf(sectionHeader);
    const tail = nextContent.slice(idx);
    const tasksIdx = tail.indexOf(tasksHeader);

    if (tasksIdx >= 0) {
      const insertAt = idx + tasksIdx + tasksHeader.length;
      nextContent = `${nextContent.slice(0, insertAt)}\n${taskLine}${nextContent.slice(insertAt)}`;
    } else {
      const insertAt = idx + sectionHeader.length;
      nextContent = `${nextContent.slice(0, insertAt)}\n\n${tasksHeader}\n${taskLine}${nextContent.slice(insertAt)}`;
    }
  }

  await app.vault.modify(file, nextContent);
  new Notice(`✅ Task added to ${project[0]} section`);
};

function getActiveProjectIdsFromFrontmatter(content) {
  const m = content.match(/(?:^|\n)active_projects:\n((?:\s+-\s+[^\n]+\n?)+)/);
  if (!m) return [];
  return m[1]
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.startsWith("- "))
    .map((l) => l.replace(/^- /, "").trim());
}
