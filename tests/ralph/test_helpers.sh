#!/bin/bash
# Common test helper functions and assertions
# Compatible with bash 3.2+ (macOS and Linux)

# Test counters
TEST_COUNT=0
PASS_COUNT=0
FAIL_COUNT=0

# Colors for output
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  NC=''
fi

# Assert that two values are equal
assert_equals() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Equality check}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ "$expected" = "$actual" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    echo -e "${RED}    Expected: '$expected'${NC}"
    echo -e "${RED}    Actual:   '$actual'${NC}"
    return 1
  fi
}

# Assert that a value is not empty
assert_not_empty() {
  local value="$1"
  local message="${2:-Value should not be empty}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ -n "$value" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message (value is empty)"
    return 1
  fi
}

# Assert that a file exists
assert_file_exists() {
  local filepath="$1"
  local message="${2:-File should exist: $filepath}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ -f "$filepath" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    return 1
  fi
}

# Assert that a file does not exist
assert_file_not_exists() {
  local filepath="$1"
  local message="${2:-File should not exist: $filepath}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ ! -f "$filepath" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    return 1
  fi
}

# Assert that a directory exists
assert_dir_exists() {
  local dirpath="$1"
  local message="${2:-Directory should exist: $dirpath}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ -d "$dirpath" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    return 1
  fi
}

# Assert that a file is executable
assert_file_executable() {
  local filepath="$1"
  local message="${2:-File should be executable: $filepath}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if [ -x "$filepath" ]; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    return 1
  fi
}

# Assert that a command succeeds
assert_command_succeeds() {
  local message="$1"
  shift
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if "$@" >/dev/null 2>&1; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    echo -e "${RED}    Command: $*${NC}"
    return 1
  fi
}

# Assert that a command fails
assert_command_fails() {
  local message="$1"
  shift
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if "$@" >/dev/null 2>&1; then
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message (command succeeded but should have failed)"
    echo -e "${RED}    Command: $*${NC}"
    return 1
  else
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  fi
}

# Assert that a string contains a substring
assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="${3:-String should contain: $needle}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  # Bash 3.2 compatible substring check
  if echo "$haystack" | grep -q "$needle"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    echo -e "${RED}    Haystack: '$haystack'${NC}"
    echo -e "${RED}    Needle:   '$needle'${NC}"
    return 1
  fi
}

# Assert that a string matches a pattern
assert_matches() {
  local text="$1"
  local pattern="$2"
  local message="${3:-String should match pattern: $pattern}"
  
  TEST_COUNT=$((TEST_COUNT + 1))
  
  if echo "$text" | grep -q "$pattern"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "${GREEN}  ✓ PASS:${NC} $message"
    return 0
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "${RED}  ✗ FAIL:${NC} $message"
    echo -e "${RED}    Text:    '$text'${NC}"
    echo -e "${RED}    Pattern: '$pattern'${NC}"
    return 1
  fi
}

# Print test results summary
print_test_summary() {
  echo ""
  echo "----------------------------------------"
  echo "Test Results:"
  echo "  Total:  $TEST_COUNT"
  echo -e "  ${GREEN}Passed: $PASS_COUNT${NC}"
  if [ $FAIL_COUNT -gt 0 ]; then
    echo -e "  ${RED}Failed: $FAIL_COUNT${NC}"
  else
    echo -e "  Failed: $FAIL_COUNT"
  fi
  echo "----------------------------------------"
  
  if [ $FAIL_COUNT -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

# Setup a temporary test directory
setup_test_dir() {
  local test_dir
  test_dir=$(mktemp -d -t ralph-test.XXXXXX)
  echo "$test_dir"
}

# Cleanup a test directory
cleanup_test_dir() {
  local test_dir="$1"
  if [ -d "$test_dir" ]; then
    rm -rf "$test_dir"
  fi
}
