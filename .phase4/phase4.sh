#!/bin/bash

# Foundation Framework - Phase 4: Stages Agent
# Dependency analysis and execution strategy generation

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
    echo -e "${MAGENTA}[PHASE 4]${NC} $1" >&2
}

# Show usage
show_usage() {
    cat << EOF
Foundation Framework - Phase 4: Stages Agent
Dependency Analysis & Execution Strategy Generation

Usage: $0 [options]

OPTIONS:
  --plans-dir <dir>      Plans directory (default: Plans)
  --output <file>        Output stages file (default: stages.md)
  -m, --model <model>    Cursor model to use
  --max-retries <num>    Max retries for AI operations (default: 2)
  -h, --help             Show this help message

DESCRIPTION:
  Phase 4 analyzes all plans and waves to:
  1. Identify dependencies between waves
  2. Build dependency graph (DAG)
  3. Calculate execution stages
  4. Identify parallel execution opportunities
  5. Determine critical path
  6. Generate stages.md with execution strategy

EXAMPLES:
  $0                                    # Use defaults
  $0 --plans-dir phase1_testing/Plans  # Custom plans directory
  $0 -m claude-3-opus                  # Use specific model
  $0 --output execution_strategy.md    # Custom output file

OUTPUT:
  stages.md containing:
  - Dependency graph visualization
  - Execution stages (what can run in parallel)
  - Critical path analysis
  - Independent waves (can run anytime)
  - Complete execution strategy

EOF
}

# Parse arguments
PLANS_DIR="Plans"
OUTPUT_FILE="stages.md"
CURSOR_MODEL=""
MAX_RETRIES=2

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            --plans-dir)
                PLANS_DIR="$2"
                shift 2
                ;;
            --output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -m|--model)
                CURSOR_MODEL="$2"
                shift 2
                ;;
            --model=*)
                CURSOR_MODEL="${1#*=}"
                shift
                ;;
            --max-retries)
                MAX_RETRIES="$2"
                shift 2
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
    log_info "Cursor CLI found"
    
    if check_cursor_auth; then
        CURSOR_AUTHENTICATED=true
        log_info "Cursor CLI authenticated"
    else
        log_warning "Cursor CLI not authenticated. Run: cursor-agent login"
        log_warning "Falling back to basic dependency analysis."
    fi
else
    log_warning "Cursor CLI not found. Using basic dependency analysis."
fi

# Cursor CLI wrapper
cursor_ask() {
    local prompt="$1"
    local max_tokens="${2:-2000}"
    
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
    
    local temp_output=$(mktemp)
    timeout 120 "${cmd_parts[@]}" "$prompt" > "$temp_output" 2>&1 || true
    
    if [ -s "$temp_output" ]; then
        # Clean output
        grep -vE "^cursor-agent|^Command:|^Executing|\[INFO\]|\[WARNING\]|\[ERROR\]|┌|│|└|─|═|┐|┘|├|┤|^Starting|^Checking|^Press" "$temp_output" | \
        sed -E 's/\x1b\[[0-9;]*m//g' | \
        sed '/^$/d'
        rm -f "$temp_output"
        return 0
    fi
    
    rm -f "$temp_output"
    return 1
}

# Extract dependencies from a wave subplan
extract_wave_dependencies() {
    local subplan_file="$1"
    
    if [ ! -f "$subplan_file" ]; then
        echo ""
        return
    fi
    
    # Look for dependency sections and extract mentioned waves/plans
    grep -iE "depend|prerequisite|require|after|before" "$subplan_file" 2>/dev/null | \
    grep -oE "(plan|wave)[0-9]+" | \
    sort -u || echo ""
}

