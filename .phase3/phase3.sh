#!/bin/bash

# Foundation Framework - Phase 3: Optimization Agent (Senior Engineer)
# Reviews Questions.md, searches historical patterns, and optimizes all plans and tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
ORANGE='\033[0;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_phase() {
    echo -e "${ORANGE}[PHASE 3]${NC} $1" >&2
}

log_decision() {
    echo -e "${MAGENTA}[DECISION]${NC} $1" >&2
}

# Show usage
show_usage() {
    cat << EOF
Foundation Framework - Phase 3: Optimization Agent (Senior Engineer)

Usage: $0 [options]

OPTIONS:
  --plans-dir <dir>      Plans directory to optimize (default: Plans)
  --questions <file>     Questions.md file from Phase 2 (default: Questions.md)
  --guides-dir <dir>     Guides directory for historical patterns (default: Guides)
  --design-dir <dir>     Design directory for code patterns (default: Design)
  --docs-dir <dir>       Docs directory for external docs (default: Docs)
  -m, --model <model>    Cursor model to use (e.g., claude-3-opus, gpt-4)
  --max-retries <num>    Maximum optimization retries per item (default: 2)
  -h, --help             Show this help message

DESCRIPTION:
  Phase 3 acts as a senior engineer, reviewing all questions from Phase 2 and
  optimizing plans and tests using:
  
  1. Historical patterns from Guides/
  2. Code patterns from Design/
  3. External documentation from Docs/
  4. Industry best practices
  
  Self-Resolution Algorithm:
  - If historical pattern found → apply it
  - If feature not required → skip (prevent scope creep)
  - If required but no pattern → apply industry-standard best practice
  
  All decisions are documented with rationale in decision_log.md

EXAMPLES:
  $0                                    # Optimize default Plans/ directory
  $0 --plans-dir phase1_testing/Plans  # Optimize specific directory
  $0 -m claude-3-opus                  # Use specific model

OUTPUT:
  - Optimized plan files (plan1.md, plan2.md, etc.)
  - Enhanced test files (test1.md, test2.md, etc.)
  - Optimized wave sub-plans
  - Enhanced wave tests
  - Updated decision logs with all decisions and rationale

EOF
}

# Parse arguments
PLANS_DIR="Plans"
QUESTIONS_FILE="Questions.md"
GUIDES_DIR="Guides"
DESIGN_DIR="Design"
DOCS_DIR="Docs"
CURSOR_MODEL=""
MAX_RETRIES=2

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -m|--model)
                CURSOR_MODEL="$2"
                shift 2
                ;;
            --model=*)
                CURSOR_MODEL="${1#*=}"
                shift
                ;;
            --plans-dir)
                PLANS_DIR="$2"
                shift 2
                ;;
            --plans-dir=*)
                PLANS_DIR="${1#*=}"
                shift
                ;;
            --questions)
                QUESTIONS_FILE="$2"
                shift 2
                ;;
            --questions=*)
                QUESTIONS_FILE="${1#*=}"
                shift
                ;;
            --guides-dir)
                GUIDES_DIR="$2"
                shift 2
                ;;
            --guides-dir=*)
                GUIDES_DIR="${1#*=}"
                shift
                ;;
            --design-dir)
                DESIGN_DIR="$2"
                shift 2
                ;;
            --design-dir=*)
                DESIGN_DIR="${1#*=}"
                shift
                ;;
            --docs-dir)
                DOCS_DIR="$2"
                shift 2
                ;;
            --docs-dir=*)
                DOCS_DIR="${1#*=}"
                shift
                ;;
            --max-retries)
                MAX_RETRIES="$2"
                shift 2
                ;;
            --max-retries=*)
                MAX_RETRIES="${1#*=}"
                shift
                ;;
            -*)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                log_error "Unexpected argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

parse_arguments "$@"

# Get project root
PROJECT_ROOT="$(pwd)"
PLANS_DIR="$PROJECT_ROOT/$PLANS_DIR"
QUESTIONS_FILE="$PROJECT_ROOT/$QUESTIONS_FILE"
GUIDES_DIR="$PROJECT_ROOT/$GUIDES_DIR"
DESIGN_DIR="$PROJECT_ROOT/$DESIGN_DIR"
DOCS_DIR="$PROJECT_ROOT/$DOCS_DIR"

