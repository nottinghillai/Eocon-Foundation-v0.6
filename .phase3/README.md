# Phase 3: Optimization Agent (Senior Engineer)

## Overview

Phase 3 of the Foundation Framework acts as a **Senior Engineer** that reviews all questions from Phase 2 and optimizes plans and tests using historical patterns, code examples, and industry best practices.

## Purpose

The Optimization Agent serves as the "senior engineer" in the pipeline, responsible for:

1. **Reviewing Questions**: Analyzing all ambiguities identified by Phase 2
2. **Searching Historical Patterns**: Looking through Guides/, Design/, and Docs/ for existing solutions
3. **Applying Self-Resolution Algorithm**: Making intelligent decisions about how to resolve ambiguities
4. **Optimizing Plans**: Enhancing all plan files with specific implementation details
5. **Enhancing Tests**: Improving test specifications with specific test cases and coverage targets
6. **Documenting Decisions**: Recording all optimization decisions with clear rationale

## Self-Resolution Algorithm

The Optimization Agent follows a three-step decision process:

```
1. IF historical pattern found → Apply it
2. IF feature not required → Skip (prevent scope creep)
3. IF required but no pattern → Apply industry-standard best practice
```

All decisions are documented with:
- **Decision**: What was decided
- **Rationale**: Why this decision was made
- **Implementation**: Specific guidance for implementation

## Usage

### Basic Usage

```bash
bash .phase3/phase3.sh
```

This will:
- Read Questions.md from Phase 2
- Search Guides/, Design/, and Docs/ for patterns
- Optimize all plans in Plans/ directory
- Enhance all test specifications
- Update decision logs with rationale

### Advanced Usage

```bash
# Specify custom directories
bash .phase3/phase3.sh \
  --plans-dir phase1_testing/Plans \
  --questions Questions.md \
  --guides-dir Guides \
  --design-dir Design \
  --docs-dir Docs

# Use specific Cursor model
bash .phase3/phase3.sh -m claude-3-opus

# Adjust retry behavior
bash .phase3/phase3.sh --max-retries 3
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--plans-dir <dir>` | Plans directory to optimize | `Plans` |
| `--questions <file>` | Questions.md from Phase 2 | `Questions.md` |
| `--guides-dir <dir>` | Historical patterns directory | `Guides` |
| `--design-dir <dir>` | Code patterns directory | `Design` |
| `--docs-dir <dir>` | External docs directory | `Docs` |
| `-m, --model <model>` | Cursor model to use | Auto-detect |
| `--max-retries <num>` | Max retries per optimization | `2` |
| `-h, --help` | Show help message | - |

## Prerequisites

1. **Phase 1 Complete**: Plans must be generated
2. **Phase 2 Complete** (recommended): Questions.md should exist
3. **Cursor CLI** (optional): For AI-powered optimization
   - Install: Follow Cursor CLI documentation
   - Authenticate: `cursor-agent login`
4. **Resource Directories**: Guides/, Design/, Docs/ (created automatically if missing)

## Input

### Required
- `Plans/` directory with plan folders (plan1/, plan2/, etc.)
- Each plan folder should contain:
  - `planX.md` - Main plan file
  - `waves/` - Wave decompositions
  - `decision_log.md` - Decision log from Phase 1

### Optional
- `Questions.md` - Questions from Phase 2
- `Guides/` - Historical implementation patterns
- `Design/` - Reusable code patterns
- `Docs/` - External documentation

## Output

### Optimized Files
- **Plans**: `planX.md` files enhanced with:
  - Specific implementation details
  - Clear technical approaches
  - Explicit file paths and dependencies
  - Resolution of ambiguities

- **Tests**: `testX.md` files enhanced with:
  - Specific test cases
  - Edge case scenarios
  - Expected results
  - Coverage targets (>80%)

- **Waves**: `subplanX.md` and `subtestX.md` optimized with:
  - Detailed implementation guidance
  - Enhanced test specifications
  - Clear acceptance criteria

### Decision Logs
Updated `decision_log.md` in each plan directory with:
- Date and timestamp
- Optimization method used
- All decisions made
- Rationale for each decision
- Resources consulted

### Backup Files
Original files preserved with `.backup` extension:
- `planX.md.backup`
- `testX.md.backup`
- `subplanX.md.backup`
- `subtestX.md.backup`

