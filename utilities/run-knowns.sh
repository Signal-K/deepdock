#!/bin/bash
# Stop any existing knowns browser on port 6420
lsof -ti:6420 | xargs kill -9 2>/dev/null
# Run the main knowns project in the background
knowns browser --project /Users/scroobz/Navigation > /dev/null 2>&1 &
echo "Knowns browser started for /Users/scroobz/Navigation"
