#!/bin/bash

# Ollama Installation Script for macOS
# This script installs Ollama and sets up the recommended model

echo "🤖 Ollama Setup for Weekly Analysis Feature"
echo "=========================================="
echo ""

# Check if Ollama is already installed
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is already installed!"
    ollama --version
else
    echo "📥 Installing Ollama..."
    echo ""
    echo "Please visit: https://ollama.ai"
    echo "Download and install Ollama for macOS"
    echo ""
    read -p "Press Enter after you've installed Ollama..."
fi

echo ""
echo "🔍 Checking Ollama status..."

if command -v ollama &> /dev/null; then
    echo "✅ Ollama found!"
    
    echo ""
    echo "📦 Available models:"
    ollama list
    
    echo ""
    echo "Would you like to pull the recommended model (llama3.2)?"
    echo "Options:"
    echo "  1) llama3.2:1b  - Lightweight, fast (~1GB)"
    echo "  2) llama3.2     - Standard, balanced (~3GB) [RECOMMENDED]"
    echo "  3) llama3.2:3b  - Better quality (~3GB)"
    echo "  4) Skip"
    echo ""
    read -p "Enter choice (1-4): " choice
    
    case $choice in
        1)
            echo "Pulling llama3.2:1b..."
            ollama pull llama3.2:1b
            echo "⚠️  Remember to update analyze-weekly.js to use 'llama3.2:1b'"
            ;;
        2)
            echo "Pulling llama3.2..."
            ollama pull llama3.2
            ;;
        3)
            echo "Pulling llama3.2:3b..."
            ollama pull llama3.2:3b
            echo "⚠️  Remember to update analyze-weekly.js to use 'llama3.2:3b'"
            ;;
        4)
            echo "Skipping model download"
            ;;
        *)
            echo "Invalid choice, skipping..."
            ;;
    esac
    
    echo ""
    echo "✅ Setup complete!"
    echo ""
    echo "📝 Next steps:"
    echo "  1. Open Obsidian"
    echo "  2. Navigate to your Dashboard"
    echo "  3. Click the '🧠 Analyze Week (AI)' button"
    echo "  4. Review the generated report"
    echo ""
    echo "📚 Documentation:"
    echo "  - Setup Guide: content/_System/Documentation/Ollama-Setup.md"
    echo "  - Features Guide: content/_System/Documentation/Weekly-Features-Setup.md"
    echo ""
    echo "🔧 Testing your setup:"
    echo "  Run: ollama run llama3.2 'Hello, test message'"
    
else
    echo "❌ Ollama not found. Please install from https://ollama.ai"
fi
