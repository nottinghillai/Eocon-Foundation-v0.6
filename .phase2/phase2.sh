#!/bin/bash

# Foundation Framework - Phase 2: Question Agent
# Analyzes all plans and waves for ambiguities and generates Questions.md

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
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
    echo -e "${MAGENTA}[PHASE 2]${NC} $1" >&2
}

# Show usage
show_usage() {
    cat << EOF
Foundation Framework - Phase 2: Question Agent

Usage: $0 [options]

OPTIONS:
  --plans-dir <dir>      Plans directory to analyze (default: Plans)
  -m, --model <model>    Cursor model to use (e.g., claude-3-opus, gpt-4)
  -o, --output <file>    Output file for questions (default: Questions.md)
  --max-questions <num>  Maximum questions per plan (default: 20)
  -h, --help             Show this help message

DESCRIPTION:
  Phase 2 analyzes all plan files and wave decompositions to identify:
  - Ambiguous requirements
  - Missing details
  - Unclear specifications
  - Potential conflicts
  - Integration gaps

EXAMPLES:
  $0                                    # Analyze default Plans/ directory
  $0 --plans-dir phase1_testing/Plans  # Analyze specific directory
  $0 -m claude-3-opus                  # Use specific model

OUTPUT:
  - Questions.md: Comprehensive list of identified ambiguities
  - decision_log.md: Updated with ambiguity findings (per plan)

EOF
}

# Parse arguments
PLANS_DIR="Plans"
CURSOR_MODEL=""
OUTPUT_FILE="Questions.md"
MAX_QUESTIONS=20

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
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            --output=*)
                OUTPUT_FILE="${1#*=}"
                shift
                ;;
            --max-questions)
                MAX_QUESTIONS="$2"
                shift 2
                ;;
            --max-questions=*)
                MAX_QUESTIONS="${1#*=}"
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
OUTPUT_FILE="$PROJECT_ROOT/$OUTPUT_FILE"

# Validate Plans directory
if [ ! -d "$PLANS_DIR" ]; then
    log_error "Plans directory not found: $PLANS_DIR"
    log_info "Run Phase 1 first to generate plans"
    exit 1
fi

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
        log_warning "Falling back to heuristic-based analysis."
    fi
else
    log_warning "Cursor CLI not found. Using heuristic-based analysis."
fi

# Simple Cursor CLI wrapper
cursor_ask() {
    local prompt="$1"
    local max_tokens="${2:-1000}"
    
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
    
    local full_prompt="$prompt

IMPORTANT: Keep your response concise and focused. Maximum $max_tokens tokens."
    
    local temp_output=$(mktemp)
    timeout 90 "${cmd_parts[@]}" "$full_prompt" > "$temp_output" 2>&1 || true
    
    if [ -s "$temp_output" ]; then
        # Clean output
        grep -vE "^cursor-agent|^Command:|^Executing|\[INFO\]|\[WARNING\]|\[ERROR\]|┌|│|└|─|═|┐|┘|├|┤|^Starting|^Checking|^Press" "$temp_output" | \
        sed -E 's/\x1b\[[0-9;]*m//g' | \
        sed '/^$/d' | \
        head -150
        rm -f "$temp_output"
        return 0
    fi
    
    rm -f "$temp_output"
    return 1
}

# Heuristic analysis for ambiguities (fallback when AI not available)
heuristic_analyze() {
    local file="$1"
    local questions=()
    
    # Check for vague terms
    if grep -qiE "somehow|maybe|probably|might|could|should probably|tbd|todo|fixme|xxx" "$file"; then
        questions+=("- **Vague Specification**: Document contains uncertain language (somehow, maybe, probably, TBD)")
    fi
    
    # Check for missing implementation details
    if grep -qiE "implement|create|build|add" "$file" && ! grep -qiE "using|with|via|through|by" "$file"; then
        questions+=("- **Missing Implementation Details**: Tasks lack specific implementation approach")
    fi
    
    # Check for undefined dependencies
    if grep -qiE "depends on|requires|needs" "$file" && ! grep -qE "^## Dependencies" "$file"; then
        questions+=("- **Undefined Dependencies**: Dependencies mentioned but not formally documented")
    fi
    
    # Check for missing error handling
    if grep -qiE "api|request|database|network" "$file" && ! grep -qiE "error|exception|failure|timeout" "$file"; then
        questions+=("- **Missing Error Handling**: No error handling strategy specified for external operations")
    fi
    
    # Check for undefined data structures
    if grep -qiE "data|model|schema|entity" "$file" && ! grep -qiE "type|interface|struct|class" "$file"; then
        questions+=("- **Undefined Data Structures**: Data models mentioned but not specified")
    fi
    
    # Check for missing test coverage details
    if [ -f "$file" ] && basename "$file" | grep -qE "test|spec"; then
        if ! grep -qiE "coverage|should|expect|assert" "$file"; then
            questions+=("- **Vague Test Specifications**: Test file lacks specific assertions or coverage targets")
        fi
    fi
    
    # Output questions
    printf "%s\n" "${questions[@]}"
}

