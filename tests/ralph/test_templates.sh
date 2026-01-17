#!/bin/bash
# Template validation tests
# Tests for prd.json, docker-compose.yml, GitHub Actions workflow templates

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helpers.sh"

RALPH_SCRIPTS_DIR="$(cd "$SCRIPT_DIR/../../scripts/ralph" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Testing template validation..."
echo ""

# =============================================================================
# PRD JSON validation
# =============================================================================

test_valid_prd_json() {
  echo "Test: Valid PRD JSON fixture is valid"
  
  local prd_file="$SCRIPT_DIR/fixtures/valid_prd.json"
  
  assert_file_exists "$prd_file" "Valid PRD fixture should exist"
  
  # Test JSON validity
  if command -v jq >/dev/null 2>&1; then
    assert_command_succeeds "Valid PRD should parse as JSON" jq empty "$prd_file"
    
    # Check for required fields
    local branch_name
    branch_name=$(jq -r '.branchName // empty' "$prd_file" 2>/dev/null)
    assert_not_empty "$branch_name" "PRD should have branchName field"
    
    local stories_count
    stories_count=$(jq '.stories | length' "$prd_file" 2>/dev/null)
    assert_not_empty "$stories_count" "PRD should have stories array"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} jq not installed, cannot validate JSON"
  fi
}

test_invalid_prd_json() {
  echo "Test: Invalid PRD JSON fixture is detected as invalid"
  
  local prd_file="$SCRIPT_DIR/fixtures/invalid_prd.json"
  
  assert_file_exists "$prd_file" "Invalid PRD fixture should exist"
  
  # Test JSON invalidity
  if command -v jq >/dev/null 2>&1; then
    assert_command_fails "Invalid PRD should fail JSON parsing" jq empty "$prd_file"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} jq not installed, cannot validate JSON"
  fi
}

test_actual_prd_json() {
  echo "Test: Actual prd.json is valid"
  
  local prd_file="$RALPH_SCRIPTS_DIR/prd.json"
  
  if [ -f "$prd_file" ]; then
    if command -v jq >/dev/null 2>&1; then
      assert_command_succeeds "Actual PRD should be valid JSON" jq empty "$prd_file"
      
      # Check required structure
      local has_branch
      has_branch=$(jq 'has("branchName")' "$prd_file" 2>/dev/null)
      assert_equals "true" "$has_branch" "PRD should have branchName at root"
      
      local has_stories
      has_stories=$(jq 'has("stories")' "$prd_file" 2>/dev/null)
      assert_equals "true" "$has_stories" "PRD should have stories array"
    else
      echo -e "${YELLOW}  ⚠ SKIP:${NC} jq not installed"
    fi
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} prd.json does not exist"
  fi
}

test_prd_story_structure() {
  echo "Test: PRD stories have required fields"
  
  local prd_file="$RALPH_SCRIPTS_DIR/prd.json"
  
  if [ -f "$prd_file" ] && command -v jq >/dev/null 2>&1; then
    # Check first story has required fields
    local first_story_id
    first_story_id=$(jq '.stories[0].id // empty' "$prd_file" 2>/dev/null)
    
    if [ -n "$first_story_id" ]; then
      assert_not_empty "$first_story_id" "First story should have id"
      
      local title
      title=$(jq -r '.stories[0].title // empty' "$prd_file" 2>/dev/null)
      assert_not_empty "$title" "First story should have title"
      
      local description
      description=$(jq -r '.stories[0].description // empty' "$prd_file" 2>/dev/null)
      assert_not_empty "$description" "First story should have description"
    else
      echo -e "${YELLOW}  ⚠ SKIP:${NC} No stories in PRD"
    fi
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Cannot validate PRD stories"
  fi
}

# =============================================================================
# Docker Compose validation (when created)
# =============================================================================