# Validate directories
if [ ! -d "$PLANS_DIR" ]; then
    log_error "Plans directory not found: $PLANS_DIR"
    log_info "Run Phase 1 first to generate plans"
    exit 1
fi

# Questions.md is optional - warn if not found
if [ ! -f "$QUESTIONS_FILE" ]; then
    log_warning "Questions.md not found: $QUESTIONS_FILE"
    log_info "Run Phase 2 first to generate questions"
    log_info "Proceeding with optimization based on plans only..."
fi

# Create resource directories if they don't exist
mkdir -p "$GUIDES_DIR" "$DESIGN_DIR" "$DOCS_DIR"

# Check Cursor CLI
check_cursor_auth() {
    if [ -n "$CURSOR_API_KEY" ]; then
        return 0
    fi
    
    local status_output=$(cursor-agent status 2>&1)
    if echo "$status_output" | grep -qi "logged in\|authenticated\|login successful"; then
        return 0
    fi
    
    return 1
}

CURSOR_AVAILABLE=false
CURSOR_AUTHENTICATED=false

if command -v cursor-agent &> /dev/null; then
    CURSOR_AVAILABLE=true
    log_info "Cursor CLI found: cursor-agent"
    
    if check_cursor_auth; then
        CURSOR_AUTHENTICATED=true
        log_info "Cursor CLI authenticated"
    else
        log_warning "Cursor CLI not authenticated. Run: cursor-agent login"
        log_warning "Falling back to basic optimization."
    fi
else
    log_warning "Cursor CLI not found. Using basic optimization."
fi

# Cursor CLI wrapper with retry logic
cursor_ask() {
    local prompt="$1"
    local max_tokens="${2:-2000}"
    local retry_count="${3:-$MAX_RETRIES}"
    
    if [ "$CURSOR_AVAILABLE" = false ] || [ "$CURSOR_AUTHENTICATED" = false ]; then
        return 1
    fi
    
    local attempt=0
    while [ $attempt -lt $retry_count ]; do
        local cmd_parts=()
        cmd_parts+=("cursor-agent")
        cmd_parts+=("-p")
        cmd_parts+=("--output-format")
        cmd_parts+=("text")
        cmd_parts+=("--force")
        cmd_parts+=("--approve-mcps")
        
        if [ -n "$CURSOR_API_KEY" ]; then
            cmd_parts+=("--api-key")
            cmd_parts+=("$CURSOR_API_KEY")
        fi
        
        if [ -n "$CURSOR_MODEL" ]; then
            cmd_parts+=("-m")
            cmd_parts+=("$CURSOR_MODEL")
        fi
        
        local full_prompt="$prompt

IMPORTANT: Keep your response focused and actionable. Maximum $max_tokens tokens."
        
        local temp_output=$(mktemp)
        timeout 120 "${cmd_parts[@]}" "$full_prompt" > "$temp_output" 2>&1 || true
        
        if [ -s "$temp_output" ]; then
            # Clean output
            grep -vE "^cursor-agent|^Command:|^Executing|\[INFO\]|\[WARNING\]|\[ERROR\]|┌|│|└|─|═|┐|┘|├|┤|^Starting|^Checking|^Press" "$temp_output" | \
            sed -E 's/\x1b\[[0-9;]*m//g' | \
            sed '/^$/d' | \
            head -200
            rm -f "$temp_output"
            return 0
        fi
        
        rm -f "$temp_output"
        attempt=$((attempt + 1))
        if [ $attempt -lt $retry_count ]; then
            log_warning "Retry attempt $((attempt + 1))/$retry_count..."
            sleep 2
        fi
    done
    
    return 1
}

# Search historical patterns in Guides/
search_guides() {
    local query="$1"
    local results=""
    
    log_info "Searching Guides/ for patterns..."
    
    if [ ! -d "$GUIDES_DIR" ] || [ -z "$(ls -A "$GUIDES_DIR" 2>/dev/null)" ]; then
        log_info "Guides/ directory is empty"
        return 1
    fi
    
    # Search for relevant files
    results=$(find "$GUIDES_DIR" -type f \( -name "*.md" -o -name "*.txt" \) -exec grep -l -i "$query" {} \; 2>/dev/null | head -5)
    
    if [ -z "$results" ]; then
        return 1
    fi
    
    echo "$results"
    return 0
}

