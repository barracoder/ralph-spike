# Ralph Tooling Test Suite

Comprehensive test suite for Ralph Docker support and submodule setup tooling.

## Overview

This test suite validates:
- Shell script functionality and quality
- Docker configuration and builds
- Template validation (JSON, YAML, Makefiles)
- Integration and end-to-end workflows
- Cross-platform compatibility (Linux, macOS)
- Bash 3.2+ compatibility

## Test Files

### Test Scripts

| File | Purpose |
|------|---------|
| `run_tests.sh` | Main test runner - executes all test suites |
| `test_scripts.sh` | Unit tests for shell scripts (ralph.sh, ralph-copilot.sh, future Docker scripts) |
| `test_templates.sh` | Template validation (PRD JSON, docker-compose.yml, workflows) |
| `test_integration.sh` | End-to-end integration tests |
| `test_dockerfile.sh` | Docker build and container tests |
| `test_helpers.sh` | Common test assertion functions |

### Test Fixtures

| File | Purpose |
|------|---------|
| `fixtures/valid_prd.json` | Valid PRD template for testing |
| `fixtures/invalid_prd.json` | Invalid JSON for error handling tests |

## Running Tests

### Run All Tests

```bash
cd tests/ralph
./run_tests.sh
```

### Run Individual Test Suites

```bash
# Script tests
./test_scripts.sh

# Template validation
./test_templates.sh

# Integration tests
./test_integration.sh

# Docker tests (requires Docker)
./test_dockerfile.sh
```

## Test Coverage

### Shell Script Tests (`test_scripts.sh`)

**Existing Scripts:**
- ✅ ralph.sh exists and is executable
- ✅ ralph-copilot.sh exists and is executable
- ✅ Proper shebang (`#!/bin/bash`)
- ✅ Shellcheck validation (warnings acceptable, no errors)
- ✅ Bash 3.2 compatibility checks

**Future Scripts (tests ready when created):**
- ralph-docker.sh: Environment variable validation, agent type validation, Docker availability
- docker-entrypoint.sh: Environment variable handling, directory detection
- setup-submodule.sh: Directory validation, git initialization, idempotency

### Template Tests (`test_templates.sh`)

- ✅ Valid PRD JSON parsing
- ✅ Invalid PRD JSON detection
- ✅ PRD structure validation (branchName at root, stories array)
- ✅ Story field validation (id, title, description)
- ✅ GitHub Actions workflow YAML validation
- 🔄 docker-compose.yml validation (when created)
- 🔄 Makefile syntax validation (when created)

### Integration Tests (`test_integration.sh`)

- ✅ PRD validation workflow
- ✅ Ralph script invocation (dry run)
- ✅ File generation workflow
- ✅ Cross-platform compatibility
- ✅ Git repository detection and initialization
- ✅ Environment variable handling
- 🔄 setup-submodule.sh end-to-end test (when created)

### Docker Tests (`test_dockerfile.sh`)

- ✅ Docker availability check
- 🔄 Dockerfile syntax validation with hadolint (when created)
- 🔄 Docker image build success (when Dockerfile exists)
- 🔄 Required tools in image (git, jq, gh, dotnet, node) (when built)
- 🔄 Entrypoint executable check (when created)
- 🔄 Container runs with --help (when implemented)

## Test Assertions

The test suite uses custom assertion functions for portability:

```bash
assert_equals expected actual "message"
assert_not_empty value "message"
assert_file_exists path "message"
assert_file_not_exists path "message"
assert_dir_exists path "message"
assert_file_executable path "message"
assert_command_succeeds "message" command args...
assert_command_fails "message" command args...
assert_contains haystack needle "message"
assert_matches text pattern "message"
```

## Requirements

### Minimal Requirements
- Bash 3.2+ (compatible with macOS and Linux)
- Standard Unix utilities (grep, sed, awk, etc.)

### Recommended for Full Coverage
- `jq` - JSON parsing and validation
- `shellcheck` - Shell script linting
- `hadolint` - Dockerfile linting
- `docker` - Docker build and container tests
- `docker-compose` or `docker compose` - docker-compose.yml validation

### Installing Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install -y jq shellcheck docker.io
```

**macOS:**
```bash
brew install jq shellcheck docker
```

**hadolint:**
```bash
# Linux
wget -O /tmp/hadolint https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
chmod +x /tmp/hadolint
sudo mv /tmp/hadolint /usr/local/bin/hadolint

# macOS
brew install hadolint
```

## CI/CD Integration

Tests run automatically on GitHub Actions when:
- Pushing to `main` or `master` branches
- Opening pull requests
- Changes to `scripts/ralph/**`, `tests/ralph/**`, `Dockerfile`, or workflows

See `.github/workflows/test-ralph-tooling.yml` for the complete CI configuration.

## Compatibility

### Bash 3.2 Compatibility

All scripts are compatible with Bash 3.2+ (default on macOS). The following modern Bash features are **avoided**:

- ❌ `${var,,}` lowercase syntax (use `tr` or `awk` instead)
- ❌ Associative arrays (use indexed arrays or separate variables)
- ❌ `|&` stderr redirect (use `2>&1 |` instead)
- ❌ Complex `[[ =~ ]]` regex patterns (use `grep` instead)

### Cross-Platform Testing

Tests run on both Linux (Ubuntu) and macOS in CI to ensure cross-platform compatibility.

## Exit Codes

- `0` - All tests passed
- `1` - One or more tests failed

## Color Output

Tests display colored output when running in a terminal:
- 🟢 Green: Passed tests
- 🔴 Red: Failed tests
- 🟡 Yellow: Skipped tests (missing dependencies or future features)

Color is automatically disabled when output is piped or redirected.

## Adding New Tests

1. Add test functions to the appropriate test file
2. Follow the naming convention: `test_descriptive_name()`
3. Use assertion functions from `test_helpers.sh`
4. Update this README with new test coverage
5. Ensure tests work without optional dependencies (graceful skip)

Example:
```bash
test_new_feature() {
  echo "Test: New feature description"
  
  if [ -f "$NEW_SCRIPT" ]; then
    assert_file_executable "$NEW_SCRIPT" "Script should be executable"
  else
    echo -e "${YELLOW}  ⚠ SKIP:${NC} Script does not exist yet"
  fi
}
```

## Future Enhancements

When Docker/submodule scripts are created, the existing tests will automatically validate:

1. **ralph-docker.sh** - Docker wrapper script
   - Environment variable validation (GITHUB_TOKEN, AMP_TOKEN)
   - Agent type validation (copilot/amp)
   - Default value handling

2. **docker-entrypoint.sh** - Container entrypoint
   - Environment variable to argument fallback
   - Ralph directory detection (submodule/root)

3. **setup-submodule.sh** - Submodule setup script
   - Target directory validation
   - Git initialization
   - Idempotency (safe to run multiple times)
   - File generation

## License

MIT