# Analyze a single plan file with AI
analyze_plan_with_ai() {
    local plan_file="$1"
    local plan_name=$(basename "$(dirname "$plan_file")")
    
    log_info "Analyzing $plan_name with AI..."
    
    # Extract plan content (limit to first 200 lines to manage token count)
    local plan_content=$(head -200 "$plan_file")
    
    local prompt="You are the Question Agent in the Foundation Framework. Your role is to identify ambiguities, missing details, and unclear specifications.

Analyze this plan and identify specific questions that need clarification:

PLAN CONTENT:
$plan_content

OUTPUT FORMAT:
Generate a numbered list of specific, actionable questions. Focus on:
1. Ambiguous requirements
2. Missing implementation details
3. Undefined dependencies
4. Unclear acceptance criteria
5. Integration gaps
6. Data structure ambiguities
7. Missing error handling strategies

Limit to $MAX_QUESTIONS most critical questions. Be specific and reference the plan content."
    
    local ai_response=$(cursor_ask "$prompt" 1500)
    
    if [ -n "$ai_response" ]; then
        echo "$ai_response"
        return 0
    fi
    
    return 1
}

# Analyze a wave with AI
analyze_wave_with_ai() {
    local wave_dir="$1"
    local wave_name=$(basename "$wave_dir")
    local plan_name=$(basename "$(dirname "$(dirname "$wave_dir")")")
    
    log_info "Analyzing $plan_name/$wave_name with AI..."
    
    # Collect wave content
    local wave_content=""
    
    if [ -f "$wave_dir/subplan${wave_name#wave}.md" ]; then
        wave_content+="=== SUBPLAN ===\n"
        wave_content+=$(head -100 "$wave_dir/subplan${wave_name#wave}.md")
        wave_content+="\n\n"
    fi
    
    if [ -f "$wave_dir/subtest${wave_name#wave}.md" ]; then
        wave_content+="=== TESTS ===\n"
        wave_content+=$(head -100 "$wave_dir/subtest${wave_name#wave}.md")
    fi
    
    if [ -z "$wave_content" ]; then
        return 1
    fi
    
    local prompt="You are the Question Agent. Analyze this wave for ambiguities and unclear specifications.

WAVE: $plan_name/$wave_name

CONTENT:
$wave_content

OUTPUT:
List 3-5 specific questions about this wave. Focus on implementation ambiguities and missing details."
    
    local ai_response=$(cursor_ask "$prompt" 800)
    
    if [ -n "$ai_response" ]; then
        echo "$ai_response"
        return 0
    fi
    
    return 1
}

