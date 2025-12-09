#!/bin/bash

# Foundation Framework - Phase 1: Wave Decomposition
# Multi-step approach with focused, digestible prompts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

log_mode() {
    echo -e "${CYAN}[MODE]${NC} $1" >&2
}

# Show usage
show_usage() {
    cat << EOF
Foundation Framework - Phase 1: Wave Decomposition

Usage: $0 <plan.md> [options]

OPTIONS:
  --plans-dir <dir>      Output directory for plans (default: Plans)
  -m, --model <model>    Cursor model to use (e.g., claude-3-opus, gpt-4)
  -h, --help             Show this help message

EXAMPLES:
  $0 plan.md                          # Process single plan
  $0 plan.md -m claude-3-opus        # Use specific model

EOF
}

# Parse arguments
INPUT_FILE=""
PLANS_DIR="Plans"
CURSOR_MODEL=""

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
            -*)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                INPUT_FILE="$1"
                shift
                ;;
        esac
    done
}

parse_arguments "$@"

# Validate input
if [ -z "$INPUT_FILE" ] || [ ! -f "$INPUT_FILE" ]; then
    log_error "Plan file not found: $INPUT_FILE"
    show_usage
    exit 1
fi

# Get project root
PROJECT_ROOT="$(pwd)"
PLANS_DIR="$PROJECT_ROOT/$PLANS_DIR"

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
        log_warning "Falling back to template-based generation."
    fi
else
    log_warning "Cursor CLI not found. Using template-based generation."
fi

# Simple Cursor CLI wrapper
cursor_ask() {
    local prompt="$1"
    local max_tokens="${2:-500}"  # Keep responses short by default
    
    if [ "$CURSOR_AVAILABLE" = false ] || [ "$CURSOR_AUTHENTICATED" = false ]; then
        return 1
    fi
    
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
    
    # Add instruction to keep response concise
    local full_prompt="$prompt

IMPORTANT: Keep your response concise and focused. Maximum $max_tokens tokens."
    
    local temp_output=$(mktemp)
    timeout 60 "${cmd_parts[@]}" "$full_prompt" > "$temp_output" 2>&1 || true
    
    if [ -s "$temp_output" ]; then
        # Clean output
        grep -vE "^cursor-agent|^Command:|^Executing|\[INFO\]|\[WARNING\]|\[ERROR\]|┌|│|└|─|═|┐|┘|├|┤|^Starting|^Checking|^Press" "$temp_output" | \
        sed -E 's/\x1b\[[0-9;]*m//g' | \
        sed '/^$/d' | \
        head -100
        rm -f "$temp_output"
        return 0
    fi
    
    rm -f "$temp_output"
    return 1
}

# Step 1: Analyze plan and determine wave count
analyze_plan_for_waves() {
    local plan_file="$1"
    
    log_info "Step 1: Analyzing plan structure..."
    
    # Extract only the key sections (keep it small!)
    local plan_overview=$(head -100 "$plan_file")
    local requirements_count=$(grep -c "^###\|^- " "$plan_file" 2>/dev/null || echo "0")
    local sections_count=$(grep -c "^## " "$plan_file" 2>/dev/null || echo "0")
    
    # Simple heuristic for wave count
    local wave_count=3
    
    if [ "$requirements_count" -gt 30 ] || [ "$sections_count" -gt 15 ]; then
        wave_count=4
    fi
    
    if [ "$requirements_count" -gt 50 ] || [ "$sections_count" -gt 25 ]; then
        wave_count=5
    fi
    
    # Try to get AI suggestion if available
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        local ai_prompt="Analyze this plan overview and suggest optimal wave count (3-5 waves recommended):

PLAN OVERVIEW (first 100 lines):
$plan_overview

METRICS:
- Requirements: $requirements_count
- Sections: $sections_count

OUTPUT: Just reply with a single number (3, 4, or 5) representing the optimal wave count."
        
        local ai_response=$(cursor_ask "$ai_prompt" 50)
        local ai_wave_count=$(echo "$ai_response" | grep -oE '^[0-9]+$' | head -1)
        
        if [ -n "$ai_wave_count" ] && [ "$ai_wave_count" -ge 3 ] && [ "$ai_wave_count" -le 5 ]; then
            wave_count=$ai_wave_count
            log_info "AI suggested wave count: $wave_count"
        fi
    fi
    
    echo "$wave_count"
}

# Step 2: Determine wave scope (what goes in each wave)
determine_wave_scope() {
    local plan_file="$1"
    local wave_num=$2
    local wave_count=$3
    
    log_info "Step 2: Determining scope for Wave $wave_num..."
    
    # Default scopes based on wave number
    case $wave_num in
        1)
            echo "Foundation & Setup"
            ;;
        2)
            echo "Core Features"
            ;;
        3)
            echo "Advanced Features"
            ;;
        4)
            echo "Integration & Polish"
            ;;
        5)
            echo "Optimization & Extras"
            ;;
        *)
            echo "Additional Features"
            ;;
    esac
}

