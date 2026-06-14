import os
import re

tasks_dir = os.path.expanduser('~/Navigation/.knowns/tasks')

mapping = {
    'BEE': 'Bumble',
    'CLI': 'Client',
    'COR': 'Coral',
    'LAN': 'Experiment 1/Landnam',
    'SAI': 'Saily',
    'QTZ': 'Quartz' # Added Quartz as it was in the list earlier
}

def update_frontmatter(path, project_name):
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    if content.startswith('---'):
        parts = re.split(r'^---\s*$', content, maxsplit=2, flags=re.MULTILINE)
        if len(parts) >= 3:
            fm = parts[1]
            if 'project:' in fm:
                fm = re.sub(r'^project:.*', f'project: {project_name}', fm, flags=re.MULTILINE)
            else:
                fm = fm.strip() + f'\nproject: {project_name}\n'
            
            new_content = f"---{fm}---\n{parts[2]}"
            with open(path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            return True
    return False

for filename in os.listdir(tasks_dir):
    if not filename.endswith('.md'): continue
    
    path = os.path.join(tasks_dir, filename)
    prefix = filename.split('-')[1][:3].upper()
    
    project = mapping.get(prefix)
    if project:
        if update_frontmatter(path, project):
            print(f"Labeled {filename} as {project}")

