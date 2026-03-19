#!/usr/bin/env python3
"""
Daily Dashboard Organizer

This script:
1. Reads the daily dashboard
2. Extracts tasks from "Quick Task Creation" section
3. Routes tasks to correct project files based on tags
4. Extracts notes from dump sections
5. Categorizes and moves notes to appropriate locations
6. Generates summary

Usage:
    python3 organize_daily.py [dashboard-file]
    
    Or use vault command:
    vault organize-daily
"""

import re
import sys
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Tuple

class DailyOrganizer:
    """Organize daily dashboard notes and tasks."""
    
    def __init__(self, dashboard_file: Path):
        self.dashboard_file = dashboard_file
        self.vault_root = self._find_vault_root()
        self.content = dashboard_file.read_text(encoding='utf-8')
        self.tasks_to_route: List[Dict] = []
        self.notes_sections: Dict[str, str] = {}
        
    def _find_vault_root(self) -> Path:
        """Find vault root (content directory)."""
        current = self.dashboard_file.parent
        while current.name != 'content' and current.parent != current:
            current = current.parent
        return current if current.name == 'content' else Path.cwd()
    
    def extract_new_tasks(self) -> List[Dict]:
        """Extract tasks from Quick Task Creation section."""
        # Find the "New Tasks" section
        pattern = r'### New Tasks\s*\n(.*?)(?=\n##|\n---|\Z)'
        match = re.search(pattern, self.content, re.DOTALL)
        
        if not match:
            return []
        
        tasks_section = match.group(1)
        
        # Parse tasks: - [ ] Task text #tag ⚡priority
        task_pattern = r'^[\-\*\+]\s*\[([ xX])\]\s*(.+)$'
        tasks = []
        
        for line in tasks_section.split('\n'):
            line = line.strip()
            if not line:
                continue
                
            match = re.match(task_pattern, line)
            if match:
                completed = match.group(1).lower() == 'x'
                text = match.group(2)
                
                # Extract project tags
                project_tags = re.findall(r'#(star-sailors|bumble|roving|station-198|vault)', text, re.IGNORECASE)
                
                # Extract priority
                priority = 'normal'
                if '🔥' in text or 'urgent' in text.lower():
                    priority = 'urgent'
                elif '⚡' in text or 'high' in text.lower():
                    priority = 'high'
                elif '💡' in text or 'idea' in text.lower():
                    priority = 'idea'
                
                # Determine project
                if project_tags:
                    project = project_tags[0].lower()
                else:
                    # Try to infer from keywords
                    project = self._infer_project(text)
                
                tasks.append({
                    'text': text,
                    'completed': completed,
                    'project': project,
                    'priority': priority,
                    'original_line': line
                })
        
        return tasks
    
    def _infer_project(self, text: str) -> str:
        """Infer project from task text."""
        text_lower = text.lower()
        
        keywords = {
            'star-sailors': ['telescope', 'satellite', 'rover', 'planet', 'classification'],
            'bumble': ['bee', 'crop', 'pollinator', 'hive', 'flower', 'garden'],
            'roving': ['roving', 'exploration'],
            'station-198': ['ios', 'swift', 'station'],
            'vault': ['obsidian', 'vault', 'dashboard', 'organize']
        }
        
        for project, project_keywords in keywords.items():
            if any(kw in text_lower for kw in project_keywords):
                return project
        
        return 'unknown'
    
    def route_task_to_file(self, task: Dict) -> Path:
        """Determine target file for a task."""
        project = task['project']
        
        # Map projects to files
        project_files = {
            'star-sailors': self.vault_root / 'Projects' / 'Star-Sailors' / 'Tasks.md',
            'bumble': self.vault_root / 'Projects' / 'Bumble' / 'Tasks.md',
            'roving': self.vault_root / 'Projects' / 'Roving' / 'Tasks.md',
            'station-198': self.vault_root / 'Projects' / 'Station-198' / 'Tasks.md',
            'vault': self.vault_root / '_Tasks' / 'Vault-Tasks.md',
            'unknown': self.vault_root / '_Inbox' / 'Unsorted-Tasks.md'
        }
        
        return project_files.get(project, project_files['unknown'])
    
    def append_task_to_file(self, task: Dict, target_file: Path):
        """Append task to target file."""
        # Create file if doesn't exist
        if not target_file.exists():
            target_file.parent.mkdir(parents=True, exist_ok=True)
            target_file.write_text(f"# {target_file.stem}\n\n## Tasks\n\n", encoding='utf-8')
        
        content = target_file.read_text(encoding='utf-8')
        
        # Format task with priority and timestamp
        priority_marker = {
            'urgent': '🔥',
            'high': '⚡',
            'idea': '💡',
            'normal': ''
        }.get(task['priority'], '')
        
        checkbox = '[x]' if task['completed'] else '[ ]'
        timestamp = datetime.now().strftime('%Y-%m-%d')
        
        task_line = f"- {checkbox} {task['text']} {priority_marker} *(added {timestamp})*\n"
        
        # Find ## Tasks section or append at end
        if '## Tasks' in content:
            # Insert after ## Tasks header
            parts = content.split('## Tasks')
            header = parts[0] + '## Tasks\n'
            body = parts[1] if len(parts) > 1 else '\n'
            
            # Add to top of tasks section
            new_content = header + '\n' + task_line + body
        else:
            # Append to end
            new_content = content + '\n## Tasks\n\n' + task_line
        
        target_file.write_text(new_content, encoding='utf-8')
    
    def extract_notes(self) -> Dict[str, str]:
        """Extract notes from dump sections."""
        sections = {
            'Quick Thoughts': r'### Quick Thoughts\s*\n(.*?)(?=\n###|\n##|\n---|\Z)',
            'Meetings': r'### Meetings & Conversations\s*\n(.*?)(?=\n###|\n##|\n---|\Z)',
            'Ideas': r'### Ideas & Brainstorming\s*\n(.*?)(?=\n###|\n##|\n---|\Z)'
        }
        
        notes = {}
        for section_name, pattern in sections.items():
            match = re.search(pattern, self.content, re.DOTALL)
            if match:
                content = match.group(1).strip()
                if content and content != '':
                    notes[section_name] = content
        
        return notes
    
    def clear_dashboard_sections(self):
        """Clear processed sections in dashboard."""
        # Clear New Tasks section
        self.content = re.sub(
            r'(### New Tasks\s*\n)(.*?)(?=\n##|\n---|\Z)',
            r'\1\n\n\n',
            self.content,
            flags=re.DOTALL
        )
        
        # Clear note dump sections
        for section in ['Quick Thoughts', 'Meetings & Conversations', 'Ideas & Brainstorming']:
            pattern = f'(### {section}\\s*\\n)(.*?)(?=\\n###|\\n##|\\n---|\\Z)'
            self.content = re.sub(
                pattern,
                r'\1\n\n\n',
                self.content,
                flags=re.DOTALL
            )
        
        # Save updated dashboard
        self.dashboard_file.write_text(self.content, encoding='utf-8')
    
    def archive_notes(self, notes: Dict[str, str]):
        """Archive extracted notes to appropriate locations."""
        if not notes:
            return
        
        # Create dated note file
        date_str = datetime.now().strftime('%Y-%m-%d')
        archive_file = self.vault_root / '_Daily' / 'Archive' / f'{date_str}.md'
        archive_file.parent.mkdir(parents=True, exist_ok=True)
        
        archive_content = f"---\ndate: {date_str}\ntags: [daily-notes]\n---\n\n"
        archive_content += f"# Daily Notes - {date_str}\n\n"
        
        for section, content in notes.items():
            archive_content += f"## {section}\n\n{content}\n\n"
        
        archive_file.write_text(archive_content, encoding='utf-8')
        return archive_file
    
    def organize(self, dry_run: bool = False):
        """Run full organization process."""
        print(f"📖 Processing dashboard: {self.dashboard_file.name}\n")
        
        # Extract and route tasks
        tasks = self.extract_new_tasks()
        
        if tasks:
            print(f"✅ Found {len(tasks)} task(s) to route:\n")
            
            routed = {}
            for task in tasks:
                target = self.route_task_to_file(task)
                project = task['project']
                
                if project not in routed:
                    routed[project] = []
                routed[project].append(task)
                
                priority_icon = {'urgent': '🔥', 'high': '⚡', 'idea': '💡', 'normal': '📌'}.get(task['priority'], '📌')
                print(f"  {priority_icon} → {project}: {task['text'][:60]}...")
            
            if not dry_run:
                # Actually route tasks
                for task in tasks:
                    target = self.route_task_to_file(task)
                    self.append_task_to_file(task, target)
                
                print(f"\n✅ Routed tasks to project files")
            else:
                print(f"\n💡 Dry run - tasks not moved")
        else:
            print("ℹ️  No new tasks to route\n")
        
        # Extract and archive notes
        notes = self.extract_notes()
        
        if notes:
            print(f"\n📝 Found notes in {len(notes)} section(s):")
            for section in notes.keys():
                print(f"  • {section}")
            
            if not dry_run:
                archive_file = self.archive_notes(notes)
                print(f"\n✅ Archived to: {archive_file.relative_to(self.vault_root)}")
            else:
                print(f"\n💡 Dry run - notes not archived")
        else:
            print("\nℹ️  No notes to archive")
        
        # Clear dashboard sections
        if not dry_run and (tasks or notes):
            self.clear_dashboard_sections()
            print(f"\n🧹 Cleared dashboard sections")
        
        print(f"\n✨ Organization complete!")


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Organize daily dashboard notes and tasks")
    parser.add_argument('dashboard_file', nargs='?', help='Path to dashboard file')
    parser.add_argument('--dry-run', action='store_true', help='Preview changes without applying')
    
    args = parser.parse_args()
    
    # Find dashboard file
    if args.dashboard_file:
        dashboard_path = Path(args.dashboard_file)
    else:
        # Look for today's dashboard
        today = datetime.now().strftime('%Y-%m-%d')
        dashboard_path = Path.cwd() / 'content' / '_Daily' / f'{today}.md'
        
        if not dashboard_path.exists():
            # Try Dashboard-Template or most recent
            template = Path.cwd() / 'content' / '_Daily' / 'Dashboard-Template.md'
            if template.exists():
                dashboard_path = template
            else:
                print("❌ No dashboard file found")
                print(f"   Tried: {dashboard_path}")
                sys.exit(1)
    
    if not dashboard_path.exists():
        print(f"❌ Dashboard file not found: {dashboard_path}")
        sys.exit(1)
    
    try:
        organizer = DailyOrganizer(dashboard_path)
        organizer.organize(dry_run=args.dry_run)
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
