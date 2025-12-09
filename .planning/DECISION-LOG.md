# Foundation Decision Log

**Purpose:** Track major decisions using formal decision-making frameworks  
**Started:** 2025-01-XX  
**Framework:** Based on "Algorithms for Decision Making" principles

---

## How to Use This Log

For each significant decision:
1. Define current **STATE**
2. List **ACTIONS** being considered
3. Estimate **EXPECTED VALUE** for each action
4. Document **DECISION** made and reasoning
5. Later, record **ACTUAL OUTCOME**
6. Calculate **LEARNING** (prediction error, insights)

---

## Decision Template

```markdown
### Decision #XXX: [Title]
**Date:** YYYY-MM-DD  
**Decision Maker:** [Name/Team]  
**Context:** [Current phase, situation, constraints]

#### State
- Current Phase: [e.g., Phase 1, Week 2]
- Key Constraints: [time, resources, dependencies]
- Uncertainty Factors: [what we don't know]

#### Actions Considered

| Action | Description | Effort (days) | Success Prob | Expected Value | Notes |
|--------|-------------|---------------|--------------|----------------|-------|
| A1     | [Description] | X | 0.Y | EV = ? | [Pros/Cons] |
| A2     | [Description] | X | 0.Y | EV = ? | [Pros/Cons] |
| A3     | [Description] | X | 0.Y | EV = ? | [Pros/Cons] |

#### Expected Value Calculation

```
Action A1:
  Success (80%): +100 value - 5 days = +95
  Failure (20%): -20 value - 5 days = -25
  EV(A1) = 0.8(95) + 0.2(-25) = 76 - 5 = 71

Action A2:
  Success (60%): +80 value - 3 days = +77
  Failure (40%): -15 value - 3 days = -18
  EV(A2) = 0.6(77) + 0.4(-18) = 46.2 - 7.2 = 39
```

#### Decision Made
**Choice:** Action A1  
**Reasoning:** Higher expected value despite higher risk  
**Confidence Level:** 75%

#### Risk Mitigation
- [How we'll handle if things go wrong]
- [Fallback plan]
- [Early warning signals]

#### Actual Outcome (Update Later)
**Date Resolved:** YYYY-MM-DD  
**Result:** [Success/Failure/Partial]  
**Actual Value:** [Measured outcome]  
**Actual Effort:** [Days spent]

#### Learning
**Prediction Error:** [Actual - Expected]  
**What We Learned:** [Key insights]  
**Update Beliefs:** [How this changes future estimates]  
**Template Improvements:** [How to decide better next time]
```

---

## Active Decisions

### Decision #001: Test Template Comprehensiveness
**Date:** 2025-01-XX  
**Decision Maker:** Core Team  
**Context:** Phase 1 - Swift Testing Backbone, Week 1

#### State
- Current Phase: Phase 1, beginning
- Key Constraints: 3-week timeline, limited LLM budget
- Uncertainty Factors: Unclear how comprehensive tests need to be for autonomous execution

#### Actions Considered

| Action | Description | Effort (days) | Success Prob | Expected Value | Notes |
|--------|-------------|---------------|--------------|----------------|-------|
| A1 - Minimal | Basic happy-path tests only | 2 | 0.50 | 35 | Fast but risky |
| A2 - Standard | Happy + edge cases | 5 | 0.75 | 71 | Balanced approach |
| A3 - Comprehensive | Full coverage + integration | 8 | 0.85 | 68 | Thorough but slow |

#### Expected Value Calculation

```
Assumptions:
- Phase 2 value if successful = 100
- Rework cost if inadequate = -30
- Time cost = -5 per day

Action A1 (Minimal):
  Success (50%): Phase 2 ready = 100 - 10 (time) = 90
  Failure (50%): Rework needed = 70 - 10 = 60
  EV(A1) = 0.5(90) + 0.5(60) = 45 + 30 = 75
  Adjusted for risk: 75 - 40 (tech debt) = 35

Action A2 (Standard):
  Success (75%): Phase 2 ready = 100 - 25 (time) = 75
  Failure (25%): Minor fixes = 85 - 25 = 60
  EV(A2) = 0.75(75) + 0.25(60) = 56.25 + 15 = 71.25

Action A3 (Comprehensive):
  Success (85%): Phase 2 ready = 100 - 40 (time) = 60
  Failure (15%): Minor fixes = 90 - 40 = 50
  EV(A3) = 0.85(60) + 0.15(50) = 51 + 7.5 = 58.5
  Long-term value: +10 (reusable templates) = 68.5
```

#### Decision Made
**Choice:** Action A2 (Standard coverage)  
**Reasoning:** Best expected value (71), balances speed with quality  
**Confidence Level:** 70%

#### Risk Mitigation
- Build incrementally: start with core patterns
- Test against 3 different Swift projects early
- If failures > 30%, pivot to A3
- Budget 2 extra days as buffer

#### Actual Outcome (Update Later)
**Date Resolved:** TBD  
**Result:** TBD  
**Actual Value:** TBD  
**Actual Effort:** TBD

#### Learning
**Prediction Error:** TBD  
**What We Learned:** TBD  
**Update Beliefs:** TBD  
**Template Improvements:** TBD

