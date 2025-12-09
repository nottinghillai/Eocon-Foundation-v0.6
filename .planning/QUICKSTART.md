# Foundation Framework - Quick Start Guide

Welcome to the Foundation Framework planning directory! This guide will get you up and running quickly.

---

## What You'll Find Here

This `.planning/` directory contains the **meta-architecture**—the design of the system that designs systems.

```
.planning/
├── Constitution/          # The Constitution of Foundation itself
│   └── Foundation-Constitution.tex
├── Notes/                # Brainstorming, ideas, raw thoughts
├── Diagrams/             # Architecture visualizations
├── Proofs/               # Proof-of-concept experiments
├── ROADMAP.md           # Implementation timeline
├── EXECUTIVE-SUMMARY.md # High-level overview
└── QUICKSTART.md        # You are here
```

---

## 5-Minute Overview

### What Is Foundation?

Foundation transforms natural language specifications (LaTeX documents called "Constitutions") into complete business constellations—networks of specialized micro-apps that together form an operating company.

**Example**: Say "I need a trucking company" → Foundation spawns Client App + Driver App + Dispatch + Fleet Management + Legal + Accounting + HR + Analytics + Support + Marketing (all integrated and working).

### How It Works

1. **Constitution** (LaTeX) - Define what the business does
2. **Planner** - Analyzes Constitution, creates task graph
3. **Plans** (Markdown) - Executable specifications
4. **Distributed Execution** - Network generates code
5. **Automated Testing** - AI validates everything
6. **Constellation** - Complete business deployed

---

## Getting Started

### 1. Read the Core Documents (in order)

**Start here** (15 minutes):
```bash
# High-level vision
cat EXECUTIVE-SUMMARY.md
```

**Then dive deeper** (30 minutes):
```bash
# Our brainstorming session that created this
cat Notes/2024-brainstorm-session-1.md

# Visual architecture
cat Diagrams/system-architecture.txt
```

**For complete details** (1-2 hours):
```bash
# The full Constitution
cd Constitution/
# Open Foundation-Constitution.tex in your LaTeX editor
# Or compile it:
pdflatex Foundation-Constitution.tex
pdflatex Foundation-Constitution.tex  # Twice for TOC
```

**To understand timeline** (20 minutes):
```bash
# Implementation roadmap
cat ROADMAP.md
```

### 2. Understand the Current Phase

**We are currently in Phase 1: Swift Testing Backbone**

This is THE foundation. Without automated testing, the autonomous pipeline cannot work.

**What we're building**:
- Automated test generation from Plan specifications
- Test execution and validation
- Debug loops (AI attempts fixes automatically)
- Screenshot + OCR for UI tests

**Why it matters**: This proves that AI can validate its own work without constant human intervention.

### 3. Contributing to Planning

#### Adding Notes
```bash
cd Notes/
# Create a new markdown file
touch 2024-my-idea-about-X.md
# Document your thoughts
```

**Format**:
- Date at the top
- Clear sections
- Explain WHY, not just WHAT
- Future you (and AI) need to understand your thinking

#### Creating Diagrams
```bash
cd Diagrams/
# Use ASCII art, draw.io, Mermaid, etc.
# Save as .txt, .png, .svg, or source files
```

#### Building Proofs
```bash
cd Proofs/
mkdir my-proof-of-concept/
cd my-proof-of-concept/
# Create small, focused experiments
# Test specific concepts
# Document learnings in README.md
```

#### Updating the Constitution
```bash
cd Constitution/
# Edit Foundation-Constitution.tex
# Add comments explaining your changes
# Update version number
# Commit with detailed message
```

---

## Key Concepts (Must Understand)

### 1. Constitutional Programming
Applications are defined through structured LaTeX documents, not chat prompts.

**Old**: Chat with AI → Get code → Repeat for every feature  
**New**: Write Constitution once → System generates entire app

### 2. Constellation Model
Not just apps—complete **businesses** composed of specialized micro-apps:
- Core functions (Legal, Accounting, HR) - universal
- Industry functions (Fleet, Kitchen, Medical Records) - sector-specific  
- Custom functions - bespoke needs

### 3. True Recursion
Not iteration (improve X → improve X → improve X)  
But recursion (system improves the improvement system itself)

