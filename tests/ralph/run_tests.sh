#!/bin/bash
# Main test runner for Ralph tooling tests
# Detects available test frameworks and runs all test files

set -e

# Colors for output (compatible with both Linux and macOS)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Ralph Tooling Test Suite${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Detect available tools
SHELLCHECK_AVAILABLE=false
HADOLINT_AVAILABLE=false
BATS_AVAILABLE=false

if command -v shellcheck >/dev/null 2>&1; then
  SHELLCHECK_AVAILABLE=true
  echo -e "${GREEN}✓${NC} shellcheck detected"
else
  echo -e "${YELLOW}⚠${NC} shellcheck not found (shell script linting will be skipped)"
fi

if command -v hadolint >/dev/null 2>&1; then
  HADOLINT_AVAILABLE=true
  echo -e "${GREEN}✓${NC} hadolint detected"
else
  echo -e "${YELLOW}⚠${NC} hadolint not found (Dockerfile linting will be skipped)"
fi

if command -v bats >/dev/null 2>&1; then
  BATS_AVAILABLE=true
  echo -e "${GREEN}✓${NC} bats detected"
else
  echo -e "${YELLOW}⚠${NC} bats not found (using bash assertions)"
fi

echo ""

# Function to run a test file
run_test_file() {
  local test_file="$1"
  local test_name=$(basename "$test_file")
  
  echo -e "${BLUE}Running${NC} $test_name..."
  
  if bash "$test_file"; then
    echo -e "${GREEN}✓ PASSED${NC} $test_name"
    PASSED_TESTS=$((PASSED_TESTS + 1))
    return 0
  else
    echo -e "${RED}✗ FAILED${NC} $test_name"
    FAILED_TESTS=$((FAILED_TESTS + 1))
    return 1
  fi
}

# Run all test files
TEST_FILES=(
  "$SCRIPT_DIR/test_scripts.sh"
  "$SCRIPT_DIR/test_templates.sh"
  "$SCRIPT_DIR/test_integration.sh"
)

# Only run Docker tests if Docker is available
if command -v docker >/dev/null 2>&1; then
  TEST_FILES+=("$SCRIPT_DIR/test_dockerfile.sh")
else
  echo -e "${YELLOW}⚠${NC} Docker not found, skipping Docker tests"
fi

echo ""

for test_file in "${TEST_FILES[@]}"; do
  if [ -f "$test_file" ]; then
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    run_test_file "$test_file" || true
    echo ""
  fi
done

# Print summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Total test files: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
if [ $FAILED_TESTS -gt 0 ]; then
  echo -e "${RED}Failed: $FAILED_TESTS${NC}"
fi
echo ""

# Exit with appropriate code
if [ $FAILED_TESTS -eq 0 ]; then
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed.${NC}"
  exit 1
fi
