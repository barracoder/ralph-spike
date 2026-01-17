#!/bin/bash
# Unit tests for Ralph shell scripts
# Tests for ralph-docker.sh, docker-entrypoint.sh, and setup-submodule.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helpers.sh"

RALPH_SCRIPTS_DIR="$(cd "$SCRIPT_DIR/../../scripts/ralph" && pwd)"

echo "Testing Ralph shell scripts..."
echo ""

# =============================================================================
# Tests for ralph.sh (existing script)
# =============================================================================

test_ralph_script_exists() {
  echo "Test: ralph.sh exists and is executable"
  assert_file_exists "$RALPH_SCRIPTS_DIR/ralph.sh" "ralph.sh should exist"
  assert_file_executable "$RALPH_SCRIPTS_DIR/ralph.sh" "ralph.sh should be executable"
}

test_ralph_script_has_shebang() {
  echo "Test: ralph.sh has proper shebang"
  local first_line
  first_line=$(head -n 1 "$RALPH_SCRIPTS_DIR/ralph.sh")
  assert_equals "#!/bin/bash" "$first_line" "ralph.sh should have bash shebang"
}

test_ralph_copilot_script_exists() {
  echo "Test: ralph-copilot.sh exists and is executable"
  assert_file_exists "$RALPH_SCRIPTS_DIR/ralph-copilot.sh" "ralph-copilot.sh should exist"
  assert_file_executable "$RALPH_SCRIPTS_DIR/ralph-copilot.sh" "ralph-copilot.sh should be executable"
}

# =============================================================================
# Tests for ralph-docker.sh (future script)
# These tests document the expected behavior when the script is created
# =============================================================================

test_ralph_docker_script_structure() {
  echo "Test: ralph-docker.sh structure (when created)"
  
  local docker_script="$RALPH_SCRIPTS_DIR/ralph-docker.sh"
  
  if [ -f "$docker_script" ]; then
    assert_file_executable "$docker_script" "ralph-docker.sh should be executable"
    
    # Test for required environment variable checks
    local script_content
    script_content=$(cat "$docker_script")
    
    # Should check for GITHUB_TOKEN when agent is copilot
    assert_contains "$script_content" "GITHUB_TOKEN" "Should check GITHUB_TOKEN for copilot"
    
    # Should check for AMP_TOKEN when agent is amp
    assert_contains "$script_content" "AMP_TOKEN" "Should check AMP_TOKEN for amp"
    
    # Should validate agent type argument
    assert_contains "$script_content" "copilot\|amp" "Should validate agent type"
    
    # Should check Docker availability
    assert_contains "$script_content" "docker" "Should check for Docker"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} ralph-docker.sh does not exist yet"
  fi
}

test_ralph_docker_defaults() {
  echo "Test: ralph-docker.sh default values (when created)"
  
  local docker_script="$RALPH_SCRIPTS_DIR/ralph-docker.sh"
  
  if [ -f "$docker_script" ]; then
    local script_content
    script_content=$(cat "$docker_script")
    
    # Should have default values
    assert_contains "$script_content" "MAX_ITERATIONS.*10" "Should default MAX_ITERATIONS to 10"
    assert_contains "$script_content" "MODEL.*gpt-5.1-codex" "Should default MODEL to gpt-5.1-codex"
    assert_contains "$script_content" "AGENT.*copilot" "Should default AGENT to copilot"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} ralph-docker.sh does not exist yet"
  fi
}

# =============================================================================
# Tests for docker-entrypoint.sh (future script)
# =============================================================================

test_docker_entrypoint_structure() {
  echo "Test: docker-entrypoint.sh structure (when created)"
  
  local entrypoint_script="$RALPH_SCRIPTS_DIR/docker-entrypoint.sh"
  
  if [ -f "$entrypoint_script" ]; then
    assert_file_executable "$entrypoint_script" "docker-entrypoint.sh should be executable"
    
    local script_content
    script_content=$(cat "$entrypoint_script")
    
    # Should handle environment variables
    assert_contains "$script_content" "RALPH_AGENT" "Should handle RALPH_AGENT env var"
    assert_contains "$script_content" "RALPH_MAX_ITERATIONS" "Should handle RALPH_MAX_ITERATIONS env var"
    assert_contains "$script_content" "RALPH_MODEL" "Should handle RALPH_MODEL env var"
    
    # Should detect Ralph script directory
    assert_contains "$script_content" "SCRIPT_DIR\|ralph" "Should detect Ralph script directory"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} docker-entrypoint.sh does not exist yet"
  fi
}

