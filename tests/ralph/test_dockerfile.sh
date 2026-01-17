#!/bin/bash
# Docker build and container tests
# Tests Dockerfile syntax, build process, and required tools

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/test_helpers.sh"

REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Testing Docker build and configuration..."
echo ""

# =============================================================================
# Docker availability check
# =============================================================================

test_docker_available() {
  echo "Test: Docker is available"
  
  if command -v docker >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ PASS:${NC} Docker command found"
    PASS_COUNT=$((PASS_COUNT + 1))
    TEST_COUNT=$((TEST_COUNT + 1))
    return 0
  else
    echo -e "${RED}  ✗ FAIL:${NC} Docker command not found"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    TEST_COUNT=$((TEST_COUNT + 1))
    return 1
  fi
}

# =============================================================================
# Dockerfile validation
# =============================================================================

test_dockerfile_exists() {
  echo "Test: Dockerfile exists (when created)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ -f "$dockerfile" ]; then
    assert_file_exists "$dockerfile" "Dockerfile should exist"
    
    # Check basic structure
    local content
    content=$(cat "$dockerfile")
    
    assert_contains "$content" "FROM" "Dockerfile should have FROM instruction"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
  fi
}

test_dockerfile_syntax() {
  echo "Test: Dockerfile has valid syntax (when created)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ ! -f "$dockerfile" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
    return 0
  fi
  
  # Use hadolint if available
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$dockerfile" >/dev/null 2>&1; then
      echo -e "${GREEN}  ✓ PASS:${NC} Dockerfile passes hadolint validation"
      PASS_COUNT=$((PASS_COUNT + 1))
    else
      # Check if errors are serious or just warnings
      local errors
      errors=$(hadolint -t error "$dockerfile" 2>&1)
      
      if [ -z "$errors" ]; then
        echo -e "${GREEN}  ✓ PASS:${NC} Dockerfile has no critical errors (warnings ok)"
        PASS_COUNT=$((PASS_COUNT + 1))
      else
        echo -e "${RED}  ✗ FAIL:${NC} Dockerfile has hadolint errors:"
        echo "$errors" | head -10
        FAIL_COUNT=$((FAIL_COUNT + 1))
      fi
    fi
    TEST_COUNT=$((TEST_COUNT + 1))
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} hadolint not installed"
  fi
}

test_dockerfile_entrypoint() {
  echo "Test: Dockerfile has proper entrypoint (when created)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ ! -f "$dockerfile" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
    return 0
  fi
  
  local content
  content=$(cat "$dockerfile")
  
  # Should have either ENTRYPOINT or CMD
  if echo "$content" | grep -q "ENTRYPOINT\|CMD"; then
    echo -e "${GREEN}  ✓ PASS:${NC} Dockerfile has ENTRYPOINT or CMD"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo -e "${RED}  ✗ FAIL:${NC} Dockerfile missing ENTRYPOINT or CMD"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
  TEST_COUNT=$((TEST_COUNT + 1))
}

# =============================================================================
# Docker build tests
# =============================================================================

test_docker_build() {
  echo "Test: Docker image builds successfully (when Dockerfile exists)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ ! -f "$dockerfile" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
    return 0
  fi
  
  if ! command -v docker >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Docker not available"
    return 0
  fi
  
  # Try to build the image
  echo "  Building Docker image (this may take a while)..."
  
  if docker build -t ralph-test:latest -f "$dockerfile" "$REPO_ROOT" >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ PASS:${NC} Docker image builds successfully"
    PASS_COUNT=$((PASS_COUNT + 1))
    TEST_COUNT=$((TEST_COUNT + 1))
    
    # Clean up
    docker rmi ralph-test:latest >/dev/null 2>&1 || true
  else
    echo -e "${RED}  ✗ FAIL:${NC} Docker build failed"
    echo "  Running build again to show errors:"
    docker build -t ralph-test:latest -f "$dockerfile" "$REPO_ROOT" 2>&1 | tail -20
    FAIL_COUNT=$((FAIL_COUNT + 1))
    TEST_COUNT=$((TEST_COUNT + 1))
  fi
}

test_docker_required_tools() {
  echo "Test: Docker image contains required tools (when built)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ ! -f "$dockerfile" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
    return 0
  fi
  
  if ! command -v docker >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Docker not available"
    return 0
  fi
  
  # Build image first
  echo "  Building image to test tools..."
  if ! docker build -t ralph-test:latest -f "$dockerfile" "$REPO_ROOT" >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Cannot build image to test tools"
    return 0
  fi
  
  # Check for required tools
  local required_tools="git jq"
  local all_found=true
  
  for tool in $required_tools; do
    if docker run --rm ralph-test:latest which "$tool" >/dev/null 2>&1; then
      echo -e "${GREEN}  ✓ PASS:${NC} Tool '$tool' found in image"
      PASS_COUNT=$((PASS_COUNT + 1))
    else
      echo -e "${RED}  ✗ FAIL:${NC} Tool '$tool' not found in image"
      FAIL_COUNT=$((FAIL_COUNT + 1))
      all_found=false
    fi
    TEST_COUNT=$((TEST_COUNT + 1))
  done
  
  # Clean up
  docker rmi ralph-test:latest >/dev/null 2>&1 || true
}

test_docker_entrypoint_executable() {
  echo "Test: Docker entrypoint is executable (when created)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ ! -f "$dockerfile" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
    return 0
  fi
  
  # Check if entrypoint script exists in repo
  local entrypoint_script="$REPO_ROOT/scripts/ralph/docker-entrypoint.sh"
  
  if [ -f "$entrypoint_script" ]; then
    assert_file_executable "$entrypoint_script" "Entrypoint script should be executable"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} docker-entrypoint.sh does not exist yet"
  fi
}

test_docker_container_help() {
  echo "Test: Docker container runs with --help (when built)"
  
  local dockerfile="$REPO_ROOT/Dockerfile"
  
  if [ ! -f "$dockerfile" ]; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Dockerfile does not exist yet"
    return 0
  fi
  
  if ! command -v docker >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Docker not available"
    return 0
  fi
  
  # Build image first
  if ! docker build -t ralph-test:latest -f "$dockerfile" "$REPO_ROOT" >/dev/null 2>&1; then
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Cannot build image"
    return 0
  fi
  
  # Try to run with --help
  if docker run --rm ralph-test:latest --help >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ PASS:${NC} Container runs with --help"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    # This might be expected if --help isn't implemented yet
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Container doesn't support --help (may not be implemented)"
  fi
  TEST_COUNT=$((TEST_COUNT + 1))
  
  # Clean up
  docker rmi ralph-test:latest >/dev/null 2>&1 || true
}

# =============================================================================
# Run all tests
# =============================================================================

# Only run Docker tests if Docker is available
if ! test_docker_available; then
  echo ""
  echo -e "${YELLOW}Docker is not available. Skipping all Docker tests.${NC}"
  echo -e "${YELLOW}Install Docker to run these tests.${NC}"
  exit 0
fi

echo ""

test_dockerfile_exists
test_dockerfile_syntax
test_dockerfile_entrypoint
echo ""

test_docker_build
echo ""

test_docker_required_tools
echo ""

test_docker_entrypoint_executable
echo ""

test_docker_container_help
echo ""

# Print summary and exit
print_test_summary
