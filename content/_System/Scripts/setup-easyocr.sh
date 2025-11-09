#!/bin/bash
# Setup EasyOCR for better handwriting recognition

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
VENV_DIR="$VAULT_ROOT/.venv"

echo "🔧 Setting up EasyOCR for handwriting recognition..."
echo ""
echo "⚠️  Note: EasyOCR is much better for handwriting than Tesseract,"
echo "   but it's larger (~500MB) and slower. Worth it for accuracy!"
echo ""

# Check if venv exists
if [ ! -d "$VENV_DIR" ]; then
    echo "📦 Virtual environment not found. Creating..."
    bash "$SCRIPT_DIR/setup-venv.sh"
fi

# Activate venv
source "$VENV_DIR/bin/activate"

echo "📦 Installing EasyOCR and dependencies..."
echo "   This may take a few minutes (downloading ML models)..."
echo ""

# Install EasyOCR
pip install -q easyocr torch torchvision

echo "✅ Installed: EasyOCR"
echo "✅ Installed: PyTorch (ML framework)"

# Test EasyOCR
echo ""
echo "🧪 Testing EasyOCR setup..."
python3 << 'EOF'
try:
    import easyocr
    print("✅ EasyOCR imported successfully")
    
    # This will download the English model (~500MB) on first run
    print("📥 Downloading English recognition model (one-time, ~500MB)...")
    reader = easyocr.Reader(['en'], gpu=False, verbose=False)
    print("✅ EasyOCR ready for handwriting recognition!")
    
except Exception as e:
    print(f"❌ Error: {e}")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 EasyOCR setup complete!"
    echo ""
    echo "Usage:"
    echo "  vault transcribe --engine easyocr      # Use EasyOCR (better for handwriting)"
    echo "  vault transcribe --engine tesseract    # Use Tesseract (faster, printed text)"
    echo ""
    echo "EasyOCR is much better for handwriting but slower."
    echo "Use it for physical notes, Tesseract for typed screenshots."
    echo ""
else
    echo "❌ EasyOCR setup failed"
    exit 1
fi

deactivate
