#!/usr/bin/env python3
"""
Reorganize the Algorithms for Decision Making markdown files into a structured hierarchy.

This script reads the converted markdown files and organizes them into a proper
folder structure based on the book's organization (Parts, Chapters, Sections).
"""

import os
import shutil
import re
from pathlib import Path
from typing import Dict, List, Tuple

# Define the source and destination directories
SOURCE_DIR = Path(".planning/AlgorithmforDecisionMaking-md")
DEST_DIR = Path(".planning/Algorithms-for-Decision-Making")

# Book structure mapping based on the table of contents
BOOK_STRUCTURE = {
    "Front-Matter": {
        "files": [
            "01-algorithms-for-decision-making.md",
            "02-algorithms-for-decision-making.md",
            "03-mykel-j-kochenderfer.md",
            "04-tim-a-wheeler.md",
            "05-kyle-h-wray.md",
            "06-the-mit-press.md",
            "07-cambridge-massachusetts.md",
            "08-london-england.md",
            "09-to-our-families.md",
            "10-contents.md",
            "185-preface.md",
            "186-acknowledgments.md",
        ],
        "chapters": {},
    },
    "Part-I-Probabilistic-Reasoning": {
        "intro": "11-part-i.md",
        "chapters": {
            "01-Introduction": [
                "187-introduction.md",
                "188-1-1.md",
                "189-decision-making.md",
            ],
            "02-Representation": ["252-representation.md"],
            "03-Inference": ["521-inference.md"],
            "04-Parameter-Learning": ["700-parameter-learning.md"],
            "05-Structure-Learning": [],
            "06-Simple-Decisions": [],
        },
    },
    "Part-II-Sequential-Problems": {
        "intro": "15-part-ii.md",
        "chapters": {
            "07-Exact-Solution-Methods": [],
            "08-Approximate-Value-Functions": [],
            "09-Online-Planning": [],
            "10-Policy-Search": [],
            "11-Policy-Gradient-Estimation": [],
            "12-Policy-Gradient-Optimization": [],
            "13-Actor-Critic-Methods": [],
            "14-Policy-Validation": [],
        },
    },
    "Part-III-Model-Uncertainty": {
        "intro": "55-part-iii.md",
        "chapters": {
            "15-Exploration-and-Exploitation": [],
            "16-Model-Based-Methods": [],
            "17-Model-Free-Methods": [],
            "18-Imitation-Learning": [],
        },
    },
    "Part-IV-State-Uncertainty": {
        "intro": "90-part-iv.md",
        "chapters": {
            "19-Beliefs": [],
            "20-Exact-Belief-State-Planning": [],
            "21-Offline-Belief-State-Planning": [],
            "22-Online-Belief-State-Planning": [],
            "23-Controller-Abstractions": [],
        },
    },
    "Part-V-Multiagent-Systems": {
        "intro": "135-part-v.md",
        "chapters": {
            "24-Multiagent-Reasoning": [],
            "25-Sequential-Problems": [],
            "26-State-Uncertainty": [],
            "27-Collaborative-Agents": [],
        },
    },
    "Appendices": {
        "files": [
            "3507-appendices.md",
            "3508-mathematical-concepts.md",
            "3658-probability-distributions.md",
            "3676-computational-complexity.md",
            "3707-neural-representations.md",
            "3789-search-algorithms.md",
            "3823-problems.md",
            "4009-julia.md",
        ],
        "chapters": {},
    },
    "Back-Matter": {
        "files": [
            "4169-references.md",
            "4177-index.md",
        ],
        "chapters": {},
    },
}


def read_file_metadata(filepath: Path) -> Dict[str, str]:
    """Read the YAML front matter from a markdown file."""
    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()
        if content.startswith("---"):
            parts = content.split("---", 2)
            if len(parts) >= 3:
                return {"content": content, "title": filepath.stem}
    return {"content": "", "title": filepath.stem}


def get_chapter_number_from_filename(filename: str) -> Tuple[int, int]:
    """
    Extract chapter and section numbers from filenames like '188-1-1.md'
    Returns (chapter, section) tuple.
    """
    match = re.search(r"(\d+)-(\d+)-(\d+)\.md$", filename)
    if match:
        _, chapter, section = match.groups()
        return (int(chapter), int(section))

    match = re.search(r"(\d+)-(\d+)\.md$", filename)
    if match:
        _, number = match.groups()
        return (int(number), 0)

    return (0, 0)


