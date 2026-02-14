// Contextual Organizer
// Auto-tags tasks and routes project content from a daily dashboard to category folders.

const PROJECTS = {
  "star-sailors-web": {
    label: "Star Sailors Web (2.1-3.0)",
    tag: "#star-sailors-web",
    path: "Star-Sailors-Ecosystem/Star-Sailors-Web",
  },
  experiment1: {
    label: "Experiment1",
    tag: "#experiment1",
    path: "Star-Sailors-Ecosystem/Experiment1",
  },
  bumble: {
    label: "Bumble",
    tag: "#bumble",
    path: "Star-Sailors-Ecosystem/Bumble",
  },
  "click-a-coral": {
    label: "Click-A-Coral",
    tag: "#click-a-coral",
    path: "Star-Sailors-Ecosystem/Click-A-Coral",
  },
  "godot-mars-archive": {
    label: "Godot-Mars-Archive",
    tag: "#godot-mars",
    path: "Star-Sailors-Ecosystem/Godot-Mars-Archive",
  },
  weathr: { label: "Weathr", tag: "#weathr", path: "Weathr" },
  "map-app": { label: "Map App", tag: "#map-app", path: "Map-App" },
  prehog: { label: "Prehog", tag: "#prehog", path: "Prehog" },
};
const TAG_TO_ID = Object.fromEntries(
  Object.entries(PROJECTS).map(([id, meta]) => [meta.tag.replace(/^#/, ""), id])
);

module.exports = async function (tp, appContext) {
  const app = appContext || this.app || tp.app;
  const file = app.workspace.getActiveFile();
  if (!file) {
    new Notice("❌ No active file");
    return;
  }

  if (!file.path.startsWith("content/Operations/Daily/")) {
    new Notice("⚠️ This command is intended for daily dashboard notes");
  }

  const dateTag = file.basename;
  const srcPath = file.path;
  let content = await app.vault.read(file);
  const activeIds = extractYamlList(content, "active_projects");
  const lines = content.split("\n");

  const sections = parseProjectSections(lines);
  if (!sections.length) {
    new Notice("⚠️ No project sections found. Use Reset Dashboard first.");
    return;
  }

  const routedLinks = [];
  let taggedTasks = 0;

  for (const section of sections) {
    const projectLines = lines.slice(section.start + 1, section.end);
    const projectId = inferProjectId(section.title, projectLines, activeIds);
    if (!projectId || !PROJECTS[projectId]) continue;
    if (activeIds.length && !activeIds.includes(projectId)) continue;
    const meta = PROJECTS[projectId];

    const { tasks, notes, ideas, decisions, taskLineIndexes } = parseProjectSubsections(projectLines, section.start + 1);

    // Auto-tag tasks in the source note.
    for (const idx of taskLineIndexes) {
      const original = lines[idx];
      if (!original.includes(meta.tag)) {
        lines[idx] = `${original} ${meta.tag}`;
        taggedTasks += 1;
      }
      if (!lines[idx].includes(`#${dateTag}`)) {
        lines[idx] = `${lines[idx]} #${dateTag}`;
      }
    }

    if (tasks.length) {
      const taskTarget = `content/Categories/Tasks/${meta.path}/Daily-Routed/${dateTag}.md`;
      const taskBody = [
        `# Tasks Routed from ${dateTag}`,
        "",
        `Source: [[${srcPath}|${file.basename}]]`,
        "",
        "## Tasks",
        ...tasks,
        "",
      ].join("\n");
      await upsertRoutedFile(app, taskTarget, `## Tasks from ${meta.label}`, taskBody);
      routedLinks.push(`- [[${taskTarget}|Routed: ${meta.label} Tasks]]`);
    }

    const docsBits = [];
    if (notes.length) docsBits.push("## Notes", ...notes, "");
    if (decisions.length) docsBits.push("## Decisions", ...decisions, "");

    if (docsBits.length) {
      const docsTarget = `content/Categories/Docs/${meta.path}/Daily-Notes/${dateTag}.md`;
      const docsBody = [
        `# Docs Routed from ${dateTag}`,
        "",
        `Source: [[${srcPath}|${file.basename}]]`,
        "",
        ...docsBits,
      ].join("\n");
      await upsertRoutedFile(app, docsTarget, `## Docs from ${meta.label}`, docsBody);
      routedLinks.push(`- [[${docsTarget}|Routed: ${meta.label} Docs]]`);
    }

    if (ideas.length) {
      const ideasTarget = `content/Categories/Ideas/${meta.path}/Daily-Insights/${dateTag}.md`;
      const ideasBody = [
        `# Ideas Routed from ${dateTag}`,
        "",
        `Source: [[${srcPath}|${file.basename}]]`,
        "",
        "## Ideas",
        ...ideas,
        "",
      ].join("\n");
      await upsertRoutedFile(app, ideasTarget, `## Ideas from ${meta.label}`, ideasBody);
      routedLinks.push(`- [[${ideasTarget}|Routed: ${meta.label} Ideas]]`);
    }
  }

  const rebuilt = lines.join("\n");
  content = mergeRoutedLinks(rebuilt, routedLinks);
  await app.vault.modify(file, content);

  new Notice(`✅ Organized daily note (${routedLinks.length} routes, ${taggedTasks} task tags added)`);
};

function parseProjectSections(lines) {
  const sections = [];
  for (let i = 0; i < lines.length; i++) {
    const m = lines[i].match(/^##\s+Project:\s+(.+)$/i);
    if (!m) continue;
    sections.push({ title: m[1].trim(), start: i, end: lines.length });
  }
  for (let i = 0; i < sections.length - 1; i++) {
    sections[i].end = sections[i + 1].start;
  }
  return sections;
}

function parseProjectSubsections(projectLines, offset) {
  const buckets = { tasks: [], notes: [], ideas: [], decisions: [], taskLineIndexes: [] };
  let mode = "";

  for (let i = 0; i < projectLines.length; i++) {
    const line = projectLines[i];
    const t = line.trim();

    if (/^###\s+Tasks/i.test(t)) {
      mode = "tasks";
      continue;
    }
    if (/^###\s+Notes/i.test(t)) {
      mode = "notes";
      continue;
    }
    if (/^###\s+Decisions/i.test(t)) {
      mode = "decisions";
      continue;
    }
    if (/^###\s+Ideas/i.test(t)) {
      mode = "ideas";
      continue;
    }
    if (/^###\s+/i.test(t)) {
      mode = "";
      continue;
    }

    if (!t) continue;

    if (mode === "tasks" && /^[-*+]\s+\[[ xX]\]/.test(t)) {
      buckets.tasks.push(line);
      buckets.taskLineIndexes.push(offset + i);
      continue;
    }

    if (mode === "notes") buckets.notes.push(line);
    if (mode === "decisions") buckets.decisions.push(line);
    if (mode === "ideas") buckets.ideas.push(line);
  }

  return buckets;
}

function inferProjectId(title, projectLines, activeIds = []) {
  for (const line of projectLines) {
    const m = line.match(/^Tags:\s+(.+)$/i);
    if (!m) continue;
    const tags = (m[1].match(/#[a-z0-9-]+/gi) || []).map((t) => t.replace(/^#/, "").toLowerCase());
    for (const tag of tags) {
      const id = TAG_TO_ID[tag];
      if (id && (!activeIds.length || activeIds.includes(id))) return id;
    }
  }

  const key = title.toLowerCase();
  if (key.includes("star sailors")) return "star-sailors-web";
  if (key.includes("experiment1")) return "experiment1";
  if (key.includes("bumble")) return "bumble";
  if (key.includes("click-a-coral")) return "click-a-coral";
  if (key.includes("godot-mars")) return "godot-mars-archive";
  if (key.includes("weathr")) return "weathr";
  if (key.includes("map app")) return "map-app";
  if (key.includes("prehog")) return "prehog";
  return null;
}

function extractYamlList(content, key) {
  const m = content.match(new RegExp(`(?:^|\\n)${key}:\\n((?:\\s+-\\s+[^\\n]+\\n?)+)`));
  if (!m) return [];
  return m[1]
    .split("\n")
    .map((l) => l.trim())
    .filter((l) => l.startsWith("- "))
    .map((l) => l.replace(/^- /, "").trim());
}

async function upsertRoutedFile(app, targetPath, marker, body) {
  await ensureFolder(app, targetPath.substring(0, targetPath.lastIndexOf("/")));
  const existing = app.vault.getAbstractFileByPath(targetPath);
  if (!existing) {
    await app.vault.create(targetPath, body);
    return;
  }

  const current = await app.vault.read(existing);
  if (current.includes(marker)) return;
  await app.vault.modify(existing, `${current.trim()}\n\n---\n\n${body}`);
}

function mergeRoutedLinks(content, newLinks) {
  if (!newLinks.length) return content;

  const unique = Array.from(new Set(newLinks));

  if (!content.includes("## Routed Notes")) {
    return `${content.trim()}\n\n## Routed Notes\n${unique.join("\n")}\n`;
  }

  const lines = content.split("\n");
  const existing = new Set(lines.filter((l) => l.trim().startsWith("- [[")));
  const toAdd = unique.filter((l) => !existing.has(l));
  if (!toAdd.length) return content;
  return `${content.trim()}\n${toAdd.join("\n")}\n`;
}

async function ensureFolder(app, folderPath) {
  if (!folderPath) return;
  const parts = folderPath.split("/");
  let curr = "";
  for (const part of parts) {
    curr = curr ? `${curr}/${part}` : part;
    if (!app.vault.getAbstractFileByPath(curr)) {
      try {
        await app.vault.createFolder(curr);
      } catch {
        // ignore race/exists
      }
    }
  }
}