## How It Works

### Step 1: Question Review
Reads Questions.md and extracts questions relevant to each plan.

### Step 2: Historical Pattern Search
For each question/ambiguity:
1. Extracts key terms
2. Searches Guides/ for implementation patterns
3. Searches Design/ for code examples
4. Searches Docs/ for documentation
5. Builds context from found resources

### Step 3: Self-Resolution
Applies the resolution algorithm:
- **Pattern Found**: Applies historical approach
- **Not Required**: Skips feature (prevents scope creep)
- **Required but No Pattern**: Applies industry best practice

### Step 4: Optimization
- Enhances plans with specific details
- Adds technical implementation guidance
- Clarifies ambiguous requirements
- Ensures completeness

### Step 5: Test Enhancement
- Adds specific test cases
- Includes edge cases and error scenarios
- Specifies test data and expected results
- Sets coverage targets (>80%)

### Step 6: Wave Optimization
For each wave:
- Optimizes sub-plans with detailed guidance
- Enhances sub-tests with specific cases
- Ensures one-shot execution readiness

### Step 7: Documentation
Updates decision logs with:
- All decisions made
- Rationale for decisions
- Resources consulted
- Implementation guidance

## AI-Powered vs. Basic Mode

### AI-Powered Mode (Recommended)
**Requirements**: Cursor CLI installed and authenticated

**Features**:
- Intelligent question resolution
- Context-aware optimization
- Natural language enhancements
- Pattern-based decision making
- Detailed rationale generation

**Advantages**:
- Higher quality optimizations
- Better context understanding
- More specific guidance
- Comprehensive enhancements

### Basic Mode (Fallback)
**When**: Cursor CLI not available or not authenticated

**Features**:
- Heuristic-based analysis
- Template-based enhancements
- Structural improvements
- Basic optimization notes

**Limitations**:
- Less intelligent decisions
- Generic guidance
- Limited pattern recognition
- Basic enhancements

## Resource Directories

### Guides/
**Purpose**: Historical implementation patterns and lessons learned

**Contents**:
- Implementation guides from previous projects
- Decision rationale documentation
- Lessons learned documents
- Best practices documentation

**Usage**: Optimization Agent searches these for proven approaches

### Design/
**Purpose**: Reusable code patterns and examples

**Contents**:
- Sample implementations
- Code templates
- Design patterns
- Component examples

**Usage**: Optimization Agent references these for implementation guidance

### Docs/
**Purpose**: External documentation and API references

**Contents**:
- Library documentation
- API references
- Framework guides
- Technical specifications

**Usage**: Optimization Agent consults these for technical details

## Examples

### Example 1: Basic Optimization
```bash
# Run with defaults
bash .phase3/phase3.sh
```

**Output**:
```
[PHASE 3] ==========================================
[PHASE 3]   Foundation Framework - Phase 3
[PHASE 3]   Optimization Agent (Senior Engineer)
[PHASE 3] ==========================================

[INFO] Plans Directory: /Users/you/project/Plans
[INFO] Questions File: /Users/you/project/Questions.md
[SUCCESS] Loaded questions from: Questions.md
[SUCCESS] Found 1 plan(s) to optimize

[PHASE 3] ==========================================
[PHASE 3] Processing plan1
[PHASE 3] ==========================================

[PHASE 3] Optimizing plan1...
[SUCCESS] Optimized: Plans/plan1/plan1.md

[PHASE 3] Enhancing tests for plan1...
[SUCCESS] Enhanced: Plans/plan1/test1.md

[INFO] Found 3 waves to optimize
[INFO] Optimizing Wave 1...
[SUCCESS] Optimized: subplan1.md
[SUCCESS] Enhanced: subtest1.md

[SUCCESS] Completed optimization of plan1

[SUCCESS] ==========================================
[SUCCESS] Phase 3 Complete!
[SUCCESS] ==========================================
```

### Example 2: Custom Configuration
```bash
# Use specific model and directories
bash .phase3/phase3.sh \
  --plans-dir phase1_testing/Plans \
  --questions phase1_testing/Questions.md \
  -m claude-3-opus \
  --max-retries 3
```

