# Foundation Framework - Planning Directory Index

**Quick Navigation Guide**

```
.planning/
│
├── 📖 START HERE
│   ├── QUICKSTART.md ...................... Get up and running in 5 minutes
│   ├── EXECUTIVE-SUMMARY.md ............... High-level vision (15 min read)
│   └── README.md .......................... Directory overview
│
├── 📋 CORE DOCUMENTS
│   ├── Constitution/
│   │   └── Foundation-Constitution.tex .... The complete specification
│   │                                        (The Constitution of Foundation itself)
│   │                                        70+ pages defining the entire framework
│   │
│   ├── ROADMAP.md ......................... Implementation timeline & phases
│   │                                        Phase 1-7 breakdown with estimates
│   │
│   └── Diagrams/
│       └── system-architecture.txt ........ Visual architecture (ASCII art)
│                                            Complete pipeline visualization
│
├── 📝 WORKING DOCUMENTS
│   ├── Notes/
│   │   └── 2024-brainstorm-session-1.md .. Initial vision session
│   │                                        Raw notes capturing the epiphany
│   │                                        Foundation concepts explained
│   │
│   └── Proofs/
│       └── (empty - for POC experiments) .. Proof-of-concept code goes here
│
└── ⚙️  CONFIGURATION
    └── .gitignore ......................... LaTeX artifacts, temp files
```

---

## Reading Order (Recommended)

### 🚀 New to Foundation? (1 hour total)
1. **QUICKSTART.md** (5 min) - What is this?
2. **EXECUTIVE-SUMMARY.md** (15 min) - The vision
3. **Notes/2024-brainstorm-session-1.md** (30 min) - How we got here
4. **Diagrams/system-architecture.txt** (10 min) - Visual understanding

### 📚 Deep Dive (3-4 hours)
1. **Constitution/Foundation-Constitution.tex** (2 hours) - Complete spec
2. **ROADMAP.md** (30 min) - Implementation plan
3. **README.md** (15 min) - Working guidelines

