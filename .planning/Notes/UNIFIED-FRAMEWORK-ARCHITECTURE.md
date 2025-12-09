# Unified Framework Architecture

**Date**: 2025-01-23  
**Status**: Core Architecture Design  
**Goal**: Speech → Company through unified agent pipeline

---

## Overview

A unified framework that combines speech-to-text processing with the Token Efficient AI Agent Pipeline, creating a complete "Speech to Company" system through specialized agents and clear phase separation.

---

## Core Flow: Speech → Company

### Input Processing
1. **Speech Capture**: Audio stored as wave file
2. **Speech-to-Text**: Whisper algorithm converts wave → text
3. **Text File**: Raw speech content in text format

### Phase 0: Constitution Agent
**Input**: Speech text file  
**Output**: Multiple Constitution documents

#### Process:
1. **C0 (Root Constitution)**: Main constitution outlining:
   - General app idea
   - Overall business concept
   - Constellation structure
   - High-level requirements

2. **C1, C2, C3...CN (Sub-Constitutions)**: Individual app constitutions
   - Each defines a specific micro-app
   - Detailed requirements per app
   - Integration specifications
   - API contracts

**Black Box**: Constitution generation logic (iterative refinement)

---

## Phase 1: Planner Agent

**Input**: Constitution documents (C0, C1, C2...CN)  
**Output**: Structured plan folders with test pairs

### File Structure Generated:
```
Plans/
├── plan1/
│   ├── plan1.md          # Main plan for app 1
│   ├── test1.md          # Test specifications for app 1
│   └── waves/
│       ├── wave1/
│       │   ├── subplan1.md
│       │   └── subtest1.md
│       ├── wave2/
│       │   ├── subplan2.md
│       │   └── subtest2.md
│       └── waveN/
│           ├── subplanN.md
│           └── subtestN.md
├── plan2/
│   ├── plan2.md
│   ├── test2.md
│   └── waves/...
└── planN/
    ├── planN.md
    ├── testN.md
    └── waves/...
```

### Planner Agent Responsibilities:
- Parse Constitution documents
- Create discrete plans (plan1.md, plan2.md...)
- Generate test specifications (test1.md, test2.md...)
- Decompose each plan into waves (subplans)
- Create digestible subplans for one-shot model execution
- Ensure each wave has plan + test parity

---

## Phase 2: Question Agent

**Input**: All plan folders and files  
**Output**: Questions.md + Decision Log

### Question Agent Responsibilities:
1. **Analyze Plans**: Review all plan.md and subplan.md files
2. **Identify Ambiguities**: Find unclear requirements, missing details
3. **Generate Questions**: Create comprehensive question list
4. **Output**: `Questions.md` document

### Decision Logging:
- Log all autonomous decisions
- Track decision rationale
- Maintain audit trail

---

## Phase 3: Optimization Agent (Senior Engineer)

**Input**: Questions.md + All plan files + Codebase context  
**Output**: Optimized plans + Enhanced tests + Decision log

### Optimization Agent Responsibilities:
1. **Analyze Questions**: Review Questions.md from Phase 2
2. **Historical Pattern Analysis**: 
   - Search Guides/ folder
   - Review previous implementations
   - Identify best practices
3. **Codebase Context Review**:
   - Analyze Design/ folder
   - Review Docs/ folder
   - Consider existing patterns
4. **Plan Optimization**:
   - Optimize main plans (plan1.md, plan2.md...)
   - Optimize main tests (test1.md, test2.md...)
   - Optimize all wave subplans
   - Generate wave-specific tests
5. **Test Generation**:
   - Create unit tests for each wave
   - Generate integration tests
   - Ensure comprehensive test coverage

### Output Structure:
```
Plans/
├── plan1/
│   ├── plan1.md          # OPTIMIZED
│   ├── test1.md          # ENHANCED
│   ├── decision_log.md   # NEW - Why decisions made
│   └── waves/
│       ├── wave1/
│       │   ├── subplan1.md    # OPTIMIZED
│       │   ├── subtest1.md    # ENHANCED
│       │   └── unit_tests.md  # NEW
│       └── waveN/
│           ├── subplanN.md    # OPTIMIZED
│           ├── subtestN.md    # ENHANCED
│           └── unit_tests.md  # NEW
```

---

## Phase 4: Stages Agent

**Input**: All optimized plans and waves  
**Output**: stages.md (Dependency Graph + Execution Plan)

### Stages Agent Responsibilities:
1. **Dependency Analysis**: 
   - Analyze all plan relationships
   - Identify wave dependencies
   - Build Directed Acyclic Graph (DAG)
2. **Stage Calculation**:
   - Determine execution order
   - Identify parallel execution opportunities
   - Calculate critical path
3. **Output**: `stages.md` with execution strategy

### stages.md Structure:
```markdown
# Execution Stages

## Stage 1 (Parallel)
- plan1/wave1
- plan2/wave1
- plan3/wave1

## Stage 2 (Parallel)
- plan1/wave2 (depends on plan1/wave1)
- plan2/wave2 (depends on plan2/wave1)
- plan3/wave3 (independent)

## Critical Path
plan1 → plan2 → plan3
```

---

## Phase 5: Parallel Execution (Test-Driven Generation)

**Input**: stages.md + All optimized plans and waves  
**Output**: Complete Constellation (Deployed Business)

### Execution Process:

#### Stage 1: Parallel Waves
- **Waves**: Wave1, Wave3 (independent)
- **Agents**: A, B, C (parallel execution)
- **Process**: Test-driven generation + immediate testing + debugging loop

#### Stage 2: Dependent Waves  
- **Waves**: Wave4, Wave5, Wave8 (depend on Stage 1)
- **Agents**: D, E, F (parallel execution)
- **Process**: Test-driven generation + immediate testing + debugging loop

### Test-Driven Generation Protocol:

#### For Each Wave:
1. **Code + Tests Simultaneously**: Generate implementation and tests together
2. **Run Tests Immediately**: Execute tests right after generation
3. **Validation**: Check if tests pass
4. **Debug Loop** (if tests fail):
   - Debug both code AND tests (max 3 attempts)
   - Re-run tests after each fix
   - Only proceed when tests pass
5. **Wave Complete**: Mark wave as done when tests pass

### Debug Loop Protocol:
```
Tests Fail → Debug Code + Tests → Re-run Tests
    ↓ (max 3 attempts)
Still Failing → Human Intervention Required
    ↓
Tests Pass → Wave Complete → Next Wave
```

### Cross-Wave Integration:
- All completed waves integrate together
- End-to-end testing across waves
- Final validation of complete constellation
- Business deployment

### Success Criteria:
- All waves pass their tests
- Cross-wave integration successful
- Complete constellation deployed and functional
- All original requirements met

---

## Agent Specialization

### 1. Constitution Agent
- **Input**: Speech text
- **Output**: C0 + C1...CN constitutions
- **Skills**: Business analysis, requirement extraction, system design
- **Black Box**: Iterative constitution refinement

### 2. Planner Agent
- **Input**: Constitution documents
- **Output**: Plan folders with test pairs
- **Skills**: Task decomposition, test specification, wave creation
- **Focus**: One-shot digestible plans

### 3. Question Agent
- **Input**: All plan files
- **Output**: Questions.md + Decision log
- **Skills**: Ambiguity detection, requirement analysis
- **Focus**: Identify what needs clarification

### 4. Optimization Agent (Senior Engineer)
- **Input**: Questions + Plans + Codebase context
- **Output**: Optimized plans + Enhanced tests + Decision log
- **Skills**: Historical analysis, best practices, test generation
- **Focus**: Production-ready plans

### 5. Stages Agent
- **Input**: Optimized plans
- **Output**: stages.md (execution strategy)
- **Skills**: Dependency analysis, parallel execution planning
- **Focus**: Efficient execution coordination

---

## File Structure Integration

### Foundation Integration:
```
Foundation/
├── Constitution/          # C0, C1, C2...CN
├── Plans/                # Enhanced with waves/
│   ├── plan1/
│   │   ├── plan1.md
│   │   ├── test1.md
│   │   ├── decision_log.md
│   │   └── waves/
│   │       ├── wave1/
│   │       │   ├── subplan1.md
│   │       │   ├── subtest1.md
│   │       │   └── unit_tests.md
│   │       └── waveN/
│   ├── plan2/
│   └── planN/
├── Guides/               # Historical patterns
├── Docs/                 # External documentation
├── Design/               # Shared code patterns
└── stages.md             # Execution strategy
```

---

## Key Innovations

### 1. Clear Agent Separation
- Each agent has specific responsibilities
- Clear input/output contracts
- Specialized skills per agent

### 2. Wave-Based Decomposition
- Plans broken into digestible waves
- Each wave = one-shot model execution
- Parallel execution within stages

### 3. Test-Driven Planning
- Every plan has corresponding tests
- Wave-level test specifications
- Unit tests per wave

### 4. Historical Learning
- Optimization agent learns from Guides/
- Pattern recognition from Design/
- Best practices integration

### 5. Autonomous Decision Logging
- All decisions documented
- Rationale captured
- Audit trail maintained

---

## Execution Flow

```
Speech (Wave) 
    ↓
Whisper (Text)
    ↓
Constitution Agent (C0 + C1...CN)
    ↓
Planner Agent (Plan folders + waves)
    ↓
Question Agent (Questions.md + Decision log)
    ↓
Optimization Agent (Optimized plans + tests)
    ↓
Stages Agent (stages.md)
    ↓
Execution (Parallel wave processing)
    ↓
Constellation (Complete business)
```

---

## Benefits

### 1. Token Efficiency
- Wave-based context isolation
- Specialized agent focus
- Historical pattern reuse

### 2. Quality Assurance
- Test-driven planning
- Senior engineer optimization
- Comprehensive test coverage

### 3. Scalability
- Parallel execution
- Clear dependency management
- Modular agent architecture

### 4. Maintainability
- Clear separation of concerns
- Documented decision process
- Historical learning integration

---

## Next Steps

1. **Agent Implementation**: Build each specialized agent
2. **File Structure**: Implement enhanced Plans/ structure
3. **Integration**: Connect with existing Foundation architecture
4. **Testing**: Validate with sample speech inputs
5. **Optimization**: Iterate based on results

---

## Conclusion

This unified framework provides a clear path from speech to complete business constellation through specialized agents and structured phases. Each agent has specific responsibilities, clear inputs/outputs, and the system learns from historical patterns to improve over time.

The wave-based decomposition ensures token efficiency while the test-driven approach guarantees quality. The autonomous decision logging provides transparency and enables continuous improvement.

---

*"From speech to company, through specialized agents and structured phases."*
