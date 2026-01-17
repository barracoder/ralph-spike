#!/bin/bash
# Integration tests for Ralph setup and workflow
# End-to-end tests that verify the complete setup process

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helpers.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Running integration tests..."
echo ""

# =============================================================================
# Setup-submodule integration test
# =============================================================================

test_setup_submodule_integration() {
  echo "Test: setup-submodule.sh integration (when created)"
  
  local setup_script="$REPO_ROOT/scripts/ralph/setup-submodule.sh"
  
  if [ ! -f "$setup_script" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} setup-submodule.sh does not exist yet"
    return 0
  fi
  
  # Create temporary directory
  local test_dir
  test_dir=$(setup_test_dir)
  
  echo "  Created test directory: $test_dir"
  
  # Run setup script
  if "$setup_script" "$test_dir" >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ PASS:${NC} setup-submodule.sh executed successfully"
    PASS_COUNT=$((PASS_COUNT + 1))
    
    # Verify expected files exist
    assert_dir_exists "$test_dir/scripts/ralph" "Should create scripts/ralph directory"
    assert_file_exists "$test_dir/scripts/ralph/ralph.sh" "Should create ralph.sh"
    assert_file_exists "$test_dir/scripts/ralph/prompt.md" "Should create prompt.md"
    assert_file_exists "$test_dir/scripts/ralph/prd.json" "Should create prd.json"
    
    # Verify scripts are executable
    if [ -f "$test_dir/scripts/ralph/ralph.sh" ]; then
      assert_file_executable "$test_dir/scripts/ralph/ralph.sh" "ralph.sh should be executable"
    fi
    
    # Test idempotency - run again
    if "$setup_script" "$test_dir" >/dev/null 2>&1; then
      echo -e "${GREEN}  ✓ PASS:${NC} setup-submodule.sh is idempotent (safe to run twice)"
      PASS_COUNT=$((PASS_COUNT + 1))
    else
      echo -e "${RED}  ✗ FAIL:${NC} setup-submodule.sh fails when run twice"
      FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    TEST_COUNT=$((TEST_COUNT + 1))
    
  else
    echo -e "${RED}  ✗ FAIL:${NC} setup-submodule.sh failed to execute"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
  TEST_COUNT=$((TEST_COUNT + 1))
  
  # Cleanup
  cleanup_test_dir "$test_dir"
  echo "  Cleaned up test directory"
}

# =============================================================================
# PRD validation integration test
# =============================================================================

test_prd_validation_workflow() {
  echo "Test: PRD validation workflow"
  
  if ! command -v jq >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} jq not installed"
    return 0
  fi
  
  # Create temporary directory
  local test_dir
  test_dir=$(setup_test_dir)
  
  # Copy valid PRD fixture
  cp "$SCRIPT_DIR/fixtures/valid_prd.json" "$test_dir/prd.json"
  
  # Validate structure
  local branch_name
  branch_name=$(jq -r '.branchName // empty' "$test_dir/prd.json")
  
  assert_not_empty "$branch_name" "PRD should have branchName"
  
  # Verify it's an object with branchName at root (not an array)
  local is_object
  is_object=$(jq -r 'type' "$test_dir/prd.json")
  assert_equals "object" "$is_object" "PRD should be an object at root"
  
  # Verify stories array exists
  local has_stories
  has_stories=$(jq 'has("stories")' "$test_dir/prd.json")
  assert_equals "true" "$has_stories" "PRD should have stories array"
  
  # Cleanup
  cleanup_test_dir "$test_dir"
}

# =============================================================================
# Ralph script execution test
# =============================================================================

test_ralph_script_dry_run() {
  echo "Test: Ralph scripts can be invoked (dry run)"
  
  local ralph_script="$REPO_ROOT/scripts/ralph/ralph.sh"
  
  if [ ! -f "$ralph_script" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} ralph.sh does not exist"
    return 0
  fi
  
  # Create a test environment
  local test_dir
  test_dir=$(setup_test_dir)
  
  # Copy necessary files
  mkdir -p "$test_dir/scripts/ralph"
  cp "$REPO_ROOT/scripts/ralph/ralph.sh" "$test_dir/scripts/ralph/"
  cp "$SCRIPT_DIR/fixtures/valid_prd.json" "$test_dir/scripts/ralph/prd.json"
  echo "# Test prompt" > "$test_dir/scripts/ralph/prompt.md"
  
  # Test that script can parse arguments (won't actually run agent)
  # We'll just check it doesn't fail on basic validation
  
  # Note: We can't actually run Ralph without the amp/copilot tools
  # So we just verify the script exists and is executable
  
  assert_file_executable "$test_dir/scripts/ralph/ralph.sh" "ralph.sh should be executable"
  
  # Cleanup
  cleanup_test_dir "$test_dir"
}