# Process a single plan directory
process_plan() {
    local plan_dir="$1"
    local plan_name=$(basename "$plan_dir")
    local plan_file="$plan_dir/${plan_name}.md"
    
    log_phase "Processing $plan_name..."
    
    local questions=()
    
    # Analyze main plan file
    if [ -f "$plan_file" ]; then
        log_info "Analyzing main plan: $plan_file"
        
        if [ "$CURSOR_AUTHENTICATED" = true ]; then
            local ai_questions=$(analyze_plan_with_ai "$plan_file")
            if [ -n "$ai_questions" ]; then
                questions+=("### $plan_name Main Plan")
                questions+=("$ai_questions")
                questions+=("")
            fi
        else
            # Fallback to heuristic analysis
            local heuristic_questions=$(heuristic_analyze "$plan_file")
            if [ -n "$heuristic_questions" ]; then
                questions+=("### $plan_name Main Plan")
                questions+=("$heuristic_questions")
                questions+=("")
            fi
        fi
    fi
    
    # Analyze waves
    if [ -d "$plan_dir/waves" ]; then
        for wave_dir in "$plan_dir/waves"/wave*; do
            if [ -d "$wave_dir" ]; then
                local wave_num=$(basename "$wave_dir" | sed 's/wave//')
                
                if [ "$CURSOR_AUTHENTICATED" = true ]; then
                    local wave_questions=$(analyze_wave_with_ai "$wave_dir")
                    if [ -n "$wave_questions" ]; then
                        questions+=("#### Wave $wave_num")
                        questions+=("$wave_questions")
                        questions+=("")
                    fi
                else
                    # Heuristic analysis for wave files
                    local wave_has_issues=false
                    for wave_file in "$wave_dir"/*.md; do
                        if [ -f "$wave_file" ]; then
                            local wave_file_questions=$(heuristic_analyze "$wave_file")
                            if [ -n "$wave_file_questions" ]; then
                                if [ "$wave_has_issues" = false ]; then
                                    questions+=("#### Wave $wave_num")
                                    wave_has_issues=true
                                fi
                                questions+=("$(basename "$wave_file"):")
                                questions+=("$wave_file_questions")
                            fi
                        fi
                    done
                    if [ "$wave_has_issues" = true ]; then
                        questions+=("")
                    fi
                fi
            fi
        done
    fi
    
    # Update decision log for this plan
    update_decision_log "$plan_dir" "${questions[@]}"
    
    # Return all questions
    printf "%s\n" "${questions[@]}"
}

# Update decision log with Phase 2 findings
update_decision_log() {
    local plan_dir="$1"
    shift
    local questions=("$@")
    
    local decision_log="$plan_dir/decision_log.md"
    
    if [ ! -f "$decision_log" ]; then
        log_warning "Decision log not found: $decision_log"
        log_info "Creating new decision log"
        cat > "$decision_log" << EOF
# Decision Log for $(basename "$plan_dir")

## Phase 1: Planning Decisions
| Date | Decision | Rationale |
|------|----------|-----------|
| $(date +"%Y-%m-%d") | Structure created | Foundation Framework standard |

EOF
    fi
    
    # Append Phase 2 section
    cat >> "$decision_log" << EOF

## Phase 2: Question Agent Analysis
**Date**: $(date +"%Y-%m-%d %H:%M:%S")
**Analysis Method**: $([ "$CURSOR_AUTHENTICATED" = true ] && echo "AI-powered" || echo "Heuristic-based")

### Identified Ambiguities

EOF
    
    if [ ${#questions[@]} -gt 0 ]; then
        printf "%s\n" "${questions[@]}" >> "$decision_log"
    else
        echo "No significant ambiguities detected." >> "$decision_log"
    fi
    
    cat >> "$decision_log" << EOF

---
*Updated by Foundation Framework Phase 2*
EOF
    
    log_success "Updated decision log: $decision_log"
}

# Generate consolidated Questions.md
generate_questions_file() {
    local all_questions="$1"
    
    log_phase "Generating consolidated Questions.md..."
    
    cat > "$OUTPUT_FILE" << EOF
---
**Foundation Framework - Phase 2: Question Agent**
**Generated**: $(date +"%Y-%m-%d %H:%M:%S")
**Analysis Method**: $([ "$CURSOR_AUTHENTICATED" = true ] && echo "AI-powered (Cursor CLI)" || echo "Heuristic-based")
---

# Questions for Human Review

This document contains ambiguities, unclear specifications, and missing details identified across all plans and waves. These questions should be answered before proceeding to Phase 3 (Optimization).

## Purpose

The Question Agent's role is to:
- Identify ambiguous requirements
- Detect missing implementation details
- Flag unclear specifications
- Highlight potential integration conflicts
- Surface undefined dependencies

**Note**: This agent identifies questions only—it does NOT answer them. Answers will be provided by the Optimization Agent (Phase 3) using historical patterns and best practices.

---

# Questions by Plan

EOF
    
    if [ -n "$all_questions" ]; then
        echo "$all_questions" >> "$OUTPUT_FILE"
    else
        cat >> "$OUTPUT_FILE" << EOF
No significant ambiguities detected. All plans appear well-specified.

This may indicate:
1. Plans are exceptionally well-written
2. Analysis needs deeper inspection (consider using AI-powered analysis)
3. Plans are templates and need actual content
EOF
    fi
    
    cat >> "$OUTPUT_FILE" << EOF

---

## Next Steps

1. **Human Review**: Review all questions above
2. **Provide Context**: Add clarifications to plan documents or via separate notes
3. **Run Phase 3**: Optimization Agent will resolve questions using:
   - Historical patterns from Guides/
   - Code patterns from Design/
   - Documentation from Docs/
   - Industry best practices

**Command**: \`bash .phase3/phase3.sh\` (once Phase 3 is implemented)

---
*Generated by Foundation Framework Phase 2*
EOF
    
    log_success "Generated: $OUTPUT_FILE"
}

# Main processing function
main() {
    log_phase "=========================================="
    log_phase "  Foundation Framework - Phase 2"
    log_phase "  Question Agent"
    log_phase "=========================================="
    echo ""
    
    log_info "Plans Directory: $PLANS_DIR"
    log_info "Output File: $OUTPUT_FILE"
    if [ -n "$CURSOR_MODEL" ]; then
        log_info "Cursor Model: $CURSOR_MODEL"
    fi
    log_info "Max Questions per Plan: $MAX_QUESTIONS"
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
    
    log_success "Found ${#plan_dirs[@]} plan(s) to analyze"
    echo ""
    
    # Process each plan
    local all_questions=""
    for plan_dir in "${plan_dirs[@]}"; do
        local plan_questions=$(process_plan "$plan_dir")
        if [ -n "$plan_questions" ]; then
            all_questions+="$plan_questions"
            all_questions+=$'\n\n'
        fi
        echo ""
    done
    
    # Generate consolidated Questions.md
    generate_questions_file "$all_questions"
    
    echo ""
    log_success "=========================================="
    log_success "Phase 2 Complete!"
    log_success "=========================================="
    log_info "Questions File: $OUTPUT_FILE"
    log_info "Decision Logs: Updated in each plan directory"
    echo ""
    log_phase "Next: Review $OUTPUT_FILE and proceed to Phase 3 (Optimization Agent)"
}

# Run main
main