def organize_by_chapter_numbers():
    """
    Organize files by detecting chapter numbers from filenames.
    This is a more automated approach.
    """
    source = SOURCE_DIR
    dest = DEST_DIR

    if not source.exists():
        print(f"Source directory {source} does not exist!")
        return

    # Track which files we've organized
    organized_files = set()

    # First pass: organize known structure
    for part_name, part_info in BOOK_STRUCTURE.items():
        part_dir = dest / part_name
        part_dir.mkdir(parents=True, exist_ok=True)

        # Copy part introduction if exists
        if "intro" in part_info and part_info["intro"]:
            intro_file = source / part_info["intro"]
            if intro_file.exists():
                shutil.copy2(intro_file, part_dir / "README.md")
                organized_files.add(part_info["intro"])

        # Copy standalone files
        if "files" in part_info:
            for filename in part_info["files"]:
                src_file = source / filename
                if src_file.exists():
                    shutil.copy2(src_file, part_dir / filename)
                    organized_files.add(filename)

    # Second pass: organize by chapter numbers
    all_files = sorted(source.glob("*.md"))

    # Group files by chapter number
    chapter_files: Dict[int, List[Path]] = {}

    for filepath in all_files:
        if filepath.name in organized_files:
            continue

        chapter_num, section_num = get_chapter_number_from_filename(filepath.name)

        if chapter_num > 0:
            if chapter_num not in chapter_files:
                chapter_files[chapter_num] = []
            chapter_files[chapter_num].append(filepath)

    # Map chapters to parts (approximate)
    chapter_to_part = {
        1: "Part-I-Probabilistic-Reasoning",
        2: "Part-I-Probabilistic-Reasoning",
        3: "Part-I-Probabilistic-Reasoning",
        4: "Part-I-Probabilistic-Reasoning",
        5: "Part-I-Probabilistic-Reasoning",
        6: "Part-I-Probabilistic-Reasoning",
        7: "Part-II-Sequential-Problems",
        8: "Part-II-Sequential-Problems",
        9: "Part-II-Sequential-Problems",
        10: "Part-II-Sequential-Problems",
        11: "Part-II-Sequential-Problems",
        12: "Part-II-Sequential-Problems",
        13: "Part-II-Sequential-Problems",
        14: "Part-II-Sequential-Problems",
        15: "Part-III-Model-Uncertainty",
        16: "Part-III-Model-Uncertainty",
        17: "Part-III-Model-Uncertainty",
        18: "Part-III-Model-Uncertainty",
        19: "Part-IV-State-Uncertainty",
        20: "Part-IV-State-Uncertainty",
        21: "Part-IV-State-Uncertainty",
        22: "Part-IV-State-Uncertainty",
        23: "Part-IV-State-Uncertainty",
        24: "Part-V-Multiagent-Systems",
        25: "Part-V-Multiagent-Systems",
        26: "Part-V-Multiagent-Systems",
        27: "Part-V-Multiagent-Systems",
    }

    # Organize chapters
    for chapter_num, files in sorted(chapter_files.items()):
        if chapter_num in chapter_to_part:
            part_name = chapter_to_part[chapter_num]
            chapter_dir = dest / part_name / f"Chapter-{chapter_num:02d}"
            chapter_dir.mkdir(parents=True, exist_ok=True)

            # Sort files by section number
            files_sorted = sorted(
                files, key=lambda f: get_chapter_number_from_filename(f.name)[1]
            )

            for filepath in files_sorted:
                shutil.copy2(filepath, chapter_dir / filepath.name)
                organized_files.add(filepath.name)

    # Third pass: copy any remaining files to a misc folder
    misc_dir = dest / "Miscellaneous"
    misc_dir.mkdir(parents=True, exist_ok=True)

    for filepath in all_files:
        if filepath.name not in organized_files:
            shutil.copy2(filepath, misc_dir / filepath.name)

    print(f"✓ Organized {len(organized_files)} files into structured folders")
    print(f"✓ Created structure in: {dest}")


def create_index_files():
    """Create README.md index files for each part and chapter."""
    dest = DEST_DIR

    # Create main README
    main_readme = dest / "README.md"
    with open(main_readme, "w", encoding="utf-8") as f:
        f.write("""# Algorithms for Decision Making

**Authors:** Mykel J. Kochenderfer, Tim A. Wheeler, Kyle H. Wray

**Publisher:** The MIT Press

This is a structured organization of the book "Algorithms for Decision Making"
converted from PDF to markdown format.

## Structure

- **Front Matter** - Preface, Acknowledgments, Contents
- **Part I: Probabilistic Reasoning** - Chapters 1-6
- **Part II: Sequential Problems** - Chapters 7-14
- **Part III: Model Uncertainty** - Chapters 15-18
- **Part IV: State Uncertainty** - Chapters 19-23
- **Part V: Multiagent Systems** - Chapters 24-27
- **Appendices** - Mathematical concepts, Probability distributions, etc.
- **Back Matter** - References, Index

## About

This book provides a broad introduction to algorithms for decision making under
uncertainty, covering topics including probabilistic reasoning, sequential decision
problems, model uncertainty, state uncertainty, and multiagent systems.

All algorithms in the book are implemented in the Julia programming language.

## Original Source

Converted from: `AlgorithmforDecisionMaking.pdf`
Conversion date: 2025-10-25
""")

    print(f"✓ Created main README at {main_readme}")


def main():
    """Main execution function."""
    print("=" * 60)
    print("Algorithms for Decision Making - File Reorganization")
    print("=" * 60)
    print()

    # Check if source exists
    if not SOURCE_DIR.exists():
        print(f"❌ Source directory not found: {SOURCE_DIR}")
        return

    # Create destination directory structure
    DEST_DIR.mkdir(parents=True, exist_ok=True)

    # Organize files
    print("Organizing files by structure...")
    organize_by_chapter_numbers()

    # Create index files
    print("\nCreating index files...")
    create_index_files()

    print("\n" + "=" * 60)
    print("✓ Reorganization complete!")
    print(f"✓ New structure available at: {DEST_DIR}")
    print("=" * 60)


if __name__ == "__main__":
    main()
