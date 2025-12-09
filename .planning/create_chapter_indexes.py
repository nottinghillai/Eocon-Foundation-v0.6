#!/usr/bin/env python3
"""
Create README.md index files for each chapter based on actual content.

This script scans the organized markdown files and creates comprehensive
README files for each chapter with proper links and descriptions.
"""

import os
import re
from pathlib import Path
from typing import Dict, List, Tuple
from collections import defaultdict

DEST_DIR = Path(".planning/Algorithms-for-Decision-Making")

# Chapter titles based on the book's structure
CHAPTER_TITLES = {
    1: "Introduction",
    2: "Representation",
    3: "Inference",
    4: "Parameter Learning",
    5: "Structure Learning",
    6: "Simple Decisions",
    7: "Exact Solution Methods",
    8: "Approximate Value Functions",
    9: "Online Planning",
    10: "Policy Search",
    11: "Policy Gradient Estimation",
    12: "Policy Gradient Optimization",
    13: "Actor-Critic Methods",
    14: "Policy Validation",
    15: "Exploration and Exploitation",
    16: "Model-Based Methods",
    17: "Model-Free Methods",
    18: "Imitation Learning",
    19: "Beliefs",
    20: "Exact Belief State Planning",
    21: "Offline Belief State Planning",
    22: "Online Belief State Planning",
    23: "Controller Abstractions",
    24: "Multiagent Reasoning",
    25: "Sequential Problems",
    26: "State Uncertainty",
    27: "Collaborative Agents",
}

PART_TITLES = {
    "Part-I-Probabilistic-Reasoning": "Part I: Probabilistic Reasoning",
    "Part-II-Sequential-Problems": "Part II: Sequential Problems",
    "Part-III-Model-Uncertainty": "Part III: Model Uncertainty",
    "Part-IV-State-Uncertainty": "Part IV: State Uncertainty",
    "Part-V-Multiagent-Systems": "Part V: Multiagent Systems",
}

PART_DESCRIPTIONS = {
    "Part-I-Probabilistic-Reasoning": """
This part introduces the foundations of probabilistic reasoning and decision making.
It covers probability theory, Bayesian networks, inference algorithms, parameter
learning, structure learning, and simple decision problems using utility theory.
""",
    "Part-II-Sequential-Problems": """
This part focuses on sequential decision problems modeled as Markov decision processes (MDPs).
Topics include exact and approximate solution methods, online planning, policy search,
policy gradient methods, actor-critic algorithms, and policy validation techniques.
""",
    "Part-III-Model-Uncertainty": """
This part addresses decision making when the model of the environment is uncertain.
It covers exploration-exploitation tradeoffs, model-based reinforcement learning,
model-free methods, and imitation learning approaches.
""",
    "Part-IV-State-Uncertainty": """
This part extends decision making to partially observable environments (POMDPs).
Topics include belief representations, exact and approximate belief state planning,
online planning methods, and controller abstractions for POMDPs.
""",
    "Part-V-Multiagent-Systems": """
This part introduces multiagent decision making where multiple agents interact.
It covers game theory, multiagent reasoning, sequential games (Markov games),
partially observable stochastic games, and collaborative multiagent systems.
""",
}


def read_file_title(filepath: Path) -> str:
    """Extract title from markdown file."""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
            # Look for YAML frontmatter title
            if content.startswith("---"):
                match = re.search(r"title:\s*(.+)", content)
                if match:
                    return match.group(1).strip()
            # Look for first header
            match = re.search(r"^#+\s+(.+)", content, re.MULTILINE)
            if match:
                return match.group(1).strip()
    except Exception:
        pass
    return filepath.stem


