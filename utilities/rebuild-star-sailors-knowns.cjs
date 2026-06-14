#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const apply = process.argv.includes('--apply');
const now = '2026-04-20T00:00:00+10:00';
const resetFolder = '2026-04-20-project-management-reset';

const projects = [
  {
    key: 'STAR_SAILORS_CLIENT',
    name: 'Star Sailors Web Client',
    root: '/Users/scroobz/Navigation/client',
    tasks: [
      task('ssw001', 'Define and lock Star Sailors 3.0 MVP route map', 'high', ['mvp', 'planning', 'web-client'], [
        'Audit the current landing, game hub, onboarding, setup, and first classification routes.',
        'Write the locked first-session path and identify every screen that belongs in MVP.',
        'Move non-MVP route work into backlog/reference notes.',
      ], [
        'Golden path is documented from landing to first science contribution.',
        'Current blocker list is limited to tester-visible failures.',
        'First external tester script exists or is updated.',
      ]),
      task('ssw002', 'Stabilize first-session onboarding and science contribution', 'high', ['mvp', 'onboarding', 'classification'], [
        'Make the first user path launch into the web client, not a vague ecosystem browse.',
        'Verify project choice, structure setup, deploy/classify flow, reward/progress update, and feedback prompt.',
      ], [
        'A new user can complete one science contribution without manual DB edits.',
        'The path works for the chosen MVP project type.',
        'Failures are captured as concrete follow-up notes.',
      ]),
      task('ssw003', 'Run mobile PWA and safe-area release pass', 'high', ['mvp', 'mobile', 'pwa', 'ux'], [
        'Check /apt, /game, and active structure viewports on narrow mobile sizes.',
        'Fix or document PWA status bar, safe-area, bottom nav, modal, and pinch-zoom issues on the MVP path.',
      ], [
        'Landing page remains zoomable/accessibility-safe where appropriate.',
        'Game route critical UI is not clipped by phone safe areas.',
        'Known unresolved layout defects are written into the tester notes.',
      ]),
      task('ssw004', 'Prepare web-client distribution and feedback cohort', 'high', ['release', 'testing', 'analytics'], [
        'Confirm production/staging URL, release command sequence, PostHog/Sentry coverage, and feedback capture.',
        'Create the first tester script for web-client MVP validation.',
      ], [
        'Tester can be sent one URL plus a short script.',
        'PostHog/Sentry or equivalent captures the critical events/errors.',
        'Rollback/disable path is documented.',
      ]),
      task('ssw005', 'Specify the citizen-science project intake surface for the web client', 'medium', ['project-intake', 'citizen-science', 'admin'], [
        'Turn the new intake template into a web-client integration spec.',
        'Define the minimum fields needed to add a new project/game without rewriting the app.',
      ], [
        'Spec names required data model fields, UI surface, and task generation path.',
        'Integration can be implemented later with Go/PocketBase or Prisma without changing MVP scope.',
      ]),
    ],
  },
  {
    key: 'SAILY',
    name: 'Saily / The Daily Sail',
    root: '/Users/scroobz/Navigation/saily',
    tasks: [
      task('sly001', 'Refresh Saily v0 readiness on current code', 'high', ['mvp', 'release', 'v0'], [
        'Run the current readiness script and capture failures.',
        'Update launch, rollback, and first-tester dates for the current week.',
      ], [
        'Readiness command result is recorded.',
        'Launch/rollback checklist reflects the current build, not March assumptions.',
        'Only blocking failures remain active.',
      ]),
      task('sly002', 'Lock the daily mission MVP to one playable path', 'high', ['mvp', 'daily-game', 'ux'], [
        'Constrain the MVP path to briefing, one puzzle, submission, result, and progress update.',
        'Hide or de-emphasize non-MVP nav/pages that distract testers.',
      ], [
        'Today mission can be completed from a clean session.',
        'Non-MVP surfaces do not block or confuse the first-session test.',
        'Submission creates the expected progress/streak state.',
      ]),
      task('sly003', 'Run mobile PWA external tester pass', 'high', ['pwa', 'mobile', 'testing'], [
        'Test install/offline shell behavior and Melbourne midnight reset assumptions.',
        'Capture screenshots for any clipping or navigation issue.',
      ], [
        'PWA install path is either working or documented with exact blocker.',
        'Offline shell does not break the MVP path.',
        'Tester notes include device/browser coverage.',
      ]),
      task('sly004', 'Define next science-feed cache intake for daily puzzles', 'medium', ['science-data', 'ingestion', 'planning'], [
        'Use the importable science feeds research to pick the next practical data source.',
        'Define how raw source data becomes a stable daily mission cache.',
      ], [
        'One source is selected for the next post-MVP expansion.',
        'Cache schema and ingestion steps are documented.',
        'No live API dependency is required for the daily play path.',
      ]),
    ],
  },
  {
    key: 'PLANET_HUNTERS_EXPERIMENT_1',
    name: 'Planet Hunters Experiment 1',
    root: '/Users/scroobz/Navigation/Native/planet-hunters-experiment-1',
    tasks: [
      task('phx001', 'Rebaseline Planet Hunters MVP scope to M1-M4 plus Free Ops', 'high', ['mvp', 'planning', 'scope-lock'], [
        'Confirm M1-M4 authored onboarding plus Free Operations is the only active MVP scope.',
        'Update the open-task handoff notes if they contradict this scope.',
      ], [
        'No authored Mission 5 work is active.',
        'MVP scope is visible from the repo docs and this command center.',
        'Deferred room/art/construction work is clearly marked.',
      ]),
      task('phx002', 'Close first-session flow clarity blockers', 'high', ['mvp', 'onboarding', 'ux'], [
        'Address PWA installed layout, install prompt, first mission payout, next mission CTA, and button guide as one tester-readiness pass.',
      ], [
        'Tester can complete first mission and know what to do next.',
        'First mission payout does not create a dead-end.',
        'Visible buttons have plain-language help.',
      ]),
      task('phx003', 'Validate mining mobile layout and target-specific generation', 'high', ['mining', 'mobile', 'testing'], [
        'Verify mining scene direct entry, portrait/mobile layout, and target-seeded terrain/mineral uniqueness.',
      ], [
        'Mining scene opens directly for testing.',
        'Critical HUD controls are visible in portrait mobile.',
        'Two different target IDs produce meaningfully different terrain/mineral results.',
      ]),
      task('phx004', 'Prepare browser distribution test pack', 'high', ['release', 'pwa', 'testing'], [
        'Run/export the browser build and capture the exact distribution path.',
        'Write the first external tester script and feedback capture instructions.',
      ], [
        'There is a playable URL or exported build path.',
        'Tester script covers launch, mine, debrief, next mission, and PWA behavior.',
        'Rollback/revert path is documented.',
      ]),
      task('phx005', 'Triage asset generation queue to MVP-only needs', 'medium', ['assets', 'scope', 'prompts'], [
        'Review room/super-sheet generation work and keep only assets needed for M1-M4 plus Free Ops.',
      ], [
        'MVP-required asset list is separated from future prompt batches.',
        'No broad art-generation task blocks tester distribution.',
      ]),
    ],
  },
  {
    key: 'CLICK_A_CORAL',
    name: 'Click-A-Coral',
    root: '/Users/scroobz/Navigation/Coral',
    tasks: [
      task('cor001', 'Replace debug web host with player-facing Coral PWA shell', 'high', ['mvp', 'pwa', 'release'], [
        'Remove or hide direct debug controls, bridge logs, and raw Supabase controls from the player entry point.',
        'Make the browser/PWA shell feel like the game.',
      ], [
        'Player can launch the current MVP path from a clean shell.',
        'Debug tools are unavailable to normal testers.',
        'PWA shell has basic title, install, and restart behavior documented.',
      ]),
      task('cor002', 'Finish 10-level content wiring and real subject IDs', 'high', ['mvp', 'content', 'citizen-science'], [
        'Assign real subject IDs to starter level data and verify no level uses placeholder/empty subject coverage.',
      ], [
        'All MVP levels have subject IDs or an explicit fallback rule.',
        'Identify phase receives the expected subject for each level.',
        'Missing data behavior is tester-safe.',
      ]),
      task('cor003', 'Enforce mandatory identify and verify offline queue', 'high', ['mvp', 'identify', 'offline'], [
        'Remove or redesign non-tutorial identify skip behavior.',
        'Verify classifications and pending rewards survive offline/reconnect.',
      ], [
        'Non-tutorial levels require identify before puzzle play.',
        'Offline submission path is verified or blocked with exact failure notes.',
        'Pending reward sync is covered by a repeatable test.',
      ]),
      task('cor004', 'Polish late-game readable surfaces for MVP', 'high', ['mvp', 'ui', 'tank', 'hud'], [
        'Improve turn results, water HUD, and Tank MVP presentation for 3-species and 6-8-species reefs.',
      ], [
        'Target species and threat species are visually distinguishable.',
        'Tank communicates stored bonus species, decorative interaction, and passive production.',
        'HUD remains readable on mobile-first viewports.',
      ]),
      task('cor005', 'Add core audio and run QA tour sign-off', 'medium', ['audio', 'qa', 'release'], [
        'Add or verify basic audio for identify, puzzle, and result phases.',
        'Run the repeatable QA tour/acceptance flow before external testing.',
      ], [
        'Core loop has basic audio feedback or a documented mute/no-audio decision.',
        'QA tour passes or produces a short blocker list.',
      ]),
    ],
  },
  {
    key: 'BUMBLE',
    name: 'Bumble / Bee Garden',
    root: '/Users/scroobz/Navigation/bee-garden',
    tasks: [
      task('bum001', 'Reconstruct Bumble MVP from notes and current repo state', 'high', ['mvp', 'planning', 'bumble'], [
        'Audit current app state against crop, hive, pollination, and order notes.',
        'Write a one-page MVP spec in the repo or vault.',
      ], [
        'MVP loop and first-session script are explicit.',
        'Deferred systems are listed separately.',
        'Repo entry points and launch command are documented.',
      ]),
      task('bum002', 'Ship one garden loop vertical slice', 'high', ['mvp', 'gameplay', 'garden'], [
        'Implement or verify plant, grow/harvest, hive nectar, pollination reward, and inventory update for one crop/hive setup.',
      ], [
        'A tester can complete one garden loop without dev tools.',
        'Pollination reward is visible and understandable.',
        'State persists across a restart if persistence exists in the current app.',
      ]),
      task('bum003', 'Ship one order-fulfillment vertical slice', 'high', ['mvp', 'orders', 'economy'], [
        'Implement or verify one NPC/request, inventory requirement check, fulfillment, reward, and next-action prompt.',
      ], [
        'Tester can fulfill one order after producing the required item.',
        'Reward and low-stock feedback are visible.',
        'Order UI works on mobile.',
      ]),
      task('bum004', 'Choose and verify first distribution target', 'high', ['release', 'mobile', 'testing'], [
        'Decide whether first Bumble tester build is Expo/native, PWA, or local web.',
        'Run the smallest smoke test for that target.',
      ], [
        'Distribution target is documented.',
        'Build/run command is known.',
        'Tester script and feedback path exist.',
      ]),
      task('bum005', 'Create minimum bee crop order content set and sketches', 'medium', ['content', 'sketches', 'assets'], [
        'Define the first crop, first hive, first bee/pollination reward, and first order.',
        'Attach sketches or asset references in Obsidian.',
      ], [
        'Minimum content list exists.',
        'Sketches/assets are referenced from the MVP spec.',
        'No full crop/season system is required for MVP.',
      ]),
    ],
  },
  {
    key: 'PROJECT_MANAGEMENT',
    name: 'Star Sailors Project Management',
    root: '/Users/scroobz/Navigation/quartz',
    tasks: [
      task('pm0001', 'Maintain this week MVP command center', 'high', ['planning', 'obsidian', 'mvp'], [
        'Keep the command center and weekly plan aligned with actual project state.',
        'Do not allow old backlog items to re-enter active work without MVP justification.',
      ], [
        'Command center reflects current MVP priorities.',
        'Weekly plan has current project choices and tester/distribution status.',
      ]),
      task('pm0002', 'Implement new citizen-science project intake template', 'high', ['project-intake', 'obsidian', 'agents'], [
        'Use the new template for one sample/intended project and refine required fields.',
      ], [
        'A new project can be described without agent rediscovery.',
        'Generated first-week tasks stay under five items.',
      ]),
      task('pm0003', 'Design Go PocketBase remote project-management backbone', 'high', ['pocketbase', 'golang', 'architecture'], [
        'Define schema, hosting, auth, agent token permissions, and sync rules for a remote project/task/session database.',
      ], [
        'Decision doc covers collections, access, deployment target, and migration path from file-based Obsidian/Knowns.',
        'No implementation begins until the scope is small enough to finish.',
      ]),
      task('pm0004', 'Wire Obsidian Knowns Things agent handoff loop', 'high', ['things', 'knowns', 'agents', 'workflow'], [
        'Define which tool is source of truth and how daily tasks mirror into Things.',
        'Define how Codex, Claude, and Gemini receive session packets and write handoffs.',
      ], [
        'Things is not a second backlog.',
        'Agent packet format is documented and used for at least one session.',
        'End-of-day sync path is clear.',
      ]),
      task('pm0005', 'Create weekly agent session packets for active projects', 'high', ['agents', 'testing', 'handoff'], [
        'Prepare ready-to-run packets for the first two active implementation projects this week.',
      ], [
        'Each packet names repo, source docs, scope, verification, out-of-scope, and handoff destination.',
        'Packets are short enough to paste into Codex, Claude, or Gemini.',
      ]),
      task('pm0006', 'Import sketches and attach them to project briefs', 'medium', ['sketches', 'obsidian', 'assets'], [
        'Create a consistent media/project-intake folder layout and attach current sketches to the relevant project notes.',
      ], [
        'Sketches are findable from project briefs.',
        'Each sketch has a caption and the decision it informs.',
      ]),
      task('pm0007', 'Decide original native Star Sailors role for 2026 MVP work', 'medium', ['native', 'scope', 'archive'], [
        'Confirm whether the original Swift app is archive/reference only or needs a concrete distribution/code-reuse task.',
      ], [
        'Native app does not silently compete with active MVP work.',
        'Any active native work has a named reason and task.',
      ]),
    ],
  },
];

