---
title: Ollama Setup Guide
icon: lucide//brain-circuit
tags:
  - setup
  - ai
  - ollama
created: 2025-11-22
---

# 🤖 Ollama Local AI Setup

This guide will help you set up Ollama to power the weekly analysis feature.

## What is Ollama?

Ollama allows you to run large language models locally on your machine. This means:
- ✅ Complete privacy - your data never leaves your computer
- ✅ No API costs
- ✅ Works offline
- ✅ Fast responses

## Installation

### macOS

1. **Download Ollama:**
   - Visit https://ollama.ai
   - Click "Download for macOS"
   - Open the downloaded `.dmg` file and drag Ollama to Applications

2. **Verify Installation:**
   ```bash
   ollama --version
   ```

3. **Pull a Model:**
   ```bash
   # Recommended: Llama 3.2 (1B - fast, good for analysis)
   ollama pull llama3.2
   
   # Or for better quality (larger model):
   ollama pull llama3.2:3b
   ```

### Alternative Models

You can use different models depending on your hardware:

```bash
# Lightweight (fast, uses ~1GB RAM)
ollama pull llama3.2:1b

# Medium (balanced, ~3GB RAM)
ollama pull llama3.2:3b

# Large (best quality, ~8GB RAM)
ollama pull llama3.1:8b

# Code-focused (for technical analysis)
ollama pull codellama
```

## Configuration

### Update the Script

If you want to use a different model, edit `/content/_System/Scripts/obsidian/analyze-weekly.js`:

Find this line:
```javascript
model: 'llama3.2', // Change to your preferred model
```

Change it to your preferred model:
```javascript
model: 'llama3.2:3b', // or 'codellama', 'llama3.1:8b', etc.
```

## Usage

### Running Ollama

Ollama runs automatically in the background after installation. You can verify it's running:

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Or use the Ollama command
ollama list
```

### Using Weekly Analysis

1. Open your Dashboard
2. Click the "🧠 Analyze Week (AI)" button
3. Wait for the analysis to complete
4. A new report will be created with AI-powered insights

## Troubleshooting

### "Ollama not available" Error

**Issue:** The script shows a fallback message saying Ollama isn't available.

**Solutions:**
1. Check if Ollama is running:
   ```bash
   ollama list
   ```

2. Restart Ollama:
   - macOS: Open Applications → Ollama
   - Or run: `ollama serve`

3. Check the port (should be 11434):
   ```bash
   lsof -i :11434
   ```

### Model Not Found

**Issue:** Error says model doesn't exist.

**Solution:**
```bash
# List available models
ollama list

# Pull the model if missing
ollama pull llama3.2
```

### Performance Issues

**Issue:** Analysis is slow or hangs.

**Solutions:**
1. Use a smaller model:
   ```bash
   ollama pull llama3.2:1b
   ```

2. Reduce context in the script (edit `num_predict` in analyze-weekly.js):
   ```javascript
   options: {
       temperature: 0.7,
       num_predict: 1000  // Reduced from 2000
   }
   ```

3. Close other applications to free up memory

### Port Conflict

**Issue:** Port 11434 is already in use.

**Solutions:**
1. Stop other processes using the port:
   ```bash
   lsof -ti:11434 | xargs kill -9
   ```

2. Or change Ollama's port (advanced):
   ```bash
   OLLAMA_HOST=0.0.0.0:11435 ollama serve
   ```
   Then update the script URL to `http://localhost:11435/api/generate`

## Advanced Configuration

### Temperature Setting

Controls creativity vs consistency:

```javascript
temperature: 0.3  // More focused, consistent
temperature: 0.7  // Balanced (default)
temperature: 1.0  // More creative, varied
```

### Context Length

How much text to process:

```javascript
num_predict: 500   // Short, quick analysis
num_predict: 2000  // Detailed analysis (default)
num_predict: 4000  // Very detailed (slower)
```

### Custom Prompts

Edit the `analysisPrompt` in `analyze-weekly.js` to customize what the AI focuses on:

```javascript
const analysisPrompt = `You are analyzing a weekly review...

Focus on:
1. Technical tasks vs creative ideas
2. Blocked tasks requiring help
3. Quick wins that can be completed today

...`;
```

## Resources

- **Ollama Docs:** https://ollama.ai/docs
- **Model Library:** https://ollama.ai/library
- **GitHub:** https://github.com/ollama/ollama

## Testing Your Setup

Run this command to test Ollama:

```bash
ollama run llama3.2 "Summarize: I need to build a component for user authentication, create API endpoints, and fix the dashboard layout"
```

You should get a concise summary back. If this works, the weekly analysis button will work!

---

## Quick Reference

```bash
# Essential Commands
ollama list                    # Show installed models
ollama pull MODEL_NAME         # Download a model
ollama rm MODEL_NAME           # Remove a model
ollama serve                   # Start Ollama server
ollama ps                      # Show running models
```

---

*For issues, check the Ollama documentation or the script's console output in Obsidian DevTools (Cmd+Option+I)*
