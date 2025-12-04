#!/bin/bash

# Quick Task Creator for iOS/Mac Shortcuts
# This script creates a task with the same flow as the dashboard button

# Arguments passed from Shortcut
TASK_TEXT="$1"
PROJECT="$2"
PRIORITY="$3"
DUE_DATE="$4"

# Generate unique 6-character ID
generate_id() {
    cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | fold -w 6 | head -n 1
}

TASK_ID=$(generate_id)
TODAY=$(date +%Y-%m-%d)

# Build task metadata
PRIORITY_EMOJI=""
case "$PRIORITY" in
    "high") PRIORITY_EMOJI="⏫" ;;
    "medium") PRIORITY_EMOJI="🔼" ;;
    "low") PRIORITY_EMOJI="🔽" ;;
esac

# Build date fields
DATE_FIELDS=""
if [ -n "$DUE_DATE" ]; then
    case "$DUE_DATE" in
        "today") 
            DATE_FIELDS=" 📅 $TODAY 🛫 $TODAY"
            ;;
        "tomorrow") 
            TOMORROW=$(date -v+1d +%Y-%m-%d)
            DATE_FIELDS=" 📅 $TOMORROW 🛫 $TODAY"
            ;;
    esac
fi

CREATED_DATE=" ➕ $TODAY"

# Build full task line
FULL_TASK="- [ ] ${TASK_TEXT} 🆔 ${TASK_ID}${DATE_FIELDS}${CREATED_DATE} ${PRIORITY_EMOJI}"

# Determine project file
PROJECT_FILE="$HOME/Navigation/quartz/content/_Tasks/Projects/${PROJECT}.md"

# Add task to appropriate section
SECTION_HEADER="## ${PRIORITY^} Priority"

# Read file, find section, insert task
if [ -f "$PROJECT_FILE" ]; then
    # Use awk to insert after section header
    awk -v section="$SECTION_HEADER" -v task="$FULL_TASK" '
    {
        print
        if ($0 == section) {
            print task
        }
    }
    ' "$PROJECT_FILE" > "${PROJECT_FILE}.tmp" && mv "${PROJECT_FILE}.tmp" "$PROJECT_FILE"
    
    echo "✅ Task added to $PROJECT (ID: $TASK_ID)"
    echo "$FULL_TASK"
else
    echo "❌ Error: Project file not found: $PROJECT_FILE"
    exit 1
fi