function task(id, title, priority, labels, plan, criteria) {
  return { id, title, priority, labels, plan, criteria };
}

function slugify(title) {
  return title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 90);
}

function renderTask(project, item) {
  const labels = item.labels.map((label) => `  - ${label}`).join('\n');
  const plan = item.plan.map((line, index) => `${index + 1}. ${line}`).join('\n');
  const criteria = item.criteria.map((line) => `- [ ] ${line}`).join('\n');

  return `---\nid: ${item.id}\ntitle: ${JSON.stringify(item.title)}\nstatus: todo\npriority: ${item.priority}\nlabels:\n${labels}\ncreatedAt: '${now}'\nupdatedAt: '${now}'\ntimeSpent: 0\nassignee: '@me'\n---\n\n# ${item.title}\n\n## Description\n\n<!-- SECTION:DESCRIPTION:BEGIN -->\nThis is part of the 2026-04-20 Star Sailors MVP/project-management reset. Project: ${project.name}. Work must stay tied to MVP closure, distribution, testing, or agent handoff for this week.\n<!-- SECTION:DESCRIPTION:END -->\n\n## Implementation Plan\n\n<!-- SECTION:PLAN:BEGIN -->\n${plan}\n<!-- SECTION:PLAN:END -->\n\n## Acceptance Criteria\n\n${criteria}\n\n## Source Context\n\n- Obsidian command center: /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/Star-Sailors-MVP-Command-Center.md\n- Weekly plan: /Users/scroobz/Navigation/quartz/content/Studio/Project-Management/This-Week-MVP-Execution-Plan-2026-04-20.md\n\n## Implementation Notes\n\n<!-- SECTION:NOTES:BEGIN -->\nCreated by project-management reset on 2026-04-20.\n<!-- SECTION:NOTES:END -->\n`;
}

