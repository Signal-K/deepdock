#!/bin/bash
# Quick Start Script for New Sprint Workflow
# Usage: ./quick-start.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONTENT_ROOT="$VAULT_ROOT/content"

echo "🚀 Quartz Vault Quick Start"
echo "=============================="
echo ""

# Check if we're in the right place
if [ ! -d "$CONTENT_ROOT/_Sprints" ]; then
    echo "❌ Error: Cannot find _Sprints folder"
    echo "   Make sure you're running this from content/_System/Scripts/"
    exit 1
fi

# Menu
echo "What would you like to do?"
echo ""
echo "1. Create new sprint from template"
echo "2. Organize current sprint"
echo "3. View current sprint tasks"
echo "4. Migrate old content"
echo "5. Run full migration (dry run)"
echo "6. Show workflow guide"
echo "7. Test Quartz build"
echo ""
read -p "Choose an option (1-7): " choice

case $choice in
    1)
        echo ""
        read -p "Enter sprint number (e.g., 295): " sprint_num
        sprint_file="$CONTENT_ROOT/_Sprints/Active/SSG-$sprint_num.md"
        
        if [ -f "$sprint_file" ]; then
            echo "⚠️  Sprint file already exists: $sprint_file"
            read -p "Overwrite? (y/n): " confirm
            if [ "$confirm" != "y" ]; then
                echo "Cancelled."
                exit 0
            fi
        fi
        
        cp "$CONTENT_ROOT/_Sprints/_Templates/sprint-template.md" "$sprint_file"
        
        # Replace XXX with actual sprint number
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/SSG-XXX/SSG-$sprint_num/g" "$sprint_file"
        else
            sed -i "s/SSG-XXX/SSG-$sprint_num/g" "$sprint_file"
        fi
        
        echo "✅ Created new sprint: SSG-$sprint_num"
        echo "   Location: $sprint_file"
        echo ""
        echo "Next steps:"
        echo "1. Open the file in Obsidian"
        echo "2. Update sprint dates and goals"
        echo "3. Start adding notes and tasks!"
        ;;
        
    2)
        echo ""
        # Find active sprint files
        active_sprints=($CONTENT_ROOT/_Sprints/Active/*.md)
        
        if [ ${#active_sprints[@]} -eq 0 ]; then
            echo "❌ No active sprint files found"
            exit 1
        fi
        
        echo "Active sprints:"
        for i in "${!active_sprints[@]}"; do
            basename="${active_sprints[$i]##*/}"
            echo "$((i+1)). $basename"
        done
        echo ""
        read -p "Choose sprint to organize (1-${#active_sprints[@]}): " sprint_choice
        
        sprint_index=$((sprint_choice - 1))
        selected_sprint="${active_sprints[$sprint_index]}"
        
        echo ""
        echo "🔧 Organizing: $(basename "$selected_sprint")"
        python3 "$SCRIPT_DIR/organize_sprint.py" "$selected_sprint"
        ;;
        
    3)
        echo ""
        task_file="$CONTENT_ROOT/_Tasks/Current-Sprint.md"
        if [ -f "$task_file" ]; then
            echo "📋 Current Sprint Tasks:"
            echo "======================="
            cat "$task_file"
        else
            echo "ℹ️  No Current-Sprint.md found yet"
            echo "   Run option 2 (Organize current sprint) to generate it"
        fi
        ;;
        
    4)
        echo ""
        echo "🔄 Migrating old content..."
        python3 "$SCRIPT_DIR/migrate_content.py"
        ;;
        
    5)
        echo ""
        echo "🔄 Running full migration (dry run)..."
        python3 "$SCRIPT_DIR/migrate_content.py"
        echo ""
        echo "💡 To actually execute the migration, run:"
        echo "   python3 migrate_content.py --auto"
        ;;
        
    6)
        echo ""
        guide_file="$VAULT_ROOT/WORKFLOW_GUIDE.md"
        if command -v bat &> /dev/null; then
            bat "$guide_file"
        elif command -v less &> /dev/null; then
            less "$guide_file"
        else
            cat "$guide_file"
        fi
        ;;
        
    7)
        echo ""
        echo "🏗️  Testing Quartz build..."
        cd "$VAULT_ROOT"
        
        if ! command -v npx &> /dev/null; then
            echo "❌ npx not found. Please install Node.js"
            exit 1
        fi
        
        echo "Building Quartz..."
        npx quartz build
        
        echo ""
        echo "✅ Build successful!"
        echo ""
        read -p "Start local server? (y/n): " serve
        if [ "$serve" == "y" ]; then
            echo "Starting server at http://localhost:8080"
            echo "Press Ctrl+C to stop"
            npx quartz serve
        fi
        ;;
        
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "✨ Done!"