test_docker_compose_yaml() {
  echo "Test: docker-compose.yml is valid YAML (when created)"
  
  local compose_file="$REPO_ROOT/docker-compose.yml"
  
  if [ -f "$compose_file" ]; then
    # Basic YAML syntax check - look for common issues
    local content
    content=$(cat "$compose_file")
    
    # Should have version field
    assert_contains "$content" "version:" "docker-compose.yml should have version"
    
    # Should have services
    assert_contains "$content" "services:" "docker-compose.yml should have services"
    
    # Try to validate with docker-compose if available
    if command -v docker-compose >/dev/null 2>&1; then
      assert_command_succeeds "docker-compose.yml should be valid" docker-compose -f "$compose_file" config -q
    elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
      assert_command_succeeds "docker-compose.yml should be valid" docker compose -f "$compose_file" config -q
    else
      echo -e "${YELLOW}  ⚠ SKIP:${NC} docker-compose not available for validation"
    fi
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} docker-compose.yml does not exist yet"
  fi
}

# =============================================================================
# GitHub Actions workflow validation (when created)
# =============================================================================

test_github_workflow_yaml() {
  echo "Test: GitHub Actions workflow YAML is valid (when created)"
  
  local workflow_file="$REPO_ROOT/.github/workflows/test-ralph-tooling.yml"
  
  if [ -f "$workflow_file" ]; then
    # Basic YAML syntax check
    local content
    content=$(cat "$workflow_file")
    
    # Should have workflow name
    assert_contains "$content" "name:" "Workflow should have name"
    
    # Should have on trigger
    assert_contains "$content" "on:" "Workflow should have on trigger"
    
    # Should have jobs
    assert_contains "$content" "jobs:" "Workflow should have jobs"
    
    # Check for common YAML issues
    if echo "$content" | grep -q $'\t'; then
      echo -e "${RED}  ✗ FAIL:${NC} Workflow contains tabs (should use spaces)"
      FAIL_COUNT=$((FAIL_COUNT + 1))
      TEST_COUNT=$((TEST_COUNT + 1))
    else
      echo -e "${GREEN}  ✓ PASS:${NC} Workflow uses spaces, not tabs"
      PASS_COUNT=$((PASS_COUNT + 1))
      TEST_COUNT=$((TEST_COUNT + 1))
    fi
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} GitHub Actions workflow does not exist yet"
  fi
}

# =============================================================================
# Makefile validation (when created)
# =============================================================================

test_makefile_syntax() {
  echo "Test: Makefile has valid syntax (when created)"
  
  local makefile="$REPO_ROOT/Makefile"
  
  if [ -f "$makefile" ]; then
    # Check that targets use tabs not spaces
    local line_num=0
    local has_error=0
    
    while IFS= read -r line; do
      line_num=$((line_num + 1))
      
      # Check if line looks like a target
      if echo "$line" | grep -q '^[a-zA-Z0-9_-]*:'; then
        continue
      fi
      
      # Check if line looks like a recipe (starts with whitespace)
      if echo "$line" | grep -q '^[[:space:]]'; then
        # Check if it starts with a tab
        if ! echo "$line" | grep -q $'^\t'; then
          echo -e "${RED}  ✗ FAIL:${NC} Makefile line $line_num: recipe should start with tab, not spaces"
          has_error=1
        fi
      fi
    done < "$makefile"
    
    if [ $has_error -eq 0 ]; then
      echo -e "${GREEN}  ✓ PASS:${NC} Makefile uses tabs for recipes"
      PASS_COUNT=$((PASS_COUNT + 1))
    else
      FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    TEST_COUNT=$((TEST_COUNT + 1))
    
    # Try to parse with make -n if available
    if command -v make >/dev/null 2>&1; then
      if make -n -f "$makefile" 2>&1 | grep -q "No targets"; then
        echo -e "${GREEN}  ✓ PASS:${NC} Makefile parses without errors"
        PASS_COUNT=$((PASS_COUNT + 1))
        TEST_COUNT=$((TEST_COUNT + 1))
      fi
    fi
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Makefile does not exist yet"
  fi
}

# =============================================================================
# Run all tests
# =============================================================================

test_valid_prd_json
test_invalid_prd_json
test_actual_prd_json
test_prd_story_structure
echo ""

test_docker_compose_yaml
echo ""

test_github_workflow_yaml
echo ""

test_makefile_syntax
echo ""

# Print summary and exit
print_test_summary