function ensureDir(dir) {
  if (!apply) return;
  fs.mkdirSync(dir, { recursive: true });
}

function archiveCurrentTasks(project) {
  const knownsDir = path.join(project.root, '.knowns');
  const tasksDir = path.join(knownsDir, 'tasks');
  const archiveDir = path.join(knownsDir, 'archive', resetFolder);

  const existing = fs.existsSync(tasksDir)
    ? fs.readdirSync(tasksDir).filter((file) => /^task-.*\.md(\.bak)?$/.test(file))
    : [];

  console.log(`${project.key}: archive ${existing.length} current task(s), create ${project.tasks.length} new task(s).`);

  if (!apply) return;

  ensureDir(tasksDir);
  ensureDir(archiveDir);

  const readme = [
    `# ${resetFolder}`,
    '',
    `Archived ${existing.length} task file(s) from ${project.name} during the Star Sailors project-management reset.`,
    '',
    'These files were not deleted. They were removed from the active Knowns task board so this week can focus on MVP closure, distribution, testing, and agent handoff.',
    '',
  ].join('\n');
  fs.writeFileSync(path.join(archiveDir, 'README.md'), readme, 'utf8');

  for (const file of existing) {
    const from = path.join(tasksDir, file);
    let to = path.join(archiveDir, file);
    if (fs.existsSync(to)) {
      const parsed = path.parse(file);
      to = path.join(archiveDir, `${parsed.name}-${Date.now()}${parsed.ext}`);
    }
    fs.renameSync(from, to);
  }
}

function writeNewTasks(project) {
  const tasksDir = path.join(project.root, '.knowns', 'tasks');
  if (apply) ensureDir(tasksDir);

  for (const item of project.tasks) {
    const file = `task-${item.id} - ${slugify(item.title)}.md`;
    const target = path.join(tasksDir, file);
    if (apply) fs.writeFileSync(target, renderTask(project, item), 'utf8');
  }
}

for (const project of projects) {
  archiveCurrentTasks(project);
  writeNewTasks(project);
}

if (!apply) {
  console.log('\nDry run only. Re-run with --apply to archive and reseed tasks.');
} else {
  console.log('\nApplied Star Sailors Knowns reset.');
}