# Analyze all plans and waves to build dependency map
analyze_dependencies() {
    log_phase "Analyzing dependencies across all plans and waves..."
    
    local dep_file=$(mktemp)
    
    # Scan all plan directories
    for plan_dir in "$PLANS_DIR"/plan*/; do
        if [ ! -d "$plan_dir" ]; then
            continue
        fi
        
        local plan_name=$(basename "$plan_dir")
        local plan_num=$(echo "$plan_name" | grep -oE "[0-9]+")
        
        log_info "Analyzing $plan_name..."
        
        # Scan all waves in this plan
        if [ -d "$plan_dir/waves" ]; then
            for wave_dir in "$plan_dir/waves"/wave*/; do
                if [ ! -d "$wave_dir" ]; then
                    continue
                fi
                
                local wave_name=$(basename "$wave_dir")
                local wave_num=$(echo "$wave_name" | grep -oE "[0-9]+")
                local wave_id="${plan_name}/${wave_name}"
                
                # Extract dependencies from subplan
                local subplan="$wave_dir/subplan${wave_num}.md"
                local deps=$(extract_wave_dependencies "$subplan")
                
                if [ -n "$deps" ]; then
                    echo "$wave_id|$deps" >> "$dep_file"
                else
                    echo "$wave_id|none" >> "$dep_file"
                fi
            done
        fi
    done
    
    echo "$dep_file"
}

# Generate Mermaid diagram from dependency data
generate_mermaid_diagram() {
    local dep_file="$1"
    
    log_phase "Generating Mermaid dependency diagram..."
    
    cat << 'EOF'
## Dependency Graph Visualization

```mermaid
graph TD
EOF
    
    # Track all waves with dependencies
    local has_deps=()
    
    # First pass: Create all nodes and edges
    while IFS='|' read -r wave_id deps; do
        # Sanitize wave_id for Mermaid (replace / with _)
        local node_id=$(echo "$wave_id" | tr '/' '_')
        local display_name=$(echo "$wave_id" | sed 's/plan/Plan /g' | sed 's/wave/Wave /g')
        
        if [ "$deps" = "none" ]; then
            # Independent wave - style differently
            echo "    $node_id[\"$display_name<br/>(Independent)\"]"
            echo "    style $node_id fill:#90EE90,stroke:#2E8B57,stroke-width:2px"
        else
            # Wave with dependencies
            echo "    $node_id[\"$display_name\"]"
            
            # Parse dependencies and create edges
            for dep in $deps; do
                local dep_node=$(echo "$dep" | tr '/' '_')
                echo "    $dep_node --> $node_id"
                has_deps+=("$node_id")
            done
        fi
    done < "$dep_file"
    
    # Add styling for waves with dependencies
    for node in "${has_deps[@]}"; do
        echo "    style $node fill:#87CEEB,stroke:#4682B4,stroke-width:2px"
    done
    
    cat << 'EOF'
    
    %% Legend
    classDef independent fill:#90EE90,stroke:#2E8B57,stroke-width:2px
    classDef dependent fill:#87CEEB,stroke:#4682B4,stroke-width:2px
```

**Legend:**
- 🟢 Green boxes: Independent waves (no dependencies)
- 🔵 Blue boxes: Dependent waves
- → Arrows: "depends on" relationship

EOF
}

# Build dependency graph using AI
build_dependency_graph_ai() {
    local dep_file="$1"
    
    log_phase "Building dependency graph with AI analysis..."
    
    local dep_data=$(cat "$dep_file")
    
    local prompt="You are analyzing wave dependencies to create an execution strategy.

DEPENDENCY DATA:
$dep_data

Each line shows: wave_id|dependencies

Your task:
1. Build a Directed Acyclic Graph (DAG) of dependencies
2. Calculate execution stages (which waves can run in parallel)
3. Identify the critical path
4. Mark independent waves (no dependencies, no dependents)

OUTPUT FORMAT (markdown):
# Dependency Graph

## Wave Dependencies
[List each wave and what it depends on]

## Execution Stages

### Stage 1 (Parallel Execution)
- [waves with no dependencies]

### Stage 2 (Parallel Execution)
- [waves that depend only on Stage 1]

### Stage N (Parallel Execution)
- [subsequent dependent waves]

## Independent Waves
[Waves with no dependencies and no dependents - can run anytime]

## Critical Path
[Longest dependency chain]

## Parallelism Opportunities
[How many waves can run simultaneously in each stage]

Be specific. Use the actual wave IDs from the data."

    local graph_output=$(cursor_ask "$prompt" 3000)
    
    if [ $? -eq 0 ] && [ -n "$graph_output" ]; then
        echo "$graph_output"
        return 0
    fi
    
    return 1
}