**Examples**:
- Plan templates that create new plan templates
- Tests that improve test generators
- Agents that propose amendments to themselves

### 4. Distributed Compute
Your computer earns tokens by contributing to the network:
- Pull tasks from queue
- Generate code, run tests
- Upload results
- Get paid in tokens

**Proof of useful work**, not arbitrary mining.

### 5. Human-in-the-Loop
Humans review at checkpoints:
- Constitution approval
- Final verification
- Amendment approval
- When AI can't resolve issues

But NOT every detail—that's the whole point.

---

## Compiling the Constitution

### Prerequisites
- LaTeX distribution (TeX Live, MacTeX, MiKTeX)
- Or use online editor (Overleaf)

### Local Compilation
```bash
cd .planning/Constitution/

# Compile (run twice for table of contents)
pdflatex Foundation-Constitution.tex
pdflatex Foundation-Constitution.tex

# Open the PDF
open Foundation-Constitution.pdf  # macOS
xdg-open Foundation-Constitution.pdf  # Linux
start Foundation-Constitution.pdf  # Windows
```

### Using Overleaf
1. Go to https://www.overleaf.com
2. Create new project
3. Upload `Foundation-Constitution.tex`
4. Compile and view

---

## Common Questions

### Q: Where do I start if I want to contribute?

**A**: 
1. Read EXECUTIVE-SUMMARY.md (15 min)
2. Read Notes/2024-brainstorm-session-1.md (30 min)
3. Look at ROADMAP.md to see current phase
4. Check what's not completed in current phase
5. Pick a task and dive in

### Q: How is this different from other AI coding tools?

**A**: 
- **Cursor/Copilot**: Chat-based, per-feature, ephemeral
- **Foundation**: Constitutional, entire constellations, reusable

We're not making coding easier—we're making it **unnecessary** for implementation details.

### Q: Why LaTeX for Constitutions?

**A**:
- Structured format
- Version control friendly
- Professional documentation standard
- Compiles to beautiful PDFs
- Clear sections and hierarchy
- Machines AND humans can parse it

### Q: Can I use this now?

**A**: Not yet. We're in Phase 1 (building the testing backbone). Check ROADMAP.md for timeline.

### Q: How can I help?

**A**:
- **Phase 1-3**: Help build testing, Planner, first micro-app
- **Phase 4-6**: Contribute to distributed infrastructure
- **Phase 7+**: Join as early user, contribute micro-apps to library

### Q: Is this open source?

**A**: The core framework will be open source. Premium micro-apps in the marketplace may be paid.

---

## Next Steps

### For Developers
1. **Read** the Constitution document (1-2 hours)
2. **Understand** the current phase (ROADMAP.md)
3. **Pick** a task from Phase 1
4. **Build** and document

### For Architects
1. **Review** the constellation model
2. **Design** micro-app Constitutions
3. **Define** entanglement patterns
4. **Document** best practices

### For Researchers
1. **Explore** proof-of-concept ideas
2. **Test** assumptions
3. **Document** findings in Proofs/
4. **Share** learnings in Notes/

---

## Resources

### Inside This Directory
- `Constitution/Foundation-Constitution.tex` - Complete specification
- `Notes/` - Brainstorming and ideas
- `Diagrams/` - Visual architecture
- `ROADMAP.md` - Implementation timeline
- `EXECUTIVE-SUMMARY.md` - High-level overview

### External Resources
- LaTeX Tutorial: https://www.overleaf.com/learn
- Directed Acyclic Graphs: https://en.wikipedia.org/wiki/Directed_acyclic_graph
- Microservices Architecture: https://microservices.io/

---

## Philosophy

> "We are not building apps. We are building the system that builds apps."

This directory embodies: **Learn Once, Document Once, Automate Forever**

Every hour spent here in careful documentation saves hundreds of hours in implementation.

---

## Status & Updates

**Current Phase**: Phase 1 - Swift Testing Backbone  
**Status**: Planning Complete, Implementation Beginning  
**Next Milestone**: Automated test generation working  
**Timeline**: See ROADMAP.md for details

---

## Support

Questions? Ideas? Concerns?

1. **Document it**: Create a note in Notes/
2. **Discuss it**: (Future: Discord/Slack)
3. **Propose it**: Update Constitution or Roadmap

---

*Welcome to the future of software development. Let's build it together.*