# Quartz Configuration for Reorganized Vault

## Overview

Your vault is now organized with private (`_` prefixed) and public folders.

## Folder Publishing Strategy

### Public Folders (Publish to Quartz)
- `Projects/` - All project documentation
- `Meta/` - Non-sensitive meeting notes, ideas, research

### Private Folders (Exclude from Quartz)
- `_Inbox/` - Quick capture, work in progress
- `_Sprints/` - Sprint files (may contain work in progress)
- `_Tasks/` - Task tracking (internal use)
- `_System/` - Scripts and templates

## Quartz Ignore Configuration

To exclude private folders, create or update `.quartzignore`:

```
# Private folders (underscore prefix)
content/_Inbox/**
content/_Sprints/**
content/_Tasks/**
content/_System/**

# Old structure (if not yet migrated)
content/Sprints/**
content/Components/**
content/Backend/**
content/Viewports/**
content/Classifications/**
content/Boards/**
content/Tags/**

# System files
.DS_Store
.obsidian/**
*.tmp
```

## Alternative: Quartz Config Modification

If you want more control, modify `quartz.config.ts`:

```typescript
const config: QuartzConfig = {
  configuration: {
    // ... other config
    ignorePatterns: [
      "_Inbox",
      "_Sprints", 
      "_Tasks",
      "_System",
      ".obsidian",
      // Old structure
      "Sprints",
      "Components", 
      "Backend",
      "Viewports",
      "Classifications",
      "Boards",
      "Tags"
    ],
  },
  // ... rest of config
}
```

## Content Organization

### What Gets Published

Your Quartz site will show:

```
/
├── Projects/
│   ├── Star-Sailors/
│   │   ├── Components/
│   │   ├── Features/
│   │   ├── Backend/
│   │   └── ... (all public documentation)
│   ├── Bumble/
│   ├── Roving/
│   └── Station-198/
│
└── Meta/
    ├── Meetings/ (select public ones)
    ├── Ideas/
    ├── Research/
    └── Games/
```

### What Stays Private

- Sprint files (your working notes)
- Task tracking
- Inbox (unorganized notes)
- System files and scripts

## Media Files

Images will be in project-specific folders:
- `Projects/Star-Sailors/Media/Screenshots/`
- `Projects/Bumble/Media/Concept-Art/`
- etc.

These are automatically published with their parent project.

## Tips

1. **Use frontmatter to control publishing:**
```yaml
---
publish: false
---
```

2. **Link between public and private notes:**
- Links from public → private will break on Quartz
- Links from private → public work fine
- Keep sprint files private, component notes public

3. **Review before publishing:**
```bash
# See what will be published
npx quartz build --dry-run
```

4. **Test locally:**
```bash
npx quartz build --serve
```

## Migration Notes

The old folder structure is still in place. You can:

1. **Keep both** - Continue adding to new structure
2. **Gradual migration** - Move files as you work on them
3. **Big bang** - Migrate everything at once

Recommend: Gradual migration. As you work on sprints, move relevant component notes to new structure.

---

*For more on Quartz configuration, see: https://quartz.jzhao.xyz/configuration*
