---
title: Quick Start - Ollama
icon: lucide//zap
tags:
  - quick-start
  - ollama
  - ai
---

# ⚡ Quick Start: Ollama

## Install (2 minutes)

### macOS
```bash
# Option 1: Download from website
# Visit https://ollama.ai and download

# Option 2: Use our setup script
./content/_System/Scripts/setup-ollama.sh
```

## Pull Model (1 minute)
```bash
ollama pull llama3.2
```

## Verify (10 seconds)
```bash
ollama list
```

You should see `llama3.2` in the list.

## Test (30 seconds)
```bash
ollama run llama3.2 "Hello!"
```

If you get a response, you're ready! 🎉

## Use in Obsidian
1. Open your Dashboard
2. Click "🧠 Analyze Week (AI)"
3. View the AI-generated report

---

## Troubleshooting

**"Ollama not available" error?**
```bash
# Check if Ollama is running
ollama list

# If not, open Ollama app from Applications
# Or run in terminal:
ollama serve
```

**Port 11434 not responding?**
```bash
# Check what's using the port
lsof -i :11434

# Restart Ollama
pkill ollama
ollama serve
```

**Need help?**
- Full guide: [[_System/Documentation/Ollama-Setup]]
- Ollama docs: https://ollama.ai/docs

---

## Models Comparison

| Model | Size | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| llama3.2:1b | ~1GB | ⚡⚡⚡ | ⭐⭐ | Quick analysis |
| llama3.2 | ~3GB | ⚡⚡ | ⭐⭐⭐ | Balanced (default) |
| llama3.2:3b | ~3GB | ⚡⚡ | ⭐⭐⭐⭐ | Better quality |
| llama3.1:8b | ~8GB | ⚡ | ⭐⭐⭐⭐⭐ | Best quality |

To switch models:
```bash
ollama pull llama3.2:3b
```

Then edit `analyze-weekly.js` line 156 to use your model.

---

**Time to setup:** ~5 minutes  
**Privacy:** 100% local, no data leaves your computer  
**Cost:** Free forever
