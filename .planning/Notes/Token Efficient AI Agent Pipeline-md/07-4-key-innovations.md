---
converted: '2025-10-29'
source: Token Efficient AI Agent Pipeline.pdf
title: 4. Key Innovations
---

# 4. Key Innovations

_Source page: 7_



4.1 The Master Plan Pattern


An immutable guideline document that serves as the foundational "operating system" for agent behavior.


Without master_plan.md, every feature implementation requires re-establishing ground rules, consuming tokens


and risking inconsistency.


4.2 Self-Resolution via Project History


Agents query project history to answer their own questions rather than creating interactive clarification loops.


The decision_log.md provides an audit trail of all autonomous decisions.


Algorithm:


For each ambiguity:


For each ambiguity:


1. Search project history (chat logs, codebase patterns)


1. Search project history (chat logs, codebase patterns)


2. If pattern found: Apply historical approach, log decision


2. If pattern found: Apply historical approach, log decision


3. Else if not a requirement: Skip feature entirely


3. Else if not a requirement: Skip feature entirely


4. Else: Apply optimal industry-standard approach, log with rationale


4. Else: Apply optimal industry-standard approach, log with rationale


4.3 Wave-Based Modular Decomposition


Each sub-module gets its own directory with isolated plan and test files, enabling context isolation and parallel


processing.


4.4 Integrated Testing Framework


Testing is not an afterthought - test specifications are generated during the planning phase, ensuring test-driven


decomposition.


4.5 Dependency-Based Stage Calculation


Automatic calculation of execution stages based on wave dependencies, enabling parallel processing and


identifying the critical path.