# Step 3: Extract relevant plan content for wave
extract_wave_context() {
    local plan_file="$1"
    local wave_num=$2
    local wave_scope="$3"
    
    log_info "Step 3: Extracting context for Wave $wave_num ($wave_scope)..."
    
    # Extract based on wave scope keywords
    local keywords=""
    case $wave_num in
        1)
            keywords="setup|install|config|auth|database|schema|foundation|infrastructure"
            ;;
        2)
            keywords="feature|core|main|primary|data|collection|crud"
            ;;
        3)
            keywords="advanced|analytics|reporting|statistics|discovery|search"
            ;;
        4)
            keywords="integration|api|external|service|polish|ui|ux"
            ;;
        5)
            keywords="optimization|performance|cache|enhancement|extra"
            ;;
        *)
            keywords=".*"
            ;;
    esac
    
    # Extract matching sections (limit to 30 lines)
    grep -iE "$keywords" "$plan_file" 2>/dev/null | head -30
}

# Step 4: Generate wave subplan (focused prompt)
generate_wave_subplan() {
    local plan_num=$1
    local wave_num=$2
    local wave_scope="$3"
    local wave_context="$4"
    local subplan_file="$PLANS_DIR/plan$plan_num/waves/wave$wave_num/subplan$wave_num.md"
    
    log_info "Step 4: Generating subplan for Wave $wave_num..."
    
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        # More explicit prompt to prevent summaries
        local prompt="You are writing a detailed wave subplan. Write ONLY the markdown content, no summaries or meta-text.

WAVE: $wave_num - $wave_scope
CONTEXT: $wave_context

Write the complete markdown document with this EXACT structure:

---
**Implementation Instructions:**
Follow this plan verbatim. Trust the files and references. Do not re-verify. Implement all changes, then review together.
---

# Wave $wave_num: $wave_scope

## Objectives
1. [Specific objective with details]
2. [Specific objective with details]
3. [Specific objective with details]

## Tasks
1. **Task Name**: Description with file paths
   - Subtask A
   - Subtask B
2. **Task Name**: Description with file paths
   - Subtask A
   - Subtask B
[Continue for 5-8 tasks]

## Dependencies
- Wave X must be complete (if applicable)
- External service Y

## Acceptance Criteria
- [ ] Specific testable criterion
- [ ] Specific testable criterion
[3-5 criteria]

---
*Generated by Foundation Framework Phase 1*

IMPORTANT: Write the FULL markdown document. Do NOT summarize. Do NOT say 'Created the subplan' - just write the actual subplan content."
        
        # Use the simple wrapper with larger token limit
        local temp_file=$(mktemp)
        if cursor_ask "$prompt" 2000 > "$temp_file" 2>/dev/null && [ -s "$temp_file" ]; then
            # Check if it's actual content or a summary
            if ! grep -q "Created\|Summary:" "$temp_file"; then
                mv "$temp_file" "$subplan_file"
                log_success "Generated subplan$wave_num.md"
                return 0
            else
                log_warning "Got summary instead of content, using template"
                rm -f "$temp_file"
            fi
        fi
        rm -f "$temp_file"
    fi
    
    # Fallback template
    cat > "$subplan_file" << EOF
---
**Implementation Instructions:**
Follow this plan verbatim. Trust the files and references. Do not re-verify. Implement all changes, then review together.
---

# Wave $wave_num: $wave_scope

## Objectives
- Set up foundational components
- Implement core functionality
- Ensure proper testing

## Tasks
1. **Setup**: Initialize project structure
2. **Implementation**: Build core features
3. **Testing**: Add unit tests
4. **Documentation**: Update docs

## Dependencies
$([ "$wave_num" -gt 1 ] && echo "- Wave $((wave_num - 1)) must be complete" || echo "None")

## Acceptance Criteria
- All tasks completed
- Tests passing
- Code reviewed

---
*Generated by Foundation Framework Phase 1*
EOF
    
    log_success "Created template subplan$wave_num.md"
}

