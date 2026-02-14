#!/bin/bash
set -euo pipefail

cd /Users/scroobz/Navigation/quartz
node .obsidian/scripts/sync-knowns-prod.cjs --apply "$@"