### Example 3: Check What Will Be Optimized
```bash
# Preview mode (dry run not implemented, but you can check)
ls Plans/plan*/plan*.md
ls Plans/plan*/test*.md
ls Plans/plan*/waves/wave*/subplan*.md
```

## Troubleshooting

### Issue: "Plans directory not found"
**Solution**: Run Phase 1 first:
```bash
bash .phase1/phase1.sh plan.md
```

### Issue: "Questions.md not found"
**Solution**: Run Phase 2 first (or continue without it):
```bash
bash .phase2/phase2.sh
```
Or proceed anyway - Phase 3 can optimize without questions.

### Issue: "Cursor CLI not authenticated"
**Solution**: Authenticate Cursor CLI:
```bash
cursor-agent login
```
Or continue with basic mode (still functional).

### Issue: Optimization produces no changes
**Possible causes**:
1. Plans are already well-specified
2. No Questions.md to address
3. AI model timeout (try increasing --max-retries)
4. Resource directories are empty

**Solutions**:
- Review `.backup` files to see originals
- Check decision logs for what was attempted
- Try with different Cursor model
- Add content to Guides/, Design/, Docs/

### Issue: Script hangs or times out
**Solution**: 
- Reduce plan size (break into smaller waves)
- Increase timeout in script (edit phase3.sh)
- Use faster Cursor model
- Check network connection

## Integration with Other Phases

### Input from Phase 2
- Questions.md with identified ambiguities
- Decision logs with initial findings

### Output to Phase 4
- Optimized plans ready for dependency analysis
- Enhanced tests ready for execution
- Complete decision logs with rationale

## Decision Log Format

Each decision log will contain:

```markdown
## Phase 3: Optimization Agent Decisions
**Date**: 2024-10-31 12:00:00
**Agent**: Senior Engineer (Optimization Agent)
**Method**: AI-powered with historical pattern search

### Optimization Decisions

**plan1 Main Plan**: Optimized with enhanced details and clarity
**plan1 Tests**: Enhanced with specific test cases and coverage targets
**Wave 1**: Optimized sub-plans and enhanced tests
**Wave 2**: Optimized sub-plans and enhanced tests

### Self-Resolution Algorithm Applied
- ✓ Searched Guides/ for historical patterns
- ✓ Searched Design/ for code patterns
- ✓ Searched Docs/ for documentation
- ✓ Applied industry best practices where needed
- ✓ Prevented scope creep by skipping non-essential features

---
*Updated by Foundation Framework Phase 3*
```

## Best Practices

1. **Run Phase 2 First**: Questions.md provides important context
2. **Populate Resource Directories**: Add Guides, Design, and Docs for better optimization
3. **Review Backups**: Check `.backup` files to see what changed
4. **Read Decision Logs**: Understand rationale for all decisions
5. **Use AI Mode**: Authenticate Cursor CLI for best results
6. **Iterate if Needed**: Can run Phase 3 multiple times with different configurations

## Performance

- **Typical Runtime**: 5-15 minutes per plan (with AI)
- **Basic Mode**: 1-3 minutes per plan
- **Large Plans**: Up to 30 minutes
- **Resource Search**: Adds 2-5 minutes per plan

## Next Steps

After Phase 3 completes:

1. **Review Optimizations**: Check updated plan and test files
2. **Read Decision Logs**: Understand all decisions made
3. **Validate Changes**: Ensure optimizations align with requirements
4. **Proceed to Phase 4**: Run Stages Agent for execution planning
   ```bash
   bash .phase4/phase4.sh
   ```

## Constitutional Reference

This phase implements **Article II, Section 3, Subsubsection: Phase 3** of the Foundation Constitution:

> **Phase 3: Optimization Agent (Senior Engineer)**
> 
> The Optimization Agent reviews questions from Phase 2 and optimizes all plans and tests using historical learning, applying the self-resolution algorithm to autonomously resolve ambiguities while documenting all decisions with clear rationale.

## Support

For issues or questions:
1. Check decision logs for hints
2. Review `.backup` files for comparison
3. Try re-running with different options
4. Consult Foundation Constitution
5. Check Cursor CLI status: `cursor-agent status`

---

*Part of the Foundation Framework - Constitutional Programming System*
*Version: 1.0*
*Last Updated: October 31, 2024*




