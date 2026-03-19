#!/bin/bash
# Setup OCR dependencies for transcribing handwritten notes

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
VENV_DIR="$VAULT_ROOT/.venv"

echo "🔧 Setting up OCR for handwritten note transcription..."
echo ""

# Check if venv exists
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Virtual environment not found. Creating..."
    bash "$SCRIPT_DIR/setup-venv.sh"
fi

# Activate venv
source "$VENV_DIR/bin/activate"

# Check for Tesseract OCR
echo "🔍 Checking for Tesseract OCR..."
if ! command -v tesseract &> /dev/null; then
    echo ""
    echo "⚠️  Tesseract OCR not found!"
    echo ""
    echo "Please install Tesseract:"
    echo "  macOS:   brew install tesseract"
    echo "  Ubuntu:  sudo apt-get install tesseract-ocr"
    echo "  Windows: Download from https://github.com/UB-Mannheim/tesseract/wiki"
    echo ""
    read -p "Have you installed Tesseract? (y/n): " installed
    
    if [ "$installed" != "y" ]; then
        echo "❌ Tesseract is required. Please install it first."
        exit 1
    fi
fi

# Verify Tesseract is working
if command -v tesseract &> /dev/null; then
    TESS_VERSION=$(tesseract --version 2>&1 | head -1)
    echo "✅ Found: $TESS_VERSION"
else
    echo "❌ Tesseract not found in PATH"
    exit 1
fi

echo ""
echo "📦 Installing Python packages..."

# Install OCR packages
pip install -q --upgrade pillow pytesseract

echo "✅ Installed: Pillow (image processing)"
echo "✅ Installed: pytesseract (OCR wrapper)"

# Check if we can import packages
echo ""
echo "🧪 Testing OCR setup..."
python3 << 'EOF'
try:
    from PIL import Image
    import pytesseract
    
    # Test Tesseract
    version = pytesseract.get_tesseract_version()
    print(f"✅ Tesseract version: {version}")
    print("✅ OCR setup complete!")
    
except Exception as e:
    print(f"❌ Error: {e}")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 OCR transcription is ready!"
    echo ""
    echo "Usage:"
    echo "  vault transcribe <sprint>       # Transcribe all physical notes"
    echo "  vault transcribe SSG-295        # Transcribe notes in SSG-295"
    echo "  vault transcribe --dry-run      # Preview without changes"
    echo ""
    echo "The system will:"
    echo "  1. Find all IMG_*.jpg files (physical notes)"
    echo "  2. Run OCR to extract handwritten text"
    echo "  3. Append transcriptions to sprint file"
    echo ""
else
    echo "❌ OCR setup failed"
    exit 1
fi

deactivate
