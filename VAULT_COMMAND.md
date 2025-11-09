# Vault Command Reference

## Installation

### One-Time Setup
```bash
cd content/_System/Scripts
./install-vault-command.sh
```

This will:
1. Install the `vault` command globally
2. Add it to your PATH (if needed)
3. Set up the Python virtual environment

### Manual Setup (Alternative)
```bash
# Add to your ~/.zshrc:
export PATH="$HOME/.local/bin:$PATH"

# Create symlink manually:
ln -s /Users/scroobz/Navigation/quartz/content/_System/Scripts/vault ~/.local/bin/vault

# Setup environment:
vault setup
```

## Usage

### Quick Commands

```bash
# Setup (first time only)
vault setup

# Organize current sprint
vault organize

# Organize specific sprint
vault organize 294
vault organize SSG-294

# Create new sprint
vault new-sprint 296

# View tasks
vault tasks

# Migrate old content
vault migrate              # Dry run
vault migrate --auto       # Execute

# Interactive menu
vault menu
```

## Command Reference

### `vault setup`
Sets up Python virtual environment and installs dependencies.
- **When to use:** First time, or after Python upgrade
- **Location:** Creates `.venv` in vault root

### `vault organize [sprint]`
Organizes sprint file - extracts tasks, identifies images, generates summaries.
- **No args:** Organizes most recent active sprint
- **With number:** `vault organize 294` → organizes SSG-294
- **With path:** `vault organize /path/to/SSG-294.md`
- **Output:** `_Tasks/Current-Sprint.md` updated

### `vault new-sprint <number>`
Creates new sprint from template.
- **Required:** Sprint number
- **Example:** `vault new-sprint 296`
- **Output:** `_Sprints/Active/SSG-296.md`
- **Auto-fills:** Current date, sprint number

### `vault tasks`
Views current sprint tasks.
- **Shows:** `_Tasks/Current-Sprint.md`
- **Uses:** bat/less/cat (whichever available)

### `vault migrate [--auto]`
Migrates old content to new structure.
- **Default:** Dry run (shows what will happen)
- **--auto:** Actually executes migration
- **Output:** Migration report

### `vault menu`
Interactive menu for all operations.
- Same as running `quick-start.sh`
- **Use when:** You want a guided experience

## Workflows

### Daily Workflow
```bash
# Open your current sprint in Obsidian
# Work throughout the day, adding notes and tasks

# End of day - organize
vault organize
```

### Starting New Sprint
```bash
# Create new sprint
vault new-sprint 296

# Open in Obsidian and start working
# (Sprint template already filled with date and number)
```

### Checking Progress
```bash
# View all current tasks
vault tasks

# Or check specific sprint
vault organize 294
vault tasks
```

### Weekly Organization
```bash
# Organize all active sprints
vault organize 294
vault organize 295

# Check tasks
vault tasks

# Optional: Migrate old content
vault migrate
```

## Virtual Environment

### What It Does
- Creates isolated Python environment (`.venv/`)
- Installs required packages automatically
- Activates/deactivates automatically for each command

### Location
```
/Users/scroobz/Navigation/quartz/.venv/
```

### Manual Activation (if needed)
```bash
source /Users/scroobz/Navigation/quartz/.venv/bin/activate
python3 organize_sprint.py <file>
deactivate
```

### Packages Installed
- pathlib (for file operations)
- Standard library modules (no external deps needed)

### Troubleshooting
```bash
# Recreate environment
rm -rf /Users/scroobz/Navigation/quartz/.venv
vault setup

# Check Python version
python3 --version

# Verify installation
which vault
vault --help
```

## Environment Variables

The vault command automatically detects:
- `SCRIPT_DIR` - Where scripts are located
- `VAULT_ROOT` - Vault root directory
- `VENV_DIR` - Virtual environment location

## File Locations

### Scripts
```
content/_System/Scripts/
├── vault                        # Main command
├── install-vault-command.sh     # Installer
├── setup-venv.sh                # Venv setup
├── organize_sprint.py           # Sprint organizer
├── migrate_content.py           # Content migrator
└── quick-start.sh               # Interactive menu
```

### Generated Files
```
.venv/                           # Virtual environment
content/_Tasks/Current-Sprint.md # Current tasks
MIGRATION_REPORT.md              # Migration report
```

## Tips & Tricks

### Aliases (Optional)
Add to your `~/.zshrc`:
```bash
alias vo="vault organize"
alias vn="vault new-sprint"
alias vt="vault tasks"
alias vm="vault menu"
```

### Auto-Organize on Save
Set up Obsidian to run `vault organize` when you save sprint files.

### Quick Access
```bash
# From anywhere:
vault organize

# Or with full path:
/Users/scroobz/Navigation/quartz/content/_System/Scripts/vault organize
```

### Tab Completion
The vault command supports:
```bash
vault <TAB>          # Shows available commands
vault organize <TAB> # Shows active sprints (if implemented)
```

## Examples

### Example 1: Daily Work
```bash
# Morning - check what's on your plate
vault tasks

# Throughout the day - work in Obsidian
# Add tasks: - [ ] Fix bug #star-sailors #bug #BUG-1

# Evening - organize
vault organize

# Check updated tasks
vault tasks
```

### Example 2: New Sprint
```bash
# Create sprint
vault new-sprint 296

# Open in Obsidian, fill in:
# - Sprint goals
# - Epic references
# - Initial tasks

# Start working
# (notes, tasks, images all in one file)

# Organize when ready
vault organize 296
```

### Example 3: Migration
```bash
# See what will be migrated
vault migrate

# Review MIGRATION_REPORT.md

# Execute if looks good
vault migrate --auto

# Verify in Obsidian
```

## Troubleshooting

### "vault: command not found"
```bash
# Check installation
ls -la ~/.local/bin/vault

# Reinstall
cd content/_System/Scripts
./install-vault-command.sh

# Check PATH
echo $PATH | grep ".local/bin"

# Add to PATH if missing
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "No active sprint files found"
```bash
# Create one
vault new-sprint 296

# Or move existing sprint to Active
mv content/Sprints/SSG-XXX.md content/_Sprints/Active/
```

### "Virtual environment not working"
```bash
# Recreate
rm -rf /Users/scroobz/Navigation/quartz/.venv
vault setup

# Or run manually
cd content/_System/Scripts
./setup-venv.sh
```

### Scripts hanging or not completing
```bash
# Check Python
python3 --version

# Run script directly to see errors
cd content/_System/Scripts
python3 organize_sprint.py ../../_Sprints/Active/SSG-294.md
```

## Support

For more information:
- **Workflow Guide:** `WORKFLOW_GUIDE.md`
- **Documentation Index:** `DOCUMENTATION_INDEX.md`
- **Quick Start:** `vault menu`

---

*Created: 2025-11-08*
*Vault command version: 1.0*