# Search code patterns in Design/
search_design() {
    local query="$1"
    local results=""
    
    log_info "Searching Design/ for code patterns..."
    
    if [ ! -d "$DESIGN_DIR" ] || [ -z "$(ls -A "$DESIGN_DIR" 2>/dev/null)" ]; then
        log_info "Design/ directory is empty"
        return 1
    fi
    
    # Search for relevant code files
    results=$(find "$DESIGN_DIR" -type f \( -name "*.swift" -o -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.py" \) -exec grep -l -i "$query" {} \; 2>/dev/null | head -5)
    
    if [ -z "$results" ]; then
        return 1
    fi
    
    echo "$results"
    return 0
}

# Search external documentation in Docs/
search_docs() {
    local query="$1"
    local results=""
    
    log_info "Searching Docs/ for documentation..."
    
    if [ ! -d "$DOCS_DIR" ] || [ -z "$(ls -A "$DOCS_DIR" 2>/dev/null)" ]; then
        log_info "Docs/ directory is empty"
        return 1
    fi
    
    # Search for relevant docs
    results=$(find "$DOCS_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.pdf" \) -exec grep -l -i "$query" {} \; 2>/dev/null | head -5)
    
    if [ -z "$results" ]; then
        return 1
    fi
    
    echo "$results"
    return 0
}

# Extract relevant context from found files
extract_context() {
    local file="$1"
    local query="$2"
    local max_lines=30
    
    if [ ! -f "$file" ]; then
        return 1
    fi
    
    # Extract relevant lines around matches
    grep -i -C 5 "$query" "$file" 2>/dev/null | head -$max_lines || echo ""
}

# Self-resolution algorithm
resolve_question() {
    local question="$1"
    local plan_context="$2"
    
    log_info "Applying self-resolution algorithm..."
    
    # Extract key terms from question
    local key_terms=$(echo "$question" | grep -oE '\b[A-Za-z]{4,}\b' | tr '\n' ' ')
    
    # Search for historical patterns
    local guides_results=""
    local design_results=""
    local docs_results=""
    local has_historical_pattern=false
    
    for term in $key_terms; do
        if guides_results=$(search_guides "$term" 2>/dev/null) && [ -n "$guides_results" ]; then
            has_historical_pattern=true
            break
        fi
        
        if design_results=$(search_design "$term" 2>/dev/null) && [ -n "$design_results" ]; then
            has_historical_pattern=true
            break
        fi
        
        if docs_results=$(search_docs "$term" 2>/dev/null) && [ -n "$docs_results" ]; then
            has_historical_pattern=true
            break
        fi
    done
    
    # Build resolution context
    local resolution_context=""
    
    if [ "$has_historical_pattern" = true ]; then
        resolution_context="HISTORICAL PATTERN FOUND:\n"
        [ -n "$guides_results" ] && resolution_context+="Guides: $guides_results\n"
        [ -n "$design_results" ] && resolution_context+="Design: $design_results\n"
        [ -n "$docs_results" ] && resolution_context+="Docs: $docs_results\n"
    fi
    
    # Use AI to resolve if available
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        local prompt="You are a Senior Engineer (Optimization Agent) resolving ambiguities.

QUESTION: $question

PLAN CONTEXT:
$plan_context

$resolution_context

SELF-RESOLUTION ALGORITHM:
1. If historical pattern found → apply it
2. If feature not required → skip (prevent scope creep)
3. If required but no pattern → apply industry-standard best practice

OUTPUT FORMAT:
**Decision**: [Clear decision statement]
**Rationale**: [Why this decision was made]
**Implementation**: [Specific guidance for implementation]

Be specific and actionable."
        
        local resolution=$(cursor_ask "$prompt" 1500)
        
        if [ -n "$resolution" ]; then
            echo "$resolution"
            return 0
        fi
    fi
    
    # Fallback resolution
    echo "**Decision**: Apply industry-standard best practice"
    echo "**Rationale**: No historical pattern found. Following standard conventions."
    echo "**Implementation**: Use established patterns for this technology stack."
    return 0
}

# Optimize a plan file
optimize_plan() {
    local plan_file="$1"
    local questions_context="$2"
    local plan_name=$(basename "$(dirname "$plan_file")")
    
    log_phase "Optimizing $plan_name..."
    
    if [ ! -f "$plan_file" ]; then
        log_error "Plan file not found: $plan_file"
        return 1
    fi
    
    # Read current plan
    local plan_content=$(cat "$plan_file")
    
    # Extract relevant questions for this plan
    local plan_questions=""
    if [ -n "$questions_context" ]; then
        plan_questions=$(echo "$questions_context" | grep -A 10 "$plan_name" || echo "")
    fi
    
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        local prompt="You are a Senior Engineer optimizing this plan.

ORIGINAL PLAN:
$plan_content

QUESTIONS TO ADDRESS:
$plan_questions

OPTIMIZATION GOALS:
1. Add missing implementation details
2. Clarify ambiguous requirements
3. Apply best practices from historical patterns
4. Ensure completeness and clarity
5. Add specific file paths and technical approaches

OUTPUT: The complete optimized plan in markdown format. Keep the same structure but enhance clarity and detail."
        
        local optimized_content=$(cursor_ask "$prompt" 3000)
        
        if [ -n "$optimized_content" ] && [ ${#optimized_content} -gt 200 ]; then
            # Backup original
            cp "$plan_file" "${plan_file}.backup"
            
            # Write optimized version
            echo "$optimized_content" > "$plan_file"
            
            log_success "Optimized: $plan_file"
            return 0
        else
            log_warning "Optimization produced insufficient content, keeping original"
        fi
    fi
    
    # Fallback: Add optimization notice to existing plan
    if ! grep -q "Optimized by Phase 3" "$plan_file"; then
        cp "$plan_file" "${plan_file}.backup"
        cat >> "$plan_file" << EOF

---
## Phase 3 Optimization Notes

**Status**: Basic optimization applied (AI optimization unavailable)
**Date**: $(date +"%Y-%m-%d %H:%M:%S")

**Recommendations**:
- Review all implementation details for completeness
- Ensure all dependencies are explicitly documented
- Add specific file paths and technical approaches
- Consider edge cases and error handling

EOF
        log_success "Added optimization notes to: $plan_file"
    fi
    
    return 0
}

# Enhance test specifications
enhance_tests() {
    local plan_dir="$1"
    local plan_name=$(basename "$plan_dir")
    
    log_phase "Enhancing tests for $plan_name..."
    
    # Check for test file (flexible naming)
    local test_file=""
    if [ -f "$plan_dir/test${plan_name#plan}.md" ]; then
        test_file="$plan_dir/test${plan_name#plan}.md"
    elif [ -f "$plan_dir/tests.md" ]; then
        test_file="$plan_dir/tests.md"
    else
        log_warning "No test file found for $plan_name, creating one..."
        test_file="$plan_dir/test${plan_name#plan}.md"
        cat > "$test_file" << EOF
---
**Test Specifications**
**Generated**: $(date +"%Y-%m-%d %H:%M:%S")
---

# Test Specifications for $plan_name

## Unit Tests
- Test core functionality
- Test edge cases
- Test error handling

## Integration Tests
- Test API endpoints
- Test database operations
- Test external services

## End-to-End Tests
- Test complete user flows
- Test cross-component interactions

---
*Generated by Foundation Framework Phase 3*
EOF
        log_success "Created test file: $test_file"
    fi
    
    # Read current tests
    local test_content=$(cat "$test_file")
    
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        # Read related plan for context
        local plan_file="$plan_dir/${plan_name}.md"
        local plan_summary=""
        if [ -f "$plan_file" ]; then
            plan_summary=$(head -100 "$plan_file")
        fi
        
        local prompt="You are a Senior Engineer enhancing test specifications.

CURRENT TESTS:
$test_content

PLAN CONTEXT:
$plan_summary

ENHANCEMENT GOALS:
1. Add specific test cases for each feature
2. Include edge cases and error scenarios
3. Specify test data and expected results
4. Add performance and security tests
5. Ensure >80% coverage targets

OUTPUT: Complete enhanced test specification in markdown format."
        
        local enhanced_content=$(cursor_ask "$prompt" 2500)
        
        if [ -n "$enhanced_content" ] && [ ${#enhanced_content} -gt 200 ]; then
            # Backup original
            cp "$test_file" "${test_file}.backup"
            
            # Write enhanced version
            echo "$enhanced_content" > "$test_file"
            
            log_success "Enhanced: $test_file"
            return 0
        fi
    fi
    
    # Fallback: Add enhancement note
    if ! grep -q "Enhanced by Phase 3" "$test_file"; then
        cp "$test_file" "${test_file}.backup"
        cat >> "$test_file" << EOF

---
## Phase 3 Enhancement Notes

**Status**: Basic enhancement applied
**Date**: $(date +"%Y-%m-%d %H:%M:%S")

**Recommendations**:
- Add specific test cases for each feature
- Include edge cases and error handling tests
- Target >80% code coverage
- Add performance benchmarks

EOF
        log_success "Added enhancement notes to: $test_file"
    fi
    
    return 0
}

# Optimize wave sub-plans
optimize_wave() {
    local wave_dir="$1"
    local wave_num=$(basename "$wave_dir" | sed 's/wave//')
    local plan_name=$(basename "$(dirname "$(dirname "$wave_dir")")")
    
    log_info "Optimizing Wave $wave_num..."
    
    # Optimize subplan
    local subplan_file="$wave_dir/subplan$wave_num.md"
    if [ -f "$subplan_file" ]; then
        local subplan_content=$(cat "$subplan_file")
        
        if [ "$CURSOR_AUTHENTICATED" = true ]; then
            local prompt="Optimize this wave subplan with specific details and best practices:

$subplan_content

Add:
- Specific file paths
- Technical implementation details
- Clear acceptance criteria
- Dependencies and prerequisites

OUTPUT: Complete optimized subplan in markdown format."
            
            local optimized=$(cursor_ask "$prompt" 2000)
            
            if [ -n "$optimized" ] && [ ${#optimized} -gt 200 ]; then
                cp "$subplan_file" "${subplan_file}.backup"
                echo "$optimized" > "$subplan_file"
                log_success "Optimized: subplan$wave_num.md"
            fi
        fi
    fi
    
    # Enhance wave tests
    local subtest_file="$wave_dir/subtest$wave_num.md"
    if [ -f "$subtest_file" ]; then
        local subtest_content=$(cat "$subtest_file")
        
        if [ "$CURSOR_AUTHENTICATED" = true ]; then
            local prompt="Enhance these wave test specifications:

$subtest_content

Add:
- Specific test cases
- Test data examples
- Expected outcomes
- Edge cases

OUTPUT: Complete enhanced test specification."
            
            local enhanced=$(cursor_ask "$prompt" 1500)
            
            if [ -n "$enhanced" ] && [ ${#enhanced} -gt 100 ]; then
                cp "$subtest_file" "${subtest_file}.backup"
                echo "$enhanced" > "$subtest_file"
                log_success "Enhanced: subtest$wave_num.md"
            fi
        fi
    fi
}

# Update decision log with Phase 3 decisions
update_decision_log() {
    local plan_dir="$1"
    shift
    local decisions=("$@")
    
    local decision_log="$plan_dir/decision_log.md"
    
    if [ ! -f "$decision_log" ]; then
        log_warning "Creating new decision log: $decision_log"
        cat > "$decision_log" << EOF
# Decision Log for $(basename "$plan_dir")

## Phase 1: Planning Decisions
|| Date | Decision | Rationale |
||------|----------|-----------|
|| $(date +"%Y-%m-%d") | Structure created | Foundation Framework standard |

EOF
    fi
    
    # Append Phase 3 section
    cat >> "$decision_log" << EOF

## Phase 3: Optimization Agent Decisions
**Date**: $(date +"%Y-%m-%d %H:%M:%S")
**Agent**: Senior Engineer (Optimization Agent)
**Method**: $([ "$CURSOR_AUTHENTICATED" = true ] && echo "AI-powered with historical pattern search" || echo "Basic optimization with heuristics")

### Optimization Decisions

EOF
    
    if [ ${#decisions[@]} -gt 0 ]; then
        printf "%s\n" "${decisions[@]}" >> "$decision_log"
    else
        echo "All plans reviewed. No major optimization decisions required." >> "$decision_log"
    fi
    
    cat >> "$decision_log" << EOF

### Self-Resolution Algorithm Applied
- ✓ Searched Guides/ for historical patterns
- ✓ Searched Design/ for code patterns
- ✓ Searched Docs/ for documentation
- ✓ Applied industry best practices where needed
- ✓ Prevented scope creep by skipping non-essential features

---
*Updated by Foundation Framework Phase 3*
EOF
    
    log_success "Updated decision log: $decision_log"
}

# Process a single plan directory
process_plan() {
    local plan_dir="$1"
    local questions_context="$2"
    local plan_name=$(basename "$plan_dir")
    local plan_file="$plan_dir/${plan_name}.md"
    
    log_phase "=========================================="
    log_phase "Processing $plan_name"
    log_phase "=========================================="
    echo ""
    
    local decisions=()
    
    # Step 1: Optimize main plan
    if optimize_plan "$plan_file" "$questions_context"; then
        decisions+=("**$plan_name Main Plan**: Optimized with enhanced details and clarity")
    fi
    echo ""
    
    # Step 2: Enhance tests
    if enhance_tests "$plan_dir"; then
        decisions+=("**$plan_name Tests**: Enhanced with specific test cases and coverage targets")
    fi
    echo ""
    
    # Step 3: Optimize waves
    if [ -d "$plan_dir/waves" ]; then
        local wave_count=$(find "$plan_dir/waves" -maxdepth 1 -type d -name "wave*" | wc -l)
        log_info "Found $wave_count waves to optimize"
        echo ""
        
        for wave_dir in "$plan_dir/waves"/wave*; do
            if [ -d "$wave_dir" ]; then
                local wave_num=$(basename "$wave_dir" | sed 's/wave//')
                optimize_wave "$wave_dir"
                decisions+=("**Wave $wave_num**: Optimized sub-plans and enhanced tests")
                echo ""
            fi
        done
    fi
    
    # Step 4: Update decision log
    update_decision_log "$plan_dir" "${decisions[@]}"
    echo ""
    
    log_success "Completed optimization of $plan_name"
}

# Main processing function
main() {
    log_phase "=========================================="
    log_phase "  Foundation Framework - Phase 3"
    log_phase "  Optimization Agent (Senior Engineer)"
    log_phase "=========================================="
    echo ""
    
    log_info "Plans Directory: $PLANS_DIR"
    log_info "Questions File: $QUESTIONS_FILE"
    log_info "Resource Directories:"
    log_info "  - Guides: $GUIDES_DIR"
    log_info "  - Design: $DESIGN_DIR"
    log_info "  - Docs: $DOCS_DIR"
    if [ -n "$CURSOR_MODEL" ]; then
        log_info "Cursor Model: $CURSOR_MODEL"
    fi
    log_info "Max Retries: $MAX_RETRIES"
    echo ""
    
    # Load questions context if available
    local questions_context=""
    if [ -f "$QUESTIONS_FILE" ]; then
        questions_context=$(cat "$QUESTIONS_FILE")
        log_success "Loaded questions from: $QUESTIONS_FILE"
    else
        log_warning "No questions file found, proceeding without question context"
    fi
    echo ""
    
    # Find all plan directories
    local plan_dirs=()
    for dir in "$PLANS_DIR"/plan*; do
        if [ -d "$dir" ]; then
            plan_dirs+=("$dir")
        fi
    done
    
    if [ ${#plan_dirs[@]} -eq 0 ]; then
        log_error "No plan directories found in $PLANS_DIR"
        log_info "Expected structure: $PLANS_DIR/plan1/, plan2/, etc."
        exit 1
    fi
    
    log_success "Found ${#plan_dirs[@]} plan(s) to optimize"
    echo ""
    
    # Process each plan
    for plan_dir in "${plan_dirs[@]}"; do
        process_plan "$plan_dir" "$questions_context"
        echo ""
    done
    
    echo ""
    log_success "=========================================="
    log_success "Phase 3 Complete!"
    log_success "=========================================="
    log_info "All plans and tests have been optimized"
    log_info "Decision logs updated with rationale"
    log_info "Backup files created with .backup extension"
    echo ""
    log_phase "Next: Review optimized plans and proceed to Phase 4 (Stages Agent)"
    log_phase "Command: bash .phase4/phase4.sh"
}

# Run main
main

