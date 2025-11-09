#!/usr/bin/env python3
"""
Sprint Organizer - Extracts tasks and images from sprint files

This script:
1. Parses the current sprint file
2. Extracts all tasks with their tags
3. Identifies image references
4. Suggests file organization
5. Generates task summary files
6. Creates backlinks

Usage:
    python3 organize_sprint.py [sprint-file-path]
    
    Or use the vault command (recommended):
    vault organize
"""

import re
import os
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Tuple
import shutil

class SprintOrganizer:
    def __init__(self, sprint_file: str):
        self.sprint_file = Path(sprint_file)
        self.sprint_name = self.sprint_file.stem
        self.content = self.sprint_file.read_text()
        self.vault_root = self._find_vault_root()
        self.tasks: List[Dict] = []
        self.images: List[Dict] = []
        self.components_mentioned: List[str] = []
        
    def _find_vault_root(self) -> Path:
        """Find the vault root (content directory)"""
        current = self.sprint_file.parent
        while current.name != 'content' and current.parent != current:
            current = current.parent
        return current if current.name == 'content' else Path.cwd()
    
    def parse_tasks(self):
        """Extract all tasks from the sprint file"""
        # Pattern: supports -, *, + list markers and [ ]/[x] (case-insensitive)
        # Examples matched:
        #   - [ ] task
        #   *  [x] another task
        #   + [X] done
        task_pattern = r'^[\-\*\+]\s*\[([ xX])\]\s*(.+)$'

        for line_num, line in enumerate(self.content.split('\n'), 1):
            match = re.match(task_pattern, line.strip())
            if match:
                completed = match.group(1).lower() == 'x'
                task_text = match.group(2)
                
                # Extract tags (words starting with #)
                tags = re.findall(r'#([\w-]+)', task_text)
                
                # Determine project
                project = self._determine_project(tags, task_text)
                
                # Extract ticket ID (format #COMPONENT-NUMBER)
                ticket_match = re.search(r'#([A-Z]+-\d+)', task_text)
                ticket_id = ticket_match.group(1) if ticket_match else None
                
                self.tasks.append({
                    'line': line_num,
                    'completed': completed,
                    'text': task_text,
                    'tags': tags,
                    'project': project,
                    'ticket_id': ticket_id,
                    'sprint': self.sprint_name
                })
    
    def _determine_project(self, tags: List[str], text: str) -> str:
        """Determine which project a task belongs to"""
        text_lower = text.lower()
        
        # Check tags first
        project_tags = {
            'star-sailors': ['SS', 'star-sailors', 'telescope', 'satellite', 'rover'],
            'bumble': ['bumble', 'BUMBLE', 'bee', 'crop', 'SOIL'],
            'roving': ['roving', 'ROVING'],
            'station-198': ['station-198', 'station198']
        }
        
        for project, project_tag_list in project_tags.items():
            if any(tag in tags for tag in project_tag_list):
                return project
            if any(pt.lower() in text_lower for pt in project_tag_list):
                return project
        
        return 'unknown'
    
    def parse_images(self):
        """Extract all image references"""
        # Patterns: ![[image.png]] or ![](image.png)
        wikilink_pattern = r'!\[\[([^\]]+)\]\]'
        markdown_pattern = r'!\[([^\]]*)\]\(([^\)]+)\)'
        
        for line_num, line in enumerate(self.content.split('\n'), 1):
            # Find wikilink style images
            for match in re.finditer(wikilink_pattern, line):
                image_ref = match.group(1)
                # Remove size hints like || 300
                image_name = re.sub(r'\s*\|\|?\s*\d+', '', image_ref)
                
                self.images.append({
                    'line': line_num,
                    'name': image_name.strip(),
                    'type': self._classify_image(image_name),
                    'original_ref': match.group(0)
                })
            
            # Find markdown style images
            for match in re.finditer(markdown_pattern, line):
                self.images.append({
                    'line': line_num,
                    'name': match.group(2),
                    'type': self._classify_image(match.group(2)),
                    'original_ref': match.group(0)
                })
    
    def _classify_image(self, filename: str) -> str:
        """Classify image type based on filename"""
        filename_lower = filename.lower()
        
        if filename_lower.startswith('img_'):
            return 'physical-note'
        elif filename_lower.startswith('pasted image'):
            return 'screenshot'
        elif any(x in filename_lower for x in ['diagram', 'flow', 'chart']):
            return 'diagram'
        elif any(ext in filename_lower for ext in ['.jpeg', '.jpg']):
            if 'img_' in filename_lower:
                return 'physical-note'
            return 'photo'
        else:
            return 'screenshot'
    
    def generate_current_sprint_tasks(self) -> str:
        """Generate Current-Sprint.md content"""
        output = f"""---
title: Current Sprint Tasks
generated: {datetime.now().isoformat()}
sprint: {self.sprint_name}
---

# Current Sprint: {self.sprint_name}

**Source:** [[../../_Sprints/Active/{self.sprint_name}|{self.sprint_name}]]

## Tasks by Project

"""
        
        # Group tasks by project
        projects = {}
        for task in self.tasks:
            project = task['project']
            if project not in projects:
                projects[project] = []
            projects[project].append(task)
        
        # Output by project
        for project, tasks in sorted(projects.items()):
            incomplete_tasks = [t for t in tasks if not t['completed']]
            if incomplete_tasks:
                output += f"\n### {project.title()}\n\n"
                for task in incomplete_tasks:
                    output += f"- [ ] {task['text']} *(line {task['line']})*\n"
        
        # Summary statistics
        total_tasks = len(self.tasks)
        completed_tasks = len([t for t in self.tasks if t['completed']])
        incomplete_tasks = total_tasks - completed_tasks
        
        output += f"\n\n## Summary\n\n"
        output += f"- **Total Tasks:** {total_tasks}\n"
        output += f"- **Completed:** {completed_tasks}\n"
        output += f"- **Remaining:** {incomplete_tasks}\n"
        output += f"- **Progress:** {(completed_tasks/total_tasks*100) if total_tasks > 0 else 0:.1f}%\n"
        
        return output
    
    def suggest_image_moves(self) -> List[Dict]:
        """Suggest where images should be moved"""
        suggestions = []
        
        for image in self.images:
            # Find the image in the Media folder
            media_path = self.vault_root / 'Media' / image['name']
            
            if media_path.exists():
                # Determine project context from surrounding text
                line = image['line']
                context_start = max(0, line - 5)
                context_end = min(len(self.content.split('\n')), line + 5)
                context = '\n'.join(self.content.split('\n')[context_start:context_end])
                
                # Simple heuristic: check for project keywords
                project = 'star-sailors'  # default
                if 'bumble' in context.lower() or '#BUMBLE' in context or '#bee' in context.lower():
                    project = 'bumble'
                elif 'station' in context.lower():
                    project = 'station-198'
                
                # Determine subfolder based on type
                subfolder = {
                    'physical-note': 'Physical-Notes',
                    'screenshot': 'Screenshots',
                    'diagram': 'Diagrams',
                    'photo': 'Concept-Art' if project == 'bumble' else 'Screenshots'
                }.get(image['type'], 'Screenshots')
                
                target_path = self.vault_root / 'Projects' / project.title().replace('-', '-') / 'Media' / subfolder / image['name']
                
                suggestions.append({
                    'image': image['name'],
                    'current': str(media_path),
                    'suggested': str(target_path),
                    'project': project,
                    'type': image['type']
                })
        
        return suggestions
    
    def run(self):
        """Run the full organization process"""
        print(f"🔍 Analyzing sprint file: {self.sprint_name}")
        print()
        
        # Parse content
        self.parse_tasks()
        self.parse_images()
        
        # Report findings
        print(f"📝 Found {len(self.tasks)} tasks")
        print(f"   - {len([t for t in self.tasks if not t['completed']])} incomplete")
        print(f"   - {len([t for t in self.tasks if t['completed']])} completed")
        print()
        
        print(f"🖼️  Found {len(self.images)} images")
        print()
        
        # Generate task summary
        tasks_content = self.generate_current_sprint_tasks()
        tasks_file = self.vault_root / '_Tasks' / 'Current-Sprint.md'
        tasks_file.write_text(tasks_content)
        print(f"✅ Generated: {tasks_file}")
        print()
        
        # Suggest image moves
        suggestions = self.suggest_image_moves()
        if suggestions:
            print(f"📦 Image organization suggestions:")
            for s in suggestions[:10]:  # Show first 10
                print(f"   {s['image']}")
                print(f"      → Projects/{s['project']}/Media/{s['type']}/")
            
            if len(suggestions) > 10:
                print(f"   ... and {len(suggestions) - 10} more")
            
            # Ask to proceed
            response = input("\n❓ Move images? (y/n): ")
            if response.lower() == 'y':
                for s in suggestions:
                    src = Path(s['current'])
                    dst = Path(s['suggested'])
                    dst.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(src, dst)
                    print(f"   ✓ Moved {s['image']}")
                print(f"\n✅ Moved {len(suggestions)} images")
                print("⚠️  Remember to update image references in the sprint file!")
        else:
            print("ℹ️  No images found to organize")
        
        print()
        print("✨ Organization complete!")


if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python organize_sprint.py <sprint-file-path>")
        print("\nExample:")
        print("  python organize_sprint.py content/_Sprints/Active/SSG-290.md")
        sys.exit(1)
    
    sprint_file = sys.argv[1]
    
    if not os.path.exists(sprint_file):
        print(f"❌ File not found: {sprint_file}")
        sys.exit(1)
    
    organizer = SprintOrganizer(sprint_file)
    organizer.run()