def create_chapter_readme(chapter_dir: Path, chapter_num: int):
    """Create README.md for a chapter directory."""
    if not chapter_dir.exists():
        return

    chapter_title = CHAPTER_TITLES.get(chapter_num, f"Chapter {chapter_num}")

    # Get all markdown files in the chapter
    md_files = sorted(chapter_dir.glob("*.md"))

    if not md_files:
        return

    # Group files by section
    sections = defaultdict(list)
    main_files = []

    for filepath in md_files:
        # Extract section number from filename
        match = re.search(r"(\d+)-(\d+)-(\d+)\.md$", filepath.name)
        if match:
            _, ch, sec = match.groups()
            if int(ch) == chapter_num:
                sections[int(sec)].append(filepath)
        else:
            # Check if it's a main chapter file
            if str(chapter_num) in filepath.name:
                main_files.append(filepath)

    # Create README content
    readme_content = f"""# Chapter {chapter_num}: {chapter_title}

## Overview

This chapter is part of "Algorithms for Decision Making" and covers topics related to
{chapter_title.lower()}.

## Contents

"""

    # Add main chapter files
    if main_files:
        readme_content += "### Main Content\n\n"
        for filepath in sorted(main_files):
            title = read_file_title(filepath)
            readme_content += f"- [{title}]({filepath.name})\n"
        readme_content += "\n"

    # Add sections
    if sections:
        readme_content += "### Sections\n\n"
        for sec_num in sorted(sections.keys()):
            files = sections[sec_num]
            if sec_num > 0:
                readme_content += f"#### Section {chapter_num}.{sec_num}\n\n"
                for filepath in sorted(files):
                    title = read_file_title(filepath)
                    readme_content += f"- [{title}]({filepath.name})\n"
                readme_content += "\n"

    # Add supplementary files if any
    other_files = [
        f
        for f in md_files
        if f not in main_files and f not in sum(sections.values(), [])
    ]
    if other_files:
        readme_content += "### Additional Materials\n\n"
        for filepath in sorted(other_files):
            title = read_file_title(filepath)
            readme_content += f"- [{title}]({filepath.name})\n"
        readme_content += "\n"

    readme_content += f"""
## Navigation

- [← Back to {PART_TITLES.get(chapter_dir.parent.name, "Part")}](../README.md)
- [← Main Book Index](../../README.md)

---

*This chapter contains {len(md_files)} markdown file(s).*
"""

    # Write README
    readme_path = chapter_dir / "README.md"
    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(readme_content)

    print(f"  ✓ Created README for Chapter {chapter_num}: {chapter_title}")


def create_part_readme(part_dir: Path):
    """Create README.md for a part directory."""
    if not part_dir.exists():
        return

    part_name = part_dir.name
    part_title = PART_TITLES.get(part_name, part_name)
    part_desc = PART_DESCRIPTIONS.get(part_name, "")

    # Get all chapter directories
    chapter_dirs = sorted(
        [d for d in part_dir.iterdir() if d.is_dir() and d.name.startswith("Chapter-")]
    )

    readme_content = f"""# {part_title}

## Description
{part_desc.strip()}

## Chapters

"""

    for chapter_dir in chapter_dirs:
        # Extract chapter number
        match = re.search(r"Chapter-(\d+)", chapter_dir.name)
        if match:
            chapter_num = int(match.group(1))
            chapter_title = CHAPTER_TITLES.get(chapter_num, f"Chapter {chapter_num}")

            # Count files in chapter
            md_files = list(chapter_dir.glob("*.md"))
            file_count = len([f for f in md_files if f.name != "README.md"])

            readme_content += f"### Chapter {chapter_num}: {chapter_title}\n\n"
            readme_content += f"[View Chapter →]({chapter_dir.name}/README.md) "
            readme_content += f"({file_count} files)\n\n"

    readme_content += """
## Navigation

- [← Back to Main Index](../README.md)

---
"""

    # Write README
    readme_path = part_dir / "README.md"
    with open(readme_path, "w", encoding="utf-8") as f:
        f.write(readme_content)

    print(f"✓ Created README for {part_title}")