### 🔨 Ready to Build (Start here)
1. **ROADMAP.md** → Find current phase tasks
2. **Constitution/** → Reference the spec
3. **Notes/** → Document your thinking
4. **Proofs/** → Build your POC

---

## Document Descriptions

### QUICKSTART.md
**Purpose**: Get anyone up to speed in 5-10 minutes  
**Contents**: 
- What Foundation is (1 paragraph)
- How it works (5 steps)
- Where to start
- Common questions

**Read this if**: You're new and want the fastest overview

---

### EXECUTIVE-SUMMARY.md
**Purpose**: Comprehensive high-level overview for stakeholders  
**Contents**:
- Problem & solution
- How it works (detailed)
- Constellation model explained
- Economic model (proof of useful work)
- Business case
- Roadmap summary
- Success metrics

**Read this if**: You need to understand the complete vision without technical depth

---

### Foundation-Constitution.tex
**Purpose**: THE definitive specification of Foundation Framework  
**Contents** (15 Articles):
- Article I: Foundational Principles
- Article II: Architectural Framework
- Article III: Testing Backbone
- Article IV: Distributed Infrastructure
- Article V: The Planner System
- Article VI: Micro-App Library
- Article VII: Entanglement Layer
- Article VIII: Human-in-the-Loop
- Article IX: Quality Assurance
- Article X: Main Orchestrator
- Article XI: Documentation Standards
- Article XII: Versioning & Amendments
- Article XIII: Security & Compliance
- Article XIV: Future Extensions
- Article XV: Governance

**Read this if**: You need complete technical and philosophical specification

**How to compile**:
```bash
cd Constitution/
pdflatex Foundation-Constitution.tex
pdflatex Foundation-Constitution.tex  # Twice for TOC
open Foundation-Constitution.pdf
```

---

### ROADMAP.md
**Purpose**: Step-by-step implementation plan from concept to production  
**Contents**:
- Phase 0: Foundation Setup ✅
- Phase 1: Swift Testing Backbone 🎯 CURRENT
- Phase 2: The Planner
- Phase 3: Single Micro-App Pipeline
- Phase 4: Entanglement Layer
- Phase 5: Multi-App Coordination
- Phase 6: Distributed Compute
- Phase 7: The Arena (Full Platform)
- Future phases
- Success metrics
- Resource requirements

**Read this if**: You want to know what we're building when, and how to contribute

---

### system-architecture.txt
**Purpose**: Visual representation of the complete system  
**Contents**:
- Customer input layer
- Main orchestrator
- Constellation determination
- Constitution layer
- The Planner
- Distributed compute network
- Implementation loops
- Integration & entanglement
- Verification & deployment
- Amendments & evolution

**Read this if**: You're a visual learner and want to see how everything connects

---

### 2024-brainstorm-session-1.md
**Purpose**: Raw notes from the initial vision session  
**Contents**:
- The epiphany: English as programming language
- Recursion vs. iteration insight
- Uber box analogy
- Twin pairs → Constellations evolution
- Five-folder Foundation structure
- Complete pipeline explanation
- Testing backbone rationale
- Distributed infrastructure vision
- Micro-app library concept
- Implementation priorities

**Read this if**: You want to understand the WHY behind every decision

---

### README.md
**Purpose**: Working guidelines for this directory  
**Contents**:
- Directory structure explanation
- Key concepts overview
- Working guidelines
- Contribution instructions
- Compilation instructions
- Philosophy

**Read this if**: You're going to be working in this directory regularly

---

## Key Concepts (Quick Reference)

### Constitutional Programming
Apps defined by LaTeX documents (Constitutions), not chat prompts

### Constellation Model
Complete businesses = networks of specialized micro-apps

### True Recursion
System improves the improvement system (not just iteration)

### Distributed Compute
Proof of useful work - earn tokens by contributing

### Human-in-the-Loop
Checkpoints only, not every detail

---

## Current Status

**Phase**: Phase 1 - Swift Testing Backbone  
**Status**: Planning Complete ✅ | Implementation Starting 🚀  
**Next Milestone**: Automated test generation working  
**Expected**: 2-3 weeks

---

## Quick Commands

### View all documents
```bash
cd .planning/
ls -lh
```

### Read in terminal
```bash
cat QUICKSTART.md
cat EXECUTIVE-SUMMARY.md
cat ROADMAP.md
cat Notes/2024-brainstorm-session-1.md
cat Diagrams/system-architecture.txt
```

### Compile Constitution
```bash
cd Constitution/
pdflatex Foundation-Constitution.tex
pdflatex Foundation-Constitution.tex
open Foundation-Constitution.pdf
```

### Search all documents
```bash
cd .planning/
grep -r "keyword" .
```

---

## Contributing

### Adding Notes
```bash
cd Notes/
touch YYYY-MM-DD-topic-name.md
# Document your thinking
```

### Adding Diagrams
```bash
cd Diagrams/
# Create visualization (ASCII, PNG, SVG, etc.)
```

### Adding Proofs
```bash
cd Proofs/
mkdir proof-name/
cd proof-name/
# Create POC, add README.md
```

### Updating Constitution
```bash
cd Constitution/
# Edit Foundation-Constitution.tex
# Add comments, update version
# Commit with detailed message
```

---

## Philosophy

> "We are not building apps. We are building the system that builds apps."

Every document here represents:
- **Learn Once** - Capture knowledge
- **Document Once** - Structure it clearly  
- **Automate Forever** - Make it executable

---

## Support & Questions

1. Check **QUICKSTART.md** for basics
2. Search documents for keywords
3. Add question to **Notes/** with your thoughts
4. (Future: Community Discord/Slack)

---

**Welcome to Foundation. Let's build the future of software development.**

*Last Updated: 2024 | Status: Active Development*