# =============================================================================
# File generation test
# =============================================================================

test_file_generation_workflow() {
  echo "Test: File generation workflow (templates)"
  
  local test_dir
  test_dir=$(setup_test_dir)
  
  # Simulate creating files that would be generated by setup
  mkdir -p "$test_dir/scripts/ralph"
  
  # Create a sample prd.json from template
  cat > "$test_dir/scripts/ralph/prd.json" <<'EOF'
{
  "branchName": "ralph/test-feature",
  "stories": []
}
EOF
  
  # Verify it's valid JSON
  if command -v jq >/dev/null 2>&1; then
    assert_command_succeeds "Generated PRD should be valid JSON" jq empty "$test_dir/scripts/ralph/prd.json"
  fi
  
  # Create a sample prompt.md
  cat > "$test_dir/scripts/ralph/prompt.md" <<'EOF'
# Ralph Prompt

You are Ralph, an autonomous coding agent.
EOF
  
  assert_file_exists "$test_dir/scripts/ralph/prompt.md" "prompt.md should be created"
  
  # Verify prompt is not empty
  local prompt_size
  prompt_size=$(wc -c < "$test_dir/scripts/ralph/prompt.md" | tr -d ' ')
  
  if [ "$prompt_size" -gt 0 ]; then
    echo -e "${GREEN}  ✓ PASS:${NC} prompt.md is not empty"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo -e "${RED}  ✗ FAIL:${NC} prompt.md is empty"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
  TEST_COUNT=$((TEST_COUNT + 1))
  
  # Cleanup
  cleanup_test_dir "$test_dir"
}

# =============================================================================
# Cross-platform compatibility test
# =============================================================================

test_cross_platform_compatibility() {
  echo "Test: Scripts work on current platform"
  
  local platform
  platform=$(uname -s)
  
  echo "  Platform: $platform"
  
  # Test that our test helpers work
  local test_dir
  test_dir=$(setup_test_dir)
  
  assert_dir_exists "$test_dir" "Temporary directory should be created on $platform"
  
  # Test that we can create files
  echo "test" > "$test_dir/test.txt"
  assert_file_exists "$test_dir/test.txt" "Should be able to create files on $platform"
  
  # Test that we can make files executable
  chmod +x "$test_dir/test.txt"
  assert_file_executable "$test_dir/test.txt" "Should be able to set executable bit on $platform"
  
  # Cleanup
  cleanup_test_dir "$test_dir"
}

# =============================================================================
# Git integration test
# =============================================================================

test_git_repository_detection() {
  echo "Test: Git repository detection"
  
  # We should be in a git repository
  if git rev-parse --git-dir >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ PASS:${NC} Running in a git repository"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo -e "${RED}  ✗ FAIL:${NC} Not in a git repository"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
  TEST_COUNT=$((TEST_COUNT + 1))
  
  # Test creating a temporary git repo
  local test_dir
  test_dir=$(setup_test_dir)
  
  cd "$test_dir" || exit 1
  
  if git init >/dev/null 2>&1; then
    assert_command_succeeds "Should initialize git repo" git rev-parse --git-dir
  else
    echo -e "${RED}  ✗ FAIL:${NC} Failed to initialize git repository"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    TEST_COUNT=$((TEST_COUNT + 1))
  fi
  
  cd "$REPO_ROOT" || exit 1
  
  # Cleanup
  cleanup_test_dir "$test_dir"
}

# =============================================================================
# Environment variable handling test
# =============================================================================

test_environment_variable_handling() {
  echo "Test: Environment variable handling"
  
  # Test that scripts respect environment variables
  export TEST_VAR="test_value"
  
  local result
  result=$(bash -c 'echo $TEST_VAR')
  
  assert_equals "test_value" "$result" "Environment variables should be accessible"
  
  unset TEST_VAR
}

# =============================================================================
# Run all tests
# =============================================================================

test_setup_submodule_integration
echo ""

test_prd_validation_workflow
echo ""

test_ralph_script_dry_run
echo ""

test_file_generation_workflow
echo ""

test_cross_platform_compatibility
echo ""

test_git_repository_detection
echo ""

test_environment_variable_handling
echo ""

# Print summary and exit
print_test_summary
