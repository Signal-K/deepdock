#!/usr/bin/env python3
"""
Transcribe handwritten notes from images in sprint files.

This script uses local OCR to extract text from physical notes (IMG_*.jpg files)
and appends the transcribed text to the sprint markdown file.

Usage:
    python3 transcribe_notes.py <sprint_file>
    python3 transcribe_notes.py content/_Sprints/Active/SSG-295.md

Requirements:
    - pytesseract (wrapper for Tesseract OCR)
    - Pillow (image processing)
    - tesseract-ocr (system package)
"""

import re
import sys
from pathlib import Path
from typing import List, Dict, Tuple
import argparse

try:
    from PIL import Image
    import pytesseract
    TESSERACT_AVAILABLE = True
except ImportError:
    TESSERACT_AVAILABLE = False

try:
    import easyocr
    EASYOCR_AVAILABLE = True
except ImportError:
    EASYOCR_AVAILABLE = False

# Check if at least one OCR engine is available
if not TESSERACT_AVAILABLE and not EASYOCR_AVAILABLE:
    print("❌ No OCR engine available. Please install one:")
    print("   Tesseract (fast, printed text):  vault setup-ocr")
    print("   EasyOCR (better handwriting):    vault setup-easyocr")
    sys.exit(1)


class NoteTranscriber:
    """Transcribe handwritten notes from images."""
    
    def __init__(self, sprint_file: Path, engine: str = 'auto'):
        self.sprint_file = sprint_file
        self.vault_root = sprint_file.parent.parent.parent.parent
        self.media_folder = self.vault_root / "content" / "Media"
        self.content = ""
        self.images: List[Dict] = []
        
        # Determine OCR engine
        if engine == 'auto':
            # Prefer EasyOCR for handwriting if available
            self.engine = 'easyocr' if EASYOCR_AVAILABLE else 'tesseract'
        else:
            self.engine = engine
            
        # Initialize EasyOCR reader if needed
        self.easyocr_reader = None
        if self.engine == 'easyocr':
            if not EASYOCR_AVAILABLE:
                raise RuntimeError("EasyOCR not installed. Run: vault setup-easyocr")
            print("🤖 Loading EasyOCR model (better for handwriting)...")
            self.easyocr_reader = easyocr.Reader(['en'], gpu=False, verbose=False)
        elif self.engine == 'tesseract':
            if not TESSERACT_AVAILABLE:
                raise RuntimeError("Tesseract not installed. Run: vault setup-ocr")
        
    def load_sprint_file(self):
        """Load sprint file content."""
        if not self.sprint_file.exists():
            raise FileNotFoundError(f"Sprint file not found: {self.sprint_file}")
        
        self.content = self.sprint_file.read_text(encoding='utf-8')
        print(f"📖 Loaded: {self.sprint_file.name}")
        
    def find_physical_notes(self) -> List[Dict]:
        """Find all physical note images in the sprint file.
        
        Looks for:
        - IMG_*.jpg (Android/camera photos)
        - UUID-style names with .jpeg/.jpg (iPhone photos)
        
        Skips:
        - Pasted image *.png (screenshots)
        """
        # Match both Obsidian ![[...]] and Markdown ![...](...) formats
        # Capture any .jpg/.jpeg that's NOT a "Pasted image"
        pattern = r'!\[\[(?!Pasted image)([^\]]+\.jpe?g)\]\]|!\[.*?\]\((?!Pasted image)([^)]+\.jpe?g)\)'
        matches = re.finditer(pattern, self.content, re.IGNORECASE)
        
        images = []
        seen = set()  # Avoid duplicates
        
        for match in matches:
            # Get the first non-None group (either Obsidian or Markdown format)
            img_name = next((g for g in match.groups() if g is not None), None)
            
            if not img_name:
                continue
            
            # Skip if already processed
            if img_name in seen:
                continue
            seen.add(img_name)
            
            # Find image in Media folder
            img_path = self._find_image_file(img_name)
            
            if img_path:
                images.append({
                    'name': img_name,
                    'path': img_path,
                    'line_num': self.content[:match.start()].count('\n') + 1,
                    'match_text': match.group(0)
                })
        
        return images
    
    def _find_image_file(self, img_name: str) -> Path:
        """Recursively search for image file in media folders."""
        # Search in multiple locations
        search_paths = [
            self.vault_root / "media",  # Root media folder
            self.vault_root / "content" / "Media",  # Content Media folder
            self.vault_root / "content",  # Anywhere in content
        ]
        
        for search_path in search_paths:
            if not search_path.exists():
                continue
                
            # Search recursively
            for img_file in search_path.rglob(img_name):
                if img_file.is_file():
                    return img_file
                
        return None
    
    def transcribe_image(self, img_path: Path) -> str:
        """Use OCR to transcribe text from image."""
        try:
            if self.engine == 'easyocr':
                return self._transcribe_easyocr(img_path)
            else:
                return self._transcribe_tesseract(img_path)
        except Exception as e:
            print(f"⚠️  Error processing {img_path.name}: {e}")
            return ""
    
    def _transcribe_easyocr(self, img_path: Path) -> str:
        """Transcribe using EasyOCR (better for handwriting)."""
        from PIL import Image, ImageEnhance
        import numpy as np
        
        # Preprocess image for better OCR
        img = Image.open(img_path)
        
        # Convert to RGB if needed
        if img.mode != 'RGB':
            img = img.convert('RGB')
        
        # Enhance contrast
        enhancer = ImageEnhance.Contrast(img)
        img = enhancer.enhance(2.0)  # Increase contrast
        
        # Enhance sharpness
        enhancer = ImageEnhance.Sharpness(img)
        img = enhancer.enhance(2.0)  # Increase sharpness
        
        # Convert to numpy array for EasyOCR
        img_array = np.array(img)
        
        # EasyOCR with paragraph detection
        results = self.easyocr_reader.readtext(
            img_array,
            detail=0,
            paragraph=True,  # Group text into paragraphs
            width_ths=0.7,   # Threshold for grouping text
        )
        
        # Join all detected text with newlines
        text = '\n'.join(results)
        return text.strip()
    
    def _transcribe_tesseract(self, img_path: Path) -> str:
        """Transcribe using Tesseract (faster, for printed text)."""
        # Open and preprocess image
        img = Image.open(img_path)
        
        # Convert to grayscale for better OCR
        img = img.convert('L')
        
        # Run OCR
        text = pytesseract.image_to_string(img, config='--psm 6')
        
        # Clean up text
        text = text.strip()
        
        return text
    
    def create_transcription_section(self, img_name: str, transcribed_text: str) -> str:
        """Create markdown section for transcribed note."""
        section = f"\n\n### 📝 Transcribed: {img_name}\n\n"
        
        if transcribed_text:
            # Add transcribed text as quote block
            lines = transcribed_text.split('\n')
            section += "> **Transcribed Text:**\n"
            for line in lines:
                if line.strip():
                    section += f"> {line}\n"
        else:
            section += "> *No text detected*\n"
        
        section += f"\n*OCR transcribed on {self._get_timestamp()}*\n"
        
        return section
    
    def _get_timestamp(self) -> str:
        """Get current timestamp."""
        from datetime import datetime
        return datetime.now().strftime("%Y-%m-%d %H:%M")
    
    def process_sprint(self, dry_run: bool = False, force: bool = False):
        """Process all physical notes in sprint file."""
        self.load_sprint_file()
        images = self.find_physical_notes()
        
        if not images:
            print("ℹ️  No physical note images found")
            print("   Looking for: .jpg/.jpeg files (excluding 'Pasted image' screenshots)")
            return
        
        engine_name = "EasyOCR (handwriting)" if self.engine == 'easyocr' else "Tesseract (printed text)"
        print(f"\n🖼️  Found {len(images)} physical note image(s)")
        print(f"🤖 Using: {engine_name}\n")
        
        transcriptions = []
        
        for img in images:
            print(f"📸 {img['name']}")
            
            if not img['path']:
                print(f"   ⚠️  Image file not found in Media folder")
                continue
            
            print(f"   📂 Found: {img['path'].relative_to(self.vault_root)}")
            
            # Check if already transcribed
            if f"Transcribed: {img['name']}" in self.content and not force:
                print(f"   ⏭️  Already transcribed (use --force to re-transcribe)")
                continue
            
            print(f"   🔍 Running OCR...")
            text = self.transcribe_image(img['path'])
            
            if text:
                preview = text[:100] + "..." if len(text) > 100 else text
                print(f"   ✅ Extracted {len(text)} characters")
                print(f"   📄 Preview: {preview.replace(chr(10), ' ')}")
            else:
                print(f"   ⚠️  No text detected")
            
            transcriptions.append({
                'image': img,
                'text': text,
                'section': self.create_transcription_section(img['name'], text)
            })
        
        if not transcriptions:
            print("\n✨ Nothing new to transcribe")
            return
        
        if dry_run:
            print("\n📋 DRY RUN - Would add these transcriptions:")
            for t in transcriptions:
                print(f"\n{t['section']}")
            print(f"\n💡 Run without --dry-run to apply changes")
            return
        
        # Append transcriptions to file
        self._append_transcriptions(transcriptions)
        
        print(f"\n✅ Transcribed {len(transcriptions)} image(s)")
        print(f"📝 Updated: {self.sprint_file.name}")
    
    def _append_transcriptions(self, transcriptions: List[Dict]):
        """Append transcriptions to sprint file."""
        # Create or update transcriptions section
        new_content = self.content
        
        # Check if there's a transcriptions section
        if "## 📝 Transcribed Notes" not in new_content:
            # Add new section at the end
            new_content += "\n\n---\n\n## 📝 Transcribed Notes\n"
            new_content += "\n*Automatically transcribed from handwritten notes using OCR*\n"
        
        # Add each transcription
        for t in transcriptions:
            new_content += t['section']
        
        # Save file
        self.sprint_file.write_text(new_content, encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(
        description="Transcribe handwritten notes from sprint images using OCR"
    )
    parser.add_argument(
        'sprint_file',
        type=str,
        help='Path to sprint file (e.g., SSG-295.md or content/_Sprints/Active/SSG-295.md)'
    )
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be transcribed without making changes'
    )
    parser.add_argument(
        '--force',
        action='store_true',
        help='Re-transcribe images even if already transcribed'
    )
    parser.add_argument(
        '--engine',
        type=str,
        choices=['auto', 'easyocr', 'tesseract'],
        default='auto',
        help='OCR engine: auto (prefer EasyOCR), easyocr (handwriting), tesseract (printed)'
    )
    
    args = parser.parse_args()
    
    # Resolve sprint file path
    sprint_path = Path(args.sprint_file)
    if not sprint_path.is_absolute():
        # Try relative to current directory
        if not sprint_path.exists():
            # Try in _Sprints/Active
            sprint_path = Path.cwd() / 'content' / '_Sprints' / 'Active' / args.sprint_file
            if not sprint_path.exists():
                print(f"❌ Sprint file not found: {args.sprint_file}")
                sys.exit(1)
    
    try:
        transcriber = NoteTranscriber(sprint_path, engine=args.engine)
        transcriber.process_sprint(dry_run=args.dry_run, force=args.force)
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
