---
converted: '2025-10-29'
source: Token Efficient AI Agent Pipeline.pdf
title: 2. Evolution of the Architecture
---

# 2. Evolution of the Architecture

_Source page: 2_



2.1 Initial Concept: The Basic Plan


The initial approach was straightforward: create a


plan.md


file that agents would use to break down tasks into


smaller units. This would prevent agents from making assumptions by forcing them to work from explicit


requirements.


Initial Structure:


plan.md


waves.md (all tasks in one file)


plan.md


waves.md (all tasks in one file)


Limitations Identified:


Single


waves.md


file became unwieldy for complex features


No mechanism to handle ambiguities


All tasks loaded into agent context simultaneously


No testing framework integration


Sequential execution only


2.2 First Evolution: Questions and Modular Waves


To address ambiguities, we introduced a


questions.md


file where agents could consolidate all clarification needs


before proceeding.


Evolved Structure:


plan.md


wave1.md, wave2.md, wave3.md + questions.md


plan.md


wave1.md, wave2.md, wave3.md + questions.md


User answers questions


User answers questions


Updated wave files


Updated wave files


Key Insight:


Separating waves into individual files (wave1.md, wave2.md, etc.) where each represents a


cohesive sub-module provided:


Reduced context window per agent invocation


Clearer module boundaries


Easier parallel processing potential


Remaining Challenge:


The questions.md approach still required human intervention, creating bottlenecks in


the workflow.


2.3 Colleague Collaboration: Self-Resolution Mechanism


A critical breakthrough came from EJ's suggestion: instead of asking users questions, agents should attempt to


answer questions themselves using project history and established patterns.


EJ's Key Contribution:


"The agent should leverage past conversations and project history to resolve ambiguities autonomously. Only


when information is truly unavailable should it make documented decisions using optimal approaches."


This insight transformed the architecture from


interactive clarification


to


autonomous resolution


, potentially


dramatically reducing token consumption in back-and-forth exchanges.


New Resolution Strategy:


1. Agent identifies ambiguity


2. Queries project history (chat logs, codebase patterns)


3. If found: Apply historical approach


4. If not found and required: Use optimal industry-standard approach


5. Document decision in


decision_log.md


2.4 Testing Integration: Separating Concerns


Initially, test criteria were embedded within


plan.md


as "Success Criteria." However, this created confusion


between:


Feature requirements (what to build)


Success validation (how to verify)


Solution:


Extract test criteria into a separate


test.md


file, then generate wave-specific test specifications.


Benefits:


Clear separation of concerns


Test-driven decomposition possible


Each wave gets corresponding test specifications


Testing becomes explicit rather than implicit


2.5 Dependency Analysis: Enabling Parallelism


The final major evolution addressed execution strategy. Complex features have interdependent sub-modules,


and naive sequential execution wastes time.


Solution:


Introduce


stages.md


- a dependency tree that calculates execution stages based on wave


dependencies.


Example Scenario:


Wave 1 (Database Schema): No dependencies


Wave 2 (API Endpoints): No dependencies, but no dependents either


Wave 3 (Frontend): No dependencies


Wave 4 (Middleware): Depends on Wave 1


Wave 5 (Integration): Depends on Wave 1


Wave 8 (Analytics): Depends on Wave 3


Stage Calculation:


Stage 1:


Wave 1, Wave 3 (can execute in parallel)


Independent:


Wave 2 (can execute anytime - no dependencies, no dependents)


Stage 2:


Wave 4, Wave 5, Wave 8 (can execute in parallel after Stage 1)


This insight enabled theoretical multi-agent parallelism, potentially reducing total execution time significantly.


2.6 The Master Plan: Immutable Core Guidelines


The culminating realization: all these structures and processes needed to be codified in an immutable guideline


that agents always reference.


The Master Plan Concept:


Never changes (immutable core)


Serves as the "constitution" for agent behavior


Used in conjunction with feature requirements to generate feature-specific plans


Prevents drift in agent behavior across different features


This architecture ensures consistency across all features while allowing feature-specific customization through


plan.md


and


test.md