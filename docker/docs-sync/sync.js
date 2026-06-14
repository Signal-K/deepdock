'use strict'

const fs = require('fs-extra')
const path = require('path')
const chokidar = require('chokidar')

// ── Environment ─────────────────────────────────────────────────────────────

const CONFIG_FILE = process.env.CONFIG_FILE || '/config/docs-sync.config.json'
const HOST_HOME = process.env.HOST_HOME || '/Users/scroobz'
const CONTAINER_HOME = process.env.CONTAINER_HOME || '/userhome'

// ── Path helpers ─────────────────────────────────────────────────────────────

function hostToContainer(hostPath) {
  if (hostPath && hostPath.startsWith(HOST_HOME)) {
    return CONTAINER_HOME + hostPath.slice(HOST_HOME.length)
  }
  return hostPath
}

// ── Load Config ─────────────────────────────────────────────────────────────

function loadConfig() {
  try {
    const raw = fs.readFileSync(CONFIG_FILE, 'utf8')
    const config = JSON.parse(raw)
    return config.projects.map(p => ({
      ...p,
      knowns: hostToContainer(p.knownsDocsDir),
      obsidian: hostToContainer(p.obsidianDocsDir),
    }))
  } catch (err) {
    console.error(`Error loading config from ${CONFIG_FILE}:`, err.message)
    process.exit(1)
  }
}

const projects = loadConfig()

// ── Sync Logic ───────────────────────────────────────────────────────────────

// Map to track in-progress syncs to prevent loops
const activeSyncs = new Set()

async function syncFile(src, dest, reason) {
  const syncKey = `${src}->${dest}`
  const reverseKey = `${dest}->${src}`

  if (activeSyncs.has(syncKey) || activeSyncs.has(reverseKey)) return

  activeSyncs.add(syncKey)
  try {
    const exists = await fs.pathExists(src)
    if (!exists) {
      // Handle deletion
      if (await fs.pathExists(dest)) {
        console.log(`[SYNC] Deleting ${dest} (triggered by ${reason})`)
        await fs.remove(dest)
      }
      return
    }

    // Ensure parent directory exists
    await fs.ensureDir(path.dirname(dest))

    // Compare mtimes to avoid redundant copies
    const srcStat = await fs.stat(src)
    try {
      const destStat = await fs.stat(dest)
      if (srcStat.mtimeMs <= destStat.mtimeMs) {
        return // Destination is newer or same age
      }
    } catch (e) {
      // Destination doesn't exist, proceed with copy
    }

    console.log(`[SYNC] Copying ${src} to ${dest} (triggered by ${reason})`)
    await fs.copy(src, dest, { preserveTimestamps: true })
  } catch (err) {
    console.error(`[ERROR] Sync failed for ${src} -> ${dest}:`, err.message)
  } finally {
    // Give it a small delay before allowing another sync of this pair to settle filesystem events
    setTimeout(() => activeSyncs.delete(syncKey), 500)
  }
}

// ── Startup Sync ─────────────────────────────────────────────────────────────

async function initialSync() {
  console.log('[INIT] Performing initial sync...')
  for (const project of projects) {
    console.log(`[INIT] Syncing project: ${project.name}`)
    
    // Ensure directories exist
    await fs.ensureDir(project.knowns)
    await fs.ensureDir(project.obsidian)

    const syncDirs = async (from, to) => {
      if (!await fs.pathExists(from)) return
      const files = await fs.readdir(from, { recursive: true })
      for (const file of files) {
        const srcPath = path.join(from, file)
        const destPath = path.join(to, file)
        const stat = await fs.stat(srcPath)
        if (stat.isFile() && file.endsWith('.md')) {
          await syncFile(srcPath, destPath, 'InitialSync')
        }
      }
    }

    // Both ways - syncFile handles mtime comparison
    await syncDirs(project.knowns, project.obsidian)
    await syncDirs(project.obsidian, project.knowns)
  }
  console.log('[INIT] Initial sync complete.')
}

// ── Watchers ─────────────────────────────────────────────────────────────────

function setupWatchers() {
  for (const project of projects) {
    // Watch Knowns
    chokidar.watch(project.knowns, { 
      persistent: true, 
      ignoreInitial: true,
      usePolling: true, // Recommended for Docker volumes on Mac
      interval: 1000
    }).on('all', (event, filePath) => {
      if (!filePath.endsWith('.md')) return
      const relativePath = path.relative(project.knowns, filePath)
      const targetPath = path.join(project.obsidian, relativePath)
      syncFile(filePath, targetPath, `KnownsEvent:${event}`)
    })

    // Watch Obsidian
    chokidar.watch(project.obsidian, { 
      persistent: true, 
      ignoreInitial: true,
      usePolling: true,
      interval: 1000
    }).on('all', (event, filePath) => {
      if (!filePath.endsWith('.md')) return
      const relativePath = path.relative(project.obsidian, filePath)
      const targetPath = path.join(project.knowns, relativePath)
      syncFile(filePath, targetPath, `ObsidianEvent:${event}`)
    })

    console.log(`[WATCH] Monitoring ${project.name}:`)
    console.log(`  - Knowns: ${project.knowns}`)
    console.log(`  - Vault : ${project.obsidian}`)
  }
}

// ── Main ─────────────────────────────────────────────────────────────────────

(async () => {
  await initialSync()
  setupWatchers()
  console.log('[READY] Docs Sync service is running.')
})()
