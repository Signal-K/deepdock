// Contextual Daily Dashboard Creator
// Prompts for active projects and creates today's dashboard with scoped sections.

const PROJECTS = [
  {
    id: "star-sailors-web",
    label: "Star Sailors Web (2.1-3.0)",
    tag: "#star-sailors-web",
    projectPath: "Star-Sailors-Ecosystem/Star-Sailors-Web",
    focusNow: true,
  },
  {
    id: "experiment1",
    label: "Experiment1",
    tag: "#experiment1",
    projectPath: "Star-Sailors-Ecosystem/Experiment1",
    focusNow: true,
  },
  {
    id: "bumble",
    label: "Bumble",
    tag: "#bumble",
    projectPath: "Star-Sailors-Ecosystem/Bumble",
  },
  {
    id: "click-a-coral",
    label: "Click-A-Coral",
    tag: "#click-a-coral",
    projectPath: "Star-Sailors-Ecosystem/Click-A-Coral",
  },
  {
    id: "godot-mars-archive",
    label: "Godot-Mars-Archive",
    tag: "#godot-mars",
    projectPath: "Star-Sailors-Ecosystem/Godot-Mars-Archive",
  },
  {
    id: "weathr",
    label: "Weathr",
    tag: "#weathr",
    projectPath: "Weathr",
  },
  {
    id: "map-app",
    label: "Map App",
    tag: "#map-app",
    projectPath: "Map-App",
  },
  {
    id: "prehog",
    label: "Prehog",
    tag: "#prehog",
    projectPath: "Prehog",
  },
];

module.exports = async function (tp, appContext) {
  const app = appContext || this.app || tp.app;

  const selected = await chooseProjects(tp, app);
  if (!selected) return;

  const todayDate = tp.date.now("YYYY-MM-DD");
  const templatePath = "content/_Daily/Templates/Text-Editor-Dashboard.md";
  const todayPath = `content/Operations/Daily/Active/${todayDate}.md`;

  const templateFile = app.vault.getAbstractFileByPath(templatePath);
  if (!templateFile) {
    new Notice(`❌ Template not found: ${templatePath}`);
    return;
  }

  const templateContent = await app.vault.read(templateFile);
  const projectIdsYaml = selected.map((p) => `  - ${p.id}`).join("\n");
  const projectTagsYaml = selected.map((p) => `  - ${p.tag.replace(/^#/, "")}`).join("\n");
  const projectSections = buildProjectSections(selected, todayDate);

  const rendered = templateContent
    .replaceAll("{{date:YYYY-MM-DD}}", todayDate)
    .replace("{{ACTIVE_PROJECT_IDS}}", projectIdsYaml)
    .replace("{{ACTIVE_PROJECT_TAGS}}", projectTagsYaml)
    .replace("{{PROJECT_SECTIONS}}", projectSections);

  const existing = app.vault.getAbstractFileByPath(todayPath);
  if (existing) {
    const action = await tp.system.suggester(
      [
        "Open existing dashboard",
        "Rebuild existing dashboard with new project context",
        "Cancel",
      ],
      ["open", "rebuild", "cancel"]
    );

    if (action === "cancel" || !action) return;

    if (action === "rebuild") {
      await app.vault.modify(existing, rendered);
      new Notice("✅ Rebuilt today's dashboard with selected projects");
    }

    await app.workspace.getLeaf(false).openFile(existing);
    return;
  }

  const created = await app.vault.create(todayPath, rendered);
  new Notice(`✅ Created contextual dashboard: ${todayPath}`);
  await app.workspace.getLeaf(false).openFile(created);
};

async function chooseProjects(tp, app) {
  const previous = await getPreviousActiveProjects(tp, app);
  const startModeLabels = [
    "Choose projects manually (multi-select)",
    "Use current focus (Experiment1 + Star Sailors Web)",
  ];
  const startModeValues = ["manual", "default"];

  if (previous.length) {
    startModeLabels.unshift(`Reuse previous daily context (${previous.map((p) => p.label).join(", ")})`);
    startModeValues.unshift("previous");
  }

  startModeLabels.push("Cancel");
  startModeValues.push("cancel");

  const startMode = await tp.system.suggester(startModeLabels, startModeValues);

  if (!startMode || startMode === "cancel") return null;
  if (startMode === "previous") return previous;

  if (startMode === "default") {
    return PROJECTS.filter((p) => p.focusNow);
  }

  const selected = await chooseProjectsByNumbers(tp);
  return selected.length ? selected : PROJECTS.filter((p) => p.focusNow);
}

async function chooseProjectsByNumbers(tp) {
  const lines = PROJECTS.map((p, idx) => `${idx + 1}. ${p.label}`);
  const defaultIndexes = PROJECTS.map((p, idx) => (p.focusNow ? idx + 1 : null))
    .filter(Boolean)
    .join(",");
  const promptText = [
    "Select active projects by number (comma-separated).",
    "Example: 1,2,4",
    "",
    ...lines,
  ].join("\n");

  const raw = await tp.system.prompt(promptText, defaultIndexes);
  if (!raw) return [];

  const picked = Array.from(
    new Set(
      raw
        .split(",")
        .map((x) => Number.parseInt(x.trim(), 10))
        .filter((n) => Number.isInteger(n) && n >= 1 && n <= PROJECTS.length)
    )
  );

  return picked.map((n) => PROJECTS[n - 1]);
}

async function getPreviousActiveProjects(tp, app) {
  const yesterday = tp.date.now("YYYY-MM-DD", -1);
  const path = `content/Operations/Daily/Active/${yesterday}.md`;
  const file = app.vault.getAbstractFileByPath(path);
  if (!file) return [];

  const content = await app.vault.read(file);
  const ids = extractYamlList(content, "active_projects");
  if (!ids.length) return [];
  return ids
    .map((id) => PROJECTS.find((p) => p.id === id))
    .filter(Boolean);
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

function buildProjectSections(projects, dateStr) {
  return projects
    .map((p) => {
      const docsIndex = `content/Categories/Docs/${p.projectPath}/index`;
      const tasksIndex = `content/Categories/Tasks/${p.projectPath}/index`;
      const ideasIndex = `content/Categories/Ideas/${p.projectPath}/index`;

      return [
        `## Project: ${p.label}`,
        "",
        `Tags: ${p.tag} #${dateStr}`,
        "",
        "### Tasks",
        `- [ ] (${p.tag})`,
        "",
        "### Notes",
        "",
        "### Decisions",
        "",
        "### Ideas",
        "",
        "### Base Links",
        `- Docs: [[${docsIndex}|Docs Index]]`,
        `- Tasks: [[${tasksIndex}|Tasks Index]]`,
        `- Ideas: [[${ideasIndex}|Ideas Index]]`,
        "",
      ].join("\n");
    })
    .join("\n");
}
