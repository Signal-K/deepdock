#!/bin/bash
# Setup script for Python virtual environment
# This creates a venv and installs all required dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
VENV_DIR="$VAULT_ROOT/.venv"

echo "🔧 Setting up Python virtual environment..."
echo "Vault root: $VAULT_ROOT"
echo "Virtual env: $VENV_DIR"
echo ""

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    echo "   Install with: brew install python3"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    echo "✅ Virtual environment created"
else
    echo "ℹ️  Virtual environment already exists"
fi

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip -q

# Install required packages
echo "📦 Installing required packages..."
pip install -q pathlib

echo ""
echo "✅ Setup complete!"
echo ""
echo "To activate the virtual environment manually, run:"
echo "   source $VENV_DIR/bin/activate"
echo ""
echo "To deactivate, run:"
echo "   deactivate"
