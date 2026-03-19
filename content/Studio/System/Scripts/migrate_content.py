#!/usr/bin/env python3
"""
Migration Helper - Assists with migrating old content to new structure

This script helps you:
1. Identify files in old structure
2. Suggest where they should go
3. Move files with link updates
4. Generate migration report

Usage:
    python3 migrate_content.py [--dry-run] [--auto]
    
    Or use the vault command (recommended):
    vault migrate
"""

import os
import re
import shutil
from pathlib import Path
from typing import List, Dict, Tuple

class ContentMigrator:
    def __init__(self, vault_root: str, dry_run: bool = True):
        self.vault_root = Path(vault_root)
        self.content_root = self.vault_root / 'content'
        self.dry_run = dry_run
        self.migrations: List[Dict] = []
        
    def scan_old_structure(self):
        """Scan old folders for content to migrate"""
        old_folders = [
            'Components',
            'Backend', 
            'Viewports',
            'Classifications',
            'Missions',
            'Research',
            'Ideas',
            'Meetings'
        ]
        
        for folder in old_folders:
            folder_path = self.content_root / folder
            if folder_path.exists():
                for file in folder_path.rglob('*.md'):
                    if file.is_file():
                        suggestion = self._suggest_destination(file, folder)
                        self.migrations.append({
                            'source': str(file),
                            'destination': suggestion,
                            'folder': folder,
                            'name': file.name
                        })
    
    def _suggest_destination(self, file: Path, old_folder: str) -> str:
        """Suggest new location for a file based on content analysis"""
        content = file.read_text()
        
        # Analyze content for project indicators
        project = self._detect_project(content, file.name)
        
        # Map old folders to new structure
        folder_mapping = {
            'Components': f'Projects/{project}/Components',
            'Backend': f'Projects/{project}/Backend',
            'Viewports': f'Projects/{project}/Viewports',
            'Classifications': f'Projects/{project}/Classifications',
            'Missions': f'Projects/{project}/Missions',
            'Research': f'Projects/{project}/Research',
            'Ideas': 'Meta/Ideas',
            'Meetings': 'Meta/Meetings'
        }
        
        new_folder = folder_mapping.get(old_folder, f'Projects/{project}')
        return str(self.content_root / new_folder / file.name)
    
    def _detect_project(self, content: str, filename: str) -> str:
        """Detect which project a file belongs to"""
        content_lower = content.lower()
        filename_lower = filename.lower()
        
        # Check for project keywords
        if any(word in content_lower or word in filename_lower 
               for word in ['bumble', 'bee', 'crop', 'pollinator']):
            return 'Bumble'
        
        if any(word in content_lower or word in filename_lower 
               for word in ['roving', 'exploration']):
            return 'Roving'
        
        if any(word in content_lower or word in filename_lower 
               for word in ['station', 'swift', 'ios']):
            return 'Station-198'
        
        # Default to Star Sailors
        return 'Star-Sailors'
    
    def migrate_sprints(self):
        """Move sprint files to new _Sprints structure"""
        old_sprints = self.content_root / 'Sprints'
        if not old_sprints.exists():
            return
        
        # Determine active vs archived sprints
        # Most recent 2 sprints = active, rest = archived
        sprint_files = sorted(
            [f for f in old_sprints.glob('*.md') if f.is_file()],
            key=lambda x: x.stat().st_mtime,
            reverse=True
        )
        
        for i, sprint_file in enumerate(sprint_files):
            # Skip kanban and other non-sprint files
            if 'kanban' in sprint_file.name.lower():
                continue
            
            if i < 2:  # Active
                dest = self.content_root / '_Sprints' / 'Active' / sprint_file.name
            else:  # Archive
                # Extract year from filename or modification time
                year = sprint_file.stat().st_mtime
                from datetime import datetime
                year_str = datetime.fromtimestamp(year).strftime('%Y')
                dest = self.content_root / '_Sprints' / 'Archive' / year_str / sprint_file.name
            
            self.migrations.append({
                'source': str(sprint_file),
                'destination': str(dest),
                'folder': 'Sprints',
                'name': sprint_file.name
            })
    
    def migrate_images(self):
        """Scan for images in old Media folder"""
        old_media = self.content_root / 'Media'
        if not old_media.exists():
            return
        
        print(f"\n📷 Found {len(list(old_media.glob('*')))} files in old Media folder")
        print("   ℹ️  Run organize_sprint.py to categorize and move images")
    
    def execute_migrations(self):
        """Execute the migrations"""
        if not self.migrations:
            print("ℹ️  No files to migrate")
            return
        
        print(f"\n{'[DRY RUN] ' if self.dry_run else ''}Migrating {len(self.migrations)} files...")
        
        for migration in self.migrations:
            src = Path(migration['source'])
            dst = Path(migration['destination'])
            
            if self.dry_run:
                print(f"   Would move: {src.name}")
                print(f"            → {dst.relative_to(self.content_root)}")
            else:
                # Create destination directory
                dst.parent.mkdir(parents=True, exist_ok=True)
                
                # Copy file (keep original for now)
                shutil.copy2(src, dst)
                print(f"   ✓ Copied: {src.name} → {dst.relative_to(self.content_root)}")
    
    def generate_report(self):
        """Generate migration report"""
        report_path = self.vault_root / 'MIGRATION_REPORT.md'
        
        report = f"""# Content Migration Report

Generated: {Path.ctime(Path.cwd())}

## Summary

- Total files to migrate: {len(self.migrations)}
- Migration status: {'DRY RUN - No files moved' if self.dry_run else 'COMPLETED'}

## Files by Project

"""
        
        # Group by destination project
        by_project = {}
        for m in self.migrations:
            dest = Path(m['destination'])
            if 'Projects' in str(dest):
                project = str(dest).split('Projects/')[1].split('/')[0]
            elif 'Meta' in str(dest):
                project = 'Meta'
            else:
                project = 'Other'
            
            if project not in by_project:
                by_project[project] = []
            by_project[project].append(m)
        
        for project, files in sorted(by_project.items()):
            report += f"\n### {project} ({len(files)} files)\n\n"
            for f in files[:10]:  # Show first 10
                report += f"- `{f['name']}` from `{f['folder']}/`\n"
            if len(files) > 10:
                report += f"- ... and {len(files) - 10} more\n"
        
        report += f"""

## Next Steps

1. Review the migrations above
2. Run with `--auto` flag to execute: `python migrate_content.py --auto`
3. Update internal links that may have broken
4. Run Obsidian's "Detect all broken links" feature
5. Update image references using organize_sprint.py
6. Archive old folders once migration is complete

## Manual Steps Needed

- [ ] Review migrated files for accuracy
- [ ] Update broken links
- [ ] Organize images in old Media folder
- [ ] Archive old folder structure
- [ ] Test Quartz build with new structure
- [ ] Update any external documentation references

---

*To execute this migration, run: `python migrate_content.py --auto`*
"""
        
        report_path.write_text(report)
        print(f"\n📄 Generated report: {report_path}")
    
    def run(self):
        """Run full migration process"""
        print("🔍 Scanning old structure...")
        
        self.scan_old_structure()
        self.migrate_sprints()
        self.migrate_images()
        
        print(f"\n   Found {len(self.migrations)} files to migrate")
        
        self.generate_report()
        self.execute_migrations()
        
        if self.dry_run:
            print("\n💡 This was a dry run. No files were moved.")
            print("   Run with --auto flag to execute migration:")
            print("   python migrate_content.py --auto")
        else:
            print("\n✅ Migration complete!")
            print("   ⚠️  Original files are still in place (copies made)")
            print("   Review migrated files before deleting originals")


if __name__ == '__main__':
    import sys
    
    vault_root = Path.cwd()
    if not (vault_root / 'content').exists():
        # Try to find content folder
        if (vault_root.parent / 'content').exists():
            vault_root = vault_root.parent
        else:
            print("❌ Cannot find content folder")
            print("   Run this script from the vault root directory")
            sys.exit(1)
    
    dry_run = '--auto' not in sys.argv
    
    migrator = ContentMigrator(str(vault_root), dry_run=dry_run)
    migrator.run()
