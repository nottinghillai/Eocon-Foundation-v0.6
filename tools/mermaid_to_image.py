#!/usr/bin/env python3
"""
Convert Mermaid diagram to PNG/PDF for LaTeX inclusion.

Usage:
    python tools/mermaid_to_image.py \
        .planning/Diagrams/unified-framework-architecture.mermaid \
        .planning/Constitution/unified-framework-architecture

This will generate:
    - unified-framework-architecture.png (for LaTeX)
    - unified-framework-architecture.pdf (for higher quality)
"""

import os
import sys
import subprocess
from pathlib import Path


def check_mermaid_cli():
    """Check if mermaid-cli (mmdc) is installed."""
    try:
        result = subprocess.run(['mmdc', '--version'], 
                              capture_output=True, 
                              text=True)
        return result.returncode == 0
    except FileNotFoundError:
        return False


def convert_with_mermaid_cli(mermaid_file, output_prefix):
    """Convert Mermaid file using mermaid-cli."""
    output_png = f"{output_prefix}.png"
    output_pdf = f"{output_prefix}.pdf"
    
    # Convert to PNG
    cmd_png = [
        'mmdc',
        '-i', mermaid_file,
        '-o', output_png,
        '-w', '2400',  # High resolution for print
        '-H', '1800',
        '-b', 'white',
        '-s', '2'  # Scale factor
    ]
    
    # Convert to PDF (better for LaTeX)
    cmd_pdf = [
        'mmdc',
        '-i', mermaid_file,
        '-o', output_pdf,
        '-w', '2400',
        '-H', '1800',
        '-b', 'white',
        '-s', '2'
    ]
    
    try:
        print(f"Converting to PNG: {output_png}")
        subprocess.run(cmd_png, check=True)
        print(f"✓ PNG created: {output_png}")
        
        print(f"Converting to PDF: {output_pdf}")
        subprocess.run(cmd_pdf, check=True)
        print(f"✓ PDF created: {output_pdf}")
        
        return True, output_png, output_pdf
    except subprocess.CalledProcessError as e:
        print(f"Error converting Mermaid diagram: {e}")
        return False, None, None


def install_instructions():
    """Print installation instructions for mermaid-cli."""
    print("\n" + "="*70)
    print("MERMAID-CLI NOT FOUND")
    print("="*70)
    print("\nTo convert Mermaid diagrams to images, install mermaid-cli:")
    print("\nOption 1: Using npm (recommended)")
    print("  npm install -g @mermaid-js/mermaid-cli")
    print("\nOption 2: Using Homebrew (macOS)")
    print("  brew install mermaid-cli")
    print("\nOption 3: Using Docker")
    print("  docker pull minlag/mermaid-cli")
    print("\nThen run this script again.")
    print("\nAlternatively, you can:")
    print("  1. Use online Mermaid editor: https://mermaid.live/")
    print("  2. Export as PNG/PDF manually")
    print("  3. Save to: .planning/Constitution/unified-framework-architecture.png")
    print("="*70 + "\n")


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    
    mermaid_file = sys.argv[1]
    output_prefix = sys.argv[2]
    
    # Ensure output directory exists
    output_dir = os.path.dirname(output_prefix)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir, exist_ok=True)
    
    # Check if mermaid-cli is available
    if not check_mermaid_cli():
        install_instructions()
        sys.exit(1)
    
    # Convert the diagram
    success, png_file, pdf_file = convert_with_mermaid_cli(mermaid_file, output_prefix)
    
    if success:
        print(f"\n✓ Success! Files created:")
        print(f"  - {png_file}")
        print(f"  - {pdf_file}")
        print(f"\nYou can now include the image in LaTeX using:")
        print(f"  \\includegraphics[width=\\textwidth]{{{os.path.basename(pdf_file)}}}")
    else:
        sys.exit(1)


if __name__ == '__main__':
    main()

