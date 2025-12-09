---
converted: '2025-10-29'
source: Token Efficient AI Agent Pipeline.pdf
title: 3. Final Architecture
---

# 3. Final Architecture

_Source page: 5_



3.1 Complete Pipeline Overview


master_plan.md


master_plan.md


(Immutable Core Guideline)


(Immutable Core Guideline)


Phase 0: Feature to Plan Conversion


Phase 0: Feature to Plan Conversion


plan.md + test.md


plan.md + test.md


(Feature-Specific)


(Feature-Specific)


Phase 1: Iteration 1


Phase 1: Iteration 1


Initial Wave Decomposition


Initial Wave Decomposition


waves/


waves/


wave1/planw1.md


wave1/planw1.md


wave2/planw2.md


wave2/planw2.md


wave3/planw3.md


wave3/planw3.md


Phase 2: Iteration 2


Phase 2: Iteration 2


Self-Resolution + Test Generation


Self-Resolution + Test Generation


waves/ (updated)


waves/ (updated)


wave1/planw1.md (updated)


wave1/planw1.md (updated)


wave1/testw1.md


wave1/testw1.md


wave2/planw2.md (updated)


wave2/planw2.md (updated)


wave2/testw2.md


wave2/testw2.md


wave3/planw3.md (updated)


wave3/planw3.md (updated)


wave3/testw3.md


wave3/testw3.md


decision_log.md


decision_log.md


Phase 3: Dependency Analysis


Phase 3: Dependency Analysis


& Stage Creation


& Stage Creation


stages.md


stages.md


(Execution Stages & Dependencies)


(Execution Stages & Dependencies)


Phase 4: Implementation (Theoretical)


Phase 4: Implementation (Theoretical)


Parallel Execution per Stage


Parallel Execution per Stage


Multi-Agent Parallel Execution


Multi-Agent Parallel Execution


Stage 1: Agents A (w1), B (w2), C (w3)


Stage 1: Agents A (w1), B (w2), C (w3)


Stage 2: Agents A (w4), B (w5), F (w8)


Stage 2: Agents A (w4), B (w5), F (w8)


Phase Descriptions:


Phase 0: Feature to Plan Conversion


Input: master_plan.md + Feature Requirements


Output: plan.md + test.md


Phase 1: Initial Wave Decomposition (Iteration 1)


Input: plan.md + test.md + master_plan.md


Output: wave1/planw1.md, wave2/planw2.md, wave3/planw3.md, ...


Phase 2: Self-Resolution & Test Generation (Iteration 2)


Input: All planw[N].md + test.md + project history


Output: Updated planw[N].md + testw[N].md + decision_log.md


Phase 3: Dependency Analysis & Stage Creation


Input: All planw[N].md files


Output: stages.md (execution stages & dependencies)


Phase 4: Implementation (Theoretical)


Input: stages.md + all wave files


Output: Multi-agent parallel execution by stage


3.2 Phase Descriptions


Phase 0: Feature to Plan Conversion


Input: Feature requirements + master_plan.md


Output: plan.md + test.md


Purpose: Transform high-level feature requests into structured tactical plans and acceptance criteria


Phase 1: Initial Wave Decomposition (Iteration 1)


Input: plan.md + test.md + master_plan.md


Output: wave[N]/planw[N].md files


Purpose: Break down feature into logical sub-modules with clear task definitions


Phase 2: Self-Resolution & Test Generation (Iteration 2)


Input: All planw[N].md + test.md + project history


Output: Updated planw[N].md + testw[N].md + decision_log.md


Purpose: Resolve ambiguities autonomously and generate test specifications


Phase 3: Dependency Analysis & Stage Creation


Input: All planw[N].md files


Output: stages.md


Purpose: Calculate execution stages for parallel processing based on dependencies


Phase 4: Implementation (Theoretical)


Input: stages.md + all wave files


Output: Working code (theoretical)


Purpose: Execute waves in parallel per stage using multiple agents