# =============================================================================
# Tests for setup-submodule.sh (future script)
# =============================================================================

test_setup_submodule_structure() {
  echo "Test: setup-submodule.sh structure (when created)"
  
  local setup_script="$RALPH_SCRIPTS_DIR/setup-submodule.sh"
  
  if [ -f "$setup_script" ]; then
    assert_file_executable "$setup_script" "setup-submodule.sh should be executable"
    
    local script_content
    script_content=$(cat "$setup_script")
    
    # Should validate target directory
    assert_contains "$script_content" "target.*dir\|TARGET.*DIR" "Should handle target directory"
    
    # Should check git repository
    assert_contains "$script_content" "git" "Should check/initialize git repository"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} setup-submodule.sh does not exist yet"
  fi
}

# =============================================================================
# Test shellcheck validation (if available)
# =============================================================================

test_shellcheck_validation() {
  echo "Test: Shell scripts pass shellcheck validation"
  
  if ! command -v shellcheck >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} shellcheck not installed"
    return 0
  fi
  
  # Test existing scripts
  for script in "$RALPH_SCRIPTS_DIR"/*.sh; do
    if [ -f "$script" ]; then
      local script_name
      script_name=$(basename "$script")
      if shellcheck "$script" 2>&1 | grep -q "No issues detected"; then
        echo -e "${GREEN}  ✓ PASS:${NC} $script_name passes shellcheck"
        PASS_COUNT=$((PASS_COUNT + 1))
        TEST_COUNT=$((TEST_COUNT + 1))
      else
        # Some warnings are acceptable, only fail on errors
        if shellcheck -S error "$script" >/dev/null 2>&1; then
          echo -e "${GREEN}  ✓ PASS:${NC} $script_name has no shellcheck errors (warnings ok)"
          PASS_COUNT=$((PASS_COUNT + 1))
        else
          echo -e "${RED}  ✗ FAIL:${NC} $script_name has shellcheck errors"
          shellcheck -S error "$script" 2>&1 | head -20
          FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
        TEST_COUNT=$((TEST_COUNT + 1))
      fi
    fi
  done
}

# =============================================================================
# Bash 3.2 compatibility tests
# =============================================================================

test_bash_32_compatibility() {
  echo "Test: Scripts are bash 3.2 compatible"
  
  for script in "$RALPH_SCRIPTS_DIR"/*.sh; do
    if [ -f "$script" ]; then
      local script_name
      script_name=$(basename "$script")
      local script_content
      script_content=$(cat "$script")
      
      # Check for incompatible features
      local has_issues=0
      
      # Check for ${var,,} lowercase syntax
      if echo "$script_content" | grep -q '\${[^}]*,,'; then
        echo -e "${RED}  ✗ FAIL:${NC} $script_name uses \${var,,} (bash 4+ only)"
        has_issues=1
      fi
      
      # Check for associative arrays
      if echo "$script_content" | grep -q 'declare -A'; then
        echo -e "${RED}  ✗ FAIL:${NC} $script_name uses associative arrays (bash 4+ only)"
        has_issues=1
      fi
      
      # Check for |& syntax
      if echo "$script_content" | grep -q '|&'; then
        echo -e "${RED}  ✗ FAIL:${NC} $script_name uses |& (bash 4+ only)"
        has_issues=1
      fi
      
      if [ $has_issues -eq 0 ]; then
        echo -e "${GREEN}  ✓ PASS:${NC} $script_name appears bash 3.2 compatible"
        PASS_COUNT=$((PASS_COUNT + 1))
      else
        FAIL_COUNT=$((FAIL_COUNT + 1))
      fi
      TEST_COUNT=$((TEST_COUNT + 1))
    fi
  done
}

# =============================================================================
# Run all tests
# =============================================================================

test_ralph_script_exists
test_ralph_script_has_shebang
test_ralph_copilot_script_exists
echo ""

test_ralph_docker_script_structure
test_ralph_docker_defaults
echo ""

test_docker_entrypoint_structure
echo ""

test_setup_submodule_structure
echo ""

test_shellcheck_validation
echo ""

test_bash_32_compatibility
echo ""

# Print summary and exit
print_test_summary
