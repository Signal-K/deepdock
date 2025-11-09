#!/bin/bash
# Install vault command globally
# This adds the vault command to your PATH

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_SCRIPT="$SCRIPT_DIR/vault"
INSTALL_DIR="$HOME/.local/bin"

echo "🔧 Installing vault command globally..."
echo ""

# Create install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "📁 Creating $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Create symlink
if [ -L "$INSTALL_DIR/vault" ]; then
    echo "ℹ️  Removing existing vault command..."
    rm "$INSTALL_DIR/vault"
fi

echo "🔗 Creating symlink..."
ln -s "$VAULT_SCRIPT" "$INSTALL_DIR/vault"

# Check if directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠️  $INSTALL_DIR is not in your PATH"
    echo ""
    echo "Add this to your ~/.zshrc or ~/.bashrc:"
    echo ""
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Then run: source ~/.zshrc"
    echo ""
    
    read -p "Add to ~/.zshrc automatically? (y/n): " add_path
    if [ "$add_path" = "y" ]; then
        echo "" >> ~/.zshrc
        echo "# Vault command" >> ~/.zshrc
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> ~/.zshrc
        echo "✅ Added to ~/.zshrc"
        echo ""
        echo "Run: source ~/.zshrc"
        echo "Or: restart your terminal"
    fi
else
    echo "✅ $INSTALL_DIR is already in PATH"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "You can now run vault commands from anywhere:"
echo "    vault setup"
echo "    vault organize"
echo "    vault new-sprint 296"
echo "    vault tasks"
echo "    vault menu"
echo ""

# Run setup automatically
read -p "Run 'vault setup' now to create virtual environment? (y/n): " run_setup
if [ "$run_setup" = "y" ]; then
    "$VAULT_SCRIPT" setup
fi