# Fallback: Basic dependency analysis without AI
build_dependency_graph_basic() {
    local dep_file="$1"
    
    log_phase "Building dependency graph (basic mode)..."
    
    cat << 'EOF'
# Dependency Graph

## Wave Dependencies

EOF

    # List all waves and their dependencies
    while IFS='|' read -r wave_id deps; do
        if [ "$deps" = "none" ]; then
            echo "- **$wave_id**: No dependencies"
        else
            echo "- **$wave_id**: Depends on $deps"
        fi
    done < "$dep_file"
    
    cat << 'EOF'

## Execution Stages

### Stage 1 (Parallel Execution)
EOF

    # Find waves with no dependencies
    while IFS='|' read -r wave_id deps; do
        if [ "$deps" = "none" ]; then
            echo "- $wave_id"
        fi
    done < "$dep_file"
    
    cat << 'EOF'

### Stage 2 (Sequential Execution)
EOF

    # Find waves with dependencies
    while IFS='|' read -r wave_id deps; do
        if [ "$deps" != "none" ]; then
            echo "- $wave_id (depends on: $deps)"
        fi
    done < "$dep_file"
    
    cat << 'EOF'

## Independent Waves
[Analysis requires AI mode]

## Critical Path
[Analysis requires AI mode]

## Parallelism Opportunities
- Stage 1: Multiple waves can run in parallel
- Stage 2: Sequential execution required for dependent waves

---
*Note: Basic mode provides limited dependency analysis. Use Cursor CLI for detailed graph analysis.*
EOF
}

# Generate execution strategy recommendations
generate_execution_strategy() {
    log_phase "Generating execution strategy..."
    
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        local prompt="Based on the dependency graph and execution stages above, provide detailed execution strategy recommendations.

Include:
1. **Recommended Execution Order**: Step-by-step guide
2. **Parallel Execution Strategy**: How to maximize parallelism
3. **Resource Allocation**: How many agents/workers needed per stage
4. **Risk Mitigation**: What to watch out for
5. **Testing Strategy**: When to run integration tests
6. **Rollback Strategy**: How to handle failures

Be specific and actionable. This will guide Phase 5 (Parallel Execution)."

        local strategy=$(cursor_ask "$prompt" 2000)
        
        if [ $? -eq 0 ] && [ -n "$strategy" ]; then
            echo ""
            echo "---"
            echo ""
            echo "# Execution Strategy"
            echo ""
            echo "$strategy"
            return 0
        fi
    fi
    
    # Fallback strategy
    cat << 'EOF'

---

# Execution Strategy

## Recommended Execution Order
1. Execute all Stage 1 waves in parallel
2. Wait for Stage 1 completion
3. Execute Stage 2 waves in parallel
4. Continue sequentially through stages
5. Run cross-wave integration tests
6. Deploy complete constellation

## Parallel Execution Strategy
- Assign one agent per wave within each stage
- Maximum parallelism = waves in largest stage
- Use worker pool to manage agent assignment

## Resource Allocation
- Recommended: 3-5 agents for optimal parallelism
- Minimum: 1 agent (sequential execution)
- Ideal: One agent per parallel wave

## Risk Mitigation
- Test each wave immediately after implementation
- Keep wave implementations small (< 2 hours)
- Implement rollback capability
- Monitor dependencies carefully

## Testing Strategy
- Unit tests: After each wave
- Integration tests: After each stage
- E2E tests: After all stages complete
- Cross-wave tests: Final validation

## Rollback Strategy
- Each wave is independently testable
- Failed wave blocks dependent waves only
- Independent waves can continue
- Retry failed waves up to 3 times before human intervention

---
*Generated by Foundation Framework Phase 4*
EOF
}