---

### Decision #002: LLM Model Selection Strategy
**Date:** 2025-01-XX  
**Decision Maker:** Core Team  
**Context:** Choosing primary LLM for code generation

#### State
- Current Phase: Phase 1
- Key Constraints: API costs, response quality variance
- Uncertainty Factors: New models emerging, performance on Swift unclear

#### Actions Considered

| Action | Description | Cost/1K tokens | Known Success | UCB Score | Notes |
|--------|-------------|----------------|---------------|-----------|-------|
| GPT-4 | Proven, expensive | $0.03 | 85% (n=50) | 1.12 | Baseline |
| Claude-3 | Good, cheaper | $0.015 | 82% (n=30) | 1.28 | Try more |
| Gemini | Unknown, cheap | $0.01 | 70% (n=5) | 1.95 | High uncertainty |

#### UCB Calculation

```
UCB(i) = μᵢ + c√(ln(n)/nᵢ)

Total generations so far: n = 85
Exploration constant: c = 2.0

GPT-4:
  μ = 0.85, n_i = 50
  UCB = 0.85 + 2√(ln(85)/50) = 0.85 + 2√(0.088) = 0.85 + 0.27 = 1.12

Claude-3:
  μ = 0.82, n_i = 30
  UCB = 0.82 + 2√(ln(85)/30) = 0.82 + 2√(0.147) = 0.82 + 0.46 = 1.28

Gemini:
  μ = 0.70, n_i = 5
  UCB = 0.70 + 2√(ln(85)/5) = 0.70 + 2√(0.883) = 0.70 + 1.25 = 1.95
```

#### Decision Made
**Choice:** Allocate next 10 generations to Gemini (highest UCB)  
**Reasoning:** High uncertainty bonus, potential for cost savings  
**Confidence Level:** 60% (exploratory phase)

#### Strategy
- Use Gemini for next 10 generations
- If success rate < 65%, abandon (not worth exploring)
- If success rate > 75%, increase allocation
- Re-calculate UCB after each batch
- Goal: Converge to best model within 100 total generations

#### Actual Outcome (Update Later)
**Date Resolved:** TBD  
**Gemini Results (n=10):** TBD  
**Updated UCB Scores:** TBD  
**New Allocation:** TBD

#### Learning
**Regret Calculation:** [Best possible - Actual chosen]  
**Exploration Efficiency:** [Worth the exploration cost?]  
**Updated Strategy:** TBD

---

## Decision Metrics Dashboard

### Overall Decision Quality

| Metric | Current | Target | Trend |
|--------|---------|--------|-------|
| Prediction Accuracy | TBD | 80% | - |
| Average EV Error | TBD | <15% | - |
| Decisions w/ Positive Outcomes | TBD | >70% | - |
| Regret (vs. optimal) | TBD | <10% | - |

### Exploration Metrics

| Model/Approach | Trials | Success Rate | UCB Score | Last Used |
|----------------|--------|--------------|-----------|-----------|
| GPT-4 | 50 | 85% | 1.12 | 2025-01-XX |
| Claude-3 | 30 | 82% | 1.28 | 2025-01-XX |
| Gemini | 5 | 70% | 1.95 | 2025-01-XX |

### Calibration Tracking

When we say "X% confident", are we right X% of the time?

| Confidence Bucket | Predictions | Actual Success | Calibration |
|-------------------|-------------|----------------|-------------|
| 90-100% | 0 | 0 | - |
| 80-90% | 0 | 0 | - |
| 70-80% | 0 | 0 | - |
| 60-70% | 0 | 0 | - |
| 50-60% | 0 | 0 | - |

**Goal:** Calibration score close to confidence level (well-calibrated)

---

## Lessons Learned

### Pattern #1: [Pattern Name]
**Observed:** [What we noticed]  
**Insight:** [What it means]  
**Application:** [How to use this going forward]

### Pattern #2: [Pattern Name]
**Observed:** [What we noticed]  
**Insight:** [What it means]  
**Application:** [How to use this going forward]

---

## Decision-Making Improvements

### Template Updates
- [Date]: [What we changed in decision template and why]

### Belief Updates
- [Date]: [How our priors changed based on evidence]

### Process Improvements
- [Date]: [Better ways to make decisions discovered]

---

## Archived Decisions

*(Move completed decisions here after learning is extracted)*

---

## Quick Reference: Decision Frameworks

### 1. Expected Value
```
EV = Σ P(outcome_i) × Value(outcome_i)
Choose action with highest EV
```

### 2. Upper Confidence Bound (Exploration)
```
UCB(i) = average_reward_i + c√(ln(total_trials)/trials_i)
Choose action with highest UCB
c = exploration constant (start with 2.0)
```

### 3. Bayesian Update
```
P(H|E) = P(E|H) × P(H) / P(E)
Update beliefs based on evidence
```

### 4. Multi-Attribute Utility
```
U = Σ wᵢ × uᵢ
wᵢ = weight of attribute i
uᵢ = utility of attribute i
```

### 5. Information Value
```
VOI = EV(with info) - EV(without info) - Cost(info)
If VOI > 0, gather more information before deciding
```

---

*Last Updated: 2025-01-XX*  
*Next Review: Weekly*