def update_main_readme():
    """Update the main README with comprehensive information."""
    main_readme = DEST_DIR / "README.md"

    content = """# Algorithms for Decision Making

**Authors:** Mykel J. Kochenderfer, Tim A. Wheeler, Kyle H. Wray
**Publisher:** The MIT Press
**Conversion Date:** 2025-10-25

## About This Book

This book provides a broad introduction to algorithms for decision making under
uncertainty. It covers a wide variety of topics related to decision making,
introducing the underlying mathematical problem formulations and the algorithms
for solving them.

The book is intended for advanced undergraduates and graduate students, as well
as professionals in fields including mathematics, statistics, computer science,
aerospace, electrical engineering, and operations research.

All algorithms in the book are implemented in the **Julia programming language**.

## Book Structure

### [Front Matter](Front-Matter/)
Preface, Acknowledgments, and Table of Contents

### [Part I: Probabilistic Reasoning](Part-I-Probabilistic-Reasoning/README.md)
*Chapters 1-6*

Introduction to probability theory, Bayesian networks, inference algorithms,
parameter and structure learning, and utility theory for simple decisions.

- Chapter 1: Introduction
- Chapter 2: Representation
- Chapter 3: Inference
- Chapter 4: Parameter Learning
- Chapter 5: Structure Learning
- Chapter 6: Simple Decisions

### [Part II: Sequential Problems](Part-II-Sequential-Problems/README.md)
*Chapters 7-14*

Markov decision processes, exact and approximate solution methods, online planning,
policy search, and reinforcement learning algorithms.

- Chapter 7: Exact Solution Methods
- Chapter 8: Approximate Value Functions
- Chapter 9: Online Planning
- Chapter 10: Policy Search
- Chapter 11: Policy Gradient Estimation
- Chapter 12: Policy Gradient Optimization
- Chapter 13: Actor-Critic Methods
- Chapter 14: Policy Validation

### [Part III: Model Uncertainty](Part-III-Model-Uncertainty/README.md)
*Chapters 15-18*

Decision making with uncertain environment models, exploration-exploitation tradeoffs,
model-based and model-free reinforcement learning, and imitation learning.

- Chapter 15: Exploration and Exploitation
- Chapter 16: Model-Based Methods
- Chapter 17: Model-Free Methods
- Chapter 18: Imitation Learning

### [Part IV: State Uncertainty](Part-IV-State-Uncertainty/README.md)
*Chapters 19-23*

Partially observable Markov decision processes (POMDPs), belief representations,
exact and approximate planning methods, and controller abstractions.

- Chapter 19: Beliefs
- Chapter 20: Exact Belief State Planning
- Chapter 21: Offline Belief State Planning
- Chapter 22: Online Belief State Planning
- Chapter 23: Controller Abstractions

### [Part V: Multiagent Systems](Part-V-Multiagent-Systems/README.md)
*Chapters 24-27*

Game theory, multiagent reasoning, Markov games, partially observable stochastic
games, and collaborative decision making.

- Chapter 24: Multiagent Reasoning
- Chapter 25: Sequential Problems
- Chapter 26: State Uncertainty
- Chapter 27: Collaborative Agents

### [Appendices](Appendices/)
Mathematical concepts, probability distributions, computational complexity,
neural networks, search algorithms, example problems, and Julia programming guide.

### [Back Matter](Back-Matter/)
References and Index

## Usage

Each chapter is organized in its own directory with a README providing an overview
and links to all section files. Navigate through the book using the README files
in each directory.

## Original Source

- **PDF File:** `AlgorithmforDecisionMaking.pdf`
- **Conversion Format:** Markdown with YAML frontmatter
- **Total Files:** 4000+ markdown files

## License

The original book content is © The MIT Press. This structured markdown version
is intended for educational purposes and easier navigation of the material.

---

*Generated structure for "Algorithms for Decision Making"*
"""

    with open(main_readme, "w", encoding="utf-8") as f:
        f.write(content)

    print("✓ Updated main README")


def main():
    """Main execution function."""
    print("=" * 60)
    print("Creating Chapter Index Files")
    print("=" * 60)
    print()

    # Create chapter READMEs for each part
    for part_name in PART_TITLES.keys():
        part_dir = DEST_DIR / part_name
        if part_dir.exists():
            print(f"\n{PART_TITLES[part_name]}")
            print("-" * 40)

            # Find all chapter directories
            chapter_dirs = sorted(
                [
                    d
                    for d in part_dir.iterdir()
                    if d.is_dir() and d.name.startswith("Chapter-")
                ]
            )

            for chapter_dir in chapter_dirs:
                match = re.search(r"Chapter-(\d+)", chapter_dir.name)
                if match:
                    chapter_num = int(match.group(1))
                    create_chapter_readme(chapter_dir, chapter_num)

            # Create part README
            create_part_readme(part_dir)

    # Update main README
    print("\nMain Documentation")
    print("-" * 40)
    update_main_readme()

    print("\n" + "=" * 60)
    print("✓ Index creation complete!")
    print("=" * 60)


if __name__ == "__main__":
    main()