# Main execution
main() {
    log_phase "=========================================="
    log_phase "  Foundation Framework - Phase 4"
    log_phase "  Stages Agent (Dependency Analysis)"
    log_phase "=========================================="
    echo ""
    
    log_info "Plans Directory: $PLANS_DIR"
    log_info "Output File: $OUTPUT_FILE"
    if [ -n "$CURSOR_MODEL" ]; then
        log_info "Cursor Model: $CURSOR_MODEL"
    fi
    echo ""
    
    # Validate plans directory exists
    if [ ! -d "$PLANS_DIR" ]; then
        log_error "Plans directory not found: $PLANS_DIR"
        log_error "Run Phase 1 first to generate plans."
        exit 1
    fi
    
    # Check if there are any plans
    local plan_count=$(find "$PLANS_DIR" -maxdepth 1 -type d -name "plan*" | wc -l)
    if [ "$plan_count" -eq 0 ]; then
        log_error "No plans found in $PLANS_DIR"
        log_error "Run Phase 1 first to generate plans."
        exit 1
    fi
    
    log_success "Found $plan_count plan(s)"
    echo ""
    
    # Step 1: Analyze dependencies
    local dep_file=$(analyze_dependencies)
    log_success "Dependency analysis complete"
    echo ""
    
    # Step 2: Build dependency graph
    local graph_content=""
    if [ "$CURSOR_AUTHENTICATED" = true ]; then
        log_info "Using AI-powered dependency graph analysis..."
        graph_content=$(build_dependency_graph_ai "$dep_file")
        if [ $? -eq 0 ]; then
            log_success "AI dependency graph generated"
        else
            log_warning "AI analysis failed, falling back to basic mode"
            graph_content=$(build_dependency_graph_basic "$dep_file")
        fi
    else
        graph_content=$(build_dependency_graph_basic "$dep_file")
    fi
    echo ""
    
    # Step 3: Generate Mermaid diagram
    local mermaid_diagram=$(generate_mermaid_diagram "$dep_file")
    log_success "Mermaid diagram generated"
    echo ""
    
    # Step 4: Generate execution strategy
    local strategy_content=$(generate_execution_strategy)
    log_success "Execution strategy generated"
    echo ""
    
    # Step 5: Write stages.md
    log_phase "Writing stages.md..."
    
    cat > "$OUTPUT_FILE" << EOF
---
**Generated by Foundation Framework Phase 4**
**Date**: $(date +"%Y-%m-%d %H:%M:%S")
**Stages Agent**: Dependency Analysis & Execution Strategy
---

# Execution Stages

This document contains the complete dependency analysis and execution strategy for all plans and waves.

$mermaid_diagram

$graph_content

$strategy_content

---

## How to Use This Document

### For Phase 5 (Parallel Execution):
1. Review execution stages
2. Assign agents to parallel waves
3. Execute stages sequentially
4. Run integration tests after each stage
5. Validate complete constellation

### For Human Review:
- Verify dependency graph is correct
- Check if critical path makes sense
- Validate parallel execution opportunities
- Ensure resource allocation is feasible

### For Debugging:
- If a wave fails, check its dependencies
- Independent waves can be retried without affecting others
- Critical path waves require immediate attention

---

## Next Steps

1. **Review this document** to understand execution strategy
2. **Run Phase 5** to begin parallel execution:
   \`\`\`bash
   bash .phase5/phase5.sh --stages stages.md
   \`\`\`
3. **Monitor execution** using the stages as checkpoints
4. **Handle failures** according to rollback strategy

---

*Part of the Foundation Framework - Constitutional Programming System*
*Version: 1.0*
*Phase 4: Stages Agent*
EOF
    
    log_success "Written: $OUTPUT_FILE"
    echo ""
    
    # Clean up temp files
    rm -f "$dep_file"
    
    # Summary
    log_success "=========================================="
    log_success "Phase 4 Complete!"
    log_success "=========================================="
    log_info "Dependency graph: $OUTPUT_FILE"
    log_info ""
    log_info "Next Step: Review stages.md and run Phase 5"
    log_info "  bash .phase5/phase5.sh --stages stages.md"
    echo ""
}

# Run main
main

