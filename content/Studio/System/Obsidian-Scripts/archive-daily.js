// Smart daily archiver
// Archives current daily note to Archive or Long-Term based on age and completion state.

module.exports = async function (tp, appContext) {
  const app = appContext || this.app || tp.app;
  const file = app.workspace.getActiveFile();

  if (!file) {
    new Notice("❌ No active file");
    return;
  }

  if (!file.path.startsWith("content/Operations/Daily/Active/")) {
    new Notice("⚠️ Open a daily file in content/Operations/Daily/Active first.");
    return;
  }

  const dateMatch = file.basename.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (!dateMatch) {
    new Notice("⚠️ This file does not look like a dated daily note.");
    return;
  }

  const [_, yyyy, mm, dd] = dateMatch;
  const content = await app.vault.read(file);
  const incomplete = (content.match(/^\s*[-*+]\s*\[\s\]/gm) || []).length;

  if (incomplete > 0) {
    const proceed = await tp.system.suggester(
      [
        `Archive anyway (${incomplete} incomplete tasks)` ,
        "Cancel",
      ],
      [true, false]
    );
    if (!proceed) return;
  }

  const noteDate = new Date(`${yyyy}-${mm}-${dd}T00:00:00`);
  const now = new Date();
  const ageDays = Math.floor((now.getTime() - noteDate.getTime()) / (1000 * 60 * 60 * 24));

  const longTerm = ageDays >= 30 && incomplete === 0;
  const baseFolder = longTerm
    ? `content/Operations/Daily/Long-Term/${yyyy}`
    : `content/Operations/Daily/Archive/${yyyy}-${mm}`;

  await ensureFolder(app, baseFolder);

  const targetPath = `${baseFolder}/${file.name}`;
  const existing = app.vault.getAbstractFileByPath(targetPath);
  const finalPath = existing ? `${baseFolder}/${file.basename}-${Date.now()}.md` : targetPath;

  await app.fileManager.renameFile(file, finalPath);
  new Notice(`✅ Archived to ${longTerm ? "Long-Term" : "Archive"}: ${finalPath}`);

  const moved = app.vault.getAbstractFileByPath(finalPath);
  if (moved) await app.workspace.getLeaf(false).openFile(moved);
};

async function ensureFolder(app, folderPath) {
  const parts = folderPath.split("/");
  let current = "";
  for (const part of parts) {
    current = current ? `${current}/${part}` : part;
    if (!app.vault.getAbstractFileByPath(current)) {
      try {
        await app.vault.createFolder(current);
      } catch {
        // ignore
      }
    }
  }
}