# Step 5: Generate wave tests (focused prompt)
generate_wave_tests() {
    local plan_num=$1
    local wave_num=$2
    local wave_scope="$3"
    local subplan_file="$PLANS_DIR/plan$plan_num/waves/wave$wave_num/subplan$wave_num.md"
    local subtest_file="$PLANS_DIR/plan$plan_num/waves/wave$wave_num/subtest$wave_num.md"
    local unit_tests_file="$PLANS_DIR/plan$plan_num/waves/wave$wave_num/unit_tests.md"
    
    log_info "Step 5: Generating tests for Wave $wave_num..."
    
    # Read subplan objectives and tasks (limit size)
    local subplan_summary=""
    if [ -f "$subplan_file" ]; then
        subplan_summary=$(grep -A 20 "^## Objectives\|^## Tasks" "$subplan_file" | head -30)
    fi
    
    if [ "$CURSOR_AUTHENTICATED" = true ] && [ -n "$subplan_summary" ]; then
        local prompt="Generate test specifications for Wave $wave_num: $wave_scope

WAVE SUMMARY:
$subplan_summary

OUTPUT: List 5-10 specific test cases covering:
- Unit tests for core functions
- Integration tests for APIs
- E2E tests for user flows

Be specific and actionable. Reference actual features from the wave."
        
        local test_content=$(cursor_ask "$prompt" 800)
        
        if [ -n "$test_content" ]; then
            # Write subtest file
            cat > "$subtest_file" << EOF
---
**Test Implementation Instructions:**
Follow test specifications verbatim. Implement all tests as specified.
---

# Tests for Wave $wave_num: $wave_scope

$test_content

---
*Generated by Foundation Framework Phase 1*
EOF
            log_success "Generated subtest$wave_num.md"
        fi
    else
        # Fallback template
        cat > "$subtest_file" << EOF
---
**Test Implementation Instructions:**
Follow test specifications verbatim. Implement all tests as specified.
---

# Tests for Wave $wave_num: $wave_scope

## Unit Tests
- Test core functionality
- Test edge cases
- Test error handling

## Integration Tests
- Test API endpoints
- Test database operations
- Test external services

---
*Generated by Foundation Framework Phase 1*
EOF
        log_success "Created template subtest$wave_num.md"
    fi
    
    # Create unit tests stub
    cat > "$unit_tests_file" << EOF
---
**Unit Test Implementation Instructions:**
Implement all unit tests as specified. Ensure >80% coverage.
---

# Unit Tests for Wave $wave_num

## Test Structure
- tests/wave${wave_num}/
  - core.test.ts
  - integration.test.ts

## Coverage Target
- Overall: >80%
- Critical paths: 100%

---
*Generated by Foundation Framework Phase 1*
EOF
    
    log_success "Generated unit_tests.md for wave$wave_num"
}

# Initialize decision log
initialize_decision_log() {
    local plan_num=$1
    local wave_count=$2
    local decision_log="$PLANS_DIR/plan$plan_num/decision_log.md"
    
    cat > "$decision_log" << EOF
# Decision Log for Plan $plan_num

## Wave Decomposition
**Date**: $(date +"%Y-%m-%d %H:%M:%S")
**Wave Count**: $wave_count
**Rationale**: Optimized for token efficiency and one-shot execution

## Phase 1: Planning Decisions
| Date | Wave | Decision | Rationale |
|------|------|----------|-----------|
| $(date +"%Y-%m-%d") | All | Structure created | Foundation Framework standard |

---
*Generated by Foundation Framework Phase 1*
EOF
    
    log_success "Initialized decision log"
}

# Main processing function
process_plan() {
    local plan_file="$1"
    local plan_num=1
    
    log_info "=========================================="
    log_info "Processing Plan: $(basename "$plan_file")"
    log_info "=========================================="
    echo ""
    
    # Step 1: Analyze and determine waves
    local wave_count=$(analyze_plan_for_waves "$plan_file")
    log_success "Determined wave count: $wave_count"
    echo ""
    
    # Create directory structure
    mkdir -p "$PLANS_DIR/plan$plan_num"
    for wave_num in $(seq 1 $wave_count); do
        mkdir -p "$PLANS_DIR/plan$plan_num/waves/wave$wave_num"
    done
    log_success "Created directory structure"
    echo ""
    
    # Copy plan file (no modification)
    cp "$plan_file" "$PLANS_DIR/plan$plan_num/plan$plan_num.md"
    log_success "Copied plan to plan$plan_num.md"
    echo ""
    
    # Initialize decision log
    initialize_decision_log "$plan_num" "$wave_count"
    echo ""
    
    # Process each wave (multi-step approach)
    for wave_num in $(seq 1 $wave_count); do
        log_info "=========================================="
        log_info "Processing Wave $wave_num of $wave_count"
        log_info "=========================================="
        
        # Step 2: Determine wave scope
        local wave_scope=$(determine_wave_scope "$plan_file" "$wave_num" "$wave_count")
        log_success "Wave scope: $wave_scope"
        
        # Step 3: Extract wave context
        local wave_context=$(extract_wave_context "$plan_file" "$wave_num" "$wave_scope")
        log_success "Extracted wave context"
        
        # Step 4: Generate subplan
        generate_wave_subplan "$plan_num" "$wave_num" "$wave_scope" "$wave_context"
        
        # Step 5: Generate tests
        generate_wave_tests "$plan_num" "$wave_num" "$wave_scope"
        
        echo ""
    done
    
    log_success "Completed processing plan$plan_num"
}

# Main execution
main() {
    log_info "=========================================="
    log_info "  Foundation Framework - Phase 1"
    log_info "  Wave Decomposition"
    log_info "=========================================="
    echo ""
    
    log_info "Input: $INPUT_FILE"
    if [ -n "$CURSOR_MODEL" ]; then
        log_info "Cursor Model: $CURSOR_MODEL"
    fi
    log_info "Output: $PLANS_DIR"
    echo ""
    
    # Create Plans directory
    mkdir -p "$PLANS_DIR"
    
    # Process the plan
    process_plan "$INPUT_FILE"
    
    echo ""
    log_success "=========================================="
    log_success "Phase 1 Complete!"
    log_success "=========================================="
    log_info "Output: $PLANS_DIR"
}

# Run main
main
